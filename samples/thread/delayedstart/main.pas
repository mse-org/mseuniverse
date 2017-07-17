unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msedispwidgets,mserichstring,msestrings,msethread;

type
 ttestthread = class(tmsethread)
  protected
   function execute(thread: tmsethread): integer override;
  public
   constructor create();
   procedure run() override;
 end;
 
 tmainfo = class(tmainform)
   createbu: tbutton;
   runbu: tbutton;
   destroybu: tbutton;
   disp: tintegerdisp;
   procedure createev(const sender: TObject);
   procedure runev(const sender: TObject);
   procedure destroyev(const sender: TObject);
  private
   fthread: ttestthread;
  public
   destructor destroy(); override;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,sysutils;

{ ttestthread }

constructor ttestthread.create();
begin
 include(fstate,ts_norun);
 inherited create(@execute);
end;

procedure ttestthread.run();
begin
 inherited;
end;

function ttestthread.execute(thread: tmsethread): integer;
begin
 while not terminated do begin
  try
   application.lock();
   mainfo.disp.value:= mainfo.disp.value + 1;
  finally
   application.unlock();
  end;
  sleep(200);
 end;
 result:= 0;
end;

{ tmainfo }

destructor tmainfo.destroy();
begin
 if fthread <> nil then begin
  destroyev(nil);
 end;
 inherited;
end;

procedure tmainfo.createev(const sender: TObject);
begin
 fthread:= ttestthread.create();
 runbu.enabled:= true;
 destroybu.enabled:= true;
 createbu.enabled:= false;
end;

procedure tmainfo.runev(const sender: TObject);
begin
 fthread.run();
 runbu.enabled:= false;
end;

procedure tmainfo.destroyev(const sender: TObject);
begin
 fthread.terminate();
 application.waitforthread(fthread); 
            //calls unlockall()/relockall() in order to avoid deadlocks
 fthread.destroy();
 fthread:= nil;
 runbu.enabled:= false;
 destroybu.enabled:= false;
 createbu.enabled:= true;
end;

end.
