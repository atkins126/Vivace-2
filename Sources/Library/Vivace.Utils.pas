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

unit Vivace.Utils;

interface

uses
  System.SysUtils;

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

procedure ExportResDLL(const aResName: string; const aDllName: string; const aDestPath: string);
function  LoadResDLL(const aResName: string): Pointer;

implementation

uses
  System.IOUtils,
  System.Classes,
  WinApi.Windows,
  Vivace.MemoryModule;

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

procedure ExportResDLL(const aResName: string; const aDllName: string; const aDestPath: string);
var
  LDLLRes: TResourceStream;
  LDLLFilename: string;
  LDLLName: string;
  LDestPath: string;
begin
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
      finally
        FreeAndNil(LDLLRes);
      end;
    end;

  end;
end;

function LoadResDLL(const aResName: string): Pointer;
var
  LBuff: TResourceStream;
begin
  Result := nil;
  if aResName.IsEmpty then Exit;
  LBuff := TResourceStream.Create(HInstance, aResName, RT_RCDATA);
  try
    Result := TMemoryModule.LoadLibrary(LBuff.Memory);
  finally
    FreeAndNil(LBuff);
  end;
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
