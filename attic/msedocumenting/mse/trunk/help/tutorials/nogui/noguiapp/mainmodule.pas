unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,msetimer;

type
 tmainmo = class(tmsedatamodule)
   ttimer1: ttimer;
   procedure asyncevent1(const sender: TObject; var atag: Integer);
   procedure timerevent1(const sender: TObject);
   procedure termanatedevent1(const sender: TObject);
 private
  eventnum: integer;
 end;
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm,sysutils;
 
procedure tmainmo.asyncevent1(const sender: TObject; var atag: Integer);
begin
 if atag = 123 then begin
  writeln('Asyncevent '+inttostr(eventnum));
  inc(eventnum);
  if eventnum >= 5 then begin
   writeln('Terminating.');
   application.terminated:= true;
  end;
  flush(output);
 end;
end;

procedure tmainmo.timerevent1(const sender: TObject);
begin
 writeln('Timerevent.');
 flush(output);
 asyncevent(123); //posts a message into the queue
end;

procedure tmainmo.termanatedevent1(const sender: TObject);
begin
 writeln('Terminated.');
end;

end.
