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

unit Vivace.Buffer;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  System.Classes,
  WinAPI.Windows;

type
  { EBufferException }
  EBufferException = class(Exception);

  { TBuffer }
  TBuffer = class(TCustomMemoryStream)
  protected
    FHandle: THandle;
    FName: string;
  public
    property Name: string read FName;

    constructor Create(aSize: Integer);
    destructor Destroy; override;

    function  Write(const aBuffer; aCount: Longint): Longint; override;
    function  Write(const aBuffer: TBytes; aOffset, aCount: Longint): Longint; override;

    procedure SaveToFile(aFilename: string);

    class function FromFile(aFilename: string): TBuffer;
  end;

implementation

uses
  System.IOUtils,
  Vivace.External.Allegro;


{ TBuffer }
constructor TBuffer.Create(aSize: Integer);
var
  LPtr: Pointer;
begin
  inherited Create;

  FName := TPath.GetGUIDFileName;
  FHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, aSize, PChar(FName));
  if FHandle = 0 then
    begin
      raise EBufferException.Create('Error creating memory mapping');
      FHandle := 0;
      Destroy;
    end
  else
    begin
      LPtr := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
      if LPtr = nil then
        begin
          raise EBufferException.Create('Error creating memory mapping');
          Destroy;
        end
      else
        begin
          Self.SetPointer(LPtr, aSize);
          Position := 0;
        end;
    end;
end;

destructor TBuffer.Destroy;
begin
  if (Memory <> nil) then
  begin
    if not UnmapViewOfFile(Memory) then
      raise EBufferException.Create('Error deallocating mapped memory');
  end;

  if (FHandle <> 0) then
  begin
    if not CloseHandle(FHandle) then
      raise EBufferException.Create('Error freeing memory mapping handle');
  end;

  inherited;
end;

function TBuffer.Write(const aBuffer; aCount: Longint): Longint;
var
  LPos: Int64;
begin
  if (Position >= 0) and (aCount >= 0) then
  begin
    LPos := Position + aCount;
    if LPos > 0 then
    begin
      if LPos > Size then
      begin
        Result := 0;
        Exit;
      end;
      System.Move(aBuffer, (PByte(Memory) + Position)^, aCount);
      Position := LPos;
      Result := aCount;
      Exit;
    end;
  end;
  Result := 0;
end;

function TBuffer.Write(const aBuffer: TBytes; aOffset, aCount: Longint): Longint;
var
  LPos: Int64;
begin
  if (Position >= 0) and (aCount >= 0) then
  begin
    LPos := Position + aCount;
    if LPos > 0 then
    begin
      if LPos > Size then
      begin
        Result := 0;
        Exit;
      end;
      System.Move(aBuffer[aOffset], (PByte(Memory) + Position)^, aCount);
      Position := LPos;
      Result := aCount;
      Exit;
    end;
  end;
  Result := 0;
end;

procedure TBuffer.SaveToFile(aFilename: string);
var
  LFileStream: TFileStream;
begin
  LFileStream := TFile.Create(aFilename);
  try
    LFileStream.Write(Memory^, Size);
  finally
    LFileStream.Free;
  end;
end;

class function TBuffer.FromFile(aFilename: string): TBuffer;
var
  LMarshaller: TMarshaller;
  LStream: PALLEGRO_FILE;
  LSize: Int64;
begin
  Result := nil;
  if aFilename.IsEmpty then Exit;
  if not al_filename_exists(LMarshaller.AsAnsi(aFilename).ToPointer) then Exit;
  LStream := al_fopen(LMarshaller.AsAnsi(aFilename).ToPointer, 'rb');
  try
    LSize := al_fsize(LStream);
    Result := TBuffer.Create(LSize);
    al_fread(LStream, Result.Memory, LSize);
  finally
    al_fclose(LStream);
  end;
end;


end.
