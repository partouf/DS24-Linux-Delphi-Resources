unit Logging.SysLog;

interface

uses
  Logging.Interfaces,
  IdSysLog;

type
  TLoggingSysLog = class(TInterfacedObject, ILogging)
  private
    FSysLog: TIdSysLog;

    procedure InitIfNeeded;
  public
    destructor Destroy; override;

    procedure Info(const Msg: string);
    procedure Debug(const Msg: string);
    procedure Error(const Msg: string);
  end;

implementation

uses
  IdSysLogMessage,
  System.SysUtils,
  Settings;

destructor TLoggingSysLog.Destroy;
begin
  FreeAndNil(FSysLog);
end;

procedure TLoggingSysLog.InitIfNeeded;
begin
  if not Assigned(FSysLog) then
  begin
    FSysLog := TIdSysLog.Create;

    FSysLog.Host := GSettings.SysLogHost;
    FSysLog.Port := GSettings.SysLogPort;
    FSysLog.Active := True;
  end;
end;

procedure TLoggingSysLog.Info(const Msg: string);
begin
  InitIfNeeded;

  // https://github.com/IndySockets/Indy/blob/3aec742e3cfea3351f1f040a7c217290071fefdb/Lib/Protocols/IdSysLogMessage.pas#L77
  FSysLog.SendLogMessage('info ' + Msg, sfUserLevel, slInformational);
end;

procedure TLoggingSysLog.Debug(const Msg: string);
begin
  InitIfNeeded;

  FSysLog.SendLogMessage('debug ' + Msg, sfUserLevel, slDebug);
end;

procedure TLoggingSysLog.Error(const Msg: string);
begin
  InitIfNeeded;

  FSysLog.SendLogMessage('error ' + Msg, sfUserLevel, slError);
end;

end.