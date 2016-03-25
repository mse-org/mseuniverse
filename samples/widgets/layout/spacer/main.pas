unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msesplitter,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   tspacer1: tspacer;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tspacer2: tspacer;
   tstringedit1: tstringedit;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
