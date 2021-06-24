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

unit uChainAction;

interface

uses
  Vivace.Base,
  Vivace.Game,
  Vivace.Actor,
  Vivace.Color,
  Vivace.Math,
  Vivace.Bitmap,
  Vivace.Starfield,
  uCommon;

const
  // scene
  SCN_COUNT  = 2;
  SCN_CIRCLE = 0;
  SCN_EXPLO  = 1;

  // circle
  SHRINK_FACTOR = 0.65;

  CIRCLE_SCALE = 0.125;
  CIRCLE_SCALE_SPEED   = 0.95;

  CIRCLE_EXP_SCALE_MIN = 0.05;
  CIRCLE_EXP_SCALE_MAX = 0.49;

  CIRCLE_MIN_COLOR = 64;
  CIRCLE_MAX_COLOR = 255;

  CIRCLE_COUNT = 80;

type
{ TCommonEntity }
  TCommonEntity = class(TEntityActor)
  public
    constructor Create; override;
    procedure OnCollide(aActor: TActor; aHitPos: TVector); override;
    function  Collide(aActor: TActor; var aHitPos: TVector): Boolean; override;
  end;

{ TCircle }
  TCircle = class(TCommonEntity)
  protected
    FColor: TColor;
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TActor; aHitPos: TVector); override;
    property Speed: Single read FSpeed;
  end;

  { TCircleExplosion }
  TCircleExplosion = class(TCommonEntity)
  protected
    FColor: array[0..1] of TColor;
    FState: Integer;
    FFade: Single;
    FSpeed: Single;
  public

    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(aX, aY: Single; aColor: TColor); overload;
    procedure Setup(aCircle: TCircle); overload;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TActor; aHitPos: TVector); override;
  end;

  { TChainActionDemo }
  TChainActionDemo = class(TBaseExample)
  protected
    FExplosions: Integer;
    FChainActive: Boolean;
    FMusic: Integer;
    FStarfield: TStarfield;
  public
    property Explosions: Integer read FExplosions write FExplosions;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
    procedure OnBeforeRenderScene(aSceneNum: Integer);
    procedure OnAfterRenderScene(aSceneNum: Integer);
    procedure SpawnCircle(aNum: Integer); overload;
    procedure SpawnCircle; overload;
    procedure SpawnExplosion(aX, aY: Single; aColor: TColor); overload;
    procedure SpawnExplosion(aCircle: TCircle); overload;
    procedure CheckCollision(aEntity: TEntityActor);
    procedure StartChain;
    procedure PlayLevel;
    function  ChainEnded: Boolean;
    function  LevelClear: Boolean;
  end;

var
  Game: TChainActionDemo = nil;


implementation

uses
  System.SysUtils,
  System.IOUtils,
  Vivace.External.Allegro,
  Vivace.Logger,
  Vivace.Common,
  Vivace.Engine,
  Vivace.Input,
  Vivace.Display;

{ TCommonEntity }
constructor TCommonEntity.Create;
begin
  inherited;
  CanCollide := True;
end;

procedure TCommonEntity.OnCollide(aActor: TActor; aHitPos: TVector);
begin
  inherited;
end;

function  TCommonEntity.Collide(aActor: TActor; var aHitPos: TVector): Boolean;
begin
  Result := False;

  if Overlap(aActor) then
  begin
    aHitPos := Entity.GetPos;
    Result := True;
  end;
end;

{ TCircle }
constructor TCircle.Create;
var
  ok: Boolean;
  VP: TRectangle;
  A: Single;
begin
  inherited;

  gEngine.Display.GetViewportSize(VP);

  Init(Game.Sprite, 0);
  Entity.SetShrinkFactor(SHRINK_FACTOR);
  Entity.SetScaleAbs(CIRCLE_SCALE);
  Entity.SetPosAbs(TMath.RandomRange(32, (VP.Width-1)-32),
    TMath.RandomRange(32, (VP.Width-1)-32));

  ok := False;
  repeat
    Sleep(1);
    FColor.Make(
      TMath.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      TMath.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      TMath.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      TMath.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR)
    );

    if FColor.Equal(BLACK) or
       FColor.Equal(WHITE) then
      continue;

    ok := True;
  until ok;

  ok := False;
  repeat
    Sleep(1);
    A := TMath.RandomRange(0, 359);
    if (Abs(A) >=90-10) and (Abs(A) <= 90+10) then continue;
    if (Abs(A) >=270-10) and (Abs(A) <= 270+10) then continue;

    ok := True;
  until ok;

  Entity.RotateAbs(A);
  Entity.SetColor(FColor);
  FSpeed := TMath.RandomRange(3*35, 7*35);
