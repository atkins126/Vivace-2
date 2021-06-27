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

unit Vivace.Audio;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Vivace.Base,
  Vivace.Buffer,
  Vivace.External.Allegro,
  Vivace.External.CSFMLAudio;

const
  AUDIO_BUFFER_COUNT = 256;
  AUDIO_CHANNEL_COUNT = 16;
  AUDIO_DYNAMIC_CHANNEL = -1;
  AUDIO_INVALID_INDEX = -2;

type
  { TAudioStatus }
  TAudioStatus = (asStopped, asPaused, asPlaying);

  { TMusicItem }
  TMusicItem = record
    FileHandle: Pointer;
    MusicHandle: PsfMusic;
    Buffer: TBuffer;
    Size: Int64;
    Filename: string;
  end;

  { TAudioChannel }
  TAudioChannel = record
    Sound: PsfSound;
    Reserved: Boolean;
    Priority: Byte;
  end;

  { TAudioBuffer }
  TAudioBuffer = record
    Buffer: PsfSoundBuffer;
    Filename: string;
  end;

  { TAudio }
  TAudio = class(TBaseObject)
  protected
    FMusicList: TList<TMusicItem>;
    FBuffer: array [0 .. AUDIO_BUFFER_COUNT - 1] of TAudioBuffer;
    FChannel: array [0 .. AUDIO_CHANNEL_COUNT - 1] of TAudioChannel;
    FOpened: Boolean;
    function TimeAsSeconds(aValue: Single): TsfTime;
    function TimeAsMilliSeconds(aValue: Integer): TsfTime;
    function GetMusicItem(var aMusicItem: TMusicItem; aMusic: Integer): Boolean;
    function AddMusicItem(var aMusicItem: TMusicItem): Integer;
    function FindFreeBuffer(aFilename: string): Integer;
    function FindFreeChannel: Integer;
    procedure Setup;
    procedure Shutdown;
  public
    constructor Create; override;
    destructor Destroy; override;

    // General
    procedure Open;
    procedure Close;
    procedure Pause(aPause: Boolean);

    // Music
    function  LoadMusic(aFilename: string): Integer;
    procedure UnloadMusic(var aMusic: Integer);
    procedure UnloadAllMusic;
    procedure PlayMusic(aMusic: Integer); overload;
    procedure PlayMusic(aMusic: Integer; aVolume: Single; aLoop: Boolean); overload;
    procedure StopMusic(aMusic: Integer);
    procedure PauseMusic(aMusic: Integer);
    procedure PauseAllMusic(aPause: Boolean);
    procedure SetMusicLoop(aMusic: Integer; aLoop: Boolean);
    function  GetMusicLoop(aMusic: Integer): Boolean;
    procedure SetMusicVolume(aMusic: Integer; aVolume: Single);
    function  GetMusicVolume(aMusic: Integer): Single;
    function  GetMusicStatus(aMusic: Integer): TAudioStatus;
    procedure SetMusicOffset(aMusic: Integer; aSeconds: Single);

    // Sound
    function  LoadSound(aFilename: string): Integer;
    procedure UnloadSound(aSound: Integer);
    function  PlaySound(aChannel: Integer; aSound: Integer): Integer; overload;
    function  PlaySound(aChannel: Integer; aSound: Integer; aVolume: Single; aLoop: Boolean): Integer; overload;

    // Channel
    procedure SetChannelReserved(aChannel: Integer; aReserve: Boolean);
    function  GetChannelReserved(aChannel: Integer): Boolean;
    procedure PauseChannel(aChannel: Integer; aPause: Boolean);
    function  GetChannelStatus(aChannel: Integer): TAudioStatus;
    procedure SetChannelVolume(aChannel: Integer; aVolume: Single);
    function  GetChannelVolume(aChannel: Integer): Single;
    procedure SetChannelLoop(aChannel: Integer; aLoop: Boolean);
    function  GetChannelLoop(aChannel: Integer): Boolean;
    procedure SetChannelPitch(aChannel: Integer; aPitch: Single);
    function  GetChannelPitch(aChannel: Integer): Single;
    procedure SetChannelPosition(aChannel: Integer; aX: Single; aY: Single);
    procedure GetChannelPosition(aChannel: Integer; var aX: Single; var aY: Single);
    procedure SetChannelMinDistance(aChannel: Integer; aDistance: Single);
    function  GetChannelMinDistance(aChannel: Integer): Single;
    procedure SetChannelRelativeToListener(aChannel: Integer; aRelative: Boolean);
    function  GetChannelRelativeToListener(aChannel: Integer): Boolean;
    procedure SetChannelAttenuation(aChannel: Integer; aAttenuation: Single);
    function  GetChannelAttenuation(aChannel: Integer): Single;
    procedure StopChannel(aChannel: Integer);
    procedure StopAllChannels;

    // Listener
    procedure SetListenerGlobalVolume(aVolume: Single);
    function  GetListenerGlobalVolume: Single;
    procedure SetListenerPosition(aX: Single; aY: Single);
    procedure GetListenerPosition(var aX: Single; var aY: Single);
  end;

