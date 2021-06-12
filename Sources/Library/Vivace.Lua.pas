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
    procedure CheckLuaError(const r: Integer);
    function PushGlobalTableForSet(aName: array of string; var aIndex: Integer): Boolean;
    function PushGlobalTableForGet(aName: array of string; var aIndex: Integer): Boolean;
    procedure PushTValue(aValue: TValue);
    function CallFunction(const aParams: array of TValue): TValue;
    procedure SaveByteCode(aStream: TStream);
    procedure LoadByteCode(aStream: TStream; aName: string; aAutoRun: Boolean = True);
    procedure CompileToStream(aFilename: string; aStream: TStream; aCleanOutput: Boolean);
    procedure Bundle(aInFilename: string; aOutFilename: string);
    procedure PushLuaValue(aValue: TLuaValue);
    function GetLuaValue(aIndex: Integer): TLuaValue;
    function DoCall(const aParams: array of TLuaValue): TLuaValue; overload;
    function DoCall(aParamCount: Integer): TLuaValue; overload;
    procedure CleanStack;
    property State: Pointer read FState;
    property Context: TLuaContext read FContext;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Reset;
    procedure LoadStream(aStream: TStream; aSize: NativeUInt = 0; aAutoRun: Boolean = True);
    procedure LoadFile(const aFilename: string; aAutoRun: Boolean = True);
    procedure LoadString(const aData: string; aAutoRun: Boolean = True);
    procedure LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean = True);
    function Call(const aName: string; const aParams: array of TLuaValue): TLuaValue; overload;
    function PrepCall(const aName: string): Boolean;
    function Call(aParamCount: Integer): TLuaValue; overload;
    function RoutineExist(const aName: string): Boolean;
    procedure Run;
    function VariableExist(const aName: string): Boolean;
    procedure SetVariable(const aName: string; aValue: TLuaValue);
    function GetVariable(const aName: string; aType: TLuaValueType): TLuaValue;
    procedure RegisterRoutine(const aName: string; aData: Pointer; aCode: Pointer); overload;
    procedure RegisterRoutine(const aName: string; aRoutine: TLuaFunction); overload;
    procedure RegisterRoutines(aClass: TClass); overload;
    procedure RegisterRoutines(aObject: TObject); overload;
    procedure RegisterRoutines(const aTables: string; aClass: TClass; const aTableName: string = ''); overload;
    procedure RegisterRoutines(const aTables: string; aObject: TObject; const aTableName: string = ''); overload;
    procedure SetGCStepSize(aStep: Integer);
    function GetGCStepSize: Integer;
    function GetGCMemoryUsed: Integer;
    procedure CollectGarbage;
  end;

implementation

uses
  System.Types,
  System.IOUtils,
  System.TypInfo,
  WinApi.Windows,
  Vivace.LuaJIT;

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
  method: TMethod;
  closure: TLuaFunction absolute method;
  lua: TLua;
begin
  // get lua object
  lua := lua_touserdata(aState, lua_upvalueindex(1));

  // get lua class routine
  method.Code := lua_touserdata(aState, lua_upvalueindex(2));
  method.Data := lua_touserdata(aState, lua_upvalueindex(3));

  // init the context
  lua.Context.Setup;

  // call class routines
  closure(lua.Context);

  // return result count
  Result := lua.Context.PushCount;

  // clean up stack
  lua.Context.Cleanup;
end;

function LuaWrapperWriter(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
  aData: Pointer): Integer; cdecl;
var
  stream: TStream;
begin
  stream := TStream(aData);
  try
    stream.WriteBuffer(aBuffer^, aSize);
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
  Value: string = '';
{$J-}
begin
  Value := aValue.AsString;
  Result := PChar(Value);
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
  Items: TArray<string>;
  i: Integer;
begin
  Items := aNames.Split(['.']);
  SetLength(Result, Length(Items));
  for i := 0 to High(Items) do
  begin
    Result[i] := Items[i];
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

