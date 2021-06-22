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

unit Vivace.Lua;

interface

uses
  System.Generics.Defaults,
  System.SysUtils,
  System.Classes,
  System.Rtti,
  Vivace.Base,
  Vivace.Common;


type

  { TLuaType }
  TLuaType = (ltNone = -1, ltNil = 0, ltBoolean = 1, ltLightUserData = 2,
    ltNumber = 3, ltString = 4, ltTable = 5, ltFunction = 6, ltUserData = 7,
    ltThread = 8);

  { TLuaTable }
  TLuaTable = (LuaTable);

  { TLuaValueType }
  TLuaValueType = (vtInteger, vtDouble, vtString, vtTable, vtPointer,
    vtBoolean);

  { TLuaValue }
  TLuaValue = record
    AsType: TLuaValueType;
    class operator Implicit(const aValue: Integer): TLuaValue;
    class operator Implicit(aValue: Double): TLuaValue;
    class operator Implicit(aValue: PChar): TLuaValue;
    class operator Implicit(aValue: TLuaTable): TLuaValue;
    class operator Implicit(aValue: Pointer): TLuaValue;
    class operator Implicit(aValue: Boolean): TLuaValue;

    class operator Implicit(aValue: TLuaValue): Integer;
    class operator Implicit(aValue: TLuaValue): Double;
    class operator Implicit(aValue: TLuaValue): PChar;
    class operator Implicit(aValue: TLuaValue): Pointer;
    class operator Implicit(aValue: TLuaValue): Boolean;

    case Integer of
      0: (AsInteger: Integer);
      1: (AsNumber: Double);
      2: (AsString: PWideChar);
      3: (AsTable: TLuaTable);
      4: (AsPointer: Pointer);
      5: (AsBoolean: Boolean);
  end;

  { ILuaContext }
  ILuaContext = interface
    ['{6AEC306C-45BC-4C65-A0E1-044739DED1EB}']
    function  ArgCount: Integer;
    function  PushCount: Integer;
    procedure ClearStack;
    procedure PopStack(aCount: Integer);
    function  GetStackType(aIndex: Integer): TLuaType;
    function  GetValue(aType: TLuaValueType; aIndex: Integer): TLuaValue;
    procedure PushValue(aValue: TLuaValue);
    procedure SetTableFieldValue(const aName: string; aValue: TLuaValue; aIndex: Integer); overload;
    function  GetTableFieldValue(const aName: string; aType: TLuaValueType; aIndex: Integer): TLuaValue; overload;
    procedure SetTableIndexValue(const aName: string; aValue: TLuaValue; aIndex: Integer; aKey: Integer);
    function  GetTableIndexValue(const aName: string; aType: TLuaValueType; aIndex: Integer; aKey: Integer): TLuaValue;
  end;

  { TLuaFunction }
  TLuaFunction = procedure(aLua: ILuaContext) of object;

  { ILua }
  ILua = interface
    ['{671FAB20-00F2-4C81-96A6-6F675A37D00B}']
    procedure Reset;
    procedure LoadStream(aStream: TStream; aSize: NativeUInt = 0; aAutoRun: Boolean = True);
    procedure LoadFile(const aFilename: string; aAutoRun: Boolean = True);
    procedure LoadString(const aData: string; aAutoRun: Boolean = True);
    procedure LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean = True);
    procedure Run;
    function  RoutineExist(const aName: string): Boolean;
    function  Call(const aName: string; const aParams: array of TLuaValue): TLuaValue; overload;
    function  PrepCall(const aName: string): Boolean;
    function  Call(aParamCount: Integer): TLuaValue; overload;
    function  VariableExist(const aName: string): Boolean;
    procedure SetVariable(const aName: string; aValue: TLuaValue);
    function  GetVariable(const aName: string; aType: TLuaValueType): TLuaValue;
    procedure RegisterRoutine(const aName: string; aData: Pointer; aCode: Pointer); overload;
    procedure RegisterRoutine(const aName: string; aRoutine: TLuaFunction); overload;
    procedure RegisterRoutines(aClass: TClass); overload;
    procedure RegisterRoutines(aObject: TObject); overload;
    procedure RegisterRoutines(const aTables: string; aClass: TClass; const aTableName: string = ''); overload;
    procedure RegisterRoutines(const aTables: string; aObject: TObject; const aTableName: string = ''); overload;
  end;

  { Forwards }
  TLua = class;
  TLuaContext = class;

  { ELuaException }
  ELuaException = class(Exception);

  { ELuaRuntimeException }
  ELuaRuntimeException = class(Exception);

  { ELuaSyntaxError }
  ELuaSyntaxError = class(Exception);

  { TLuaContext }
  TLuaContext = class(TSingletonImplementation, ILuaContext)
  protected
    FLua: TLua;
    FPushCount: Integer;
    FPushFlag: Boolean;
    procedure Setup;
    procedure Check;
    procedure IncStackPushCount;
    procedure Cleanup;
    function PushTableForSet(aName: array of string; aIndex: Integer;
      var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
    function PushTableForGet(aName: array of string; aIndex: Integer;
      var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
  public
    constructor Create(aLua: TLua);
    destructor Destroy; override;
    function ArgCount: Integer;
    function PushCount: Integer;
    procedure ClearStack;
    procedure PopStack(aCount: Integer);
    function GetStackType(aIndex: Integer): TLuaType;
    function GetValue(aType: TLuaValueType; aIndex: Integer): TLuaValue; overload;
    procedure PushValue(aValue: TLuaValue); overload;
    procedure SetTableFieldValue(const aName: string; aValue: TLuaValue; aIndex: Integer); overload;
    function  GetTableFieldValue(const aName: string; aType: TLuaValueType; aIndex: Integer): TLuaValue; overload;
    procedure SetTableIndexValue(const aName: string; aValue: TLuaValue; aIndex: Integer; aKey: Integer);
    function  GetTableIndexValue(const aName: string; aType: TLuaValueType; aIndex: Integer; aKey: Integer): TLuaValue;
  end;


  { TLua }
  TLua = class(TSingletonImplementation, ILua)
  protected
    FState: Pointer;
    FContext: TLuaContext;
    FGCStep: Integer;
    procedure Open;
    procedure Close;
    procedure CheckLuaError(const aError: Integer);
    function  PushGlobalTableForSet(aName: array of string; var aIndex: Integer): Boolean;
    function  PushGlobalTableForGet(aName: array of string; var aIndex: Integer): Boolean;
    procedure PushTValue(aValue: TValue);
    function  CallFunction(const aParams: array of TValue): TValue;
    procedure SaveByteCode(aStream: TStream);
    procedure LoadByteCode(aStream: TStream; aName: string; aAutoRun: Boolean = True);
    procedure CompileToStream(aFilename: string; aStream: TStream; aCleanOutput: Boolean);
    procedure Bundle(aInFilename: string; aOutFilename: string);
    procedure PushLuaValue(aValue: TLuaValue);
    function  GetLuaValue(aIndex: Integer): TLuaValue;
    function  DoCall(const aParams: array of TLuaValue): TLuaValue; overload;
    function  DoCall(aParamCount: Integer): TLuaValue; overload;
    procedure CleanStack;
    property  State: Pointer read FState;
    property  Context: TLuaContext read FContext;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Reset;

    procedure LoadStream(aStream: TStream; aSize: NativeUInt = 0; aAutoRun: Boolean = True);
    procedure LoadFile(const aFilename: string; aAutoRun: Boolean = True);
    procedure LoadString(const aData: string; aAutoRun: Boolean = True);
    procedure LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean = True);

    function  Call(const aName: string; const aParams: array of TLuaValue): TLuaValue; overload;
    function  PrepCall(const aName: string): Boolean;
    function  Call(aParamCount: Integer): TLuaValue; overload;

    procedure Run;

    function  RoutineExist(const aName: string): Boolean;

    function  VariableExist(const aName: string): Boolean;
    procedure SetVariable(const aName: string; aValue: TLuaValue);
    function  GetVariable(const aName: string; aType: TLuaValueType): TLuaValue;

    procedure RegisterRoutine(const aName: string; aData: Pointer; aCode: Pointer); overload;
    procedure RegisterRoutine(const aName: string; aRoutine: TLuaFunction); overload;

    procedure RegisterRoutines(aClass: TClass); overload;
    procedure RegisterRoutines(aObject: TObject); overload;
    procedure RegisterRoutines(const aTables: string; aClass: TClass; const aTableName: string = ''); overload;
    procedure RegisterRoutines(const aTables: string; aObject: TObject; const aTableName: string = ''); overload;

    procedure SetGCStepSize(aStep: Integer);
    function  GetGCStepSize: Integer;
    function  GetGCMemoryUsed: Integer;
    procedure CollectGarbage;
  end;

implementation

uses
  System.Types,
  System.IOUtils,
  System.TypInfo,
  WinApi.Windows,
  Vivace.External.LuaJIT,
  Vivace.Engine;

const
  cLuaExt = 'lua';
  cLuacExt = 'luac';
  cLuaAutoSetup = 'AutoSetup';

const cLOADER_LUA : array[1..436] of Byte = (
$2D, $2D, $20, $55, $74, $69, $6C, $69, $74, $79, $20, $66, $75, $6E, $63, $74,
$69, $6F, $6E, $20, $66, $6F, $72, $20, $68, $61, $76, $69, $6E, $67, $20, $61,
$20, $77, $6F, $72, $6B, $69, $6E, $67, $20, $69, $6D, $70, $6F, $72, $74, $20,
$66, $75, $6E, $63, $74, $69, $6F, $6E, $0A, $2D, $2D, $20, $46, $65, $65, $6C,
$20, $66, $72, $65, $65, $20, $74, $6F, $20, $75, $73, $65, $20, $69, $74, $20,
$69, $6E, $20, $79, $6F, $75, $72, $20, $6F, $77, $6E, $20, $70, $72, $6F, $6A,
$65, $63, $74, $73, $0A, $28, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $29,
$0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20, $73, $63, $72, $69, $70,
$74, $5F, $63, $61, $63, $68, $65, $20, $3D, $20, $7B, $7D, $3B, $0A, $20, $20,
$20, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $69, $6D, $70, $6F, $72,
$74, $28, $6E, $61, $6D, $65, $29, $0A, $20, $20, $20, $20, $20, $20, $20, $20,
$69, $66, $20, $73, $63, $72, $69, $70, $74, $5F, $63, $61, $63, $68, $65, $5B,
$6E, $61, $6D, $65, $5D, $20, $3D, $3D, $20, $6E, $69, $6C, $20, $74, $68, $65,
$6E, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $73, $63,
$72, $69, $70, $74, $5F, $63, $61, $63, $68, $65, $5B, $6E, $61, $6D, $65, $5D,
$20, $3D, $20, $6C, $6F, $61, $64, $66, $69, $6C, $65, $28, $6E, $61, $6D, $65,
$29, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $65, $6E, $64, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $69,
$66, $20, $73, $63, $72, $69, $70, $74, $5F, $63, $61, $63, $68, $65, $5B, $6E,
$61, $6D, $65, $5D, $20, $7E, $3D, $20, $6E, $69, $6C, $20, $74, $68, $65, $6E,
$0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $72, $65, $74,
$75, $72, $6E, $20, $73, $63, $72, $69, $70, $74, $5F, $63, $61, $63, $68, $65,
$5B, $6E, $61, $6D, $65, $5D, $28, $29, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $65, $6E, $64, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $65, $72, $72,
$6F, $72, $28, $22, $46, $61, $69, $6C, $65, $64, $20, $74, $6F, $20, $6C, $6F,
$61, $64, $20, $73, $63, $72, $69, $70, $74, $20, $22, $20, $2E, $2E, $20, $6E,
$61, $6D, $65, $29, $0A, $20, $20, $20, $20, $65, $6E, $64, $0A, $65, $6E, $64,
$29, $28, $29, $0A
);

const cLUABUNDLE_LUA : array[1..3478] of Byte = (
$28, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $61, $72, $67, $73, $29, $0D,
$0A, $6C, $6F, $63, $61, $6C, $20, $6D, $6F, $64, $75, $6C, $65, $73, $20, $3D,
$20, $7B, $7D, $0D, $0A, $6D, $6F, $64, $75, $6C, $65, $73, $5B, $27, $61, $70,
$70, $2F, $62, $75, $6E, $64, $6C, $65, $5F, $6D, $61, $6E, $61, $67, $65, $72,
$2E, $6C, $75, $61, $27, $5D, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F,
$6E, $28, $2E, $2E, $2E, $29, $0D, $0A, $2D, $2D, $20, $43, $6C, $61, $73, $73,
$20, $66, $6F, $72, $20, $63, $6F, $6C, $6C, $65, $63, $74, $69, $6E, $67, $20,
$74, $68, $65, $20, $66, $69, $6C, $65, $27, $73, $20, $63, $6F, $6E, $74, $65,
$6E, $74, $20, $61, $6E, $64, $20, $62, $75, $69, $6C, $64, $69, $6E, $67, $20,
$61, $20, $62, $75, $6E, $64, $6C, $65, $20, $66, $69, $6C, $65, $0D, $0A, $6C,
$6F, $63, $61, $6C, $20, $73, $6F, $75, $72, $63, $65, $5F, $70, $61, $72, $73,
$65, $72, $20, $3D, $20, $69, $6D, $70, $6F, $72, $74, $28, $22, $61, $70, $70,
$2F, $73, $6F, $75, $72, $63, $65, $5F, $70, $61, $72, $73, $65, $72, $2E, $6C,
$75, $61, $22, $29, $0D, $0A, $0D, $0A, $72, $65, $74, $75, $72, $6E, $20, $66,
$75, $6E, $63, $74, $69, $6F, $6E, $28, $65, $6E, $74, $72, $79, $5F, $70, $6F,
$69, $6E, $74, $29, $0D, $0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20,
$73, $65, $6C, $66, $20, $3D, $20, $7B, $7D, $0D, $0A, $20, $20, $20, $20, $6C,
$6F, $63, $61, $6C, $20, $66, $69, $6C, $65, $73, $20, $3D, $20, $7B, $7D, $0D,
$0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $2D, $2D, $20, $53, $65,
$61, $72, $63, $68, $65, $73, $20, $74, $68, $65, $20, $67, $69, $76, $65, $6E,
$20, $66, $69, $6C, $65, $20, $72, $65, $63, $75, $72, $73, $69, $76, $65, $6C,
$79, $20, $66, $6F, $72, $20, $69, $6D, $70, $6F, $72, $74, $20, $66, $75, $6E,
$63, $74, $69, $6F, $6E, $20, $63, $61, $6C, $6C, $73, $0D, $0A, $20, $20, $20,
$20, $73, $65, $6C, $66, $2E, $70, $72, $6F, $63, $65, $73, $73, $5F, $66, $69,
$6C, $65, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $66, $69,
$6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $6C, $6F, $63, $61, $6C, $20, $70, $61, $72, $73, $65, $72, $20, $3D, $20,
$73, $6F, $75, $72, $63, $65, $5F, $70, $61, $72, $73, $65, $72, $28, $66, $69,
$6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $66, $69, $6C, $65, $73, $5B, $66, $69, $6C, $65, $6E, $61, $6D, $65, $5D,
$20, $3D, $20, $70, $61, $72, $73, $65, $72, $2E, $63, $6F, $6E, $74, $65, $6E,
$74, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $0D, $0A, $20, $20, $20,
$20, $20, $20, $20, $20, $66, $6F, $72, $20, $5F, $2C, $20, $66, $20, $69, $6E,
$20, $70, $61, $69, $72, $73, $28, $70, $61, $72, $73, $65, $72, $2E, $69, $6E,
$63, $6C, $75, $64, $65, $73, $29, $20, $64, $6F, $0D, $0A, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $73, $65, $6C, $66, $2E, $70, $72, $6F,
$63, $65, $73, $73, $5F, $66, $69, $6C, $65, $28, $66, $29, $0D, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $65,
$6E, $64, $0D, $0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $2D, $2D,
$20, $43, $72, $65, $61, $74, $65, $20, $61, $20, $62, $75, $6E, $64, $6C, $65,
$20, $66, $69, $6C, $65, $20, $77, $68, $69, $63, $68, $20, $63, $6F, $6E, $74,
$61, $69, $6E, $73, $20, $74, $68, $65, $20, $64, $65, $74, $65, $63, $74, $65,
$64, $20, $66, $69, $6C, $65, $73, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C,
$66, $2E, $62, $75, $69, $6C, $64, $5F, $62, $75, $6E, $64, $6C, $65, $20, $3D,
$20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $64, $65, $73, $74, $5F, $66,
$69, $6C, $65, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $6C, $6F,
$63, $61, $6C, $20, $66, $69, $6C, $65, $20, $3D, $20, $69, $6F, $2E, $6F, $70,
$65, $6E, $28, $64, $65, $73, $74, $5F, $66, $69, $6C, $65, $2C, $20, $22, $77,
$22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $0D, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65,
$28, $22, $28, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $61, $72, $67, $73,
$29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66,
$69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $6C, $6F, $63, $61, $6C,
$20, $6D, $6F, $64, $75, $6C, $65, $73, $20, $3D, $20, $7B, $7D, $5C, $6E, $22,
$29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $0D, $0A, $20, $20, $20,
$20, $20, $20, $20, $20, $2D, $2D, $20, $43, $72, $65, $61, $74, $65, $20, $61,
$20, $73, $6F, $72, $74, $65, $64, $20, $6C, $69, $73, $74, $20, $6F, $66, $20,
$6B, $65, $79, $73, $20, $73, $6F, $20, $74, $68, $65, $20, $6F, $75, $74, $70,
$75, $74, $20, $77, $69, $6C, $6C, $20, $62, $65, $20, $74, $68, $65, $20, $73,
$61, $6D, $65, $20, $77, $68, $65, $6E, $20, $74, $68, $65, $20, $69, $6E, $70,
$75, $74, $20, $64, $6F, $65, $73, $20, $6E, $6F, $74, $20, $63, $68, $61, $6E,
$67, $65, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $6C, $6F, $63, $61,
$6C, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $73, $20, $3D, $20, $7B, $7D,
$0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $6F, $72, $20, $66, $69,
$6C, $65, $6E, $61, $6D, $65, $2C, $20, $5F, $20, $69, $6E, $20, $70, $61, $69,
$72, $73, $28, $66, $69, $6C, $65, $73, $29, $20, $64, $6F, $0D, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $74, $61, $62, $6C, $65, $2E,
$69, $6E, $73, $65, $72, $74, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $73,
$2C, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20,
$20, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $20, $20,
$20, $20, $74, $61, $62, $6C, $65, $2E, $73, $6F, $72, $74, $28, $66, $69, $6C,
$65, $6E, $61, $6D, $65, $73, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $2D, $2D, $20, $41, $64,
$64, $20, $66, $69, $6C, $65, $73, $20, $61, $73, $20, $6D, $6F, $64, $75, $6C,
$65, $73, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $6F, $72, $20,
$5F, $2C, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $20, $69, $6E, $20, $70,
$61, $69, $72, $73, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $73, $29, $20,
$64, $6F, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $6D, $6F, $64, $75,
$6C, $65, $73, $5B, $27, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28,
$66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74,
$65, $28, $22, $27, $5D, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E,
$28, $2E, $2E, $2E, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74,
$65, $28, $66, $69, $6C, $65, $73, $5B, $66, $69, $6C, $65, $6E, $61, $6D, $65,
$5D, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $5C, $6E, $22, $29,
$0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69,
$6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $65, $6E, $64, $5C, $6E, $22,
$29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A,
$20, $20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69,
$74, $65, $28, $22, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $69, $6D, $70,
$6F, $72, $74, $28, $6E, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20,
$20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22,
$72, $65, $74, $75, $72, $6E, $20, $6D, $6F, $64, $75, $6C, $65, $73, $5B, $6E,
$5D, $28, $74, $61, $62, $6C, $65, $2E, $75, $6E, $70, $61, $63, $6B, $28, $61,
$72, $67, $73, $29, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20,
$20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $65,
$6E, $64, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20,
$0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77,
$72, $69, $74, $65, $28, $22, $6C, $6F, $63, $61, $6C, $20, $65, $6E, $74, $72,
$79, $20, $3D, $20, $69, $6D, $70, $6F, $72, $74, $28, $27, $22, $20, $2E, $2E,
$20, $65, $6E, $74, $72, $79, $5F, $70, $6F, $69, $6E, $74, $20, $2E, $2E, $20,
$22, $27, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A,
$77, $72, $69, $74, $65, $28, $22, $65, $6E, $64, $29, $28, $7B, $2E, $2E, $2E,
$7D, $29, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69,
$6C, $65, $3A, $66, $6C, $75, $73, $68, $28, $29, $0D, $0A, $20, $20, $20, $20,
$20, $20, $20, $20, $66, $69, $6C, $65, $3A, $63, $6C, $6F, $73, $65, $28, $29,
$0D, $0A, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $0D,
$0A, $20, $20, $20, $20, $72, $65, $74, $75, $72, $6E, $20, $73, $65, $6C, $66,
$0D, $0A, $65, $6E, $64, $0D, $0A, $65, $6E, $64, $0D, $0A, $6D, $6F, $64, $75,
$6C, $65, $73, $5B, $27, $61, $70, $70, $2F, $6D, $61, $69, $6E, $2E, $6C, $75,
$61, $27, $5D, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $2E,
$2E, $2E, $29, $0D, $0A, $2D, $2D, $20, $4D, $61, $69, $6E, $20, $66, $75, $6E,
$63, $74, $69, $6F, $6E, $20, $6F, $66, $20, $74, $68, $65, $20, $70, $72, $6F,
$67, $72, $61, $6D, $0D, $0A, $6C, $6F, $63, $61, $6C, $20, $62, $75, $6E, $64,
$6C, $65, $5F, $6D, $61, $6E, $61, $67, $65, $72, $20, $3D, $20, $69, $6D, $70,
$6F, $72, $74, $28, $22, $61, $70, $70, $2F, $62, $75, $6E, $64, $6C, $65, $5F,
$6D, $61, $6E, $61, $67, $65, $72, $2E, $6C, $75, $61, $22, $29, $0D, $0A, $0D,
$0A, $72, $65, $74, $75, $72, $6E, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E,
$28, $61, $72, $67, $73, $29, $0D, $0A, $20, $20, $20, $20, $69, $66, $20, $23,
$61, $72, $67, $73, $20, $3D, $3D, $20, $31, $20, $61, $6E, $64, $20, $61, $72,
$67, $73, $5B, $31, $5D, $20, $3D, $3D, $20, $22, $2D, $76, $22, $20, $74, $68,
$65, $6E, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $70, $72, $69, $6E,
$74, $28, $22, $6C, $75, $61, $62, $75, $6E, $64, $6C, $65, $20, $76, $30, $2E,
$30, $31, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $6F, $73,
$2E, $65, $78, $69, $74, $28, $29, $0D, $0A, $20, $20, $20, $20, $65, $6C, $73,
$65, $69, $66, $20, $23, $61, $72, $67, $73, $20, $7E, $3D, $20, $32, $20, $74,
$68, $65, $6E, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $70, $72, $69,
$6E, $74, $28, $22, $75, $73, $61, $67, $65, $3A, $20, $6C, $75, $61, $62, $75,
$6E, $64, $6C, $65, $20, $69, $6E, $20, $6F, $75, $74, $22, $29, $0D, $0A, $20,
$20, $20, $20, $20, $20, $20, $20, $6F, $73, $2E, $65, $78, $69, $74, $28, $29,
$0D, $0A, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $0D,
$0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20, $69, $6E, $66, $69, $6C,
$65, $20, $3D, $20, $61, $72, $67, $73, $5B, $31, $5D, $0D, $0A, $20, $20, $20,
$20, $6C, $6F, $63, $61, $6C, $20, $6F, $75, $74, $66, $69, $6C, $65, $20, $3D,
$20, $61, $72, $67, $73, $5B, $32, $5D, $0D, $0A, $20, $20, $20, $20, $6C, $6F,
$63, $61, $6C, $20, $62, $75, $6E, $64, $6C, $65, $20, $3D, $20, $62, $75, $6E,
$64, $6C, $65, $5F, $6D, $61, $6E, $61, $67, $65, $72, $28, $69, $6E, $66, $69,
$6C, $65, $29, $0D, $0A, $20, $20, $20, $20, $62, $75, $6E, $64, $6C, $65, $2E,
$70, $72, $6F, $63, $65, $73, $73, $5F, $66, $69, $6C, $65, $28, $69, $6E, $66,
$69, $6C, $65, $2C, $20, $62, $75, $6E, $64, $6C, $65, $29, $0D, $0A, $20, $20,
$20, $20, $0D, $0A, $20, $20, $20, $20, $62, $75, $6E, $64, $6C, $65, $2E, $62,
$75, $69, $6C, $64, $5F, $62, $75, $6E, $64, $6C, $65, $28, $6F, $75, $74, $66,
$69, $6C, $65, $29, $0D, $0A, $65, $6E, $64, $0D, $0A, $65, $6E, $64, $0D, $0A,
$6D, $6F, $64, $75, $6C, $65, $73, $5B, $27, $61, $70, $70, $2F, $73, $6F, $75,
$72, $63, $65, $5F, $70, $61, $72, $73, $65, $72, $2E, $6C, $75, $61, $27, $5D,
$20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $2E, $2E, $2E, $29,
$0D, $0A, $2D, $2D, $20, $43, $6C, $61, $73, $73, $20, $66, $6F, $72, $20, $65,
$78, $74, $72, $61, $63, $74, $69, $6E, $67, $20, $69, $6D, $70, $6F, $72, $74,
$20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $63, $61, $6C, $6C, $73, $20,
$66, $72, $6F, $6D, $20, $73, $6F, $75, $72, $63, $65, $20, $66, $69, $6C, $65,
$73, $0D, $0A, $72, $65, $74, $75, $72, $6E, $20, $66, $75, $6E, $63, $74, $69,
$6F, $6E, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20,
$20, $20, $6C, $6F, $63, $61, $6C, $20, $66, $69, $6C, $65, $20, $3D, $20, $69,
$6F, $2E, $6F, $70, $65, $6E, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $2C,
$20, $22, $72, $22, $29, $0D, $0A, $20, $20, $20, $20, $69, $66, $20, $66, $69,
$6C, $65, $20, $3D, $3D, $20, $6E, $69, $6C, $20, $74, $68, $65, $6E, $0D, $0A,
$20, $20, $20, $20, $20, $20, $20, $20, $65, $72, $72, $6F, $72, $28, $22, $46,
$69, $6C, $65, $20, $6E, $6F, $74, $20, $66, $6F, $75, $6E, $64, $3A, $20, $22,
$20, $2E, $2E, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20,
$20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $6C, $6F, $63, $61,
$6C, $20, $66, $69, $6C, $65, $5F, $63, $6F, $6E, $74, $65, $6E, $74, $20, $3D,
$20, $66, $69, $6C, $65, $3A, $72, $65, $61, $64, $28, $22, $2A, $61, $22, $29,
$0D, $0A, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $63, $6C, $6F, $73, $65,
$28, $29, $0D, $0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20, $69, $6E,
$63, $6C, $75, $64, $65, $64, $5F, $66, $69, $6C, $65, $73, $20, $3D, $20, $7B,
$7D, $0D, $0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $2D, $2D, $20,
$53, $65, $61, $72, $63, $68, $20, $66, $6F, $72, $20, $69, $6D, $70, $6F, $72,
$74, $28, $29, $20, $63, $61, $6C, $6C, $73, $20, $77, $69, $74, $68, $20, $64,
$6F, $62, $75, $6C, $65, $20, $71, $75, $6F, $74, $65, $73, $20, $28, $21, $29,
$0D, $0A, $20, $20, $20, $20, $66, $6F, $72, $20, $66, $20, $69, $6E, $20, $73,
$74, $72, $69, $6E, $67, $2E, $67, $6D, $61, $74, $63, $68, $28, $66, $69, $6C,
$65, $5F, $63, $6F, $6E, $74, $65, $6E, $74, $2C, $20, $27, $69, $6D, $70, $6F,
$72, $74, $25, $28, $5B, $22, $5C, $27, $5D, $28, $5B, $5E, $5C, $27, $22, $5D,
$2D, $29, $5B, $22, $5C, $27, $5D, $25, $29, $27, $29, $20, $64, $6F, $0D, $0A,
$20, $20, $20, $20, $20, $20, $20, $20, $74, $61, $62, $6C, $65, $2E, $69, $6E,
$73, $65, $72, $74, $28, $69, $6E, $63, $6C, $75, $64, $65, $64, $5F, $66, $69,
$6C, $65, $73, $2C, $20, $66, $29, $0D, $0A, $20, $20, $20, $20, $65, $6E, $64,
$0D, $0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66,
$20, $3D, $20, $7B, $7D, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66, $2E,
$66, $69, $6C, $65, $6E, $61, $6D, $65, $20, $3D, $20, $66, $69, $6C, $65, $6E,
$61, $6D, $65, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66, $2E, $63, $6F,
$6E, $74, $65, $6E, $74, $20, $3D, $20, $66, $69, $6C, $65, $5F, $63, $6F, $6E,
$74, $65, $6E, $74, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66, $2E, $69,
$6E, $63, $6C, $75, $64, $65, $73, $20, $3D, $20, $69, $6E, $63, $6C, $75, $64,
$65, $64, $5F, $66, $69, $6C, $65, $73, $0D, $0A, $20, $20, $20, $20, $72, $65,
$74, $75, $72, $6E, $20, $73, $65, $6C, $66, $0D, $0A, $65, $6E, $64, $0D, $0A,
$65, $6E, $64, $0D, $0A, $6D, $6F, $64, $75, $6C, $65, $73, $5B, $27, $6C, $75,
$61, $62, $75, $6E, $64, $6C, $65, $2E, $6C, $75, $61, $27, $5D, $20, $3D, $20,
$66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $2E, $2E, $2E, $29, $0D, $0A, $2D,
$2D, $20, $45, $6E, $74, $72, $79, $20, $70, $6F, $69, $6E, $74, $20, $6F, $66,
$20, $74, $68, $65, $20, $70, $72, $6F, $67, $72, $61, $6D, $2E, $0D, $0A, $2D,
$2D, $20, $4F, $6E, $6C, $79, $20, $62, $61, $73, $69, $63, $20, $73, $74, $75,
$66, $66, $20, $69, $73, $20, $73, $65, $74, $20, $75, $70, $20, $68, $65, $72,
$65, $2C, $20, $74, $68, $65, $20, $61, $63, $74, $75, $61, $6C, $20, $70, $72,
$6F, $67, $72, $61, $6D, $20, $69, $73, $20, $69, $6E, $20, $61, $70, $70, $2F,
$6D, $61, $69, $6E, $2E, $6C, $75, $61, $0D, $0A, $6C, $6F, $63, $61, $6C, $20,
$61, $72, $67, $73, $20, $3D, $20, $7B, $2E, $2E, $2E, $7D, $0D, $0A, $0D, $0A,
$2D, $2D, $20, $43, $68, $65, $63, $6B, $20, $69, $66, $20, $77, $65, $20, $61,
$72, $65, $20, $61, $6C, $72, $65, $61, $64, $79, $20, $62, $75, $6E, $64, $6C,
$65, $64, $0D, $0A, $69, $66, $20, $69, $6D, $70, $6F, $72, $74, $20, $3D, $3D,
$20, $6E, $69, $6C, $20, $74, $68, $65, $6E, $0D, $0A, $20, $20, $20, $20, $64,
$6F, $66, $69, $6C, $65, $28, $22, $75, $74, $69, $6C, $2F, $6C, $6F, $61, $64,
$65, $72, $2E, $6C, $75, $61, $22, $29, $0D, $0A, $65, $6E, $64, $0D, $0A, $0D,
$0A, $69, $6D, $70, $6F, $72, $74, $28, $22, $61, $70, $70, $2F, $6D, $61, $69,
$6E, $2E, $6C, $75, $61, $22, $29, $28, $61, $72, $67, $73, $29, $0D, $0A, $65,
$6E, $64, $0D, $0A, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $69, $6D, $70,
$6F, $72, $74, $28, $6E, $29, $0D, $0A, $72, $65, $74, $75, $72, $6E, $20, $6D,
$6F, $64, $75, $6C, $65, $73, $5B, $6E, $5D, $28, $74, $61, $62, $6C, $65, $2E,
$75, $6E, $70, $61, $63, $6B, $28, $61, $72, $67, $73, $29, $29, $0D, $0A, $65,
$6E, $64, $0D, $0A, $6C, $6F, $63, $61, $6C, $20, $65, $6E, $74, $72, $79, $20,
$3D, $20, $69, $6D, $70, $6F, $72, $74, $28, $27, $6C, $75, $61, $62, $75, $6E,
$64, $6C, $65, $2E, $6C, $75, $61, $27, $29, $0D, $0A, $65, $6E, $64, $29, $28,
$7B, $2E, $2E, $2E, $7D, $29
);

function LuaWrapperClosure(aState: Pointer): Integer; cdecl;
var
  LMethod: TMethod;
  LClosure: TLuaFunction absolute LMethod;
  LLua: TLua;
begin
  // get lua object
  LLua := lua_touserdata(aState, lua_upvalueindex(1));

  // get lua class routine
  LMethod.Code := lua_touserdata(aState, lua_upvalueindex(2));
  LMethod.Data := lua_touserdata(aState, lua_upvalueindex(3));

  // init the context
  LLua.Context.Setup;

  // call class routines
  LClosure(LLua.Context);

  // return result count
  Result := LLua.Context.PushCount;

  // clean up stack
  LLua.Context.Cleanup;
end;

function LuaWrapperWriter(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt; aData: Pointer): Integer; cdecl;
var
  LStream: TStream;
begin
  LStream := TStream(aData);
  try
    LStream.WriteBuffer(aBuffer^, aSize);
    Result := 0;
  except
    on E: EStreamError do
      Result := 1;
  end;
end;

{ TLuaValue }
class operator TLuaValue.Implicit(const aValue: Integer): TLuaValue;
begin
  Result.AsType := vtInteger;
  Result.AsInteger := aValue;
end;

class operator TLuaValue.Implicit(aValue: Double): TLuaValue;
begin
  Result.AsType := vtDouble;
  Result.AsNumber := aValue;
end;

class operator TLuaValue.Implicit(aValue: PChar): TLuaValue;
begin
  Result.AsType := vtString;
  Result.AsString := aValue;
end;

class operator TLuaValue.Implicit(aValue: TLuaTable): TLuaValue;
begin
  Result.AsType := vtTable;
  Result.AsTable := aValue;
end;

class operator TLuaValue.Implicit(aValue: Pointer): TLuaValue;
begin
  Result.AsType := vtPointer;
  Result.AsPointer := aValue;
end;

class operator TLuaValue.Implicit(aValue: Boolean): TLuaValue;
begin
  Result.AsType := vtBoolean;
  Result.AsBoolean := aValue;
end;

class operator TLuaValue.Implicit(aValue: TLuaValue): Integer;
begin
  Result := aValue.AsInteger;
end;

class operator TLuaValue.Implicit(aValue: TLuaValue): Double;
begin
  Result := aValue.AsNumber;
end;

class operator TLuaValue.Implicit(aValue: TLuaValue): PChar;
const
{$J+}
  LValue: string = '';
{$J-}
begin
  LValue := aValue.AsString;
  Result := PChar(LValue);
end;

class operator TLuaValue.Implicit(aValue: TLuaValue): Pointer;
begin
  Result := aValue.AsPointer
end;

class operator TLuaValue.Implicit(aValue: TLuaValue): Boolean;
begin
  Result := aValue.AsBoolean;
end;


{ --- Routines -------------------------------------------------------------- }
function ParseTableNames(aNames: string): TStringArray;
var
  LItems: TArray<string>;
  LI: Integer;
begin
  LItems := aNames.Split(['.']);
  SetLength(Result, Length(LItems));
  for LI := 0 to High(LItems) do
  begin
    Result[LI] := LItems[LI];
  end;
end;

{ --- TLuaContext ----------------------------------------------------------- }
procedure TLuaContext.Setup;
begin
  FPushCount := 0;
  FPushFlag := True;
end;

procedure TLuaContext.Check;
begin
  if FPushFlag then
  begin
    FPushFlag := False;
    ClearStack;
  end;
end;

procedure TLuaContext.IncStackPushCount;
begin
  Inc(FPushCount);
end;

procedure TLuaContext.Cleanup;
begin
  if FPushFlag then
  begin
    ClearStack;
  end;
end;

function TLuaContext.PushTableForSet(aName: array of string; aIndex: Integer; var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  Result := False;

  // validate name array size
  aStackIndex := Length(aName);
  if aStackIndex < 1 then
    Exit;

  // validate return aStackIndex and aFieldNameIndex
  if Length(aName) = 1 then
    aFieldNameIndex := 0
  else
    aFieldNameIndex := Length(aName) - 1;

  // table does not exist, exit
  if lua_type(FLua.State, aIndex) <> LUA_TTABLE then
    Exit;

  // process sub tables
  for LI := 0 to aStackIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, LI + aIndex, LMarshall.AsAnsi(aName[LI]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FLua.State, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FLua.State, 1);

      // push new table
      lua_newtable(FLua.State);

      // set new table a field
      lua_setfield(FLua.State, LI + aIndex, LMarshall.AsAnsi(aName[LI]).ToPointer);

      // push field table back on stack
      lua_getfield(FLua.State, LI + aIndex, LMarshall.AsAnsi(aName[LI]).ToPointer);
    end;
  end;

  Result := True;
end;

function TLuaContext.PushTableForGet(aName: array of string; aIndex: Integer; var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  Result := False;

  // validate name array size
  aStackIndex := Length(aName);
  if aStackIndex < 1 then
    Exit;

  // validate return aStackIndex and aFieldNameIndex
  if aStackIndex = 1 then
    aFieldNameIndex := 0
  else
    aFieldNameIndex := aStackIndex - 1;

  // table does not exist, exit
  if lua_type(FLua.State, aIndex) <> LUA_TTABLE then
    Exit;

  // process sub tables
  for LI := 0 to aStackIndex - 2 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, LI + aIndex, LMarshall.AsAnsi(aName[LI]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FLua.State, -1) <> LUA_TTABLE then
      Exit;
  end;

  Result := True;
end;

constructor TLuaContext.Create(aLua: TLua);
begin
  FLua := aLua;
  FPushCount := 0;
  FPushFlag := False;
end;

destructor TLuaContext.Destroy;
begin
  FLua := nil;
  FPushCount := 0;
  FPushFlag := False;
  inherited;
end;

function TLuaContext.ArgCount: Integer;
begin
  Result := lua_gettop(FLua.State);
end;

function TLuaContext.PushCount: Integer;
begin
  Result := FPushCount;
end;

procedure TLuaContext.ClearStack;
begin
  lua_pop(FLua.State, lua_gettop(FLua.State));
  FPushCount := 0;
  FPushFlag := False;
end;

procedure TLuaContext.PopStack(aCount: Integer);
begin
  lua_pop(FLua.State, aCount);
end;

function TLuaContext.GetStackType(aIndex: Integer): TLuaType;
begin
  Result := TLuaType(lua_type(FLua.State, aIndex));
end;

function TLuaContext.GetValue(aType: TLuaValueType; aIndex: Integer): TLuaValue;
const
{$J+}
  LStr: string = '';
{$J-}
begin
  case aType of
    vtInteger:
      begin
        Result := lua_tointeger(FLua.State, aIndex);
      end;
    vtDouble:
      begin
        Result := lua_tonumber(FLua.State, aIndex);
      end;
    vtString:
      begin
        LStr := lua_tostring(FLua.State, aIndex);
        Result := PChar(LStr);
      end;
    vtPointer:
      begin
        Result := lua_touserdata(FLua.State, aIndex);
      end;
    vtBoolean:
      begin
        var
          Bool: LongBool := lua_toboolean(FLua.State, aIndex);
        Result := Boolean(Bool);
      end;
  else
    begin

    end;
  end;
end;

procedure TLuaContext.PushValue(aValue: TLuaValue);
begin
  Check;

  case aValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FLua.State, aValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FLua.State, aValue);
      end;
    vtString:
      begin
        var
          Marshall: TMarshaller;
        var
          Value: string := aValue.AsString;
        lua_pushstring(FLua.State, Marshall.AsAnsi(Value).ToPointer);
      end;
    vtTable:
      begin
        lua_newtable(FLua.State);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FLua.State, aValue);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := aValue.AsBoolean;
        lua_pushboolean(FLua.State, Value);
      end;
  end;

  IncStackPushCount;
end;

procedure TLuaContext.SetTableFieldValue(const aName: string; aValue: TLuaValue; aIndex: Integer);
var
  LMarshall: TMarshaller;
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringArray;
  LOk: Boolean;
begin
  LItems := ParseTableNames(aName);
  if not PushTableForSet(LItems, aIndex, LStackIndex, LFieldNameIndex) then
    Exit;
  LOk := True;

  case aValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FLua.State, aValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FLua.State, aValue);
      end;
    vtString:
      begin
        var
          Value: string := aValue.AsString;
        lua_pushstring(FLua.State, LMarshall.AsAnsi(Value).ToPointer);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FLua.State, aValue);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := aValue.AsBoolean;
        lua_pushboolean(FLua.State, Value);
      end;
  else
    begin
      LOk := False;
    end;
  end;

  if LOk then
  begin
    lua_setfield(FLua.State, LStackIndex + (aIndex - 1),
      LMarshall.AsAnsi(LItems[LFieldNameIndex]).ToPointer);
  end;

  PopStack(LStackIndex);
