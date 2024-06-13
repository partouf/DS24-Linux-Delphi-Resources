program ds24_app;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DataMod_Database in 'Globals\DataMod_Database.pas' {dmDatabase: TDataModule},
  Settings in 'Globals\Settings.pas',
  Globals in 'Globals\Globals.pas',
  StartupParams in 'Globals\StartupParams.pas',
  Logging.Interfaces in 'Logging\Logging.Interfaces.pas',
  Logging.SysLog in 'Logging\Logging.SysLog.pas',
  Logging.Console in 'Logging\Logging.Console.pas',
  Books.Controller in 'Books\Books.Controller.pas',
  Books.Models in 'Books\Books.Models.pas',
  Books.Queries in 'Books\Books.Queries.pas',
  MVCServer in 'Globals\MVCServer.pas',
  MyWebmodule in 'MyWebmodule.pas' {MyWebModule: TWebModule},
  Checks.Controller in 'Checks\Checks.Controller.pas';

{$INCLUDE version.inc}

begin
  try
    GLogging.Info('ds24_app version ' + C_COMMITHASH_MAIN);

    TStartupParams.Check;
  except
    on E: Exception do
      GLogging.Error(E.ClassName + ': ' + E.Message);
  end;
end.
