unit bigform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,
 baseform;

type
 tbigfo = class(tbasefo)
 end;
var
 bigfo: tbigfo;
implementation
uses
 bigform_mfm;
end.
