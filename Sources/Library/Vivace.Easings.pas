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

unit Vivace.Easings;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common;

type
  { TEaseType }
  TEaseType = (etLinearTween, etInQuad, etOutQuad, etInOutQuad, etInCubic,
    etOutCubic, etInOutCubic, etInQuart, etOutQuart, etInOutQuart, etInQuint,
    etOutQuint, etInOutQuint, etInSine, etOutSine, etInOutSine, etInExpo,
    etOutExpo, etInOutExpo, etInCircle, etOutCircle, etInOutCircle);

  { TEase }
  TEase = class
    class function Value(aCurrentTime: Double; aStartValue: Double; aChangeInValue: Double; aDuration: Double; aEaseType: TEaseType): Double;
    class function Position(aStartPos: Double; aEndPos: Double; aCurrentPos: Double; aEaseType: TEaseType): Double;
  end;

implementation

uses
  System.Math,
  Vivace.Utils,
  Vivace.Engine;

{ TEase }
class function TEase.Value(aCurrentTime: Double; aStartValue: Double; aChangeInValue: Double; aDuration: Double; aEaseType: TEaseType): Double;
begin
  Result := 0;
  case aEaseType of
    etLinearTween:
      begin
        Result := aChangeInValue * aCurrentTime / aDuration + aStartValue;
      end;

    etInQuad:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutQuad:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := -aChangeInValue * aCurrentTime * (aCurrentTime-2) + aStartValue;
      end;

    etInOutQuad:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 1;
          Result := -aChangeInValue / 2 * (aCurrentTime * (aCurrentTime - 2) - 1) + aStartValue;
        end;
      end;

    etInCubic:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutCubic:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := aChangeInValue * ( aCurrentTime * aCurrentTime * aCurrentTime + 1) + aStartValue;
      end;

    etInOutCubic:
      begin
        aCurrentTime := aCurrentTime / (aDuration/2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := aChangeInValue / 2 * (aCurrentTime * aCurrentTime * aCurrentTime + 2) + aStartValue;
        end;
      end;

    etInQuart:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutQuart:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := -aChangeInValue * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime - 1) + aStartValue;
      end;

    etInOutQuart:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := -aChangeInValue / 2 * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime - 2) + aStartValue;
        end;
      end;

    etInQuint:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutQuint:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := aChangeInValue * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + 1) + aStartValue;
      end;

    etInOutQuint:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := aChangeInValue / 2 * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + 2) + aStartValue;
        end;
      end;

    etInSine:
      begin
        Result := -aChangeInValue * Cos(aCurrentTime / aDuration * (PI / 2)) + aChangeInValue + aStartValue;
      end;

    etOutSine:
      begin
        Result := aChangeInValue * Sin(aCurrentTime / aDuration * (PI / 2)) + aStartValue;
      end;

    etInOutSine:
      begin
        Result := -aChangeInValue / 2 * (Cos(PI * aCurrentTime / aDuration) - 1) + aStartValue;
      end;

    etInExpo:
      begin
        Result := aChangeInValue * Power(2, 10 * (aCurrentTime/aDuration - 1) ) + aStartValue;
      end;

    etOutExpo:
      begin
        Result := aChangeInValue * (-Power(2, -10 * aCurrentTime / aDuration ) + 1 ) + aStartValue;
      end;

    etInOutExpo:
      begin
        aCurrentTime := aCurrentTime / (aDuration/2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * Power(2, 10 * (aCurrentTime - 1) ) + aStartValue
        else
         begin
           aCurrentTime := aCurrentTime - 1;
           Result := aChangeInValue / 2 * (-Power(2, -10 * aCurrentTime) + 2 ) + aStartValue;
         end;
      end;

    etInCircle:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := -aChangeInValue * (Sqrt(1 - aCurrentTime * aCurrentTime) - 1) + aStartValue;
      end;

    etOutCircle:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := aChangeInValue * Sqrt(1 - aCurrentTime * aCurrentTime) + aStartValue;
      end;

    etInOutCircle:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := -aChangeInValue / 2 * (Sqrt(1 - aCurrentTime * aCurrentTime) - 1) + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := aChangeInValue / 2 * (Sqrt(1 - aCurrentTime * aCurrentTime) + 1) + aStartValue;
        end;
      end;
  end;
end;

class function TEase.Position(aStartPos: Double; aEndPos: Double; aCurrentPos: Double; aEaseType: TEaseType): Double;
var
  LT, LB, LC, LD: Double;
begin
  LC := aEndPos - aStartPos;
  LD := 100;
  LT := aCurrentPos;
  LB := aStartPos;
  Result := Value(LT, LB, LC, LD, aEaseType);
  if Result > 100 then
    Result := 100;
end;

end.
