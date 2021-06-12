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

unit Vivace.CSFMLAudio;

{$I Vivace.Defines.inc }

interface

const
  sfFalse = 0;
  sfTrue = 1;

type
  TsfBool = type Integer;

  TsfTime = record
    MicroSeconds: Int64;
  end;

  TsfVector3f = record
    X, Y, Z: Single;
  end;

  TsfInputStreamReadFunc = function(Data: Pointer; Size: Int64; UserData: Pointer): Int64; cdecl;
  TsfInputStreamSeekFunc = function(Position: Int64; UserData: Pointer): Int64; cdecl;
  TsfInputStreamTellFunc = function(UserData: Pointer): Int64; cdecl;
  TsfInputStreamGetSizeFunc = function(UserData: Pointer): Int64; cdecl;

  PsfInputStream = ^TsfInputStream;
  TsfInputStream = record
    Read: TsfInputStreamReadFunc;
    Seek: TsfInputStreamSeekFunc;
    Tell: TsfInputStreamTellFunc;
    GetSize: TsfInputStreamGetSizeFunc;
    UserData: Pointer;
  end;

  PsfMusic = ^TsfMusic;
  TsfMusic = record end;

  PsfSound = ^TsfSound;
  TsfSound = record end;

  PsfSoundBuffer = ^TsfSoundBuffer;
  TsfSoundBuffer = record end;

  PsfSoundBufferRecorder = ^TsfSoundBufferRecorder;
  TsfSoundBufferRecorder = record end;

  PsfSoundRecorder = ^TsfSoundRecorder;
  TsfSoundRecorder = record end;

  PsfSoundStream = ^TsfSoundStream;
  TsfSoundStream = record end;

  TsfSoundStatus = (sfStopped, sfPaused, sfPlaying);

  PsfSoundStreamChunk = ^TsfSoundStreamChunk;
  TsfSoundStreamChunk = record
    Samples: PSmallInt;
    SampleCount: Cardinal;
  end;

  TsfSoundStreamGetDataCallback = function(Chunk: PsfSoundStreamChunk; UserData: Pointer): Boolean; cdecl;
  TsfSoundStreamSeekCallback = procedure(Time: TsfTime; UserData: Pointer); cdecl;
  TsfSoundRecorderStartCallback = function(UserData: Pointer): Boolean; cdecl;
  TsfSoundRecorderProcessCallback = function(Data: PSmallInt; SampleFrames: NativeUInt; UserData: Pointer): Boolean; cdecl;
  TsfSoundRecorderStopCallback = procedure(UserData: Pointer); cdecl;

  TsfTimeSpan = record
    offset: TsfTime;
    length: TsfTime;
  end;

