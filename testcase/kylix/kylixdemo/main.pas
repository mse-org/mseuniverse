unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 mseifiglob,msestrings,msetypes,msestatfile,msesimplewidgets,msewidgets;

type
 tmainfo = class(tmainform)
   tlabel1: tlabel;
   tbutton1: tbutton;
   procedure exitexec(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

var
 int1: integer;
 
procedure tmainfo.exitexec(const sender: TObject);
var
 int2: integer;
begin
 int2:= 123;
 int1:= int2*10;
 writeln('Exit button clicked');
end;

end.
