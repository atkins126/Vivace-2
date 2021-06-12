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

unit Vivace.LuaJIT;

{$I Vivace.Defines.inc }

interface

const
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

var
  lua_gc: function(aState: Pointer; aWhat: Integer; aData: Integer): Integer; cdecl;
  lua_gettop: function(aState: Pointer): Integer; cdecl;
  lua_settop: procedure(aState: Pointer; aIndex: Integer); cdecl;
  lua_pushvalue: procedure(aState: Pointer; aIndex: Integer); cdecl;
  lua_call: procedure(aState: Pointer; aNumArgs, aNumResults: Integer); cdecl;
  lua_pcall: function(aState: Pointer; aNumArgs, aNumResults, errfunc: Integer): Integer; cdecl;
  lua_tonumber: function(aState: Pointer; aIndex: Integer): Double; cdecl;
  lua_tointeger: function(aState: Pointer; aIndex: Integer): Integer; cdecl;
  lua_toboolean: function(aState: Pointer; aIndex: Integer): LongBool; cdecl;
  lua_tolstring: function(aState: Pointer; aIndex: Integer; len: PNativeUInt): PAnsiChar; cdecl;
  lua_touserdata: function(aState: Pointer; aIndex: Integer): Pointer; cdecl;
  lua_topointer: function(aState: Pointer; aIndex: Integer): Pointer; cdecl;
  lua_close: procedure(aState: Pointer); cdecl;
  lua_type: function(aState: Pointer; aIndex: Integer): Integer; cdecl;
  lua_iscfunction: function(aState: Pointer; aIndex: Integer): LongBool; cdecl;
  lua_pushnil: procedure(aState: Pointer); cdecl;
  lua_pushnumber: procedure(aState: Pointer; n: Double); cdecl;
  lua_pushinteger: procedure(aState: Pointer; n: Integer); cdecl;
  lua_pushlstring: procedure(aState: Pointer; const aStr: PAnsiChar; aLen: NativeUInt); cdecl;
  lua_pushstring: procedure(aState: Pointer; const aStr: PAnsiChar); cdecl;
  lua_pushcclosure: procedure(aState: Pointer; aFuncn: TLuaCFunction; aCount: Integer); cdecl;
  lua_pushboolean: procedure(L: Pointer; b: LongBool); cdecl;
  lua_pushlightuserdata: procedure(aState: Pointer; aData: Pointer); cdecl;
  lua_createtable: procedure(aState: Pointer; narr, nrec: Integer); cdecl;
  lua_setfield: procedure(aState: Pointer; aIndex: Integer; const aName: PAnsiChar); cdecl;
  lua_getfield: procedure(aState: Pointer; aIndex: Integer; aName: PAnsiChar); cdecl;
  lua_dump: function(aState: Pointer; aWriter: TLuaWriter; aData: Pointer): Integer; cdecl;
  lua_rawset: procedure(aState: Pointer; aIndex: Integer); cdecl;
  lua_load: function(aState: Pointer; aReader: TLuaReader; aData: Pointer; aChunkName: PAnsiChar): Integer; cdecl;
  lua_rawgeti: procedure(aState: Pointer; index: integer; key: integer); cdecl;
  lua_rawseti: procedure(aState: Pointer; index: integer; key: integer); cdecl;
  luaL_error: function(aState: Pointer; const aFormat: PAnsiChar): Integer varargs; cdecl;
  luaL_newstate: function: Pointer; cdecl;
  luaL_openlibs: procedure(aState: Pointer); cdecl;
  luaL_loadfile: function(aState: Pointer; const filename: PAnsiChar): Integer; cdecl;
  luaL_loadstring: function(aState: Pointer; const aStr: PAnsiChar): Integer; cdecl;
  luaL_loadbuffer: function(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt; aName: PAnsiChar): Integer; cdecl;

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

{$R Vivace.LuaJIT.res}

uses
  System.SysUtils,
  Vivace.Utils,
  Vivace.MemoryModule;

var
  DLL: Pointer;

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

