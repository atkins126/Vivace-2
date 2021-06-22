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

unit Vivace.Logger;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  System.Classes,
  Vivace.Base,
  Vivace.SMTP,
  Vivace.Common,
  Vivace.Console;

const
  cLogExt = 'log';

type

  { TLogger }
  TLogger = class
  public
    class procedure SetLogFilename(aFilename: string);
    class function  GetLogFilename: string;

    class procedure SetLogToConsole(aEnable: Boolean);
    class function  GetLogToConsole: Boolean;

    class procedure SetLogToFile(aEnable: Boolean);
    class function  GetLogToFile: Boolean;

    class procedure SetLogToMail(aEnable: Boolean);
    class function  GetLogToMail: Boolean;
    class procedure SetupMail(aServer: string; aPort: Integer; aUserName: string; aPassword: string; aFromAddress: string; aToAddresses: string; aSubject: string);

    class procedure Log(aType: TLogEventType; const aMsg: string; const aArgs: array of const); overload;
    class procedure Log(const aMsg: string; const aArgs: array of const; aFColor: TConsoleColor=ccDefault; aBColor: TConsoleColor=ccDefault); overload;
    class procedure Free;
  end;

implementation

uses
  System.IOUtils,
  System.StrUtils,
  Vivace.Utils,
  Vivace.OS,
  Vivace.External.CLibs;

type
  { TMLogger }
  TMLogger = class(TBaseObject)
  protected
    FLogFilename: string;
    FLog: TStringList;
    FMailLog: TStringList;
    FLogToConsole: Boolean;
    FLogToFile: Boolean;
    FLogToMail: Boolean;
    FFormatSettings : TFormatSettings;
    FMail: TSMTP;
    FMailTo: string;
    FMailFrom: string;
    FMailSubject: string;
    FHtmlTags: TStringList;
    procedure LogToFile;
    procedure LogToMail;
    function StripHTML(aText: string): string;
    procedure LogHeader;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SetLogFilename(aFilename: string);
    function GetLogFilename: string;
    procedure SetLogToConsole(aEnable: Boolean);
    function GetLogToConsole: Boolean;
    procedure SetLogToFile(aEnable: Boolean);
    function GetLogToFile: Boolean;
    procedure SetLogToMail(aEnable: Boolean);
    function GetLogToMail: Boolean;
    procedure SetupMail(aServer: string; aPort: Integer; aUserName: string; aPassword: string; aFromAddress: string; aToAddresses: string; aSubject: string);
    procedure Log(aType: TLogEventType; const aMsg: string; const aArgs: array of const); overload;
    procedure Log(const aMsg: string; const aArgs: array of const; aFColor: TConsoleColor=ccDefault; aBColor: TConsoleColor=ccDefault); overload;
  end;

var
  mLogger: TMLogger = nil;
  mRunOnce: Boolean = False;

procedure RunOnce;
begin
  if mRunOnce then Exit;
  mRunOnce := True;
  MLogger.LogHeader;

end;

procedure CreateLogger;
begin
  if MLogger = nil then
  begin
    MLogger := TMLogger.Create;
    RunOnce;
  end;
end;

procedure FreeLogger;
begin
  if mLogger <> nil then
  begin
    FreeAndNil(mLogger);
  end;
end;

{ TLogger }
class procedure TLogger.SetLogFilename(aFilename: string);
begin
  CreateLogger;
  MLogger.SetLogFilename(aFilename)
end;

class function TLogger.GetLogFilename: string;
begin
  CreateLogger;
  Result := MLogger.GetLogFilename
end;

class procedure TLogger.SetLogToConsole(aEnable: Boolean);
begin
  CreateLogger;
  MLogger.SetLogToConsole(aEnable);
end;

class function TLogger.GetLogToConsole: Boolean;
begin
  CreateLogger;
  Result := MLogger.GetLogToConsole;
end;

class procedure TLogger.SetLogToFile(aEnable: Boolean);
begin
  CreateLogger;
  MLogger.SetLogToFile(aEnable);
end;

class function TLogger.GetLogToFile: Boolean;
begin
  CreateLogger;
  Result := MLogger.GetLogToFile;
end;

class procedure TLogger.SetLogToMail(aEnable: Boolean);
begin
  CreateLogger;
  mLogger.SetLogToMail(aEnable);
end;

class function TLogger.GetLogToMail: Boolean;
begin
  CreateLogger;
  Result := mLogger.GetLogToMail;
end;

