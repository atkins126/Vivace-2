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

unit Vivace.Utils;

interface

uses
  System.Generics.Collections,
  System.TypInfo,
  System.SysUtils;

const
  cTrueFalseStr: array[False .. True] of string = ('False', 'True ');

type

 { TEnumConverter }
  TEnumConverter = class
  public
    class function EnumToInt<T>(const aEnumValue: T): Integer;
    class function EnumToString<T>(aEnumValue: T): string;
  end;

 { TDirectoryStack }
  TDirectoryStack = class
  protected
    FStack: TStack<String>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(aPath: string);
    procedure Pop;
  end;


function  GetParamValue(const aParamName: string; aSwitchChars: TSysCharSet; aSeperator: Char; var aValue: string): Boolean;
function  GetParam(const aParamName: string; var aValue: string): Boolean; overload;
function  GetParam(const aParamName: string): Boolean; overload;

function  GetAppName : string;
function  GetAppVersionStr: string;
function  GetAppVersionFullStr: string;
function  GetVersionInfo(aIdent: string): string;
function  GetFileDescription: string;
function  GetLegalCopyright: string;
function  GetLegalTrademarks: string;

function  GetFileSize(const aFilename: string): Int64;

function  ExportResDLL(const aResName: string; const aDllName: string; const aDestPath: string): Boolean;

procedure DeferDelFile(const aFilename: string);

function  FillStr(const aC: Char; const aCount: Integer): string;

function  IsDebug: Boolean;

function  FileCount(const aPath: string; const aSearchMask: string): Int64;

function  ResourceExists(aResName: string): Boolean;

procedure GotoURL(aURL: string);

function  IsConsoleApp: Boolean;

function GetVideoCardName: string;
function GetVideoCardMemory: UInt64;

implementation

uses
  System.IOUtils,
  System.Classes,
  System.Variants,
  System.Win.ComObj,
  WinApi.Windows,
  WinApi.ShellAPI,
  WinApi.ActiveX;

{ TEnumConverter }
class function TEnumConverter.EnumToInt<T>(const aEnumValue: T): Integer;
begin
  Result := 0;
  Move(aEnumValue, Result, SizeOf(aEnumValue));
end;

class function TEnumConverter.EnumToString<T>(aEnumValue: T): string;
begin
  Result := GetEnumName(TypeInfo(T), EnumToInt(aEnumValue));
end;

{ TDirectoryStack }
constructor TDirectoryStack.Create;
begin
  inherited;
  FStack := TStack<String>.Create;
end;

destructor TDirectoryStack.Destroy;
begin
  FreeAndNil(FStack);
  inherited;
end;

procedure TDirectoryStack.Push(aPath: string);
var
  LDir: string;
begin
  LDir := GetCurrentDir;
  FStack.Push(LDir);
  if not LDir.IsEmpty then
  begin
    SetCurrentDir(aPath);
  end;
end;

procedure TDirectoryStack.Pop;
var
  LDir: string;
begin
  LDir := FStack.Pop;
  SetCurrentDir(LDir);
end;



(* GetParameterValue

  GetParameterValue will return the value associated with a parameter name in the form of

  /paramname:paramvalue
  -paramname:paramvalue

  and

  /paramname
  -paramname

  ParamName - Name of the parameter (paramname)
  SwitchChars - Parameter switch identifiers (/ or -)
  Seperator - The char that sits between paramname and paramvalue (:)
  Value - The value of the parameter (paramvalue) if it exists

  Returns - Boolean, true if the parameter was found, false if parameter does not exist

  typical usage

  Parameter
  -P=c:\temp\
  -S

  GetParameterValue('p', ['/', '-'], '=', sValue);

  sValue will contain c:\temp\

*)
function GetParamValue(const aParamName: string; aSwitchChars: TSysCharSet; aSeperator: Char; var aValue: string): Boolean;
var
  i, Sep: Longint;
  s: string;
begin

  Result := False;
  aValue := '';

  // check for first non switch param when aParamName = '' and no
  // other params are found
  if (aParamName = '') then
  begin
    for i := 1 to ParamCount do
    begin
      s := ParamStr(i);
      if Length(s) > 0 then
        // if S[1] in aSwitchChars then
        if not CharInSet(s[1], aSwitchChars) then
        begin
          aValue := s;
          Result := True;
          Exit;
        end;
    end;
    Exit;
  end;

  // check for switch params
  for i := 1 to ParamCount do
  begin
    s := ParamStr(i);
    if Length(s) > 0 then
      // if S[1] in aSwitchChars then
      if CharInSet(s[1], aSwitchChars) then

      begin
        Sep := Pos(aSeperator, s);

        case Sep of
          0:
            begin
              if CompareText(Copy(s, 2, Length(s) - 1), aParamName) = 0 then
              begin
                Result := True;
                Break;
              end;
            end;
          1 .. MaxInt:
            begin
              if CompareText(Copy(s, 2, Sep - 2), aParamName) = 0 then
              // if CompareText(Copy(S, 1, Sep -1), aParamName) = 0 then
              begin
                aValue := Copy(s, Sep + 1, Length(s));
                Result := True;
                Break;
              end;
            end;
        end; // case
      end
  end;

