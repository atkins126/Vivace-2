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

unit uViExamples;

interface

uses
  Vivace.Game,
  Vivace.Color,
  uCommon,
  // examples
  uDisplay,
  uEntity,
  uActor,
  uBitmap,
  uFont,
  uAudio,
  // demos
  uAstroBlasterDemo,
  uScrollDemo,
  uElasticDemo,
  uChainActionDemo,
  uViewportsDemo,
  uGUIDemo;

type
  { TExamples }
  TExamples = class(TCustomGameApp)
  public
    procedure OnSetConfig(var aConfig: TGameConfig); override;
    function  OnStartupDialogShow: Boolean; override;
    function  OnStartupDialogRun: Boolean; override;
    procedure OnLoad; override;
  end;

implementation

uses
  System.SysUtils,
  Vivace.Common,
  Vivace.Engine,
  Vivace.TreeMenu;


{ TExamples }
procedure TExamples.OnSetConfig(var aConfig: TGameConfig);
begin
  aConfig.ArchiveFilename := cArchiveFilename;
  aConfig.DisplayTitle := cDisplayTitle;
  aConfig.DisplayClearColor := BLACK;
end;

function  TExamples.OnStartupDialogShow: Boolean;
begin
  gEngine.StartupDialog.SetCaption(cDisplayTitle);
  gEngine.StartupDialog.SetLogo('arc/startup/banner.png');
  gEngine.StartupDialog.SetLogoClickUrl(cVivaceURL);
  gEngine.StartupDialog.SetReadme('arc/startup/README.rtf');
  gEngine.StartupDialog.SetLicense('arc/startup/LICENSE.rtf');
  gEngine.StartupDialog.SetReleaseInfo('Vivace v' + VIVACE_VERSION);
  Result := True;
end;

function  TExamples.OnStartupDialogRun: Boolean;
type
  { TMenuIds }
  TMenuIds = (
    // Display
    miDisplayPrimitives,
    miDisplayRotateViewport,
    miDisplayBasic,
    miDisplayToggleFullscreen,

    // Bitmap
    miBitmapColorKeyTransparency,
    miBitmapTrueTransparency,
    miBitmapTiled,

    // Font
    miFontUnicode,

    // Entity
    miEntityBasic,
    miEntityPolyPointCollision,
    miEntityPolyPointCollisionPoint,
    miEntityBlendMode,

    //Actor
    miActorBasic,

    // Audio
    miAudioMusic,
    miAudioSound,
    miAudioPositional,

    // Demo
    miDemoAstroBlaster,
    miDemoChainAction,
    miDemoScroll,
    miDemoElastic,
    miDemoViewports,
    miDemoGUI
  );

var
  LTreeMenu: TTreeMenu;
  LDisplay: Integer;
  LBitmap: Integer;
  LFont: Integer;
  LEntity: Integer;
  LDemo: Integer;
  LActor: Integer;
  LAudio: Integer;
  LSelItem: Integer;
