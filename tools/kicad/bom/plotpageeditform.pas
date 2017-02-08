unit plotpageeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 docupageeditform,plotsettings;

type
 tplotpageeditfo = class(tdocupageeditfo)
   plotsettingsfo1: tplotsettingsfo;
 end;
var
 plotpageeditfo: tplotpageeditfo;
implementation
uses
 plotpageeditform_mfm;
end.
