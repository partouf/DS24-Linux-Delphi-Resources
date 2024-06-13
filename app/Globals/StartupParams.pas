unit StartupParams;

interface

type
  TStartupParams = class
  public
    class procedure Check;
    class procedure CheckDatabaseConnection;
  end;

implementation

uses
  System.SysUtils,
  DataMod_Database,
  FireDAC.Comp.Client,
  Logging.Interfaces,
  Settings, MVCServer;

class procedure TStartupParams.CheckDatabaseConnection;
var
  Connection: TFDConnection;
begin
  Connection := dmDatabase.NewConnection;
  try
    if not Connection.Connected then
      raise Exception.Create('Unable to reach database');
  finally
    Connection.Free;
  end;
end;

procedure TestDatabaseConnection;
var
  Connection: TFDConnection;
begin
  Connection := dmDatabase.NewConnection;
  try
    if Connection.Connected then
    begin
      GLogging.Info('Connection succeeded');
      Halt(0);
    end
    else
    begin
      GLogging.Error('Connection failed');
      Halt(1);
    end;
  finally
    Connection.Free;
  end;
end;

class procedure TStartupParams.Check;
var
  IdxParam: Integer;
  CurrentParam: string;
begin
  for IdxParam := 1 to ParamCount do
  begin
    CurrentParam := ParamStr(IdxParam);

    if SameText(CurrentParam, '--version') then
    begin
      Halt(0);
    end;

    if SameText(CurrentParam, '--check') then
    begin
      Assert(Assigned(GSettings), 'App not initialized correctly');

      GSettings.SettingsCheck;

      Exit;
    end;

    if SameText(CurrentParam, '--dbtest') then
    begin
      TestDatabaseConnection;

      Exit;
    end;
  end;

  TMVCServer.Start;
end;

end.
