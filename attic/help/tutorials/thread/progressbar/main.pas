unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 msegui,mseclasses,mseforms,msesimplewidgets;

type
 tmainfo = class(tmseform)
   tbutton1: tbutton;
   procedure taskexec(const sender: TObject);
 end;

var
 mainfo: tmainfo;

implementation

uses
 main_mfm,barform;

procedure tmainfo.taskexec(const sender: TObject);
begin 
 tbarfo.create(application).show(true);
end;

end.
