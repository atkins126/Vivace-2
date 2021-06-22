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

unit Vivace.Math;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common;

const
  // Degree/Radian conversion
  RAD2DEG = 180.0 / PI;
  DEG2RAD = PI / 180.0;

type

  { TPointi }
  PPointi = ^TPointi;
  TPointi = record
    X, Y: Integer;
  end;

  { TPoint }
  PPointf = ^TPointi;
  TPointf = record
    X, Y: Single;
  end;

  { TGVRange }
  PRange = ^TRange;
  TRange = record
    MinX, MinY, MaxX, MaxY: Single;
  end;

  { TVector }
  PVector = ^TVector;
  TVector = record
    X, Y, Z: Single;
    constructor Create(aX: Single; aY: Single);
    procedure Assign(aX: Single; aY: Single); overload; inline;
    procedure Assign(aX: Single; aY: Single; aZ: Single); overload; inline;
    procedure Assign(aVector: TVector); overload; inline;
    procedure Clear; inline;
    procedure Add(aVector: TVector); inline;
    procedure Subtract(aVector: TVector); inline;
    procedure Multiply(aVector: TVector); inline;
    procedure Divide(aVector: TVector); inline;
    function  Magnitude: Single; inline;
    function  MagnitudeTruncate(aMaxMagitude: Single): TVector; inline;
    function  Distance(aVector: TVector): Single; inline;
    procedure Normalize; inline;
    function  Angle(aVector: TVector): Single; inline;
    procedure Thrust(aAngle: Single; aSpeed: Single); inline;
    function  MagnitudeSquared: Single; inline;
    function  DotProduct(aVector: TVector): Single; inline;
    procedure Scale(aValue: Single); inline;
    procedure DivideBy(aValue: Single); inline;
    function  Project(aVector: TVector): TVector; inline;
    procedure Negate; inline;
  end;

  { TRectangle }
  PRectangle = ^TRectangle;
  TRectangle = record
    X: Single;
    Y: Single;
    Width: Single;
    Height: Single;
    constructor Create(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
    procedure Assign(aX: Single; aY: Single; aWidth: Single; aHeight: Single); inline;
    function  Intersect(aRect: TRectangle): Boolean; inline;
  end;

  { TMath }
  TMath = class
  public
    class procedure Randomize;
    class function  RandomRange(aMin, aMax: Integer): Integer; overload;
    class function  RandomRange(aMin, aMax: Single): Single; overload;
    class function  RandomBool: Boolean;
    class function  GetRandomSeed: Integer;
    class procedure SetRandomSeed(aValue: Integer);

    class function  AngleCos(aAngle: Integer): Single;
    class function  AngleSin(aAngle: Integer): Single;
    class function  AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
    class procedure AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);

    class function  ClipValue(var aValue: Single; aMin: Single; aMax: Single; aWrap: Boolean): Single; overload;
    class function  ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer; aWrap: Boolean): Integer; overload;

    class function  SameSign(aValue1: Integer; aValue2: Integer): Boolean; overload;
    class function  SameSign(aValue1: Single; aValue2: Single): Boolean; overload;

    class function  SameValue(aA: Double; aB: Double; aEpsilon: Double = 0): Boolean; overload;
    class function  SameValue(aA: Single; aB: Single; aEpsilon: Single = 0): Boolean; overload;

    class function  Pointi(aX: Integer; aY: Integer): TPointi; inline;
    class function  Pointf(aX: Single; aY: Single): TPointf; inline;
    class function  Vector(aX: Single; aY: Single): TVector; inline;
    class function  Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TRectangle; inline;
end;

implementation

uses
  System.Math,
  Vivace.Logger,
  Vivace.Engine;

var
  mCosTable: array [0 .. 360] of Single;
  mSinTable: array [0 .. 360] of Single;

{ TMath }
class procedure TMath.Randomize;
begin
  System.Randomize;
end;

class function TMath.RandomRange(aMin, aMax: Integer): Integer;
begin
  Result := System.Math.RandomRange(aMin, aMax + 1);
end;

class function TMath.RandomRange(aMin, aMax: Single): Single;
var
  N: Single;
begin
  N := System.Math.RandomRange(0, MaxInt) / MaxInt;
  Result := aMin + (N * (aMax - aMin));
