unit diffwindow;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,
 diffform;

type
 tdiffwindowfo = class(tdifffo)
 end;
var
 diffwindowfo: tdiffwindowfo;
implementation
uses
 diffwindow_mfm;
end.
