unit skinmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,
 guitemplates;

type
 tskinmo = class(tguitemplatesmo)
 end;
var
 skinmo: tskinmo;
implementation
uses
 skinmodule_mfm;
initialization
 application.createdatamodule(tskinmo,skinmo);
end.
