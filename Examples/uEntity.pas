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

unit uEntity;

interface

uses
  Vivace.Game,
  Vivace.Sprite,
  Vivace.Entity,
  Vivace.Math,
  Vivace.Display,
  uCommon;

type

  { TEntityBasic }
  TEntityBasic = class(TBaseExample)
  protected
    FShip: TEntity;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

  { TEntityBlendMode }
  TEntityBlendMode = class(TBaseExample)
  protected
    FBlendMode: Boolean;
    FExplo: TEntity;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

  { TEntityPolyPointCollision }
  TEntityPolyPointCollision = class(TBaseExample)
  protected
    FBoss: TEntity;
    FFigure: TEntity;
    FFigureAngle: Single;
    FCollide: Boolean;
    FHitPos: TVector;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

  { TEntityPolyPointCollisionPoint }
  TEntityPolyPointCollisionPoint = class(TBaseExample)
  protected
    FFigure: TEntity;
    FFigureAngle: Single;
    FCollide: Boolean;
    FHitPos: TVector;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

implementation

uses
  System.SysUtils,
  Vivace.Engine,
  Vivace.Color,
  Vivace.Input,
  Vivace.Common,
  Vivace.Utils;


{ TEntityBasic }
procedure TEntityBasic.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Basic Entity';
end;

procedure TEntityBasic.OnStartup;
begin
  inherited;

  // init ship sprite
  Sprite.LoadPage('arc/bitmaps/sprites/ship.png', nil);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 0, 64, 64);

  // init ship entity
  FShip := TEntity.Create;
  FShip.Init(Sprite, 0);
  FShip.SetFrameFPS(17);
  FShip.SetScaleAbs(1);
  FShip.SetPosAbs(Config.DisplayWidth/2, Config.DisplayHeight/2);
  FShip.SetFrameRange(1, 3);
end;

procedure TEntityBasic.OnShutdown;
begin
  FreeAndNil(FShip);

  inherited;
end;

procedure TEntityBasic.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  FShip.NextFrame;
end;

procedure TEntityBasic.OnRender;
begin
  inherited;

  FShip.Render(0, 0);
end;

procedure TEntityBasic.OnRenderHUD;
begin
  inherited;

end;


{ TEntityPolyPointCollision }
procedure TEntityPolyPointCollision.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Entity Collision';
end;

procedure TEntityPolyPointCollision.OnStartup;
begin
  inherited;

  // init boss sprite
  Sprite.LoadPage('arc/bitmaps/sprites/boss.png', @COLORKEY);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 128, 128);
  Sprite.AddImageFromGrid(0, 0, 1, 0, 128, 128);
  Sprite.AddImageFromGrid(0, 0, 0, 1, 128, 128);

  // init figure sprite
  Sprite.LoadPage('arc/bitmaps/sprites/figure.png', @COLORKEY);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(1, 1, 0, 0, 128, 128);

  // init boss entity
  FBoss := TEntity.Create;
  FBoss.Init(Sprite, 0);
  FBoss.SetFrameFPS(14);
  FBoss.SetScaleAbs(1);
  FBoss.SetPosAbs(Config.DisplayWidth/2, (Config.DisplayHeight/2)-100);
  FBoss.TracePolyPoint(6, 12, 70);
  FBoss.SetRenderPolyPoint(True);

  // init figure entity
  FFigure := TEntity.Create;
  FFigure.Init(Sprite, 1);
  FFigure.SetFrameFPS(17);
  FFigure.SetScaleAbs(1);
  FFigure.SetPosAbs(Config.DisplayWidth/2, Config.DisplayHeight/2);
  FFigure.TracePolyPoint(6, 12, 70);
  FFigure.SetRenderPolyPoint(True);
end;

procedure TEntityPolyPointCollision.OnShutdown;
begin
  FreeAndNil(FFigure);
  FreeAndNil(FBoss);

  inherited;
end;

procedure TEntityPolyPointCollision.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  FBoss.NextFrame;
  FBoss.ThrustToPos(30*50, 14*50, MousePos.X, MousePos.Y, 128, 32, 5*50, 0.001, aDeltaTime);
  if FBoss.CollidePolyPoint(FFigure, FHitPos) then
    FCollide := True
  else
    FCollide := False;

  FFigureAngle := FFigureAngle + (30.0 * aDeltaTime);
  TMath.ClipValue(FFigureAngle, 0, 359, True);
  FFigure.RotateAbs(FFigureAngle);
