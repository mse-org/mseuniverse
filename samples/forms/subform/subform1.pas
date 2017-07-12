unit subform1;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets;
type
 tsubform1fo = class(tmseform)
   tlabel1: tlabel;
 end;
implementation
uses
 subform1_mfm;
end.
