unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msegraphedits,mseificomp,mseificompglob,mseifiglob,
 msescrollbar,msedataedits,mseedit,msegrids,msestatfile,msestream,msestrings,
 msewidgetgrid,sysutils;

type
 tmainfo = class(tmainform)
   tdatabutton1: tdatabutton;
   tdatabutton2: tdatabutton;
   tdatabutton3: tdatabutton;
   tdatabutton4: tdatabutton;
   tdatabutton5: tdatabutton;
   twidgetgrid1: twidgetgrid;
   tstringedit1: tstringedit;
   tdatabutton6: tdatabutton;
   tstatfile1: tstatfile;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