procedure LoadDLL;
begin
  DLL := LoadResDLL('LUAJIT');
  if DLL <> nil then
  begin
    @lua_gc := TMemoryModule.GetProcAddress(DLL, 'lua_gc');
    @lua_gettop := TMemoryModule.GetProcAddress(DLL, 'lua_gettop');
    @lua_settop := TMemoryModule.GetProcAddress(DLL, 'lua_settop');
    @lua_pushvalue := TMemoryModule.GetProcAddress(DLL, 'lua_pushvalue');
    @lua_call := TMemoryModule.GetProcAddress(DLL, 'lua_call');
    @lua_pcall := TMemoryModule.GetProcAddress(DLL, 'lua_pcall');
    @lua_tonumber := TMemoryModule.GetProcAddress(DLL, 'lua_tonumber');
    @lua_tointeger := TMemoryModule.GetProcAddress(DLL, 'lua_tointeger');
    @lua_toboolean := TMemoryModule.GetProcAddress(DLL, 'lua_toboolean');
    @lua_tolstring := TMemoryModule.GetProcAddress(DLL, 'lua_tolstring');
    @lua_touserdata := TMemoryModule.GetProcAddress(DLL, 'lua_touserdata');
    @lua_topointer := TMemoryModule.GetProcAddress(DLL, 'lua_topointer');
    @lua_close := TMemoryModule.GetProcAddress(DLL, 'lua_close');
    @lua_type := TMemoryModule.GetProcAddress(DLL, 'lua_type');
    @lua_iscfunction := TMemoryModule.GetProcAddress(DLL, 'lua_iscfunction');
    @lua_pushnil := TMemoryModule.GetProcAddress(DLL, 'lua_pushnil');
    @lua_pushnumber := TMemoryModule.GetProcAddress(DLL, 'lua_pushnumber');
    @lua_pushinteger := TMemoryModule.GetProcAddress(DLL, 'lua_pushinteger');
    @lua_pushlstring := TMemoryModule.GetProcAddress(DLL, 'lua_pushlstring');
    @lua_pushstring := TMemoryModule.GetProcAddress(DLL, 'lua_pushstring');
    @lua_pushcclosure := TMemoryModule.GetProcAddress(DLL, 'lua_pushcclosure');
    @lua_pushboolean := TMemoryModule.GetProcAddress(DLL, 'lua_pushboolean');
    @lua_pushlightuserdata := TMemoryModule.GetProcAddress(DLL, 'lua_pushlightuserdata');
    @lua_createtable := TMemoryModule.GetProcAddress(DLL, 'lua_createtable');
    @lua_setfield := TMemoryModule.GetProcAddress(DLL, 'lua_setfield');
    @lua_getfield := TMemoryModule.GetProcAddress(DLL, 'lua_getfield');
    @lua_dump := TMemoryModule.GetProcAddress(DLL, 'lua_dump');
    @lua_rawset := TMemoryModule.GetProcAddress(DLL, 'lua_rawset');
    @lua_load := TMemoryModule.GetProcAddress(DLL, 'lua_load');
    @lua_rawgeti := TMemoryModule.GetProcAddress(DLL, 'lua_rawgeti');
    @lua_rawseti := TMemoryModule.GetProcAddress(DLL, 'lua_rawseti');
    @luaL_error := TMemoryModule.GetProcAddress(DLL, 'luaL_error');
    @luaL_newstate := TMemoryModule.GetProcAddress(DLL, 'luaL_newstate');
    @luaL_openlibs := TMemoryModule.GetProcAddress(DLL, 'luaL_openlibs');
    @luaL_loadfile := TMemoryModule.GetProcAddress(DLL, 'luaL_loadfile');
    @luaL_loadstring := TMemoryModule.GetProcAddress(DLL, 'luaL_loadstring');
    @luaL_loadbuffer := TMemoryModule.GetProcAddress(DLL, 'luaL_loadbuffer');
  end;
end;

procedure UnloadDLL;
begin
  TMemoryModule.FreeLibrary(DLL);
end;

initialization
begin
  LoadDLL;
end;

finalization
begin
  UnloadDLL;
end;

end.
