unit netlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,
 spiceform;

type
 tnetlistfo = class(tspicefo)
 end;
var
 netlistfo: tnetlistfo;
implementation
uses
 netlistform_mfm;
end.