end;

// GetParameterValue('p', ['/', '-'], ':', sValue);
function GetParam(const aParamName: string; var aValue: string): Boolean;
begin
  Result := GetParamValue(aParamName, ['/', '-'], '=', aValue);
end;

function GetParam(const aParamName: string): Boolean;
var
  value: string;
begin
  Result := GetParamValue(aParamName, ['/', '-'], ':', value);
end;

function GetAppName : string;
begin
  Result := TPath.GetFileNameWithoutExtension(ParamStr(0));
end;
function GetAppVersionStr: string;
var
  Rec: LongRec;
  ver : Cardinal;
begin
  ver := GetFileVersion(ParamStr(0));
  if ver <> Cardinal(-1) then
  begin
    Rec := LongRec(ver);
    Result := Format('%d.%d', [Rec.Hi, Rec.Lo]);
  end
  else Result := '';
end;
function GetAppVersionFullStr: string;
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Result := '';
  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
  begin
    //RaiseLastOSError;
    //no version info in file
    Exit;
  end;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  if (LongRec(FixedPtr.dwFileVersionLS).Hi = 0) and (LongRec(FixedPtr.dwFileVersionLS).Lo = 0) then
  begin
    Result := Format('%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,   //major
     LongRec(FixedPtr.dwFileVersionMS).Lo]); //minor
  end
  else if (LongRec(FixedPtr.dwFileVersionLS).Lo = 0) then
  begin
    Result := Format('%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,   //major
     LongRec(FixedPtr.dwFileVersionMS).Lo,   //minor
     LongRec(FixedPtr.dwFileVersionLS).Hi]); //release
  end
  else
  begin
    Result := Format('%d.%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,   //major
     LongRec(FixedPtr.dwFileVersionMS).Lo,   //minor
     LongRec(FixedPtr.dwFileVersionLS).Hi,   //release
     LongRec(FixedPtr.dwFileVersionLS).Lo]); //build
  end;
end;
function GetVersionInfo(aIdent: string): string;

type
  TLang = packed record
    Lng, Page: WORD;
  end;

  TLangs = array [0 .. 10000] of TLang;

  PLangs = ^TLangs;

var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: String;
  RM: TMemoryStream;
  RS: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: String;

