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

unit Vivace.Game;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common,
  Vivace.Color,
  Vivace.ConfigFile,
  Vivace.Math,
  Vivace.Font;

type
  { TBaseGame }
  TBaseGame = class(TBaseObject)
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Run; virtual;
  end;

  { TCustomGame }
  TCustomGame = class(TBaseGame)
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Run; override;
    procedure OnLoad; virtual;
    procedure OnExit; virtual;
    procedure OnStartup; virtual;
    procedure OnShutdown; virtual;
    function  OnStartupDialogShow: Boolean; virtual;
    procedure OnStartupDialogMore; virtual;
    function  OnStartupDialogRun: Boolean; virtual;
    procedure OnProcessIMGUI; virtual;
    procedure OnDisplayOpenBefore; virtual;
    procedure OnDisplayOpenAfter; virtual;
    procedure OnDisplayCloseBefore; virtual;
    procedure OnDisplayCloseAfter; virtual;
    procedure OnDisplayReady(aReady: Boolean); virtual;
    procedure OnDisplayClear; virtual;
    procedure OnDisplayToggleFullscreen(aFullscreen: Boolean); virtual;
    procedure OnRender; virtual;
    procedure OnRenderHUD; virtual;
    procedure OnDisplayShow; virtual;
    procedure OnSpeechWord(const aWord: string; const aText: string); virtual;
    procedure OnUpdate(aDeltaTime: Double); virtual;
    procedure OnLuaReset; virtual;
  end;

  { TCustomGameClass }
  TCustomGameClass = class of TCustomGame;

  { TGameConfig }
  TGameConfig = record
    ConfigFilename: string;
    ArchiveFilename: string;
    DisplayWidth: Integer;
    DisplayHeight: Integer;
    DisplayFullscreen: Boolean;
    DisplayTitle: string;
    DisplayClearColor: TColor;
  end;

  { TCustomGameApp }
  TCustomGameApp = class(TCustomGame)
  protected
    FConfigFile: TConfigFile;
    FFont: TFont;
  public
    Config: TGameConfig;
    HudPos: TVector;

    property ConfigFile: TConfigFile read FConfigFile;
    property Font: TFont read FFont;

    constructor Create; override;
    destructor Destroy; override;
    procedure OnSetConfig(var aConfig: TGameConfig); virtual;
    procedure Run; override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnDisplayClear; override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
    procedure OnDisplayShow; override;
    procedure OnUpdate(aDeltaTime: Double); override;
  end;

// Routines
procedure RunGame(aGame: TCustomGameClass);

implementation

uses
  System.IOUtils,
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Logger;


// Routines
procedure RunGame(aGame: TCustomGameClass);
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    gEngine.Run(aGame);
  except
    on E: Exception do
      TLogger.Log(etException, '%s: %s', [E.ClassName, E.Message]);
  end;
end;


{ TBaseGame }
constructor TBaseGame.Create;
begin
  inherited;
end;

destructor TBaseGame.Destroy;
begin
  inherited;
end;

procedure TBaseGame.Run;
begin
end;


{ TCustomGame }
constructor TCustomGame.Create;
begin
  inherited;

end;

destructor TCustomGame.Destroy;
begin

  inherited;
end;

procedure TCustomGame.Run;
var
  LQuit: Boolean;
begin
  try
    OnLoad;
    if OnStartupDialogShow then
      begin
        LQuit := False;
        repeat
          case gEngine.StartupDialog.Show of
            sdsMore:
              begin
                OnStartupDialogMore;
              end;
            sdsRun:
              begin
                if OnStartupDialogRun then
                  gEngine.GameLoop;
              end;
            sdsQuit:
              begin
                LQuit := True;
              end;
          end;
        until LQuit;
      end
    else
      begin
        gEngine.GameLoop;
      end;
  finally
    OnExit;
  end;
end;

procedure TCustomGame.OnLoad;
begin
end;

procedure TCustomGame.OnExit;
begin
end;

procedure TCustomGame.OnStartup;
begin
end;

procedure TCustomGame.OnShutdown;
begin
end;

function  TCustomGame.OnStartupDialogShow: Boolean;
begin
  Result := False;
