unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,mseimage,msetimer;

type
 tmainfo = class(tmainform)
   panel: tgroupbox;
   tbutton1: tbutton;
   tstringedit1: tstringedit;
   tstringedit2: tstringedit;
   image: timage;
   tanimtimer1: tanimtimer;
   tanimitemcomp1: tanimitemcomp;
   procedure tickev(const sender: tanimitem; const avalue: Real);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.tickev(const sender: tanimitem; const avalue: Real);
begin
 panel.face.fade_color[0]:= blendcolor(avalue,cl_black,cl_white);
end;

end.
