unit mesh.serialize;

{$mode delphi}

interface

uses
  Classes,
  SysUtils,
  mesh.types;

type

  { TSerializeImpl }
  (*
    base impl class for serialization
  *)
  TSerializeImpl = class(TInterfacedObject)
  strict private
  strict protected
    function DoSerialize(Out Success:Boolean;
      Out Error:String) : String;virtual;abstract;
  public
    function Serialize(Out Success:Boolean; Out Error:String): String;
    constructor Create;virtual;
  end;

implementation

{ TSerializeImpl }

function TSerializeImpl.Serialize(out Success: Boolean; out Error: String): String;
begin
  Result:=DoSerialize(Success, Error);
end;

constructor TSerializeImpl.Create;
begin
  //nothing in base
end;
end.

