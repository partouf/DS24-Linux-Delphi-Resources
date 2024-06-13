unit Linux-Exec;

interface

uses
  {$ifdef Linux64}
  Posix.Base,
  Posix.Stdio,
  {$endif}
  System.SysUtils;

type
  TStreamHandle = pointer;

{$ifdef Linux64}
// http://man7.org/linux/man-pages/man3/popen.3.html
function popen(const command: MarshaledAString; const _type: MarshaledAString): TStreamHandle; cdecl; external libc name _PU + 'popen';
{$EXTERNALSYM popen}

// http://man7.org/linux/man-pages/man3/pclose.3p.html
function pclose(filehandle: TStreamHandle): int32; cdecl; external libc name _PU + 'pclose';
{$EXTERNALSYM pclose}
{$endif}

implementation

end.
