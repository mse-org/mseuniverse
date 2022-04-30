unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes, mseglob, mseguiglob, mseguiintf, mseapplication, msestat, msemenus,
 msegui,msegraphics, msegraphutils, mseevent, mseclasses, msewidgets, mseforms,
 msebitmap, mseact, msedataedits, msedropdownlist, mseedit, mseificomp,
 mseificompglob, mseifiglob, msestatfile, msestream, sysutils, msesimplewidgets,
 msedragglob, msegrids, msegridsglob, msedispwidgets, mserichstring;

type
 tmainfo = class(tmainform)
   imli: timagelist;
   tstringedit7: tstringedit;
   tstringedit10: tstringedit;
   tbutton1: tbutton;
   tbutton3: tbutton;
   tstringgrid1: tstringgrid;
   tstringdisp1: tstringdisp;
   tbutton2: tbutton;
   tstringdisp2: tstringdisp;
   tbutton4: tbutton;
   tbutton5: tbutton;
   tbutton6: tbutton;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
