{==============================================================================
         _       ve'va'CHe
  __   _(_)_   ____ _  ___ ___ ™
  \ \ / / \ \ / / _` |/ __/ _ \
   \ V /| |\ V / (_| | (_|  __/
    \_/ |_| \_/ \__,_|\___\___|
                   game toolkit

 Copyright © 2020-21 tinyBigGAMES™ LLC
 All rights reserved.

 website: https://tinybiggames.com
 email  : support@tinybiggames.com

 LICENSE: zlib/libpng

 Vivace Game Toolkit is licensed under an unmodified zlib/libpng license,
 which is an OSI-certified, BSD-like license that allows static linking
 with closed source software:

 This software is provided "as-is", without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software in
     a product, an acknowledgment in the product documentation would be
     appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.

  3. This notice may not be removed or altered from any source distribution.

============================================================================== }

program Testbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Vivace.MemoryModule in '..\..\Sources\Library\Vivace.MemoryModule.pas',
  Vivace.Allegro in '..\..\Sources\Library\Vivace.Allegro.pas',
  Vivace.Nuklear in '..\..\Sources\Library\Vivace.Nuklear.pas',
  Vivace.OpenAL in '..\..\Sources\Library\Vivace.OpenAL.pas',
  Vivace.CSFMLAudio in '..\..\Sources\Library\Vivace.CSFMLAudio.pas',
  Vivace.EnvVars in '..\..\Sources\Library\Vivace.EnvVars.pas',
  Vivace.Utils in '..\..\Sources\Library\Vivace.Utils.pas',
  Vivace.Buffer in '..\..\Sources\Library\Vivace.Buffer.pas',
  uTestbed in 'uTestbed.pas',
  Vivace.Audio in '..\..\Sources\Library\Vivace.Audio.pas',
  Vivace.LuaJIT in '..\..\Sources\Library\Vivace.LuaJIT.pas',
  Vivace.Lua in '..\..\Sources\Library\Vivace.Lua.pas',
  Vivace.Base in '..\..\Sources\Library\Vivace.Base.pas',
  Vivace.Common in '..\..\Sources\Library\Vivace.Common.pas',
  Vivace.SMTP in '..\..\Sources\Library\Vivace.SMTP.pas',
  Vivace.SSLLibs in '..\..\Sources\Library\Vivace.SSLLibs.pas',
  Vivace.OS in '..\..\Sources\Library\Vivace.OS.pas';

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    RunTests;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
