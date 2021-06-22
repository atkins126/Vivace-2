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
  Vivace.Utils,
  Vivace.Console,
  Vivace.Logger;

procedure RunDump;
var
  Dump: TViDump;
begin
  TLogger.SetLogToConsole(False);
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
  TConsole.WriteLn('%s v%s', [VIDUMP_DESCRIPTION, VIVACE_VERSION], ccWhite);
  TConsole.WriteLn(VIVACE_LEGALCOPYRIGHT, [], ccWhite);
  TConsole.WriteLn(VIVACE_LEGALTRADEMARK, [], ccWhite);
  TConsole.WriteLn;
end;

procedure TViDump.ShowUsage;
begin
  TConsole.WriteLn('Usage: ViDump filename', [], ccYellow, ccDefault);
  TConsole.WriteLn;
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
    TConsole.WriteLn('File was not found: "%s"', [InFilename], etError);
    ShowUsage;
    Exit;
  end;

  OutFilename := TPath.GetFileName(InFilename);
  OutFilename := OutFilename.Replace('.', '_');
  OutFilename := OutFilename + '.inc';
  OutFilename := TPath.Combine(TPath.GetDirectoryName(InFilename), OutFilename);

  TConsole.WriteLn('Dumping %s...', [InFilename], etInfo);
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
        TConsole.Write(#13'  Writing %d/%d...', [InFile.Position, InFile.Size], etInfo);
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
    TConsole.WriteLn;
    TConsole.WriteLn('Done!', [], etSuccess);
  finally
    FreeAndNil(List);
    FreeAndNil(OutFile);
    FreeAndNil(InFile);
  end;
end;

end.
