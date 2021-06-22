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

unit Vivace.Display;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  VCL.Graphics,
  Vivace.External.Allegro,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math,
  Vivace.Viewport,
  Vivace.Color,
  Vivace.Bitmap;

const
  DISPLAY_DEFAULT_DPI = 96;

  BLEND_ZERO = 0;
  BLEND_ONE = 1;
  BLEND_ALPHA = 2;
  BLEND_INVERSE_ALPHA = 3;
  BLEND_SRC_COLOR = 4;
  BLEND_DEST_COLOR = 5;
  BLEND_INVERSE_SRC_COLOR = 6;
  BLEND_INVERSE_DEST_COLOR = 7;
  BLEND_CONST_COLOR = 8;
  BLEND_INVERSE_CONST_COLOR = 9;
  BLEND_ADD = 0;
  BLEND_SRC_MINUS_DEST = 1;
  BLEND_DEST_MINUS_SRC = 2;

type

  { TBlendMode }
  TBlendMode = (bmPreMultipliedAlpha, bmNonPreMultipliedAlpha, bmAdditiveAlpha, bmCopySrcToDest, bmMultiplySrcAndDest);

  { TBlendModeColor }
  TBlendModeColor = (bcColorNormal, bcColorAvgSrcDest);


  { TDisplay }
  TDisplay = class(TCommonObject)
  protected
    FSize: TVector;
    FTransScale: Single;
    FTransSize: TRectangle;
    FTrans: ALLEGRO_TRANSFORM;
    FBlackbar: array[ 0..3 ] of TRectangle;
    FFullscreen: Boolean;
    FReady: Boolean;
    FViewport: TViewport;
    function TransformScale(aFullscreen: Boolean): Single;
    procedure ResizeForDPI;
    procedure FixupWindow;
    procedure LoadDefaultIcon;
    procedure Clearblackbars;
  public
    property Fullscreen: Boolean read FFullscreen;
    property Ready: Boolean read FReady write FReady;
    property TransSize: TRectangle read FTransSize;
    property TransScale: Single read FTransScale;
    property Trans: ALLEGRO_TRANSFORM read FTrans;

    constructor Create; override;
    destructor Destroy; override;

    function  Open(aWidth: Integer; aHeight: Integer; aFullscreen: Boolean; aTitle: string): Boolean;
    function  Close: Boolean;
    function  Opened: Boolean;

    procedure SetPosition(aX: Integer; aY: Integer);

    procedure Clear(aColor: Vivace.Color.TColor);

    procedure Show;
    procedure ToggleFullscreen;

    procedure ResetTransform;
    procedure SetTransformPosition(aX: Integer; aY: Integer);
    procedure SetTransformAngle(aAngle: Single);

    procedure GetSize(aWidth: PInteger; aHeight: PInteger; aAspectRatio: PSingle=nil);

    procedure SetTarget(aBitmap: Vivace.Bitmap.TBitmap);
    procedure ResetTarget;

    procedure AlignToViewport(var aX: Single; var aY: Single);
    procedure SetViewport(aViewport: TViewport);
    procedure GetViewportSize(aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger); overload;
    procedure GetViewportSize(var aSize: TRectangle); overload;
    procedure ResetViewport;

    procedure DrawLine(aX1, aY1, aX2, aY2: Single; aColor: TColor; aThickness: Single);
    procedure DrawRectangle(aX, aY, aWidth, aHeight, aThickness: Single; aColor: TColor);
    procedure DrawFilledRectangle(aX, aY, aWidth, aHeight: Single; aColor: TColor);
    procedure DrawCircle(aX, aY, aRadius, aThickness: Single;  aColor: TColor);
    procedure DrawFilledCircle(aX, aY, aRadius: Single; aColor: TColor);
    procedure DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer; aThickness: Single; aColor: TColor);
    procedure DrawFilledPolygon(aVertices: System.PSingle; aVertexCount: Integer; aColor: TColor);
    procedure DrawTriangle(aX1, aY1, aX2, aY2, aX3, aY3, aThickness: Single; aColor: TColor);
    procedure DrawFilledTriangle(aX1, aY1, aX2, aY2, aX3, aY3: Single; aColor: TColor);

    procedure SetBlender(aOperation: Integer; aSource: Integer; aDestination: Integer);
    procedure GetBlender(aOperation: PInteger; aSource: PInteger; aDestination: PInteger);
    procedure SetBlendColor(aColor: TColor);
    function  GetBlendColor: TColor;
    procedure SetBlendMode(aMode: TBlendMode);
    procedure SetBlendModeColor(aMode: TBlendModeColor; aColor: TColor);
    procedure RestoreDefaultBlendMode;

    procedure Save(aFilename: string);

    procedure GetTransInfo(var aSize: TRectangle; var aScale: Single);
    procedure GetMonitorSize(var aSize: TVector);

    function  GetMemorySize: UInt64;

  end;


