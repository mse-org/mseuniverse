unit woptionsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar,
 msesimplewidgets,msegrids,msestrings,keypanelform,msedataedits,mseedit;
type
 twoptionsfo = class(tkeypanelfo)
   wlang: tstringgrid;
   btnclose: tstockglyphbutton;
   wautocapital: tbooleanedit;
   procedure closeexe(const sender: TObject);
   procedure form_onloaded(const sender: TObject);
   procedure wlang_oncellevent(const sender: TObject;
                   var info: celleventinfoty);
 end;
implementation
uses
 woptionsform_mfm,frmkeyboard,keybindings,msegridsglob;
 
procedure twoptionsfo.closeexe(const sender: TObject);
begin
 frmkeyboardfo.selectpanel(pk_abc);
end;

procedure twoptionsfo.form_onloaded(const sender: TObject);
begin
 wlang.appendrow(['US', 'US Keyboard']);
 wlang.appendrow(['DE', 'Deutch']);
 wlang.appendrow(['RU', #1056#1091#1089#1089#1082#1072#1103]);
 wlang.appendrow(['UZ', 'Uzbek-Cyrillic']);
 wlang.appendrow(['FR', 'French']);
 wlang.appendrow(['ES', 'Spanish']);
 wlang.appendrow(['ZH', 'Chinese']);
end;

procedure twoptionsfo.wlang_oncellevent(const sender: TObject;
               var info: celleventinfoty);
begin
 with info do begin
  if (eventkind = cek_select) and selected then begin
   keylang:= keylangty(cell.row);
   frmkeyboardfo.updatebuttons;
  end;
 end;
end;

end.