var
  // Listener
  sfListener_setGlobalVolume: procedure(Volume: Single); cdecl;
  sfListener_getGlobalVolume: function: Single; cdecl;
  sfListener_setPosition: procedure(Position: TsfVector3f); cdecl;
  sfListener_getPosition: function: TsfVector3f; cdecl;
  sfListener_setDirection: procedure(Direction: TsfVector3f); cdecl;
  sfListener_getDirection: function: TsfVector3f; cdecl;
  sfListener_setUpVector: procedure(UpVector: TsfVector3f); cdecl;
  sfListener_getUpVector: function: TsfVector3f; cdecl;

  // Music
  sfMusic_createFromFile: function(const FileName: PAnsiChar): PsfMusic; cdecl;
  sfMusic_createFromMemory: function(const Data: Pointer; SizeInBytes: NativeUInt): PsfMusic; cdecl;
  sfMusic_createFromStream: function(Stream: PsfInputStream): PsfMusic; cdecl;
  sfMusic_destroy: procedure(Music: PsfMusic); cdecl;
  sfMusic_setLoop: procedure(Music: PsfMusic; Loop: TsfBool); cdecl;
  sfMusic_getLoop: function(const Music: PsfMusic): Integer; cdecl;
  sfMusic_play: procedure(Music: PsfMusic); cdecl;
  sfMusic_pause: procedure(Music: PsfMusic); cdecl;
  sfMusic_stop: procedure(Music: PsfMusic); cdecl;
  sfMusic_getChannelCount: function(const Music: PsfMusic): Cardinal; cdecl;
  sfMusic_getSampleRate: function(const Music: PsfMusic): Cardinal; cdecl;
  sfMusic_getStatus: function(const Music: PsfMusic): TsfSoundStatus; cdecl;
  sfMusic_setPitch: procedure(Music: PsfMusic; Pitch: Single); cdecl;
  sfMusic_setVolume: procedure(Music: PsfMusic; Volume: Single); cdecl;
  sfMusic_setPosition: procedure(Music: PsfMusic; Position: TsfVector3f); cdecl;
  sfMusic_setRelativeToListener: procedure(Music: PsfMusic; Relative: Integer); cdecl;
  sfMusic_setMinDistance: procedure(Music: PsfMusic; Distance: Single); cdecl;
  sfMusic_setAttenuation: procedure(Music: PsfMusic; Attenuation: Single); cdecl;
  sfMusic_setPlayingOffset: procedure(Music: PsfMusic; TimeOffset: TsfTime); cdecl;
  sfMusic_getPitch: function(const Music: PsfMusic): Single; cdecl;
  sfMusic_getVolume: function(const Music: PsfMusic): Single; cdecl;
  sfMusic_getPosition: function(const Music: PsfMusic): TsfVector3f; cdecl;
  sfMusic_isRelativeToListener: function(const Music: PsfMusic): Integer; cdecl;
  sfMusic_getMinDistance: function(const Music: PsfMusic): Single; cdecl;
  sfMusic_getAttenuation: function(const Music: PsfMusic): Single; cdecl;
  sfMusic_setLoopPoints: procedure(Music: PsfMusic; timePoints: TsfTimeSpan); cdecl;
  sfMusic_getLoopPoints: function(const Music: PsfMusic): TsfTimeSpan; cdecl;

  // SoundStream
  sfSoundStream_create: function(OnGetData: TsfSoundStreamGetDataCallback; OnSeek: TsfSoundStreamSeekCallback; ChannelCount, SampleRate: Cardinal; UserData: Pointer): PsfSoundStream; cdecl;
  sfSoundStream_destroy: procedure(SoundStream: PsfSoundStream); cdecl;
  sfSoundStream_play: procedure(SoundStream: PsfSoundStream); cdecl;
  sfSoundStream_pause: procedure(SoundStream: PsfSoundStream); cdecl;
  sfSoundStream_stop: procedure(SoundStream: PsfSoundStream); cdecl;
  sfSoundStream_getStatus: function(const SoundStream: PsfSoundStream): TsfSoundStatus; cdecl;
  sfSoundStream_getChannelCount: function(const SoundStream: PsfSoundStream): Cardinal; cdecl;
  sfSoundStream_getSampleRate: function(const SoundStream: PsfSoundStream): Cardinal; cdecl;
  sfSoundStream_setPitch: procedure(SoundStream: PsfSoundStream; Pitch: Single); cdecl;
  sfSoundStream_setVolume: procedure(SoundStream: PsfSoundStream; Volume: Single); cdecl;
  sfSoundStream_setPosition: procedure(SoundStream: PsfSoundStream; Position: TsfVector3f); cdecl;
  sfSoundStream_setRelativeToListener: procedure(SoundStream: PsfSoundStream; Relative: Integer); cdecl;
  sfSoundStream_setMinDistance: procedure(SoundStream: PsfSoundStream; Distance: Single); cdecl;
  sfSoundStream_setAttenuation: procedure(SoundStream: PsfSoundStream; Attenuation: Single); cdecl;
  sfSoundStream_setPlayingOffset: procedure(SoundStream: PsfSoundStream; TimeOffset: TsfTime); cdecl;
  sfSoundStream_setLoop: procedure(SoundStream: PsfSoundStream; Loop: Integer); cdecl;
  sfSoundStream_getPitch: function(const SoundStream: PsfSoundStream): Single; cdecl;
  sfSoundStream_getVolume: function(const SoundStream: PsfSoundStream): Single; cdecl;
  sfSoundStream_getPosition: function(const SoundStream: PsfSoundStream): TsfVector3f; cdecl;
  sfSoundStream_isRelativeToListener: function(const SoundStream: PsfSoundStream): Integer; cdecl;
  sfSoundStream_getMinDistance: function(const SoundStream: PsfSoundStream): Single; cdecl;
  sfSoundStream_getAttenuation: function(const SoundStream: PsfSoundStream): Single; cdecl;
  sfSoundStream_getLoop: function(const SoundStream: PsfSoundStream): Integer; cdecl;

  // Sound
  sfSound_create: function: PsfSound; cdecl;
  sfSound_copy: function(const Sound: PsfSound): PsfSound; cdecl;
  sfSound_destroy: procedure(Sound: PsfSound); cdecl;
  sfSound_play: procedure(Sound: PsfSound); cdecl;
  sfSound_pause: procedure(Sound: PsfSound); cdecl;
  sfSound_stop: procedure(Sound: PsfSound); cdecl;
  sfSound_setBuffer: procedure(Sound: PsfSound; const Buffer: PsfSoundBuffer); cdecl;
  sfSound_getBuffer: function(const Sound: PsfSound): PsfSoundBuffer; cdecl;
  sfSound_setLoop: procedure(Sound: PsfSound; Loop: TsfBool); cdecl;
  sfSound_getLoop: function(const Sound: PsfSound): Integer; cdecl;
  sfSound_getStatus: function(const Sound: PsfSound): TsfSoundStatus; cdecl;
  sfSound_setPitch: procedure(Sound: PsfSound; Pitch: Single); cdecl;
  sfSound_setVolume: procedure(Sound: PsfSound; Volume: Single); cdecl;
  sfSound_setPosition: procedure(Sound: PsfSound; Position: TsfVector3f); cdecl;
  sfSound_setRelativeToListener: procedure(Sound: PsfSound; Relative: Integer); cdecl;
  sfSound_setMinDistance: procedure(Sound: PsfSound; Distance: Single); cdecl;
  sfSound_setAttenuation: procedure(Sound: PsfSound; Attenuation: Single); cdecl;
  sfSound_setPlayingOffset: procedure(Sound: PsfSound; TimeOffset: TsfTime); cdecl;
  sfSound_getPitch: function(const Sound: PsfSound): Single; cdecl;
  sfSound_getVolume: function(const Sound: PsfSound): Single; cdecl;
  sfSound_getPosition: function(const Sound: PsfSound): TsfVector3f; cdecl;
  sfSound_isRelativeToListener: function(const Sound: PsfSound): Integer; cdecl;
  sfSound_getMinDistance: function(const Sound: PsfSound): Single; cdecl;
  sfSound_getAttenuation: function(const Sound: PsfSound): Single; cdecl;

  // SoundBuffer
  sfSoundBuffer_createFromFile: function(const FileName: PAnsiChar): PsfSoundBuffer; cdecl;
  sfSoundBuffer_createFromMemory: function(const Data: Pointer; SizeInBytes: NativeUInt): PsfSoundBuffer; cdecl;
  sfSoundBuffer_createFromStream: function(Stream: PsfInputStream): PsfSoundBuffer; cdecl;
  sfSoundBuffer_createFromSamples: function(const Samples: PSmallInt; SampleCount: UInt64; ChannelCount, SampleRate: Cardinal): PsfSoundBuffer; cdecl;
  sfSoundBuffer_copy: function(const SoundBuffer: PsfSoundBuffer): PsfSoundBuffer; cdecl;
  sfSoundBuffer_destroy: procedure(SoundBuffer: PsfSoundBuffer); cdecl;
  sfSoundBuffer_saveToFile: function(const SoundBuffer: PsfSoundBuffer; const FileName: PAnsiChar): Integer; cdecl;
  sfSoundBuffer_getSamples: function(const SoundBuffer: PsfSoundBuffer): PSmallInt; cdecl;
  sfSoundBuffer_getSampleCount: function(const SoundBuffer: PsfSoundBuffer): NativeUInt; cdecl;
  sfSoundBuffer_getSampleRate: function(const SoundBuffer: PsfSoundBuffer): Cardinal; cdecl;
  sfSoundBuffer_getChannelCount: function(const SoundBuffer: PsfSoundBuffer): Cardinal; cdecl;

  // SoundBufferRecorder
  sfSoundBufferRecorder_create: function: PsfSoundBufferRecorder; cdecl;
  sfSoundBufferRecorder_destroy: procedure(soundBufferRecorder: PsfSoundBufferRecorder); cdecl;
  sfSoundBufferRecorder_start: function(soundBufferRecorder: PsfSoundBufferRecorder; SampleRate: Cardinal): Integer; cdecl;
  sfSoundBufferRecorder_stop: procedure(soundBufferRecorder: PsfSoundBufferRecorder); cdecl;
  sfSoundBufferRecorder_getSampleRate: function(const soundBufferRecorder: PsfSoundBufferRecorder): Cardinal; cdecl;
  sfSoundBufferRecorder_getBuffer: function(const soundBufferRecorder: PsfSoundBufferRecorder): PsfSoundBuffer; cdecl;
  sfSoundBufferRecorder_setDevice: function(SoundRecorder: PsfSoundBufferRecorder; const Name: PAnsiChar): Integer; cdecl;
  sfSoundBufferRecorder_getDevice: function(SoundRecorder: PsfSoundBufferRecorder): PAnsiChar; cdecl;

  // SoundRecorder
  sfSoundRecorder_create: function(OnStart: TsfSoundRecorderStartCallback; OnProcess: TsfSoundRecorderProcessCallback; OnStop: TsfSoundRecorderStopCallback; UserData: Pointer): PsfSoundRecorder; cdecl;
  sfSoundRecorder_destroy: procedure(SoundRecorder: PsfSoundRecorder); cdecl;
  sfSoundRecorder_start: function(SoundRecorder: PsfSoundRecorder; SampleRate: Cardinal): Integer; cdecl;
  sfSoundRecorder_stop: procedure(SoundRecorder: PsfSoundRecorder); cdecl;
  sfSoundRecorder_getSampleRate: function(const SoundRecorder: PsfSoundRecorder): Cardinal; cdecl;
  sfSoundRecorder_isAvailable: function: Integer; cdecl;
  sfSoundRecorder_setProcessingInterval: procedure(SoundRecorder: PsfSoundRecorder; Interval: TsfTime); cdecl;
  sfSoundRecorder_getAvailableDevices: function(count: PNativeUInt): PPAnsiChar; cdecl;
  sfSoundRecorder_getDefaultDevice: function: PAnsiChar; cdecl;
  sfSoundRecorder_setDevice: function(SoundRecorder: PsfSoundRecorder; const Name: PAnsiChar): Integer; cdecl;
  sfSoundRecorder_getDevice: function(SoundRecorder: PsfSoundRecorder): PAnsiChar; cdecl;
  sfSoundRecorder_setChannelCount: function(SoundRecorder: PsfSoundRecorder; const ChannelCount: Cardinal): Integer; cdecl;
  sfSoundRecorder_getChannelCount: function(const SoundRecorder: PsfSoundRecorder): Cardinal; cdecl;

