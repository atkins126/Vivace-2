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
    constructor Create(aSize: Integer);
    destructor Destroy; override;
    function Write(const aBuffer; aCount: Longint): Longint; override;
    function Write(const aBuffer: TBytes; aOffset, aCount: Longint): Longint; override;
    procedure SaveToFile(aFilename: string);
    property Name: string read FName;
  end;

implementation

uses
  System.IOUtils;

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

end.
