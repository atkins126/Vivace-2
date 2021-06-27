{==============================================================================
         _       ve'va'CHe
  __   _(_)_   ____ _  ___ ___ ™
  \ \ / / \ \ / / _` |/ __/ _ \
   \ V /| |\ V / (_| | (_|  __/
    \_/ |_| \_/ \__,_|\___\___|
                   Game Toolkit

  Copyright © 2020-21 tinyBigGAMES™ LLC
  All rights reserved.

  Website: https://tinybiggames.com
  Email  : support@tinybiggames.com

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software in
     a product, an acknowledgment in the product documentation would be
     appreciated but is not required.

  2. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

  3. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.

  4. Neither the name of the copyright holder nor the names of its
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

  5. All video, audio, graphics and other content accessed through the
     software in this distro is the property of the applicable content owner
     and may be protected by applicable copyright law. This License gives
     Customer no rights to such content, and Company disclaims any liability
     for misuse of content.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
  COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
  OF THE POSSIBILITY OF SUCH DAMAGE.
============================================================================== }

unit Vivace.Bitmap;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math,
  Vivace.Color;

type
  { TBitmapData }
  PBitmapData = ^TBitmapData;
  TBitmapData = record
    Memory: Pointer;
    Format: Integer;
    Pitch: Integer;
    PixelSize: Integer;
  end;

  { TBitmap }
  TBitmap = class(TCommonObject)
  protected
    FWidth: Single;
    FHeight: Single;
    FLocked: Boolean;
    FLockedRegion: TRectangle;
    FFilename: string;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Allocate(aWidth: Integer; aHeight: Integer);
    procedure Load(aFilename: string; aColorKey: PColor);
    procedure Unload;

    procedure GetSize(var aSize: TVector); overload;
    procedure GetSize(aWidth: PSingle; aHeight: PSingle); overload;

    procedure Lock(aRegion: PRectangle; var aData: TBitmapData);
    procedure Unlock;

    function  GetPixel(aX: Integer; aY: Integer): TColor;

    procedure Draw(aX, aY: Single; aRegion: PRectangle; aCenter: PVector;  aScale: PVector; aAngle: Single; aColor: TColor; aHFlip: Boolean; aVFlip: Boolean); overload;
    procedure Draw(aX, aY, aScale, aAngle: Single; aColor: TColor; aHAlign: THAlign; aVAlign: TVAlign; aHFlip: Boolean=False; aVFlip: Boolean=False); overload;
    procedure DrawTiled(aDeltaX: Single; aDeltaY: Single);

    class function LoadBitmap(aFilename: string; aColorKey: PColor): TBitmap; inline;
  end;

implementation

uses
  System.IOUtils,
  System.Math,
  Vivace.External.Allegro,
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Logger;


{ TBitmap }
constructor TBitmap.Create;
begin
  inherited;

  FHandle.Bitmap := nil;
  Unload;
end;

destructor TBitmap.Destroy;
begin
  Unload;

  inherited;
end;

procedure TBitmap.Allocate(aWidth: Integer; aHeight: Integer);
begin
  Unload;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  FHandle.Bitmap := al_create_bitmap(aWidth, aHeight);
  if FHandle.Bitmap <> nil then
    begin
      FWidth := al_get_bitmap_width(FHandle.Bitmap);
      FHeight := al_get_bitmap_height(FHandle.Bitmap);
      FFilename := '';
      TLogger.Log(etSuccess, 'Successfully allocated (%d x %d) bitmap', [aWidth, aHeight]);
    end
  else
    begin
      TLogger.Log(etSuccess, 'Failed to allocate (%d x %d) bitmap', [aWidth, aHeight]);
    end;
end;

procedure TBitmap.Load(aFilename: string; aColorKey: PColor);
var
  LColorKey: PALLEGRO_COLOR absolute aColorKey;
  LOk: Boolean;
begin
  if aFilename.IsEmpty then Exit;

  // check if in archive
  LOk := gEngine.ArchiveFileExist(aFilename);
  if not LOk then
    // else check if exist on filesystem
    LOk := TFile.Exists(aFilename);

  if LOk then
  begin
    Unload;

    al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_VIDEO_BITMAP);

    FHandle.Bitmap := al_load_bitmap(PAnsiChar(AnsiString(aFilename)));
    if FHandle.Bitmap <> nil then
      begin
        FWidth := al_get_bitmap_width(FHandle.Bitmap);
        FHeight := al_get_bitmap_height(FHandle.Bitmap);

        // apply colorkey
        if aColorKey <> nil then
        begin
          al_convert_mask_to_alpha(FHandle.Bitmap, LColorKey^)
        end;

        FFilename := aFilename;
        TLogger.Log(etSuccess, 'Successfully loaded bitmap "%s"', [aFilename]);
      end
    else
      begin
        TLogger.Log(etError, 'Failed to load bitmap "%s"', [aFilename]);
      end;
  end;
end;

procedure TBitmap.Unload;
begin
  if FHandle.Bitmap <> nil then
  begin
    al_destroy_bitmap(FHandle.Bitmap);
    FHandle.Bitmap := nil;
    if not FFilename.IsEmpty then
      TLogger.Log(etInfo, 'Unloaded bitmap "%s"', [FFilename])
    else
      TLogger.Log(etInfo, 'Unloaded (%f x %f) bitmap', [FWidth, FHeight]);
    FFilename := ''
  end;
  FWidth := 0;
  FHeight := 0;
  FLocked := False;
  FLockedRegion.X := 0;
  FLockedRegion.Y := 0;
  FLockedRegion.Width := 0;
  FLockedRegion.Height := 0;
end;

procedure TBitmap.GetSize(var aSize: TVector);
begin
  aSize.X := FWidth;
  aSize.Y := FHeight;
end;

procedure TBitmap.GetSize(aWidth: PSingle; aHeight: PSingle);
begin
  if aWidth <> nil then aWidth^ := FWidth;
  if aHeight <> nil then aHeight^ := FHeight;
end;

procedure TBitmap.Lock(aRegion: PRectangle; var aData: TBitmapData);
var
  LLock: PALLEGRO_LOCKED_REGION;
begin
  if FHandle.Bitmap = nil then Exit;

  LLock := nil;

  if not FLocked then
  begin
    if aRegion <> nil then
      begin
        LLock := al_lock_bitmap_region(FHandle.Bitmap, Round(aRegion.X),
          Round(aRegion.Y), Round(aRegion.Width), Round(aRegion.Height),
          ALLEGRO_PIXEL_FORMAT_ANY,
          ALLEGRO_LOCK_READWRITE);
        FLockedRegion.X := aRegion.X;
        FLockedRegion.Y := aRegion.Y;
        FLockedRegion.Width := aRegion.Width;
        FLockedRegion.Height := aRegion.Height;
      end
    else
      begin
        LLock := al_lock_bitmap(FHandle.Bitmap, ALLEGRO_PIXEL_FORMAT_ANY,
          ALLEGRO_LOCK_READWRITE);
        FLockedRegion.X := 0;
        FLockedRegion.Y := 0;
        FLockedRegion.Width := FWidth;
        FLockedRegion.Height := FHeight;
      end;
    FLocked := True;
  end;

  if LLock <> nil then
  begin
    aData.Memory := LLock.data;
    aData.Format := LLock.format;
    aData.Pitch := LLock.pitch;
    aData.PixelSize := LLock.pixel_size;
  end;
end;

procedure TBitmap.Unlock;
begin
  if FHandle.Bitmap = nil then Exit;
  if FLocked then
  begin
    al_unlock_bitmap(FHandle.Bitmap);
    FLocked := False;
    FLockedRegion.X := 0;
    FLockedRegion.Y := 0;
    FLockedRegion.Width := 0;
    FLockedRegion.Height := 0;
  end;
end;

function TBitmap.GetPixel(aX: Integer; aY: Integer): TColor;
var
  LX,LY: Integer;
  LResult: ALLEGRO_COLOR absolute Result;
begin
  if FHandle.Bitmap = nil then Exit;

  LX := Round(aX + FLockedRegion.X);
  LY := Round(aY + FlockedRegion.Y);
  LResult := al_get_pixel(FHandle.Bitmap, LX, LY);
end;

procedure TBitmap.Draw(aX, aY: Single; aRegion: PRectangle; aCenter: PVector; aScale: PVector; aAngle: Single; aColor: TColor; aHFlip: Boolean; aVFlip: Boolean);
var
  LA: Single;
  LRG: TRectangle;
  LCP: TVector;
  LSC: TVector;
  LC: ALLEGRO_COLOR absolute aColor;
  LFlags: Integer;
begin
  if FHandle.Bitmap = nil then Exit;

  // angle
  LA := aAngle * DEG2RAD;

  // region
  if Assigned(aRegion) then
    begin
      LRG.X := aRegion.X;
      LRG.Y := aRegion.Y;
      LRG.Width := aRegion.Width;
      LRG.Height := aRegion.Height;
    end
  else
    begin
      LRG.X := 0;
      LRG.Y := 0;
      LRG.Width := FWidth;
      LRG.Height := FHeight;
    end;

  if LRG.X < 0 then
    LRG.X := 0;
  if LRG.X > FWidth - 1 then
    LRG.X := FWidth - 1;

  if LRG.Y < 0 then
    LRG.Y := 0;
  if LRG.Y > FHeight - 1 then
    LRG.Y := FHeight - 1;

  if LRG.Width < 0 then
    LRG.Width := 0;
  if LRG.Width > FWidth then
    LRG.Width := LRG.Width;

  if LRG.Height < 0 then
    LRG.Height := 0;
  if LRG.Height > FHeight then
    LRG.Height := LRG.Height;

  // center
  if Assigned(aCenter) then
    begin
      LCP.X := (LRG.Width * aCenter.X);
      LCP.Y := (LRG.Height * aCenter.Y);
    end
  else
    begin
      LCP.X := 0;
      LCP.Y := 0;
    end;

  // scale
  if Assigned(aScale) then
    begin
      LSC.X := aScale.X;
      LSC.Y := aScale.Y;
    end
  else
    begin
      LSC.X := 1;
      LSC.Y := 1;
    end;

  // flags
  LFlags := 0;
  if aHFlip then LFlags := LFlags or ALLEGRO_FLIP_HORIZONTAL;
  if aVFlip then LFlags := LFlags or ALLEGRO_FLIP_VERTICAL;

  // render
  al_draw_tinted_scaled_rotated_bitmap_region(FHandle.Bitmap, LRG.X, LRG.Y, LRG.Width, LRG.Height, LC, LCP.X, LCP.Y, aX, aY, LSC.X, LSC.Y, LA, LFlags);
end;

procedure TBitmap.Draw(aX, aY, aScale, aAngle: Single; aColor: TColor; aHAlign: THAlign; aVAlign: TVAlign; aHFlip: Boolean=False; aVFlip: Boolean=False);
var
  LCenter: TVector;
  LScale: TVector;
begin
  LCenter.X := 0;
  LCenter.Y := 0;

  LScale.X := aScale;
  LScale.Y := aScale;

  case aHAlign of
    haLeft  : LCenter.X := 0;
    haCenter: LCenter.X := 0.5;
    haRight : LCenter.X := 1;
  end;

  case aVAlign of
    vaTop   : LCenter.Y := 0;
    vaCenter: LCenter.Y := 0.5;
    vaBottom: LCenter.Y := 1;
  end;

  Draw(aX, aY, nil, @LCenter, @LScale, aAngle, aColor, aHFlip, aVFlip);
end;


procedure TBitmap.DrawTiled(aDeltaX: Single; aDeltaY: Single);
var
  LW,LH    : Integer;
  LOX,LOY  : Integer;
  LPX,LPY  : Single;
  LFX,LFY  : Single;
  LTX,LTY  : Integer;
  LVPW,LVPH: Integer;
  LVR,LVB  : Integer;
  LIX,LIY  : Integer;
begin
  gEngine.Display.GetViewportSize(nil, nil, @LVPW, @LVPH);

  LW := Round(FWidth);
  LH := Round(FHeight);

  LOX := -LW+1;
  LOY := -LH+1;

  LPX := aDeltaX;
  LPY := aDeltaY;

  LFX := LPX-floor(LPX);
  LFY := LPY-floor(LPY);

  LTX := floor(LPX)-LOX;
  LTY := floor(LPY)-LOY;

  if (LTX>=0) then LTX := LTX mod LW + LOX else LTX := LW - -LTX mod LW + LOX;
  if (LTY>=0) then LTY := LTY mod LH + LOY else LTY := LH - -LTY mod LH + LOY;

  LVR := LVPW;
  LVB := LVPH;
  LIY := LTY;

  while LIY<LVB do
  begin
    LIX := LTX;
    while LIX<LVR do
    begin
      al_draw_bitmap(FHandle.Bitmap, LIX+LFX, LIY+LFY, 0);
      LIX := LIX+LW;
    end;
   LIY := LIY+LH;
  end;
end;

class function TBitmap.LoadBitmap(aFilename: string; aColorKey: PColor): TBitmap;
begin
  Result := TBitmap.Create;
  Result.Load(aFilename, aColorKey);
end;

end.
