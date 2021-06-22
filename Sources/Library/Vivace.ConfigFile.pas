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

unit Vivace.ConfigFile;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  Vivace.Base,
  Vivace.Common;

type

  { TConfigFile }
  TConfigFile = class(TBaseObject)
  protected
    FHandle: TIniFile;
    FFilename: string;
    FSection: TStringList;
  public
    property  Handle: TIniFile read FHandle;

    constructor Create; override;
    destructor Destroy; override;

    function  Open(aFilename: string=''): Boolean;
    procedure Close;
    function  IsOpen: Boolean;

    procedure Update;

    function  RemoveSection(aName: string): Boolean;

    procedure SetValue(aSection: string; aKey: string; aValue: string);  overload;
    procedure SetValue(aSection: string; aKey: string; aValue: Integer); overload;
    procedure SetValue(aSection: string; aKey: string; aValue: Boolean); overload;

    function  GetValue(aSection: string; aKey: string; aDefaultValue: string): string; overload;
    function  GetValue(aSection: string; aKey: string; aDefaultValue: Integer): Integer; overload;
    function  GetValue(aSection: string; aKey: string; aDefaultValue: Boolean): Boolean; overload;

    function  RemoveKey(aSection: string; aKey: string): Boolean;

    function  GetSectionValues(aSection: string): Integer;

    function  GetSectionValue(aIndex: Integer; aDefaultValue: string): string; overload;
    function  GetSectionValue(aIndex: Integer; aDefaultValue: Integer): Integer; overload;
    function  GetSectionValue(aIndex: Integer; aDefaultValue: Boolean): Boolean; overload;
  end;


implementation

uses
  System.IOUtils,
  Vivace.Utils,
  Vivace.Engine;

{ TGVConfigFile }
constructor TConfigFile.Create;
begin
  inherited;
  FHandle := nil;
  FSection := TStringList.Create;
end;

destructor TConfigFile.Destroy;
begin
  Close;
  FreeAndNil(FSection);
  inherited;
end;

function TConfigFile.Open(aFilename: string): Boolean;
var
  LFilename: string;
begin
  Result := False;
  if IsOpen then Exit;
  LFilename := aFilename;
  if LFilename.IsEmpty then LFilename := TPath.ChangeExtension(ParamStr(0), 'cfg');
  FHandle := TIniFile.Create(LFilename);
  Result := Boolean(FHandle <> nil);
  FFilename := LFilename;
end;

procedure TConfigFile.Close;
begin
  if not IsOpen then Exit;
  FHandle.UpdateFile;
  FreeAndNil(FHandle);
end;

function TConfigFile.IsOpen: Boolean;
begin
  Result := Boolean(FHandle <> nil);
end;

procedure TConfigFile.Update;
begin
  if not IsOpen then Exit;
  FHandle.UpdateFile;
end;

function TConfigFile.RemoveSection(aName: string): Boolean;
var
  LName: string;
begin
  Result := False;
  if FHandle = nil then Exit;
  LName := aName;
  if LName.IsEmpty then Exit;
  FHandle.EraseSection(LName);
  Result := True;
end;

procedure TConfigFile.SetValue(aSection: string; aKey: string; aValue: string);
begin
  if FHandle = nil then Exit;
  FHandle.WriteString(aSection, aKey, aValue);
end;

procedure TConfigFile.SetValue(aSection: string; aKey: string; aValue: Integer);
begin
  SetValue(aSection, aKey, aValue.ToString);
end;

procedure TConfigFile.SetValue(aSection: string; aKey: string; aValue: Boolean);
begin
  SetValue(aSection, aKey, aValue.ToInteger);
end;

function TConfigFile.GetValue(aSection: string; aKey: string; aDefaultValue: string): string;
begin
  Result := '';
  if FHandle = nil then Exit;
  Result := FHandle.ReadString(aSection, aKey, aDefaultValue);
end;

function TConfigFile.GetValue(aSection: string; aKey: string; aDefaultValue: Integer): Integer;
var
  LResult: string;
begin
  LResult := GetValue(aSection, aKey, aDefaultValue.ToString);
  Integer.TryParse(LResult, Result);
end;

function TConfigFile.GetValue(aSection: string; aKey: string; aDefaultValue: Boolean): Boolean;
begin
  Result := GetValue(aSection, aKey, aDefaultValue.ToInteger).ToBoolean;
end;

function TConfigFile.RemoveKey(aSection: string; aKey: string): Boolean;
var
  LSection: string;
  LKey: string;
begin
  Result := False;
  if FHandle = nil then Exit;
  LSection := aSection;
  LKey := aKey;
  if LSection.IsEmpty then Exit;
  if LKey.IsEmpty then Exit;
  FHandle.DeleteKey(LSection, LKey);
  Result := True;
end;

function TConfigFile.GetSectionValues(aSection: string): Integer;
var
  LSection: string;
begin
  Result := 0;
  if LSection.IsEmpty then Exit;
  LSection := aSection;
  FSection.Clear;
  FHandle.ReadSectionValues(LSection, FSection);
  Result := FSection.Count;
end;

function TConfigFile.GetSectionValue(aIndex: Integer; aDefaultValue: string): string;
begin
  Result := '';
  if (aIndex < 0) or (aIndex > FSection.Count - 1) then Exit;
  Result := FSection.ValueFromIndex[aIndex];
  if Result.IsEmpty then Result := aDefaultValue;
end;

function TConfigFile.GetSectionValue(aIndex: Integer; aDefaultValue: Integer): Integer;
begin
  Result := GetSectionValue(aIndex, aDefaultValue.ToString).ToInteger
end;

function TConfigFile.GetSectionValue(aIndex: Integer; aDefaultValue: Boolean): Boolean;
begin
  Result := GetSectionValue(aIndex, aDefaultValue.ToString).ToBoolean
end;

end.
