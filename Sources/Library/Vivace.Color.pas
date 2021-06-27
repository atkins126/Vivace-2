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

unit Vivace.Color;

{$I Vivace.Defines.inc }

interface

uses
  System.SysUtils,
  Vivace.Base,
  Vivace.Common;

type

  { TColor }
  PColor = ^TColor;
  TColor = record
    Red: Single;
    Green: Single;
    Blue: Single;
    Alpha: Single;
    function Make(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TColor; overload;
    function Make(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): TColor; overload;
    function Make(const aName: string): TColor; overload;

    function Fade(aTo: TColor; aPos: Single): TColor;

    function Equal(aColor: TColor): Boolean;
  end;

{$REGION 'Common Colors'}
var
  ALICEBLUE: TColor;
  ANTIQUEWHITE: TColor;
  AQUA: TColor;
  AQUAMARINE: TColor;
  AZURE: TColor;
  BEIGE: TColor;
  BISQUE: TColor;
  BLACK: TColor;
  BLANCHEDALMOND: TColor;
  BLUE: TColor;
  BLUEVIOLET: TColor;
  BROWN: TColor;
  BURLYWOOD: TColor;
  CADETBLUE: TColor;
  CHARTREUSE: TColor;
  CHOCOLATE: TColor;
  CORAL: TColor;
  CORNFLOWERBLUE: TColor;
  CORNSILK: TColor;
  CRIMSON: TColor;
  CYAN: TColor;
  DARKBLUE: TColor;
  DARKCYAN: TColor;
  DARKGOLDENROD: TColor;
  DARKGRAY: TColor;
  DARKGREEN: TColor;
  DARKKHAKI: TColor;
  DARKMAGENTA: TColor;
  DARKOLIVEGREEN: TColor;
  DARKORANGE: TColor;
  DARKORCHID: TColor;
  DARKRED: TColor;
  DARKSALMON: TColor;
  DARKSEAGREEN: TColor;
  DARKSLATEBLUE: TColor;
  DARKSLATEGRAY: TColor;
  DARKTURQUOISE: TColor;
  DARKVIOLET: TColor;
  DEEPPINK: TColor;
  DEEPSKYBLUE: TColor;
  DIMGRAY: TColor;
  DODGERBLUE: TColor;
  FIREBRICK: TColor;
  FLORALWHITE: TColor;
  FORESTGREEN: TColor;
  FUCHSIA: TColor;
  GAINSBORO: TColor;
  GHOSTWHITE: TColor;
  GOLDENROD: TColor;
  GOLD: TColor;
  GRAY: TColor;
  GREEN: TColor;
  GREENYELLOW: TColor;
  HONEYDEW: TColor;
  HOTPINK: TColor;
  INDIANRED: TColor;
  INDIGO: TColor;
  IVORY: TColor;
  KHAKI: TColor;
  LAVENDERBLUSH: TColor;
  LAVENDER: TColor;
  LAWNGREEN: TColor;
  LEMONCHIFFON: TColor;
  LIGHTBLUE: TColor;
  LIGHTCORAL: TColor;
  LIGHTCYAN: TColor;
  LIGHTGOLDENRODYELLOW: TColor;
  LIGHTGREEN: TColor;
  LIGHTGREY: TColor;
  LIGHTPINK: TColor;
  LIGHTSALMON: TColor;
  LIGHTSEAGREEN: TColor;
  LIGHTSKYBLUE: TColor;
  LIGHTSLATEGRAY: TColor;
  LIGHTSTEELBLUE: TColor;
  LIGHTYELLOW: TColor;
  LIME: TColor;
  LIMEGREEN: TColor;
  LINEN: TColor;
  MAGENTA: TColor;
  MAROON: TColor;
  MEDIUMAQUAMARINE: TColor;
  MEDIUMBLUE: TColor;
  MEDIUMORCHID: TColor;
  MEDIUMPURPLE: TColor;
  MEDIUMSEAGREEN: TColor;
  MEDIUMSLATEBLUE: TColor;
  MEDIUMSPRINGGREEN: TColor;
  MEDIUMTURQUOISE: TColor;
  MEDIUMVIOLETRED: TColor;
  MIDNIGHTBLUE: TColor;
  MINTCREAM: TColor;
  MISTYROSE: TColor;
  MOCCASIN: TColor;
  AVAJOWHITE: TColor;
  NAVY: TColor;
  OLDLACE: TColor;
  OLIVE: TColor;
  OLIVEDRAB: TColor;
  ORANGE: TColor;
  ORANGERED: TColor;
  ORCHID: TColor;
  PALEGOLDENROD: TColor;
  PALEGREEN: TColor;
  PALETURQUOISE: TColor;
  PALEVIOLETRED: TColor;
  PAPAYAWHIP: TColor;
  PEACHPUFF: TColor;
  PERU: TColor;
  PINK: TColor;
  PLUM: TColor;
  POWDERBLUE: TColor;
  PURPLE: TColor;
  REBECCAPURPLE: TColor;
  RED: TColor;
  ROSYBROWN: TColor;
  ROYALBLUE: TColor;
  SADDLEBROWN: TColor;
  SALMON: TColor;
  SANDYBROWN: TColor;
  SEAGREEN: TColor;
  SEASHELL: TColor;
  SIENNA: TColor;
  SILVER: TColor;
  SKYBLUE: TColor;
  SLATEBLUE: TColor;
  SLATEGRAY: TColor;
  SNOW: TColor;
  SPRINGGREEN: TColor;
  STEELBLUE: TColor;
  TAN: TColor;
  TEAL: TColor;
  THISTLE: TColor;
  TOMATO: TColor;
  TURQUOISE: TColor;
  VIOLET: TColor;
  WHEAT: TColor;
  WHITE: TColor;
  WHITESMOKE: TColor;
  YELLOW: TColor;
  YELLOWGREEN: TColor;
  BLANK: TColor;
  WHITE2: TColor;
  RED2: TColor;
  COLORKEY: TColor;
  OVERLAY1: TColor;
  OVERLAY2: TColor;
  DIMWHITE: TColor;
{$ENDREGION}

implementation

uses
  Vivace.External.Allegro,
  Vivace.Utils,
  Vivace.Engine;


{ TColor }
function TColor.Make(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TColor;
var
  LColor: ALLEGRO_COLOR absolute Result;
begin
  LColor := al_map_rgba(aRed, aGreen, aBlue, aAlpha);
  Red := LColor.r;
  Green := LColor.g;
  Blue := LColor.b;
  Alpha := LColor.a;
end;

function TColor.Make(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): TColor;
var
  LColor: ALLEGRO_COLOR absolute Result;
begin
  LColor := al_map_rgba_f(aRed, aGreen, aBlue, aAlpha);
  Red := LColor.r;
  Green := LColor.g;
  Blue := LColor.b;
  Alpha := LColor.a;
end;

function TColor.Make(const aName: string): TColor;
var
  LColor: ALLEGRO_COLOR absolute Result;
begin
  LColor := al_color_name(PAnsiChar(AnsiString(aName)));
  Red := LColor.r;
  Green := LColor.g;
  Blue := LColor.b;
  Alpha := LColor.a;
end;

function TColor.Fade(aTo: TColor; aPos: Single): TColor;
var
  LColor: TColor;
begin
  // clip to ranage 0.0 - 1.0
  if aPos < 0 then
    aPos := 0
  else if aPos > 1.0 then
    aPos := 1.0;

  // fade colors
  LColor.Alpha := Alpha + ((aTo.Alpha - Alpha) * aPos);
  LColor.Blue := Blue + ((aTo.Blue - Blue) * aPos);
  LColor.Green := Green + ((aTo.Green - Green) * aPos);
  LColor.Red := Red + ((aTo.Red - Red) * aPos);
  Result := Make(LColor.Red, LColor.Green, LColor.Blue, LColor.Alpha);
  Red := LColor.Red;
  Green := LColor.Green;
  Blue := LColor.Blue;
  Alpha := LColor.Alpha;
end;

function TColor.Equal(aColor: TColor): Boolean;
begin
  if (Red = aColor.Red) and (Green = aColor.Green) and
    (Blue = aColor.Blue) and (Alpha = aColor.Alpha) then
    Result := True
  else
    Result := False;
end;

initialization
begin
  ALICEBLUE.Make('aliceblue');
  ANTIQUEWHITE.Make('antiquewhite');
  AQUA.Make('aqua');
  AQUAMARINE.Make('aquamarine');
  AZURE.Make('azure');
  BEIGE.Make('beige');
  BISQUE.Make('bisque');
  BLACK.Make('black');
  BLANCHEDALMOND.Make('blanchedalmond');
  BLUE.Make('blue');
  BLUEVIOLET.Make('blueviolet');
  BROWN.Make('brown');
  BURLYWOOD.Make('burlywood');
  CADETBLUE.Make('cadetblue');
  CHARTREUSE.Make('chartreuse');
  CHOCOLATE.Make('chocolate');
  CORAL.Make('coral');
  CORNFLOWERBLUE.Make('cornflowerblue');
  CORNSILK.Make('cornsilk');
  CRIMSON.Make('crimson');
  CYAN.Make('cyan');
  DARKBLUE.Make('darkblue');
  DARKCYAN.Make('darkcyan');
  DARKGOLDENROD.Make('darkgoldenrod');
  DARKGRAY.Make('darkgray');
  DARKGREEN.Make('darkgreen');
  DARKKHAKI.Make('darkkhaki');
  DARKMAGENTA.Make('darkmagenta');
  DARKOLIVEGREEN.Make('darkolivegreen');
  DARKORANGE.Make('darkorange');
  DARKORCHID.Make('darkorchid');
  DARKRED.Make('darkred');
  DARKSALMON.Make('darksalmon');
  DARKSEAGREEN.Make('darkseagreen');
  DARKSLATEBLUE.Make('darkslateblue');
  DARKSLATEGRAY.Make('darkslategray');
  DARKTURQUOISE.Make('darkturquoise');
  DARKVIOLET.Make('darkviolet');
  DEEPPINK.Make('deeppink');
  DEEPSKYBLUE.Make('deepskyblue');
  DIMGRAY.Make('dimgray');
  DODGERBLUE.Make('dodgerblue');
  FIREBRICK.Make('firebrick');
  FLORALWHITE.Make('floralwhite');
  FORESTGREEN.Make('forestgreen');
  FUCHSIA.Make('fuchsia');
  GAINSBORO.Make('gainsboro');
  GHOSTWHITE.Make('ghostwhite');
  GOLDENROD.Make('goldenrod');
  GOLD.Make('gold');
  GRAY.Make('gray');
  GREEN.Make('green');
  GREENYELLOW.Make('greenyellow');
  HONEYDEW.Make('honeydew');
  HOTPINK.Make('hotpink');
  INDIANRED.Make('indianred');
  INDIGO.Make('indigo');
  IVORY.Make('ivory');
  KHAKI.Make('khaki');
  LAVENDERBLUSH.Make('lavenderblush');
  LAVENDER.Make('lavender');
  LAWNGREEN.Make('lawngreen');
  LEMONCHIFFON.Make('lemonchiffon');
  LIGHTBLUE.Make('lightblue');
  LIGHTCORAL.Make('lightcoral');
  LIGHTCYAN.Make('lightcyan');
  LIGHTGOLDENRODYELLOW.Make('lightgoldenrodyellow');
  LIGHTGREEN.Make('lightgreen');
  LIGHTGREY.Make('lightgrey');
  LIGHTPINK.Make('lightpink');
  LIGHTSALMON.Make('lightsalmon');
  LIGHTSEAGREEN.Make('lightseagreen');
  LIGHTSKYBLUE.Make('lightskyblue');
  LIGHTSLATEGRAY.Make('lightslategray');
  LIGHTSTEELBLUE.Make('lightsteelblue');
  LIGHTYELLOW.Make('lightyellow');
  LIME.Make('lime');
  LIMEGREEN.Make('limegreen');
  LINEN.Make('linen');
  MAGENTA.Make('magenta');
  MAROON.Make('maroon');
  MEDIUMAQUAMARINE.Make('mediumaquamarine');
  MEDIUMBLUE.Make('mediumblue');
  MEDIUMORCHID.Make('mediumorchid');
  MEDIUMPURPLE.Make('mediumpurple');
  MEDIUMSEAGREEN.Make('mediumseagreen');
  MEDIUMSLATEBLUE.Make('mediumslateblue');
  MEDIUMSPRINGGREEN.Make('mediumspringgreen');
  MEDIUMTURQUOISE.Make('mediumturquoise');
  MEDIUMVIOLETRED.Make('mediumvioletred');
  MIDNIGHTBLUE.Make('midnightblue');
  MINTCREAM.Make('mintcream');
  MISTYROSE.Make('mistyrose');
  MOCCASIN.Make('moccasin');
  AVAJOWHITE.Make('avajowhite');
  NAVY.Make('navy');
  OLDLACE.Make('oldlace');
  OLIVE.Make('olive');
  OLIVEDRAB.Make('olivedrab');
  ORANGE.Make('orange');
  ORANGERED.Make('orangered');
  ORCHID.Make('orchid');
  PALEGOLDENROD.Make('palegoldenrod');
  PALEGREEN.Make('palegreen');
  PALETURQUOISE.Make('paleturquoise');
  PALEVIOLETRED.Make('palevioletred');
  PAPAYAWHIP.Make('papayawhip');
  PEACHPUFF.Make('peachpuff');
  PERU.Make('peru');
  PINK.Make('pink');
  PLUM.Make('plum');
  POWDERBLUE.Make('powderblue');
  PURPLE.Make('purple');
  REBECCAPURPLE.Make('rebeccapurple');
  RED.Make('red');
  ROSYBROWN.Make('rosybrown');
  ROYALBLUE.Make('royalblue');
  SADDLEBROWN.Make('saddlebrown');
  SALMON.Make('salmon');
  SANDYBROWN.Make('sandybrown');
  SEAGREEN.Make('seagreen');
  SEASHELL.Make('seashell');
  SIENNA.Make('sienna');
  SILVER.Make('silver');
  SKYBLUE.Make('skyblue');
  SLATEBLUE.Make('slateblue');
  SLATEGRAY.Make('slategray');
  SNOW.Make('snow');
  SPRINGGREEN.Make('springgreen');
  STEELBLUE.Make('steelblue');
  TAN.Make('tan');
  TEAL.Make('teal');
  THISTLE.Make('thistle');
  TOMATO.Make('tomato');
  TURQUOISE.Make('turquoise');
  VIOLET.Make('violet');
  WHEAT.Make('wheat');
  WHITE.Make('white');
  WHITESMOKE.Make('whitesmoke');
  YELLOW.Make('yellow');
  YELLOWGREEN.Make('yellowgreen');
  BLANK.Make(0, 0, 0, 0);
  WHITE2.Make(245, 245, 245, 255);
  RED2.Make(126, 50, 63, 255);
  COLORKEY.Make(255, 000, 255, 255);
  OVERLAY1.Make(000, 032, 041, 180);
  OVERLAY2.Make(001, 027, 001, 255);
  DIMWHITE.Make(16, 16, 16, 16);
end;

finalization
begin
end;

end.
