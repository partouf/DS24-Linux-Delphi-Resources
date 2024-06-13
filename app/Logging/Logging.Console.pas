unit Logging.Console;

interface

uses
  Logging.Interfaces,
  System.SysUtils;

type
  TLoggingConsole = class(TInterfacedObject, ILogging)
  private
    procedure LogAll(const LogType: string; const Msg: string); inline;
  public
    procedure Info(const Msg: string);
    procedure Debug(const Msg: string);
    procedure Error(const Msg: string);
  end;

implementation

procedure TLoggingConsole.LogAll(const LogType: string; const Msg: string);
begin
  WriteLn(Format('%s [%s] - %s', [DateTimeToStr(Now), LogType, Msg]));
end;

procedure TLoggingConsole.Info(const Msg: string);
begin
  LogAll('info', Msg);
end;

procedure TLoggingConsole.Debug(const Msg: string);
begin
  LogAll('debug', Msg);
end;

procedure TLoggingConsole.Error(const Msg: string);
begin
  LogAll('error', Msg);
end;

end.
