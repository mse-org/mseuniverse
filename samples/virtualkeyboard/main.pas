unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mseskin,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msetimer,
 msedispwidgets,mserichstring,msesimplewidgets,msewidgets,msegrids,
 msewidgetgrid,msebitmap,msedatanodes,msefiledialog,mselistbrowser,msesys,
 msegraphedits,msescrollbar;

type
 tmainfo = class(tmainform)
   tskincontroller1: tskincontroller;
   trealedit1: trealedit;
   tmemoedit1: tmemoedit;
   tstringedit1: tstringedit;
   trealedit2: trealedit;
   tframecomp1: tframecomp;
   tdropdownlistedit1: tdropdownlistedit;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tintegeredit1: tintegeredit;
   tint64edit1: tint64edit;
   twidgetgrid1: twidgetgrid;
   tstringedit2: tstringedit;
   tintegeredit2: tintegeredit;
   trealedit3: trealedit;
   tdropdownlistedit2: tdropdownlistedit;
   tframecomp2: tframecomp;
   tfacecomp2: tfacecomp;
   tframecomp3: tframecomp;
   tfacecomp3: tfacecomp;
   trealedit4: trealedit;
   tstringedit3: tstringedit;
   tfilenameedit1: tfilenameedit;
   tstringgrid1: tstringgrid;
   wvkbd: tbooleanedit;
   procedure showformmodal(const sender: TObject);
   procedure wvkbd_onchange(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,virtualkeyboard,frmmodal;


procedure tmainfo.showformmodal(const sender: TObject);
begin
 application.createform(tfrmmodalfo, frmmodalfo);
 frmmodalfo.show(true);
end;

procedure tmainfo.wvkbd_onchange(const sender: TObject);
begin
 if wvkbd.value then
  enabledvirtualkeyboard
 else
  disabledvirtualkeyboard;  
end;

end.
