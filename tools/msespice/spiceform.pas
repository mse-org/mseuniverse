unit spiceform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,mseact,
 mseactions,mseifiglob;

type
 tspicefo = class(tdockform)
   printpanel: taction;
   popupme: tpopupmenu;
   procedure printpanelexe(const sender: TObject);
 end;
var
 spicefo: tspicefo;
implementation
uses
 spiceform_mfm,printwindow;
 
procedure tspicefo.printpanelexe(const sender: TObject);
begin
 tprintwindowfo.create(container);
end;

end.
