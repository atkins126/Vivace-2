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

unit Vivace.Video;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.External.Allegro,
  Vivace.Base,
  Vivace.Common;

type
  { TVideo }
  TVideo = class(TBaseObject)
  protected
    FVoice: PALLEGRO_VOICE;
    FMixer: PALLEGRO_MIXER;
    FHandle: PALLEGRO_VIDEO;
    FLoop: Boolean;
    FPlaying: Boolean;
    FPaused: Boolean;
    FFilename: string;
    procedure InitAudio;
    procedure ShutdownAudio;
    function GetPause: Boolean;
    procedure SetPause(aPause: Boolean);
    function GetLooping: Boolean;
    procedure SetLooping(aLoop: Boolean);
    function GetPlaying: Boolean;
    procedure SetPlaying(aPlaying: Boolean);
  public
    property Handle: PALLEGRO_VIDEO read FHandle;
    property Pause: Boolean read GetPause write SetPause;
    property Looping: Boolean read GetLooping write SetLooping;
    property Playing: Boolean read GetPlaying write SetPlaying;

    constructor Create; override;
    destructor Destroy; override;

    procedure Load(aFilename: string);
    procedure Unload;

    procedure Play(aLoop: Boolean; aGain: Single);
    procedure Draw(aX: Single; aY: Single);

    procedure GetSize(aWidth: PSingle; aHeight: PSingle);
    procedure Seek(aPos: Single);
    procedure Rewind;

    class procedure PauseAll(aPause: Boolean);
    class procedure FreeAll;
    class procedure FinishedEvent(aHandle: PALLEGRO_VIDEO);
  end;

implementation

uses
  System.Generics.Collections,
  System.IOUtils,
  Vivace.Utils,
  Vivace.Engine;

var
  VideoList: TList<TVideo> = nil;


{ TGVVideo }
procedure TVideo.Unload;
begin

  if FHandle <> nil then
  begin
    al_set_video_playing(FHandle, False);
    al_unregister_event_source(gEngine.Queue,
      al_get_video_event_source(FHandle));
    al_close_video(FHandle);
    ShutdownAudio;
    FHandle := nil;
    FFilename := '';
    FLoop := False;
    FPlaying := False;
    FPaused := False;
  end;
end;

procedure TVideo.InitAudio;
begin
  if al_is_audio_installed then
  begin
    if FVoice = nil then
    begin
      FVoice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16,
        ALLEGRO_CHANNEL_CONF_2);
      FMixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32,
        ALLEGRO_CHANNEL_CONF_2);
      al_attach_mixer_to_voice(FMixer, FVoice);
    end;
  end;
end;

procedure TVideo.ShutdownAudio;
begin
  if al_is_audio_installed then
  begin
    al_detach_mixer(FMixer);
    al_destroy_mixer(FMixer);
    al_destroy_voice(FVoice);
    FMixer := nil;
    FVoice := nil;
  end;
end;

constructor TVideo.Create;
begin
  inherited;
  FHandle := nil;
  FLoop := False;
  FPlaying := False;
  FPaused := False;
  FVoice := nil;
  FMixer := nil;
  FFilename := '';
  VideoList.Add(Self);
end;

destructor TVideo.Destroy;
begin
  VideoList.Remove(Self);
  Unload;
  inherited;
end;

procedure TVideo.Draw(aX, aY: Single);
var
  frame: PALLEGRO_BITMAP;
begin
  if FHandle = nil then
    Exit;

  if not GetPlaying then
  begin
    Exit;
  end;

  frame := al_get_video_frame(FHandle);
  if frame <> nil then
  begin
    al_draw_scaled_bitmap(frame, 0, 0, al_get_bitmap_width(frame),
      al_get_bitmap_height(frame), aX, aY, al_get_video_scaled_width(FHandle),
      al_get_video_scaled_height(FHandle), 0);
  end;

end;

function TVideo.GetLooping: Boolean;
begin
  Result := FLoop;
