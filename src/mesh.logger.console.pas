unit mesh.logger.console;

{$mode delphi}

interface

uses
  Classes,
  SysUtils,
  mesh.logger;

type

  { IConsoleLogger }
  (*
    logger specific to console apps (writes to std out)
  *)
  IConsoleLogger = interface
    ['{57FC7B65-8323-47A2-8711-C40A9843425C}']
  end;

  { TConsoleLoggerImpl }
  (*
    console based logger implementation
  *)
  TConsoleLoggerImpl = class(TLoggerImpl,IConsoleLogger)
  public
    const
      LOG_FORMAT = '[%s] - %s - %s'; //type - time - message
      PREFIX_INFO = 'INFO';
      PREFIX_WARN = 'WARN';
      PREFIX_ERROR = 'ERROR';
  strict protected
    procedure DoLogError(const AMessage: String); override;
    procedure DoLogInfo(const AMessage: String); override;
    procedure DoLogWarning(const AMessage: String); override;

    procedure LogEntry(Const APrefix, AMessage : String);
  public
  end;

implementation

{ TConsoleLoggerImpl }

procedure TConsoleLoggerImpl.DoLogError(const AMessage: String);
begin
  LogEntry(PREFIX_ERROR, AMessage);
end;

procedure TConsoleLoggerImpl.DoLogInfo(const AMessage: String);
begin
  LogEntry(PREFIX_INFO, AMessage);
end;

procedure TConsoleLoggerImpl.DoLogWarning(const AMessage: String);
begin
  LogEntry(PREFIX_WARN, AMessage);
end;

procedure TConsoleLoggerImpl.LogEntry(const APrefix, AMessage: String);
begin
  WriteLn(Format(LOG_FORMAT, [APrefix, DateToStr(Now), AMessage]));
end;

end.