end;

function TLuaContext.GetTableFieldValue(const aName: string; aType: TLuaValueType; aIndex: Integer): TLuaValue;
const
{$J+}
  LStr: string = '';
{$J-}
var
  LMarshall: TMarshaller;
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringArray;
begin
  LItems := ParseTableNames(aName);
  if not PushTableForGet(LItems, aIndex, LStackIndex, LFieldNameIndex) then
    Exit;
  lua_getfield(FLua.State, LStackIndex + (aIndex - 1),
    LMarshall.AsAnsi(LItems[LFieldNameIndex]).ToPointer);

  case aType of
    vtInteger:
      begin
        Result := lua_tointeger(FLua.State, -1);
      end;
    vtDouble:
      begin
        Result := lua_tonumber(FLua.State, -1);
      end;
    vtString:
      begin
        LStr := lua_tostring(FLua.State, -1);
        Result := PChar(LStr);
      end;
    vtPointer:
      begin
        Result := lua_touserdata(FLua.State, -1);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := lua_toboolean(FLua.State, -1);
        Result := Boolean(Value);
      end;
  end;

  PopStack(LStackIndex);
end;

procedure TLuaContext.SetTableIndexValue(const aName: string; aValue: TLuaValue; aIndex: Integer; aKey: Integer);
var
  LMarshall: TMarshaller;
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringArray;
  LOk: Boolean;

  procedure LPushValue;
  begin
    LOk := True;

    case aValue.AsType of
      vtInteger:
        begin
          lua_pushinteger(FLua.State, aValue);
        end;
      vtDouble:
        begin
          lua_pushnumber(FLua.State, aValue);
        end;
      vtString:
        begin
          var
            Value: string := aValue.AsString;
          lua_pushstring(FLua.State, LMarshall.AsAnsi(Value).ToPointer);
        end;
      vtPointer:
        begin
          lua_pushlightuserdata(FLua.State, aValue);
        end;
      vtBoolean:
        begin
          var
            Value: LongBool := aValue.AsBoolean;
          lua_pushboolean(FLua.State, Value);
        end;
    else
      begin
        LOk := False;
      end;
    end;

  end;

