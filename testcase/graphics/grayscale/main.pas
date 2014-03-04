unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msesimplewidgets;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   procedure exe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.exe(const sender: TObject);
var
 ha1: pixmapty;
begin
 ha1:= gui_createpixmap(ms(100,50),0,bmk_gray);
end;

end.
