unit mesh.serialize.json;

{$mode delphi}

interface

uses
  Classes,
  SysUtils,
  fpjson,
  jsonparser,
  mesh.types,
  mesh.serialize;

type

  (*
    specialized json serialization
  *)
  IJSONSerialize = interface(ISerialize)
    ['{0B65F743-DE5A-46CF-B35A-26069FB57683}']
    function ToJSON (Out Success:Boolean; Out Error:String): String;
  end;

  { TJSONSerialize }
  (*
    specialized json serializer base class
  *)
  TJSONSerialize = class(TSerializeImpl)
  strict protected
    function DoSerialize(Out Success: Boolean;
      Out Error: String): String;override;
    function DoToJSON (Const AResult:TJSONObject;
      Out Error:String): Boolean;virtual;abstract;
  public
    function ToJSON (Out Success:Boolean; Out Error:String): String;
  end;

implementation

{ TJSONSerialize }

function TJSONSerialize.DoSerialize(out Success: Boolean;
  out Error: String): String;
begin
  Result:=ToJSON(Success, Error);
end;

function TJSONSerialize.ToJSON(out Success: Boolean; out Error: String): String;
var
  LObj:TJSONObject;
begin
  Result:='';

  //create out result json object
  LObj:=TJSONObject.Create;
  try
    Success:=DoToJSON(LObj, Error);
    Result:=LObj.AsJSON;
  finally
    LObj.Free;
  end;
end;
end.

