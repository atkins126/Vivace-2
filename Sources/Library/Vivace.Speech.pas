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

unit Vivace.Speech;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  System.Classes,
  Vivace.Base,
  Vivace.Common,
  Vivace.TLB.SpeechLib;

type

  { TSpeechVoiceAttribute }
  TSpeechVoiceAttribute = (vaDescription, vaName, vaVendor, vaAge, vaGender, vaLanguage, vaId);

  { TSpeech }
  TSpeech = class(TBaseObject)
  protected
    FSpVoice: TSpVoice;
    FVoiceList: TInterfaceList;
    FVoiceDescList: TStringList;
    FPaused: Boolean;
    FText: string;
    FWord: string;
    procedure OnWord(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant; aCharacterPosition, aLength: Integer);
    procedure OnStartStream(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant);
    procedure DoSpeak(aText: string; aFlags: Integer);
    procedure EnumVoices;
    procedure FreeVoices;
  public
    constructor Create; override;
    destructor Destroy; override;

    function  GetVoiceCount: Integer;
    function  GetVoiceAttribute(aIndex: Integer; aAttribute: TSpeechVoiceAttribute): string;
    procedure ChangeVoice(aIndex: Integer);

    procedure SetVolume(aVolume: Single);
    function  GetVolume: Single;

    procedure SetRate(aRate: Single);
    function  GetRate: Single;

    procedure Clear;
    procedure Speak(aText: string; aPurge: Boolean);
    procedure SpeakXML(aText: string; aPurge: Boolean);

    function  Active: Boolean;
    procedure Pause;
    procedure Resume;
    procedure Reset;
  end;

implementation

uses
  Vivace.Utils,
  Vivace.Engine;

{  TSpeech }
procedure TSpeech.OnWord(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant; aCharacterPosition, aLength: Integer);
begin
  if FText.IsEmpty then Exit;
  FWord := FText.Substring(aCharacterPosition, aLength);
  gEngine.OnSpeechWord(FWord, FText);
end;

procedure TSpeech.OnStartStream(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant);
begin
end;

procedure TSpeech.DoSpeak(aText: string; aFlags: Integer);
begin
  if FSpVoice = nil then Exit;
  if aText.IsEmpty then Exit;
  if FPaused then Resume;
  FSpVoice.Speak(aText, aFlags);
  FText := aText;
end;

procedure TSpeech.EnumVoices;
var
  I: Integer;
  LSOToken: ISpeechObjectToken;
  LSOTokens: ISpeechObjectTokens;
begin
  FVoiceList := TInterfaceList.Create;
  FVoiceDescList := TStringList.Create;
  LSOTokens := FSpVoice.GetVoices('', '');
  for I := 0 to LSOTokens.Count - 1 do
  begin
    LSOToken := LSOTokens.Item(I);
    FVoiceDescList.Add(LSOToken.GetDescription(0));
    FVoiceList.Add(LSOToken);
  end;
end;

procedure TSpeech.FreeVoices;
begin
  FreeAndNil(FVoiceDescList);
  FreeAndNil(FVoiceList);
end;

constructor TSpeech.Create;
begin
  inherited;
  FPaused := False;
  FText := '';
  FWord := '';
  FSpVoice := TSpVoice.Create(nil);
  FSpVoice.EventInterests := SVEAllEvents;
  EnumVoices;
  //FSpVoice.OnStartStream := OnStartStream;
  FSpVoice.OnWord := OnWord;
end;

destructor TSpeech.Destroy;
begin
  FreeVoices;
  FSpVoice.OnWord := nil;
  FSpVoice.Free;
  inherited;
end;

function TSpeech.GetVoiceCount: Integer;
begin
  Result := FVoiceList.Count;
end;

function TSpeech.GetVoiceAttribute(aIndex: Integer; aAttribute: TSpeechVoiceAttribute): string;
var
  LSOToken: ISpeechObjectToken;

  function GetAttr(aItem: string): string;
  begin
    if aItem = 'Id' then
      Result := LSOToken.Id
    else
      Result := LSOToken.GetAttribute(aItem);
  end;

