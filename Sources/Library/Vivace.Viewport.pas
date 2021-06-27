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

unit Vivace.Viewport;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math,
  Vivace.Bitmap;

type

  { TViewport }
  TViewport = class(TBaseObject)
  protected
    FBitmap: TBitmap;
    FActive: Boolean;
    FPos: TRectangle;
    FHalf: TVector;
    FAngle: Single;
    FCenter: TVector;
    procedure Clean;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer);

    procedure SetActive(aActive: Boolean);
    function  GetActive: Boolean;

    procedure SetPosition(aX: Integer; aY: Integer);
    procedure GetSize(aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger);

    procedure SetAngle(aAngle: Single);
    function  GetAngle: Single;

    procedure Align(var aX: Single; var aY: Single); overload;
    procedure Align(var aPos: TVector); overload;

    class function CreateViewport(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer): TViewport;
  end;

implementation

uses
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Color;


{ TViewport }
procedure TViewport.Clean;
begin
  if FBitmap <> nil then
  begin
    if FActive then
    begin
      // this fixes the is issue where if the active viewport is destroyed
      // while active, then just pass nil to Display.SetViewport to restore
      // the fullscreen viewport instead
      gEngine.Display.SetViewport(nil);
    end;
    SetActive(False);
    FreeAndNil(FBitmap);
    FActive := FAlse;
    FBitmap := nil;
    FPos.X := 0;
    FPos.Y := 0;
    FPos.Width := 0;
    FPos.Height := 0;
    FAngle := 0;
  end;
end;

constructor TViewport.Create;
begin
  inherited;

  FBitmap := nil;
  FActive := False;
  FPos.X := 0;
  FPos.Y := 0;
  FPos.Width := 0;
  FPos.Height := 0;
  FAngle := 0;
  FCenter.X := 0.5;
  FCenter.Y := 0.5;
end;

destructor TViewport.Destroy;
begin
  Clean;

  inherited;
end;

procedure TViewport.Init(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer);
begin
  Clean;
  FActive := False;
  FBitmap := TBitmap.Create;
  if FBitmap <> nil then
  begin
    FBitmap.Allocate(aWidth, aHeight);
    FPos.X := aX;
    FPos.Y := aY;
    FPos.Width := aWidth;
    FPos.Height := aHeight;

    FHalf.X := aWidth/2;
    FHalf.Y := aHeight/2;
  end;
end;

procedure TViewport.SetActive(aActive: Boolean);
begin
  if FBitmap = nil then Exit;

  if aActive then
    begin
      if FActive then Exit;
      gEngine.Display.SetTarget(FBitmap);
    end
  else
    begin
      if not FActive then Exit;
      gEngine.Display.ResetTarget;
      FBitmap.Draw(FPos.X+FHalf.X, FPos.Y+FHalf.Y, nil, @FCenter, nil, FAngle, WHITE, False, False);
    end;

  FActive := aActive;
end;

function TViewport.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TViewport.SetPosition(aX: Integer; aY: Integer);
begin
  if FBitmap = nil then Exit;
  FPos.X := aX;
  FPos.Y := aY;
end;

procedure TViewport.GetSize(aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger);
begin
  if FBitmap = nil then Exit;

  if aX <> nil then
    aX^ := Round(FPos.X);
  if aY <>nil then
    aY^ := Round(FPos.Y);
  if aWidth <> nil then
    aWidth^ := Round(FPos.Width);
  if aHeight <> nil then
    aHeight^ := Round(FPos.Height);
end;

procedure TViewport.SetAngle(aAngle: Single);
begin
  FAngle := aAngle;
  //gEngine.Math.ClipValue(FAngle, 0, 359, True);
  if FAngle > 359 then
    begin
      while FAngle > 359 do
      begin
        FAngle := FAngle - 359;
      end;
    end
  else
  if FAngle < 0 then
    begin
      while FAngle < 0 do
      begin
        FAngle := FAngle + 359;
      end;
    end;
end;

function  TViewport.GetAngle: Single;
begin
  Result := FAngle;
end;

procedure TViewport.Align(var aX: Single; var aY: Single);
begin
  aX := FPos.X + aX;
  aY := FPos.Y + aY;
end;

procedure TViewport.Align(var aPos: TVector);
begin
  aPos.X := FPos.X + aPos.X;
  aPos.Y := FPos.Y + aPos.Y;
end;

class function TViewport.CreateViewport(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer): TViewport;
begin
  Result := TViewport.Create;
  Result.Init(aX, aY, aWidth, aHeight);
end;

end.
