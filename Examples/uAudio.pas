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

unit uAudio;

interface

uses
  Vivace.Game,
  Vivace.Sprite,
  Vivace.Entity,
  Vivace.Math,
  Vivace.Display,
  Vivace.Font,
  uCommon;

type
  { TAudioMusic }
  TAudioMusic = class(TBaseExample)
  protected
    FFilename: string;
    FNum: Integer;
    FMusic: Integer;
    procedure Play(aNum: Integer; aVol: Single);
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

  { TAudioSound }
  TAudioSound = class(TBaseExample)
  protected
    FSamples: array[ 0..8 ] of Integer;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

  { TAudioPositional }
  TAudioPositional = class(TBaseExample)
  protected
    FSfx: Integer;
    FChan: Integer;
    FCenterPos: TVector;
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
  Vivace.Color,
  Vivace.Common,
  Vivace.Engine,
  Vivace.Input,
  Vivace.Audio;


{ TAudioMusic }
procedure TAudioMusic.Play(aNum: Integer; aVol: Single);
begin
  FFilename := Format('arc/audio/music/song%.*d.ogg', [2,aNum]);
  gEngine.Audio.UnloadMusic(FMusic);
  FMusic := gEngine.Audio.LoadMusic(FFilename);
  gEngine.Audio.PlayMusic(FMusic, aVol, True);
end;

procedure TAudioMusic.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Music Audio';
end;

procedure TAudioMusic.OnStartup;
begin
  inherited;

  FNum := 1;
  FFilename := '';
  FMusic := -1;
  Play(1, 1.0);
end;

procedure TAudioMusic.OnShutdown;
begin
  gEngine.Audio.UnloadMusic(FMusic);

  inherited;
end;

procedure TAudioMusic.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if gEngine.Input.KeyboardPressed(KEY_PGUP) then
  begin
    Inc(FNum);
    if FNum > 13 then
      FNum := 1;
    Play(FNum, 1.0);
  end
  else
  if gEngine.Input.KeyboardPressed(KEY_PGDN) then
  begin
    Dec(FNum);
    if FNum < 1 then
      FNum := 13;
    Play(FNum, 1.0);
  end
end;

procedure TAudioMusic.OnRender;
begin
  inherited;
end;

procedure TAudioMusic.OnRenderHUD;
begin
  inherited;

  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, GREEN, haLeft, 'PgUp/PgDn - Play sample', []);
  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, ORANGE, haLeft, 'Song:       %s', [TPath.GetFileName(FFilename)]);
end;


{ TAudioSound }
procedure TAudioSound.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Sound Audio';
end;

procedure TAudioSound.OnStartup;
var
  LI: Integer;
begin
  inherited;

  gEngine.Audio.SetChannelReserved(0, True);

  for LI := 0 to 5 do
  begin
    FSamples[LI] := gEngine.Audio.LoadSound(Format('arc/audio/sfx/samp%d.ogg', [LI]));
  end;

  FSamples[6] := gEngine.Audio.LoadSound('arc/audio/sfx/weapon_player.ogg');
  FSamples[7] := gEngine.Audio.LoadSound('arc/audio/sfx/thunder.ogg');
  FSamples[8] := gEngine.Audio.LoadSound('arc/audio/sfx/digthis.ogg');
end;

procedure TAudioSound.OnShutdown;
var
  LI: Integer;
begin
  gEngine.Audio.StopAllChannels;

  for LI := 0 to 8 do
  begin
    gEngine.Audio.UnloadSound(FSamples[LI]);
  end;

  inherited;
end;

procedure TAudioSound.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if gEngine.Input.KeyboardPressed(KEY_1) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[1], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_2) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[2], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_3) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[3], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_4) then
    gEngine.Audio.PlaySound(0, FSamples[0], 1, True);

  if gEngine.Input.KeyboardPressed(KEY_5) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[4], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_6) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[5], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_7) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[6], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_8) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[7], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_9) then
    gEngine.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSamples[8], 1, False);

  if gEngine.Input.KeyboardPressed(KEY_0) then
    gEngine.Audio.StopChannel(0);
end;

procedure TAudioSound.OnRender;
begin
  inherited;
end;

procedure TAudioSound.OnRenderHUD;
begin
  inherited;

  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, GREEN, haLeft, '1-9       - Play sample', []);
  Font.Print(HudPos.X, HudPos.Y, HudPos.Z, GREEN, haLeft, '0         - Stop looping sample', []);
end;


{ TAudioPositional }
procedure TAudioPositional.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Positional Audio';
end;

procedure TAudioPositional.OnStartup;
begin
  inherited;

  FCenterPos.Assign(Config.DisplayWidth/2, Config.DisplayHeight/2);

  gEngine.Audio.SetListenerPosition(Config.DisplayWidth/2, Config.DisplayHeight/2);
  FSfx := gEngine.Audio.LoadSound('arc/audio/sfx/samp5.ogg');

  FChan := gEngine.Audio.PlaySound(0, FSfx, 1.0, True);
  gEngine.Audio.SetChannelMinDistance(FChan, 10);
  gEngine.Audio.SetChannelAttenuation(FChan, 0.5);
end;

procedure TAudioPositional.OnShutdown;
begin
  gEngine.Audio.UnloadSound(FSfx);

  inherited;
end;

procedure TAudioPositional.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  gEngine.Audio.SetChannelPosition(FChan, MousePos.X, MousePos.Y);
end;

procedure TAudioPositional.OnRender;
var
  LRadius: Single;
begin
  inherited;

  gEngine.Display.DrawLine(FCenterPos.X, FCenterPos.Y, MousePos.X, MousePos.Y, GREEN, 1);
  gEngine.Display.DrawFilledCircle(FCenterPos.X, FCenterPos.Y, 10, ORANGE);

  LRadius := FCenterPos.Distance(MousePos);

  gEngine.Display.DrawCircle(FCenterPos.X, FCenterPos.Y, LRadius, 1, WHITE);

  gEngine.Display.DrawLine(0, MousePos.Y, Config.DisplayWidth-1, MousePos.Y, YELLOW, 1);
  gEngine.Display.DrawLine(MousePos.X, 0, MousePos.X, Config.DisplayHeight-1, YELLOW, 1);
end;

procedure TAudioPositional.OnRenderHUD;
begin
  inherited;
end;

end.