begin
  // Assume error
  Result := '';

  RM := TMemoryStream.Create;
  try
    // Load the version resource into memory
    RS := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
    try
      RM.CopyFrom(RS, RS.Size);
    finally
      FreeAndNil(RS);
    end;

    // Extract the translations list
    if not VerQueryValue(RM.Memory, '\\VarFileInfo\\Translation', Pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div sizeof(TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available

    // Use the first translation from the table (in most cases will be OK)
    with BLngs[0] do
      BLangId := IntToHex(Lng, 4) + IntToHex(Page, 4);

    // Extract field by parameter
    BId := '\\StringFileInfo\\' + BLangId + '\\' + aIdent;
    if not VerQueryValue(RM.Memory, PChar(BId), Pointer(BP), BL) then
      Exit; // No such field

    // Prepare result
    Result := BP;
  finally
    FreeAndNil(RM);
  end;
end;
function GetFileDescription: string;
begin
  Result := GetVersionInfo('FileDescription');
end;

function GetLegalCopyright: string;
begin
  Result := GetVersionInfo('LegalCopyright');
end;

function GetLegalTrademarks: string;
begin
  Result := GetVersionInfo('LegalTrademarks');
end;

function GetProductVersion: string;
begin
  Result := GetVersionInfo('ProductVersion');
end;

function GetFileVersion: string;
begin
  Result := GetVersionInfo('FileVersion');
end;

function GetFileSize(const aFilename: string): Int64;
var
  LInfo: TWin32FileAttributeData;
begin
  Result := -1;

  if NOT GetFileAttributesEx(PWideChar(aFileName), GetFileExInfoStandard, @LInfo) then
    Exit;

  Result := Int64(LInfo.nFileSizeLow) or Int64(LInfo.nFileSizeHigh shl 32);
end;

function ExportResDLL(const aResName: string; const aDllName: string; const aDestPath: string): Boolean;
var
  LDLLRes: TResourceStream;
  LDLLFilename: string;
  LDLLName: string;
  LDestPath: string;
begin
  Result := False;
  if aResName.IsEmpty then Exit;
  if aDllName.IsEmpty then Exit;
  if aDestPath.IsEmpty then
    LDestPath := GetCurrentDir
  else
    LDestPath := aDestPath;

  LDllName := TPath.ChangeExtension(aDllName, 'dll');

  if TDirectory.Exists(LDestPath) then
  begin
    LDLLFilename := TPath.Combine(LDestPath, LDllName);

    if not TFile.Exists(LDLLFilename) then
    begin
      LDLLRes := TResourceStream.Create(HInstance, aResName, RT_RCDATA);
      try
        LDLLRes.SaveToFile(LDLLFilename);
        Result := TFile.Exists(LDLLFilename);
      finally
        FreeAndNil(LDLLRes);
      end;
    end;

  end;
end;

procedure DeferDelFile(const aFilename: string);
var
  LCode: TStringList;
  LFilename: string;

  procedure C(const aMsg: string; const aArgs: array of const);
  var
    LLine: string;
  begin
    LLine := Format(aMsg, aArgs);
    LCode.Add(LLine)
  end;

begin
  if aFilename.IsEmpty then Exit;
  LFilename := ChangeFileExt(aFilename, '');
  LFilename := LFilename + '_DeferDelFile.bat';
  if TFile.Exists(LFilename) then Exit;

  LCode := TStringList.Create;
  try
    C('@echo off', []);
    C(':Repeat', []);
    C('del "%s"', [aFilename]);
    C('if exist "%s" goto Repeat', [aFilename]);
    C('del "%s"', [LFilename]);
    LCode.SaveToFile(LFilename);
  finally
    FreeAndNil(LCode);
  end;

  if TFile.Exists(LFilename) then
  begin
    ShellExecute(0, 'open', PChar(LFilename), nil, nil, SW_HIDE);
  end;
end;

function FillStr(const aC: Char; const aCount: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to aCount do
  begin
    Result := Result + aC;
  end;
end;

function IsDebug: Boolean;
begin
  {$IFDEF DEBUG}
    Result := True;
  {$ELSE}
    Result := False;
  {$ENDIF DEBUG}
end;

function FileCount(const aPath: string; const aSearchMask: string): Int64;
var
  SearchRec: TSearchRec;
  LPath: string;
begin
  Result := 0;
  LPath := aPath;
  LPath := System.IOUtils.TPath.Combine(aPath, aSearchMask);
  if FindFirst(LPath, faAnyFile, SearchRec) = 0 then
    repeat
      if SearchRec.Attr <> faDirectory then
        Inc(Result);
    until FindNext(SearchRec) <> 0;
end;

function ResourceExists(aResName: string): Boolean;
begin
  Result := Boolean((FindResource(hInstance, PChar(aResName), RT_RCDATA) <> 0));
end;

procedure GotoURL(aURL: string);
begin
  if aURL.IsEmpty then Exit;
  ShellExecute(0, 'OPEN', PChar(aURL), '', '', SW_SHOWNORMAL);
end;

function IsConsoleApp: Boolean;
var
  Stdout: THandle;
begin
  Stdout := GetStdHandle(Std_Output_Handle);
  Win32Check(Stdout <> Invalid_Handle_Value);
  Result := Stdout <> 0;
end;

function GetVideoCardName: string;
const
  WbemUser = '';
  WbemPassword = '';
  WbemComputer = 'localhost';
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
begin;
  try
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2',
      WbemUser, WbemPassword);
    FWbemObjectSet := FWMIService.ExecQuery
      ('SELECT Name,PNPDeviceID  FROM Win32_VideoController', 'WQL',
      wbemFlagForwardOnly);
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
    while oEnum.Next(1, FWbemObject, iValue) = 0 do
    begin
      result := String(FWbemObject.Name);
      FWbemObject := Unassigned;
    end;
  except
  end;
end;

function GetVideoCardMemory: UInt64;
var
  DeviceMode: TDeviceMode;
  i, m, max: UInt64;
begin
  max := 0;
  i := 0;
  while EnumDisplaySettings(nil, i, DeviceMode) do
  begin
    m := Round(DeviceMode.dmPelsWidth * DeviceMode.dmPelsHeight * (DeviceMode.dmBitsPerPel/8));
    if m > max then
      max := m;
    inc(i);
  end;
  Result := max;
end;

{ =========================================================================== }
var
  CodePage: Cardinal;

initialization
begin
  ReportMemoryLeaksOnShutdown := True;
  CodePage := GetConsoleOutputCP;
  SetConsoleOutputCP(WinApi.Windows.CP_UTF8);
end;

finalization
begin
  SetConsoleOutputCP(CodePage);
end;

end.
