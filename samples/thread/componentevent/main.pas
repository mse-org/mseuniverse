unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msedispwidgets,mserichstring,msestrings,msesimplewidgets,msethreadcomp;

type
 tmainfo = class(tmainform)
   disp: trealdisp;
   startbu: tbutton;
   terminatebu: tbutton;
   thread: tthreadcomp;
   procedure startedev(const sender: tthreadcomp);
   procedure terminatedev(const sender: tthreadcomp);
   procedure startev(const sender: TObject);
   procedure terminateev(const sender: TObject);
   procedure threadexeev(const sender: tthreadcomp);
   procedure componenteventev(const sender: TObject;
                   const aevent: tcomponentevent);
   procedure destroyev(const sender: TObject);
 end;
 
 tmyevent = class(tcomponentevent)
  private
   fvalue: flo64;
  public
   constructor create(const asender: tobject; const avalue: flo64);
   property value: flo64 read fvalue write fvalue;
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,msesysutils;

{ tmyevent }

constructor tmyevent.create(const asender: tobject;
                                                 const avalue: flo64);
begin
 fvalue:= avalue;
 inherited create(asender);
end;

{ tmainfo }
 
procedure tmainfo.startev(const sender: TObject);
begin
 thread.run(); //restart thread
end;

procedure tmainfo.terminateev(const sender: TObject);
begin
 thread.active:= false;
end;

procedure tmainfo.startedev(const sender: tthreadcomp);
begin //in application.locked state
 startbu.enabled:= false;
 terminatebu.enabled:= true;
end;

procedure tmainfo.terminatedev(const sender: tthreadcomp);
begin //in application.locked state
 startbu.enabled:= true;
 terminatebu.enabled:= false;
end;

procedure tmainfo.threadexeev(const sender: tthreadcomp);
var
 value: flo64;
begin
 value:= 0;
 while not sender.terminated and (value < 1) do begin
  sleepus(10000);
  value:= value + 0.001;
  mainfo.postcomponentevent(tmyevent.create(sender,value)); 
        //asynchronous, does not wait, event automatically destroyed
 end;
end;

procedure tmainfo.componenteventev(const sender: TObject;
               const aevent: tcomponentevent);
begin 
 if aevent is tmyevent then begin    //event automatically destroyed
  disp.value:= tmyevent(aevent).value;
 end;
end;

procedure tmainfo.destroyev(const sender: TObject);
begin
 thread.active:= false; 
                //avoid terminatedev callback with already destroyed buttons 
end;

end.