begin

  LItems := ParseTableNames(aName);
  if Length(LItems) > 0 then
    begin
      if not PushTableForGet(LItems, aIndex, LStackIndex, LFieldNameIndex) then
        Exit;
      LPushValue;
      if LOk then
        lua_rawseti (FLua.State, LStackIndex + (aIndex - 1), aKey);
    end
  else
    begin
      LPushValue;
      if LOk then
      begin
        lua_rawseti (FLua.State, aIndex, aKey);
      end;
      LStackIndex := 0;
    end;

    PopStack(LStackIndex);
end;

function TLuaContext.GetTableIndexValue(const aName: string; aType: TLuaValueType; aIndex: Integer; aKey: Integer): TLuaValue;
const
{$J+}
  LStr: string = '';
{$J-}
var
  //Marshall: TMarshaller;
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringArray;
begin
  LItems := ParseTableNames(aName);
  if Length(LItems) > 0 then
    begin
      if not PushTableForGet(LItems, aIndex, LStackIndex, LFieldNameIndex) then
        Exit;
      lua_rawgeti (FLua.State, LStackIndex + (aIndex - 1), aKey);
    end
  else
    begin
      lua_rawgeti (FLua.State, aIndex, aKey);
      LStackIndex := 0;
    end;

  case aType of
    vtInteger:
      begin
        Result := lua_tointeger(FLua.State, -1);
      end;
    vtDouble:
      begin
        Result := lua_tonumber(FLua.State, -1);
      end;
    vtString:
      begin
        LStr := lua_tostring(FLua.State, -1);
        Result := PChar(LStr);
      end;
    vtPointer:
      begin
        Result := lua_touserdata(FLua.State, -1);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := lua_toboolean(FLua.State, -1);
        Result := Boolean(Value);
      end;
  end;

  PopStack(LStackIndex);
