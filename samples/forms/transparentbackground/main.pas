unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 
 sysutils, classes, MClasses,msetypes, mseglob, mseguiglob, mseguiintf,msepointer,
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
   tpaintbox2: tpaintbox;
   procedure onexec(const sender: TObject);
   procedure oncreate(const sender: TObject);
   procedure onmousepaintbox(const sender: twidget;
                   var ainfo: mouseeventinfoty);
 end;
var
 mainfo: tmainfo;
 oripoint: pointty;
 ispressed: Boolean = False;
  
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

procedure tmainfo.onmousepaintbox(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
  if ainfo.eventkind = ek_buttonpress then
    begin
      ispressed := True;
      oripoint  := ainfo.pos;
      cursor := cr_pointinghand;
    end;
  if ainfo.eventkind = ek_buttonrelease then
    begin
      ispressed := False;
      cursor := cr_default;
    end;
  if (ispressed = True) and (ainfo.eventkind = ek_mousemove) then
    begin
      left := left + ainfo.pos.x - oripoint.x;
      top  := top + ainfo.pos.y - oripoint.y;
    end;
end;


end.
