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

unit Vivace.Sprite;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math,
  Vivace.Bitmap,
  Vivace.Color;

type

  { TSpriteImageRegion }
  PSpriteImageRegion = ^TSpriteImageRegion;
  TSpriteImageRegion = record
    Rect: TRectangle;
    Page: Integer;
  end;

  { TSpriteGroup }
  PSpriteGroup = ^TSpriteGroup;
  TSpriteGroup = record
    Image: array of TSpriteImageRegion;
    Count: Integer;
    PolyPoint: Pointer;
  end;

  { TSprite }
  TSprite = class(TBaseObject)
  protected
    FBitmap: array of TBitmap;
    FGroup: array of TSpriteGroup;
    FPageCount: Integer;
    FGroupCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;
    function LoadPage(aFilename: string; aColorKey: PColor): Integer;

    function AddGroup: Integer;
    function GetGroupCount: Integer;

    function AddImageFromRect(aPage: Integer; aGroup: Integer; aRect: TRectangle): Integer;
    function AddImageFromGrid(aPage: Integer; aGroup: Integer; aGridX: Integer; aGridY: Integer; aGridWidth: Integer; aGridHeight: Integer): Integer;

    function GetImageCount(aGroup: Integer): Integer;
    function GetImageWidth(aNum: Integer; aGroup: Integer): Single;
    function GetImageHeight(aNum: Integer; aGroup: Integer): Single;
    function GetImageTexture(aNum: Integer; aGroup: Integer): TBitmap;
    function GetImageRect(aNum: Integer; aGroup: Integer): TRectangle;

    procedure DrawImage(aNum: Integer; aGroup: Integer; aX: Single; aY: Single; aOrigin: PVector; aScale: PVector; aAngle: Single; aColor: TColor; aHFlip: Boolean; aVFlip: Boolean; aDrawPolyPoint: Boolean);

    function GroupPolyPoint(aGroup: Integer): Pointer;
    procedure GroupPolyPointTrace(aGroup: Integer; aMju: Single=6; aMaxStepBack: Integer=12; aAlphaThreshold: Integer=70; aOrigin: PVector=nil);
    function GroupPolyPointCollide(aNum1: Integer; aGroup1: Integer;
      aX1: Single; aY1: Single; aScale1: Single; aAngle1: Single;
      aOrigin1: PVector; aHFlip1: Boolean; aVFlip1: Boolean; aSprite2: TSprite;
      aNum2: Integer; aGroup2: Integer; aX2: Single; aY2: Single;
      aScale2: Single; aAngle2: Single; aOrigin2: PVector; aHFlip2: Boolean;
      aVFlip2: Boolean; aShrinkFactor: Single; var aHitPos: TVector): Boolean;
    function GroupPolyPointCollidePoint(aNum: Integer; aGroup: Integer;
      aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PVector;
      aHFlip: Boolean; aVFlip: Boolean; aShrinkFactor: Single;
      var aPoint: TVector): Boolean;
  end;

implementation

uses
  Vivace.Utils,
  Vivace.Collision,
  Vivace.PolyPoint,
  Vivace.Engine;

{ TSprite }
procedure TSprite.Clear;
var
  I: Integer;
begin
  if FBitmap <> nil then
  begin
    // free group data
    for I := 0 to FGroupCount - 1 do
    begin
      // free image array
      FGroup[I].Image := nil;

      // free polypoint
      FreeAndNil(FGroup[I].PolyPoint);
    end;

    // free page
    for I := 0 to FPageCount - 1 do
    begin
      if Assigned(FBitmap[I]) then
      begin
        FreeAndNil(FBitmap[I]);
      end;
    end;

    FBitmap := nil;
    FGroup := nil;
    FPageCount := 0;
    FGroupCount := 0;
  end;
end;

constructor TSprite.Create;
begin
  inherited;
  FBitmap := nil;
  FGroup := nil;
  FPageCount := 0;
  FGroupCount := 0;
end;

destructor TSprite.Destroy;
begin
  Clear;
  inherited;
end;

function TSprite.LoadPage(aFilename: string; aColorKey: PColor): Integer;
begin
  Result := FPageCount;
  Inc(FPageCount);
  SetLength(FBitmap, FPageCount);
  FBitmap[Result] := TBitmap.Create;
  FBitmap[Result].Load(aFilename, aColorKey);
