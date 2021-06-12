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

unit uTestbed;

interface

procedure RunTests;

implementation

uses
  System.SysUtils,
  Vivace.Allegro,
  Vivace.Nuklear,
  Vivace.CSFMLAudio,
  Vivace.Buffer,
  Vivace.Audio,
  Vivace.SMTP;

procedure WaitForEnter;
begin
  writeln;
  write('Press ENTER to continue...');
  readln;
end;

procedure Test_Allegro;
begin
  if al_install_system(ALLEGRO_VERSION_INT, nil) then
  begin
    WriteLn('init Allegro');
    writeln('elapsed time: ', al_get_time);
    al_uninstall_system;
    WriteLn('shutdown Allegro');
  end;

  WaitForEnter;
end;

procedure Test_Nuklear;
var
  ctx: nk_context;
begin
  if nk_init_default(@ctx, nil) = 1 then
  begin
    writeln('init nuklear');

    nk_free(@ctx);
    writeln('free nuklear');
  end;

  WaitForEnter;

end;

procedure Test_CSFMLAudio;
var
  mus: PsfMusic;
begin
  mus := sfMusic_createFromFile('arc/audio/music/song08.ogg');
  if mus <> nil then
  begin
    writeln('playing music...');
    sfMusic_play(mus);

    WaitForEnter;

    if mus <> nil then
    begin
      sfMusic_stop(mus);
      sfMusic_destroy(mus);
      writeln('stop music');
    end;

    WaitForEnter;

  end;

end;

procedure Test_PhysicsFS;
var
  Hnd: Pointer;
  Siz: Int64;
  Buf: TBuffer;
  mus: PsfMusic;
begin
  if PHYSFS_init('') then
  begin
    writeln('open PhysicsFS');

    if PHYSFS_mount('Data.arc', '', True) then
    begin
      writeln('Mounted Data.arc');

      Hnd := PHYSFS_openRead('arc/audio/music/song08.ogg');
      if Hnd <> nil then
      begin
        writeln('Open song8.ogg for reading');
        Siz := PHYSFS_fileLength(Hnd);
        writeln('song8.ogg size: ', Siz);

        Buf := TBuffer.Create(Siz);
        PHYSFS_readBytes(Hnd, Buf.Memory, Siz);

        mus := sfMusic_createFromMemory(Buf.Memory, Siz);
        sfMusic_play(mus);

        WaitForEnter;

        sfMusic_stop(mus);
        sfMusic_destroy(mus);

        FreeAndNil(Buf);


        PHYSFS_close(Hnd);
        writeln('closed song8.ogg');
      end;


      if PHYSFS_unmount('Data.arc') then
        writeln('Unmounted Data.arc');
    end;


    if PHYSFS_deinit then
      writeln('close PhysicsFS');
  end;

  WaitForEnter;
end;

procedure Test_Audio_Music;
var
  Audio: TAudio;
  Mus: array[0..1] of Integer;
  Snd: array[0..1] of Integer;
begin
  PHYSFS_init('');
  try
    PHYSFS_mount('Data.arc', '', True);
    Audio := TAudio.Create;
    try
      Snd[0] := Audio.LoadSound('arc/audio/sfx/digthis.ogg');
      Snd[1] := Audio.LoadSound('arc/audio/sfx/thunder.ogg');


      Mus[0] := Audio.LoadMusic('arc/audio/music/song08.ogg');
      Mus[1] := Audio.LoadMusic('arc/audio/music/song04.ogg');

      Audio.UnloadMusic(Mus[0]);
      Mus[0] := Audio.LoadMusic('arc/audio/music/song08.ogg');

      Audio.PlayMusic(Mus[0], 0.5, True);
      Audio.PlayMusic(Mus[1], 0.5, True);

      Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, Snd[0], 0.3, True);
      Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, Snd[1]);

      WaitForEnter;
      Audio.UnloadMusic(Mus[1]);
      Audio.UnloadMusic(Mus[0]);
      Audio.UnloadSound(Snd[1]);
      Audio.UnloadSound(Snd[0]);
    finally
      FreeAndNil(Audio);
    end;
  finally
    PHYSFS_deinit;
  end;
end;

procedure RunTests;
begin
  //Test_Allegro;
  //Test_Nuklear;
  //Test_CSFMLAudio;
  //Test_PhysicsFS;
  Test_Audio_Music;
end;

end.
