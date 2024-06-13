unit Globals;

interface

implementation

uses
  System.SysUtils,
  DataMod_Database,
  Logging.Interfaces,
  Logging.Console,
  Logging.SysLog,
  Settings;

procedure InitGlobals;
begin
  FormatSettings := TFormatSettings.Create('nl-NL');
  GSettings := TSettings.Create;

  if GSettings.UseSysLog then
    GLogging := TLoggingSysLog.Create
  else
    GLogging := TLoggingConsole.Create;

  dmDatabase := TdmDatabase.Create(nil);
end;

procedure FiniGlobals;
begin
  FreeAndNil(dmDatabase);
  FreeAndNil(GSettings);
end;

initialization
  InitGlobals;
finalization
  FiniGlobals;
end.
