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

unit uViDump;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Base,
  Vivace.Common;

const
  VIDUMP_DESCRIPTION = 'Vivace™ Archive Utility';

type

  { TViDump }
  TViDump = class(TBaseObject)
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure ShowHeader;
    procedure ShowUsage;
    procedure Run;
  end;


procedure RunDump;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  Vivace.Utils;

procedure RunDump;
var
  Dump: TViDump;
begin
  Dump := TViDump.Create;
  try
    Dump.Run;
  finally
    FreeAndNil(Dump);
  end;
end;

{ --- TViDump --------------------------------------------------------------- }
constructor TViDump.Create;
begin
  inherited;
end;

destructor TViDump.Destroy;
begin
  inherited;
end;

procedure TViDump.ShowHeader;
begin
  WriteLn(Format('%s v%s', [VIDUMP_DESCRIPTION, VIVACE_VERSION]));
  WriteLn(VIVACE_LEGALCOPYRIGHT);
  WriteLn(VIVACE_LEGALTRADEMARK);
  WriteLn;
end;

procedure TViDump.ShowUsage;
begin
  WriteLn('Usage: ViDump filename');
  WriteLn;
end;

procedure TViDump.Run;
var
  InFilename: string;
  OutFilename: string;
  Line: string;
  InFile: TFileStream;
  OutFile: TStringBuilder;
  List: TStringList;
  C: Cardinal;
  S,E: Integer;
  B: Byte;
begin
  ShowHeader;

  if ParamCount < 1 then
  begin
    ShowUsage;
    Exit;
  end;

  InFilename := ParamStr(1);

  if not TFile.Exists(InFilename) then
  begin
    WriteLn('File was not found: ', InFilename);
    ShowUsage;
    Exit;
  end;

  OutFilename := TPath.GetFileName(InFilename);
  OutFilename := OutFilename.Replace('.', '_');
  OutFilename := OutFilename + '.inc';
  OutFilename := TPath.Combine(TPath.GetDirectoryName(InFilename), OutFilename);

  WriteLn(Format('Dumping %s...', [InFilename]));
  InFile := TFile.OpenRead(InFilename);
  OutFile := TStringBuilder.Create;
  List := TStringList.Create;
  try
    C := 0;
    S := 0;
    OutFile.Append(Format('const c%s : array[1..', [TPath.GetFileNameWithoutExtension(OutFilename).ToUpper]));
    OutFile.Append(InFile.Size);
    OutFile.Append('] of Byte = (');
    OutFile.AppendLine;

    while InFile.Position < InFile.Size do
    begin
      InFile.Read(B, 1);

      Inc(c, 1);
      if (c = 16) then
      begin
        if (InFile.Position = InFile.Size) then
        begin
          OutFile.Append('$');
          OutFile.Append(IntToHex(B, 2));
          OutFile.AppendLine;
        end
        else
        begin
          OutFile.Append('$');
          OutFile.Append(IntToHex(B, 2));
          OutFile.Append(',');
          OutFile.AppendLine;
        end;
        C := 0;
        E := (OutFile.Length-S)-1;
        Line := OutFile.ToString(S, E);
        S := OutFile.Length-1;
        Write(Format(#13'  Writing %d/%d...', [InFile.Position, InFile.Size]));
      end
      else if (InFile.Position = InFile.Size) then
      begin
        OutFile.Append('$');
        OutFile.Append(IntToHex(B, 2));
        OutFile.AppendLine;
      end
      else
      begin
        OutFile.Append('$');
        OutFile.Append(IntToHex(B, 2));
        OutFile.Append(', ');
      end;
    end;
    OutFile.Append(');');
    List.Add(OutFile.ToString);
    List.SaveToFile(OutFilename);
    WriteLn;
    WriteLn('Done!');
  finally
    FreeAndNil(List);
    FreeAndNil(OutFile);
    FreeAndNil(InFile);
  end;
end;

end.
