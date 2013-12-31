unit keypanelform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms;
type
 tkeypanelfo = class(tsubform)
  public
   procedure updatebuttons(); virtual;
 end;
implementation
uses
 keypanelform_mfm;

{ tkeypanelfo }

procedure tkeypanelfo.updatebuttons;
begin
 //dummy
end;

end.
