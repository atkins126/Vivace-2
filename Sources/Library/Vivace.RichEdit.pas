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

unit Vivace.RichEdit;

{$I Vivace.Defines.inc }

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls;

type

  { TRichEdit }
  TRichEdit = class(Vcl.ComCtrls.TRichEdit)
  private
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
  protected
    procedure CreateWnd; override;
  end;

implementation

uses
  Winapi.ShellAPI,
  Winapi.RichEdit;

const
  AURL_ENABLEURL = 1;
  AURL_ENABLEEAURLS = 8;

procedure TRichEdit.CreateWnd;
var
  LMask: LResult;
begin
  inherited;
  LMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(Handle, EM_SETEVENTMASK, 0, LMask or ENM_LINK);
  SendMessage(Handle, EM_AUTOURLDETECT, AURL_ENABLEURL, 0);
end;

procedure TRichEdit.CNNotify(var Message: TWMNotify);
type
  PENLink = ^TENLink;
var
  LP: PENLink;
  LTR: TEXTRANGE;
  LUrl: array of Char;
begin
  if (Message.NMHdr.code = EN_LINK) then begin
    LP := PENLink(Message.NMHdr);
    if (LP.Msg = WM_LBUTTONDOWN) then begin
      { optionally, enable this:
      if CheckWin32Version(6, 2) then begin
        // on Windows 8+, returning EN_LINK_DO_DEFAULT directs
        // the RichEdit to perform the default action...
        Message.Result :=  EN_LINK_DO_DEFAULT;
        Exit;
      end;
      }
      try
        SetLength(LUrl, LP.chrg.cpMax - LP.chrg.cpMin + 1);
        LTR.chrg := LP.chrg;
        LTR.lpstrText := PChar(LUrl);
        SendMessage(Handle, EM_GETTEXTRANGE, 0, LPARAM(@LTR));
        ShellExecute(Handle, nil, PChar(LUrl), nil, nil, SW_SHOWNORMAL);
      except
        {ignore}
      end;
      Exit;
    end;
  end;
  inherited;
end;


end.
