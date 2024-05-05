unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,msetimer,msethreadcomp,mseevent;

const
 myeventtag1 = 12345;  
 myeventtag2 = 67890;  
type 
 tmainmo = class(tmsedatamodule)
   ttimer1: ttimer;
   waitthread: tthreadcomp;
   eventpostthread: tthreadcomp;
   procedure timertick(const sender: TObject);
   procedure waitforenter(const sender: tthreadcomp);
   procedure postevent(const sender: tthreadcomp);
   procedure handleevent(const sender: TObject; const aevent: tobjectevent);
   procedure handleasyncevent(const sender: TObject; var atag: Integer);
  private
   ftick: integer;
 end;
var
 mainmo: tmainmo;
implementation
uses
 main_mfm,sysutils;
 
procedure tmainmo.timertick(const sender: TObject);
begin
 if ftick mod 10 = 0 then begin
  writeln('Press Enter in order to terminate the program.');
 end;
 inc(ftick);
 writeln('Tick '+inttostr(ftick));
 flush(output);
end;

procedure tmainmo.waitforenter(const sender: tthreadcomp);
begin
 readln;
 application.lock;
 writeln('Application terminated.');
 flush(output);
 application.unlock;
 application.terminated:= true;
end;

procedure tmainmo.postevent(const sender: tthreadcomp);
var
 int1: integer;
begin
 int1:= 0;
 while not sender.terminated do begin
  sleep(100);
  inc(int1);
  if int1 mod 50 = 0 then begin //5 sec tick
   if int1 mod 100 = 0 then begin
    mainmo.asyncevent(myeventtag1);
   end
   else begin
    application.postevent(tuserevent.create(ievent(mainmo),myeventtag2));
   end;
  end;
 end;
end;

procedure tmainmo.handleevent(const sender: TObject;
               const aevent: tobjectevent);
begin
 if aevent is tuserevent then begin
  with tuserevent(aevent) do begin
   writeln('Event '+inttostr(tag)+' received.');
   flush(output);
  end;
 end;
end;

procedure tmainmo.handleasyncevent(const sender: TObject; var atag: Integer);
begin
 writeln('Asyncevent '+inttostr(atag)+' received.');
 flush(output);
end;

end.