end;


{ --- TLua ---------------------------------------------------------------- }
procedure TLua.Open;
begin
  if FState <> nil then
    Exit;
  FState := luaL_newstate;
  SetGCStepSize(200);
  luaL_openlibs(FState);
  LoadBuffer(@cLOADER_LUA, Length(cLOADER_LUA));
  FContext := TLuaContext.Create(Self);
  SetVariable('Vivace.LuaVersion', GetVariable('jit.version', vtString));
  //SetVariable('Game.meta', 'test');
end;

procedure TLua.Close;
begin
  if FState = nil then
    Exit;
  FreeAndNil(FContext);
  lua_close(FState);
  FState := nil;
end;

procedure TLua.CheckLuaError(const aError: Integer);
var
  LErr: string;
begin
  case aError of
    // success
    0:
      begin

      end;
    // a runtime error.
    LUA_ERRRUN:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaRuntimeException.CreateFmt('Runtime error [%s]', [LErr]);
      end;
    // memory allocation error. For such errors, Lua does not call the error handler function.
    LUA_ERRMEM:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaException.CreateFmt('Memory allocation error [%s]', [LErr]);
      end;
    // error while running the error handler function.
    LUA_ERRERR:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaException.CreateFmt
          ('Error while running the error handler function [%s]', [LErr]);
      end;
    LUA_ERRSYNTAX:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaSyntaxError.CreateFmt('Syntax Error [%s]', [LErr]);
      end
  else
    begin
      LErr := lua_tostring(FState, -1);
      lua_pop(FState, 1);
      raise ELuaException.CreateFmt('Unknown Error [%s]', [LErr]);
    end;
  end;
