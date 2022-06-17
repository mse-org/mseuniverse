unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 sysutils, classes, MClasses,msetypes, mseglob, mseguiglob, mseguiintf,
 mseapplication, msestat, msemenus,msegui,msegraphics, msegraphutils, mseevent,
 mseclasses, msewidgets, mseforms,msesimplewidgets, msedispwidgets,
 mserichstring, mseedit, msestatfile, msestream, msedragglob, msegrids,
 msegridsglob, mseimage, msegraphedits, mseificomp, mseificompglob, mseifiglob,
  msescrollbar;
 
 
type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tstringdisp1: tstringdisp;
   tedit1: tedit;
   tstringgrid1: tstringgrid;
   tbooleanedit1: tbooleanedit;
   procedure onexec(const sender: TObject);
   procedure oncreate(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.onexec(const sender: TObject);
begin
application.terminate;
end;

procedure tmainfo.oncreate(const sender: TObject);
begin
 optionswindow := [wo_groupleader,wo_taskbar,wo_alwaysontop,wo_transparentbackground];
 SetChildBounds(sender);
end;

end.
