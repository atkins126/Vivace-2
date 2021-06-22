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

unit Vivace.OS;

{$I Vivace.Defines.inc}

interface

type

  { TDialogMessage }
  TMessageDialog = (mdDefault = $00000000, mdError = $00000010, mdWarning = $00000030, mdInfo = $00000040);

  { TConfirmDialogResult }
  TConfirmDialogResult = (cdYes, cdNo, cdCancel);

  { TOS }
  TOS = class
    class function  GetWorkPath: string;
    class procedure DeferDeleteWorkPathFile(aFilename: string);
    class function  GetComputerName: string;
    class function  GetVersion: string;
    class function  GetLoggedUserName: string;
    class function  GetNow: string;
    class procedure ProcessMessages;
    class function  GetLastError: string;
    class procedure Sleep(aMilliseconds: Cardinal);
    class function  GetAppName: string;
    class function  GetAppPath: string;
    class function  GetCPUCount: Integer;
    class function  GetOSVersion: string;
    class procedure GetDiskFreeSpace(var aFreeSpace: Int64; var aTotalSpace: Int64);
    class procedure GetMemoryFree(var aAvailMem: UInt64; var aTotalMem: UInt64);
    class function  GetVideoCard: string;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  WinApi.Windows,
  Vivace.EnvVars,
  Vivace.Utils;

{ TOS }
class function TOS.GetWorkPath: string;
begin
  Result := TPath.Combine(TPath.GetTempPath, 'Vivace');
end;

class procedure TOS.DeferDeleteWorkPathFile(aFilename: string);
var
  LFilename: string;
begin
  if aFilename.IsEmpty then Exit;
  LFilename := TPath.Combine(TOS.GetWorkPath, aFilename);
  if TFile.Exists(LFilename) then
  begin
    DeferDelFile(LFilename);
  end;
end;

class function TOS.GetComputerName: string;
var
  LLength: dword;
begin
  LLength := 253;
  SetLength(Result, LLength+1);
  if not WinApi.Windows.GetComputerName(PChar(Result), LLength) then Result := 'Not detected!';
  Result := PChar(result);
end;

class function TOS.GetLoggedUserName: string;
const
  cnMaxUserNameLen = 254;
var
  sUserName     : string;
  dwUserNameLen : DWord;
begin
  dwUserNameLen := cnMaxUserNameLen-1;
  SetLength( sUserName, cnMaxUserNameLen );
  GetUserName(PChar( sUserName ),dwUserNameLen );
  SetLength( sUserName, dwUserNameLen );
  Result := sUserName;
end;

class function TOS.GetVersion: string;
begin
  Result := TOSVersion.ToString;
end;

class function  TOS.GetNow: string;
begin
  Result := DateTimeToStr(Now());
end;

class procedure TOS.ProcessMessages;
var
  LMsg: TMsg;
begin
  while Integer(PeekMessage(LMsg, 0, 0, 0, PM_REMOVE)) <> 0 do
  begin
    TranslateMessage(LMsg);
    DispatchMessage(LMsg);
  end;
end;

class function TOS.GetLastError: string;
begin
  Result := SysErrorMessage(WinAPI.Windows.GetLastError);
end;

class procedure TOS.Sleep(aMilliseconds: Cardinal);
begin
  System.SysUtils.Sleep(aMilliseconds)
end;

class function TOS.GetAppName: string;
begin
  Result := Format('%s %s',[TPath.GetFileNameWithoutExtension(ParamStr(0)),GetAppVersionFullStr]);
end;

class function TOS.GetAppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

class function  TOS.GetCPUCount: Integer;
begin
  Result := CPUCount;
end;

class function  TOS.GetOSVersion: string;
begin
  Result := TOSVersion.ToString;
end;

class procedure TOS.GetDiskFreeSpace(var aFreeSpace: Int64; var aTotalSpace: Int64);
begin
  GetDiskFreeSpaceEx(PChar(GetWorkPath), aFreeSpace, aTotalSpace, nil);
end;

class procedure TOS.GetMemoryFree(var aAvailMem: UInt64; var aTotalMem: UInt64);
var
  LMemStatus: MemoryStatusEx;
begin
 FillChar (LMemStatus, SizeOf(MemoryStatusEx), #0);
 LMemStatus.dwLength := SizeOf(MemoryStatusEx);
 GlobalMemoryStatusEx (LMemStatus);
 //Result:= Real2Str(MS_Ex.ullTotalPhys / GB, 2)+ ' GB';
 aAvailMem := LMemStatus.ullAvailPhys;
 aTotalMem := LMemStatus.ullTotalPhys;
end;

class function TOS.GetVideoCard: string;
begin
  Result := GetVideoCardName;
end;

initialization
var
  LEnvPath: string;
begin
  // create a WorkPath
  TDirectory.CreateDirectory(TOS.GetWorkPath);

  // add WorkPath to environment
  LEnvPath :=  TOS.GetWorkPath + ';' + TEnvVars.GetValue('PATH');
  TEnvVars.SetValue('PATH', LEnvPath);
end;

finalization
begin
end;

end.
