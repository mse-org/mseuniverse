unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 sysutils,msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,
 msemenus,msegui,msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,
 mseforms,mseimage,msesimplewidgets;

type
 tmainfo = class(tmainform)
   timage1: timage;
   tbutton1: tbutton;
   timage2: timage;
   procedure oncre(const sender: TObject);
   procedure onexec(const sender: TObject);
 end;
var
 mainfo: tmainfo;
 ordir : string;
implementation
uses
 main_mfm;
procedure tmainfo.oncre(const sender: TObject);
begin
mse_shapebmp := timage2.bitmap;
optionswindow := [wo_groupleader,wo_taskbar,wo_alwaysontop,wo_noframe,wo_customshape];
end;

procedure tmainfo.onexec(const sender: TObject);
begin
application.terminate;
end;

end.