implementation

uses
  System.IOUtils,
  Vivace.Utils,
  Vivace.Common,
  Vivace.Logger;


{ TAudio }
function TAudio.TimeAsSeconds(aValue: Single): TsfTime;
begin
  Result.MicroSeconds := Round(aValue * 1000000);
end;

function TAudio.TimeAsMilliSeconds(aValue: Integer): TsfTime;
begin
  Result.MicroSeconds := Round(aValue * 1000);
end;

function TAudio.GetMusicItem(var aMusicItem: TMusicItem; aMusic: Integer): Boolean;
begin
  // assume false
  Result := False;

  // check for valid music id
  if (aMusic < 0) or (aMusic > FMusicList.Count-1) then Exit;

  // get item
  aMusicItem := FMusicList.Items[aMusic];

  // check if valid
  if aMusicItem.MusicHandle = nil then
    Result := False
  else
    // return true
    Result := True;
end;

function TAudio.AddMusicItem(var aMusicItem: TMusicItem): Integer;
var
  LIndex: Integer;
  LItem: TMusicItem;
begin
  Result := -1;
  for LIndex := 0 to FMusicList.Count-1 do
  begin
    LItem := FMusicList.Items[LIndex];
    if LItem.MusicHandle = nil then
    begin
      FMusicList.Items[LIndex] := aMusicItem;
      Result := LIndex;
      Exit;
    end;
  end;

  if LItem.MusicHandle <> nil then
  begin
    Result := FMusicList.Add(aMusicItem);
  end;
end;

function TAudio.FindFreeBuffer(aFilename: string): Integer;
var
  LI: Integer;
begin
  Result := AUDIO_INVALID_INDEX;
  for LI := 0 to AUDIO_BUFFER_COUNT - 1 do
  begin
    if FBuffer[LI].Filename = aFilename then
    begin
      Exit;
    end;

    if FBuffer[LI].Buffer = nil then
    begin
      Result := LI;
      Break;
    end;
  end;
end;

function TAudio.FindFreeChannel: Integer;
var
  LI: Integer;
begin
  Result := AUDIO_INVALID_INDEX;
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    if sfSound_getStatus(FChannel[LI].Sound) = sfStopped then
    begin
      if not FChannel[LI].Reserved then
      begin
        Result := LI;
        Break;
      end;
    end;
  end;
end;

procedure TAudio.Setup;
var
  LI: Integer;
begin
  if FOpened then Exit;

  // init music list
  FMusicList := TList<TMusicItem>.Create;

  // init channels
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    FChannel[LI].Sound := sfSound_create;
    FChannel[LI].Reserved := False;
    FChannel[LI].Priority := 0;
  end;

  // init buffers
  for LI := 0 to AUDIO_BUFFER_COUNT - 1 do
  begin
    FBuffer[LI].Buffer := nil;
  end;

  FOpened := True;
end;

procedure TAudio.Shutdown;
var
  LI: Integer;