end;

procedure TEntityPolyPointCollision.OnRender;
begin
  inherited;

  FFigure.Render(0, 0);
  FBoss.Render(0, 0);
  if FCollide then gEngine.Display.DrawFilledRectangle(FHitPos.X, FHitPos.Y, 10, 10, RED);
end;

procedure TEntityPolyPointCollision.OnRenderHUD;
begin
  inherited;

end;


{ TEntityPolyPointCollisionPoint }
procedure TEntityPolyPointCollisionPoint.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Entity Collision Point';
end;

procedure TEntityPolyPointCollisionPoint.OnStartup;
begin
  inherited;

  // init figure sprite
  Sprite.LoadPage('arc/bitmaps/sprites/figure.png', @COLORKEY);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 128, 128);

  // init figure entity
  FFigure := TEntity.Create;
  FFigure.Init(Sprite, 0);
  FFigure.SetFrameFPS(17);
  FFigure.SetScaleAbs(1);
  FFigure.SetPosAbs(Config.DisplayWidth/2, Config.DisplayHeight/2);
  FFigure.TracePolyPoint(6, 12, 70);
  FFigure.SetRenderPolyPoint(True);
end;

procedure TEntityPolyPointCollisionPoint.OnShutdown;
begin
  FreeAndNil(FFigure);

  inherited;
end;

procedure TEntityPolyPointCollisionPoint.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  FHitPos.Assign(MousePos);

  if FFigure.CollidePolyPointPoint(FHitPos) then
    FCollide := True
  else
    FCollide := False;

  FFigureAngle := FFigureAngle + (30.0 * aDeltaTime);
  TMath.ClipValue(FFigureAngle, 0, 359, True);
  FFigure.RotateAbs(FFigureAngle);
end;

procedure TEntityPolyPointCollisionPoint.OnRender;
var
  LPos: TVector;
begin
  inherited;

  FFigure.Render(0, 0);
  if FCollide then
  begin
    LPos := FFigure.GetPos;
    Font.Print(LPos.X-64, LPos.Y-64, WHITE, haLeft, '(%3f,%3f)', [FHitPos.X, FHitPos.Y]);
    gEngine.Display.DrawFilledRectangle(FHitPos.X, FHitPos.Y, 10, 10, RED);
  end;
end;

procedure TEntityPolyPointCollisionPoint.OnRenderHUD;
begin
  inherited;

  Font.Print(Config.DisplayWidth/2, (Config.DisplayHeight/2) - 100, YELLOW, haCenter, 'Move mouse pointer over figure outline', []);
end;


{ TEntityBlendMode }
procedure TEntityBlendMode.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Entity Blend Mode';
end;

procedure TEntityBlendMode.OnStartup;
begin
  inherited;

  // init explosion sprite
  Sprite.LoadPage('arc/bitmaps/sprites/explosion.png', nil);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 0, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 1, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 2, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 3, 64, 64);

  // init explosion entity
  FExplo := TEntity.Create;
  FExplo.Init(Sprite, 0);
  FExplo.SetFrameFPS(14);
  FExplo.SetScaleAbs(1);
  FExplo.SetPosAbs(Config.DisplayWidth/2, Config.DisplayHeight/2);

  FBlendMode := False;
end;

procedure TEntityBlendMode.OnShutdown;
begin
  FreeAndNil(FExplo);

  inherited;
end;

procedure TEntityBlendMode.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if gEngine.Input.KeyboardPressed(KEY_B) then
  begin
    FBlendMode := not FBlendMode;
  end;

  FExplo.NextFrame;
end;

procedure TEntityBlendMode.OnRender;
begin
  inherited;

  if FBlendMode then gEngine.Display.SetBlendMode(bmAdditiveAlpha);
  FExplo.Render(0,0);
  gEngine.Display.RestoreDefaultBlendMode;
end;

procedure TEntityBlendMode.OnRenderHUD;
begin
  inherited;

  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, GREEN,  haLeft, 'B         - Toggle blending', []);
  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, YELLOW, haLeft, 'Blend:      %s', [cTrueFalseStr[FBlendMode]]);
end;




end.