implementation

uses
  System.Math,
  System.IOUtils,
  VCL.Forms,
  WinApi.Windows,
  WinApi.Messages,
  WinAPI.Direct3D9,
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Logger;

{ TDisplay }
procedure TDisplay.ResizeForDPI;
begin
  var LDpi: Integer := GetDpiForWindow(al_get_win_window_handle(FHandle.Display));
  var LSX,LSY: Integer;
  LSX := MulDiv(Round(FSize.X), LDPI, DISPLAY_DEFAULT_DPI);
  LSY := MulDiv(Round(FSize.Y), LDpi, DISPLAY_DEFAULT_DPI);

  var LWH: HWND := al_get_win_window_handle(FHandle.Display);
  var LWX,LWY,LHW,LHH: integer;
  al_get_window_position(FHandle.Display, @LWX, @LWY);

  LHW := (LSX - Round(FSize.X)) div 2;
  LHH := (LSY - Round(FSize.Y)) div 2;

  al_set_window_position(FHandle.Display, LWX-LHW, LWY-LHH);
  al_resize_display(FHandle.Display, LSX, LSY);

  var LScale: Single := min(LSX / FSize.x, LSY / FSize.Y);
  al_set_clipping_rectangle(0, 0, LSX, LSY);
  FTransSize.X := 0;
  FTransSize.Y := 0;
  FTransSize.Width := LSX;
  FTransSize.Height := LSY;
  FTransScale := LScale;
  al_build_transform(@FTrans, 0, 0, LScale, LScale, 0);
  al_use_transform(@FTrans);

  SetWindowLong(LWH, GWL_STYLE, GetWindowLong(LWH, GWL_STYLE) and (not WS_SIZEBOX));
  FixupWindow;
end;

procedure TDisplay.FixupWindow;
begin
  var LWW: Integer := al_get_display_width(FHandle.Display);
  var LWH: Integer := al_get_display_height(FHandle.Display);
  al_resize_display(FHandle.Display, LWW+1, LWH+1);
  al_resize_display(FHandle.Display, LWW, LWH);
end;

function TDisplay.TransformScale(aFullscreen: Boolean): Single;
var
  LScreenX, LScreenY: Integer;
  LScaleX, LScaleY: Single;
  LClipX, LClipY: Single;
  LScale: Single;
begin
  Result := 1;
  if FHandle.Display = nil then Exit;

  LScreenX := al_get_display_width(FHandle.Display);
  LScreenY := al_get_display_height(FHandle.Display);

  if aFullscreen then
    begin
      LScaleX := LScreenX / FSize.X;
      LScaleY := LScreenY / FSize.Y;
      LScale := min(LScaleX, LScaleY);
      LClipX := (LScreenX - LScale * FSize.X) / 2;
      LClipY := (LScreenY - LScale * FSize.Y) / 2;
      al_build_transform(@FTrans, LClipX, LClipY, LScale, LScale, 0);
      al_use_transform(@FTrans);
      al_set_clipping_rectangle(Round(LClipX), Round(LClipY), Round(LScreenX - 2 * LClipX), Round(LScreenY - 2 * LClipY));
      FTransSize.X := LClipX;
      FTransSize.Y := LClipY;
      FTransSize.Width := LScreenX - 2 * LClipX;
      FTransSize.Height := LScreenY - 2 * LClipY;
      Result := LScale;
      FTransScale := LScale;

      // calc left blackbar
      FBlackbar[0].X := 0;
      FBlackbar[0].Y := 0;
      FBlackbar[0].Width := FTransSize.X;
      FBlackbar[0].Height := LScreenY;

      // calc right blackbar
      FBlackbar[1].X := FTransSize.X + FTransSize.Width;
      Fblackbar[1].Y := 0;
      FBlackbar[1].Width := LScreenX - FBlackbar[1].X;
      FBlackbar[1].Height := LScreenY;

      // calc top blackbar
      FBlackbar[2].X := FTransSize.X;
      FBlackbar[2].Y := 0;
      FBlackbar[2].Width := FTransSize.Width;
      FBlackbar[2].Height := FTransSize.Y;

      // calc bottom blackbar
      FBlackbar[3].X := FTransSize.X;
      FBlackbar[3].Y := FTransSize.Y+FTransSize.Height;
      FBlackbar[3].Width := FTransSize.Width;
      FBlackbar[3].Height := LScreenY - FBlackbar[3].Y;

    end
  else
    begin
      al_identity_transform(@FTrans);
      al_use_transform(@FTrans);
      al_set_clipping_rectangle(0, 0, Round(LScreenX), Round(LScreenY));
      FTransSize.X := 0;
      FTransSize.Y := 0;
      FTransSize.Width := LScreenX;
      FTransSize.Height := LScreenY;
      FTransScale := 1;
    end;