end;

class function TMath.RandomBool: Boolean;
begin
  Result := Boolean(System.Math.RandomRange(0, 2) = 1);
end;

class function TMath.GetRandomSeed: Integer;
begin
  Result := RandSeed;
end;

class procedure TMath.SetRandomSeed(aValue: Integer);
begin
  RandSeed := aValue;
end;

class function TMath.AngleCos(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then
    Exit;
  Result := mCosTable[aAngle];
end;

class function TMath.AngleSin(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then
    Exit;
  Result := mSinTable[aAngle];
end;

class function TMath.AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
var
  C: Single;
begin
  C := aDestAngle - aSrcAngle -
    (Floor((aDestAngle - aSrcAngle) / 360.0) * 360.0);

  if C >= (360.0 / 2) then
  begin
    C := C - 360.0;
  end;
  Result := C;
end;

class procedure TMath.AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);
var
  nx, ny: Single;
  ia: Integer;
begin
  ClipValue(aAngle, 0, 359, True);

  ia := Round(aAngle);

  nx := aX * mCosTable[ia] - aY * mSinTable[ia];
  ny := aY * mCosTable[ia] + aX * mSinTable[ia];

  aX := nx;
  aY := ny;
end;

class function TMath.ClipValue(var aValue: Single; aMin: Single; aMax: Single; aWrap: Boolean): Single;
begin
  if aWrap then
  begin
    if (aValue > aMax) then
    begin
      aValue := aMin + Abs(aValue - aMax);
      if aValue > aMax then
        aValue := aMax;
    end
    else if (aValue < aMin) then
    begin
      aValue := aMax - Abs(aValue - aMin);
      if aValue < aMin then
        aValue := aMin;
    end
  end
  else
  begin
    if aValue < aMin then
      aValue := aMin
    else if aValue > aMax then
      aValue := aMax;
  end;

  Result := aValue;

end;

class function TMath.ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer; aWrap: Boolean): Integer;
begin
  if aWrap then
  begin
    if (aValue > aMax) then
    begin
      aValue := aMin + Abs(aValue - aMax);
      if aValue > aMax then
        aValue := aMax;
    end
    else if (aValue < aMin) then
    begin
      aValue := aMax - Abs(aValue - aMin);
      if aValue < aMin then
        aValue := aMin;
    end
  end
  else
  begin
    if aValue < aMin then
      aValue := aMin
    else if aValue > aMax then
      aValue := aMax;
  end;

  Result := aValue;
end;

class function TMath.SameSign(aValue1: Integer; aValue2: Integer): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

class function TMath.SameSign(aValue1: Single; aValue2: Single): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

class function TMath.SameValue(aA: Double; aB: Double; aEpsilon: Double = 0): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

class function TMath.SameValue(aA: Single; aB: Single; aEpsilon: Single = 0): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

class function TMath.Pointi(aX: Integer; aY: Integer): TPointi;
begin
  Result.X := aX;
  Result.Y := aY;
end;

class function TMath.Pointf(aX: Single; aY: Single): TPointf;
begin
  Result.X := aX;
  Result.Y := aY;
end;

class function TMath.Vector(aX: Single; aY: Single): TVector;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Z := 0;
end;

class function TMath.Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TRectangle;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Width := aWidth;
  Result.Height := aHeight;
end;



{ TVector }
constructor TVector.Create(aX: Single; aY: Single);
begin
  Assign(aX, aY);
  Z := 0;
end;

procedure TVector.Assign(aX: Single; aY: Single);
begin
  X := aX;
  Y := aY;
end;

procedure TVector.Assign(aX: Single; aY: Single; aZ: Single);
begin
  X := aX;
  Y := aY;
  Z := aZ;
end;

procedure TVector.Clear;
begin
  X := 0;
  Y := 0;
  Z := 0;
end;

procedure TVector.Assign(aVector: TVector);
begin
  X := aVector.X;
  Y := aVector.Y;
end;

procedure TVector.Add(aVector: TVector);
begin
  X := X + aVector.X;
  Y := Y + aVector.Y;
end;

procedure TVector.Subtract(aVector: TVector);
begin
  X := X - aVector.X;
  Y := Y - aVector.Y;
end;

