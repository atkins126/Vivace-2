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

unit Vivace.Console;

{$I Vivace.Defines.inc }

interface

uses
  Vivace.Common;

type

  { TConsoleColor }
  TConsoleColor = (
  ccBlack        = 0,
  ccBlue         = 1,
  ccGreen        = 2,
  ccCyan         = 3,
  ccRed          = 4,
  ccMagenta      = 5,
  ccBrown        = 6,
  ccLightGray    = 7,
  ccDarkGray     = 8,
  ccLightBlue    = 9,
  ccLightGreen   = 10,
  ccLightCyan    = 11,
  ccLightRed     = 12,
  ccLightMagenta = 13,
  ccYellow       = 14,
  ccWhite        = 15,
  ccDefault);


  { TConsole }
  TConsole = class
  public
    class procedure Write(const aMsg: string; const aArgs: array of const; aEventType: TLogEventType); overload;
    class procedure Write(const aMsg: string; const aArgs: array of const; aFColor: TConsoleColor=ccDefault; aBColor: TConsoleColor=ccDefault); overload;
    class procedure Write; overload;
    class procedure WriteLn(const aMsg: string; const aArgs: array of const; aEventType: TLogEventType); overload;
    class procedure WriteLn(const aMsg: string; const aArgs: array of const;  aFColor: TConsoleColor=ccDefault; aBColor: TConsoleColor=ccDefault); overload;
    class procedure WriteLn; overload;

    class procedure SetTextColor(aColor: TConsoleColor);
    class procedure SetTextBackgroundColor(aColor: TConsoleColor);
    class procedure ResetColors;

    class function  IsAvailable: Boolean;

    class function  KeyPressed: Boolean;
    class procedure WaitForAnyKey;
  end;

implementation

uses
  System.SysUtils,
  WinAPI.Windows,
  Vivace.OS,
  Vivace.Utils;

var
  LastMode : Word;
  DefConsoleColor : Byte;
  DefBackgroundColor: Byte;
  TextAttr : Byte;
  hStdOut: THandle;
  hStdErr: THandle;
  ConsoleRect: TSmallRect;
  ConsoleInit: Boolean = False;

procedure InitConsole;
var
  BufferInfo: TConsoleScreenBufferInfo;
begin
  if ConsoleInit then Exit;
  if not IsConsoleApp then Exit;

  Rewrite(Output);
  hStdOut := TTextRec(Output).Handle;
  Rewrite(ErrOutput);
  hStdErr := TTextRec(ErrOutput).Handle;
  if not GetConsoleScreenBufferInfo(hStdOut, BufferInfo) then
  begin
    SetInOutRes(GetLastError);
    Exit;
  end;
  ConsoleRect.Left := 0;
  ConsoleRect.Top := 0;
  ConsoleRect.Right := BufferInfo.dwSize.X - 1;
  ConsoleRect.Bottom := BufferInfo.dwSize.Y - 1;
  TextAttr := BufferInfo.wAttributes and $FF;
  DefConsoleColor := TextAttr;
  DefBackgroundColor := Ord(ccBlack);
  LastMode := 3; //CO80;
  ConsoleInit := True;
end;


{ TConsole }
class procedure TConsole.Write(const aMsg: string; const aArgs: array of const; aEventType: TLogEventType);
var
  LFColor: TConsoleColor;
  LBColor: TConsoleColor;
begin
  InitConsole;
  LBColor := TConsoleColor(DefBackgroundColor);
  case aEventType of
    etError     : LFColor := ccLightRed;
    etInfo      : LFColor := ccWhite;
    etSuccess   : LFColor := ccLightGreen;
    etWarning   : LFColor := ccYellow;
    etDebug     : LFColor := ccLightCyan;
    etTrace     : LFColor := ccLightMagenta;
    etCritical  :
      begin
        LFColor := ccYellow;
        LBColor := ccRed;
      end;
    etException : LFColor := ccRed;
  else
    LFColor := ccWhite;
  end;

  Write(aMsg, aArgs, LFColor, LBColor);

end;

class procedure TConsole.Write(const aMsg: string; const aArgs: array of const; aFColor: TConsoleColor; aBColor: TConsoleColor);
begin
  InitConsole;
  if IsAvailable then
  begin
    SetTextColor(aFColor);
    SetTextBackgroundColor(aBColor);
    System.Write(Format(aMsg, aArgs));
    ResetColors;
  end;