end;

function TLua.PushGlobalTableForSet(aName: array of string; var aIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  Result := False;

  if Length(aName) < 2 then
    Exit;

  aIndex := Length(aName) - 1;

  // check if global table exists
  lua_getglobal(FState, LMarshall.AsAnsi(aName[0]).ToPointer);

  // table does not exist, create new one
  if lua_type(FState, lua_gettop(FState)) <> LUA_TTABLE then
  begin
    // clean up stack
    lua_pop(FState, 1);

    // create new table
    lua_newtable(FState);

    // make it global
    lua_setglobal(FState, LMarshall.AsAnsi(aName[0]).ToPointer);

    // push global table back on stack
    lua_getglobal(FState, LMarshall.AsAnsi(aName[0]).ToPointer);
  end;

  // process tables in global table at index 1+
  // global table on stack, process remaining tables
  for LI := 1 to aIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FState, LI, LMarshall.AsAnsi(aName[LI]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FState, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FState, 1);

      // push new table
      lua_newtable(FState);

      // set new table a field
      lua_setfield(FState, LI, LMarshall.AsAnsi(aName[LI]).ToPointer);

      // push field table back on stack
      lua_getfield(FState, LI, LMarshall.AsAnsi(aName[LI]).ToPointer);
    end;
  end;

  Result := True;
end;

function TLua.PushGlobalTableForGet(aName: array of string; var aIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  // assume false
  Result := False;

  // check for valid table name count
  if Length(aName) < 2 then
    Exit;

  // init stack index
  aIndex := Length(aName) - 1;

  // lookup global table
  lua_getglobal(FState, LMarshall.AsAnsi(aName[0]).ToPointer);

  // check of global table exits
  if lua_type(FState, lua_gettop(FState)) = LUA_TTABLE then
  begin
    // process tables in global table at index 1+
    // global table on stack, process remaining tables
    for LI := 1 to aIndex - 1 do
    begin
      // get table at field aIndex[i]
      lua_getfield(FState, LI, LMarshall.AsAnsi(aName[LI]).ToPointer);

      // table field does not exists, exit
      if lua_type(FState, -1) <> LUA_TTABLE then
      begin
        // table name does not exit so we are out of here with an error
        Exit;
      end;
    end;
  end;

  // all table names exits we are good
  Result := True;
end;

procedure TLua.PushTValue(aValue: TValue);
var
  LUtf8s: RawByteString;
begin
  case aValue.Kind of
    tkUnknown, tkChar, tkSet, tkMethod, tkVariant, tkArray, tkProcedure,
      tkRecord, tkInterface, tkDynArray, tkClassRef:
      begin
        lua_pushnil(FState);
      end;
    tkInteger:
      lua_pushinteger(FState, aValue.AsInteger);
    tkEnumeration:
      begin
        if aValue.IsType<Boolean> then
        begin
          if aValue.AsBoolean then
            lua_pushboolean(FState, True)
          else
            lua_pushboolean(FState, False);
        end
        else
          lua_pushinteger(FState, aValue.AsInteger);
      end;
    tkFloat:
      lua_pushnumber(FState, aValue.AsExtended);
    tkString, tkWChar, tkLString, tkWString, tkUString:
      begin
        LUtf8s := UTF8Encode(aValue.AsString);
        lua_pushstring(FState, PAnsiChar(LUtf8s));
      end;
    tkClass:
      { lua_pushlightuserdata(FState, Pointer(Value.AsObject)) };
    tkInt64:
      lua_pushnumber(FState, aValue.AsInt64);
    tkPointer:
      { lua_pushlightuserdata(FState, Pointer(Value.AsObject)) };
  end;
end;

function TLua.CallFunction(const aParams: array of TValue): TValue;
var
  LP: TValue;
  LR: Integer;
begin
  for LP in aParams do
    PushTValue(LP);
  LR := lua_pcall(FState, Length(aParams), 1, 0);
  CheckLuaError(LR);
  lua_pop(FState, 1);
  case lua_type(FState, -1) of
    LUA_TNIL:
      begin
        Result := nil;
      end;

    LUA_TBOOLEAN:
      begin
        Result := Boolean(lua_toboolean(FState, -1));
      end;

    LUA_TNUMBER:
      begin
        Result := lua_tonumber(FState, -1);
      end;

    LUA_TSTRING:
      begin
        Result := lua_tostring(FState, -1);
      end;
  else
    Result := nil;
    // ELuaException.Create('Unsupported return type');
  end;
end;

procedure TLua.Bundle(aInFilename: string; aOutFilename: string);
begin
  if aInFilename.IsEmpty then  Exit;
  if aOutFilename.IsEmpty then Exit;
  LoadBuffer(@cLUABUNDLE_LUA, Length(cLUABUNDLE_LUA), False);
  DoCall([PChar(aInFilename), PChar(aOutFilename)]);
end;

constructor TLua.Create;
begin
  inherited;
  FState := nil;
  Open;
end;

destructor TLua.Destroy;
begin
  Close;
  inherited;
end;

procedure TLua.Reset;
begin
  Close;
  Open;
  gEngine.OnLuaReset;
end;

procedure TLua.LoadFile(const aFilename: string; aAutoRun: Boolean);
var
  LMarshall: TMarshaller;
  LErr: string;
  LRes: Integer;
  LFilename: string;
begin
  if aFilename.IsEmpty then
    Exit;

  LFilename := TPath.ChangeExtension(aFilename, cLuaExt);

  if not TFile.Exists(LFilename) then
  begin
    LFilename := TPath.ChangeExtension(LFilename, cLuacExt);
    if not TFile.Exists(LFilename) then Exit;
  end;

  if aAutoRun then
    LRes := luaL_dofile(FState, LMarshall.AsAnsi(LFilename).ToPointer)
  else
    LRes := luaL_loadfile(FState, LMarshall.AsAnsi(LFilename).ToPointer);

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(LErr);
  end;
end;

procedure TLua.LoadString(const aData: string; aAutoRun: Boolean);
var
  LMarshall: TMarshaller;
  LErr: string;
  LRes: Integer;
  LData: string;
begin
  LData := aData;
  if LData.IsEmpty then
    Exit;

  if aAutoRun then
    LRes := luaL_dostring(FState, LMarshall.AsAnsi(LData).ToPointer)
  else
    LRes := luaL_loadstring(FState, LMarshall.AsAnsi(LData).ToPointer);

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(LErr);
  end;
end;

procedure TLua.LoadStream(aStream: TStream; aSize: NativeUInt; aAutoRun: Boolean);
var
  LMemStream: TMemoryStream;
  LSize: NativeUInt;
begin
  LMemStream := TMemoryStream.Create;
  try
    if aSize = 0 then
      LSize := aStream.Size
    else
      LSize := aSize;
    LMemStream.Position := 0;
    LMemStream.CopyFrom(aStream, LSize);
    LoadBuffer(LMemStream.Memory, LMemStream.size, aAutoRun);
  finally
    FreeAndNil(LMemStream);
  end;
end;

procedure TLua.LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean);
var
  LMemStream: TMemoryStream;
  LRes: Integer;
  LErr: string;
begin
  LMemStream := TMemoryStream.Create;
  try
    LMemStream.Write(aData^, aSize);
    LMemStream.Position := 0;
    if aAutoRun then
      LRes := luaL_dobuffer(FState, LMemStream.Memory, LMemStream.size, 'LoadBuffer')
    else
      LRes := luaL_loadbuffer(FState, LMemStream.Memory, LMemStream.size, 'LoadBuffer');
  finally
    FreeAndNil(LMemStream);
  end;

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(LErr);
  end;

end;

procedure TLua.SaveByteCode(aStream: TStream);
var
  LRet: Integer;
begin
  if lua_type(FState, lua_gettop(FState)) <> LUA_TFUNCTION then
    Exit;

  try
    LRet := lua_dump(FState, LuaWrapperWriter, aStream);
    if LRet <> 0 then
      raise ELuaException.CreateFmt('lua_dump returned code %d', [LRet]);
  finally
    lua_pop(FState, 1);
  end;
end;

procedure TLua.LoadByteCode(aStream: TStream; aName: string; aAutoRun: Boolean);
var
  LRes: Integer;
  LErr: string;
  LMemStream: TMemoryStream;
  LMarshall: TMarshaller;
begin
  if aStream = nil then
    Exit;
  if aStream.size <= 0 then
    Exit;

  LMemStream := TMemoryStream.Create;

  try
    LMemStream.CopyFrom(aStream, aStream.size);

    if aAutoRun then
    begin
      LRes := luaL_dobuffer(FState, LMemStream.Memory, LMemStream.size,
        LMarshall.AsAnsi(aName).ToPointer)
    end
    else
      LRes := luaL_loadbuffer(FState, LMemStream.Memory, LMemStream.size,
        LMarshall.AsAnsi(aName).ToPointer);
  finally
    LMemStream.Free;
  end;

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(LErr);
  end;

end;

procedure TLua.PushLuaValue(aValue: TLuaValue);
begin
  case aValue.AsType of
    vtInteger:
      begin
        var value: Integer := aValue.AsInteger;
        lua_pushinteger(FState, value);
      end;
    vtDouble:
      begin
        var value: Double := aVAlue.AsNumber;
        lua_pushnumber(FState, value);
      end;
    vtString:
      begin
        var
          utf8s: RawByteString := UTF8Encode(aValue.AsString);
        lua_pushstring(FState, PAnsiChar(utf8s));
      end;
    vtPointer:
      begin
        var value: Pointer := aValue.AsPointer;
        lua_pushlightuserdata(FState, value);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := aValue.AsBoolean;
        lua_pushboolean(FState, Value);
      end;
  else
    begin
      lua_pushnil(FState);
    end;
  end;
end;

function TLua.GetLuaValue(aIndex: Integer): TLuaValue;
const
{$J+}
  LStr: string = '';
{$J-}
begin
  case lua_type(FState, aIndex) of
    LUA_TNIL:
      begin
        Result := nil;
      end;

    LUA_TBOOLEAN:
      begin
        Result := Boolean(lua_toboolean(FState, aIndex));
      end;

    LUA_TNUMBER:
      begin
        Result := lua_tonumber(FState, aIndex);
      end;

    LUA_TSTRING:
      begin
        LStr := lua_tostring(FState, aIndex);
        Result := PChar(LStr);
      end;
  else
    begin
      Result := nil;
    end;
  end;
end;

function TLua.DoCall(const aParams: array of TLuaValue): TLuaValue;
var
  LValue: TLuaValue;
  LRes: Integer;
begin
  for LValue in aParams do
  begin
    PushLuaValue(LValue);
  end;

  LRes := lua_pcall(FState, Length(aParams), 1, 0);
  CheckLuaError(LRes);
  Result := GetLuaValue(-1);
  //CleanStack;
end;

function TLua.DoCall(aParamCount: Integer): TLuaValue;
var
  LRes: Integer;
begin
  LRes := lua_pcall(FState, aParamCount, 1, 0);
  CheckLuaError(LRes);
  Result := GetLuaValue(-1);
  CleanStack;
end;

procedure TLua.CleanStack;
begin
  lua_pop(FState, lua_gettop(FState));
end;

function TLua.Call(const aName: string; const aParams: array of TLuaValue): TLuaValue;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringArray;
begin

  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  CleanStack;

  LItems := ParseTableNames(aName);

  if Length(LItems) > 1 then
  begin
    if not PushGlobalTableForGet(LItems, LIndex) then
    begin
      CleanStack;
      Exit;
    end;

    lua_getfield(FState,  LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, LMarshall.AsAnsi(LItems[0]).ToPointer);
  end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := DoCall(aParams);
    end;
  end;

end;

function TLua.PrepCall(const aName: string): Boolean;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringArray;
begin

  Result := False;

  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  CleanStack;

  LItems := ParseTableNames(aName);

  if Length(LItems) > 1 then
  begin
    if not PushGlobalTableForGet(LItems, LIndex) then
    begin
      CleanStack;
      Exit;
    end;

    lua_getfield(FState,  LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, LMarshall.AsAnsi(LItems[0]).ToPointer);
  end;
  Result := True;
end;

function TLua.Call(aParamCount: Integer): TLuaValue;
begin
  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := DoCall(aParamCount);
    end;
  end;
end;

function TLua.RoutineExist(const aName: string): Boolean;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringArray;
  LCount: Integer;
  LName: string;
begin
  Result := False;

  LName := aName;
  if LName.IsEmpty then
    Exit;

  LItems := ParseTableNames(LName);

  LCount := Length(LItems);

  if LCount > 1 then
  begin
    if not PushGlobalTableForGet(LItems, LIndex) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
  end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := True;
    end;
  end;

  CleanStack;
end;

procedure TLua.Run;
var
  LErr: string;
  LRes: Integer;
begin
  LRes := LUA_OK;

  if lua_type(FState, lua_gettop(FState)) = LUA_TFUNCTION then
  begin
    LRes := lua_pcall(FState, 0, LUA_MULTRET, 0);
  end;

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(LErr);
  end;
end;

function TLua.VariableExist(const aName: string): Boolean;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringArray;
  LCount: Integer;
  LName: string;
begin
  Result := False;
  LName := aName;
  if LName.IsEmpty then
    Exit;

  LItems := ParseTableNames(LName);
  LCount := Length(LItems);

  if LCount > 1 then
  begin
    if not PushGlobalTableForGet(LItems, LIndex) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
  end
  else if LCount = 1 then
  begin
    lua_getglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
  end
  else
  begin
    Exit;
  end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    Result := lua_isvariable(FState, -1);
  end;

  CleanStack;
end;

function TLua.GetVariable(const aName: string; aType: TLuaValueType): TLuaValue;
const
{$J+}
  LStr: string = '';
{$J-}
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringArray;
  LCount: Integer;
  LName: string;
begin
  Result := nil;
  LName := aName;
  if LName.IsEmpty then
    Exit;

  LItems := ParseTableNames(LName);
  LCount := Length(LItems);

  if LCount > 1 then
  begin
    if not PushGlobalTableForGet(LItems, LIndex) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
  end
  else if LCount = 1 then
  begin
    lua_getglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
  end
  else
  begin
    Exit;
  end;

  case aType of
    vtInteger:
      begin
        Result := lua_tointeger(FState, -1);
      end;
    vtDouble:
      begin
        Result := lua_tonumber(FState, -1);
      end;
    vtString:
      begin
        LStr := lua_tostring(FState, -1);
        Result := PChar(LStr);
      end;
    vtPointer:
      begin
        Result := lua_touserdata(FState, -1);
      end;
    vtBoolean:
      begin
        var
          Bool: LongBool := lua_toboolean(FState, -1);
        Result := Boolean(Bool);
      end;
  end;

  CleanStack;
end;

procedure TLua.SetVariable(const aName: string; aValue: TLuaValue);
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringArray;
  LOk: Boolean;
  LCount: Integer;
  LName: string;
begin
  LName := aName;
  if LName.IsEmpty then
    Exit;

  LItems := ParseTableNames(aName);
  LCount := Length(LItems);

  if LCount > 1 then
  begin
    if not PushGlobalTableForSet(LItems, LIndex) then
    begin
      CleanStack;
      Exit;
    end;
  end
  else if LCount < 1 then
  begin
    Exit;
  end;

  LOk := True;

  case aValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FState, aValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FState, aValue);
      end;
    vtString:
      begin
        var
          LS: string := aValue;
        lua_pushstring(FState, LMarshall.AsAnsi(LS).ToPointer);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FState, aValue);
      end;
    vtBoolean:
      begin
        var
          LBool: LongBool := aValue.AsBoolean;
        lua_pushboolean(FState, LBool);
      end;
  else
    begin
      LOk := False;
    end;
  end;

  if LOk then
  begin
    if LCount > 1 then
    begin
      lua_setfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer)
    end
    else
    begin
      lua_setglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
    end;
  end;

  CleanStack;
