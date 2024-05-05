unit smallform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,
 baseform;

type
 tsmallfo = class(tbasefo)
 end;
var
 smallfo: tsmallfo;
implementation
uses
 smallform_mfm;
end.