end;

procedure TDisplay.LoadDefaultIcon;
var
  LWnd: HWND;
  LHnd: THandle;
  LIco: TIcon;
begin
  if FHandle.Display = nil then Exit;
  LHnd := GetModuleHandle(nil);
  if LHnd <> 0 then
  begin
    if FindResource(LHnd, 'MAINICON', RT_GROUP_ICON) <> 0 then
    begin
      LIco := TIcon.Create;
      LIco.LoadFromResourceName(LHnd, 'MAINICON');
      LWnd := al_get_win_window_handle(FHandle.Display);
      SendMessage(LWnd, WM_SETICON, ICON_BIG, LIco.Handle);
      FreeAndNil(LIco);
    end;
  end;
end;

procedure TDisplay.ClearBlackbars;
var
  I: Integer;
  cx,cy,cw,ch: Integer;
begin
  if not FFullscreen then exit;
  al_get_clipping_rectangle(@cx, @cy, @cw, @ch);
  al_reset_clipping_rectangle;
  for I := 0 to 3 do
  begin
    al_set_clipping_rectangle(Round(FBlackbar[I].X), Round(FBlackbar[I].Y), Round(FBlackbar[I].Width), Round(FBlackbar[I].Height));
    Clear(BLACK);
  end;
  al_set_clipping_rectangle(cx, cy, cw, ch);
end;

constructor TDisplay.Create;
begin
  inherited;
  FHandle.Display := nil;
end;

destructor TDisplay.Destroy;
begin
  Close;
  inherited;
end;

function Clear_a_Bit(const aValue: Cardinal; const Bit: cardinal): Cardinal;
begin
  Result := aValue and not (1 shl Bit);
end;

function TDisplay.Open(aWidth: Integer; aHeight: Integer; aFullscreen: Boolean; aTitle: string): Boolean;
var
  LFlags: Integer;
begin
  Result := False;
  LFlags :=  ALLEGRO_DIRECT3D_INTERNAL or ALLEGRO_RESIZABLE;
  if aFullscreen then LFlags := LFlags or ALLEGRO_FULLSCREEN_WINDOW;
  al_set_new_display_option(ALLEGRO_COMPATIBLE_DISPLAY, 1, ALLEGRO_REQUIRE);
  al_set_new_display_option(ALLEGRO_VSYNC, 1, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_CAN_DRAW_INTO_BITMAP, 1, ALLEGRO_SUGGEST);
  al_set_new_window_title(PAnsiChar(AnsiString(aTitle)));
  al_set_new_display_flags(LFlags);
  al_set_new_display_option(ALLEGRO_SAMPLE_BUFFERS, 1, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_SAMPLES, 8, ALLEGRO_SUGGEST);
  gEngine.OnDisplayOpenBefore;

  FHandle.Display := al_create_display(aWidth, aHeight);
  if FHandle.Display <> nil then
  begin
    Clear(BLACK); Show;
    al_register_event_source(gEngine.Queue, al_get_display_event_source(FHandle.Display));
    LoadDefaultIcon;
    FSize.X := aWidth;
    FSize.Y := aHeight;
    TransformScale(aFullscreen);
    ResizeForDPI;
    Clear(BLACK); Show;
    FFullscreen := aFullscreen;
    FReady := True;
    Result := True;
    gEngine.OnDisplayOpenAfter;
    TLogger.Log(etSuccess, 'Succesfully initialized Display to %d x %d resolution', [aWidth, aHeight]);
  end
  else
  begin
    TLogger.Log(etError, 'Failed to initialize.', [aWidth, aHeight]);
  end;