end;

function TSprite.AddGroup: Integer;
begin
  Result := FGroupCount;
  Inc(FGroupCount);
  SetLength(FGroup, FGroupCount);
  FGroup[Result].PolyPoint := TPolyPoint.Create;
end;

function TSprite.GetGroupCount: Integer;
begin
  Result := FGroupCount;
end;

function TSprite.AddImageFromRect(aPage: Integer; aGroup: Integer;
  aRect: TRectangle): Integer;
begin
  Result := FGroup[aGroup].Count;
  Inc(FGroup[aGroup].Count);
  SetLength(FGroup[aGroup].Image, FGroup[aGroup].Count);

  FGroup[aGroup].Image[Result].Rect.X := aRect.X;
  FGroup[aGroup].Image[Result].Rect.Y := aRect.Y;
  FGroup[aGroup].Image[Result].Rect.Width := aRect.Width;
  FGroup[aGroup].Image[Result].Rect.Height := aRect.Height;
  FGroup[aGroup].Image[Result].Page := aPage;
end;

function TSprite.AddImageFromGrid(aPage: Integer; aGroup: Integer;
  aGridX: Integer; aGridY: Integer; aGridWidth: Integer;
  aGridHeight: Integer): Integer;
begin
  Result := FGroup[aGroup].Count;
  Inc(FGroup[aGroup].Count);
  SetLength(FGroup[aGroup].Image, FGroup[aGroup].Count);

  FGroup[aGroup].Image[Result].Rect.X := aGridWidth * aGridX;
  FGroup[aGroup].Image[Result].Rect.Y := aGridHeight * aGridY;
  FGroup[aGroup].Image[Result].Rect.Width := aGridWidth;
  FGroup[aGroup].Image[Result].Rect.Height := aGridHeight;
  FGroup[aGroup].Image[Result].Page := aPage;
end;

function TSprite.GetImageCount(aGroup: Integer): Integer;
begin
  Result := FGroup[aGroup].Count;
end;

function TSprite.GetImageWidth(aNum: Integer; aGroup: Integer): Single;
begin
  Result := FGroup[aGroup].Image[aNum].Rect.Width;
end;

function TSprite.GetImageHeight(aNum: Integer; aGroup: Integer): Single;
begin
  Result := FGroup[aGroup].Image[aNum].Rect.Height;
end;

function TSprite.GetImageTexture(aNum: Integer; aGroup: Integer): TBitmap;
begin
  Result := FBitmap[FGroup[aGroup].Image[aNum].Page];
end;

procedure TSprite.DrawImage(aNum: Integer; aGroup: Integer; aX: Single;
  aY: Single; aOrigin: PVector; aScale: PVector; aAngle: Single; aColor: TColor;
  aHFlip: Boolean; aVFlip: Boolean; aDrawPolyPoint: Boolean);
var
  PageNum: Integer;
  RectP: PRectangle;
  oxy: TVector;
begin
  RectP := @FGroup[aGroup].Image[aNum].Rect;
  PageNum := FGroup[aGroup].Image[aNum].Page;
  FBitmap[PageNum].Draw(aX, aY, RectP, aOrigin, aScale, aAngle, aColor,
    aHFlip, aVFlip);

  if aDrawPolyPoint then
  begin
    oxy.X := 0;
    oxy.Y := 0;
    if aOrigin <> nil then
    begin
      oxy.X := FGroup[aGroup].Image[aNum].Rect.Width;
      oxy.Y := FGroup[aGroup].Image[aNum].Rect.Height;

      oxy.X := Round(oxy.X * aOrigin.X);
      oxy.Y := Round(oxy.Y * aOrigin.Y);
    end;
    TPolyPoint(FGroup[aGroup].PolyPoint).Render(aNum, aX, aY, aScale.X, aAngle,
      YELLOW, @oxy, aHFlip, aVFlip);
  end;
end;

function TSprite.GetImageRect(aNum: Integer; aGroup: Integer): TRectangle;
begin
  Result := FGroup[aGroup].Image[aNum].Rect;
end;

function TSprite.GroupPolyPoint(aGroup: Integer): Pointer;
begin
  Result := FGroup[aGroup].PolyPoint;
end;

procedure TSprite.GroupPolyPointTrace(aGroup: Integer; aMju: Single = 6;
  aMaxStepBack: Integer = 12; aAlphaThreshold: Integer = 70;
  aOrigin: PVector = nil);
