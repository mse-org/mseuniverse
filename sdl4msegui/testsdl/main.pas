unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,sysutils,mseimage,msepolygon;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   timage1: timage;
   tpolygon1: tpolygon;
   procedure mainfo_onmouseevent(const sender: twidget;
                   var ainfo: mouseeventinfoty);
   procedure mainfo_onkeydown(const sender: twidget; var ainfo: keyeventinfoty);
   procedure mainfo_onkeyup(const sender: twidget; var ainfo: keyeventinfoty);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msesysutils;
procedure tmainfo.mainfo_onmouseevent(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 debugwriteln('mouse move '+inttostr(ainfo.pos.x)+'; '+inttostr(ainfo.pos.y));
end;

procedure tmainfo.mainfo_onkeydown(const sender: twidget;
               var ainfo: keyeventinfoty);
begin
 debugwriteln(ainfo.chars);
end;

procedure tmainfo.mainfo_onkeyup(const sender: twidget;
               var ainfo: keyeventinfoty);
begin
 debugwriteln(ainfo.chars);
end;

end.
