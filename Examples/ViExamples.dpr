{==============================================================================
         _       ve'va'CHe
  __   _(_)_   ____ _  ___ ___ ™
  \ \ / / \ \ / / _` |/ __/ _ \
   \ V /| |\ V / (_| | (_|  __/
    \_/ |_| \_/ \__,_|\___\___|
                   Game Toolkit

  Copyright © 2020-21 tinyBigGAMES™ LLC
  All rights reserved.

  website: https://tinybiggames.com
  email  : support@tinybiggames.com

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

program ViExamples;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uViExamples in 'uViExamples.pas',
  Vivace.Actor in '..\Sources\Library\Vivace.Actor.pas',
  Vivace.Async in '..\Sources\Library\Vivace.Async.pas',
  Vivace.Audio in '..\Sources\Library\Vivace.Audio.pas',
  Vivace.Base in '..\Sources\Library\Vivace.Base.pas',
  Vivace.Bitmap in '..\Sources\Library\Vivace.Bitmap.pas',
  Vivace.Buffer in '..\Sources\Library\Vivace.Buffer.pas',
  Vivace.CmdConsole in '..\Sources\Library\Vivace.CmdConsole.pas',
  Vivace.Collision in '..\Sources\Library\Vivace.Collision.pas',
  Vivace.Color in '..\Sources\Library\Vivace.Color.pas',
  Vivace.Common in '..\Sources\Library\Vivace.Common.pas',
  Vivace.ConfigFile in '..\Sources\Library\Vivace.ConfigFile.pas',
  Vivace.Console in '..\Sources\Library\Vivace.Console.pas',
  Vivace.Crypto in '..\Sources\Library\Vivace.Crypto.pas',
  Vivace.Display in '..\Sources\Library\Vivace.Display.pas',
  Vivace.Easings in '..\Sources\Library\Vivace.Easings.pas',
  Vivace.Engine in '..\Sources\Library\Vivace.Engine.pas',
  Vivace.Entity in '..\Sources\Library\Vivace.Entity.pas',
  Vivace.EnvVars in '..\Sources\Library\Vivace.EnvVars.pas',
  Vivace.External.Allegro in '..\Sources\Library\Vivace.External.Allegro.pas',
  Vivace.External.CLibs in '..\Sources\Library\Vivace.External.CLibs.pas',
  Vivace.External.CSFMLAudio in '..\Sources\Library\Vivace.External.CSFMLAudio.pas',
  Vivace.External.LuaJIT in '..\Sources\Library\Vivace.External.LuaJIT.pas',
  Vivace.External.Nuklear in '..\Sources\Library\Vivace.External.Nuklear.pas',
  Vivace.Font in '..\Sources\Library\Vivace.Font.pas',
  Vivace.Game in '..\Sources\Library\Vivace.Game.pas',
  Vivace.GUI in '..\Sources\Library\Vivace.GUI.pas',
  Vivace.Input in '..\Sources\Library\Vivace.Input.pas',
  Vivace.KeyValueData in '..\Sources\Library\Vivace.KeyValueData.pas',
  Vivace.Logger in '..\Sources\Library\Vivace.Logger.pas',
  Vivace.Lua in '..\Sources\Library\Vivace.Lua.pas',
  Vivace.Math in '..\Sources\Library\Vivace.Math.pas',
  Vivace.OS in '..\Sources\Library\Vivace.OS.pas',
  Vivace.Polygon in '..\Sources\Library\Vivace.Polygon.pas',
  Vivace.PolyPoint in '..\Sources\Library\Vivace.PolyPoint.pas',
  Vivace.PolyPointTrace in '..\Sources\Library\Vivace.PolyPointTrace.pas',
  Vivace.Screenshake in '..\Sources\Library\Vivace.Screenshake.pas',
  Vivace.Screenshot in '..\Sources\Library\Vivace.Screenshot.pas',
  Vivace.SMTP in '..\Sources\Library\Vivace.SMTP.pas',
  Vivace.Speech in '..\Sources\Library\Vivace.Speech.pas',
  Vivace.Sprite in '..\Sources\Library\Vivace.Sprite.pas',
  Vivace.Starfield in '..\Sources\Library\Vivace.Starfield.pas',
  Vivace.StartupDialog in '..\Sources\Library\Vivace.StartupDialog.pas',
  Vivace.StartupDialogForm in '..\Sources\Library\Vivace.StartupDialogForm.pas' {StartupDialogForm},
  Vivace.TLB.SpeechLib in '..\Sources\Library\Vivace.TLB.SpeechLib.pas',
  Vivace.TreeMenu in '..\Sources\Library\Vivace.TreeMenu.pas',
  Vivace.TreeMenuForm in '..\Sources\Library\Vivace.TreeMenuForm.pas' {TreeMenuForm},
  Vivace.Utils in '..\Sources\Library\Vivace.Utils.pas',
  Vivace.Video in '..\Sources\Library\Vivace.Video.pas',
  Vivace.Viewport in '..\Sources\Library\Vivace.Viewport.pas',
  uCommon in 'uCommon.pas',
  Vivace.RichEdit in '..\Sources\Library\Vivace.RichEdit.pas',
  uDisplay in 'uDisplay.pas',
  uEntity in 'uEntity.pas',
  uActor in 'uActor.pas',
  uAstroBlaster in 'uAstroBlaster.pas',
  uScroll in 'uScroll.pas',
  uElastic in 'uElastic.pas',
  uChainAction in 'uChainAction.pas';

begin
  RunGame(TExamples);
end.
