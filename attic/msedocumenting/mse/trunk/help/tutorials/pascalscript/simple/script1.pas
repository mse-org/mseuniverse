unit script1;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msepascalscript,msesimplewidgets,
 msewidgets,msepascimportmsegui,msepascimport;

type
 tscript1sc = class(tpascform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   tpsimportmsegui1: tpascimportmsegui;
   TPSImport_Classes1: tpascImport_Classes;
   procedure beepex(const sender: TObject);
 end;

var
 script1sc: tscript1sc;

implementation
uses
 script1_mfm;
 
procedure tscript1sc.beepex(const sender: TObject);
begin
 beep;
end;

end.
