unit form1;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 baseform;

type
 tform1fo = class(tbasefo)
 end;
var
 form1fo: tform1fo;
implementation
uses
 form1_mfm;
end.
