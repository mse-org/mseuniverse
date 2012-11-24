unit spicetabform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,mseact,
 mseactions,mseifiglob;
type
 tspicetabfo = class(ttabform)
   printpanel: taction;
   popupme: tpopupmenu;
   procedure printpanelexe(const sender: TObject);
 end;
 
implementation
uses
 spicetabform_mfm,printwindow;
 
procedure tspicetabfo.printpanelexe(const sender: TObject);
begin
 tprintwindowfo.create(container);
end;

end.
