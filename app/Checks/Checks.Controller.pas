unit Checks.Controller;

interface

uses
  MVCFramework,
  MVCFramework.Commons;

type
  [MVCPath('/checks')]
  TChecksController = class(TMVCController)
  public
    [MVCPath('/health')]
    [MVCProduces('text/plain')]
    [MVCHTTPMethod([httpGET])]
    function Health: string;
  end;

implementation

uses
  StartupParams;

{ TChecksController }

function TChecksController.Health: string;
begin
  TStartupParams.CheckDatabaseConnection;

  Result := 'OK';
end;

end.