function TLuaContext.PushTableForSet(aName: array of string; aIndex: Integer;
  var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
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
  for i := 0 to aStackIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FLua.State, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FLua.State, 1);

      // push new table
      lua_newtable(FLua.State);

      // set new table a field
      lua_setfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);

      // push field table back on stack
      lua_getfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);
    end;
  end;

  Result := True;
end;

function TLuaContext.PushTableForGet(aName: array of string; aIndex: Integer;
  var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
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
  for i := 0 to aStackIndex - 2 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);

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
  Str: string = '';
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
        Str := lua_tostring(FLua.State, aIndex);
        Result := PChar(Str);
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

procedure TLuaContext.SetTableFieldValue(const aName: string; aValue: TLuaValue;
  aIndex: Integer);
var
  Marshall: TMarshaller;
  StackIndex: Integer;
  FieldNameIndex: Integer;
  Items: TStringArray;
  ok: Boolean;
begin
  Items := ParseTableNames(aName);
  if not PushTableForSet(Items, aIndex, StackIndex, FieldNameIndex) then
    Exit;
  ok := True;

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
        lua_pushstring(FLua.State, Marshall.AsAnsi(Value).ToPointer);
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
      ok := False;
    end;
  end;

  if ok then
  begin
    lua_setfield(FLua.State, StackIndex + (aIndex - 1),
      Marshall.AsAnsi(Items[FieldNameIndex]).ToPointer);
  end;

  PopStack(StackIndex);
end;

function TLuaContext.GetTableFieldValue(const aName: string; aType: TLuaValueType;
  aIndex: Integer): TLuaValue;
const
{$J+}
  Str: string = '';
{$J-}
var
  Marshall: TMarshaller;
  StackIndex: Integer;
  FieldNameIndex: Integer;
  Items: TStringArray;
begin
  Items := ParseTableNames(aName);
  if not PushTableForGet(Items, aIndex, StackIndex, FieldNameIndex) then
    Exit;
  lua_getfield(FLua.State, StackIndex + (aIndex - 1),
    Marshall.AsAnsi(Items[FieldNameIndex]).ToPointer);

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
        Str := lua_tostring(FLua.State, -1);
        Result := PChar(Str);
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

  PopStack(StackIndex);
end;

procedure TLuaContext.SetTableIndexValue(const aName: string; aValue: TLuaValue; aIndex: Integer; aKey: Integer);
var
  Marshall: TMarshaller;
  StackIndex: Integer;
  FieldNameIndex: Integer;
  Items: TStringArray;
  ok: Boolean;

  procedure LPushValue;
  begin
    ok := True;

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
          lua_pushstring(FLua.State, Marshall.AsAnsi(Value).ToPointer);
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
        ok := False;
      end;
    end;

  end;

begin

  Items := ParseTableNames(aName);
  if Length(Items) > 0 then
    begin
      if not PushTableForGet(Items, aIndex, StackIndex, FieldNameIndex) then
        Exit;
      LPushValue;
      if ok then
        lua_rawseti (FLua.State, StackIndex + (aIndex - 1), aKey);
    end
  else
    begin
      LPushValue;
      if ok then
      begin
        lua_rawseti (FLua.State, aIndex, aKey);
      end;
      StackIndex := 0;
    end;

    PopStack(StackIndex);
end;

function TLuaContext.GetTableIndexValue(const aName: string; aType: TLuaValueType; aIndex: Integer; aKey: Integer): TLuaValue;
const
{$J+}
  Str: string = '';
{$J-}
var
  //Marshall: TMarshaller;
  StackIndex: Integer;
  FieldNameIndex: Integer;
  Items: TStringArray;
begin
  Items := ParseTableNames(aName);
  if Length(Items) > 0 then
    begin
      if not PushTableForGet(Items, aIndex, StackIndex, FieldNameIndex) then
        Exit;
      lua_rawgeti (FLua.State, StackIndex + (aIndex - 1), aKey);
    end
  else
    begin
      lua_rawgeti (FLua.State, aIndex, aKey);
      StackIndex := 0;
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
        Str := lua_tostring(FLua.State, -1);
        Result := PChar(Str);
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

  PopStack(StackIndex);
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

