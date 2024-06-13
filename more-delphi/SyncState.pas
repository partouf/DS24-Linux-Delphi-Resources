unit SyncState;

interface

uses
  System.SyncObjs;

type
  TSyncState = class
  protected
    FLock: TCriticalSection;
    FLastLocked: TDateTime;
    FLastReleased: TDateTime;
    FCurrentlyLocked: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Acquire;
    procedure Release;

    property LastLocked: TDateTime read FLastLocked;
    property LastReleased: TDateTime read FLastReleased;
    property CurrentlyLocked: Boolean read FCurrentlyLocked;
  end;

var
  GSyncState: TSyncState;

implementation

uses
  System.SysUtils;

{ TSyncState }

procedure TSyncState.Acquire;
begin
  FLock.Acquire;
  FLastLocked := Now;
  FCurrentlyLocked := True;
end;

constructor TSyncState.Create;
begin
  FLock := TCriticalSection.Create;
end;

destructor TSyncState.Destroy;
begin
  FreeAndNil(FLock);

  inherited;
end;

procedure TSyncState.Release;
begin
  FCurrentlyLocked := False;
  FLastReleased := Now;
  FLock.Release;
end;

initialization
  GSyncState := TSyncState.Create;

finalization
  FreeAndNil(GSyncState);

end.