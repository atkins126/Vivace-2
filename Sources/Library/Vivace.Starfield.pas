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

unit Vivace.Starfield;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math;

type

  { TStarfieldItem }
  TStarfieldItem = record
    X, Y, Z: Single;
    Speed: Single;
  end;

  { TStarfield }
  TStarfield = class(TBaseObject)
  protected
    FCenter: TVector;
    FMin: TVector;
    FMax: TVector;
    FViewScaleRatio: Single;
    FViewScale: Single;
    FStarCount: Cardinal;
    FStar: array of TStarfieldItem;
    FSpeed: TVector;
    FVirtualPos: TVector;
  protected
    procedure TransformDrawPoint(aX, aY, aZ: Single; aVPX, aVPY, aVPW, aVPH: Integer);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Done;
    procedure Init(aStarCount: Cardinal; aMinX, aMinY, aMinZ, aMaxX, aMaxY, aMaxZ, aViewScale: Single);

    procedure SetVirtualPos(aX, aY: Single);
    procedure GetVirtualPos(var aX: Single; var aY: Single);

    procedure SetXSpeed(aSpeed: Single);
    procedure SetYSpeed(aSpeed: Single);
    procedure SetZSpeed(aSpeed: Single);

    procedure Update(aDeltaTime: Single);

    procedure Render;
  end;

implementation

uses
  System.Math,
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Color;


{ TStarfield }
procedure TStarfield.TransformDrawPoint(aX, aY, aZ: Single; aVPX, aVPY, aVPW, aVPH: Integer);
var
  LX, LY: Single;
  LSW, LSH: Single;
  LOOZ: Single;
  LCV: byte;
  LColor: TColor;

  function IsVisible(vx, vy, vw, vh: Single): Boolean;
  begin
    Result := False;
    if ((vx - vw) < 0) then
      Exit;
    if (vx > (aVPW - 1)) then
      Exit;
    if ((vy - vh) < 0) then
      Exit;
    if (vy > (aVPH - 1)) then
      Exit;
    Result := True;
  end;

begin
  FViewScaleRatio := aVPW / aVPH;
  FCenter.X := (aVPW / 2) + aVPX;
  FCenter.Y := (aVPH / 2) + aVPY;

  LOOZ := ((1.0 / aZ) * FViewScale);
  LX := (FCenter.X - aVPX) - (aX * LOOZ) * FViewScaleRatio;
  LY := (FCenter.Y - aVPY) + (aY * LOOZ) * FViewScaleRatio;
  LSW := (1.0 * LOOZ);
  if LSW < 1 then
    LSW := 1;
  LSH := (1.0 * LOOZ);
  if LSH < 1 then
    LSH := 1;
  if not IsVisible(LX, LY, LSW, LSH) then
    Exit;
  LCV := round(255.0 - (((1.0 / FMax.Z) / (1.0 / aZ)) * 255.0));

  LColor.Make(LCV, LCV, LCV, LCV);

  LX := LX - FVirtualPos.X;
  LY := LY - FVirtualPos.Y;

  gEngine.Display.DrawFilledRectangle(LX, LY, LSW, LSH, LColor);
end;

constructor TStarfield.Create;
begin
  inherited;

  Init(250, -1000, -1000, 10, 1000, 1000, 1000, 120);
end;

destructor TStarfield.Destroy;
begin
  Done;

  inherited;
end;

procedure TStarfield.Init(aStarCount: Cardinal; aMinX, aMinY, aMinZ, aMaxX, aMaxY, aMaxZ, aViewScale: Single);
var
  LVPX, LVPY: Integer;
  LVPW, LVPH: Integer;
  LI: Integer;