procedure TLua.CheckLuaError(const r: Integer);
var
  err: string;
begin
  case r of
    // success
    0:
      begin

      end;
    // a runtime error.
    LUA_ERRRUN:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaRuntimeException.CreateFmt('Runtime error [%s]', [err]);
      end;
    // memory allocation error. For such errors, Lua does not call the error handler function.
    LUA_ERRMEM:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaException.CreateFmt('Memory allocation error [%s]', [err]);
      end;
    // error while running the error handler function.
    LUA_ERRERR:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaException.CreateFmt
          ('Error while running the error handler function [%s]', [err]);
      end;
    LUA_ERRSYNTAX:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ELuaSyntaxError.CreateFmt('Syntax Error [%s]', [err]);
      end
  else
    begin
      err := lua_tostring(FState, -1);
      lua_pop(FState, 1);
      raise ELuaException.CreateFmt('Unknown Error [%s]', [err]);
    end;
  end;
end;

function TLua.PushGlobalTableForSet(aName: array of string;
  var aIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
begin
  Result := False;

  if Length(aName) < 2 then
    Exit;

  aIndex := Length(aName) - 1;

  // check if global table exists
  lua_getglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);

  // table does not exist, create new one
  if lua_type(FState, lua_gettop(FState)) <> LUA_TTABLE then
  begin
    // clean up stack
    lua_pop(FState, 1);

    // create new table
    lua_newtable(FState);

    // make it global
    lua_setglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);

    // push global table back on stack
    lua_getglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);
  end;

  // process tables in global table at index 1+
  // global table on stack, process remaining tables
  for i := 1 to aIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FState, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FState, 1);

      // push new table
      lua_newtable(FState);

      // set new table a field
      lua_setfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);

      // push field table back on stack
      lua_getfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);
    end;
  end;

  Result := True;
end;

function TLua.PushGlobalTableForGet(aName: array of string;
  var aIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
begin
  // assume false
  Result := False;

  // check for valid table name count
  if Length(aName) < 2 then
    Exit;

  // init stack index
  aIndex := Length(aName) - 1;

  // lookup global table
  lua_getglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);

  // check of global table exits
  if lua_type(FState, lua_gettop(FState)) = LUA_TTABLE then
  begin
    // process tables in global table at index 1+
    // global table on stack, process remaining tables
    for i := 1 to aIndex - 1 do
    begin
      // get table at field aIndex[i]
      lua_getfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);

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
  utf8s: RawByteString;
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
        utf8s := UTF8Encode(aValue.AsString);
        lua_pushstring(FState, PAnsiChar(utf8s));
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
  p: TValue;
  r: Integer;
begin
  for p in aParams do
    PushTValue(p);
  r := lua_pcall(FState, Length(aParams), 1, 0);
  CheckLuaError(r);
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
  //gEngine.OnLuaReset;
end;

procedure TLua.LoadFile(const aFilename: string; aAutoRun: Boolean);
var
  Marshall: TMarshaller;
  err: string;
  Res: Integer;
  fname: string;
  filename: string;
begin
  filename := aFilename;
  if filename.IsEmpty then
    Exit;

  fname := TPath.ChangeExtension(filename, cLuaExt);

  if not TFile.Exists(fname) then
  begin
    fname := TPath.ChangeExtension(filename, cLuacExt);
    if not TFile.Exists(fname) then
  end;

  if aAutoRun then
    Res := luaL_dofile(FState, Marshall.AsAnsi(fname).ToPointer)
  else
    Res := luaL_loadfile(FState, Marshall.AsAnsi(fname).ToPointer);

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(err);
  end;
end;

procedure TLua.LoadString(const aData: string; aAutoRun: Boolean);
var
  Marshall: TMarshaller;
  err: string;
  Res: Integer;
  Data: string;
