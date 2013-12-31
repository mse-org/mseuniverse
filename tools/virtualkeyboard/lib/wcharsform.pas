unit wcharsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,keypanelform;
type
 twcharsfo = class(tkeypanelfo)
   btnright: tstockglyphbutton;
   btndown: tstockglyphbutton;
   btnleft: tstockglyphbutton;
   btnoptions: tstockglyphbutton;
   btnspace: tstockglyphbutton;
   btnctrl: tstockglyphbutton;
   btnsymbols: tstockglyphbutton;
   btnshift: tstockglyphbutton;
   btnz: tstockglyphbutton;
   btnx: tstockglyphbutton;
   btnc: tstockglyphbutton;
   btnv: tstockglyphbutton;
   btnb: tstockglyphbutton;
   btnn: tstockglyphbutton;
   btnm: tstockglyphbutton;
   btncomma: tstockglyphbutton;
   btnperiod: tstockglyphbutton;
   btnquestion: tstockglyphbutton;
   btnup: tstockglyphbutton;
   btnhide: tstockglyphbutton;
   btnenter2: tstockglyphbutton;
   btnaposthrope: tstockglyphbutton;
   btnl: tstockglyphbutton;
   btnk: tstockglyphbutton;
   btnj: tstockglyphbutton;
   btnh: tstockglyphbutton;
   btng: tstockglyphbutton;
   btnf: tstockglyphbutton;
   btnd: tstockglyphbutton;
   btns: tstockglyphbutton;
   btna: tstockglyphbutton;
   btndel2: tstockglyphbutton;
   btnback2: tstockglyphbutton;
   btnp: tstockglyphbutton;
   btno: tstockglyphbutton;
   btni: tstockglyphbutton;
   btnu: tstockglyphbutton;
   btny: tstockglyphbutton;
   btnt: tstockglyphbutton;
   btnr: tstockglyphbutton;
   btne: tstockglyphbutton;
   btnw: tstockglyphbutton;
   btnq: tstockglyphbutton;
   procedure keybuttonexe(const sender: TObject);
   procedure hideexe(const sender: TObject);
   procedure selectsymbolexe(const sender: TObject);
   procedure selectoptionsexe(const sender: TObject);
   procedure shiftexe(const sender: TObject);
   procedure ctrlexe(const sender: TObject);
  public
   procedure updatebuttons(); override;
 end;
implementation
uses
 wcharsform_mfm,frmkeyboard;
 
procedure twcharsfo.keybuttonexe(const sender: TObject);
begin
 frmkeyboardfo.keybuttonexe(sender);
end;

procedure twcharsfo.hideexe(const sender: TObject);
begin
 frmkeyboardfo.selectpanel(pk_none);
end;

procedure twcharsfo.selectsymbolexe(const sender: TObject);
begin
 frmkeyboardfo.selectpanel(pk_symbol);
end;

procedure twcharsfo.selectoptionsexe(const sender: TObject);
begin
 frmkeyboardfo.selectpanel(pk_options);
end;

procedure twcharsfo.shiftexe(const sender: TObject);
begin
 frmkeyboardfo.shift:= not frmkeyboardfo.shift;
end;

procedure twcharsfo.ctrlexe(const sender: TObject);
begin
 frmkeyboardfo.ctrl:= not frmkeyboardfo.ctrl;
end;

procedure twcharsfo.updatebuttons;
begin
 if frmkeyboardfo.shift then begin
  btnshift.colorglyph:= cl_red;
 end
 else begin
  btnshift.colorglyph:= btnshift.font.color;
 end;
 if frmkeyboardfo.ctrl then begin
  btnctrl.colorglyph:= cl_red;
 end
 else begin
  btnctrl.colorglyph:= btnctrl.font.color;
 end;
end;

end.
