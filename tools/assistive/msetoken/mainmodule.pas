unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,msestat,msestatfile,
 mseassistivehandler,mseactions;

type
 tmainmo = class(tmsedatamodule)
   tstatfile1: tstatfile;
   tassistivehandler1: tassistivehandler;
   newtocenact: taction;
   procedure newtokenev(const sender: TObject);
 end;
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm,newtokenform,msegui;
 
procedure tmainmo.newtokenev(const sender: TObject);
begin
 with tnewtokenfo.create(nil) do begin
  show(ml_application);
 end;
end;

end.
