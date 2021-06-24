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

unit uBitmap;

interface

uses
  Vivace.Game,
  Vivace.Sprite,
  Vivace.Entity,
  Vivace.Math,
  Vivace.Display,
  Vivace.Bitmap,
  Vivace.Color,
  uCommon;

type

  { TBitmapColorKeyTransparency }
  TBitmapColorKeyTransparency = class(TBaseExample)
  protected
    FBitmap: array[0..1] of TBitmap;
    FCenterPos: TVector;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

  { TBitmapTrueTransparency }
  TBitmapTrueTransparency = class(TBaseExample)
  protected
    FBitmap: TBitmap;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

  { TBitmapTiled }
  TBitmapTiled = class(TBaseExample)
  protected
    FTexture: array[0..3] of TBitmap;
    FSpeed: array[0..3] of Single;
    FPos: array[0..3] of TVector;
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
  System.IOUtils,
  Vivace.External.Allegro,
  Vivace.Logger,
  Vivace.Common,
  Vivace.Engine;

  { TBitmapBasic }
procedure TBitmapColorKeyTransparency.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;
  aConfig.DisplayTitle := cExampleTitle + 'Bitmap ColorKey Transparency';
end;

procedure TBitmapColorKeyTransparency.OnStartup;
begin
  inherited;

  // load a bitmap and use colorkey transparancy
  FBitmap[0] := TBitmap.LoadBitmap('arc/bitmaps/sprites/circle00.png', nil);
  FBitmap[1] := TBitmap.LoadBitmap('arc/bitmaps/sprites/circle00.png', @COLORKEY);

  FCenterPos.Assign(Config.DisplayWidth/2, Config.DisplayHeight/2);
end;

procedure TBitmapColorKeyTransparency.OnShutdown;
begin
  FreeAndNil(FBitmap[1]);
  FreeAndNil(FBitmap[0]);
  inherited;
end;

procedure TBitmapColorKeyTransparency.OnUpdate(aDeltaTime: Double);
begin
  inherited;
end;

procedure TBitmapColorKeyTransparency.OnRender;
begin
  inherited;

  // draw colorkey transparancy bitmap
  FBitmap[0].Draw(FCenterPos.X, FCenterPos.Y-100, 1, 0, WHITE, haCenter, vaCenter);
  FBitmap[1].Draw(FCenterPos.X, FCenterPos.Y+100, 1, 0, WHITE, haCenter, vaCenter);


  Font.Print(FCenterPos.X, FCenterPos.Y-35, ORANGE, haCenter, 'with colorkey', []);
  Font.Print(FCenterPos.X, FCenterPos.Y+163, ORANGE, haCenter, 'colorkey removed', []);
end;

procedure TBitmapColorKeyTransparency.OnRenderHUD;
begin
  inherited;
end;

{ TBitmapTrueTransparency }
procedure TBitmapTrueTransparency.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;
  aConfig.DisplayTitle := cExampleTitle + 'Bitmap True Transparency';
end;

procedure TBitmapTrueTransparency.OnStartup;
begin
  inherited;

  FBitmap := TBitmap.LoadBitmap('arc/bitmaps/sprites/vivace.png', nil);
end;

procedure TBitmapTrueTransparency.OnShutdown;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TBitmapTrueTransparency.OnUpdate(aDeltaTime: Double);
begin
  inherited;
end;

procedure TBitmapTrueTransparency.OnRender;
begin
  inherited;

  FBitmap.Draw(Config.DisplayWidth/2, Config.DisplayHeight/2, 1, 0, WHITE, haCenter, vaCenter);
  Font.Print(Config.DisplayWidth/2, (Config.DisplayHeight/2)+130, ORANGE, haCenter, 'true transparency', []);


end;

procedure TBitmapTrueTransparency.OnRenderHUD;
begin
  inherited;
end;


{ TBitmapTiled }
procedure TBitmapTiled.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;
  aConfig.DisplayTitle := cExampleTitle + 'Tiled Bitmap';
end;

procedure TBitmapTiled.OnStartup;
begin
  inherited;

  // Load bitmap images
  FTexture[0] := TBitmap.LoadBitmap('arc/bitmaps/backgrounds/space.png', nil);
  FTexture[1] := TBitmap.LoadBitmap('arc/bitmaps/backgrounds/nebula.png', @BLACK);
  FTexture[2] := TBitmap.LoadBitmap('arc/bitmaps/backgrounds/spacelayer1.png', @BLACK);
  FTexture[3] := TBitmap.LoadBitmap('arc/bitmaps/backgrounds/spacelayer2.png', @BLACK);

  // Set bitmap speeds
  FSpeed[0] := 0.3 * 30;
  FSpeed[1] := 0.5 * 30;
  FSpeed[2] := 1.0 * 30;
  FSpeed[3] := 2.0 * 30;

  // Clear pos
  FPos[0].Clear;
  FPos[1].Clear;
  FPos[2].Clear;
  FPos[3].Clear;

end;

procedure TBitmapTiled.OnShutdown;
var
  LI: Integer;
begin
  for LI := 0 to 3 do
    FreeAndNil(FTexture[LI]);

  inherited;
end;

procedure TBitmapTiled.OnUpdate(aDeltaTime: Double);
var
  LI: Integer;
begin
  inherited;

  // update bitmap position
  for LI := 0 to 3 do
  begin
    FPos[LI].Y := FPos[LI].Y + (FSpeed[LI] * aDeltaTime);
  end;
end;

procedure TBitmapTiled.OnRender;
var
  LI: Integer;
begin
  inherited;

  // render bitmaps
  for LI := 0 to 3 do
  begin
    if LI = 1 then
    begin
      gEngine.Display.SetBlendMode(bmAdditiveAlpha);
    end;
    FTexture[LI].DrawTiled(FPos[LI].X, FPos[LI].Y);
    if LI = 1 then gEngine.Display.RestoreDefaultBlendMode;
  end;
end;

procedure TBitmapTiled.OnRenderHUD;
begin
  inherited;
end;

end.
