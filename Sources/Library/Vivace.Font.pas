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

unit Vivace.Font;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.External.Allegro,
  Vivace.Base,
  Vivace.Common,
  Vivace.Color,
  Vivace.Math;

type

  { TFont }
  TFont = class(TCommonObject)
  protected
    FHandle: PALLEGRO_FONT;
    FFilename: string;
    FPadding: TVector;
    procedure Default;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure LoadBuiltIn;

    procedure Load(aSize: Cardinal); overload;
    procedure Load(aSize: Cardinal; aFilename: string); overload;
    procedure Load(aSize: Cardinal; aMemory: Pointer; aLength: Int64); overload;

    procedure Unload;
    procedure Print(aX: Single; aY: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const); overload;
    procedure Print(aX: Single; var aY: Single; aLineSpace: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const); overload;
    procedure Print(aX: Single; aY: Single; aColor: TColor; aAngle: Single; const aMsg: string; const aArgs: array of const); overload;

    function  GetTextWidth(const aMsg: string; const aArgs: array of const): Single;
    function  GetLineHeight: Single;
  end;

implementation

{$R Vivace.Font.res}

uses
  System.IOUtils,
  WinApi.Windows,
  System.Classes,
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Logger;


{ TFont }
procedure TFont.Unload;
begin
  if FHandle <> nil then
  begin
    al_destroy_font(FHandle);
    FHandle := nil;
    if not FFilename.IsEmpty then
      TLogger.Log(etSuccess, 'Sucessfully unloaded font "%s"', [FFilename]);
    FFilename := '';
    FPadding.Assign(0,0);
  end;
end;

constructor TFont.Create;
begin
  inherited;

  FHandle := nil;
  FFilename := '';
  Unload;
  Default;
end;

destructor TFont.Destroy;
begin
  Unload;

  inherited;
end;

procedure TFont.Default;
begin
  Unload;
  LoadBuiltIn;
end;

procedure TFont.LoadBuiltIn;
begin
  Unload;
  FHandle := al_create_builtin_font;
  if FHandle <> nil then
    begin
      //FPadding.Assign(0, 3);
    end
  else
    TLogger.Log(etError, 'Failed to load builtin font', [])
end;

procedure TFont.Load(aSize: Cardinal);
var
  LResStream: TResourceStream;
begin
  if not ResourceExists('DEFAULTFONT') then Exit;
  LResStream := TResourceStream.Create(HInstance, 'DEFAULTFONT', RT_RCDATA);
  try
    Load(aSize, LResStream.Memory, LResStream.Size);
  finally
    FreeAndNil(LResStream);
  end;
end;

procedure TFont.Load(aSize: Cardinal; aFilename: string);
var
  LSize: Integer;
  LOk: Boolean;
begin
  if aFilename.IsEmpty then Exit;

  LSize := -aSize;

  // check if in archive
  LOk := gEngine.ArchiveFileExist(aFilename);
  if not LOk then
    // else check if exist on filesystem
    LOk := TFile.Exists(aFilename);

  if LOk then
    begin
      Unload;
      al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
      FHandle := al_load_font(PAnsiChar(AnsiString(aFilename)), LSize, 0);
      if FHandle <> nil then
        begin
          FFilename := aFilename;
          TLogger.Log(etSuccess, 'Successfully loaded font "%s"', [aFilename])
        end
      else
        begin
          TLogger.Log(etError, 'Failed to load font "%s"', [aFilename])
        end;
    end
  else
    begin
      TLogger.Log(etError, 'Font file "%s" was not found', [aFilename])
    end;
end;

procedure TFont.Load(aSize: Cardinal; aMemory: Pointer; aLength: Int64);
var
  LMemFile: PALLEGRO_FILE;
  LSize: Integer;
begin
  LMemFile := al_open_memfile(aMemory, aLength, 'rb');
  LSize := -aSize;
  if LMemFile <> nil then
    begin
      Unload;
      al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
      FHandle := al_load_ttf_font_f(LMemFile, '', LSize, 0);
      if FHandle = nil then
        TLogger.Log(etError, 'Failed to load font from memory', [])
    end
  else
    begin
      TLogger.Log(etError, 'Failed to access memory font', [])
    end;
end;

procedure TFont.Print(aX: Single; aY: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const);
var
  LUstr: PALLEGRO_USTR;
  LText: string;
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then  Exit;
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  al_draw_ustr(FHandle, LColor, aX, aY, Ord(aAlign) or ALLEGRO_ALIGN_INTEGER, LUstr);
  al_ustr_free(LUstr);
end;

procedure TFont.Print(aX: Single; var aY: Single; aLineSpace: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const);
begin
  Print(aX, aY, aColor, aAlign, aMsg, aArgs);
  aY := aY + GetLineHeight + aLineSpace;
end;

function TFont.GetTextWidth(const aMsg: string; const aArgs: array of const): Single;
var
  LUstr: PALLEGRO_USTR;
  LText: string;
begin
  Result := 0;
  if FHandle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then  Exit;
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  Result := al_get_ustr_width(FHandle, LUstr);
  al_ustr_free(LUstr);
end;

function TFont.GetLineHeight: Single;
begin
  if FHandle = nil then
    Result := 0
  else
    Result := al_get_font_line_height(FHandle) + FPadding.Y;
end;

procedure TFont.Print(aX: Single; aY: Single; aColor: TColor; aAngle: Single; const aMsg: string; const aArgs: array of const);
var
  LUstr: PALLEGRO_USTR;
  LText: string;
  LFX, LFY: Single;
  LTR: ALLEGRO_TRANSFORM;
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then Exit;
  LFX := GetTextWidth(LText, []) / 2;
  LFY := GetLineHeight / 2;
  al_identity_transform(@LTR);
  al_translate_transform(@LTR, -LFX, -LFY);
  al_rotate_transform(@LTR, aAngle * DEG2RAD);
  TMath.AngleRotatePos(aAngle, LFX, LFY);
  al_translate_transform(@LTR, aX + LFX, aY + LFY);
  al_compose_transform(@LTR, @gEngine.Display.Trans);
  al_use_transform(@LTR);
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  al_draw_ustr(FHandle, LColor, 0, 0, ALLEGRO_ALIGN_LEFT or ALLEGRO_ALIGN_INTEGER, LUstr);
  al_ustr_free(LUstr);
  al_use_transform(@gEngine.Display.Trans);
end;

end.
