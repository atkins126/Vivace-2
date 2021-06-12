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

unit Vivace.EnvVars;

{$I Vivace.Defines.inc }

interface

uses
  System.Classes;

type

  { TEnvVars }
  TEnvVars = class
  public
    class function GetValue(const aVarName: string): string;
    class function SetValue(const aVarName, aVarValue: string): Integer;
    class function Delete(const aVarName: string): Integer;
    class function CreateBlock(const aNewEnv: TStrings; const aIncludeCurrent: Boolean; const aBuffer: Pointer; const aBufSize: Integer): Integer;
    class function Expand(const aStr: string): string;
    class function GetAll(const aVars: TStrings): Integer;
  end;

implementation

uses
  System.SysUtils,
  WinApi.Windows;

{ TEnvVars }

class function TEnvVars.GetValue(const aVarName: string): string;
var
  LBufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  LBufSize := GetEnvironmentVariable(PChar(aVarName), nil, 0);
  if LBufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, LBufSize - 1);
    GetEnvironmentVariable(PChar(aVarName), PChar(Result), LBufSize);
  end
  else
    // No such environment variable
    Result := '';
end;

class function TEnvVars.SetValue(const aVarName, aVarValue: string): Integer;
begin
  if SetEnvironmentVariable(PChar(aVarName), PChar(aVarValue)) then
    Result := 0
  else
    Result := GetLastError;
end;

class function TEnvVars.Delete(const aVarName: string): Integer;
begin
  if SetEnvironmentVariable(PChar(aVarName), nil) then
    Result := 0
  else
    Result := GetLastError;
end;

class function TEnvVars.CreateBlock(const aNewEnv: TStrings; const aIncludeCurrent: Boolean; const aBuffer: Pointer; const aBufSize: Integer): Integer;
var
  LEnvVars: TStringList; // env vars in new block
  LIdx: Integer;         // loops thru env vars
  LPBuf: PChar;          // start env var entry in block
begin
  // String list for new environment vars
  LEnvVars := TStringList.Create;
  try
    // include current block if required
    if aIncludeCurrent then
       GetAll(LEnvVars);

    // store given environment vars in list
    if Assigned(aNewEnv) then
      LEnvVars.AddStrings(aNewEnv);
    // Calculate size of new environment block
    Result := 0;
    for LIdx := 0 to Pred(LEnvVars.Count) do
      Inc(Result, Length(LEnvVars[LIdx]) + 1);
    Inc(Result);
    // Create block if buffer large enough
    if (aBuffer <> nil) and (aBufSize >= Result) then
    begin
      // new environment blocks are always sorted
      LEnvVars.Sorted := True;
      // do the copying
      LPBuf := aBuffer;
      for LIdx := 0 to Pred(LEnvVars.Count) do
      begin
        StrPCopy(LPBuf, LEnvVars[LIdx]);
        Inc(LPBuf, Length(LEnvVars[LIdx]) + 1);
      end;
      // terminate block with additional #0
      LPBuf^ := #0;
    end;
  finally
    LEnvVars.Free;
  end;
end;

class function TEnvVars.Expand(const aStr: string): string;
var
  LBufSize: Integer; // size of expanded string
begin
  // Get required buffer size
  LBufSize := ExpandEnvironmentStrings(PChar(aStr), nil, 0);
  if LBufSize > 0 then
  begin
    // Read expanded string into result string
    SetLength(Result, LBufSize);
    ExpandEnvironmentStrings(PChar(aStr), PChar(Result), LBufSize);
  end
  else
    // Trying to expand empty string
    Result := '';
end;

class function TEnvVars.GetAll(const aVars: TStrings): Integer;
var
  LPEnvVars: PChar;    // pointer to start of environment block
  LPEnvEntry: PChar;   // pointer to an env string in block
begin
  // Clear the list
  if Assigned(aVars) then
    aVars.Clear;

  // Get reference to environment block for this process
  LPEnvVars := GetEnvironmentStrings;
  if LPEnvVars <> nil then
  begin
    // We have a block: extract strings from it
    // Env strings are #0 separated and list ends with #0#0
    LPEnvEntry := LPEnvVars;
    try
      while LPEnvEntry^ <> #0 do
      begin
        if Assigned(aVars) then
          aVars.Add(LPEnvEntry);
        Inc(LPEnvEntry, StrLen(LPEnvEntry) + 1);
      end;
      // Calculate length of block
      Result := (LPEnvEntry - LPEnvVars) + 1;
    finally
      // Dispose of the memory block
      FreeEnvironmentStrings(LPEnvVars);
    end;
  end
  else
    // No block => zero length
    Result := 0;
end;

end.
