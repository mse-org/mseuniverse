unit aform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msesimplewidgets,msewidgets;

type
 tafo = class(tdockform)
   tlabel1: tlabel;
 end;
var
 afo: tafo;
implementation
uses
 aform_mfm;
end.
