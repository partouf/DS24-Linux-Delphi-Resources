unit DataMod_Database;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Phys.MSSQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TdmDatabase = class(TDataModule)
    drvlinkMSSQL: TFDPhysMSSQLDriverLink;
  private
    { Private declarations }
  public
    { Public declarations }
    function NewConnection: TFDConnection;
  end;

var
  dmDatabase: TdmDatabase;

implementation

uses
  Settings;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TdmDatabase }

function TdmDatabase.NewConnection: TFDConnection;
begin
  Result := TFDConnection.Create(Self);
  Result.LoginPrompt      := False;
  Result.DriverName       := 'MSSQL';

  Result.Params.Add('Server=' + GSettings.MssqlServer);
  Result.Params.Add('Database=' + GSettings.MssqlDb);
  Result.Params.Add('User_Name=' + GSettings.MssqlUsername);
  Result.Params.Add('Password=' + GSettings.MssqlPassword);
  Result.Params.Add('Encrypt=yes');
  Result.Params.Add('MetaDefSchema=dbo');
  Result.Params.Add('MetaDefCatalog=' + GSettings.MssqlDb);
  Result.Params.Add('ODBCAdvanced=TrustServerCertificate=yes');

  WriteLn(Result.Params.Text);

  Result.Open;
end;

end.