class procedure TLogger.SetupMail(aServer: string; aPort: Integer; aUserName: string; aPassword: string; aFromAddress: string; aToAddresses: string; aSubject: string);
begin
  CreateLogger;
  mLogger.SetupMail(aServer, aPort, aUserName, aPassword, aFromAddress, aToAddresses, aSubject);
end;

class procedure TLogger.Log(aType: TLogEventType; const aMsg: string; const aArgs: array of const);
begin
  CreateLogger;
  mLogger.Log(aType, aMsg, aArgs);
end;

class procedure TLogger.Log(const aMsg: string; const aArgs: array of const; aFColor: TConsoleColor; aBColor: TConsoleColor);
begin
  CreateLogger;
  mLogger.Log(aMsg, aArgs, aFColor, aBColor);
end;

class procedure TLogger.Free;
begin
  FreeLogger;
end;

{ TMLogger }
procedure TMLogger.LogToFile;
begin
  if FLogFilename.IsEmpty then Exit;
  if not FLogToFile then Exit;
  FLog.SaveToFile(FLogFilename);
end;

procedure TMLogger.LogToMail;
var
  LCriticalCount: Integer;
  LExceptionCount: Integer;
  LLine: string;
begin
  if FMail = nil then Exit;
  if not FLogToMail then Exit;
  if FMailLog.Count = 0 then Exit;
  LCriticalCount := 0;
  LExceptionCount := 0;
  for LLine in FMailLog do
  begin
     if ContainsText(LLine, '[Critical') then
      Inc(LCriticalCount);
     if ContainsText(LLine, '[Exception') then
      Inc(LExceptionCount);
  end;

  if (LCriticalCount = 0) and (LExceptionCount = 0) then Exit;

  Log(etWarning, 'Mailing %d critical and %d exception logging errors...', [LCriticalCount, LExceptionCount]);
  FMail.SendEmail(FMailFrom, 'Vivace Game Toolkit', FMailSubject, FMailTo, '', '', '', FMailLog.Text);
end;

function TMLogger.StripHTML(aText: string): string;
var
  LStartTag: string;
  LEndTag: string;
begin
  Result := aText;
  for LSTartTag in FHtmlTags do
  begin
    LEndTag := LStartTag.Replace('<', '</');
    Result := Result.Replace(LStartTag, '', [rfReplaceAll, rfIgnoreCase]);
    Result := Result.Replace(LEndTag, '', [rfReplaceAll, rfIgnoreCase]);
  end;
end;

procedure TMLogger.LogHeader;

  procedure L(const aMsg: string; const aArgs: array of const);
  var
    LLine: string;
  begin
    LLine := Format(aMsg, aArgs);
    FMailLog.Add(LLine);
    Log(aMsg, aArgs);
  end;

begin
  FLog.Clear;
  FMailLog.Clear;
  SetLogToConsole(False);
  L('Vivace™ Game Toolkit v%s<br/>', [VIVACE_VERSION]);
  L(FillStr('-',70)+'<br/>', []);
  L('Application : %s %s<br/>',[TPath.GetFileNameWithoutExtension(ParamStr(0)),GetAppVersionFullStr]);
  L('Path        : %s<br/>',[ExtractFilePath(ParamStr(0))]);
  L('CPU cores   : %d<br/>',[CPUCount]);
  L('OS version  : %s<br/>',[TOSVersion.ToString]);
  L('Host        : %s<br/>',[TOS.GetComputerName]);
  L('Username    : %s<br/>',[Trim(TOS.GetLoggedUserName)]);
  L('Started     : %s<br/>',[TOS.GetNow]);
  if System.IsConsole then
    L('AppType     : Console<br/>', [])
  else
    L('AppType     : GUI<br/>', []);

  if IsDebug then
    L('Debug mode  : On<br/>', [])
  else
    L('Debug mode  : Off<br/>', []);
  L(FillStr('-',70)+'<br/>', []);
  SetLogToConsole(True);
end;

