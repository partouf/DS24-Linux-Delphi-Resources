unit Logging.Interfaces;

interface

type
  ILogging = interface
    ['{4FA253CD-18FB-4BC0-BDEB-499823D7356A}']

    procedure Info(const Msg: string);
    procedure Debug(const Msg: string);
    procedure Error(const Msg: string);
  end;

var
  GLogging: ILogging;

implementation

end.
