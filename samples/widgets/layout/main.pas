unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,msestrings,sysutils,msesimplewidgets;

type
 tmainfo = class(tmainform)
   tlayouter1: tlayouter;
   tmemoedit1: tmemoedit;
   tstringedit1: tstringedit;
   tbutton1: tbutton;
   tgroupbox1: tgroupbox;
   tspacer1: tspacer;
   tsimplewidget1: tsimplewidget;
   tscrollbox1: tscrollbox;
   tsplitter1: tsplitter;
   tstatfile1: tstatfile;
   tmemoedit2: tmemoedit;
   tstringedit2: tstringedit;
   tstringedit3: tstringedit;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton4: tbutton;
   tsimplewidget2: tsimplewidget;
   tsplitter2: tsplitter;
   tsplitter3: tsplitter;
   tsplitter4: tsplitter;
   tsimplewidget3: tsimplewidget;
   tsimplewidget4: tsimplewidget;
   tsimplewidget5: tsimplewidget;
   tstringedit4: tstringedit;
   tstringedit5: tstringedit;
   tbutton5: tbutton;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
