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

unit Vivace.Styles;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  System.Classes,
  Vivace.Base,
  Vivace.Common;

type

  { TStyles }
  TStyles = class(TBaseObject)
  protected
    FList: TStringList;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetCount: Integer;
    function GetName(aIndex: Integer): string;
    procedure SetByName(aName: string);
    procedure SetByIndex(aIndex: Integer);
  end;

implementation

{$R Vivace.Styles.res}

uses
  VCL.Themes,
  VCL.Styles,
  Vivace.Utils,
  Vivace.Engine;

{ TStyles }
constructor TStyles.Create;
begin
  inherited;
  FList := TStringList.Create;
  FList.AddStrings(TStyleManager.StyleNames);
end;

destructor TStyles.Destroy;
begin
  inherited;
end;

function TStyles.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TStyles.GetName(aIndex: Integer): string;
begin
  Result := '';
  if (aIndex < 0) or (aIndex > GetCount-1) then Exit;
  Result := FList[aIndex];
end;

procedure TStyles.SetByName(aName: string);
begin
  if aName.IsEmpty then Exit;
  //TStyleManager.ActiveStyle.
  TStyleManager.TrySetStyle(aName, False);
end;

procedure TStyles.SetByIndex(aIndex: Integer);
begin
  SetByName(GetName(aIndex));
end;


end.