end;

destructor TCircle.Destroy;
begin
  inherited;
end;

procedure TCircle.OnUpdate(aDeltaTime: Double);
var
  V: TVector;
  VP: TRectangle;
  R: Single;
begin
  gEngine.Display.GetViewportSize(VP);

  Entity.Thrust(FSpeed * aDeltaTime);

  V := Entity.GetPos;

  R := Entity.GetRadius / 2;

  if V.x < -R then
    V.x := VP.Width-1
  else if V.x > (VP.Width-1)+R then
    V.x := -R;

  if V.y < -R then
    V.y := (VP.Height-1)
  else if V.y > (VP.Height-1)+R then
    V.y := -R;

  Entity.SetPosAbs(V.X, V.Y);
end;

procedure TCircle.OnRender;
begin
  inherited;
end;

procedure TCircle.OnCollide(aActor: TActor; aHitPos: TVector);
var
  LPos: TVector;
begin
  Terminated := True;
  LPos := Entity.GetPos;
  Game.SpawnExplosion(LPos.X, LPos.Y, FColor);
  Game.Explosions := Game.Explosions + 1;
end;


{ TCircleExplosion }
constructor TCircleExplosion.Create;
begin
  inherited;
  Init(Game.Sprite, 0);
  Entity.SetShrinkFactor(SHRINK_FACTOR);
  Entity.SetScaleAbs(CIRCLE_SCALE);
  FState := 0;
  FFade := 0;
  FSpeed := 0;
end;

destructor TCircleExplosion.Destroy;
begin
  inherited;
end;

procedure TCircleExplosion.Setup(aX, aY: Single; aColor: TColor);
begin
  FColor[0] := aColor;
  FColor[1] := aColor;
  Entity.SetPosAbs(aX, aY);
end;
procedure TCircleExplosion.Setup(aCircle: TCircle);
var
  LPos: TVector;
begin
  LPos := aCircle.Entity.GetPos;
  Setup(LPos.X, LPos.Y, aCircle.Entity.GetColor);
  Entity.RotateAbs(aCircle.Entity.GetAngle);
  FSpeed := aCircle.Speed;
end;

procedure TCircleExplosion.OnUpdate(aDeltaTime: Double);
begin
  Entity.Thrust(FSpeed*aDeltaTime);

  case FState of
    0: // expand
    begin
      Entity.SetScaleRel(CIRCLE_SCALE_SPEED*aDeltaTime);
      if Entity.GetScale > CIRCLE_EXP_SCALE_MAX then
      begin
        FState := 1;
      end;
      Entity.SetColor(FColor[0]);
    end;

    1: // contract
    begin
      Entity.SetScaleRel(-CIRCLE_SCALE_SPEED*aDeltaTime);
      FFade := CIRCLE_SCALE_SPEED*aDeltaTime / Entity.GetScale;
      if Entity.GetScale < CIRCLE_EXP_SCALE_MIN then
      begin
        FState := 2;
        FFade := 1.0;
        Terminated := True;
      end;
      //C := Engine.Color.Fade(FColor[0], FColor[1], FFade);
      //Entity.SetColor(C);
    end;

    2: // kill
    begin
      Terminated := True;
    end;

  end;

  Game.CheckCollision(Self);
end;

procedure TCircleExplosion.OnRender;
begin
  inherited;
end;

procedure TCircleExplosion.OnCollide(aActor: TActor; aHitPos: TVector);
begin
end;

{ TChainActionDemo }
constructor TChainActionDemo.Create;
begin
  inherited;
  Game := Self;
end;

destructor TChainActionDemo.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TChainActionDemo.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;
  aConfig.DisplayTitle := cExampleTitle + 'ChainAction Demo';
  aConfig.DisplayClearColor := BLACK;
