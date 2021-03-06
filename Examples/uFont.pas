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

unit uFont;

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
  { TFontUnicode }
  TFontUnicode = class(TBaseExample)
  protected
    FUniFont: TFont;
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
  Vivace.Color,
  Vivace.Common;


{ TFontUnicode }
procedure TFontUnicode.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;

  aConfig.DisplayTitle := cExampleTitle + 'Unicode Font';
end;

procedure TFontUnicode.OnStartup;
begin
  inherited;

  FUniFont := TFont.Create;
  FUniFont.Load(16, 'arc/fonts/default-mono.ttf');
end;

procedure TFontUnicode.OnShutdown;
begin
  FreeAndNil(FUniFont);

  inherited;
end;

procedure TFontUnicode.OnUpdate(aDeltaTime: Double);
begin
  inherited;

end;

procedure TFontUnicode.OnRender;
begin
  inherited;

end;

procedure TFontUnicode.OnRenderHUD;
begin
  inherited;

  FUniFont.Print(Config.DisplayWidth div 2, Config.DisplayHeight div 2, YELLOW, haCenter, ' en   zh      ja       ko        de   es   pt     fr      vi    id', []);
  FUniFont.Print(Config.DisplayWidth div 2, (Config.DisplayHeight div 2)+18, GREEN, haCenter, 'Hello|你好|こんにちは|안녕하세요|Hallo|Hola|Olá|Bonjour|Xin chào|Halo', []);
end;

end.