begin
  Result := '';
  if (aIndex < 0) or (aIndex > FVoiceList.Count - 1) then
    Exit;
  LSOToken := ISpeechObjectToken(FVoiceList.Items[aIndex]);
  case aAttribute of
    vaDescription:
      Result := FVoiceDescList[aIndex];
    vaName:
      Result := GetAttr('Name');
    vaVendor:
      Result := GetAttr('Vendor');
    vaAge:
      Result := GetAttr('Age');
    vaGender:
      Result := GetAttr('Gender');
    vaLanguage:
      Result := GetAttr('Language');
    vaId:
      Result := GetAttr('Id');
  end;
end;

procedure TSpeech.ChangeVoice(aIndex: Integer);
var
  LSOToken: ISpeechObjectToken;
begin
  if (aIndex < 0) or (aIndex > FVoiceList.Count - 1) then
    Exit;
  LSOToken := ISpeechObjectToken(FVoiceList.Items[aIndex]);
  FSpVoice.Voice := LSOToken;
end;

procedure TSpeech.SetVolume(aVolume: Single);
var
  LVolume: Integer;
begin
  if aVolume < 0 then
    aVolume := 0
  else if aVolume > 1 then
    aVolume := 1;

  LVolume := Round(100.0 * aVolume);

  if FSpVoice = nil then
    Exit;
  FSpVoice.Volume := LVolume;
end;

function TSpeech.GetVolume: Single;
begin
  Result := 0;
  if FSpVoice = nil then
    Exit;
  Result := FSpVoice.Volume / 100.0;
end;

procedure TSpeech.SetRate(aRate: Single);
var
  LVolume: Integer;
begin
  if aRate < 0 then
    aRate := 0
  else if aRate > 1 then
    aRate := 1;

  LVolume := Round(20.0 * aRate) - 10;

  if LVolume < -10 then
    LVolume := -10
  else if LVolume > 10 then
    LVolume := 10;

  if FSpVoice = nil then
    Exit;
  FSpVoice.Rate := LVolume;
end;

function TSpeech.GetRate: Single;
begin
  Result := 0;
  if FSpVoice = nil then
    Exit;
  Result := (FSpVoice.Rate + 10.0) / 20.0;
end;

procedure TSpeech.Speak(aText: string; aPurge: Boolean);
var
  LFlag: Integer;
  LText: string;
begin
  LFlag := SVSFlagsAsync;
  LText := aText;
  if aPurge then
    LFlag := LFlag or SVSFPurgeBeforeSpeak;
  DoSpeak(LText, LFlag);
end;

procedure TSpeech.SpeakXML(aText: string; aPurge: Boolean);
var
  LFlag: Integer;
  LText: string;
begin
  LFlag := SVSFlagsAsync or SVSFIsXML;
  if aPurge then
    LFlag := LFlag or SVSFPurgeBeforeSpeak;
  LText := aText;
  DoSpeak(aText, LFlag);
end;

procedure TSpeech.Clear;
begin
  if FSpVoice = nil then
    Exit;
  if Active then
  begin
    FSpVoice.Skip('Sentence', MaxInt);
    Speak(' ', True);
  end;
  FText := '';
end;

function TSpeech.Active: Boolean;
begin
  Result := False;
  if FSpVoice = nil then
    Exit;
  Result := Boolean(FSpVoice.Status.RunningState <> SRSEDone);
end;

procedure TSpeech.Pause;
begin
  if FSpVoice = nil then
    Exit;
  FSpVoice.Pause;
  FPaused := True;
end;

procedure TSpeech.Resume;
begin
  if FSpVoice = nil then
    Exit;
  FSpVoice.Resume;
  FPaused := False;
end;

procedure TSpeech.Reset;
begin
  Clear;
  FreeAndNil(FSpVoice);
  FPaused := False;
  FText := '';
  FWord := '';
  FSpVoice := TSpVoice.Create(nil);
  FSpVoice.EventInterests := SVEAllEvents;
  EnumVoices;
  //FSpVoice.OnStartStream := OnStartStream;
  FSpVoice.OnWord := OnWord;
end;


end.