begin
  if not FOpened then Exit;

  // shutdown music
  UnloadAllMusic;
  FreeAndNil(FMusicList);

  // shutdown channels
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    if FChannel[LI].Sound <> nil then
    begin
      sfSound_destroy(FChannel[LI].Sound);
      FChannel[LI].Reserved := False;
      FChannel[LI].Priority := 0;
      FChannel[LI].Sound := nil;
    end;
  end;

  // shutdown buffers
  for LI := 0 to AUDIO_BUFFER_COUNT - 1 do
  begin
    if FBuffer[LI].Buffer <> nil then
    begin
      sfSoundBuffer_destroy(FBuffer[LI].Buffer);
      FBuffer[LI].Buffer := nil;
    end;
  end;

  FillChar(FBuffer, SizeOf(FBuffer), 0);
  FillChar(FChannel, SizeOf(FChannel), 0);
  FOpened := False;
end;

constructor TAudio.Create;
begin
  inherited;

  FillChar(FBuffer, SizeOf(FBuffer), 0);
  FillChar(FChannel, SizeOf(FChannel), 0);
  FOpened := False;
  Setup;
end;

destructor TAudio.Destroy;
begin
  Shutdown;

  inherited;
end;

procedure TAudio.Open;
begin
  Setup;
end;

procedure TAudio.Close;
begin
  Shutdown;
end;

procedure TAudio.Pause(aPause: Boolean);
var
  LI: Integer;
begin
  //TMusic.PauseAll(aPause);
  PauseAllMusic(aPause);

  // pause channel
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    PauseChannel(LI, aPause);
  end;
end;

//TODO: check of music is already loaded
function TAudio.LoadMusic(aFilename: string): Integer;
var
  LMarshaller: TMarshaller;
  LItem: TMusicItem;
begin
  Result := -1;

  // init music item
  LItem.FileHandle := nil;
  LItem.MusicHandle := nil;
  LItem.Buffer := nil;
  LItem.Size := 0;

  // try to load from PhysicalFS
  if PHYSFS_isInit then
  begin
    LItem.FileHandle := PHYSFS_openRead(LMarshaller.AsAnsi(aFilename).ToPointer);
    if LItem.FileHandle <> nil then
    begin
      LItem.Size := PHYSFS_fileLength(LItem.FileHandle);
      LItem.Buffer := TBuffer.Create(LItem.Size);
      PHYSFS_readBytes(LItem.FileHandle, LItem.Buffer.Memory, LItem.Size);
      LItem.MusicHandle := sfMusic_createFromMemory(LItem.Buffer.Memory, LItem.Size);
      LItem.Filename := aFilename;
    end;
  end;

  // try to load from filesystem
  if LItem.FileHandle = nil then
  begin
    if not TFile.Exists(aFilename) then Exit;
    LItem.Size := GetFileSize(aFilename);
    LItem.MusicHandle := sfMusic_createFromFile(LMarshaller.AsAnsi(aFilename).ToPointer);
    if LItem.MusicHandle = nil then Exit;
    LItem.Buffer := nil;
  end;

  // add to list
  Result := AddMusicItem(LItem);

  TLogger.Log(etSuccess, 'Sucessfully loaded music "%s"', [aFilename]);
end;

procedure TAudio.UnloadMusic(var aMusic: Integer);
var
  LItem: TMusicItem;
begin
  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // stop music
  StopMusic(aMusic);

  // free music handle
  sfMusic_destroy(LItem.MusicHandle);

  // free music buffer
  if LItem.Buffer <> nil then
  begin
    FreeAndNil(LItem.Buffer);
  end;

  // close PhsycialFS handle
  if LItem.FileHandle <> nil then
  begin
    PHYSFS_close(LItem.FileHandle);
  end;

  // clear item data
  LItem.FileHandle := nil;
  LItem.MusicHandle := nil;
  LItem.Buffer := nil;
  LItem.Size := 0;
  FMusicList.Items[aMusic] := LItem;

  TLogger.Log(etInfo, 'Unloaded music "%s"', [LItem.Filename]);

  // return handle as invalid
  aMusic := -1;
end;

procedure TAudio.UnloadAllMusic;
var
  LIndex: Integer;
  LMusic: Integer;
begin
  for LIndex := 0 to FMusicList.Count-1 do
  begin
    LMusic := LIndex;
    StopMusic(LMusic);
    UnloadMusic(LMusic);
  end;
end;