begin
  Data := aData;
  if Data.IsEmpty then
    Exit;

  if aAutoRun then
    Res := luaL_dostring(FState, Marshall.AsAnsi(Data).ToPointer)
  else
    Res := luaL_loadstring(FState, Marshall.AsAnsi(Data).ToPointer);

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(err);
  end;
end;

procedure TLua.LoadStream(aStream: TStream; aSize: NativeUInt;
  aAutoRun: Boolean);
var
  ms: TMemoryStream;
  size: NativeUInt;
begin
  ms := TMemoryStream.Create;
  try
    if aSize = 0 then
      size := aStream.size
    else
      size := aSize;
    ms.Position := 0;
    ms.CopyFrom(aStream, size);
    LoadBuffer(ms.Memory, ms.size, aAutoRun);
  finally
    FreeAndNil(ms);
  end;
end;

procedure TLua.LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean);
var
  ms: TMemoryStream;
  Res: Integer;
  Err: string;
begin
  ms := TMemoryStream.Create;
  try
    ms.Write(aData^, aSize);
    ms.Position := 0;
    if aAutoRun then
      Res := luaL_dobuffer(FState, ms.Memory, ms.size, 'LoadBuffer')
    else
      Res := luaL_loadbuffer(FState, ms.Memory, ms.size, 'LoadBuffer');
  finally
    FreeAndNil(ms);
  end;

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(err);
  end;

end;

procedure TLua.SaveByteCode(aStream: TStream);
var
  ret: Integer;
begin
  if lua_type(FState, lua_gettop(FState)) <> LUA_TFUNCTION then
    Exit;

  try
    ret := lua_dump(FState, LuaWrapperWriter, aStream);
    if ret <> 0 then
      raise ELuaException.CreateFmt('lua_dump returned code %d', [ret]);
  finally
    lua_pop(FState, 1);
  end;
end;

procedure TLua.LoadByteCode(aStream: TStream; aName: string; aAutoRun: Boolean);
var
  Res: Integer;
  err: string;
  ms: TMemoryStream;
  Marshall: TMarshaller;
begin
  if aStream = nil then
    Exit;
  if aStream.size <= 0 then
    Exit;

  ms := TMemoryStream.Create;

  try
    ms.CopyFrom(aStream, aStream.size);

    if aAutoRun then
    begin
      Res := luaL_dobuffer(FState, ms.Memory, ms.size,
        Marshall.AsAnsi(aName).ToPointer)
    end
    else
      Res := luaL_loadbuffer(FState, ms.Memory, ms.size,
        Marshall.AsAnsi(aName).ToPointer);
  finally
    ms.Free;
  end;

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(err);
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
  Str: string = '';
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
        Str := lua_tostring(FState, aIndex);
        Result := PChar(Str);
      end;
  else
    begin
      Result := nil;
    end;
  end;
end;

function TLua.DoCall(const aParams: array of TLuaValue): TLuaValue;
var
  Value: TLuaValue;
  Res: Integer;
begin
  for Value in aParams do
  begin
    PushLuaValue(Value);
  end;

  Res := lua_pcall(FState, Length(aParams), 1, 0);
  CheckLuaError(Res);
  Result := GetLuaValue(-1);
  //CleanStack;
end;

function TLua.DoCall(aParamCount: Integer): TLuaValue;
var
  Res: Integer;
begin
  Res := lua_pcall(FState, aParamCount, 1, 0);
  CheckLuaError(Res);
  Result := GetLuaValue(-1);
  CleanStack;
end;

procedure TLua.CleanStack;
begin
  lua_pop(FState, lua_gettop(FState));
end;

function TLua.Call(const aName: string; const aParams: array of TLuaValue): TLuaValue;
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
begin

  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  CleanStack;

  Items := ParseTableNames(aName);

  if Length(Items) > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;

    lua_getfield(FState,  Index,
      Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Items[0]).ToPointer);
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
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
begin

  Result := False;

  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  CleanStack;

  Items := ParseTableNames(aName);

  if Length(Items) > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;

    lua_getfield(FState,  Index,
      Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Items[0]).ToPointer);
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
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  Count: Integer;
  Name: string;
