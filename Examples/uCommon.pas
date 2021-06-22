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

unit uCommon;

interface

uses
  Vivace.Game,
  Vivace.Font,
  Vivace.Math,
  Vivace.Sprite;

const
  cArchiveFilename   = 'Data.arc';
  cVivace            = 'Vivace';
  cDisplayTitle      = cVivace + ': Examples';
  cExampleTitle      = cVivace + ': ';
  cVivaceURL         = 'https://vivace.dev';

type

  { TBaseExample }
  TBaseExample = class(TCustomGameApp)
  protected
    FMonoFont: TFont;
    FPropFont: TFont;
    FSmallFont: TFont;
    FSprite: TSprite;
  public
    MousePos: TVector;
    property Sprite: TSprite read FSprite;
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    function  OnStartupDialogShow: Boolean; override;
    procedure OnStartupDialogMore; override;
    function  OnStartupDialogRun: Boolean; override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
    procedure OnUpdate(aDeltaTime: Double); override;
  end;

implementation

uses
  System.SysUtils,
  Vivace.Common,
  Vivace.Color,
  Vivace.Engine,
  Vivace.Input;

procedure TBaseExample.OnSetConfig(var aConfig: TGameConfig);
begin
  // archive is already mounted
  aConfig.ArchiveFilename := '';
end;

procedure TBaseExample.OnLoad;
begin
  inherited;
  FSprite := TSprite.Create;
end;

procedure TBaseExample.OnExit;
begin
  FreeAndNil(FSprite);
  inherited;
end;

procedure TBaseExample.OnStartup;
begin
  inherited;
  FMonoFont := TFont.Create;
  FPropFont := TFont.Create;
  FSmallFont := TFont.Create;
  FSmallFont.Load(12);
end;

procedure TBaseExample.OnShutdown;
begin
  FreeAndNil(FSmallFont);
  FreeAndNil(FPropFont);
  FreeAndNil(FMonoFont);
  inherited;
end;

function  TBaseExample.OnStartupDialogShow: Boolean;
begin
  Result := False;
end;

procedure TBaseExample.OnStartupDialogMore;
begin
  inherited;
end;

function  TBaseExample.OnStartupDialogRun: Boolean;
begin
  Result := False;
end;

procedure TBaseExample.OnRender;
begin
  inherited;
end;

procedure TBaseExample.OnRenderHUD;
var
  LWidth, LHeight: Integer;
  LColor: TColor;
begin
  inherited;
  //Font.Print(HudPos.X, HudPos.Y, HudPos.Z, GREEN, haLeft, '`       - Command Console', []);
  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, GREEN, haLeft, 'ESC     - Quit', []);

  gEngine.Display.GetViewportSize(nil, nil, @LWidth, @LHeight);
  LColor.Make(64, 64, 64, 64);
  FSmallFont.Print(LWidth/2, LHeight-(FSmallFont.GetLineHeight+3) , LColor, haCenter, 'Vivace™ Game Toolkit - vivace.dev', []);
end;

procedure TBaseExample.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  gEngine.Input.MouseGetInfo(MousePos);

  if gEngine.Input.KeyboardPressed(KEY_ESCAPE) then
    gEngine.SetTerminate(True);

  if gEngine.Input.KeyboardPressed(KEY_F11) then
    gEngine.Display.ToggleFullscreen;

end;



end.
