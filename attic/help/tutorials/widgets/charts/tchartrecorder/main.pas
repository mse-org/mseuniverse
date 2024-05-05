unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msechart,msetimer;

type
 tmainfo = class(tmseform)
   chartrec: tchartrecorder;
   ttimer1: ttimer;
   procedure ti(const sender: TObject);
  private
   x: integer;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
const
 periode = 300; //pixels
 
procedure tmainfo.ti(const sender: TObject);
begin
 chartrec.addsample([sin(2*pi*x/periode)]);
 x:= (x + 1) mod periode;
end;

end.
