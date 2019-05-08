{ mesh

  Copyright (c) 2019 mr-highball

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
}

(*
  this unit contains common types/classes/consts used throughout the library.
  if a class can be broken out to it's own namespace, it should be for
  readability
*)
unit mesh.types;

{$mode delphi}

interface

uses
  Classes,
  SysUtils,
  fgl;

type

  { ISerialize }
  (*
    provides contract for serializable objects
  *)
  ISerialize = interface
    ['{8F9BCBC3-8410-4A87-A518-A36DAA3F7FB4}']
    function Serialize(Out Success:Boolean; Out Error:String): String;
  end;

  { ILogger }
  (*
    provides contract for objects that can log
  *)
  ILogger = interface
    ['{FF5CBD92-D96D-4D25-844B-B50D41ADA5E7}']
    procedure LogInfo(Const AMessage : String);
    procedure LogWarning(Const AMessage : String);
    procedure LogError(Const AMessage : String);
  end;

  (*
    currently a signal maps to a byte, this might change...
  *)
  TSignal = Byte;
  PSignal = ^TSignal;

  (*
    offer various collections for signals
  *)
  TSignalArray = TArray<TSignal>;
  PSignalArray = ^TSignalArray;
  TSignalList = TFPGList<TSignal>;
  TSignalMap<T> = class(TFPGMap<T,TSignal>)
  end;

  (*
    enumeration for all the signals
  *)
  TSignalDesignator = (
    sdA,
    sdB,
    sdC,
    sdD,
    sdE
  );

  TSignalDesignators = set of TSignalDesignator;

  { TPatternItem }
  (*
    structure for holding just enough info about a signal to form a pattern
  *)
  TPatternItem = packed record
  strict private
    FDesignator: TSignalDesignator;
    FSignal: TSignal;
    procedure SetSignal(Const AValue: TSignal);
  public
    property Signal : TSignal read FSignal write SetSignal;
    property Designator : TSignalDesignator read FDesignator;

    class operator Equal(Const A,B : TPatternItem):Boolean;
    constructor Create(Const ASignal : TSignal);
  end;

  PPatternItem = ^TPatternItem;

  (*
    offer various collection types for pattern items. a collection
    of pattern items forms a single pattern
  *)
  TPatternItemArray = TArray<TPatternItem>;
  PPatternItemArray = ^TPatternItemArray;
  TPatternItemList = TFPGList<TPatternItem>;
  TPatternItemMap<T> = class(TFPGMap<T,TPatternItem>)
  end;

  (*
    collections of patterns
  *)
  //array of arrays for copying
  TPatternArray = TArray<TPatternItemArray>;

  //array of pointer to array for speed
  TPatternPArray = TArray<PPatternItemArray>;

  //list of lists for convenience
  TPatternList = TFPGList<TPatternItemList>;

  //maps for who knows what spice
  TPatternArrayMap<T> = class(TFPGMap<T,TPatternArray>)
  end;
  TPatternListMap<T> = class(TFPGMap<T,TPatternList>)
  end;


  { IPatterns }
  (*

  *)
  IPatterns = interface
    ['{4C40548F-D4CF-4707-A98E-0F9B4F88EE6A}']
    //property methods
    function GetPatterns: TPatternList;

    //properties
    property Collection : TPatternList read GetPatterns;
  end;

  (*
    setup the ranges based on the size of signal and the total signals
  *)
  TSigARange = Low(TSignal)..(High(TSignal) div 5) - 1;
  TSigBRange = Succ(High(TSigARange))..Succ(High(TSigARange)) + High(TSignal) div 5;
  TSigCRange = Succ(High(TSigBRange))..Succ(High(TSigBRange)) + High(TSignal) div 5;
  TSigDRange = Succ(High(TSigCRange))..Succ(High(TSigCRange)) + High(TSignal) div 5;
  TSigERange = Succ(High(TSigDRange))..High(TSignal);

  //forward
  IConnector = interface;
  TConnectors = TFPGInterfacedObjectList<IConnector>;

  { IConnectors }
  (*
    collection of IConnector for easier use
  *)
  IConnectors = interface
    ['{A1605798-7A33-485E-93D5-A91EDED46DCF}']
    //property methods
    function GetCollection: TConnectors;
    function GetSerial: ISerialize;

    //properties
    property Serialize : ISerialize read GetSerial;
    property Collection : TConnectors read GetCollection;

    //methods
    { TODO -ohighball : once connector is spec'd out, add some helper methods }
  end;

  { INode }
  (*
    main worker unit inside of a mesh network
  *)
  INode = interface
    ['{7E764B4C-83FF-4C95-BE5A-FA5C618845C1}']
    //property methods
    function GetSerial: ISerialize;
    function GetConnectors: IConnectors;
    function GetPatterns: IPatterns;
    function GetSignal: TSignal;

    //properties
    property Serialize : ISerialize read GetSerial;
    property Connectors : IConnectors read GetConnectors;
    property Patterns : IPatterns read GetPatterns;
    property Signal : TSignal read GetSignal;

    //methods
    (*
      adds a signal to the current signal value
    *)
    procedure Charge(Const ASignal : TSignal);

    (*
      reduces the current signal value by input
    *)
    procedure Discharge(Const ASignal : TSignal);
  end;

  { IConnector }
  (*
    connects nodes together
  *)
  IConnector = interface
    ['{6BF6F8C7-97B3-4A8C-B608-658E3D38C36E}']
    //property methods
    function GetSerial: ISerialize;

    //properties
    property Serialize : ISerialize read GetSerial;
  end;

  { IMesh }
  (*
    a network of nodes
  *)
  IMesh = interface
    ['{D8E79ABE-6DA7-4E3F-9A7F-CC71F17F4AA6}']
    //property methods
    function GetSerial: ISerialize;

    //properties
    property Serialize : ISerialize read GetSerial;
  end;

  (*
    will provide the upper and lower bounds for a given signal designator
  *)
  procedure RangeForSignal(Const ADesignator:TSignalDesignator;
    Out Lower, Upper : TSignal);

  (*
    maps a signal to a designator
  *)
  function DesignatorForSignal(Const ASignal:TSignal): TSignalDesignator;

var
  (*
    a default logger that classes can optionally use
  *)
  DefaultLogger : ILogger;

implementation
uses
  mesh.logger.console;

procedure RangeForSignal(const ADesignator: TSignalDesignator; out Lower,
  Upper: TSignal);
begin
  //return the upper and lower for the given designator
  case ADesignator of
    sdA:
      begin
        Lower:=Low(TSigARange);
        Upper:=High(TSigARange);
      end;
    sdB:
      begin
        Lower:=Low(TSigBRange);
        Upper:=High(TSigBRange);
      end;
    sdC:
      begin
        Lower:=Low(TSigCRange);
        Upper:=High(TSigCRange);
      end;
    sdD:
      begin
        Lower:=Low(TSigDRange);
        Upper:=High(TSigDRange);
      end;
    sdE:
      begin
        Lower:=Low(TSigERange);
        Upper:=High(TSigERange);
      end;
  end;
end;

function DesignatorForSignal(const ASignal: TSignal): TSignalDesignator;
begin
  if ASignal <= High(TSigARange) then
    Exit(sdA)
  else if (ASignal >= Low(TSigBRange)) and (ASignal <= High(TSigBRange)) then
    Exit(sdB)
  else if (ASignal >= Low(TSigCRange)) and (ASignal <= High(TSigCRange)) then
    Exit(sdC)
  else if (ASignal >= Low(TSigDRange)) and (ASignal <= High(TSigDRange)) then
    Exit(sdD)
  else
    Exit(sdE);
end;

{ TPatternItem }

procedure TPatternItem.SetSignal(const AValue: TSignal);
begin
  if FSignal=AValue then
    Exit;
  FSignal:=AValue;
  FDesignator:=DesignatorForSignal(AValue);
end;

class operator TPatternItem.Equal(const A, B: TPatternItem): Boolean;
begin
  Result:=(A.Designator = B.Designator) and (A.Signal = B.Signal);
end;

constructor TPatternItem.Create(const ASignal: TSignal);
begin
  SetSignal(ASignal);
end;

initialization
  //setup the default logger as the console logger
  { TODO -ohighball : choose a logger depending on console/ui or more advanced logger }
  DefaultLogger:=TConsoleLoggerImpl.Create;

finalization
  DefaultLogger:=nil;
end.

