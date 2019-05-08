unit mesh.logger;

{$mode delphi}

interface

uses
  Classes,
  SysUtils,
  mesh.types;

type

  { TLoggerImpl }
  (*
    base class for an ILogger
  *)
  TLoggerImpl = class(TInterfacedObject,ILogger)
  strict private
  strict protected
    procedure DoLogInfo(Const AMessage : String);virtual;abstract;
    procedure DoLogWarning(Const AMessage : String);virtual;abstract;
    procedure DoLogError(Const AMessage : String);virtual;abstract;
  public
    procedure LogInfo(Const AMessage : String);
    procedure LogWarning(Const AMessage : String);
    procedure LogError(Const AMessage : String);

    constructor Create;virtual;overload;
  end;

implementation

{ TLoggerImpl }

procedure TLoggerImpl.LogInfo(const AMessage: String);
begin
  DoLogInfo(AMessage);
end;

procedure TLoggerImpl.LogWarning(const AMessage: String);
begin
  DoLogWarning(AMessage);
end;

procedure TLoggerImpl.LogError(const AMessage: String);
begin
  DoLogError(AMessage);
end;

constructor TLoggerImpl.Create;
begin
  //nothing in base
end;

end.

