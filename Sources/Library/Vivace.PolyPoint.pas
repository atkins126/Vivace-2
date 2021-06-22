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

unit Vivace.PolyPoint;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math,
  Vivace.Polygon,
  Vivace.Bitmap,
  Vivace.Color,
  Vivace.Sprite;

type

  { TPolyPoint }
  TPolyPoint = class(TBaseObject)
  protected
    FPolygon: array of TPolygon;
    FCount: Integer;
    procedure Clear;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Save(aFilename: string);
    procedure Load(aFilename: string);
    procedure CopyFrom(aPolyPoint: TPolyPoint);
    procedure AddPoint(aNum: Integer; aX: Single; aY: Single; aOrigin: PVector);
    function TraceFromBitmap(aBitmap: TBitmap; aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PVector): Integer;
    procedure TraceFromSprite(aSprite: TSprite; aGroup: Integer; aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PVector);
    function Count: Integer;
    procedure Render(aNum: Integer; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColor: TColor; aOrigin: PVector; aHFlip: Boolean; aVFlip: Boolean);
    function Collide(aNum1: Integer; aGroup1: Integer; aX1: Single; aY1: Single;
      aScale1: Single; aAngle1: Single; aOrigin1: PVector; aHFlip1: Boolean;
      aVFlip1: Boolean; aPolyPoint2: TPolyPoint; aNum2: Integer;
      aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single;
      aAngle2: Single; aOrigin2: PVector; aHFlip2: Boolean; aVFlip2: Boolean;
      var aHitPos: TVector): Boolean;
    function CollidePoint(aNum: Integer; aGroup: Integer; aX: Single;
      aY: Single; aScale: Single; aAngle: Single; aOrigin: PVector;
      aHFlip: Boolean; aVFlip: Boolean; var aPoint: TVector): Boolean;
    function Polygon(aNum: Integer): TPolygon;
    function Valid(aNum: Integer): Boolean;
  end;

implementation

uses
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Collision,
  Vivace.PolyPointTrace;

{ TPolyPoint }
procedure TPolyPoint.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Assigned(FPolygon[I]) then
    begin
      FreeAndNil(FPolygon[I]);
    end;
  end;
  FPolygon := nil;
  FCount := 0;
end;

constructor TPolyPoint.Create;
begin
  inherited;
  FPolygon := nil;
  FCount := 0;
end;

destructor TPolyPoint.Destroy;
begin
  Clear;
  inherited;
end;

procedure TPolyPoint.Save(aFilename: string);
begin
end;

procedure TPolyPoint.Load(aFilename: string);
begin
end;

procedure TPolyPoint.CopyFrom(aPolyPoint: TPolyPoint);
begin
end;

procedure TPolyPoint.AddPoint(aNum: Integer; aX: Single; aY: Single;
  aOrigin: PVector);
var
  X, Y: Single;
begin
  X := aX;
  Y := aY;

  if aOrigin <> nil then
  begin
    X := X - aOrigin.X;
    Y := Y - aOrigin.Y;
  end;

  FPolygon[aNum].AddLocalPoint(X, Y, True);
end;

function TPolyPoint.TraceFromBitmap(aBitmap: TBitmap; aMju: Single;
  aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PVector): Integer;
var
  I: Integer;
  W, H: Single;
  LData: TBitmapData;
begin
  Inc(FCount);
  SetLength(FPolygon, FCount);
  I := FCount - 1;
  FPolygon[I] := TPolygon.Create;
  aBitmap.GetSize(@W, @H);
  aBitmap.Lock(nil, LData);
  TPolyPointTrace.Init(aMju, aMaxStepBack, aAlphaThreshold);
  TPolyPointTrace.PrimaryTrace(aBitmap, W, H);
  TPolyPointTrace.SimplifyPoly;
  TPolyPointTrace.ApplyPolyPoint(Self, I, aOrigin);
  TPolyPointTrace.Done;
  aBitmap.Unlock;

  Result := I;
end;

procedure TPolyPoint.TraceFromSprite(aSprite: TSprite; aGroup: Integer;
  aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer;
  aOrigin: PVector);
var
  I: Integer;
  Rect: TRectangle;
  Tex: TBitmap;
  W, H: Integer;
  LData: TBitmapData;
begin
  Clear;
  FCount := aSprite.GetImageCount(aGroup);
  SetLength(FPolygon, Count);
  for I := 0 to Count - 1 do
  begin
    FPolygon[I] := TPolygon.Create;
    Tex := aSprite.GetImageTexture(I, aGroup);
    Rect := aSprite.GetImageRect(I, aGroup);
    W := Round(Rect.width);
    H := Round(Rect.height);
    Tex.Lock(@Rect, LData);
    TPolyPointTrace.Init(aMju, aMaxStepBack, aAlphaThreshold);
    TPolyPointTrace.PrimaryTrace(Tex, W, H);
    TPolyPointTrace.SimplifyPoly;
    TPolyPointTrace.ApplyPolyPoint(Self, I, aOrigin);
    TPolyPointTrace.Done;
    Tex.Unlock;
  end;