end;

procedure TLua.RegisterRoutine(const aName: string; aRoutine: TLuaFunction);
var
  LMethod: TMethod;
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  LI: Integer;
  LItems: TStringArray;
  LCount: Integer;
begin
  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(aName);

  LCount := Length(LItems);

  SetLength(LNames, Length(LItems));

  for LI := 0 to High(LItems) do
  begin
    LNames[LI] := LItems[LI];
  end;

  // init sub table LNames
  if LCount > 1 then
  begin

    // push global table to stack
    if not PushGlobalTableForSet(LNames, LIndex) then
    begin
      CleanStack;
      Exit;
    end;

    // push closure
    LMethod.Code := TMethod(aRoutine).Code;
    LMethod.Data := TMethod(aRoutine).Data;
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, LMethod.Code);
    lua_pushlightuserdata(FState, LMethod.Data);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // add field to table
    lua_setfield(FState, -2, LMarshall.AsAnsi(LNames[LIndex]).ToPointer);

    CleanStack;
  end
  else if (LCount = 1) then
  begin
    // push closure
    LMethod.Code := TMethod(aRoutine).Code;
    LMethod.Data := TMethod(aRoutine).Data;
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, LMethod.Code);
    lua_pushlightuserdata(FState, LMethod.Data);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // set as global
    lua_setglobal(FState, LMarshall.AsAnsi(LNames[0]).ToPointer);
  end;