end;

function TDisplay.Close: Boolean;
var
  LWH: HWND;
begin
  Result := False;
  if FHandle.Display <> nil then
  begin
    al_unregister_event_source(gEngine.Queue,
      al_get_display_event_source(FHandle.Display));

    // NOTE: hide window to prevent show default icon for a split second when
    // you have a custom icon set. It's annoying!!! Apparently, allegro restores
    // the defalt icon during destry.
    LWH := al_get_win_window_handle(FHandle.Display);
    ShowWindow(LWH, SW_HIDE);
    gEngine.OnDisplayCloseBefore;
    al_destroy_display(FHandle.Display);
    FHandle.Display := nil;
    Result := True;
    gEngine.OnDisplayCloseAfter;
    TLogger.Log(etInfo, 'Succesfully Closed Display', []);
  end;
end;

function TDisplay.Opened: Boolean;
begin
  Result := Boolean(FHandle.Display <> nil);
end;

procedure TDisplay.SetPosition(aX: Integer; aY: Integer);
begin
  if FHandle.Display = nil then Exit;
  al_set_window_position(FHandle.Display, aX, aY);
end;

procedure TDisplay.Clear(aColor: Vivace.Color.TColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_clear_to_color(color);
end;

procedure TDisplay.Show;
begin
  if FHandle.Display = nil then Exit;
  Clearblackbars;
  al_flip_display;
end;

procedure TDisplay.ToggleFullscreen;
var
  LFlags: Integer;
  LFullscreen: Boolean;
  LMX, LMY: Integer;

  function IsOnPrimaryMonitor: Boolean;
  begin
    Result := Screen.MonitorFromWindow(al_get_win_window_handle(FHandle.Display), mdPrimary).Primary
  end;

begin
  if FHandle.Display = nil then Exit;
  gEngine.Input.MouseGetInfo(@LMX, @LMY, nil);
  LFlags := al_get_display_flags(FHandle.Display);
  LFullscreen := Boolean(LFlags and ALLEGRO_FULLSCREEN_WINDOW = ALLEGRO_FULLSCREEN_WINDOW);
  LFullscreen := not LFullscreen;

  // we can only go fullscreen on primrary monitor
  if LFullscreen and (not IsOnPrimaryMonitor) then Exit;

  al_set_display_flag(FHandle.Display, ALLEGRO_FULLSCREEN_WINDOW, LFullscreen);
  TransformScale(LFullscreen);
  FFullscreen := LFullscreen;
  if not FFullscreen then ResizeForDPI;
  gEngine.Input.MouseSetPos(LMX, LMY);
  gEngine.OnDisplayToggleFullscreen(FFullscreen);
end;

procedure TDisplay.ResetTransform;
begin
  if FHandle.Display = nil then Exit;
  al_use_transform(@FTrans);
end;

procedure TDisplay.SetTransformPosition(aX: Integer; aY: Integer);
var
  LTrans: ALLEGRO_TRANSFORM;
begin
  if FHandle.Display = nil then Exit;
  al_copy_transform(@LTrans, al_get_current_transform);
  al_translate_transform(@LTrans, aX, aY);
  al_use_transform(@LTrans);
end;

procedure TDisplay.SetTransformAngle(aAngle: Single);
var
  LTrans: ALLEGRO_TRANSFORM;
  LX, LY: Integer;
begin
  if FHandle.Display = nil then Exit;
  LX := al_get_display_width(FHandle.Display);
  LY := al_get_display_height(FHandle.Display);

  al_copy_transform(@Trans, al_get_current_transform);
  al_translate_transform(@Trans, -(LX div 2), -(LY div 2));
  al_rotate_transform(@LTrans, aAngle * DEG2RAD);
  al_translate_transform(@LTrans, 0, 0);
  al_translate_transform(@LTrans, LX div 2, LY div 2);
  al_use_transform(@LTrans);
end;

procedure TDisplay.GetSize(aWidth: System.PInteger; aHeight: System.PInteger; aAspectRatio: System.PSingle=nil);
begin
  if FHandle.Display = nil then  Exit;
  if aWidth <> nil then
    aWidth^ := Round(FSize.X);

  if aHeight <> nil then
    aHeight^ := Round(FSize.Y);

  if aAspectRatio <> nil then
    aAspectRatio^ := FSize.X / FSize.Y;
end;

procedure TDisplay.SetTarget(aBitmap: Vivace.Bitmap.TBitmap);
begin
  if aBitmap <> nil then
  begin
    if aBitmap.Handle.Bitmap <> nil then
    begin
      al_set_target_bitmap(aBitmap.Handle.Bitmap);
    end;
  end;
end;

procedure TDisplay.ResetTarget;
begin
  if FHandle.Display = nil then Exit;
  al_set_target_backbuffer(FHandle.Display);
end;

procedure TDisplay.AlignToViewport(var aX: Single; var aY: Single);
var
  LVP: TRectangle;
begin
  GetViewportSize(LVP);
  aX := LVP.X + aX;
  aY := LVP.Y + aY;
end;

// TODO: handle case where viewport object is destroyed
// while still being active, FViewport will then be
// invalid. A possible solution would be to have a parent
// in TViewport and if its destroyed then let parent know
// so it can take appropriet action
// UPDATE: now what I do is if the current view is about
// to be destroyed, if its active, it call SetViewport(nil)
// to deactivate before its released to set the viewport
// back to full screen.
procedure TDisplay.SetViewport(aViewport: TViewport);
begin
  if FHandle.Display = nil then Exit;

  if aViewport <> nil then
    begin
      // check if same as current
      if FViewport = aViewport then
        Exit
      else
      // setting a new viewport when one is current
      begin
        // set to not active to show it
        if FViewport <> nil then
        begin
          TViewport(FViewport).SetActive(False);
        end;
      end;

      FViewport := aViewport;
      TViewport(FViewport).SetActive(True);
    end
  else
    begin
      if FViewport <> nil then
      begin
        TViewport(FViewport).SetActive(False);
        FViewport := nil;
      end;
    end;
end;

procedure TDisplay.ResetViewport;
begin
  if FHandle.Display = nil then Exit;
  if FViewport <> nil then
  begin
    TViewport(FViewport).SetActive(False);
  end;
end;


procedure TDisplay.GetViewportSize(aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger);
begin
  if FHandle.Display = nil then Exit;

  if FViewport <> nil then
    begin
      FViewport.GetSize(aX, aY, aWidth, aHeight);
    end
  else
    begin
      if aX <> nil then
        aX^ := 0;
      if aY <> nil then
        aY^ := 0;
      GetSize(aWidth, aHeight);
    end;
end;

procedure TDisplay.GetViewportSize(var aSize: TRectangle);
var
  LVX,LVY,LVW,LVH: Integer;
begin
  GetViewportSize(@LVX, @LVY, @LVW, @LVH);
  aSize.X := LVX;
  aSize.Y := LVY;
  aSize.Width := LVW;
  aSize.Height := LVH;
end;

procedure TDisplay.DrawLine(aX1, aY1, aX2, aY2: Single; aColor: TColor; aThickness: Single);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_line(aX1, aY1, aX2, aY2, LColor, aThickness);
end;

procedure TDisplay.DrawRectangle(aX, aY, aWidth, aHeight, aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_rectangle(aX, aY, aX + aWidth, aY + aHeight, LColor, aThickness);
end;

procedure TDisplay.DrawFilledRectangle(aX, aY, aWidth, aHeight: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_filled_rectangle(aX, aY, aX + aWidth, aY + aHeight, LColor);
end;

procedure TDisplay.DrawCircle(aX, aY, aRadius, aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_circle(aX, aY, aRadius, LColor, aThickness);
end;

procedure TDisplay.DrawFilledCircle(aX, aY, aRadius: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_filled_circle(aX, aY, aRadius, LColor);
end;

procedure TDisplay.DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer; aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_polygon(WinApi.Windows.PSingle(aVertices), aVertexCount, ALLEGRO_LINE_JOIN_ROUND, LColor, aThickness, 1.0);
end;

procedure TDisplay.DrawFilledPolygon(aVertices: System.PSingle; aVertexCount: Integer; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_filled_polygon(WinApi.Windows.PSingle(aVertices), aVertexCount, LColor);
end;

procedure TDisplay.DrawTriangle(aX1, aY1, aX2, aY2, aX3, aY3, aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_triangle(aX1, aY1, aX2, aY2, aX3, aY3, LColor, aThickness);
end;

procedure TDisplay.DrawFilledTriangle(aX1, aY1, aX2, aY2, aX3, aY3: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_draw_filled_triangle(aX1, aY1, aX2, aY2, aX3, aY3, LColor);
end;

procedure TDisplay.SetBlender(aOperation: Integer; aSource: Integer; aDestination: Integer);
begin
  if FHandle.Display = nil then Exit;
  al_set_blender(aOperation, aSource, aDestination);
end;

procedure TDisplay.GetBlender(aOperation: PInteger; aSource: PInteger; aDestination: PInteger);
begin
  if FHandle.Display = nil then Exit;
  al_get_blender(aOperation, aSource, aDestination);
end;

procedure TDisplay.SetBlendColor(aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle.Display = nil then Exit;
  al_set_blend_color(LColor);
end;

function TDisplay.GetBlendColor: TColor;
var
  LResult: ALLEGRO_COLOR absolute Result;
begin
  Result := BLANK;
  if FHandle.Display = nil then Exit;
  LResult := al_get_blend_color;
end;

procedure TDisplay.SetBlendMode(aMode: TBlendMode);
begin
  if FHandle.Display = nil then Exit;

  case aMode of
    bmPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
      end;
    bmNonPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ALPHA, ALLEGRO_INVERSE_ALPHA);
      end;
    bmAdditiveAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ONE);
      end;
    bmCopySrcToDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO);
      end;
    bmMultiplySrcAndDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_DEST_COLOR, ALLEGRO_ZERO)
      end;
  end;
end;

procedure TDisplay.SetBlendModeColor(aMode: TBlendModeColor; aColor: TColor);
begin
  if FHandle.Display = nil then Exit;
  case aMode of
    bcColorNormal:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_ONE);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue, aColor.alpha));
      end;
    bcColorAvgSrcDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_CONST_COLOR);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue, aColor.alpha));
      end;
  end;