procedure TVector.Multiply(aVector: TVector);
begin
  X := X * aVector.X;
  Y := Y * aVector.Y;
end;

procedure TVector.Divide(aVector: TVector);
begin
  X := X / aVector.X;
  Y := Y / aVector.Y;

end;

function TVector.Magnitude: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function TVector.MagnitudeTruncate(aMaxMagitude: Single): TVector;
var
  MaxMagSqrd: Single;
  VecMagSqrd: Single;
  Truc: Single;
begin
  Result.Assign(X, Y);
  MaxMagSqrd := aMaxMagitude * aMaxMagitude;
  VecMagSqrd := Result.Magnitude;
  if VecMagSqrd > MaxMagSqrd then
  begin
    Truc := (aMaxMagitude / Sqrt(VecMagSqrd));
    Result.X := Result.X * Truc;
    Result.Y := Result.Y * Truc;
  end;
end;

function TVector.Distance(aVector: TVector): Single;
var
  DirVec: TVector;
begin
  DirVec.X := X - aVector.X;
  DirVec.Y := Y - aVector.Y;
  Result := DirVec.Magnitude;
end;

procedure TVector.Normalize;
var
  Len, OOL: Single;
begin
  Len := self.Magnitude;
  if Len <> 0 then
  begin
    OOL := 1.0 / Len;
    X := X * OOL;
    Y := Y * OOL;
  end;
end;

function TVector.Angle(aVector: TVector): Single;
var
  xoy: Single;
  R: TVector;
begin
  R.Assign(self);
  R.Subtract(aVector);
  R.Normalize;

  if R.Y = 0 then
  begin
    R.Y := 0.001;
  end;

  xoy := R.X / R.Y;

  Result := ArcTan(xoy) * RAD2DEG;
  if R.Y < 0 then
    Result := Result + 180.0;

end;

procedure TVector.Thrust(aAngle: Single; aSpeed: Single);
var
  A: Single;
begin
  A := aAngle + 90.0;
  TMath.ClipValue(A, 0, 360, True);

  X := X + TMath.AngleCos(Round(A)) * -(aSpeed);
  Y := Y + TMath.AngleSin(Round(A)) * -(aSpeed);
end;

function TVector.MagnitudeSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

function TVector.DotProduct(aVector: TVector): Single;
begin
  Result := (X * aVector.X) + (Y * aVector.Y);
end;

procedure TVector.Scale(aValue: Single);
begin
  X := X * aValue;
  Y := Y * aValue;
end;

procedure TVector.DivideBy(aValue: Single);
begin
  X := X / aValue;
  Y := Y / aValue;
end;

function TVector.Project(aVector: TVector): TVector;
var
  dp: Single;
begin
  dp := self.DotProduct(aVector);
  Result.X := (dp / (aVector.X * aVector.X + aVector.Y * aVector.Y)) *
    aVector.X;
  Result.Y := (dp / (aVector.X * aVector.X + aVector.Y * aVector.Y)) *
    aVector.Y;
end;

procedure TVector.Negate;
begin
  X := -X;
  Y := -Y;
end;

{ TRectangle }
constructor TRectangle.Create(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single);
begin
  Assign(aX, aY, aWidth, aHeight);
end;

procedure TRectangle.Assign(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single);
begin
  X := aX;
  Y := aY;
  Width := aWidth;
  Height := aHeight;
end;

function TRectangle.Intersect(aRect: TRectangle): Boolean;
var
  r1r, r1b: Single;
  r2r, r2b: Single;
begin
  r1r := X - (Width - 1);
  r1b := Y - (Height - 1);
  r2r := aRect.X - (aRect.Width - 1);
  r2b := aRect.Y - (aRect.Height - 1);

  Result := (X < r2r) and (r1r > aRect.X) and (Y < r2b) and (r1b > aRect.Y);
end;

{ unit initialize/finalize }

procedure InitSinCosTable;
var
  I: Integer;
begin
  for I := 0 to 360 do
  begin
    mCosTable[I] := cos((I * PI / 180.0));
    mSinTable[I] := sin((I * PI / 180.0));
  end;
  TLogger.Log(etSuccess, 'Initialized sin/cos tables', []);
end;

initialization
begin
  Randomize;
  InitSinCosTable;
end;

finalization
begin
end;


end.
