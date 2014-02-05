unit dform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msesimplewidgets,msewidgets;

type
 tdfo = class(tdockform)
   tlabel1: tlabel;
 end;
var
 dfo: tdfo;
implementation
uses
 dform_mfm;
end.
