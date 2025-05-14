unit wnumbersform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,keypanelform;
type
 twnumbersfo = class(tkeypanelfo)
   btn0: tstockglyphbutton;
   btndec: tstockglyphbutton;
   btnenter: tstockglyphbutton;
   btnhide2: tstockglyphbutton;
   btn9: tstockglyphbutton;
   btn8: tstockglyphbutton;
   btn7: tstockglyphbutton;
   btndel: tstockglyphbutton;
   btn6: tstockglyphbutton;
   btn5: tstockglyphbutton;
   btn4: tstockglyphbutton;
   btnback: tstockglyphbutton;
   btn3: tstockglyphbutton;
   btn2: tstockglyphbutton;
   btn1: tstockglyphbutton;
   procedure hideexe(const sender: TObject);
   procedure keybuttonexe(const sender: TObject);
  public
   procedure updatebuttons(); override;
 end;
 
implementation
uses
 wnumbersform_mfm,frmkeyboard;
 
procedure twnumbersfo.hideexe(const sender: TObject);
begin
 frmkeyboardfo.selectpanel(pk_none);
end;

procedure twnumbersfo.keybuttonexe(const sender: TObject);
begin
 frmkeyboardfo.keybuttonexe(sender);
end;

procedure twnumbersfo.updatebuttons;
begin
 btndec.visible:= frmkeyboardfo.widgetkind <> wik_integer;
end;

end.
