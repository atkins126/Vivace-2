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

unit Vivace.Async;

{$I Vivace.Defines.inc }

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.SyncObjs,
  System.Classes,
  Vivace.Base,
  Vivace.Common;

type
  { TAsyncThread }
  TAsyncThread = class(TThread)
  protected
    FTask: TProc;
    FWait: TProc;
    FFinished: Boolean;
  public
    property TaskProc: TProc read FTask write FTask;
    property WaitProc: TProc read FWait write FWait;
    property Finished: Boolean read FFinished;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Execute; override;
  end;

  { TAsync }
  TAsync = class(TBaseObject)
  protected
    FCriticalSection: TCriticalSection;
    FQueue: TList<TAsyncThread>;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Run(aTask: TProc; aWait: TProc);

    procedure Enter;
    procedure Leave;

    procedure Process;
  end;

implementation

uses
  Vivace.Utils,
  Vivace.Engine;


{ TAsyncThread }
constructor TAsyncThread.Create;
begin
  inherited Create(True);

  FTask := nil;
  FWait := nil;
  FFinished := False;
end;

destructor TAsyncThread.Destroy;
begin

  inherited;
end;

procedure TAsyncThread.Execute;
begin
  FFinished := False;

  if Assigned(FTask) then
  begin
    FTask();
  end;

  FFinished := True;
end;


{ TAsync }
constructor TAsync.Create;
begin
  inherited;

  FCriticalSection := TCriticalSection.Create;
  FQueue := TList<TAsyncThread>.Create;
end;

destructor TAsync.Destroy;
begin
  FreeAndNil(FQueue);
  FreeAndNil(FCriticalSection);

  inherited;
end;

procedure TAsync.Run(aTask: TProc; aWait: TProc);
var
  LAsyncThread: TAsyncThread;
begin
  if not Assigned(aTask) then Exit;
  //Enter;
  LAsyncThread := TAsyncThread.Create;
  LAsyncThread.TaskProc := aTask;
  if Assigned(aWait) then LAsyncThread.WaitProc := aWait;
  FQueue.Add(LAsyncThread);
  LAsyncThread.Start;
  //Leave;
end;

procedure TAsync.Process;
var
  LAsyncThread: TAsyncThread;
begin
  Enter;

  if TThread.CurrentThread.ThreadID = MainThreadID then
  begin
    for LAsyncThread in FQueue do
    begin
      if Assigned(LAsyncThread) then
      begin
        if LAsyncThread.Finished then
        begin
          LAsyncThread.WaitFor;
          if Assigned(LAsyncThread.WaitProc) then
            LAsyncThread.WaitProc();
          FQueue.Remove(LAsyncThread);
          FreeAndNil(LAsyncThread);
        end;
      end;
    end;
    FQueue.Pack;
  end;

  Leave;
end;

procedure TAsync.Enter;
begin
  FCriticalSection.Enter;
end;

procedure TAsync.Leave;
begin
  FCriticalSection.Leave;
end;

end.
