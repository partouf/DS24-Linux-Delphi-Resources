unit Daemon;

interface

{$ifdef Linux64}
uses
  Posix.Stdlib, Posix.SysStat, Posix.SysTypes, Posix.Unistd, Posix.Signal, Posix.Fcntl, System.SysUtils,
  IdSysLog, IdSysLogMessage, System.Classes;

// mostly from https://blog.paolorossi.net/building-a-real-linux-daemon-with-delphi-part-2/

type
  TDaemonAndFork = class
  private
    FPID: pid_t;
    FDevNull: Integer;
    FOnDoSomething: TProc;

    procedure ForkAway;
    procedure ForkMe;
  public
    constructor Create;
    destructor Destroy; override;

    property OnDoSomething: TProc read FOnDoSomething write FOnDoSomething;
    procedure Terminate;

    procedure Execute;
  end;

  EDaemonAndForkError = class(Exception);

var
  GDaemonInfo: TDaemonAndFork;

{$endif}

implementation

uses
  Logging.Interfaces;

{$ifdef Linux64}
const
  LOG_PID = 1;
  LOG_NDELAY = 2;
  LOG_DAEMON = 3;


procedure HandleSignals(SigNum: Integer); cdecl;
begin
  case SigNum of
    SIGTERM:
      begin
        GDaemonInfo.Terminate;
      end;
    SIGHUP:
      begin
        GLogging.Info('daemon: reloading config');
        // todo: Reload configuration once we have any
      end;
  end;
end;

{ TDaemonAndFork }

constructor TDaemonAndFork.Create;
begin
  if getppid() > 1 then
  begin
    ForkAway;
  end;
end;

destructor TDaemonAndFork.Destroy;
begin
  inherited;
end;

procedure TDaemonAndFork.Terminate;
begin
  FRunning := False;
end;

procedure TDaemonAndFork.ForkMe;
begin
  FPID := fork();
  if FPID < 0 then
    raise EDaemonAndForkError.Create('Error forking the process');

  if FPID > 0 then
    Halt(EXIT_SUCCESS);
end;

procedure TDaemonAndFork.Execute;
begin
  FRunning := True;
  try
    while FRunning do
    begin
      if Assigned(FOnDoSomething) then
        FOnDoSomething();

      Sleep(1000);
    end;

    ExitCode := EXIT_SUCCESS;
  except
    on E: Exception do
    begin
      GLogging.Error('Error: ' + E.Message);
      ExitCode := EXIT_FAILURE;
    end;
  end;

  GLogging.Info('daemon stopped');
end;

procedure TDaemonAndFork.ForkAway;
begin
  ForkMe;

  if setsid() < 0 then
    raise EDaemonAndForkError.Create('Impossible to create an independent session');

  Signal(SIGCHLD, TSignalHandler(SIG_IGN));
  Signal(SIGHUP, HandleSignals);
  Signal(SIGTERM, HandleSignals);

  ForkMe;

  for var idx := sysconf(_SC_OPEN_MAX) downto 0 do
    __close(idx);

  FDevNull := __open('/dev/null', O_RDWR);
  dup(FDevNull);
  dup(FDevNull);

  umask(027);

  chdir('/tmp');
end;

{$endif}

end.