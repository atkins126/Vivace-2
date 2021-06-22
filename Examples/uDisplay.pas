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

unit uDisplay;

interface

uses
  Vivace.Game,
  uCommon;

type

  { TDisplayBasic }
  TDisplayBasic = class(TBaseExample)
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
  end;

  { TDisplayToggleFullscreen }
  TDisplayToggleFullscreen = class(TBaseExample)
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRenderHUD; override;
  end;

  { TDisplayPrimitives }
  TDisplayPrimitives = class(TBaseExample)
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

implementation

uses
  Vivace.Engine,
  Vivace.Input,
  Vivace.Color,
  Vivace.Common,
  Vivace.Math;

{ TDisplayBasic }
procedure TDisplayBasic.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Basic Display';
end;

{ TDisplayToggleFullscreen }
procedure TDisplayToggleFullscreen.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Toggle Fullscreen';
end;

procedure TDisplayToggleFullscreen.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if gEngine.Input.KeyboardPressed(KEY_F) then
    gEngine.Display.ToggleFullscreen;

  if gEngine.Input.KeyboardPressed(KEY_A) then
  begin
    gEngine.Display.ResetTransform;
    gEngine.Display.SetTransformAngle(1);
  end;
end;

procedure TDisplayToggleFullscreen.OnRenderHUD;
begin
  inherited;

  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, GREEN, haLeft, 'F       - Toggle fullscreen', []);
end;


{ TDisplayPrimitives }
procedure TDisplayPrimitives.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Primitives';
end;

procedure TDisplayPrimitives.OnUpdate(aDeltaTime: Double);
begin
  inherited;

end;

procedure TDisplayPrimitives.OnRender;
var
  LVSize: TRectangle;
begin
  inherited;

  gEngine.Display.GetViewportSize(LVSize);

  gEngine.Display.DrawLine(50, 70, LVSize.Width-50, 70, WHITE, 5);

  gEngine.Display.DrawRectangle(50, 100, 50, 50, 5, GREEN);
  gEngine.Display.DrawFilledRectangle(150-2, 100-2, 50+4, 50+4, DARKOLIVEGREEN);

  gEngine.Display.DrawCircle(275, 125, 25, 5, DARKSLATEBLUE);
  gEngine.Display.DrawFilledCircle(275+95, 125, 25+3, CADETBLUE);

  gEngine.Display.DrawTriangle(465, 100, 465+25, 100+50, 465-25, 100+50, 5, ORANGERED);
  gEngine.Display.DrawFilledTriangle(465+95, 100-3, 465+25+95, 100+50+3, (465-25)+95, 100+50+3, DARKORANGE);

end;

procedure TDisplayPrimitives.OnRenderHUD;
begin
  inherited;

end;



end.
