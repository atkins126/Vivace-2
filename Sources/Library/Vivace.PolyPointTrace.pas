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

unit Vivace.PolyPointTrace;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math,
  Vivace.Bitmap,
  Vivace.PolyPoint;

type

  { TPolyPointTrace }
  TPolyPointTrace = class
  public
    class procedure Init(aMju: Extended = 6; aMaxStepBack: Integer = 10; aAlphaThreshold: Byte = 70);
    class procedure Done;
    class function  GetPointCount: Integer;
    class procedure PrimaryTrace(aTex: TBitmap; aWidth, aHeight: Single);
    class procedure SimplifyPoly;
    class procedure ApplyPolyPoint(aPolyPoint: TPolyPoint; aNum: Integer; aOrigin: PVector);
  end;

implementation

uses
  Vivace.Utils,
  Vivace.Color;

type
  { TR_Point }
  TR_Point = record
    X, Y: Integer;
  end;

var
  mPolyArr: array of TR_Point;
  mPntCount: Integer;
  mMju: Extended = 6;
  mMaxStepBack: Integer = 10;
  mAlphaThreshold: Byte = 70; // alpha channel threshhold

function IsNeighbour(X1, Y1, X2, Y2: Integer): Boolean;
begin
  Result := (Abs(X2 - X1) <= 1) and (Abs(Y2 - Y1) <= 1);
end;

function IsPixEmpty(Tex: TBitmap; X, Y: Integer; W, H: Single): Boolean;
var
  LColor: TColor;
begin
  if (X < 0) or (Y < 0) or (X > W - 1) or (Y > H - 1) then
    Result := true
  else
  begin
    LColor := Tex.GetPixel(X, Y);
    Result := Boolean(LColor.alpha * 255 < mAlphaThreshold);
  end;
end;

// some point list functions
procedure AddPoint(X, Y: Integer);
var
  LL: Integer;
begin
  Inc(mPntCount);
  // L := Length(PolyArr);
  LL := High(mPolyArr) + 1;
  if LL < mPntCount then
    SetLength(mPolyArr, LL + mMaxStepBack);
  mPolyArr[mPntCount - 1].X := X;
  mPolyArr[mPntCount - 1].Y := Y;
end;

procedure DelPoint(Index: Integer);
var
  LI: Integer;
begin
  if mPntCount > 1 then
    for LI := Index to mPntCount - 2 do
      mPolyArr[LI] := mPolyArr[LI + 1];
  Dec(mPntCount);
end;

function IsInList(X, Y: Integer): Boolean;
var
  LI: Integer;
begin
  Result := False;
  for LI := 0 to mPntCount - 1 do
  begin
    Result := (mPolyArr[LI].X = X) and (mPolyArr[LI].Y = Y);
    if Result then
      Break;
  end;
end;

procedure FindStartingPoint(Tex: TBitmap; var X, Y: Integer; W, H: Single);
var
  LI, LJ: Integer;
begin
  X := 1000000; // init X and Y with huge values
  Y := 1000000;
  // and simply find the non-zero point with lowest Y
  LI := 0;
  LJ := 0;
  while (X = 1000000) and (LI <= H) do
  begin
    if not IsPixEmpty(Tex, LI, LJ, W, H) then
    begin
      X := LI;
      Y := LJ;
    end;
    Inc(LI);
    if LI = W then
    begin
      LI := 0;
      Inc(LJ);
    end;
  end;
  if X = 1000000 then
  begin
    // do something awful - texture is empty!
    // ShowMessage('do something awful - texture is empty!', [], SHOWMESSAGE_ERROR);
  end;
end;

const
  // this is an order of looking for neighbour. Order is quite important
  Neighbours: array [1 .. 8, 1 .. 2] of Integer = ((0, -1), (-1, 0), (0, 1),
    (1, 0), (-1, -1), (-1, 1), (1, 1), (1, -1));

function CountEmptyAround(Tex: TBitmap; X, Y: Integer; W, H: Single): Integer;
var
  LI: Integer;
begin
  Result := 0;
  for LI := 1 to 8 do
    if IsPixEmpty(Tex, X + Neighbours[LI, 1], Y + Neighbours[LI, 2], W, H) then
      Inc(Result);
end;

// finds nearest non-empty pixel with maximum empty neighbours which is NOT neighbour of some other pixel
// Returns true if found and XF,YF - coordinates
// This function may look odd but I need it for finding primary circumscribed poly which later will be
// simplified
function FindNearestButNotNeighbourOfOther(Tex: TBitmap; Xs, Ys, XOther, YOther: Integer; var XF, YF: Integer; W, H: Single): Boolean;
var
  LI, LMaxEmpty, LE: Integer;
  LXt, LYt: Integer;
begin
  LMaxEmpty := 0;
  Result := False;
  for LI := 1 to 8 do
  begin
    LXt := Xs + Neighbours[LI, 1];
    LYt := Ys + Neighbours[LI, 2];
    // is it non-empty and not-a-neighbour point?
    if (not IsInList(LXt, LYt)) and (not IsNeighbour(LXt, LYt, XOther, YOther)) and
      (not IsPixEmpty(Tex, LXt, LYt, W, H)) then
    begin
      LE := CountEmptyAround(Tex, LXt, LYt, W, H); // ok. count empties around
      if LE > LMaxEmpty then // the best choice point has max empty neighbours
      begin
        XF := LXt;
        YF := LYt;
        LMaxEmpty := LE;
        Result := true;
      end;
    end;
  end;
end;

