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

unit Vivace.External.LuaJIT;

{$I Vivace.Defines.inc }

interface

uses
  Vivace.External.CLibs;

const
  cDllName = 'lua51.dll';

  // basic types
  LUA_TNONE = -1;
  LUA_TNIL = 0;
  LUA_TBOOLEAN = 1;
  LUA_TLIGHTUSERDATA = 2;
  LUA_TNUMBER = 3;
  LUA_TSTRING = 4;
  LUA_TTABLE = 5;
  LUA_TFUNCTION = 6;
  LUA_TUSERDATA = 7;
  LUA_TTHREAD = 8;

  // minimum Lua stack available to a C function
  LUA_MINSTACK = 20;

  // option for multiple returns in `lua_pcall' and `lua_call'
  LUA_MULTRET = -1;

  // pseudo-indices
  LUA_REGISTRYINDEX = -10000;
  LUA_ENVIRONINDEX = -10001;
  LUA_GLOBALSINDEX = -10002;

  // thread status;
  LUA_OK = 0;
  LUA_YIELD_ = 1;
  LUA_ERRRUN = 2;
  LUA_ERRSYNTAX = 3;
  LUA_ERRMEM = 4;
  LUA_ERRERR = 5;

  LUA_GCSTOP = 0;
  LUA_GCRESTART = 1;
  LUA_GCCOLLECT = 2;
  LUA_GCCOUNT = 3;
  LUA_GCCOUNTB = 4;
  LUA_GCSTEP = 5;
  LUA_GCSETPAUSE = 6;
  LUA_GCSETSTEPMUL = 7;

type
  { TLuaCFunction }
  TLuaCFunction = function(aState: Pointer): Integer; cdecl;

  { TLuaWriter }
  TLuaWriter = function(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt; aData: Pointer): Integer; cdecl;

  { TLuaReader }
  TLuaReader = function(aState: Pointer; aData: Pointer; aSize: PNativeUInt): PAnsiChar; cdecl;

function  lua_gc(aState: Pointer; aWhat: Integer; aData: Integer): Integer; cdecl; external cDllName delayed;
function  lua_gettop(aState: Pointer): Integer; cdecl; external cDllName delayed;
procedure lua_settop(aState: Pointer; aIndex: Integer); cdecl; external cDllName delayed;
procedure lua_pushvalue(aState: Pointer; aIndex: Integer); cdecl; external cDllName delayed;
procedure lua_call(aState: Pointer; aNumArgs, aNumResults: Integer); cdecl; external cDllName delayed;
function  lua_pcall(aState: Pointer; aNumArgs, aNumResults, errfunc: Integer): Integer; cdecl; external cDllName delayed;
function  lua_tonumber(aState: Pointer; aIndex: Integer): Double; cdecl; external cDllName delayed;
function  lua_tointeger(aState: Pointer; aIndex: Integer): Integer; cdecl; external cDllName delayed;
function  lua_toboolean(aState: Pointer; aIndex: Integer): LongBool; cdecl; external cDllName delayed;
function  lua_tolstring(aState: Pointer; aIndex: Integer; len: PNativeUInt): PAnsiChar; cdecl; external cDllName delayed;
function  lua_touserdata(aState: Pointer; aIndex: Integer): Pointer; cdecl; external cDllName delayed;
function  lua_topointer(aState: Pointer; aIndex: Integer): Pointer; cdecl; external cDllName delayed;
procedure lua_close(aState: Pointer); cdecl; external cDllName delayed;
function  lua_type(aState: Pointer; aIndex: Integer): Integer; cdecl; external cDllName delayed;
function  lua_iscfunction(aState: Pointer; aIndex: Integer): LongBool; cdecl; external cDllName delayed;
procedure lua_pushnil(aState: Pointer); cdecl; external cDllName delayed;
procedure lua_pushnumber(aState: Pointer; n: Double); cdecl; external cDllName delayed;
procedure lua_pushinteger(aState: Pointer; n: Integer); cdecl; external cDllName delayed;
procedure lua_pushlstring(aState: Pointer; const aStr: PAnsiChar; aLen: NativeUInt); cdecl; external cDllName delayed;
procedure lua_pushstring(aState: Pointer; const aStr: PAnsiChar); cdecl; external cDllName delayed;
procedure lua_pushcclosure(aState: Pointer; aFuncn: TLuaCFunction; aCount: Integer); cdecl; external cDllName delayed;
procedure lua_pushboolean(L: Pointer; b: LongBool); cdecl; external cDllName delayed;
procedure lua_pushlightuserdata(aState: Pointer; aData: Pointer); cdecl; external cDllName delayed;
procedure lua_createtable(aState: Pointer; narr, nrec: Integer); cdecl; external cDllName delayed;
procedure lua_setfield(aState: Pointer; aIndex: Integer; const aName: PAnsiChar); cdecl; external cDllName delayed;
procedure lua_getfield(aState: Pointer; aIndex: Integer; aName: PAnsiChar); cdecl; external cDllName delayed;
function  lua_dump(aState: Pointer; aWriter: TLuaWriter; aData: Pointer): Integer; cdecl; external cDllName delayed;
procedure lua_rawset(aState: Pointer; aIndex: Integer); cdecl; external cDllName delayed;
function  lua_load(aState: Pointer; aReader: TLuaReader; aData: Pointer; aChunkName: PAnsiChar): Integer; cdecl; external cDllName delayed;
procedure lua_rawgeti(aState: Pointer; index: integer; key: integer); cdecl; external cDllName delayed;
procedure lua_rawseti(aState: Pointer; index: integer; key: integer); cdecl; external cDllName delayed;
function  luaL_error(aState: Pointer; const aFormat: PAnsiChar): Integer; varargs; cdecl; external cDllName delayed;
function  luaL_newstate: Pointer; cdecl; external cDllName delayed;
procedure luaL_openlibs(aState: Pointer); cdecl; external cDllName delayed;
function  luaL_loadfile(aState: Pointer; const filename: PAnsiChar): Integer; cdecl; external cDllName delayed;
function  luaL_loadstring(aState: Pointer; const aStr: PAnsiChar): Integer; cdecl; external cDllName delayed;
function  luaL_loadbuffer(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt; aName: PAnsiChar): Integer; cdecl; external cDllName delayed;