end;

procedure TDisplay.RestoreDefaultBlendMode;
begin
  if FHandle.Display = nil then  Exit;
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
  al_set_blend_color(al_map_rgba(255, 255, 255, 255));
end;

procedure TDisplay.Save(aFilename: string);
var
  LBackbuffer: PALLEGRO_BITMAP;
  LScreenshot: PALLEGRO_BITMAP;
  LVX, LVY, LVW, LVH: Integer;
  LFilename: string;
begin
  if FHandle.Display = nil then Exit;

  // get viewport size
  LVX := Round(FTransSize.X);
  LVY := Round(FTransSize.Y);
  LVW := Round(FTransSize.Width);
  LVH := Round(FTransSize.Height);

  // create LScreenshot bitmpat
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR);
  LScreenshot := al_create_bitmap(LVW, LVH);

  // exit if failed to create LScreenshot bitmap
  if LScreenshot = nil then Exit;

  // get LBackbuffer
  LBackbuffer := al_get_backbuffer(FHandle.Display);

  // set target to LScreenshot bitmap
  al_set_target_bitmap(LScreenshot);

  // draw viewport area of LBackbuffer to LScreenshot bitmap
  al_draw_bitmap_region(LBackbuffer, LVX, LVY, LVW, LVH, 0, 0, 0);

  // restore LBackbuffer target
  al_set_target_bitmap(LBackbuffer);

  // make sure filename is a PNG file
  LFilename := aFilename;
  LFilename := TPath.ChangeExtension(LFilename, 'png');

  // save screen bitmap to PNG filename
  al_save_bitmap(PAnsiChar(AnsiString(LFilename)), LScreenshot);

  // destroy LScreenshot bitmap
  al_destroy_bitmap(LScreenshot);
end;

procedure TDisplay.GetTransInfo(var aSize: TRectangle; var aScale: Single);
begin
  aSize := FTransSize;
  aScale := FTransScale;
end;

procedure TDisplay.GetMonitorSize(var aSize: TVector);
begin
  aSize.X := al_get_display_width(Handle.Display);
  aSize.Y := al_get_display_height(Handle.Display);
  aSize.Z := aSize.X / aSize.Y;
end;

function  TDisplay.GetMemorySize: UInt64;
var
  LD3d: LPDIRECT3DDEVICE9;
begin
  Result := 0;
  if FHandle.Display = nil then Exit;
  LD3d := al_get_d3d_device(Handle.Display);
  Result := LD3d.GetAvailableTextureMem;
end;


end.
