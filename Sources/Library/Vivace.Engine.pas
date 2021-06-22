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

unit Vivace.Engine;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.External.Allegro,
  Vivace.Base,
  Vivace.Common,
  Vivace.Game,
  Vivace.Display,
  Vivace.Input,
  Vivace.Audio,
  Vivace.Speech,
  Vivace.Async,
  Vivace.Screenshot,
  Vivace.Screenshake,
  Vivace.CmdConsole,
  Vivace.GUI,
  Vivace.StartupDialog,
  Vivace.Lua,
  Vivace.Styles;

const
  EVENT_CMDCON_ACTIVE   = 10000;
  EVENT_CMDCON_INACTIVE = 10001;

type

  { TEngine }
  TEngine = class(TBaseObject)
  protected
    FTerminate: Boolean;
    FUserEventSrc: ALLEGRO_EVENT_SOURCE;
    FCmdConActive: ALLEGRO_EVENT;
    FCmdConInactive: ALLEGRO_EVENT;
    FQueue: PALLEGRO_EVENT_QUEUE;
    FEvent: ALLEGRO_EVENT;
    FVoice: PALLEGRO_VOICE;
    FMixer: PALLEGRO_MIXER;
    FMouseState: ALLEGRO_MOUSE_STATE;
    FKeyboardState: ALLEGRO_KEYBOARD_STATE;
    FKeyCode: Integer;
    FTimer: record
      LNow: Double;
      Passed: Double;
      Last: Double;
      Accumulator: Double;
      FrameAccumulator: Double;
      DeltaTime: Double;
      FrameCount: Cardinal;
      FrameRate: Cardinal;
      UpdateSpeed: Single;
    end;
    FGame: TCustomGame;
    FDisplay: TDisplay;
    FInput: TInput;
    FAudio: TAudio;
    FSpeech: TSpeech;
    FAsync: TAsync;
    FScreenshot: TScreenshot;
    FScreenshake: TScreenshakes;
    FCmdConsole: TCmdConsole;
    FGUI: TGUI;
    FStartupDialog: TStartupDialog;
    FStyles: TStyles;
    FLua: TLua;
    procedure Startup;
    procedure Shutdown;

  public
    Joystick: TJoystick;
    property Queue: PALLEGRO_EVENT_QUEUE read FQueue;
    property Event: ALLEGRO_EVENT read FEvent;
    property Mixer: PALLEGRO_MIXER read FMixer;
    property MouseState: ALLEGRO_MOUSE_STATE read FMouseState;
    property KeyboardState: ALLEGRO_KEYBOARD_STATE read FKeyboardState;
    property KeyCode: Integer read FKeyCode write FKeyCode;
    property Display: TDisplay read FDisplay;
    property Input: TInput read FInput;
    property Audio: TAudio read FAudio;
    property Speech: TSpeech read FSpeech;
    property Screenshot: TScreenshot read FScreenshot;
    property Screenshake: TScreenshakes read FScreenshake;
    property CmdConsole: TCmdConsole read FCmdConsole;
    property GUI: TGUI read FGUI;
    property StartupDialog: TStartupDialog read FStartupDialog;
    property Styles: TStyles read FStyles;
    property Lua: TLua read FLua;

    constructor Create; override;
    destructor Destroy; override;

    procedure EmitCmdConInactiveEvent;
    procedure EmitCmdConActiveEvent;

    procedure OnLoad;
    procedure OnExit;
    procedure OnStartup;
    procedure OnShutdown;
    function  OnStartupDialogShow: Boolean;
    procedure OnStartupDialogMore;
    function  OnStartupDialogRun: Boolean;
    procedure OnProcessIMGUI;
    procedure OnDisplayOpenBefore;
    procedure OnDisplayOpenAfter;
    procedure OnDisplayCloseBefore;
    procedure OnDisplayCloseAfter;
    procedure OnDisplayReady(aReady: Boolean);
    procedure OnDisplayClear;
    procedure OnDisplayToggleFullscreen(aFullscreen: Boolean);
    procedure OnRender;
    procedure OnRenderHUD;
    procedure OnDisplayShow;
    procedure OnSpeechWord(const aWord: string; const aText: string);
    procedure OnUpdate(aDeltaTime: Double);
    procedure OnLuaReset;

    procedure SetTerminate(aTerminate: Boolean);
    function  GetTerminate: Boolean;

    function  GetVersion: string;

    function  GetTime: Double;
    procedure ResetTiming;
    procedure UpdateTiming;

    procedure SetUpdateSpeed(aSpeed: Single);
    function  GetUpdateSpeed: Single;

    function  GetDeltaTime: Double;
    function  GetFrameRate: Cardinal;

    function  FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
    function  FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;

    function  MountArchive(aFilename: string): Boolean;
    function  UnmountArchive(aFilename: string): Boolean;
    function  ArchiveFileExist(aFilename: string): Boolean;

    procedure GameLoop;
    procedure Run(aGame: TCustomGameClass);

  end;