// macros
function  lua_isfunction(aState: Pointer; n: Integer): Boolean; inline;
function  lua_isvariable(aState: Pointer; n: Integer): Boolean; inline;
procedure lua_newtable(aState: Pointer); inline;
procedure lua_pop(aState: Pointer; n: Integer); inline;
procedure lua_getglobal(aState: Pointer; aName: PAnsiChar); inline;
procedure lua_setglobal(aState: Pointer; aName: PAnsiChar); inline;
procedure lua_pushcfunction(aState: Pointer; aFunc: TLuaCFunction); inline;
procedure lua_register(aState: Pointer; aName: PAnsiChar; aFunc: TLuaCFunction); inline;
function  lua_isnil(aState: Pointer; n: Integer): Boolean; inline;
function  lua_tostring(aState: Pointer; idx: Integer): string; inline;
function  luaL_dofile(aState: Pointer; aFilename: PAnsiChar): Integer; inline;
function  luaL_dostring(aState: Pointer; aStr: PAnsiChar): Integer; inline;
function  luaL_dobuffer(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt; aName: PAnsiChar): Integer; inline;
function  lua_upvalueindex(i: Integer): Integer; inline;

implementation

// macros
function lua_isfunction(aState: Pointer; n: Integer): Boolean; inline;
begin
  Result := Boolean(lua_type(aState, n) = LUA_TFUNCTION);
end;

function lua_isvariable(aState: Pointer; n: Integer): Boolean; inline;
var
  aType: Integer;
begin
  aType := lua_type(aState, n);

  if (aType = LUA_TBOOLEAN) or (aType = LUA_TLIGHTUSERDATA) or (aType = LUA_TNUMBER) or (aType = LUA_TSTRING) then
    Result := True
  else
    Result := False;
end;

procedure lua_newtable(aState: Pointer); inline;
begin
  lua_createtable(aState, 0, 0);
end;

procedure lua_pop(aState: Pointer; n: Integer); inline;
begin
  lua_settop(aState, -n - 1);
end;

procedure lua_getglobal(aState: Pointer; aName: PAnsiChar); inline;
begin
  lua_getfield(aState, LUA_GLOBALSINDEX, aName);
end;

procedure lua_setglobal(aState: Pointer; aName: PAnsiChar); inline;
begin
  lua_setfield(aState, LUA_GLOBALSINDEX, aName);
end;

procedure lua_pushcfunction(aState: Pointer; aFunc: TLuaCFunction); inline;
begin
  lua_pushcclosure(aState, aFunc, 0);
end;

procedure lua_register(aState: Pointer; aName: PAnsiChar; aFunc: TLuaCFunction); inline;
begin
  lua_pushcfunction(aState, aFunc);
  lua_setglobal(aState, aName);
end;

function lua_isnil(aState: Pointer; n: Integer): Boolean; inline;
begin
  Result := Boolean(lua_type(aState, n) = LUA_TNIL);
end;

function lua_tostring(aState: Pointer; idx: Integer): string; inline;
begin
  Result := string(lua_tolstring(aState, idx, nil));
end;

function luaL_dofile(aState: Pointer; aFilename: PAnsiChar): Integer; inline;
Var
  Res: Integer;
begin
  Res := luaL_loadfile(aState, aFilename);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function luaL_dostring(aState: Pointer; aStr: PAnsiChar): Integer; inline;
Var
  Res: Integer;
begin
  Res := luaL_loadstring(aState, aStr);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function luaL_dobuffer(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
  aName: PAnsiChar): Integer; inline;
var
  Res: Integer;
begin
  Res := luaL_loadbuffer(aState, aBuffer, aSize, aName);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function lua_upvalueindex(i: Integer): Integer; inline;
begin
  Result := LUA_GLOBALSINDEX - i;
end;

end.
