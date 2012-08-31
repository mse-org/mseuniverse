unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,sysutils;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   procedure mainfo_onmouseevent(const sender: twidget;
                   var ainfo: mouseeventinfoty);
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

end.
