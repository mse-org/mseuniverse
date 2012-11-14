unit spiceform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock;

type
 tspicefo = class(tdockform)
 end;
var
 spicefo: tspicefo;
implementation
uses
 spiceform_mfm;
end.