var
  gEngine: TEngine = nil;

implementation

uses
  System.IOUtils,
  WinAPI.MMSystem,
  Vivace.External.CSFMLAudio,
  Vivace.Utils,
  Vivace.Console,
  Vivace.OS,
  Vivace.Logger,
  Vivace.Video;

{ TEngine }
procedure TEngine.Startup;
begin

  if al_is_system_installed then Exit;

  // init allegro
  if al_install_system(ALLEGRO_VERSION_INT, nil) then
    TLogger.Log(etSuccess, 'Sucessfully initialized Allegro', [])
  else
    TLogger.Log(etSuccess, 'Was not able initialized Allegro', []);

  // init addons
  if al_init_video_addon then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro Video addon', []) else TLogger.Log(etError, 'Failed to initialize Allegro Video addon', []);
  if al_init_font_addon then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro Font addon', []) else TLogger.Log(etError, 'Failed to initialize Allegro Font addon', []);
  if al_init_ttf_addon then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro TTF addon', []) else TLogger.Log(etError, 'Failed to initialize Allegro TTF addon', []);
  if al_init_primitives_addon then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro Primitives addon', []) else TLogger.Log(etError, 'Failed to initialize Allegro Primitives addon', []);
  if al_init_native_dialog_addon then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro Native Dialog addon', []) else TLogger.Log(etError, 'Failed to initialize Allegro Native Dialog addon', []);
  if al_init_image_addon then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro Image addon', []) else TLogger.Log(etError, 'Failed to initialize Allegro Image addon', []);

  // install devices
  if al_install_keyboard then TLogger.Log(etSuccess, 'Sucessfully installed Allegro keyboard support', []) else TLogger.Log(etError, 'Failed to install Allegro keyboard support', []);
  if al_install_mouse then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro mouse support', []) else TLogger.Log(etError, 'Failed to install Allegro mouse support', []);
  if al_install_joystick then
  begin
    TLogger.Log(etSuccess, 'Sucessfully initialized Allegro joystick support', []);
    Joystick.Setup(0);
    TLogger.Log(etSuccess, 'Setup default joystick', []);
  end
  else
    TLogger.Log(etError, 'Failed to install Allegro joystick support', []);

  // int user event source
  al_init_user_event_source(@FUserEventSrc);

  // init event queues
  FQueue := al_create_event_queue;
  al_register_event_source(FQueue, al_get_keyboard_event_source);
  al_register_event_source(FQueue, al_get_mouse_event_source);
  al_register_event_source(FQueue, al_get_joystick_event_source);
  al_register_event_source(FQueue , @FUserEventSrc);
  TLogger.Log(etInfo, 'Registered Allegro event queues', []);

  FCmdConActive.&type := EVENT_CMDCON_ACTIVE;
  FCmdConInactive.&type := EVENT_CMDCON_INACTIVE;

