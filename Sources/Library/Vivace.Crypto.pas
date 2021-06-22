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

unit Vivace.Crypto;

{$I Vivace.Defines.inc }

interface

type

  { TCrpyto }
  TCrpyto = class
  public
    class function Encrypt(aPassword: string; aValue: string): string;
    class function Decrypt(aPassword: string; aValue: string): string;
  end;

implementation

uses
  System.SysUtils,
  WinAPI.Windows,
  IdCoderMIME,
  IdGlobal,
  Vivace.Utils,
  Vivace.Engine;

type
  HCRYPTPROV  = Cardinal;
  HCRYPTKEY   = Cardinal;
  ALG_ID      = Cardinal;
  HCRYPTHASH  = Cardinal;
const
  _lib_ADVAPI32    = 'ADVAPI32.dll';
  CALG_SHA_256     = 32780;
  CALG_AES_128     = 26126;
  CRYPT_NEWKEYSET  = $00000008;
  PROV_RSA_AES     = 24;
  KP_MODE          = 4;
  CRYPT_MODE_CBC   = 1;
function CryptAcquireContext(var Prov: HCRYPTPROV; Container: PChar; Provider: PChar; ProvType: LongWord; Flags: LongWord): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptAcquireContextW';
function CryptDeriveKey(Prov: HCRYPTPROV; Algid: ALG_ID; BaseData: HCRYPTHASH; Flags: LongWord; var Key: HCRYPTKEY): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptDeriveKey';
function CryptSetKeyParam(hKey: HCRYPTKEY; dwParam: LongInt; pbData: PBYTE; dwFlags: LongInt): LongBool stdcall; stdcall; external _lib_ADVAPI32 name 'CryptSetKeyParam';
function CryptEncrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: LongBool; Flags: LongWord; pbData: PBYTE; var Len: LongInt; BufLen: LongInt): LongBool;stdcall;external _lib_ADVAPI32 name 'CryptEncrypt';
function CryptDecrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: LongBool; Flags: LongWord; pbData: PBYTE; var Len: LongInt): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptDecrypt';
function CryptCreateHash(Prov: HCRYPTPROV; Algid: ALG_ID; Key: HCRYPTKEY; Flags: LongWord; var Hash: HCRYPTHASH): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptCreateHash';
function CryptHashData(Hash: HCRYPTHASH; Data: PChar; DataLen: LongWord; Flags: LongWord): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptHashData';
function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: LongWord): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptReleaseContext';
function CryptDestroyHash(hHash: HCRYPTHASH): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptDestroyHash';
function CryptDestroyKey(hKey: HCRYPTKEY): LongBool; stdcall; external _lib_ADVAPI32 name 'CryptDestroyKey';
{$WARN SYMBOL_PLATFORM OFF}
function __CryptAcquireContext(ProviderType: Integer): HCRYPTPROV;
begin
  if (not CryptAcquireContext(Result, nil, nil, ProviderType, 0)) then
  begin
    if HRESULT(GetLastError) = NTE_BAD_KEYSET then
      Win32Check(CryptAcquireContext(Result, nil, nil, ProviderType, CRYPT_NEWKEYSET))
    else
      RaiseLastOSError;
  end;
end;
function __AES128_DeriveKeyFromPassword(m_hProv: HCRYPTPROV; Password: string): HCRYPTKEY;
var
  hHash: HCRYPTHASH;
  Mode: DWORD;
begin
  Win32Check(CryptCreateHash(m_hProv, CALG_SHA_256, 0, 0, hHash));
  try
    Win32Check(CryptHashData(hHash, PChar(Password), Length(Password) * SizeOf(Char), 0));
    Win32Check(CryptDeriveKey(m_hProv, CALG_AES_128, hHash, 0, Result));
    // Wine uses a different default mode of CRYPT_MODE_EBC
    Mode := CRYPT_MODE_CBC;
    Win32Check(CryptSetKeyParam(Result, KP_MODE, Pointer(@Mode), 0));
  finally
    CryptDestroyHash(hHash);
  end;
end;
function Base64_Encode(Value: TBytes): string;
var
  Encoder: TIdEncoderMIME;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Result := Encoder.EncodeBytes(TIdBytes(Value));
  finally
    Encoder.Free;
  end;
end;
function Base64_Decode(Value: string): TBytes;
var
  Encoder: TIdDecoderMIME;
begin
  Encoder := TIdDecoderMIME.Create(nil);
  try
    Result := TBytes(Encoder.DecodeBytes(Value));
  finally
    Encoder.Free;
  end;
end;
{ TCrpyto }
class function TCrpyto.Encrypt(aPassword: string; aValue: string): string;
var
  hCProv: HCRYPTPROV;
  hKey: HCRYPTKEY;
  lul_datalen: Integer;
  lul_buflen: Integer;
  Buffer: TBytes;
begin
  Assert(aPassword <> '');
  if (aValue = '') then
    Result := ''
  else begin
    hCProv := __CryptAcquireContext(PROV_RSA_AES);
    try
      hKey := __AES128_DeriveKeyFromPassword(hCProv, aPassword);
      try
        // allocate buffer space
        lul_datalen := Length(aValue) * SizeOf(Char);
        Buffer := TEncoding.Unicode.GetBytes(aValue + '        ');
        lul_buflen := Length(Buffer);
        // encrypt to buffer
        Win32Check(CryptEncrypt(hKey, 0, True, 0, @Buffer[0], lul_datalen, lul_buflen));
        SetLength(Buffer, lul_datalen);
        // base 64 result
        Result := Base64_Encode(Buffer);
      finally
        CryptDestroyKey(hKey);
      end;
    finally
      CryptReleaseContext(hCProv, 0);
    end;
  end;
end;
class function TCrpyto.Decrypt(aPassword: string; aValue: string): string;
var
  hCProv: HCRYPTPROV;
  hKey: HCRYPTKEY;
  lul_datalen: Integer;
  Buffer: TBytes;
begin
  Assert(aPassword <> '');
  if aValue = '' then
    Result := ''
  else begin
    hCProv := __CryptAcquireContext(PROV_RSA_AES);
    try
      hKey := __AES128_DeriveKeyFromPassword(hCProv, aPassword);
      try
        // decode base64
        Buffer := Base64_Decode(aValue);
        // allocate buffer space
        lul_datalen := Length(Buffer);
        // decrypt buffer to to string
        Win32Check(CryptDecrypt(hKey, 0, True, 0, @Buffer[0], lul_datalen));
        Result := TEncoding.Unicode.GetString(Buffer, 0, lul_datalen);
      finally
        CryptDestroyKey(hKey);
      end;
    finally
      CryptReleaseContext(hCProv, 0);
    end;
  end;
end;

end.
