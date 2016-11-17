unit basereppage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msereport;

type
 tbasereppa = class(treppageform)
 end;
var
 basereppa: tbasereppa;
implementation
uses
 basereppage_mfm;
end.
