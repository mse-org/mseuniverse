unit datamodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules;

type
 tdatamo = class(tmsedatamodule)
 end;
var
 datamo: tdatamo;
implementation
uses
 datamodule_mfm;
end.