begin
  Result := False;

  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(Name);

  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Name).ToPointer);
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
  err: string;
  Res: Integer;
begin
  Res := LUA_OK;

  if lua_type(FState, lua_gettop(FState)) = LUA_TFUNCTION then
  begin
    Res := lua_pcall(FState, 0, LUA_MULTRET, 0);
  end;

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ELuaException.Create(err);
  end;
end;

function TLua.VariableExist(const aName: string): Boolean;
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  Count: Integer;
  Name: string;
begin
  Result := False;
  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(Name);
  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else if Count = 1 then
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Name).ToPointer);
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
  Str: string = '';
{$J-}
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  Count: Integer;
  Name: string;
begin
  Result := nil;
  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(Name);
  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else if Count = 1 then
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Name).ToPointer);
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
        Str := lua_tostring(FState, -1);
        Result := PChar(Str);
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
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  ok: Boolean;
  Count: Integer;
  Name: string;
begin
  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(aName);
  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForSet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
  end
  else if Count < 1 then
  begin
    Exit;
  end;

  ok := True;

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
          s: string := aValue;
        lua_pushstring(FState, Marshall.AsAnsi(s).ToPointer);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FState, aValue);
      end;
    vtBoolean:
      begin
        var
          Bool: LongBool := aValue.AsBoolean;
        lua_pushboolean(FState, Bool);
      end;
  else
    begin
      ok := False;
    end;
  end;

  if ok then
  begin
    if Count > 1 then
    begin
      lua_setfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer)
    end
    else
    begin
      lua_setglobal(FState, Marshall.AsAnsi(Name).ToPointer);
    end;
  end;

  CleanStack;
end;

procedure TLua.RegisterRoutine(const aName: string; aRoutine: TLuaFunction);
var
  method: TMethod;
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  i: Integer;
  Items: TStringArray;
  Count: Integer;
begin
  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aName);

  Count := Length(Items);

  SetLength(Names, Length(Items));

  for i := 0 to High(Items) do
  begin
    Names[i] := Items[i];
  end;

  // init sub table names
  if Count > 1 then
  begin

    // push global table to stack
    if not PushGlobalTableForSet(Names, Index) then
    begin
      CleanStack;
      Exit;
    end;

    // push closure
    method.Code := TMethod(aRoutine).Code;
    method.Data := TMethod(aRoutine).Data;
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, method.Code);
    lua_pushlightuserdata(FState, method.Data);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // add field to table
    lua_setfield(FState, -2, Marshall.AsAnsi(Names[Index]).ToPointer);

    CleanStack;
  end
  else if (Count = 1) then
  begin
    // push closure
    method.Code := TMethod(aRoutine).Code;
    method.Data := TMethod(aRoutine).Data;
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, method.Code);
    lua_pushlightuserdata(FState, method.Data);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // set as global
    lua_setglobal(FState, Marshall.AsAnsi(Names[0]).ToPointer);
  end;
end;

procedure TLua.RegisterRoutine(const aName: string; aData: Pointer; aCode: Pointer);
var
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  i: Integer;
  Items: TStringArray;
  Count: Integer;
begin
  //if aName.IsEmpty then
  if aName = '' then
    Exit;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aName);

  Count := Length(Items);

  SetLength(Names, Length(Items));

  for i := 0 to High(Items) do
  begin
    Names[i] := Items[i];
  end;

  // init sub table names
  if Count > 1 then
  begin

    // push global table to stack
    if not PushGlobalTableForSet(Names, Index) then
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
    lua_setfield(FState, -2, Marshall.AsAnsi(Names[Index]).ToPointer);

    CleanStack;
  end
  else if (Count = 1) then
  begin
    // push closure
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, aCode);
    lua_pushlightuserdata(FState, aData);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // set as global
    lua_setglobal(FState, Marshall.AsAnsi(Names[0]).ToPointer);
  end;