//  al_emit_user_event(@FUserEventSrc , @FCmdConActive , nil);
//  al_emit_user_event(@FUserEventSrc , @FCmdConInactive , nil);

  // init audio
  if not al_is_audio_installed then
  begin
    // init audio
    if al_install_audio then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro audio', []);
    if al_init_acodec_addon then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro audio codec addon', []);
    FVoice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16,  ALLEGRO_CHANNEL_CONF_2);
    if FVoice <> nil then TLogger.Log(etSuccess, 'Sucessfully created Allegro default voice', []) else TLogger.Log(etError, 'Failed to create Allegro default voice', []);
    FMixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32,  ALLEGRO_CHANNEL_CONF_2);
    if FMixer <> nil then TLogger.Log(etSuccess, 'Sucessfully created Allegro default mixer', []) else TLogger.Log(etError, 'Failed to createAllegro default mixer', []);
    if al_set_default_mixer(FMixer) then TLogger.Log(etSuccess, 'Sucessfully setup Allegro default audio mixer', []);
    if al_attach_mixer_to_voice(FMixer, FVoice) then TLogger.Log(etSuccess, 'Sucessfully Allegro default audio mixer to default voice', []);
    if al_reserve_samples(ALLEGRO_MAX_CHANNELS) then TLogger.Log(etSuccess, 'Sucessfully initialized Allegro mouse support', []);
  end;

  // inif PhysicalFS
  if PHYSFS_init(nil) then
    begin
      TLogger.Log(etSuccess, 'Sucessfully initialized PhysicalFS', []);
      al_set_physfs_file_interface;
    end
  else
    TLogger.Log(etError, 'Was not able to initialized PhysicalFS', []);


// init timing
  FTimer.LNow := 0;
  FTimer.Passed := 0;
  FTimer.Last := 0;
  FTimer.Accumulator := 0;
  FTimer.FrameAccumulator := 0;
  FTimer.DeltaTime := 0;
  FTimer.FrameCount := 0;
  FTimer.FrameRate := 0;
  SetUpdateSpeed(60);
  FTimer.Last := GetTime;

  // init objects
  FDisplay := TDisplay.Create;
  FInput := TInput.Create;
  FAudio := TAudio.Create;
  FSpeech := TSpeech.Create;
  FAsync := TAsync.Create;
  FScreenshot := TScreenshot.Create;
  FScreenshake := TScreenshakes.Create;
  FCmdConsole := TCmdConsole.Create;
  FGUI := TGUI.Create;
  FStartupDialog := TStartupDialog.Create;
  FStyles := TStyles.Create;
  FLua := TLua.Create;
end;

