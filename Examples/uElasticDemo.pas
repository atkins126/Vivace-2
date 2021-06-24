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

unit uElasticDemo;

interface

uses
  Vivace.Base,
  Vivace.Game,
  Vivace.Actor,
  Vivace.Color,
  Vivace.Math,
  Vivace.Bitmap,
  uCommon;


const
  cGravity          = 0.04;
  cXDecay           = 0.97;
  cYDecay           = 0.97;
  cBeadCount        = 10;
  cXElasticity      = 0.02;
  cYElasticity      = 0.02;
  cWallDecay        = 0.9;
  cSlackness        = 1;
  cBeadSize         = 12;
  cBedHalfSize      = cBeadSize / 2;
  cBeadFilled       = True;

type
  { TBead }
  TBead = record
    X    : Single;
    Y    : Single;
    XMove: Single;
    YMove: Single;
  end;

  { TElasticDemo }
  TElasticDemo = class(TBaseExample)
  protected
    FViewWidth: Single;
    FViewHeight: Single;
    FBead : array[0..cBeadCount] of TBead;
    FTimer: Single;
    FMusic: Integer;
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Vivace.External.Allegro,
  Vivace.Logger,
  Vivace.Common,
  Vivace.Engine,
  Vivace.Input,
  Vivace.Display;

{ TElasticDemo }
procedure TElasticDemo.OnSetConfig(var aConfig: TGameConfig);
begin
  inherited;
  aConfig.DisplayTitle := cExampleTitle + 'Elastic Demo';
end;

procedure TElasticDemo.OnLoad;
begin
  inherited;
end;

procedure TElasticDemo.OnExit;
begin
  inherited;
end;

procedure TElasticDemo.OnStartup;
var
  LVP: TRectangle;
begin
  inherited;

  FillChar(FBead, SizeOf(FBead), 0);

  gEngine.Display.GetViewportSize(LVP);
  FViewWidth := LVP.Width;
  FViewHeight := LVP.Height;

  FMusic := gEngine.Audio.LoadMusic('arc/audio/music/song04.ogg');
  gEngine.Audio.PlayMusic(FMusic, 0.5, True);
end;

procedure TElasticDemo.OnShutdown;
begin
  gEngine.Audio.UnloadMusic(FMusic);

  inherited;
end;

procedure TElasticDemo.OnUpdate(aDeltaTime: Double);
var
  LI: Integer;
  LDist, LDistX, LDistY: Single;
begin
  inherited;

  if not gEngine.FrameSpeed(FTimer, gEngine.GetUpdateSpeed) then
    Exit;

  FBead[0].X := MousePos.X;
  FBead[0].Y := MousePos.Y;

  if FBead[0].X - (cBeadSize+10)/2<0 then
  begin
   FBead[0].X := (cBeadSize+10)/2;
  end;

  if FBead[0].X + ((cBeadSize+10)/2) >FViewWidth then
  begin
   FBead[0].X := FViewWidth - (cBeadSize+10)/2;
  end;

  if FBead[0].Y - ((cBeadSize+10)/2) < 0 then
  begin
   FBead[0].Y := (cBeadSize+10)/2;
  end;

  if FBead[0].Y + ((cBeadSize+10)/2) > FViewHeight then
  begin
   FBead[0].Y := FViewHeight - (cBeadSize+10)/2;
  end;

  // loop though other beads
  for LI := 1 to cBeadCount do
  begin
    // calc X and Y distance between the bead and the one before it
    LDistX := FBead[LI].X - FBead[LI-1].X;
    LDistY := FBead[LI].Y - FBead[LI-1].Y;

    // calc total distance
    LDist := sqrt(LDistX*LDistX + LDistY * LDistY);

    // if the beads are far enough apart, decrease the movement to create elasticity
    if LDist > cSlackness then
    begin
       FBead[LI].XMove := FBead[LI].XMove - (cXElasticity * LDistX);
       FBead[LI].YMove := FBead[LI].YMove - (cYElasticity * LDistY);
    end;

    // if bead is not last bead
    if LI <> cBeadCount then
    begin
       // calc distances between the bead and the one after it
       LDistX := FBead[LI].X - FBead[LI+1].X;
       LDistY := FBead[LI].Y - FBead[LI+1].Y;
       LDist  := sqrt(LDistX*LDistX + LDistY*LDistY);

       // if beads are far enough apart, decrease the movement to create elasticity
       if LDist > 1 then
       begin
          FBead[LI].XMove := FBead[LI].XMove - (cXElasticity * LDistX);
          FBead[LI].YMove := FBead[LI].YMove - (cYElasticity * LDistY);
       end;
    end;

    // decay the movement of the beads to simulate loss of energy
    FBead[LI].XMove := FBead[LI].XMove * cXDecay;
    FBead[LI].YMove := FBead[LI].YMove * cYDecay;

    // apply cGravity to bead movement
    FBead[LI].YMove := FBead[LI].YMove + cGravity;

    // move beads
    FBead[LI].X := FBead[LI].X + FBead[LI].XMove;
    FBead[LI].Y := FBead[LI].Y + FBead[LI].YMove;

    // ff the beads hit a wall, make them bounce off of it
    if FBead[LI].X - ((cBeadSize + 10 ) / 2) < 0 then
    begin
       FBead[LI].X     :=  FBead[LI].X     + (cBeadSize+10)/2;
       FBead[LI].XMove := -FBead[LI].XMove * cWallDecay;
    end;

    if FBead[LI].X + ((cBeadSize+10)/2) > FViewWidth then
    begin
       FBead[LI].X     := FViewWidth - (cBeadSize+10)/2;
       FBead[LI].xMove := -FBead[LI].XMove * cWallDecay;
    end;

    if FBead[LI].Y - ((cBeadSize+10)/2) < 0 then
    begin
       FBead[LI].YMove := -FBead[LI].YMove * cWallDecay;
       FBead[LI].Y     :=(cBeadSize+10)/2;
    end;

    if FBead[LI].Y + ((cBeadSize+10)/2) > FViewHeight then
    begin
       FBead[LI].YMove := -FBead[LI].YMove * cWallDecay;
       FBead[LI].Y     := FViewHeight - (cBeadSize+10)/2;
    end;
  end;

end;

procedure TElasticDemo.OnRender;
var
  LI: Integer;
begin
  inherited;

  // draw last bead
  gEngine.Display.DrawFilledRectangle(FBead[0].X, FBead[0].Y, cBeadSize, cBeadSize, GREEN);

  // loop though other beads
  for LI := 1 to cBeadCount do
  begin
    // draw bead and string from it to the one before it
    gEngine.Display.DrawLine(FBead[LI].x+cBedHalfSize,
      FBead[LI].y+cBedHalfSize, FBead[LI-1].x+cBedHalfSize,
      FBead[LI-1].y+cBedHalfSize, YELLOW, 1);
    gEngine.Display.DrawFilledRectangle(FBead[LI].X, FBead[LI].Y, cBeadSize,
     cBeadSize, GREEN);
  end;

end;

procedure TElasticDemo.OnRenderHUD;
begin
  inherited;
end;


end.