end;

function TVideo.GetPlaying: Boolean;
begin
  if FHandle = nil then
    Result := False
  else
    Result := al_is_video_playing(FHandle);
end;

procedure TVideo.Load(aFilename: string);
var
  LMarsheller: TMarshaller;
  LOk: Boolean;

begin
  if aFilename.IsEmpty then  Exit;

  LOk := gEngine.ArchiveFileExist(aFilename);
  if not LOk then
    LOk := TFile.Exists(aFilename);

  if LOk then
  begin
    Unload;
    InitAudio;
    FHandle := al_open_video(LMarsheller.AsAnsi(aFilename).ToPointer);
    if FHandle <> nil then
    begin
      al_register_event_source(gEngine.Queue,
        al_get_video_event_source(FHandle));
      al_set_video_playing(FHandle, False);
      FFilename := aFilename;
    end;
  end;
end;

procedure TVideo.Play(aLoop: Boolean; aGain: Single);
begin
  if FHandle = nil then
    Exit;
  al_start_video(FHandle, FMixer);
  al_set_mixer_gain(FMixer, aGain);
  al_set_video_playing(FHandle, True);
  FLoop := aLoop;
  FPlaying := True;
  FPaused := False;
end;

procedure TVideo.SetLooping(aLoop: Boolean);
begin
  FLoop := aLoop;
end;

procedure TVideo.SetPlaying(aPlaying: Boolean);
begin
  if FHandle = nil then
    Exit;
  if FPaused then
    Exit;
  al_set_video_playing(FHandle, aPlaying);
  FPlaying := aPlaying;
  FPaused := False;
end;

procedure TVideo.GetSize(aWidth: PSingle; aHeight: PSingle);
begin
  if FHandle = nil then
  begin
    if aWidth <> nil then
      aWidth^ := 0;
    if aHeight <> nil then
      aHeight^ := 0;
    Exit;
  end;
  if aWidth <> nil then
    aWidth^ := al_get_video_scaled_width(FHandle);
  if aHeight <> nil then
    aHeight^ := al_get_video_scaled_height(FHandle);
end;

procedure TVideo.Seek(aPos: Single);
begin
  if FHandle = nil then
    Exit;
  al_seek_video(FHandle, aPos);
end;

procedure TVideo.SetPause(aPause: Boolean);
begin
  // if not FPlaying then Exit;
  if FHandle = nil then
    Exit;

  // if trying to pause and video is not playing, just exit
  if (aPause = True) then
  begin
    if not al_is_video_playing(FHandle) then
    Exit;
  end;

  // if trying to unpause without first being paused, just exit
  if (aPause = False) then
  begin
    if FPaused = False then
      Exit;
  end;

  al_set_video_playing(FHandle, not aPause);
  FPaused := aPause;
end;

function TVideo.GetPause: Boolean;
begin
  Result := FPaused;
end;

procedure TVideo.Rewind;
begin
  if FHandle = nil then
    Exit;
  al_seek_video(FHandle, 0);
end;

class procedure TVideo.PauseAll(aPause: Boolean);
var
  V: TVideo;
begin
  for V in VideoList do
  begin
    V.Pause := aPause;
  end;
end;

class procedure TVideo.FreeAll;
var
  V: TVideo;
begin
  for V in VideoList do
  begin
    FreeAndNil(V);
  end;
  VideoList.Clear;
end;

class procedure TVideo.FinishedEvent(aHandle: PALLEGRO_VIDEO);
var
  V: TVideo;
begin
  for V in VideoList do
  begin
    if V.Handle <> aHandle then
      continue;

    if V.Looping then
    begin
      V.Rewind;
      if not V.Pause then
        V.Playing := True;
    end;

  end;
end;

initialization
begin
  // init video list
  VideoList := TList<TVideo>.Create;
end;

finalization
begin
  // free any unfreed videos
  TVideo.FreeAll;

  // free video list
  FreeAndNil(VideoList);
end;

end.
