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

unit Vivace.External.CLibs;

{$I Vivace.Defines.inc }

interface

procedure UnloadCLibs;

implementation

{$R Vivace.External.CLibs.res}

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.Zip,
  WinApi.Windows,
  idSSLOpenSSLHeaders,
  Vivace.Common,
  Vivace.Logger,
  Vivace.OS;

const
  cDeferDeleteFilename = 'Clibs.txt';

procedure LoadCLibs;
var
  LZipFile: TZipFile;
  LResStream: TResourceStream;
  LName: string;
  I: Integer;
  LSizeNeeded: Int64;
  LTotalSize: Int64;
  LFreeSize: Int64;
  LWorkPath: string;
  LFileList: TStringList;
  mDllNames: TArray<string>;
begin
  TLogger.SetLogToConsole(False);

  LWorkPath := TOS.GetWorkPath;

  // extract zip resdata
  LZipFile := TZipFile.Create;
  try
    LResStream := TResourceStream.Create(HInstance, 'CLIBS', RT_RCDATA);
    try
      LZipFile.Open(LResStream, zmRead);
      try
        LSizeNeeded := 0;
        LTotalSize := 0;
        LFreeSize := 0;
        mDllNames := nil;
        for I := 0 to LZipFile.FileCount-1 do
        begin
          LSizeNeeded := LSizeNeeded + LZipFile.FileInfo[0].UncompressedSize
        end;
        TLogger.Log(etInfo, 'Total space needed by CLibs: %d', [LSizeNeeded]);
        GetDiskFreeSpaceEx(PChar(LWorkPath), LFreeSize, LTotalSize, nil);
        TLogger.Log(etInfo, 'Total free space on workspace drive: %d', [LFreeSize]);
        if LFreeSize > LSizeNeeded then
          begin
            mDllNames := LZipFile.FileNames;
            for LName in mDllNames do
            begin
              if not TFile.Exists(TPath.Combine(LWorkPath, LName)) then
              begin
                LZipFile.Extract(LName, LWorkPath);
                if TFile.Exists(TPath.Combine(LWorkPath, LName)) then
                  TLogger.Log(etSuccess, 'Sucessfully extracted %s', [LName]);
              end;
            end;
            IdOpenSSLSetLibPath(TOS.GetWorkPath);
            LFileList := TStringList.Create;
            try
              LFilelist.AddStrings(mDLLNames);
              LFileList.SaveToFile(TPath.Combine(LWorkPath, cDeferDeleteFilename));
            finally
              FreeAndNil(LFileList);
            end;
          end
        else
          raise Exception.Create('Insufficient disk space on workspace drive');
      finally
        LZipFile.Close;
      end;
    finally
      FreeAndNil(LResStream);
    end;
  finally
    FreeAndNil(LZipFile);
  end;

  TLogger.SetLogToConsole(True);
end;

procedure UnloadCLibs;
var
  LName: string;
  LFileList: TStringList;
  LFilename: string;
begin
  LFilename := TPath.Combine(TOS.GetWorkPath, cDeferDeleteFilename);
  if not TFile.Exists(LFilename) then Exit;
  LFileList := TStringList.Create;
  LFileList.LoadFromFile(LFilename);
  for LName in LFileList do
  begin
    TOS.DeferDeleteWorkPathFile(LName);
    //FIXME: calling the logger at this point will create it again and any
    // entries will overwrite the current file already written. I need to
    // find a better way to structure the logger, for now just not log anything
    // here.
    //TLogger.Log(etInfo, 'Defer deleting %s', [LName]);
  end;
  FreeAndNil(LFileList);
  TOS.DeferDeleteWorkPathFile(LFilename);
end;

initialization
begin
  LoadCLibs;
end;

finalization
begin
  //UnloadCLibs;
end;

end.
