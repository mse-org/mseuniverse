unit subform2;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets;
type
 tsubform2fo = class(tmseform)
   tlabel1: tlabel;
 end;
implementation
uses
 subform2_mfm;
end.