procedure TEngine.Shutdown;
begin
  if not al_is_system_installed then Exit;

  // free objects
  FreeAndNil(FLua);
  FreeAndNil(FStyles);
  FreeAndNil(FStartupDialog);
  FreeAndNil(FGUI);
  FreeAndNil(FCmdConsole);
  FreeAndNil(FScreenshake);
  FreeAndNil(FScreenshot);
  FreeAndNil(FAsync);
  FreeAndNil(FSpeech);
  FreeAndNil(FAudio);
  FreeAndNil(FInput);
  FreeAndNil(Display);

  // shutdown PhyscalFS
  if PHYSFS_isInit then
  begin
    if PHYSFS_deinit then
    TLogger.Log(etSuccess, 'Sucessfully deinitialized PhysicalFS', [])
  else
    TLogger.Log(etError, 'Was not able to deinitialized PhysicalFS', []);
  end;

  // shutdown audio
  if al_is_audio_installed then
  begin
    al_stop_samples;
    if al_detach_mixer(FMixer) then TLogger.Log(etSuccess, 'Sucessfully detached Allegro default audio mixer', []);
    al_destroy_mixer(FMixer);
    al_destroy_voice(FVoice);
    al_uninstall_audio;
    TLogger.Log(etSuccess, 'Sucessfully shutdown Allegro audio support', []);
  end;

  // shutdown event queues
  if al_is_event_source_registered(FQueue, @FUserEventSrc) then
    al_unregister_event_source(FQueue, @FUserEventSrc);

  if al_is_event_source_registered(FQueue, al_get_keyboard_event_source) then
    al_unregister_event_source(FQueue, al_get_keyboard_event_source);

  if al_is_event_source_registered(FQueue, al_get_mouse_event_source) then
    al_unregister_event_source(FQueue, al_get_mouse_event_source);

  if al_is_event_source_registered(FQueue, al_get_joystick_event_source) then
    al_unregister_event_source(FQueue, al_get_joystick_event_source);

  // destroy user event source
  al_destroy_user_event_source(@FUserEventSrc);

  TLogger.Log(etInfo, 'Unregistered all Allegro events', []);


  // destroy event queue
  if FQueue <> nil then
  begin
    al_destroy_event_queue(FQueue);
    TLogger.Log(etInfo, 'Destroyed Allegro event queue', []);
  end;


  // uninstall allegro
  al_uninstall_system;
  TLogger.Log(etInfo, 'Shutdown Allegro', []);

end;

