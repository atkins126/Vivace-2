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

unit Vivace.KeyValueData;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  System.Classes,
  Vivace.Base,
  Vivace.Common;

type

  { TKeyValueData }
  TKeyValueData = class
  protected
    FData: TStringList;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Clear;

    procedure Load(aFilename: string);
    procedure Save(aFilename: string);

    procedure SetData(aKey: string; aValue: string);
    function  GetData(aKey: string): string;
  end;

implementation

uses
  System.IOUtils,
  Vivace.External.Allegro,
  Vivace.Utils,
  Vivace.Engine,
  Vivace.Buffer,
  Vivace.Crypto;

{ TKeyValueData }
constructor TKeyValueData.Create;
begin
  inherited;

  FData := TStringList.Create;
end;

destructor TKeyValueData.Destroy;
begin
  FreeAndNil(FData);

  inherited;
end;

procedure TKeyValueData.Clear;
begin
  FData.Clear;
end;

procedure TKeyValueData.Load(aFilename: string);
var
  LMarshaller: TMarshaller;
  LHandle: Pointer;
  LBuffer: TBuffer;
  LSize: Int64;
  LStream: TFileStream;
begin
  if aFilename.IsEmpty then  Exit;
  LBuffer := nil;

  LHandle := PHYSFS_openRead(LMarshaller.AsAnsi(aFilename).ToPointer);
  if LHandle <> nil then
  begin
    LSize := PHYSFS_fileLength(LHandle);
    LBuffer := TBuffer.Create(LSize);
    PHYSFS_readBytes(LHandle, LBuffer.Memory, LSize);
    PHYSFS_close(LHandle);
  end;

  // try to load from filesystem
  if LBuffer = nil then
  begin
    if not TFile.Exists(aFilename) then Exit;
    LSize := GetFileSize(aFilename);
    LBuffer := TBuffer.Create(LSize);
    LStream := TFile.OpenRead(aFilename);
    LStream.ReadBuffer(LBuffer.Memory^, LSize);
    FreeAndNil(LStream);
  end;

  if LBuffer <> nil then
  begin
    FData.Clear;
    LBuffer.Position := 0;
    FData.LoadFromStream(LBuffer);
    FreeAndNil(LBuffer);
  end;
end;

procedure TKeyValueData.Save(aFilename: string);
begin
  FData.SaveToFile(aFilename);
end;

procedure TKeyValueData.SetData(aKey: string; aValue: string);
begin
  FData.Values[aKey] := aValue;
end;

function TKeyValueData.GetData(aKey: string): string;
begin
  Result := FData.Values[aKey];
end;

end.
