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
  Vivace.Common;

procedure RunViArc;
var
  Arc: TViArc;
begin
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
  WriteLn(Format('%s v%s', [VIARC_DESCRIPTION, VIVACE_VERSION]));
  WriteLn(VIVACE_LEGALCOPYRIGHT);
  WriteLn(VIVACE_LEGALTRADEMARK);
  WriteLn;
end;

procedure TViArc.ShowUsage;
begin
  WriteLn('Usage: ViArc filename[.arc] directory');
  WriteLn;
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
  Write(Format('   Adding %s (%d%s)...'#13, [aFilename, Done, '%']));
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
    WriteLn(Format('Directory was not found: "%s"', [Dir]));
    ShowUsage;
    Exit;
  end;

  WriteLn(Format('Creating %s...', [FName]));

  // create zip archive and show progress
  Build(FName, Dir);

  WriteLn;
  WriteLn;

  // check if zip archive was created
  if TFile.Exists(FName) then
    WriteLn('Done!')
  else
    WriteLn(Format('Error creating %s...', [FName]));

end;


end.
