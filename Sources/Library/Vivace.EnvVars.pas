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