end;

function TPolyPoint.Count: Integer;
begin
  Result := FCount;
end;

procedure TPolyPoint.Render(aNum: Integer; aX: Single; aY: Single;
  aScale: Single; aAngle: Single; aColor: TColor; aOrigin: PVector;
  aHFlip: Boolean; aVFlip: Boolean);
begin
  if aNum >= FCount then
    Exit;
  FPolygon[aNum].Render(aX, aY, aScale, aAngle, 1, aColor, aOrigin,
    aHFlip, aVFlip);
end;

function TPolyPoint.Collide(aNum1: Integer; aGroup1: Integer; aX1: Single;
  aY1: Single; aScale1: Single; aAngle1: Single; aOrigin1: PVector;
  aHFlip1: Boolean; aVFlip1: Boolean; aPolyPoint2: TPolyPoint; aNum2: Integer;
  aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single; aAngle2: Single;
  aOrigin2: PVector; aHFlip2: Boolean; aVFlip2: Boolean;
  var aHitPos: TVector): Boolean;
var
  L1, L2, IX, IY: Integer;
  Cnt1, Cnt2: Integer;
  Pos: array [0 .. 3] of PVector;
  Poly1, Poly2: TPolygon;
begin
  Result := False;

  if (aPolyPoint2 = nil) then
    Exit;

  Poly1 := FPolygon[aNum1];
  Poly2 := aPolyPoint2.Polygon(aNum2);

  // transform to world points
  Poly1.Transform(aX1, aY1, aScale1, aAngle1, aOrigin1, aHFlip1, aVFlip1);
  Poly2.Transform(aX2, aY2, aScale2, aAngle2, aOrigin2, aHFlip2, aVFlip2);

  Cnt1 := Poly1.GetPointCount;
  Cnt2 := Poly2.GetPointCount;

  if Cnt1 < 2 then
    Exit;
  if Cnt2 < 2 then
    Exit;

  for L1 := 0 to Cnt1 - 2 do
  begin
    Pos[0] := Poly1.GetWorldPoint(L1);
    Pos[1] := Poly1.GetWorldPoint(L1 + 1);

    for L2 := 0 to Cnt2 - 2 do
    begin

      Pos[2] := Poly2.GetWorldPoint(L2);
      Pos[3] := Poly2.GetWorldPoint(L2 + 1);
      if TCollision.LineIntersection(Round(Pos[0].X), Round(Pos[0].Y), Round(Pos[1].X),
        Round(Pos[1].Y), Round(Pos[2].X), Round(Pos[2].Y), Round(Pos[3].X),
        Round(Pos[3].Y), IX, IY) = liTRUE then
      begin
        aHitPos.X := IX;
        aHitPos.Y := IY;
        Result := True;
        Exit;
      end;
    end;
  end;

end;

function TPolyPoint.CollidePoint(aNum: Integer; aGroup: Integer; aX: Single;
  aY: Single; aScale: Single; aAngle: Single; aOrigin: PVector; aHFlip: Boolean;
  aVFlip: Boolean; var aPoint: TVector): Boolean;
var
  L1, IX, IY: Integer;
  Cnt1: Integer;
  Pos: array [0 .. 3] of PVector;
  Point2: TVector;
  Poly1: TPolygon;
begin
  Result := False;

  Poly1 := FPolygon[aNum];

  // transform to world points
  Poly1.Transform(aX, aY, aScale, aAngle, aOrigin, aHFlip, aVFlip);

  Cnt1 := Poly1.GetPointCount;

  if Cnt1 < 2 then
    Exit;

  Point2.X := aPoint.X + 1;
  Point2.Y := aPoint.Y + 1;
  Pos[2] := @aPoint;
  Pos[3] := @Point2;

  for L1 := 0 to Cnt1 - 2 do
  begin
    Pos[0] := Poly1.GetWorldPoint(L1);
    Pos[1] := Poly1.GetWorldPoint(L1 + 1);

    if TCollision.LineIntersection(Round(Pos[0].X), Round(Pos[0].Y), Round(Pos[1].X),
      Round(Pos[1].Y), Round(Pos[2].X), Round(Pos[2].Y), Round(Pos[3].X),
      Round(Pos[3].Y), IX, IY) = liTrue then
    begin
      aPoint.X := IX;
      aPoint.Y := IY;
      Result := True;
      Exit;
    end;
  end;

end;

function TPolyPoint.Polygon(aNum: Integer): TPolygon;
begin
  Result := FPolygon[aNum];
end;

function TPolyPoint.Valid(aNum: Integer): Boolean;
begin
  Result := False;
  if aNum >= FCount then
    Exit;
  Result := Boolean(FPolygon[aNum].GetPointCount >= 2);
end;

end.