procedure TEngine.GameLoop;
begin
  TLogger.Log(etInfo, 'Entering GameLoop', []);

  try
    FAudio.Open;

    FSpeech.Clear;

    OnStartup;

    FInput.Clear;

    FGui.Open;

    FCmdConsole.Open;

    FTerminate := False;

    ResetTiming;

    while not FTerminate do
    begin

      // process OS messages
      TOS.ProcessMessages;

      //ProcessAsync;
      FAsync.Process;

      timeBeginPeriod(1);

      if not gEngine.Display.Ready then
      begin
        // allow background tasks to runn
        Sleep(1);
      end;

      timeEndPeriod(1);

      // input
      FKeyCode := 0;
      al_get_keyboard_state(@FKeyboardState);
      al_get_mouse_state(@FMouseState);

      // start imgui input processing
      FGUI.InputBegin;

      repeat
        FLua.CollectGarbage;

        if al_get_next_event(FQueue, @FEvent) then
        begin

          // process imgui events
          FGUI.HandleEvent(FEvent);

          case FEvent.&type of
            EVENT_CMDCON_ACTIVE:
              begin
                FAudio.Pause(True);
                Vivace.Video.TVideo.PauseAll(True);
                if FSpeech.Active then FSpeech.Pause;
                if al_is_audio_installed then al_set_mixer_playing(FMixer, False);
              end;

            EVENT_CMDCON_INACTIVE:
              begin
                FAudio.Pause(False);
                Vivace.Video.TVideo.PauseAll(False);
                if FSpeech.Active then FSpeech.Resume;
                if al_is_audio_installed then al_set_mixer_playing(FMixer, True);
              end;

            ALLEGRO_EVENT_DISPLAY_CLOSE:
              begin
                FTerminate := True;
              end;

            ALLEGRO_EVENT_DISPLAY_RESIZE:
              begin
              end;

            ALLEGRO_EVENT_DISPLAY_DISCONNECTED,
            ALLEGRO_EVENT_DISPLAY_HALT_DRAWING, ALLEGRO_EVENT_DISPLAY_LOST,
            ALLEGRO_EVENT_DISPLAY_SWITCH_OUT:
              begin
                // display switch out
                if FEvent.&type = ALLEGRO_EVENT_DISPLAY_SWITCH_OUT then
                begin
                  FInput.Clear;
                end;

                // pause speech engine
                if FSpeech <> nil then
                begin
                  if FSpeech.Active then
                  begin
                    FSpeech.Pause;
                  end;
                end;

                // pause audio
                if al_is_audio_installed then
                begin
                  al_set_mixer_playing(FMixer, False);
                end;

                FAudio.Pause(True);

                // pause video
                Vivace.Video.TVideo.PauseAll(True);

                // set display not ready
                gEngine.Display.Ready := False;
                OnDisplayReady(gEngine.Display.Ready);
              end;

            ALLEGRO_EVENT_DISPLAY_CONNECTED,
            ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING, ALLEGRO_EVENT_DISPLAY_FOUND,
            ALLEGRO_EVENT_DISPLAY_SWITCH_IN:
              begin
                // resume speech engine
                if FSpeech <> nil then
                begin
                  if FSpeech.Active then
                  begin
                    FSpeech.Resume;
                  end;
                end;

                // resume audio
                if al_is_audio_installed then
                begin
                  al_set_mixer_playing(FMixer, True);
                end;

                FAudio.Pause(False);

                // resume video
                Vivace.Video.TVideo.PauseAll(False);

                // set display ready
                ResetTiming;
                gEngine.Display.Ready := True;
                OnDisplayReady(gEngine.Display.Ready);
              end;

            ALLEGRO_EVENT_KEY_CHAR:
              begin
                FKeyCode := FEvent.keyboard.unichar;
              end;

            ALLEGRO_EVENT_VIDEO_FINISHED:
              begin
                Vivace.Video.TVideo.FinishedEvent(PALLEGRO_VIDEO(FEvent.user.data1));
              end;

            ALLEGRO_EVENT_JOYSTICK_AXIS:
              begin
                if (FEvent.Joystick.stick < MAX_STICKS) and
                  (FEvent.Joystick.axis < MAX_AXES) then
                begin
                  Joystick.Pos[FEvent.Joystick.stick][FEvent.Joystick.axis] :=
                    FEvent.Joystick.Pos;
                end;
              end;

            ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN:
              begin
                Joystick.Button[FEvent.Joystick.Button] := True;
              end;

            ALLEGRO_EVENT_JOYSTICK_BUTTON_UP:
              begin
                Joystick.Button[FEvent.Joystick.Button] := False;
              end;

            ALLEGRO_EVENT_JOYSTICK_CONFIGURATION:
              begin
                al_reconfigure_joysticks;
                Joystick.Setup(0);
              end;

          end;
        end;

      until al_is_event_queue_empty(FQueue);

      // end imgui input processing
      FGUI.InputEnd;

      if gEngine.Display.Ready then
      begin
        // reset transform
        FDisplay.ResetTransform;

        // process IMGUI
        OnProcessIMGUI;

        //FPhysics.Update;

        UpdateTiming;

        // clear frame
        OnDisplayClear;

        // render
        OnRender;

        // save the current transform
        var trans: ALLEGRO_TRANSFORM := al_get_current_transform^;

        // reset transform
        FDisplay.ResetTransform;

        // render imgui
        FGUI.Render;

        // clear imgui resources
        FGUI.Clear;

        // render normal HUD
        OnRenderHUD;

        // got back to current transform
        al_use_transform(@trans);

        // process screen shots
        FScreenshot.Process;

        // show display
        OnDisplayShow;

      end;

    end;


  finally

    FCmdConsole.Close;

    FGui.Close;

    FInput.Clear;

    OnShutdown;

    FSpeech.Clear;

    FAudio.Close;
  end;

  TLogger.Log(etInfo, 'Exiting GameLoop', []);
end;

constructor TEngine.Create;
begin
  inherited;
  gEngine := Self;
  Startup;
end;

destructor TEngine.Destroy;
begin
  Shutdown;
  inherited;
  gEngine := nil;
end;

// Events

procedure TEngine.EmitCmdConInactiveEvent;
begin
 al_emit_user_event(@FUserEventSrc , @FCmdConInactive , nil);
end;

procedure TEngine.EmitCmdConActiveEvent;
begin
  al_emit_user_event(@FUserEventSrc , @FCmdConActive , nil);
