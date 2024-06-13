unit Settings;

interface

type
  TSettings = class
  private
    FMssqlDb: string;
    FMssqlPassword: string;
    FMssqlUsername: string;
    FMssqlServer: string;

    FSysLoghost: string;
    FSysLogPort: Integer;

    procedure LoadFromEnv;
    procedure LoadFromIniFile;
  public
    constructor Create;

    procedure SettingsCheck;
    function UseSysLog: Boolean;

    property MssqlServer: string read FMssqlServer;
    property MssqlDb: string read FMssqlDb;
    property MssqlUsername: string read FMssqlUsername;
    property MssqlPassword: string read FMssqlPassword;

    property SysLogHost: string read FSysLogHost;
    property SysLogPort: Integer read FSysLogPort;
  end;

var
  GSettings: TSettings;

implementation

uses
  System.SysUtils, System.IOUtils, System.IniFiles;

const
  StrMSSQLSERVER = 'MSSQL_SERVER';
  StrMSSQLDB = 'MSSQL_DB';
  StrMSSQLUSERNAME = 'MSSQL_USERNAME';
  StrMSSQLPASSWORD = 'MSSQL_PASSWORD';
  StrSYSLOGHOST = 'SYSLOG_HOST';
  StrSYSLOGPORT = 'SYSLOG_PORT';

{ TSettings }

constructor TSettings.Create;
begin
  LoadFromEnv;
  LoadFromIniFile;
end;

procedure TSettings.LoadFromEnv;
begin
  FMssqlServer := GetEnvironmentVariable(StrMSSQLSERVER);
  FMssqlDb := GetEnvironmentVariable(StrMSSQLDB);
  FMssqlUsername := GetEnvironmentVariable(StrMSSQLUSERNAME);
  FMssqlPassword := GetEnvironmentVariable(StrMSSQLPASSWORD);

  FSysLogHost := GetEnvironmentVariable(StrSYSLOGHOST);
  FSysLogPort := StrToIntDef(GetEnvironmentVariable(StrSYSLOGPORT), 0);
end;

procedure TSettings.LoadFromIniFile;
var
  AppRoot: string;
  IniFilepath: string;
begin
  AppRoot := TPath.GetDirectoryName(ParamStr(0));
  IniFilepath := TPath.Combine(AppRoot, 'settings.ini');

  if TFile.Exists(IniFilepath) then
  begin
    var Ini := TIniFile.Create(IniFilepath);
    try
      FMssqlServer := Ini.ReadString('DB', StrMSSQLSERVER, FMssqlServer);
      FMssqlDb := Ini.ReadString('DB', StrMSSQLDB, FMssqlDb);
      FMssqlUsername := Ini.ReadString('DB', StrMSSQLUSERNAME, FMssqlUsername);
      FMssqlPassword := Ini.ReadString('DB', StrMSSQLPASSWORD, FMssqlPassword);
    finally
      Ini.Free;
    end;
  end;
end;

procedure TSettings.SettingsCheck;
begin
  Assert(FMssqlServer <> '', 'MSSQL_SERVER not set');
  Assert(FMssqlDb <> '', 'MSSQL_DB not set');
end;

function TSettings.UseSysLog: Boolean;
begin
  Result := (FSysLogHost <> '') and (FSysLogPort <> 0);
end;

end.