end;

procedure TLua.RegisterRoutine(const aName: string; aData: Pointer; aCode: Pointer);
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  LI: Integer;
  LItems: TStringArray;
  LCount: Integer;
begin
  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(aName);

  LCount := Length(LItems);

  SetLength(LNames, Length(LItems));

  for LI := 0 to High(LItems) do
  begin
    LNames[LI] := LItems[LI];
  end;

  // init sub table LNames
  if LCount > 1 then
  begin

    // push global table to stack
    if not PushGlobalTableForSet(LNames, LIndex) then
    begin
      CleanStack;
      Exit;
    end;

    // push closure
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, aCode);
    lua_pushlightuserdata(FState, aData);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // add field to table
    lua_setfield(FState, -2, LMarshall.AsAnsi(LNames[LIndex]).ToPointer);

    CleanStack;
  end
  else if (LCount = 1) then
  begin
    // push closure
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, aCode);
    lua_pushlightuserdata(FState, aData);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // set as global
    lua_setglobal(FState, LMarshall.AsAnsi(LNames[0]).ToPointer);
  end;
end;

procedure TLua.RegisterRoutines(aClass: TClass);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;

  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
begin
  LRttiType := LRttiContext.GetType(aClass);
  LMethodAutoSetup := nil;
  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkClassProcedure) then
      continue;
    if (LRttiMethod.Visibility <> mvPublic) then
      continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)
        ) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // LRttiMethod.Invoke(aClass, [Self]);
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType))
      and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := aClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      // lua_setfield(FState, -2,  LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
      lua_setglobal(FState, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);

    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(aClass, [Self]);

    // clean up stack
    // Lua_Pop(FState, Lua_GetTop(FState));
    CleanStack;
  end;