end;

procedure TCustomGame.OnStartupDialogMore;
begin
end;

function  TCustomGame.OnStartupDialogRun: Boolean;
begin
  Result := False;
end;

procedure TCustomGame.OnProcessIMGUI;
begin
end;

procedure TCustomGame.OnDisplayOpenBefore;
begin
end;

procedure TCustomGame.OnDisplayOpenAfter;
begin
end;

procedure TCustomGame.OnDisplayCloseBefore;
begin
end;

procedure TCustomGame.OnDisplayCloseAfter;
begin
end;

procedure TCustomGame.OnDisplayReady(aReady: Boolean);
begin
end;

procedure TCustomGame.OnDisplayClear;
begin
end;

procedure TCustomGame.OnDisplayToggleFullscreen(aFullscreen: Boolean);
begin
end;

procedure TCustomGame.OnRender;
begin
end;

procedure TCustomGame.OnRenderHUD;
begin
end;

procedure TCustomGame.OnDisplayShow;
begin
end;

procedure TCustomGame.OnSpeechWord(const aWord: string; const aText: string);
begin
end;

procedure TCustomGame.OnUpdate(aDeltaTime: Double);
begin
end;

procedure TCustomGame.OnLuaReset;
begin
end;


{ TCustomGameApp }
constructor TCustomGameApp.Create;
begin
  inherited;
end;

destructor TCustomGameApp.Destroy;
begin
  inherited;
end;

procedure TCustomGameApp.OnSetConfig(var aConfig: TGameConfig);
begin
end;

procedure TCustomGameApp.Run;
begin
  HudPos.Clear;
  HudPos.Assign(3, 3);

  Config.ConfigFilename := TPath.ChangeExtension(ParamStr(0), CFG_EXT);
  Config.ArchiveFilename := TPath.ChangeExtension(ParamStr(0), ARC_EXT);
  Config.DisplayWidth := 800;
  Config.DisplayHeight := 500;
  Config.DisplayFullscreen := False;
  Config.DisplayTitle := 'CustomGameApp';
  Config.DisplayClearColor.Make(22, 27, 34, 255);
  OnSetConfig(Config);
  inherited;
end;

procedure TCustomGameApp.OnLoad;
begin
  inherited;

  // open configfile
  FConfigFile := TConfigFile.Create;
  FConfigfile.Open(Config.ConfigFilename);

  // mount achive if exists
  if TFile.Exists(Config.ArchiveFilename) then
  begin
    gEngine.MountArchive(Config.ArchiveFilename);
  end;
end;

procedure TCustomGameApp.OnExit;
begin
  // unmount archive if exist
  if TFile.Exists(Config.ArchiveFilename) then
  begin
    gEngine.UnmountArchive(Config.ArchiveFilename);
  end;

  // close configfile
  FreeAndNil(FConfigFile);

  inherited;
end;

procedure TCustomGameApp.OnStartup;
begin
  inherited;

  // open display
  gEngine.Display.Open(Config.DisplayWidth, Config.DisplayHeight, Config.DisplayFullscreen, Config.DisplayTitle);

  // init font
  FFont := TFont.Create;
  FFont.Load(16);
end;

procedure TCustomGameApp.OnShutdown;
begin
  // free font
  FreeAndNil(FFont);

  // close display
  gEngine.Display.Close;

  inherited;
end;

procedure TCustomGameApp.OnDisplayClear;
begin
  // clear display
  gEngine.Display.Clear(Config.DisplayClearColor);
end;

procedure TCustomGameApp.OnRender;
begin
  inherited;
end;

procedure TCustomGameApp.OnRenderHUD;
begin
  inherited;

  HudPos.Assign(3, 3, 0);
  FFont.Print(HudPos.X, HudPos.Y, HudPos.Z, WHITE, haLeft, 'fps %d', [gEngine.GetFrameRate]);
end;

procedure TCustomGameApp.OnDisplayShow;
begin
  inherited;

  gEngine.Display.Show;
end;

procedure TCustomGameApp.OnUpdate(aDeltaTime: Double);
begin
  inherited;

end;

end.