// Workarounds for the Delphi compiler
function sfMusic_getDuration(const Music: PsfMusic): TsfTime; cdecl;
function sfMusic_getPlayingOffset(const Music: PsfMusic): TsfTime; cdecl;
function sfSoundStream_getPlayingOffset(const SoundStream: PsfSoundStream): TsfTime; cdecl;
function sfSound_getPlayingOffset(const Sound: PsfSound): TsfTime; cdecl;
function sfSoundBuffer_getDuration(const SoundBuffer: PsfSoundBuffer): TsfTime; cdecl;

implementation

{$R Vivace.CSFMLAudio.res}

uses
  System.SysUtils,
  System.Classes,
  WinAPI.Windows,
  Vivace.MemoryModule,
  Vivace.OpenAL;

var
  DLL: Pointer;

var
  // Workarounds for the Delphi compiler
  sfMusic_getDuration_: function(const Music: PsfMusic): Int64; cdecl;
  sfMusic_getPlayingOffset_: function(const Music: PsfMusic): Int64; cdecl;
  sfSoundStream_getPlayingOffset_: function(const SoundStream: PsfSoundStream): Int64; cdecl;
  sfSound_getPlayingOffset_: function(const Sound: PsfSound): Int64; cdecl;
  sfSoundBuffer_getDuration_: function(const SoundBuffer: PsfSoundBuffer): Int64; cdecl;

