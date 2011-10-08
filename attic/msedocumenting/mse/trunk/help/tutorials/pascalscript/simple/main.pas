unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets,
 uPSComponent_Default,msepascimportmsegui,msepascalscript,uPSCompiler,uPSComponent,
 uPSPreProcessor,uPSRuntime;

type
 tmainfo = class(tmseform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   procedure comprun(const sender: TObject);
   procedure scriptrun(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,script1,msepascimport;
 
procedure tmainfo.comprun(const sender: TObject);
begin
 tscript1sc.create(nil).caption:= 'Compiled Form';
end;

procedure tmainfo.scriptrun(const sender: TObject);
begin
 registerclasses([tpascimport_classes,tpascimportmsegui,tbutton]); 
                       //register allowed components
 loadpascform('script1.mfm');
end;

end.
