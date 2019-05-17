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
unit mesh.connectors;

{$mode delphi}

interface

uses
  Classes,
  SysUtils,
  mesh.types,
  mesh.serialize.json,
  fpjson,
  jsonparser;

type

  { TConnectorsImpl }
  (*
    base implementation for IConnectors using json as primary
    means of serialization
  *)
  TConnectorsImpl = class(TJSONSerialize,IConnectors)
  public
    const
      PROP_COLLECTION = 'collection';
  strict private
    FCollection : TConnectors;
  private
    function GetCollection: TConnectors;
    function GetSerial: ISerialize;
  strict protected
    function DoToJSON(const AResult: TJSONObject;
      out Error: String): Boolean;override;
  public
    property Serialize : ISerialize read GetSerial;
    property Collection : TConnectors read GetCollection;
  end;

implementation

{ TConnectorsImpl }

function TConnectorsImpl.GetCollection: TConnectors;
begin
  Result:=FCollection;
end;

function TConnectorsImpl.GetSerial: ISerialize;
begin
  Result:=Self as ISerialize;
end;

function TConnectorsImpl.DoToJSON(const AResult: TJSONObject;
  out Error: String): Boolean;
var
  LResult: TJSONArray;
  I: Integer;
  LSuccess: Boolean;
  LCollector: String;
begin
  Result:=False;
  LResult:=TJSONArray.Create;
  try
    try
      //iterate over the collection and add the serialized version to the array
      for I := 0 to Pred(FCollection.Count) do
      begin
        //get the string representation of this object
        LCollector:=FCollection[I].Serialize.Serialize(LSuccess,Error);

        //we weren't able to serialize this collector
        if not LSuccess then
          Exit;

        //add a json object to the array
        LResult.Add(GetJSON(LCollector));
      end;

      //if we make it here with no errors, then serialize the result to string
      //and parse to an object so we can free our local array ourselves
      AResult.Add(PROP_COLLECTION,GetJSON(LResult.AsJSON));
      Result:=True;
    except on E:Exception do
      Error:=E.Message;
    end;
  finally
    LResult.Free;
  end;
end;

end.