// simplifying procedures
function LineLength(X1, Y1, X2, Y2: Integer): Extended;
var
  LA, LB: Integer;
begin
  LA := Abs(X2 - X1);
  LB := Abs(Y2 - Y1);
  Result := Sqrt(LA * LA + LB * LB);
end;

function TriangleSquare(X1, Y1, X2, Y2, X3, Y3: Integer): Extended;
var
  LP: Extended;
  LA, LB, LC: Extended;
begin
  LA := LineLength(X1, Y1, X2, Y2);
  LB := LineLength(X2, Y2, X3, Y3);
  LC := LineLength(X3, Y3, X1, Y1);
  LP := LA + LB + LC;
  Result := Sqrt(LP * (LP - LA) * (LP - LB) * (LP - LC)); // using Heron's formula
end;

// for alternate method simplifying I decided to use "thinness" of triangles
// the idea is that if square of triangle is small but his perimeter is big it means that
// triangle is "thin" - so it can be approximated to line
function TriangleThinness(X1, Y1, X2, Y2, X3, Y3: Integer): Extended;
var
  LP: Extended;
  LA, LB, LC, LS: Extended;
begin
  LA := LineLength(X1, Y1, X2, Y2);
  LB := LineLength(X2, Y2, X3, Y3);
  LC := LineLength(X3, Y3, X1, Y1);
  LP := LA + LB + LC;
  LS := Sqrt(LP * (LP - LA) * (LP - LB) * (LP - LC));
  // using Heron's formula to find triangle'LS square
  Result := LS / LP;
  // so if this result less than some Mju then we can approximate particular triangle
end;

{ TPolyPointTrace }
class procedure TPolyPointTrace.ApplyPolyPoint(aPolyPoint: TPolyPoint; aNum: Integer; aOrigin: PVector);
var
  LI: Integer;
begin
  for LI := 0 to mPntCount - 1 do
  begin
    aPolyPoint.AddPoint(aNum, mPolyArr[LI].X, mPolyArr[LI].Y, aOrigin);
  end;
end;

class procedure TPolyPointTrace.Init(aMju: Extended = 6; aMaxStepBack: Integer = 10; aAlphaThreshold: Byte = 70);
begin
  Done;
  mMju := aMju;
  mMaxStepBack := aMaxStepBack;
  mAlphaThreshold := aAlphaThreshold;
end;

class procedure TPolyPointTrace.Done;
begin
  mPntCount := 0;
  mPolyArr := nil;
end;

class function TPolyPointTrace.GetPointCount: Integer;
begin
  Result := mPntCount;
end;

// primarily tracer procedure (gives too precise polyline - need to simplify later)
class procedure TPolyPointTrace.PrimaryTrace(aTex: TBitmap; aWidth, aHeight: Single);
var
  LI: Integer;
  LXn, LYn, LXnn, LYnn: Integer;
  LNextPointFound: Boolean;
  LBack: Integer;
  LLStepBack: Integer;
begin
  FindStartingPoint(aTex, LXn, LYn, aWidth, aHeight);
  LNextPointFound := LXn <> 1000000;
  LLStepBack := 0;
  while LNextPointFound do
  begin
    LNextPointFound := False;
    // checking if we got LBack to starting point...
    if not((mPntCount > 3) and IsNeighbour(LXn, LYn, mPolyArr[0].X, mPolyArr[0].Y))
    then
    begin
      if mPntCount > 7 then
        LBack := 7
      else
        LBack := mPntCount;
      if LBack = 0 then // no points in list - take any near point
        LNextPointFound := FindNearestButNotNeighbourOfOther(aTex, LXn, LYn, -100,
          -100, LXnn, LYnn, aWidth, aHeight)
      else
        // checking near but not going LBack
        for LI := 1 to LBack do
        begin
          LNextPointFound := FindNearestButNotNeighbourOfOther(aTex, LXn, LYn,
            mPolyArr[mPntCount - LI].X, mPolyArr[mPntCount - LI].Y, LXnn, LYnn, aWidth, aHeight);
          LNextPointFound := LNextPointFound and (not IsInList(LXnn, LYnn));
          if LNextPointFound then
            Break;
        end;
      AddPoint(LXn, LYn);
      if LNextPointFound then
      begin
        LXn := LXnn;
        LYn := LYnn;
        LLStepBack := 0;
      end
      else if LLStepBack < mMaxStepBack then
      begin
        LXn := mPolyArr[mPntCount - LLStepBack * 2 - 2].X;
        LYn := mPolyArr[mPntCount - LLStepBack * 2 - 2].Y;
        Inc(LLStepBack);
        LNextPointFound := true;
      end;
    end;
  end;
  // close the poly
  if mPntCount > 0 then
    AddPoint(mPolyArr[0].X, mPolyArr[0].Y);
end;

class procedure TPolyPointTrace.SimplifyPoly;
var
  I: Integer;
  Finished: Boolean;
  Thinness: Extended;
begin
  Finished := False;
  while not Finished do
  begin
    I := 0;
    Finished := true;
    while I <= mPntCount - 3 do
    begin
      Thinness := TriangleThinness(mPolyArr[I].X, mPolyArr[I].Y, mPolyArr[I + 1].X,
        mPolyArr[I + 1].Y, mPolyArr[I + 2].X, mPolyArr[I + 2].Y);
      if Thinness < mMju then
      // the square of triangle is too thin - we can approximate it!
      begin
        DelPoint(I + 1); // so delete middle point
        Finished := False;
      end;
      Inc(I);
    end;
  end;
end;

end.
