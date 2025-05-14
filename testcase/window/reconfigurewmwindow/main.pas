unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   procedure exe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,form1,form2,form3,mx,mxlib,mxutil;
 
procedure tmainfo.exe(const sender: TObject);
var
 changes: txwindowchanges; 
begin
 changes.stack_mode:= below;
 changes.sibling:= form2fo.window.winid;
 xreconfigurewmwindow(msedisplay,form1fo.window.winid,msedefaultscreenno,
                              cwsibling or cwstackmode,@changes);

end;

end.