// Workarounds for the Delphi compiler
function sfMusic_getDuration(const Music: PsfMusic): TsfTime; cdecl;
begin
  Result.MicroSeconds := sfMusic_getDuration_(Music);
end;

function sfMusic_getPlayingOffset(const Music: PsfMusic): TsfTime; cdecl;
begin
  Result.MicroSeconds := sfMusic_getPlayingOffset_(Music);
end;

function sfSoundStream_getPlayingOffset(const SoundStream: PsfSoundStream)
  : TsfTime; cdecl;
begin
  Result.MicroSeconds := sfSoundStream_getPlayingOffset_(SoundStream);
end;

function sfSound_getPlayingOffset(const Sound: PsfSound): TsfTime; cdecl;
begin
  Result.MicroSeconds := sfSound_getPlayingOffset_(Sound);
end;

function sfSoundBuffer_getDuration(const SoundBuffer: PsfSoundBuffer): TsfTime; cdecl;
begin
  Result.MicroSeconds := sfSoundBuffer_getDuration_(SoundBuffer);
end;

procedure LoadDLL;
var
  LBuff: TResourceStream;
begin
  LBuff := TResourceStream.Create(HInstance, 'CSFMLAUDIO', RT_RCDATA);
  try
    DLL := TMemoryModule.LoadLibrary(LBuff.Memory);
    if DLL <> nil then
    begin
      // Listener
      @sfListener_setGlobalVolume := TMemoryModule.GetProcAddress(DLL, 'sfListener_setGlobalVolume');
      @sfListener_getGlobalVolume := TMemoryModule.GetProcAddress(DLL, 'sfListener_getGlobalVolume');
      @sfListener_setPosition := TMemoryModule.GetProcAddress(DLL, 'sfListener_setPosition');
      @sfListener_getPosition := TMemoryModule.GetProcAddress(DLL, 'sfListener_getPosition');
      @sfListener_setDirection := TMemoryModule.GetProcAddress(DLL, 'sfListener_setDirection');
      @sfListener_getDirection := TMemoryModule.GetProcAddress(DLL, 'sfListener_getDirection');
      @sfListener_setUpVector := TMemoryModule.GetProcAddress(DLL, 'sfListener_setUpVector');
      @sfListener_getUpVector := TMemoryModule.GetProcAddress(DLL, 'sfListener_getUpVector');

      // Music
      @sfMusic_createFromFile := TMemoryModule.GetProcAddress(DLL, 'sfMusic_createFromFile');
      @sfMusic_createFromMemory := TMemoryModule.GetProcAddress(DLL, 'sfMusic_createFromMemory');
      @sfMusic_createFromStream := TMemoryModule.GetProcAddress(DLL, 'sfMusic_createFromStream');
      @sfMusic_destroy := TMemoryModule.GetProcAddress(DLL, 'sfMusic_destroy');
      @sfMusic_setLoop := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setLoop');
      @sfMusic_getLoop := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getLoop');
      @sfMusic_play := TMemoryModule.GetProcAddress(DLL, 'sfMusic_play');
      @sfMusic_pause := TMemoryModule.GetProcAddress(DLL, 'sfMusic_pause');
      @sfMusic_stop := TMemoryModule.GetProcAddress(DLL, 'sfMusic_stop');
      @sfMusic_getChannelCount := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getChannelCount');
      @sfMusic_getSampleRate := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getSampleRate');
      @sfMusic_getStatus := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getStatus');
      @sfMusic_setPitch := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setPitch');
      @sfMusic_setVolume := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setVolume');
      @sfMusic_setPosition := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setPosition');
      @sfMusic_setRelativeToListener := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setRelativeToListener');
      @sfMusic_setMinDistance := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setMinDistance');
      @sfMusic_setAttenuation := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setAttenuation');
      @sfMusic_setPlayingOffset := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setPlayingOffset');
      @sfMusic_getPitch := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getPitch');
      @sfMusic_getVolume := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getVolume');
      @sfMusic_getPosition := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getPosition');
      @sfMusic_isRelativeToListener := TMemoryModule.GetProcAddress(DLL, 'sfMusic_isRelativeToListener');
      @sfMusic_getMinDistance := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getMinDistance');
      @sfMusic_getAttenuation := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getAttenuation');
      @sfMusic_setLoopPoints := TMemoryModule.GetProcAddress(DLL, 'sfMusic_setLoopPoints');
      @sfMusic_getLoopPoints := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getLoopPoints');

      // SoundStream
      @sfSoundStream_create := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_create');
      @sfSoundStream_destroy := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_destroy');
      @sfSoundStream_play := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_play');
      @sfSoundStream_pause := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_pause');
      @sfSoundStream_stop := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_stop');
      @sfSoundStream_getStatus := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getStatus');
      @sfSoundStream_getChannelCount := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getChannelCount');
      @sfSoundStream_getSampleRate := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getSampleRate');
      @sfSoundStream_setPitch := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setPitch');
      @sfSoundStream_setVolume := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setVolume');
      @sfSoundStream_setPosition := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setPosition');
      @sfSoundStream_setRelativeToListener := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setRelativeToListener');
      @sfSoundStream_setMinDistance := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setMinDistance');
      @sfSoundStream_setAttenuation := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setAttenuation');
      @sfSoundStream_setPlayingOffset := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setPlayingOffset');
      @sfSoundStream_setLoop := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_setLoop');
      @sfSoundStream_getPitch := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getPitch');
      @sfSoundStream_getVolume := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getVolume');
      @sfSoundStream_getPosition := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getPosition');
      @sfSoundStream_isRelativeToListener := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_isRelativeToListener');
      @sfSoundStream_getMinDistance := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getMinDistance');
      @sfSoundStream_getAttenuation := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getAttenuation');
      @sfSoundStream_getLoop := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getLoop');

      // Sound
      @sfSound_create := TMemoryModule.GetProcAddress(DLL, 'sfSound_create');
      @sfSound_copy := TMemoryModule.GetProcAddress(DLL, 'sfSound_copy');
      @sfSound_destroy := TMemoryModule.GetProcAddress(DLL, 'sfSound_destroy');
      @sfSound_play := TMemoryModule.GetProcAddress(DLL, 'sfSound_play');
      @sfSound_pause := TMemoryModule.GetProcAddress(DLL, 'sfSound_pause');
      @sfSound_stop := TMemoryModule.GetProcAddress(DLL, 'sfSound_stop');
      @sfSound_setBuffer := TMemoryModule.GetProcAddress(DLL, 'sfSound_setBuffer');
      @sfSound_getBuffer := TMemoryModule.GetProcAddress(DLL, 'sfSound_getBuffer');
      @sfSound_setLoop := TMemoryModule.GetProcAddress(DLL, 'sfSound_setLoop');
      @sfSound_getLoop := TMemoryModule.GetProcAddress(DLL, 'sfSound_getLoop');
      @sfSound_getStatus := TMemoryModule.GetProcAddress(DLL, 'sfSound_getStatus');
      @sfSound_setPitch := TMemoryModule.GetProcAddress(DLL, 'sfSound_setPitch');
      @sfSound_setVolume := TMemoryModule.GetProcAddress(DLL, 'sfSound_setVolume');
      @sfSound_setPosition := TMemoryModule.GetProcAddress(DLL, 'sfSound_setPosition');
      @sfSound_setRelativeToListener := TMemoryModule.GetProcAddress(DLL, 'sfSound_setRelativeToListener');
      @sfSound_setMinDistance := TMemoryModule.GetProcAddress(DLL, 'sfSound_setMinDistance');
      @sfSound_setAttenuation := TMemoryModule.GetProcAddress(DLL, 'sfSound_setAttenuation');
      @sfSound_setPlayingOffset := TMemoryModule.GetProcAddress(DLL, 'sfSound_setPlayingOffset');
      @sfSound_getPitch := TMemoryModule.GetProcAddress(DLL, 'sfSound_getPitch');
      @sfSound_getVolume := TMemoryModule.GetProcAddress(DLL, 'sfSound_getVolume');
      @sfSound_getPosition := TMemoryModule.GetProcAddress(DLL, 'sfSound_getPosition');
      @sfSound_isRelativeToListener := TMemoryModule.GetProcAddress(DLL, 'sfSound_isRelativeToListener');
      @sfSound_getMinDistance := TMemoryModule.GetProcAddress(DLL, 'sfSound_getMinDistance');
      @sfSound_getAttenuation := TMemoryModule.GetProcAddress(DLL, 'sfSound_getAttenuation');

      // SoundBuffer
      @sfSoundBuffer_createFromFile := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_createFromFile');
      @sfSoundBuffer_createFromMemory := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_createFromMemory');
      @sfSoundBuffer_createFromStream := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_createFromStream');
      @sfSoundBuffer_createFromSamples := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_createFromSamples');
      @sfSoundBuffer_copy := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_copy');
      @sfSoundBuffer_destroy := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_destroy');
      @sfSoundBuffer_saveToFile := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_saveToFile');
      @sfSoundBuffer_getSamples := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_getSamples');
      @sfSoundBuffer_getSampleCount := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_getSampleCount');
      @sfSoundBuffer_getSampleRate := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_getSampleRate');
      @sfSoundBuffer_getChannelCount := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_getChannelCount');

      // SoundBufferRecorder
      @sfSoundBufferRecorder_create := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_create');
      @sfSoundBufferRecorder_destroy := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_destroy');
      @sfSoundBufferRecorder_start := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_start');
      @sfSoundBufferRecorder_stop := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_stop');
      @sfSoundBufferRecorder_getSampleRate := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_getSampleRate');
      @sfSoundBufferRecorder_getBuffer := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_getBuffer');
      @sfSoundBufferRecorder_setDevice := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_setDevice');
      @sfSoundBufferRecorder_getDevice := TMemoryModule.GetProcAddress(DLL, 'sfSoundBufferRecorder_getDevice');

      // SoundRecorder
      @sfSoundRecorder_create := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_create');
      @sfSoundRecorder_destroy := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_destroy');
      @sfSoundRecorder_start := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_start');
      @sfSoundRecorder_stop := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_stop');
      @sfSoundRecorder_getSampleRate := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_getSampleRate');
      @sfSoundRecorder_isAvailable := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_isAvailable');
      @sfSoundRecorder_setProcessingInterval := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_setProcessingInterval');
      @sfSoundRecorder_getAvailableDevices := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_getAvailableDevices');
      @sfSoundRecorder_getDefaultDevice := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_getDefaultDevice');
      @sfSoundRecorder_setDevice := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_setDevice');
      @sfSoundRecorder_getDevice := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_getDevice');
      @sfSoundRecorder_setChannelCount := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_setChannelCount');
      @sfSoundRecorder_getChannelCount := TMemoryModule.GetProcAddress(DLL, 'sfSoundRecorder_getChannelCount');

      // Workarounds for the Delphi compiler
      @sfMusic_getDuration_ := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getDuration');
      @sfMusic_getPlayingOffset_ := TMemoryModule.GetProcAddress(DLL, 'sfMusic_getPlayingOffset');
      @sfSoundStream_getPlayingOffset_ := TMemoryModule.GetProcAddress(DLL, 'sfSoundStream_getPlayingOffset');
      @sfSound_getPlayingOffset_ := TMemoryModule.GetProcAddress(DLL, 'sfSound_getPlayingOffset');
      @sfSoundBuffer_getDuration_ := TMemoryModule.GetProcAddress(DLL, 'sfSoundBuffer_getDuration');

    end;
  finally
    FreeAndNil(LBuff);
  end;

end;

procedure UnloadDLL;
begin
  TMemoryModule.FreeLibrary(DLL);
end;

initialization
begin
  LoadDLL;
end;

finalization
begin
  UnloadDLL;
end;

end.
