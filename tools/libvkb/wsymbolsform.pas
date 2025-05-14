unit wsymbolsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,keypanelform;
type
 twsymbolsfo = class(tkeypanelfo)
   btngreater: tstockglyphbutton;
   btnparenright: tstockglyphbutton;
   btndoublequote: tstockglyphbutton;
   btntilde: tstockglyphbutton;
   btnsection: tstockglyphbutton;
   btnless: tstockglyphbutton;
   btnleft2: tstockglyphbutton;
   btnright2: tstockglyphbutton;
   btnspace2: tstockglyphbutton;
   btnleftbracket: tstockglyphbutton;
   btnrightbracket: tstockglyphbutton;
   btnleftbrace: tstockglyphbutton;
   btnrightbrace: tstockglyphbutton;
   btnvertbar: tstockglyphbutton;
   btnplus: tstockglyphbutton;
   btnbackslash: tstockglyphbutton;
   btnsemicolon: tstockglyphbutton;
   btncolon: tstockglyphbutton;
   btndollar: tstockglyphbutton;
   btnpercent: tstockglyphbutton;
   btnampersand: tstockglyphbutton;
   btnparenleft: tstockglyphbutton;
   btntab: tstockglyphbutton;
   btneclam: tstockglyphbutton;
   btnat: tstockglyphbutton;
   btnnumsign: tstockglyphbutton;
   btnequal: tstockglyphbutton;
   btnUnderscore: tstockglyphbutton;
   btnminus: tstockglyphbutton;
   btnprev: tstockglyphbutton;
   btnnext: tstockglyphbutton;
   btnasterisk: tstockglyphbutton;
   btnslash: tstockglyphbutton;
   btnabc: tstockglyphbutton;
   btncaret: tstockglyphbutton;
   procedure keybuttonexe(const sender: TObject);
   procedure selctabcexe(const sender: TObject);
 end;
implementation
uses
 wsymbolsform_mfm,frmkeyboard;
 
procedure twsymbolsfo.keybuttonexe(const sender: TObject);
begin
 frmkeyboardfo.keybuttonexe(sender);
end;

procedure twsymbolsfo.selctabcexe(const sender: TObject);
begin
 frmkeyboardfo.selectpanel(pk_abc);
end;

end.