constructor TMLogger.Create;
begin
  inherited;
  FFormatSettings.DateSeparator := '/';
  FFormatSettings.TimeSeparator := ':';
  FFormatSettings.ShortDateFormat := 'DD-MM-YYY HH:NN:SS';
  FFormatSettings.ShortTimeFormat := 'HH:NN:SS';

  FLogFilename := TPath.ChangeExtension(ParamStr(0), cLogExt);
  FLogToConsole := True;
  FLogToFile := True;
  FLogToMail := False;

  FLog := TStringList.Create;
  FLog.DefaultEncoding := TEncoding.UTF8;

  FMailLog := TStringList.Create;
  FMailLog.DefaultEncoding := TEncoding.UTF8;
  FMail := nil;

  // init html tags
  FHtmlTags := TStringList.Create;
  FHtmlTags.Sorted := True;
  FHtmlTags.CaseSensitive := False;
  FHtmlTags.Add('<a>');
  FHtmlTags.Add('<abbr>');
  FHtmlTags.Add('<address>');
  FHtmlTags.Add('<applet>');
  FHtmlTags.Add('<area>');
  FHtmlTags.Add('<article>');
  FHtmlTags.Add('<aside>');
  FHtmlTags.Add('<audio>');
  FHtmlTags.Add('<b>');
  FHtmlTags.Add('<base>');
  FHtmlTags.Add('<basefont>');
  FHtmlTags.Add('<bdi>');
  FHtmlTags.Add('<bdo>');
  FHtmlTags.Add('<big>');
  FHtmlTags.Add('<blockquote>');
  FHtmlTags.Add('<body>');
  FHtmlTags.Add('<br>');
  FHtmlTags.Add('<br/>');
  FHtmlTags.Add('<button>');
  FHtmlTags.Add('<canvas>');
  FHtmlTags.Add('<caption>');
  FHtmlTags.Add('<center>');
  FHtmlTags.Add('<cite>');
  FHtmlTags.Add('<code>');
  FHtmlTags.Add('<col>');
  FHtmlTags.Add('<colgroup>');
  FHtmlTags.Add('<data>');
  FHtmlTags.Add('<datalist>');
  FHtmlTags.Add('<dd>');
  FHtmlTags.Add('<del>');
  FHtmlTags.Add('<details>');
  FHtmlTags.Add('<dfn>');
  FHtmlTags.Add('<dialog>');
  FHtmlTags.Add('<dir>');
  FHtmlTags.Add('<div>');
  FHtmlTags.Add('<dl>');
  FHtmlTags.Add('<dt>');
  FHtmlTags.Add('<em>');
  FHtmlTags.Add('<embed>');
  FHtmlTags.Add('<fieldset>');
  FHtmlTags.Add('<figcaption>');
  FHtmlTags.Add('<figure>');
  FHtmlTags.Add('<font>');
  FHtmlTags.Add('<footer>');
  FHtmlTags.Add('<form>');
  FHtmlTags.Add('<frame>');
  FHtmlTags.Add('<frameset>');
  FHtmlTags.Add('<h1>');
  FHtmlTags.Add('<h2>');
  FHtmlTags.Add('<h3>');
  FHtmlTags.Add('<h4>');
  FHtmlTags.Add('<h5>');
  FHtmlTags.Add('<h6>');
  FHtmlTags.Add('<head>');
  FHtmlTags.Add('<header>');
  FHtmlTags.Add('<hr>');
  FHtmlTags.Add('<html>');
  FHtmlTags.Add('<i>');
  FHtmlTags.Add('<iframe>');
  FHtmlTags.Add('<img>');
  FHtmlTags.Add('<input>');
  FHtmlTags.Add('<ins>');
  FHtmlTags.Add('<kbd>');
  FHtmlTags.Add('<label>');
  FHtmlTags.Add('<legend>');
  FHtmlTags.Add('<li>');
  FHtmlTags.Add('<link>');
  FHtmlTags.Add('<main>');
  FHtmlTags.Add('<map>');
  FHtmlTags.Add('<mark>');
  FHtmlTags.Add('<meta>');
  FHtmlTags.Add('<meter>');
  FHtmlTags.Add('<nav>');
  FHtmlTags.Add('<noframes>');
  FHtmlTags.Add('<noscript>');
  FHtmlTags.Add('<object>');
  FHtmlTags.Add('<ol>');
  FHtmlTags.Add('<optgroup>');
  FHtmlTags.Add('<option>');
  FHtmlTags.Add('<output>');
  FHtmlTags.Add('<p>');
  FHtmlTags.Add('<param>');
  FHtmlTags.Add('<picture>');
  FHtmlTags.Add('<pre>');
  FHtmlTags.Add('<progress>');
  FHtmlTags.Add('<q>');
  FHtmlTags.Add('<rp>');
  FHtmlTags.Add('<rt>');
  FHtmlTags.Add('<ruby>');
  FHtmlTags.Add('<s>');
  FHtmlTags.Add('<samp>');
  FHtmlTags.Add('<script>');
  FHtmlTags.Add('<section>');
  FHtmlTags.Add('<select>');
  FHtmlTags.Add('<small>');
  FHtmlTags.Add('<source>');
  FHtmlTags.Add('<span>');
  FHtmlTags.Add('<strike>');
  FHtmlTags.Add('<strong>');
  FHtmlTags.Add('<style>');
  FHtmlTags.Add('<sub>');
  FHtmlTags.Add('<summary>');
  FHtmlTags.Add('<sup>');
  FHtmlTags.Add('<svg>');
  FHtmlTags.Add('<table>');
  FHtmlTags.Add('<tbody>');
  FHtmlTags.Add('<td>');
  FHtmlTags.Add('<template>');
  FHtmlTags.Add('<textarea>');
  FHtmlTags.Add('<tfoot>');
  FHtmlTags.Add('<th>');
  FHtmlTags.Add('<thead>');
  FHtmlTags.Add('<time>');
  FHtmlTags.Add('<title>');
  FHtmlTags.Add('<tr>');
  FHtmlTags.Add('<track>');
  FHtmlTags.Add('<tt>');
  FHtmlTags.Add('<u>');
  FHtmlTags.Add('<ul>');
  FHtmlTags.Add('<var>');
  FHtmlTags.Add('<video>');
  FHtmlTags.Add('<wbr>');
  FHtmlTags.Sort;