end;

procedure TLua.RegisterRoutines(aClass: TClass);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;

  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
begin
  rttiType := FRttiContext.GetType(aClass);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkClassProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aClass, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      // lua_setfield(FState, -2,  Marshall.AsAnsi(rttiMethod.Name).ToPointer);
      lua_setglobal(FState, Marshall.AsAnsi(rttiMethod.Name).ToPointer);

    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aClass, [Self]);

    // clean up stack
    // Lua_Pop(FState, Lua_GetTop(FState));
    CleanStack;
  end;

end;

procedure TLua.RegisterRoutines(aObject: TObject);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;
  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
begin
  rttiType := FRttiContext.GetType(aObject.ClassType);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aObject.ClassType, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      // lua_setfield(FState, -2,  Marshall.AsAnsi(rttiMethod.Name).ToPointer);
      lua_setglobal(FState, Marshall.AsAnsi(rttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aObject, [Self]);

    // clean up stack
    CleanStack;
  end;

end;

procedure TLua.RegisterRoutines(const aTables: string; aClass: TClass;
  const aTableName: string);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;

  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  TblName: string;
  i: Integer;
  Items: TStringArray;
begin
  // init the routines table name
  //if aTableName.IsEmpty then
  if aTableName = '' then
    TblName := aClass.ClassName
  else
    TblName := aTableName;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aTables);

  // init sub table names
  if Length(Items) > 0 then
  begin
    SetLength(Names, Length(Items) + 2);

    for i := 0 to High(Items) do
    begin
      Names[i] := Items[i];
    end;

    // set last as table name for functions
    Names[i] := TblName;
    Names[i + 1] := TblName;
  end
  else
  begin
    SetLength(Names, 2);
    Names[0] := TblName;
    Names[1] := TblName;
  end;

  // push global table to stack
  if not PushGlobalTableForSet(Names, Index) then
  begin
    CleanStack;
    Exit;
  end;

  rttiType := FRttiContext.GetType(aClass);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkClassProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aClass, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, Marshall.AsAnsi(rttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aClass, [Self]);

    // clean up stack
    // Lua_Pop(FState, Lua_GetTop(FState));
    CleanStack;
  end;

end;

procedure TLua.RegisterRoutines(const aTables: string; aObject: TObject;
  const aTableName: string);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;
  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  TblName: string;
  i: Integer;
  Items: TStringArray;
begin
  // init the routines table name
  //if aTableName.IsEmpty then
  if aTableName = '' then
    TblName := aObject.ClassName
  else
    TblName := aTableName;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aTables);

  // init sub table names
  if Length(Items) > 0 then
  begin
    SetLength(Names, Length(Items) + 2);

    for i := 0 to High(Items) do
    begin
      Names[i] := Items[i];
    end;

    // set last as table name for functions
    Names[i] := TblName;
    Names[i + 1] := TblName;
  end
  else
  begin
    SetLength(Names, 2);
    Names[0] := TblName;
    Names[1] := TblName;
  end;

  // push global table to stack
  if not PushGlobalTableForSet(Names, Index) then
  begin
    CleanStack;
    Exit;
  end;

  rttiType := FRttiContext.GetType(aObject.ClassType);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aObject.ClassType, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = ILuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, Marshall.AsAnsi(rttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aObject, [Self]);

    // clean up stack
    CleanStack;
  end;

end;

procedure TLua.CompileToStream(aFilename: string; aStream: TStream; aCleanOutput: Boolean);
var
  InFilename: string;
  BundleFilename: string;
begin
  InFilename := aFilename;
  BundleFilename := TPath.GetFileNameWithoutExtension(InFilename) +
    '_bundle.lua';

  Bundle(InFilename, BundleFilename);
  LoadFile(PChar(BundleFilename), False);
  SaveByteCode(aStream);
  CleanStack;

  if aCleanOutput then
  begin
    if TFile.Exists(BundleFilename) then
    begin
      TFile.Delete(BundleFilename);
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
