unit baseform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock;

type
 tbasefo = class(tdockform)
 end;
var
 basefo: tbasefo;
implementation
uses
 baseform_mfm;
end.