end;

procedure TChainActionDemo.OnLoad;
begin
  inherited;
end;

procedure TChainActionDemo.OnExit;
begin
  inherited;
end;

procedure TChainActionDemo.OnStartup;
var
  Page: Integer;
  Group: Integer;
begin
  inherited;

  // init circle sprite
  Page := Sprite.LoadPage('arc/bitmaps/sprites/light.png', @COLORKEY);
  Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(Page, Group, 0, 0, 256, 256);

  // init music
  FMusic := gEngine.Audio.LoadMusic('arc/audio/music/song06.ogg');
  gEngine.Audio.PlayMusic(FMusic, 1.0, True);

  // init starfield
  FStarfield := TStarfield.Create;

  Scene.Alloc(SCN_COUNT);
  PlayLevel;
end;

procedure TChainActionDemo.OnShutdown;
begin
  FreeAndNil(FStarfield);
  gEngine.Audio.UnloadMusic(FMusic);

  inherited;
end;

procedure TChainActionDemo.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  // start  new level
  if gEngine.Input.KeyboardPressed(KEY_SPACE) then
  begin
    if LevelClear then
      PlayLevel;
  end;

  // start chain reaction
  if gEngine.Input.MousePressed(MOUSE_BUTTON_LEFT) then
  begin
    if ChainEnded then
      StartChain;
  end;

  FStarfield.Update(aDeltaTime);

  // update scene
  Scene.Update([], aDeltaTime);
end;

procedure TChainActionDemo.OnRender;
begin
  FStarfield.Render;
  Scene.Render([], OnBeforeRenderScene, OnAfterRenderScene);
  inherited;
end;

procedure TChainActionDemo.OnRenderHUD;
var
  VP: TRectangle;
  x: Single;
  C: TColor;
begin
  inherited;

  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, YELLOW, haLeft, 'Circles:    %d', [Scene[SCN_CIRCLE].Count]);

  gEngine.Display.GetViewportSize(vp);
  x := vp.Width / 2;

  if ChainEnded and (not LevelClear) then
    C := WHITE
  else
    C := DIMWHITE;

  Font.Print(x, 120, C, haCenter, 'Click mouse to start chain reaction', []);

  if LevelClear then
  begin
    Font.Print(x, 120+21, ORANGE, haCenter, 'Press SPACE to start new level', []);
  end;
end;

procedure TChainActionDemo.OnBeforeRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      gEngine.Display.SetBlendMode(bmAdditiveAlpha);
    end;
  end;
end;

procedure TChainActionDemo.OnAfterRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      gEngine.Display.RestoreDefaultBlendMode;
    end;
  end;
end;

procedure TChainActionDemo.SpawnCircle(aNum: Integer);
var
  I: Integer;
begin
  for I := 0 to aNum - 1 do
    Scene[SCN_CIRCLE].Add(TCircle.Create);
end;

procedure TChainActionDemo.SpawnCircle;
begin
  SpawnCircle(TMath.RandomRange(10, 40));
end;

procedure TChainActionDemo.SpawnExplosion(aX, aY: Single; aColor: TColor);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aX, aY, aColor);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainActionDemo.SpawnExplosion(aCircle: TCircle);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aCircle);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainActionDemo.CheckCollision(aEntity: TEntityActor);
begin
  Scene[SCN_CIRCLE].CheckCollision([], aEntity);
end;

procedure TChainActionDemo.StartChain;
begin
  if not FChainActive then
  begin
    SpawnExplosion(MousePos.X, MousePos.Y, WHITE);
    FChainActive := True;
  end;
end;

procedure TChainActionDemo.PlayLevel;
begin
  Scene.ClearAll;
  SpawnCircle(CIRCLE_COUNT);
  FChainActive := False;
  FExplosions := 0;
end;

function  TChainActionDemo.ChainEnded: Boolean;
begin
  Result := True;
  if FChainActive then
  begin
    Result := Boolean(Scene[SCN_EXPLO].Count = 0);
    if Result  then
      FChainActive := False;
  end;
end;

function  TChainActionDemo.LevelClear: Boolean;
begin
  Result := Boolean(Scene[SCN_CIRCLE].Count = 0);
end;



end.
