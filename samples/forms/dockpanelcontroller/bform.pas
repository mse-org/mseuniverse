unit bform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msesimplewidgets,msewidgets;

type
 tbfo = class(tdockform)
   tlabel1: tlabel;
 end;
var
 bfo: tbfo;
implementation
uses
 bform_mfm;
end.
