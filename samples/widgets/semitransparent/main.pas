unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msesplitter;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   fader: texpandingwidget;
   tstringedit1: tstringedit;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
