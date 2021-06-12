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

unit Vivace.SMTP;

{$I Vivace.Defines.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  IdGlobal,
  IdSMTP,
  IdMessage,
  IdReplySMTP,
  IdSSLOpenSSL,
  IdText,
  IdAttachment,
  IdAttachmentFile,
  IdExplicitTLSClientServerBase,
  IdHTTP;

type

  { TMailMessage }
  TMailMessage = class
  private
    FSenderName: string;
    FFrom: string;
    FRecipient: string;
    FSubject: string;
    FBody: string;
    FCC: string;
    FBCC: string;
    FReplyTo: string;
    FBodyFromFile: Boolean;
    FAttachments: TStringList;
    procedure SetBody(aValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    property SenderName: string read FSenderName write FSenderName;
    property From: string read FFrom write FFrom;
    property Recipient: string read FRecipient write FRecipient;
    property Subject: string read FSubject write FSubject;
    property Body: string read FBody write SetBody;
    property CC: string read FCC write FCC;
    property BCC : string read FBCC write FBCC;
    property ReplyTo : string read FReplyTo write FReplyTo;
    property Attachments: TStringList read FAttachments write FAttachments;
    procedure AddBodyFromFile(const aFilename: string);
  end;

  { TSMTP }
  TSMTP = class(TIdSMTP)
  private
    FServerAuth: Boolean;
    FUseSSL: Boolean;
    FMail: TMailMessage;
  public
    constructor Create; overload;
    constructor Create(const aHost: string; aPort: Integer; aUseSSL: Boolean=False; const aUserName: string=''; const aPassword: string=''); overload;
    destructor Destroy; override;
    property ServerAuth: Boolean read FServerAuth write FServerAuth;
    property UseSSL: Boolean read FUseSSL write FUseSSL;
    property Mail: TMailMessage read FMail write FMail;
    function SendMail: Boolean; overload;
    function SendMail(aMail: TMailMessage) : Boolean; overload;
    function SendEmail(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string): Boolean; overload;
    function SendEmail(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string; const aAttachments: TStringList): Boolean; overload;
  end;

implementation

uses
  Vivace.SSLLibs;

{ TMailMessage }
constructor TMailMessage.Create;
begin
  FCC := '';
  FBCC := '';
  FBody := '';
  FAttachments := TStringList.Create;
end;

destructor TMailMessage.Destroy;
begin
  if Assigned(FAttachments) then FAttachments.Free;
  inherited;
end;

procedure TMailMessage.AddBodyFromFile(const aFilename: string);
begin
  FBodyFromFile := True;
  FBody := aFilename;
end;

procedure TMailMessage.SetBody(aValue: string);
begin
  FBodyFromFile := False;
  FBody := aValue;
end;

{ TSMTP }
constructor TSMTP.Create;
begin
  inherited Create;
  FMail := TMailMessage.Create;
  Port := 25;
  UseTLS := TIdUseTLS.utNoTLSSupport;
  FUseSSL := False;
end;

constructor TSMTP.Create(const aHost: string; aPort: Integer; aUseSSL: Boolean; const aUserName: string; const aPassword: string);
begin
  Create;
  Host := aHost;
  Port := aPort;
  FUseSSL := aUseSSL;
  UserName := aUserName;
  Password := aPassword;
end;

destructor TSMTP.Destroy;
begin
  if Assigned(FMail) then FMail.Free;
  inherited;
end;

function TSMTP.SendEmail(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string): Boolean;
begin
  Result := SendEmail(aFromEmail, aFromName,aSubject,aTo,aCC,aBC,aReplyTo,aBody, nil);
end;

function TSMTP.SendEmail(const aFromEmail, aFromName, aSubject, aTo, aCC, aBC, aReplyTo, aBody: string; const aAttachments: TStringList): Boolean;
var
  LMail : TMailMessage;
begin
  if aFromEmail.IsEmpty then
    raise Exception.Create('Sender Email not specified!');
  if aFromName.IsEmpty then
    raise Exception.Create('Email sender not specified!');
  if aTo.IsEmpty then
    raise Exception.Create('Email destination not specified!');
  FMail.From := aFromEmail;
  FMail.SenderName := aFromName;
  LMail := TMailMessage.Create;
  try
    LMail.From := aFromEmail;
    LMail.FSenderName := aFromName;
    LMail.Subject := aSubject;
    LMail.Body := aBody;
    LMail.Recipient := aTo;
    LMail.CC := aCC;
    LMail.BCC := aBC;
    LMail.ReplyTo := aReplyTo;
    if aAttachments <> nil then LMail.Attachments := aAttachments;
    Result := Self.SendMail(LMail);
  finally
    LMail.Free;
  end;
end;

function TSMTP.SendMail: Boolean;
begin
  Result := SendMail(FMail);
end;

function TSMTP.SendMail(aMail: TMailMessage): Boolean;
var
  LMsg: TIdMessage;
  LSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  LEmail: string;
  LFilename: string;
  LMailBody: TIdText;
  LMailAttach: TIdAttachmentFile;
begin
  Result := False;
  LMailBody := nil;
  LMailAttach := nil;
  LSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    LMsg := TIdMessage.Create(nil);
    try
      //create mail msg
      LMailAttach := nil;
      LMailBody := nil;
      LMsg.From.Address := aMail.From;
      if aMail.SenderName <> '' then LMsg.From.Name := aMail.SenderName;
      LMsg.Subject := aMail.Subject;
      for LEmail in aMail.Recipient.Split([',',';']) do LMsg.Recipients.Add.Address := LEmail;
      for LEmail in aMail.CC.Split([',',';']) do LMsg.CCList.Add.Address := LEmail;
      for LEmail in aMail.BCC.Split([',',';']) do LMsg.BCCList.Add.Address := LEmail;
      for LEmail in aMail.ReplyTo.Split([',',';']) do LMsg.ReplyTo.Add.Address := LEmail;
      if aMail.FBodyFromFile then
      begin
        LMsg.Body.LoadFromFile(aMail.Body);
      end
      else
      begin
        LMailBody := TIdText.Create(LMsg.MessageParts);
        LMailBody.ContentType := 'text/html';
        LMailBody.CharSet:= 'utf-8';
        LMailBody.Body.Text := aMail.Body;
      end;

      //add attachements if exists
      if aMail.Attachments.Count > 0 then
      begin
        for LFilename in aMail.Attachments do
        begin
          LMailAttach := TIdAttachmentFile.Create(LMsg.MessageParts,LFilename);
        end;
      end;

      //configure smtp SSL
      try
        if FUseSSL then
        begin
          Self.IOHandler := LSSLHandler;
          LSSLHandler.MaxLineAction := maException;
          LSSLHandler.SSLOptions.Method := sslvTLSv1_2;
          LSSLHandler.SSLOptions.Mode := sslmUnassigned;
          LSSLHandler.SSLOptions.VerifyMode := [];
          LSSLHandler.SSLOptions.VerifyDepth := 0;
          if fPort = 465 then Self.UseTLS := utUseImplicitTLS
            else Self.UseTLS := utUseExplicitTLS;
        end;
        //server auth
        if ServerAuth then Self.AuthType := TIdSMTPAuthenticationType.satDefault;
        Self.Port := fPort;
      except
        on E : Exception do raise Exception.Create(Format('[%s] : %s',[Self.ClassName,e.Message]));
      end;

      //send email
      try
        Self.Connect;
        if Self.Connected then
        begin
          Self.Send(LMsg);
          Self.Disconnect(False);
          Result := True;
        end;
      except
        on E : Exception do raise Exception.Create(Format('[%s] : %s',[Self.ClassName,e.Message]));
      end;
    finally
      if Assigned(LMailAttach) then LMailAttach.Free;
      if Assigned(LMailBody) then LMailBody.Free;
      LMsg.Free;
    end;
  finally
    LSSLHandler.Free;
  end;
end;

end.