begin
  TPolyPoint(FGroup[aGroup].PolyPoint).TraceFromSprite(Self, aGroup, aMju,
    aMaxStepBack, aAlphaThreshold, aOrigin);
end;

function TSprite.GroupPolyPointCollide(aNum1: Integer; aGroup1: Integer;
  aX1: Single; aY1: Single; aScale1: Single; aAngle1: Single; aOrigin1: PVector;
  aHFlip1: Boolean; aVFlip1: Boolean; aSprite2: TSprite; aNum2: Integer;
  aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single; aAngle2: Single;
  aOrigin2: PVector; aHFlip2: Boolean; aVFlip2: Boolean; aShrinkFactor: Single;
  var aHitPos: TVector): Boolean;
var
  PP1, PP2: TPolyPoint;
  Radius1: Integer;
  Radius2: Integer;
  Origini1, Origini2: TVector;
  Origini1P, Origini2P: PVector;
begin
  Result := False;

  if (aSprite2 = nil) then
    Exit;

  PP1 := FGroup[aGroup1].PolyPoint;
  PP2 := aSprite2.FGroup[aGroup2].PolyPoint;

  if not PP1.Valid(aNum1) then
    Exit;
  if not PP2.Valid(aNum2) then
    Exit;

  Radius1 := Round(FGroup[aGroup1].Image[aNum1].Rect.Height + FGroup[aGroup1]
    .Image[aNum1].Rect.Width) div 2;

  Radius2 := Round(aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Height +
    aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Width) div 2;

  if not TCollision.RadiusOverlap(Radius1, aX1, aY1, Radius2, aX2, aY2, aShrinkFactor) then
    Exit;

  Origini2.X := aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Width;
  Origini2.Y := aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Height;

  Origini1P := nil;
  if aOrigin1 <> nil then
  begin
    Origini1.X := Round(FGroup[aGroup1].Image[aNum1].Rect.Width * aOrigin1.X);
    Origini1.Y := Round(FGroup[aGroup1].Image[aNum1].Rect.Height * aOrigin1.Y);
    Origini1P := @Origini1;
  end;

  Origini2P := nil;
  if aOrigin2 <> nil then
  begin
    Origini2.X := Round(aSprite2.FGroup[aGroup2].Image[aNum2]
      .Rect.Width * aOrigin2.X);
    Origini2.Y := Round(aSprite2.FGroup[aGroup2].Image[aNum2]
      .Rect.Height * aOrigin2.Y);
    Origini2P := @Origini2;
  end;

  Result := PP1.Collide(aNum1, aGroup1, aX1, aY1, aScale1, aAngle1, Origini1P,
    aHFlip1, aVFlip1, PP2, aNum2, aGroup2, aX2, aY2, aScale2, aAngle2,
    Origini2P, aHFlip2, aVFlip2, aHitPos);
end;

function TSprite.GroupPolyPointCollidePoint(aNum: Integer; aGroup: Integer;
  aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PVector;
  aHFlip: Boolean; aVFlip: Boolean; aShrinkFactor: Single;
  var aPoint: TVector): Boolean;
var
  PP1: TPolyPoint;
  Radius1: Integer;
  Radius2: Integer;
  Origini1: TVector;
  Origini1P: PVector;

begin
  Result := False;

  PP1 := FGroup[aGroup].PolyPoint;

  if not PP1.Valid(aNum) then
    Exit;

  Radius1 := Round(FGroup[aGroup].Image[aNum].Rect.Height + FGroup[aGroup].Image
    [aNum].Rect.Width) div 2;

  Radius2 := 2;

  if not TCollision.RadiusOverlap(Radius1, aX, aY, Radius2, aPoint.X, aPoint.Y,
    aShrinkFactor) then
    Exit;

  Origini1P := nil;
  if aOrigin <> nil then
  begin
    Origini1.X := FGroup[aGroup].Image[aNum].Rect.Width * aOrigin.X;
    Origini1.Y := FGroup[aGroup].Image[aNum].Rect.Height * aOrigin.Y;
    Origini1P := @Origini1;
  end;

  Result := PP1.CollidePoint(aNum, aGroup, aX, aY, aScale, aAngle, Origini1P,
    aHFlip, aVFlip, aPoint);
end;

end.
