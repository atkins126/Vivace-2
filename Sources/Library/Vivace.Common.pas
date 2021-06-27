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

unit Vivace.Common;

{$I Vivace.Defines.inc }

interface

uses
  Vivace.External.Allegro,
  Vivace.Base;

const
  { library info }
  VIVACE_MAJOR_VERSION  = '0';
  VIVACE_MINOR_VERSION  = '1';
  VIVACE_PATCH_VERSION  = '0';
  VIVACE_VERSION        = VIVACE_MAJOR_VERSION + '.' + VIVACE_MINOR_VERSION + '.' + VIVACE_PATCH_VERSION;
  VIVACE_DESCRIPTION    = 'Vivace™ Game Toolkit';
  VIVACE_LEGALCOPYRIGHT = 'Copyright © 2020-21 tinyBigGAMES™ LLC';
  VIVACE_LEGALTRADEMARK = 'All rights reserved.';
  VIVACE_WEBISTE        = 'https://tinybiggames.com';
  VIVACE_EMAIL          = 'support@tinybiggames.com';

  { math }
  EPSILON               = 0.00001;

  { TreeMenu }
  TREEMENU_NONE         = -1;
  TREEMENU_QUIT         = -2;

  { extentions }
  ARC_EXT               = 'arc';
  CFG_EXT               = 'cfg';
  LOG_EXT               = 'log';

type
  { TStringArray }
  TStringArray = array of string;

  { TLogEventType }
  TLogEventType = (etInfo, etSuccess, etWarning, etError, etDebug, etDone, etTrace, etCritical, etException);

  { THAlign }
  THAlign = (haLeft, haCenter, haRight);

  { TVAlign }
  TVAlign = (vaTop, vaCenter, vaBottom);

  { TStartupDialogState }
  TStartupDialogState = (sdsMore = 0, sdsRun = 1, sdsQuit = 2);

{ TObj }
  PObj = ^TObj;
  TObj = record
    case Integer of
      0: (Display: PALLEGRO_DISPLAY);
      1: (Bitmap: PALLEGRO_BITMAP);
      2: (Font: PALLEGRO_FONT);
      3: (Video: PALLEGRO_VIDEO);
      4: (Sample: PALLEGRO_SAMPLE);
      5: (Stream: PALLEGRO_AUDIO_STREAM);
    end;

  { TCommonObject }
  TCommonObject = class(TBaseObject)
  protected
    FHandle: TObj;
  public
    property Handle: TObj read FHandle write FHandle;
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation


{ TCommonObject }
constructor TCommonObject.Create;
begin
  inherited;

end;

destructor TCommonObject.Destroy;
begin

  inherited;
end;

end.
