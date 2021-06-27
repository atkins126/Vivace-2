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

unit Vivace.Screenshake;

{$I Vivace.Defines.inc }

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  Vivace.External.Allegro,
  Vivace.Base,
  Vivace.Common,
  Vivace.Math;

type

  { TScreenshake }
  TScreenshake = class
  protected
    FActive: Boolean;
    FDuration: Single;
    FMagnitude: Single;
    FTimer: Single;
    FPos: TPointi;
  public
    constructor Create(aDuration: Single; aMagnitude: Single);
    destructor Destroy; override;
    procedure Process(aSpeed: Single; aDeltaTime: Double);
    property Active: Boolean read FActive;
  end;

  { TScreenshakes }
  TScreenshakes = class(TBaseObject)
  protected
    FTrans: ALLEGRO_TRANSFORM;
    FList: TObjectList<TScreenshake>;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Process(aSpeed: Single; aDeltaTime: Double);

    procedure Start(aDuration: Single; aMagnitude: Single);
    procedure Clear;
    function  Active: Boolean;
  end;

implementation

uses
  System.Math,
  Vivace.Utils,
  Vivace.Engine;


{ TScreenshake }
constructor TScreenshake.Create(aDuration: Single; aMagnitude: Single);
begin
  inherited Create;

  FActive := True;
  FDuration := aDuration;
  FMagnitude := aMagnitude;
  FTimer := 0;
  FPos.x := 0;
  FPos.y := 0;
end;

destructor TScreenshake.Destroy;
begin

  inherited;
end;

function lerp(t: Single; a: Single; b: Single): Single; inline;
begin
  Result := (1 - t) * a + t * b;
end;

procedure TScreenshake.Process(aSpeed: Single; aDeltaTime: Double);
begin
  if not FActive then Exit;

  FDuration := FDuration - (aSpeed * aDeltaTime);
  if FDuration <= 0 then
  begin
    gEngine.Display.SetTransformPosition(-FPos.x, -FPos.y);
    FActive := False;
    Exit;
  end;

  if Round(FDuration) <> Round(FTimer) then
  begin
    gEngine.Display.SetTransformPosition(-FPos.x, -FPos.y);

    FPos.x := Round(TMath.RandomRange(-FMagnitude, FMagnitude));
    FPos.y := Round(TMath.RandomRange(-FMagnitude, FMagnitude));

    gEngine.Display.SetTransformPosition(FPos.x, FPos.y);

    FTimer := FDuration;
  end;
end;


{ TScreenshakes }
constructor TScreenshakes.Create;
begin
  inherited;

  FList := TObjectList<TScreenshake>.Create(True);
  al_identity_transform(@FTrans);
end;

destructor TScreenshakes.Destroy;
begin
  FreeAndNil(FList);

  inherited;
end;

procedure TScreenshakes.Start(aDuration: Single; aMagnitude: Single);
var
  LShake: TScreenshake;
begin
  LShake := TScreenshake.Create(aDuration, aMagnitude);
  FList.Add(LShake);
end;

procedure TScreenshakes.Clear;
begin
  FList.Clear;
end;

function TScreenshakes.Active: Boolean;
begin
  Result := Boolean(FList.Count > 0);
end;

procedure TScreenshakes.Process(aSpeed: Single; aDeltaTime: Double);
var
  LShake: TScreenshake;
  LFlag: Boolean;
begin
  // process shakes
  LFlag := Active;
  for LShake in FList do
  begin
    if LShake.Active then
    begin
      LShake.Process(aSpeed, aDeltaTime);
    end
    else
    begin
      FList.Remove(LShake);
    end;
  end;

  if LFlag then
  begin
    if not Active then
    begin
      // Lib.Display.ResetTransform;
    end;
  end;

end;

end.
