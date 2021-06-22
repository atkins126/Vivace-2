{==============================================================================
         _       ve'va'CHe
  __   _(_)_   ____ _  ___ ___ �
  \ \ / / \ \ / / _` |/ __/ _ \
   \ V /| |\ V / (_| | (_|  __/
    \_/ |_| \_/ \__,_|\___\___|
                   Game Toolkit

  Copyright � 2020-21 tinyBigGAMES� LLC
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

unit Vivace.Screenshot;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common;

type
  { TScreenshot }
  TScreenshot = class(TBaseObject)
  protected
    FFlag: Boolean;
    FDir: string;
    FBaseFilename: string;
    FFilename: string;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Process;

    procedure Init(aDir: string; aBaseFilename: string);
    procedure Take;
  end;

implementation

uses
  Vivace.Utils,
  Vivace.Engine;

{ TScreenshot }
constructor TScreenshot.Create;
begin
  inherited;
  FFlag := False;
  FFilename := '';
  FDir := 'Screenshots';
  FBaseFilename := 'Screen';
  Init('', '');
end;

destructor TScreenshot.Destroy;
begin
  inherited;
end;

procedure TScreenshot.Init(aDir: string; aBaseFilename: string);
var
  Dir: string;
  BaseFilename: string;
begin
  FFilename := '';
  FFlag := False;

  Dir := aDir;
  BaseFilename := aBaseFilename;

  if Dir.IsEmpty then
    Dir := 'Screenshots';
  FDir := Dir;

  if BaseFilename.IsEmpty then
    BaseFilename := 'Screen';
  FBaseFilename := BaseFilename;

  ChangeFileExt(FBaseFilename, '');
end;

procedure TScreenshot.Take;
begin
  FFlag := True;
end;

procedure TScreenshot.Process;
var
  c: Integer;
  f, d, b: string;
begin
  if gEngine.Screenshake.Active then
    Exit;
  if not FFlag then
    Exit;
  FFlag := False;

  // director
  d := ExpandFilename(FDir);
  ForceDirectories(d);

  // base name
  b := FBaseFilename;

  // search file maks
  f := b + '*.png';

  // file count
  c := FileCount(d, f);

  // screenshot file mask
  f := Format('%s\%s (%.3d).png', [d, b, c]);
  FFilename := f;

  // save screenshot
  gEngine.Display.Save(f);
end;

end.