end;

destructor TMLogger.Destroy;
begin
  LogToFile;
  LogToMail;
  FreeAndNil(FHtmlTags);
  FreeAndNil(FMail);
  FreeAndNil(FMailLog);
  FreeAndNil(FLog);
  inherited;
end;

procedure TMLogger.SetLogFilename(aFilename: string);
begin
  FLogFilename := aFilename;
end;

function TMLogger.GetLogFilename: string;
begin
  Result := FLogFilename;
end;

procedure TMLogger.SetLogToConsole(aEnable: Boolean);
begin
  FLogToConsole := aEnable;
end;

function TMLogger.GetLogToConsole: Boolean;
begin
  Result := FLogToConsole;
end;

procedure TMLogger.SetLogToFile(aEnable: Boolean);
begin
  FLogToFile := aEnable;
end;

procedure TMLogger.SetLogToMail(aEnable: Boolean);
begin
  FLogToMail := aEnable;
end;

procedure TMLogger.SetupMail(aServer: string; aPort: Integer; aUserName, aPassword, aFromAddress, aToAddresses, aSubject: string);
begin
  if FMail <> nil then Exit;
  FMail :=  TSMTP.Create(aServer, aPort, True, aUserName, aPassword);
  FMailFrom := aFromAddress;
  FMailTo := aToAddresses;
  FMailSubject := aSubject
end;

function TMLogger.GetLogToFile: Boolean;
begin
  Result := FLogToFile;
end;

function TMLogger.GetLogToMail: Boolean;
begin
  Result := FLogToMail;
end;

procedure TMLogger.Log(aType: TLogEventType; const aMsg: string; const aArgs: array of const);
var
  LMsg: string;
  LStripMsg: string;
begin
  // add log message
  LMsg := Format('[%s]', [TEnumConverter.EnumToString(aType)]);
  LMsg := LMsg.Replace('[et', '[');
  LMsg := LMsg.PadRight(11);
  LMsg := Format('%s %s', [DateTimeToStr(Now, FFormatSettings), LMsg]);
  LMsg := LMsg + ' ' + Format(aMsg, aArgs);
  LStripMsg := StripHTML(LMsg);
  FLog.Add(LStripMsg);

  // log msg to console
  if FLogToConsole then
  begin
    TConsole.WriteLn(LStripMsg, [], aType);
  end;

  // log to mail log
  if (aType = etCritical) or (aType = etException) then
  begin
    FMailLog.Add(LMsg+'<br/>');
  end;

end;

procedure TMLogger.Log(const aMsg: string; const aArgs: array of const; aFColor: TConsoleColor=ccDefault; aBColor: TConsoleColor=ccDefault);
var
  LMsg: string;
begin
  // add log message
  LMsg := Format('%s %s', [DateTimeToStr(Now, FFormatSettings), LMsg]);
  LMsg := LMsg + Format(aMsg, aArgs);
  LMsg := StripHTML(LMsg);
  FLog.Add(LMsg);

  // log msg to console
  if FLogToConsole then
  begin
    TConsole.WriteLn(LMsg, [], aFColor, aBColor);
  end;
end;

initialization
begin
  CreateLogger;
end;

finalization
begin
  FreeLogger;
  UnloadCLibs;
  FreeLogger;
end;


end.