end;

procedure TLua.RegisterRoutines(aObject: TObject);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;
  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
begin
  LRttiType := LRttiContext.GetType(aObject.ClassType);
  LMethodAutoSetup := nil;
  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkProcedure) then
      continue;
    if (LRttiMethod.Visibility <> mvPublic) then
      continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)
        ) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // LRttiMethod.Invoke(aObject.ClassType, [Self]);
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType))
      and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := aObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      // lua_setfield(FState, -2,  LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
      lua_setglobal(FState, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(aObject, [Self]);

    // clean up stack
    CleanStack;
  end;

end;

procedure TLua.RegisterRoutines(const aTables: string; aClass: TClass; const aTableName: string);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;

  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  TblName: string;
  LI: Integer;
  LItems: TStringArray;
  LLastIndex: Integer;
begin
  // init the routines table name
  //if aTableName.IsEmpty then
  if aTableName = '' then
    TblName := aClass.ClassName
  else
    TblName := aTableName;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(aTables);

  // init sub table LNames
  if Length(LItems) > 0 then
  begin
    SetLength(LNames, Length(LItems) + 2);

    LLastIndex := 0;
    for LI := 0 to High(LItems) do
    begin
      LNames[LI] := LItems[LI];
      LLastIndex := LI;
    end;

    // set last as table name for functions
    LNames[LLastIndex] := TblName;
    LNames[LLastIndex + 1] := TblName;
  end
  else
  begin
    SetLength(LNames, 2);
    LNames[0] := TblName;
    LNames[1] := TblName;
  end;

  // push global table to stack
  if not PushGlobalTableForSet(LNames, LIndex) then
  begin
    CleanStack;
    Exit;
  end;

  LRttiType := LRttiContext.GetType(aClass);
  LMethodAutoSetup := nil;
  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkClassProcedure) then
      continue;
    if (LRttiMethod.Visibility <> mvPublic) then
      continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)
        ) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // LRttiMethod.Invoke(aClass, [Self]);
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType))
      and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := aClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(aClass, [Self]);

    // clean up stack
    // Lua_Pop(FState, Lua_GetTop(FState));
    CleanStack;
  end;

end;

procedure TLua.RegisterRoutines(const aTables: string; aObject: TObject;
  const aTableName: string);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;
  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  TblName: string;
  LI: Integer;
  LItems: TStringArray;
  LLastIndex: Integer;
begin
  // init the routines table name
  //if aTableName.IsEmpty then
  if aTableName = '' then
    TblName := aObject.ClassName
  else
    TblName := aTableName;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(aTables);

  // init sub table LNames
  if Length(LItems) > 0 then
  begin
    SetLength(LNames, Length(LItems) + 2);

    LLastIndex := 0;
    for LI := 0 to High(LItems) do
    begin
      LNames[LI] := LItems[LI];
      LLastIndex := LI;
    end;

    // set last as table name for functions
    LNames[LLastIndex] := TblName;
    LNames[LLastIndex + 1] := TblName;
  end
  else
  begin
    SetLength(LNames, 2);
    LNames[0] := TblName;
    LNames[1] := TblName;
  end;

  // push global table to stack
  if not PushGlobalTableForSet(LNames, LIndex) then
  begin
    CleanStack;
    Exit;
  end;

  LRttiType := LRttiContext.GetType(aObject.ClassType);
  LMethodAutoSetup := nil;
  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkProcedure) then
      continue;
    if (LRttiMethod.Visibility <> mvPublic) then
      continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)
        ) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // LRttiMethod.Invoke(aObject.ClassType, [Self]);
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType))
      and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := aObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  CleanStack;

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(aObject, [Self]);

    // clean up stack
    CleanStack;
  end;

end;

procedure TLua.CompileToStream(aFilename: string; aStream: TStream; aCleanOutput: Boolean);
var
  LInFilename: string;
  LBundleFilename: string;
begin
  LInFilename := aFilename;
  LBundleFilename := TPath.GetFileNameWithoutExtension(LInFilename) +
    '_bundle.lua';

  Bundle(LInFilename, LBundleFilename);
  LoadFile(PChar(LBundleFilename), False);
  SaveByteCode(aStream);
  CleanStack;

  if aCleanOutput then
  begin
    if TFile.Exists(LBundleFilename) then
    begin
      TFile.Delete(LBundleFilename);
    end;
  end;
end;

procedure TLua.SetGCStepSize(aStep: Integer);
begin
  FGCStep := aStep;
end;

function TLua.GetGCStepSize: Integer;
begin
  Result := FGCStep;
end;

function TLua.GetGCMemoryUsed: Integer;
begin
  Result := lua_gc(FState, LUA_GCCOUNT, FGCStep);
end;

procedure TLua.CollectGarbage;
begin
  lua_gc(FState, LUA_GCSTEP, FGCStep);
end;

end.