procedure TAudio.PlayMusic(aMusic: Integer);
var
  LItem: TMusicItem;
begin
  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // play music
  sfMusic_play(LItem.MusicHandle);
end;

procedure TAudio.PlayMusic(aMusic: Integer; aVolume: Single; aLoop: Boolean);
begin
  PlayMusic(aMusic);
  SetMusicVolume(aMusic, aVolume);
  SetMusicLoop(aMusic, aLoop);
end;

procedure TAudio.StopMusic(aMusic: Integer);
var
  LItem: TMusicItem;
begin
  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // stop music playing
  sfMusic_stop(LItem.MusicHandle);
end;

procedure TAudio.PauseMusic(aMusic: Integer);
var
  LItem: TMusicItem;
begin
  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // pause audio
  sfMusic_pause(LItem.MusicHandle);
end;

procedure TAudio.PauseAllMusic(aPause: Boolean);
var
  LItem: TMusicItem;
  LIndex: Integer;
begin
  for LIndex := 0 to FMusicList.Count-1 do
  begin
    if GetMusicItem(LItem, LIndex) then
    begin
      if aPause then
        PauseMusic(LIndex)
      else
        PlayMusic(LIndex);
    end;
  end;
end;

procedure TAudio.SetMusicLoop(aMusic: Integer; aLoop: Boolean);
var
  LItem: TMusicItem;
begin
  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // set music loop status
  sfMusic_setLoop(LItem.MusicHandle, Ord(aLoop));
end;

function TAudio.GetMusicLoop(aMusic: Integer): Boolean;
var
  LItem: TMusicItem;
begin
  Result := False;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // get music loop status
  Result := Boolean(sfMusic_getLoop(LItem.MusicHandle));
end;

procedure TAudio.SetMusicVolume(aMusic: Integer; aVolume: Single);
var
  LVol: Single;
  LItem: TMusicItem;
begin
  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // check volume range
  if aVolume < 0 then
    aVolume := 0
  else if aVolume > 1 then
    aVolume := 1;

  // unnormalize value
  LVol := aVolume * 100;

  // set music volume
  sfMusic_setVolume(LItem.MusicHandle, LVol);
end;

function TAudio.GetMusicVolume(aMusic: Integer): Single;
var
  LItem: TMusicItem;
begin
  Result := 0;
  if not GetMusicItem(LItem, aMusic) then Exit;
  Result := sfMusic_getVolume(LItem.MusicHandle);
  Result := Result / 100;
end;

function TAudio.GetMusicStatus(aMusic: Integer): TAudioStatus;
var
  LItem: TMusicItem;
begin
  Result := asStopped;
  if not GetMusicItem(LItem, aMusic) then Exit;
  Result := TAudioStatus(sfMusic_getStatus(LItem.MusicHandle));
end;

procedure TAudio.SetMusicOffset(aMusic: Integer; aSeconds: Single);
var
  LItem: TMusicItem;
begin
  if not GetMusicItem(LItem, aMusic) then Exit;
  sfMusic_setPlayingOffset(LItem.MusicHandle, TimeAsSeconds(aSeconds));
end;

procedure TAudio.SetChannelReserved(aChannel: Integer; aReserve: Boolean);
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  FChannel[aChannel].Reserved := aReserve;
end;

function TAudio.GetChannelReserved(aChannel: Integer): Boolean;
begin
  Result := False;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then  Exit;
  Result := FChannel[aChannel].Reserved;
end;

function TAudio.LoadSound(aFilename: string): Integer;
var
  LI: Integer;
  LFileHandle: Pointer;
  LMarshaller: TMarshaller;
  LSize: Int64;
  LBuffer: TBuffer;