end;

procedure TEngine.OnLoad;
begin
  if Assigned(FGame) then
    FGame.OnLoad;
end;

procedure TEngine.OnExit;
begin
  if Assigned(FGame) then
    FGame.OnExit;
end;

procedure TEngine.OnStartup;
begin
  if Assigned(FGame) then
    FGame.OnStartup;
end;

procedure TEngine.OnShutdown;
begin
  if Assigned(FGame) then
    FGame.OnShutdown;
end;

function  TEngine.OnStartupDialogShow: Boolean;
begin
  Result := False;
  if Assigned(FGame) then
    Result := FGame.OnStartupDialogShow;
end;

procedure TEngine.OnStartupDialogMore;
begin
  if Assigned(FGame) then
    FGame.OnStartupDialogMore;
end;

function  TEngine.OnStartupDialogRun: Boolean;
begin
  Result := False;
  if Assigned(FGame) then
    Result := FGame.OnStartupDialogRun;
end;

procedure TEngine.OnProcessIMGUI;
begin
  if Assigned(FGame) then
    FGame.OnProcessIMGUI;
end;

procedure TEngine.OnDisplayOpenBefore;
begin
  if Assigned(FGame) then
    FGame.OnDisplayOpenBefore;
end;

procedure TEngine.OnDisplayOpenAfter;
begin
  if Assigned(FGame) then
    FGame.OnDisplayOpenAfter;
end;

procedure TEngine.OnDisplayCloseBefore;
begin
  if Assigned(FGame) then
    FGame.OnDisplayCloseBefore;
end;

procedure TEngine.OnDisplayCloseAfter;
begin
  if Assigned(FGame) then
    FGame.OnDisplayCloseAfter;
end;

procedure TEngine.OnDisplayReady(aReady: Boolean);
begin
  if Assigned(FGame) then
    FGame.OnDisplayReady(aReady);
end;

procedure TEngine.OnDisplayClear;
begin
  if Assigned(FGame) then
    FGame.OnDisplayClear;
end;

procedure TEngine.OnDisplayToggleFullscreen(aFullscreen: Boolean);
begin
  if Assigned(FGame) then
    FGame.OnDisplayToggleFullscreen(aFullscreen);
end;

procedure TEngine.OnRender;
begin
  if Assigned(FGame) then
    FGame.OnRender;
end;

procedure TEngine.OnRenderHUD;
begin
  if Assigned(FGame) then
    FGame.OnRenderHUD;
  FCmdConsole.Render;
end;

procedure TEngine.OnDisplayShow;
begin
  if Assigned(FGame) then
    FGame.OnDisplayShow;
end;

procedure TEngine.OnSpeechWord(const aWord: string; const aText: string);
begin
  if Assigned(FGame) then
    FGame.OnSpeechWord(aWord, aText);
end;

procedure TEngine.OnUpdate(aDeltaTime: Double);
begin
  if not FCmdConsole.Active then
  begin
    if Assigned(FGame) then
      FGame.OnUpdate(aDeltaTime);

     FScreenshake.Process(FTimer.UpdateSpeed, aDeltaTime);
  end;

  FCmdConsole.Update(aDeltaTime);
end;

procedure TEngine.OnLuaReset;
begin
  if Assigned(FGame) then
    FGame.OnLuaReset;
end;

procedure TEngine.SetTerminate(aTerminate: Boolean);
begin
  FTerminate := aTerminate;
end;

function  TEngine.GetTerminate: Boolean;
begin
  Result := FTerminate;
end;

function  TEngine.GetVersion: string;
begin
  Result := VIVACE_VERSION;
end;

