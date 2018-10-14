unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msesimplewidgets;

type
 tmainfo = class(tmainform)
   tstatfile1: tstatfile;
   tbutton1: tbutton;
   tbutton2: tbutton;
   procedure showexeev(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,editform;
 
procedure tmainfo.showexeev(const sender: TObject);
begin
 editfo.show();
end;

end.
