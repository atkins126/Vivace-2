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

unit uViarc;

interface

{$I Vivace.Defines.inc}

uses
  System.Zip,
  Vivace.Base;

const
  VIARC_DESCRIPTION = 'Vivace™ Archive Utility';

type

  { TViArc }
  TViArc = class(TBaseObject)
  protected
    FHandle: TZipFile;
    FCurFilename: string;
    procedure ShowHeader;
    procedure ShowUsage;
    procedure OnProgress(aSender: TObject; aFilename: string; aHeader: TZipHeader; aPosition: Int64);
    procedure Build(aFilename: string; aPath: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Run;
  end;

procedure RunViArc;

implementation

uses
  System.Types,
  System.SysUtils,
  System.IOUtils,
  Vivace.Utils,
  Vivace.Common,
  Vivace.Console,
  Vivace.Logger;

procedure RunViArc;
var
  Arc: TViArc;
begin
  TLogger.SetLogToConsole(False);
  Arc := TViArc.Create;
  try
    Arc.Run;
  finally
    FreeAndNil(Arc);
  end;
end;


{ --- TViArc ---------------------------------------------------------------- }
procedure TViArc.ShowHeader;
begin
  TConsole.WriteLn('%s v%s', [VIARC_DESCRIPTION, VIVACE_VERSION], ccWhite);
  TConsole.WriteLn(VIVACE_LEGALCOPYRIGHT, [], ccWhite);
  TConsole.WriteLn(VIVACE_LEGALTRADEMARK, [], ccWhite);
  TConsole.WriteLn;
end;

procedure TViArc.ShowUsage;
begin
  TConsole.WriteLn('Usage: ViArc filename[.arc] directory', [], etWarning);
  TConsole.WriteLn;
end;

procedure TViArc.OnProgress(aSender: TObject; aFilename: string; aHeader: TZipHeader; aPosition: Int64);
var
  Done: Integer;
begin
  if FCurFilename <> aFilename then
  begin
    WriteLn;
    FCurFilename := aFilename;
  end;
  Done := Round((aPosition / aHeader.UncompressedSize) * 100);
  TConsole.Write(#13'   Adding %s (%d%s)...', [aFilename, Done, '%'], etInfo);
end;

procedure TViArc.Build(aFilename: string; aPath: string);
var
  LPath: string;
  LFile: string;
  LFiles: TStringDynArray;
begin
  //FHandle.Encoding :=
  FHandle.OnProgress := OnProgress;
  if TFile.Exists(aFilename) then
    TFile.Delete(aFilename);
  LPath := System.SysUtils.IncludeTrailingPathDelimiter(aPath);
  LFiles := TDirectory.GetFiles(LPath, '*', TSearchOption.soAllDirectories);
  FHandle.Open(aFilename, zmWrite);
  for LFile in LFiles do
  begin
   FHandle.Add(LFile, LFile, zcDeflate);
  end;
end;

constructor TViArc.Create;
begin
  inherited;
  FHandle := TZipFile.Create;
  FCurFilename := '';
end;

destructor TViArc.Destroy;
begin
  FreeAndNil(FHandle);
  inherited;
end;

procedure TViArc.Run;
var
  Dir: string;
  FName: string;
begin
  ShowHeader;

  // check correct number of params
  if ParamCount < 2 then
  begin
    ShowUsage;
    Exit;
  end;


  // check filename
  FName := ParamStr(1);
  FName := TPath.ChangeExtension(FName, '.arc');

  // check directory
  Dir := ParamStr(2);
  if not TDirectory.Exists(Dir) then
  begin
    TConsole.WriteLn('Directory was not found: "%s"', [Dir], etError);
    ShowUsage;
    Exit;
  end;

  TConsole.WriteLn('Creating %s...', [FName], etInfo);

  // create zip archive and show progress
  Build(FName, Dir);

  TConsole.WriteLn;
  TConsole.WriteLn;

  // check if zip archive was created
  if TFile.Exists(FName) then
    TConsole.WriteLn('Done!', [], etSuccess)
  else
    TConsole.WriteLn('Error creating %s...', [FName], etError);

end;


end.
