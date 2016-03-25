unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 msesimplewidgets,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils;

type
 tmainfo = class(tmainform)
   tlayouter2: tlayouter;
   tlayouter3: tlayouter;
   tbutton4: tbutton;
   tbutton5: tbutton;
   tbutton6: tbutton;
   tstringedit2: tstringedit;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
