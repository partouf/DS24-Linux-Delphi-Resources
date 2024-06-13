unit MVCServer;

interface

uses
  MVCFramework,
  MVCFramework.DotEnv,
  MVCFramework.Commons,
  MVCFramework.Signal,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdContext,
  IdHTTPWebBrokerBridge;

type
  TMVCServer = class
  public
    class procedure Start;
  end;

implementation

uses
  MyWebmodule,
  System.SysUtils,
  Logging.Interfaces;

{ TMVCServer }

class procedure TMVCServer.Start;
var
  LServer: TIdHTTPWebBrokerBridge;
begin
  IsMultiThread := True;

  MVCSerializeNulls := False;

  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := TMyWebModule;

  dotEnvConfigure(
    function: IMVCDotEnv
    begin
      Result := NewDotEnv
               .UseStrategy(TMVCDotEnvPriority.FileThenEnv)
               .UseLogger(procedure(LogItem: String)
                          begin
                            GLogging.Info('dotEnv: ' + LogItem);
                          end)
               .Build();
    end);

  WebRequestHandlerProc.MaxConnections := dotEnv.Env('dmvc.handler.max_connections', 1024);

  GLogging.Info('** DMVCFramework Server ** build ' + DMVCFRAMEWORK_VERSION);
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;
    LServer.DefaultPort := 80;
    LServer.KeepAlive := True;
    LServer.MaxConnections := dotEnv.Env('dmvc.webbroker.max_connections', 0);
    LServer.ListenQueue := dotEnv.Env('dmvc.indy.listen_queue', 500);

    LServer.Active := True;
    GLogging.Info('Listening on port ' + IntToStr(LServer.DefaultPort));

    WaitForTerminationSignal;

    EnterInShutdownState;

    LServer.Active := False;
  finally
    LServer.Free;
  end;
end;

end.