begin
  LTreeMenu := TTreeMenu.Create;
  try
    LTreeMenu.SetTitle(cDisplayTitle);

    // Display
    LDisplay := LTreeMenu.AddItem(0, 'Display', TREEMENU_NONE, True);
    LTreeMenu.AddItem(LDisplay, 'Rotate Viewport', Ord(miDisplayRotateViewport), True);
    LTreeMenu.AddItem(LDisplay, 'Primitives', Ord(miDisplayPrimitives), True);
    LTreeMenu.AddItem(LDisplay, 'Basic', Ord(miDisplayBasic), True);
    LTreeMenu.AddItem(LDisplay, 'Toggle Fullscreen', Ord(miDisplayToggleFullscreen), True);
    LTreeMenu.Sort(LDisplay);

    // Bitmap
    LBitmap  := LTreeMenu.AddItem(0, 'Bitmap', TREEMENU_NONE, True);
    LTreeMenu.AddItem(LBitmap, 'ColorKey Transparency', Ord(miBitmapColorKeyTransparency), True);
    LTreeMenu.AddItem(LBitmap, 'True Transparency', Ord(miBitmapTrueTransparency), True);
    LTreeMenu.AddItem(LBitmap, 'Tiled', Ord(miBitmapTiled), True);
    LTreeMenu.Sort(LBitmap);

    // Font
    LFont  := LTreeMenu.AddItem(0, 'Font', TREEMENU_NONE, True);
    LTreeMenu.AddItem(LFont, 'Unicode', Ord(miFontUnicode), True);
    LTreeMenu.Sort(LFont);

    // Entity
    LEntity := LTreeMenu.AddItem(0, 'Entity', TREEMENU_NONE, True);
    LTreeMenu.AddItem(LEntity, 'Basic', Ord(miEntityBasic), True);
    LTreeMenu.AddItem(LEntity, 'PolyPoint Collision', Ord(miEntityPolyPointCollision), True);
    LTreeMenu.AddItem(LEntity, 'PolyPoint Collision Point', Ord(miEntityPolyPointCollisionPoint), True);
    LTreeMenu.AddItem(LEntity, 'Blend Mode', Ord(miEntityBlendMode), True);
    LTreeMenu.Sort(LEntity);

    // Actor
    LActor := LTreeMenu.AddItem(0, 'Actor', TREEMENU_NONE, True);
    LTreeMenu.AddItem(LActor, 'Basic', Ord(miActorBasic), True);
    LTreeMenu.Sort(LActor);
    LTreeMenu.Sort(0);

    // Audio
    LAudio  := LTreeMenu.AddItem(0, 'Audio', TREEMENU_NONE, True);
    LTreeMenu.AddItem(LAudio, 'Music', Ord(miAudioMusic), True);
    LTreeMenu.AddItem(LAudio, 'Sound', Ord(miAudioSound), True);
    LTreeMenu.AddItem(LAudio, 'Positional', Ord(miAudioPositional), True);
    LTreeMenu.Sort(LAudio);


    // Demo
    LDemo := LTreeMenu.AddItem(0, 'Demo', TREEMENU_NONE, True);
    LTreeMenu.AddItem(LDemo, 'AstroBlaster', Ord(miDemoAstroBlaster), True);
    LTreeMenu.AddItem(LDemo, 'ChainAction', Ord(miDemoChainAction), True);
    LTreeMenu.AddItem(LDemo, 'Scroll', Ord(miDemoScroll), True);
    LTreeMenu.AddItem(LDemo, 'Elastic', Ord(miDemoElastic), True);
    LTreeMenu.AddItem(LDemo, 'Viewports', Ord(miDemoViewports), True);
    LTreeMenu.AddItem(LDemo, 'GUI', Ord(miDemoGUI), True);
    LTreeMenu.Sort(LDemo);

    LSelItem := ConfigFile.GetValue('Examples.Menu', 'SelItem', TREEMENU_NONE);
    repeat
      LSelItem := LTreeMenu.Show(LSelItem);
      case TMenuIds(LSelItem) of
        // display
        miDisplayRotateViewport        : RunGame(TDisplayRotateViewport);
        miDisplayBasic                 : RunGame(TDisplayBasic);
        miDisplayToggleFullscreen      : RunGame(TDisplayToggleFullscreen);
        miDisplayPrimitives            : RunGame(TDisplayPrimitives);

        // bitmap
        miBitmapColorKeyTransparency   : RunGame(TBitmapColorKeyTransparency);
        miBitmapTrueTransparency       : RunGame(TBitmapTrueTransparency);
        miBitmapTiled                  : RunGame(TBitmapTiled);

        // font
        miFontUnicode                  : RunGame(TFontUnicode);

        // entity
        miEntityBasic                  : RunGame(TEntityBasic);
        miEntityPolyPointCollision     : RunGame(TEntityPolyPointCollision);
        miEntityPolyPointCollisionPoint: RunGame(TEntityPolyPointCollisionPoint);
        miEntityBlendMode              : RunGame(TEntityBlendMode);

        // actor
        miActorBasic                   : RunGame(TActorBasic);

        // audio
        miAudioMusic                   : RunGame(TAudioMusic);
        miAudioSound                   : RunGame(TAudioSound);
        miAudioPositional              : RunGame(TAudioPositional);

        // demo
        miDemoAstroBlaster             : RunGame(TAstroBlasterDemo);
        miDemoScroll                   : RunGame(TScrollDemo);
        miDemoChainAction              : RunGame(TChainActionDemo);
        miDemoElastic                  : RunGame(TElasticDemo);
        miDemoViewports                : RunGame(TAViewportsDemo);
        miDemoGUI                      : RunGame(TGUIDemo);
      end;
    until LSelItem = TREEMENU_QUIT;

    ConfigFile.SetValue('Examples.Menu', 'SelItem', LTreeMenu.GetLastSelectedId);

  finally
    FreeAndNil(LTreeMenu);
  end;

  Result := False;
end;

procedure TExamples.OnLoad;
begin
  inherited;

end;



end.