end;

class procedure TConsole.Write;
begin
  Write('', []);
end;

class procedure TConsole.WriteLn(const aMsg: string; const aArgs: array of const; aEventType: TLogEventType);
var
  LFColor: TConsoleColor;
  LBColor: TConsoleColor;
begin
  InitConsole;
  LBColor := TConsoleColor(DefBackgroundColor);
  case aEventType of
    etError     : LFColor := ccLightRed;
    etInfo      : LFColor := ccLightGray;
    etSuccess   : LFColor := ccLightGreen;
    etWarning   : LFColor := ccYellow;
    etDebug     : LFColor := ccLightCyan;
    etTrace     : LFColor := ccLightMagenta;
    etCritical  :
      begin
        LFColor := ccYellow;
        LBColor := ccRed;
      end;
    etException : LFColor := ccRed;
  else
    LFColor := ccLightGray;
  end;

  WriteLn(aMsg, aArgs, LFColor, LBColor);
end;

class procedure TConsole.WriteLn(const aMsg: string; const aArgs: array of const; aFColor: TConsoleColor; aBColor: TConsoleColor);
begin
  InitConsole;
  if IsAvailable then
  begin
    SetTextColor(aFColor);
    SetTextBackgroundColor(aBColor);
    System.WriteLn(Format(aMsg, aArgs));
    ResetColors;
  end;
end;

class procedure TConsole.WriteLn;
begin
  WriteLn('', []);
end;

class procedure TConsole.SetTextColor(aColor: TConsoleColor);
var
  LColor: Byte;
begin
  InitConsole;
  if not IsAvailable then Exit;
  if aColor = ccDefault then
    LColor := DefConsoleColor
  else
    LColor := Ord(aColor);
  LastMode := TextAttr;
  TextAttr := (TextAttr and $F0) or (LColor and $0F);
  if TextAttr <> LastMode then SetConsoleTextAttribute(hStdOut, TextAttr);
end;

class procedure TConsole.SetTextBackgroundColor(aColor: TConsoleColor);
var
  LColor: Byte;
begin
  InitConsole;
  if not IsAvailable then Exit;
  if aColor = ccDefault then
    LColor := DefBackgroundColor
  else
    LColor := Ord(aColor);
  LastMode := TextAttr;
  TextAttr := (TextAttr and $0F) or ((LColor shl 4) and $F0);
  if TextAttr <> LastMode then SetConsoleTextAttribute(hStdOut, TextAttr);
end;

class procedure TConsole.ResetColors;
begin
  InitConsole;
  SetConsoleTextAttribute(hStdOut, DefConsoleColor);
  TextAttr := DefConsoleColor;
end;

class function  TConsole.IsAvailable: Boolean;
begin
  InitConsole;
  Result := Boolean(hStdOut <> 0);
end;

class function TConsole.KeyPressed: Boolean;
var
  lpNumberOfEvents     : DWORD;
  lpBuffer             : TInputRecord;
  lpNumberOfEventsRead : DWORD;
  nStdHandle           : THandle;
begin
  Result:=false;
  //get the console handle
  nStdHandle := GetStdHandle(STD_INPUT_HANDLE);

  lpNumberOfEvents:=0;
  //get the number of events
  GetNumberOfConsoleInputEvents(nStdHandle,lpNumberOfEvents);
  if lpNumberOfEvents<> 0 then
  begin
    //retrieve the event
    PeekConsoleInput(nStdHandle,lpBuffer,1,lpNumberOfEventsRead);
    if lpNumberOfEventsRead <> 0 then
    begin
      if lpBuffer.EventType = KEY_EVENT then //is a Keyboard event?
      begin
        if lpBuffer.Event.KeyEvent.bKeyDown then //the key was pressed?
          Result:=true
        else
          FlushConsoleInputBuffer(nStdHandle); //flush the buffer
      end
      else
      FlushConsoleInputBuffer(nStdHandle);//flush the buffer
    end;
  end;
  FlushConsoleInputBuffer(nStdHandle);//flush the buffer
end;

class procedure TConsole.WaitForAnyKey;
begin
  repeat
    Sleep(1);
    TOS.ProcessMessages;
  until KeyPressed;
end;

initialization
begin
  InitConsole;
end;

finalization
begin
  ConsoleInit := False;
end;

end.