begin
  Result := AUDIO_INVALID_INDEX;

  if aFilename.IsEmpty then Exit;

  LI := FindFreeBuffer(aFilename);
  if LI = AUDIO_INVALID_INDEX then Exit;

  LFileHandle := nil;

  // try to load from PhysicalFS
  if PHYSFS_isInit then
  begin
    LFileHandle := PHYSFS_openRead(LMarshaller.AsAnsi(aFilename).ToPointer);
    if LFileHandle <> nil then
    begin
      try
        LSize := PHYSFS_fileLength(LFileHandle);
        LBuffer := TBuffer.Create(LSize);
        try
          PHYSFS_readBytes(LFileHandle, LBuffer.Memory, LSize);
          FBuffer[LI].Buffer := sfSoundBuffer_createFromMemory(LBuffer.Memory, LSize);
        finally
          FreeAndNil(LBuffer);
        end;
      finally
        PHYSFS_close(LFileHandle);
      end;
    end;
  end;

  // try to load from filesystem
  if LFileHandle = nil then
  begin
    if not TFile.Exists(aFilename) then Exit;
    FBuffer[LI].Buffer := sfSoundBuffer_createFromFile(LMarshaller.AsAnsi(aFilename).ToPointer);
    if FBuffer[LI].Buffer = nil then Exit;
  end;

  FBuffer[LI].Filename := aFilename;
  TLogger.Log(etSuccess, 'Sucessfully loaded sound "%s"', [aFilename]);

  Result := LI;
end;

procedure TAudio.UnloadSound(aSound: Integer);
var
  LBuff: PsfSoundBuffer;
  LSnd: PsfSound;
  LI: Integer;
begin
  if (aSound < 0) or (aSound > AUDIO_BUFFER_COUNT - 1) then  Exit;
  LBuff := FBuffer[aSound].Buffer;
  if LBuff = nil then Exit;

  // stop all channels playing this buffer
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    LSnd := FChannel[LI].Sound;
    if LSnd <> nil then
    begin
      if sfSound_getBuffer(LSnd) = LBuff then
      begin
        sfSound_stop(LSnd);
        sfSound_destroy(LSnd);
        FChannel[LI].Sound := nil;
        FChannel[LI].Reserved := False;
        FChannel[LI].Priority := 0;
      end;
    end;
  end;

  // destroy this buffer
  sfSoundBuffer_destroy(LBuff);
  TLogger.Log(etInfo, 'Unloaded sound "%s"', [FBuffer[aSound].Filename]);
  FBuffer[aSound].Buffer := nil;
  FBuffer[aSound].Filename := '';
end;

function TAudio.PlaySound(aChannel: Integer; aSound: Integer): Integer;
var
  LI: Integer;
begin
  Result := AUDIO_INVALID_INDEX;

  // check if sound is in range
  if (aSound < 0) or (aSound > AUDIO_BUFFER_COUNT - 1) then Exit;

  // check if channel is in range
  LI := aChannel;
  if LI = AUDIO_DYNAMIC_CHANNEL then LI := FindFreeChannel
  else if (LI < 0) or (LI > AUDIO_CHANNEL_COUNT - 1) then Exit;

  // play sound
  sfSound_setBuffer(FChannel[LI].Sound, FBuffer[aSound].Buffer);
  sfSound_play(FChannel[LI].Sound);
  sfSound_setAttenuation(FChannel[LI].Sound, 0);

  Result := LI;
end;

function TAudio.PlaySound(aChannel: Integer; aSound: Integer; aVolume: Single; aLoop: Boolean): Integer;
begin
  Result := PlaySound(aChannel, aSound);
  SetChannelVolume(Result, aVolume);
  SetChannelLoop(Result, aLoop);
end;

procedure TAudio.PauseChannel(aChannel: Integer; aPause: Boolean);
var
  LStatus: TsfSoundStatus;
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;

  LStatus := sfSound_getStatus(FChannel[aChannel].Sound);

  case aPause of
    False:
      begin
        if LStatus = sfPaused then
          sfSound_play(FChannel[aChannel].Sound);
      end;
    True:
      begin
        if LStatus = sfPlaying then
          sfSound_pause(FChannel[aChannel].Sound);
      end;
  end;
end;

function TAudio.GetChannelStatus(aChannel: Integer): TAudioStatus;
begin
  Result := asStopped;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := TAudioStatus(sfSound_getStatus(FChannel[aChannel].Sound));
end;

procedure TAudio.SetChannelVolume(aChannel: Integer; aVolume: Single);
var
  LV: Single;
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;

  if aVolume < 0 then
    aVolume := 0
  else if aVolume > 1 then
    aVolume := 1;

  LV := aVolume * 100;
  sfSound_setVolume(FChannel[aChannel].Sound, LV);
