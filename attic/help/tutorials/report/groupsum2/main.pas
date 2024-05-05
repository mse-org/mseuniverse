unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets;

type
 tmainfo = class(tmseform)
   tbutton1: tbutton;
   procedure runreport(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,testreport;
 
procedure tmainfo.runreport(const sender: TObject);
begin
 ttestre.create(nil);
end;

end.
