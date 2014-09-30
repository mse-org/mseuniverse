unit runform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms;
type
 trunfo = class(tmseform)
 end;
var
 runfo: trunfo;
implementation
uses
 runform_mfm;
end.