end;

function TAudio.GetChannelVolume(aChannel: Integer): Single;
begin
  Result := 0;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := sfSound_getVolume(FChannel[aChannel].Sound);
  Result := Result / 100;
end;

procedure TAudio.SetChannelLoop(aChannel: Integer; aLoop: Boolean);
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_setLoop(FChannel[aChannel].Sound, Ord(aLoop));
end;

function TAudio.GetChannelLoop(aChannel: Integer): Boolean;
begin
  Result := False;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := Boolean(sfSound_getLoop(FChannel[aChannel].Sound));
end;

procedure TAudio.SetChannelPitch(aChannel: Integer; aPitch: Single);
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_setPitch(FChannel[aChannel].Sound, aPitch);
end;

function TAudio.GetChannelPitch(aChannel: Integer): Single;
begin
  Result := 0;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then  Exit;
  Result := sfSound_getPitch(FChannel[aChannel].Sound);
end;

procedure TAudio.SetChannelPosition(aChannel: Integer; aX: Single; aY: Single);
var
  LV: TsfVector3f;
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  LV.X := aX;
  LV.Y := 0;
  LV.Z := aY;
  sfSound_setPosition(FChannel[aChannel].Sound, LV);
end;

procedure TAudio.GetChannelPosition(aChannel: Integer; var aX: Single; var aY: Single);
var
  LV: TsfVector3f;
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  LV := sfSound_getPosition(FChannel[aChannel].Sound);
  aX := LV.X;
  aY := LV.Z;
end;

procedure TAudio.SetChannelMinDistance(aChannel: Integer; aDistance: Single);
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  if aDistance < 1 then  aDistance := 1;
  sfSound_setMinDistance(FChannel[aChannel].Sound, aDistance);
end;

function TAudio.GetChannelMinDistance(aChannel: Integer): Single;
begin
  Result := 0;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := sfSound_getMinDistance(FChannel[aChannel].Sound);
end;

procedure TAudio.SetChannelRelativeToListener(aChannel: Integer; aRelative: Boolean);
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_setRelativeToListener(FChannel[aChannel].Sound, Ord(aRelative));
end;

function TAudio.GetChannelRelativeToListener(aChannel: Integer): Boolean;
begin
  Result := False;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := Boolean(sfSound_isRelativeToListener(FChannel[aChannel].Sound));
end;

procedure TAudio.SetChannelAttenuation(aChannel: Integer; aAttenuation: Single);
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then  Exit;
  sfSound_setAttenuation(FChannel[aChannel].Sound, aAttenuation);
end;

function TAudio.GetChannelAttenuation(aChannel: Integer): Single;
begin
  Result := 0;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := sfSound_getAttenuation(FChannel[aChannel].Sound);
end;

procedure TAudio.StopChannel(aChannel: Integer);
begin
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_stop(FChannel[aChannel].Sound);
end;

procedure TAudio.StopAllChannels;
var
  LI: Integer;
begin
  for LI := 0 to AUDIO_CHANNEL_COUNT-1 do
  begin
    sfSound_stop(FChannel[LI].Sound);
  end;
end;

procedure TAudio.SetListenerGlobalVolume(aVolume: Single);
var
  LV: Single;
begin
  LV := aVolume;
  if (LV < 0) then
    LV := 0
  else if (LV > 1) then
    LV := 1;

  LV := LV * 100;
  sfListener_setGlobalVolume(LV);
end;

function TAudio.GetListenerGlobalVolume: Single;
begin
  Result := sfListener_getGlobalVolume;
  Result := Result / 100;
end;

procedure TAudio.SetListenerPosition(aX: Single; aY: Single);
var
  LV: TsfVector3f;
begin
  LV.X := aX;
  LV.Y := 0;
  LV.Z := aY;
  sfListener_setPosition(LV);
end;

procedure TAudio.GetListenerPosition(var aX: Single; var aY: Single);
var
  LV: TsfVector3f;
begin
  LV := sfListener_getPosition;
  aX := LV.X;
  aY := LV.Z;
end;

end.
