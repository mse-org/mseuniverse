unit woptionsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar,
 msesimplewidgets,msegrids,msestrings,keypanelform;
type
 twoptionsfo = class(tkeypanelfo)
   wlang: tstringgrid;
   btnclose: tstockglyphbutton;
   wautocapital: tbooleanedit;
   procedure closeexe(const sender: TObject);
 end;
implementation
uses
 woptionsform_mfm,frmkeyboard;
 
procedure twoptionsfo.closeexe(const sender: TObject);
begin
 frmkeyboardfo.selectpanel(pk_abc);
end;

end.