procedure TEngine.UpdateTiming;
begin
  FTimer.LNow := GetTime;
  FTimer.Passed := FTimer.LNow - FTimer.Last;
  FTimer.Last := FTimer.LNow;

  // process framerate
  Inc(FTimer.FrameCount);
  FTimer.FrameAccumulator := FTimer.FrameAccumulator + FTimer.Passed + EPSILON;
  if FTimer.FrameAccumulator >= 1 then
  begin
    FTimer.FrameAccumulator := 0;
    FTimer.FrameRate := FTimer.FrameCount;
    FTimer.FrameCount := 0;
  end;

  // process variable update
  FTimer.Accumulator := FTimer.Accumulator + FTimer.Passed;
  while (FTimer.Accumulator >= FTimer.DeltaTime) do
  begin
    OnUpdate(FTimer.DeltaTime);
    FTimer.Accumulator := FTimer.Accumulator - FTimer.DeltaTime;
  end;
end;

function TEngine.GetTime: Double;
begin
  Result := al_get_time;
end;

procedure TEngine.ResetTiming;
begin
  FTimer.LNow := 0;
  FTimer.Passed := 0;
  FTimer.Last := 0;

  FTimer.Accumulator := 0;
  FTimer.FrameAccumulator := 0;

  FTimer.DeltaTime := 0;

  FTimer.FrameCount := 0;
  FTimer.FrameRate := 0;

  SetUpdateSpeed(FTimer.UpdateSpeed);

  FTimer.Last := GetTime;
end;

procedure TEngine.SetUpdateSpeed(aSpeed: Single);
begin
  FTimer.UpdateSpeed := aSpeed;
  FTimer.DeltaTime := 1.0 / FTimer.UpdateSpeed;
end;

function  TEngine.GetUpdateSpeed: Single;
begin
  Result := FTimer.UpdateSpeed;
end;

function  TEngine.GetDeltaTime: Double;
begin
  Result := FTimer.DeltaTime;
end;

function  TEngine.GetFrameRate: Cardinal;
begin
  Result := FTimer.FrameRate;
end;

function  TEngine.FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + (aSpeed / FTimer.UpdateSpeed);
  if aTimer >= 1.0 then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

function  TEngine.FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + FTimer.DeltaTime;
  if aTimer > aFrames then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

function  TEngine.MountArchive(aFilename: string): Boolean;
var
  LMarsheller: TMarshaller;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;
  if TFile.Exists(aFilename) then
    begin
      Result := PHYSFS_mount(LMarsheller.AsAnsi(aFilename).ToPointer, nil, True);
      if Result then
        TLogger.Log(etSuccess, 'Successfull mounted archive: %s', [aFilename])
      else
        TLogger.Log(etError, 'Failed to mounte archive: %s', [aFilename])
    end
  else
    begin
      TLogger.Log(etError, 'Archive was not found: %s', [aFilename]);
    end;
end;

function  TEngine.UnmountArchive(aFilename: string): Boolean;
var
  LMarsheller: TMarshaller;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;
  if TFile.Exists(aFilename) then
    begin
      Result := PHYSFS_unmount(LMarsheller.AsAnsi(aFilename).ToPointer);
      if Result then
        TLogger.Log(etSuccess, 'Successfull unmounted archive: %s', [aFilename])
      else
        TLogger.Log(etError, 'Failed to unmount archive: %s', [aFilename])
    end
  else
    begin
      TLogger.Log(etError, 'Archive was not found: %s', [aFilename]);
    end;
end;

function  TEngine.ArchiveFileExist(aFilename: string): Boolean;
var
  LMarsheller: TMarshaller;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;
  Result := Boolean(PHYSFS_exists(LMarsheller.AsAnsi(aFilename).ToPointer) <> 0);
end;

procedure TEngine.Run(aGame: TCustomGameClass);
begin
  FGame := aGame.Create;
  try
    FGame.Run;
  finally
    FreeAndNil(FGame);
  end;
end;

initialization
begin
  gEngine := TEngine.Create;
end;

finalization
begin
  FreeAndNil(gEngine);
end;

end.
