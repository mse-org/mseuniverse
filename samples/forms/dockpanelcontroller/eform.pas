unit eform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msesimplewidgets,msewidgets;

type
 tefo = class(tdockform)
   tlabel1: tlabel;
 end;
var
 efo: tefo;
implementation
uses
 eform_mfm;
end.
