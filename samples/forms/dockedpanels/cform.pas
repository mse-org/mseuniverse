unit cform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msesimplewidgets,msewidgets;

type
 tcfo = class(tdockform)
   tlabel1: tlabel;
 end;
var
 cfo: tcfo;
implementation
uses
 cform_mfm;
end.