begin
  Done;

  FStarCount := aStarCount;
  SetLength(FStar, FStarCount);

  gEngine.Display.GetViewportSize(@LVPX, @LVPY, @LVPW, @LVPH);

  FViewScale := aViewScale;
  FViewScaleRatio := LVPW / LVPH;
  FCenter.X := (LVPW / 2) + LVPX;
  FCenter.Y := (LVPH / 2) + LVPY;
  FCenter.Z := 0;

  FMin.X := aMinX;
  FMin.Y := aMinY;
  FMin.Z := aMinZ;
  FMax.X := aMaxX;
  FMax.Y := aMaxY;
  FMax.Z := aMaxZ;

  for LI := 0 to FStarCount - 1 do
  begin
    FStar[LI].X := TMath.RandomRange(FMin.X, FMax.X);
    FStar[LI].Y := TMath.RandomRange(FMin.Y, FMax.Y);
    FStar[LI].Z := TMath.RandomRange(FMin.Z, FMax.Z);
  end;

  SetXSpeed(0.0);
  SetYSpeed(0.0);
  SetZSpeed(-60*3);
  SetVirtualPos(0, 0);
end;

procedure TStarfield.Done;
begin
  FStar := nil;
end;

procedure TStarfield.SetVirtualPos(aX, aY: Single);
begin
  FVirtualPos.X := aX;
  FVirtualPos.Y := aY;
  FVirtualPos.Z := 0;
end;

procedure TStarfield.GetVirtualPos(var aX: Single; var aY: Single);
begin
  aX := FVirtualPos.X;
  aY := FVirtualPos.Y;
end;

procedure TStarfield.SetXSpeed(aSpeed: Single);
begin
  FSpeed.X := aSpeed;
end;

procedure TStarfield.SetYSpeed(aSpeed: Single);
begin
  FSpeed.Y := aSpeed;
end;

procedure TStarfield.SetZSpeed(aSpeed: Single);
begin

  FSpeed.Z := aSpeed;
end;

procedure TStarfield.Update(aDeltaTime: Single);
var
  LI: Integer;

  procedure SetRandomPos(aIndex: Integer);
  begin
    FStar[aIndex].X := TMath.RandomRange(FMin.X, FMax.X);
    FStar[aIndex].Y := TMath.RandomRange(FMin.Y, FMax.Y);
    FStar[aIndex].Z := TMath.RandomRange(FMin.Z, FMax.Z);
  end;

begin

  for LI := 0 to FStarCount - 1 do
  begin
    FStar[LI].X := FStar[LI].X + (FSpeed.X * aDeltaTime);
    FStar[LI].Y := FStar[LI].Y + (FSpeed.Y * aDeltaTime);
    FStar[LI].Z := FStar[LI].Z + (FSpeed.Z * aDeltaTime);

    if FStar[LI].X < FMin.X then
    begin
      SetRandomPos(LI);
      FStar[LI].X := FMax.X;
    end;

    if FStar[LI].X > FMax.X then
    begin
      SetRandomPos(LI);
      FStar[LI].X := FMin.X;
    end;

    if FStar[LI].Y < FMin.Y then
    begin
      SetRandomPos(LI);
      FStar[LI].Y := FMax.Y;
    end;

    if FStar[LI].Y > FMax.Y then
    begin
      SetRandomPos(LI);
      FStar[LI].Y := FMin.Y;
    end;

    if FStar[LI].Z < FMin.Z then
    begin
      SetRandomPos(LI);
      FStar[LI].Z := FMax.Z;
    end;

    if FStar[LI].Z > FMax.Z then
    begin
      SetRandomPos(LI);
      FStar[LI].Z := FMin.Z;
    end;

  end;
end;

procedure TStarfield.Render;
var
  LI: Integer;
  LVPX, LVPY, LVPW, LVPH: Integer;
begin
  gEngine.Display.GetViewportSize(@LVPX, @LVPY, @LVPW, @LVPH);
  for LI := 0 to FStarCount - 1 do
  begin
    TransformDrawPoint(FStar[LI].X, FStar[LI].Y, FStar[LI].Z, LVPX, LVPY, LVPW, LVPH);
  end;
end;

end.
