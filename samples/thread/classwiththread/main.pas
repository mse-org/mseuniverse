unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msedispwidgets,mserichstring,msestrings,msethread;

type
 ttestthreadcontainer = class
  private
   fthread: tmsethread;
  protected
   function execute(thread: tmsethread): integer;
  public
   destructor destroy(); override;
   procedure run();
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
   fthreadcontainer: ttestthreadcontainer;
  public
   destructor destroy(); override;
 end;

var
 mainfo: tmainfo;

implementation
uses
 main_mfm,sysutils;

{ ttestthreadcontainer }

destructor ttestthreadcontainer.destroy();
begin
 if fthread <> nil then begin
  fthread.terminate();
  application.waitforthread(fthread); 
             //calls unlockall()/relockall() in order to avoid deadlocks
  fthread.destroy();
 end;
 inherited;
end;

procedure ttestthreadcontainer.run();
begin
 fthread:= tmsethread.create(@execute);
end;

function ttestthreadcontainer.execute(thread: tmsethread): integer;
begin
 while not thread.terminated do begin
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
 fthreadcontainer.free();
 inherited;
end;

procedure tmainfo.createev(const sender: TObject);
begin
 fthreadcontainer:= ttestthreadcontainer.create();
 runbu.enabled:= true;
 destroybu.enabled:= true;
 createbu.enabled:= false;
end;

procedure tmainfo.runev(const sender: TObject);
begin
 fthreadcontainer.run();
 runbu.enabled:= false;
end;

procedure tmainfo.destroyev(const sender: TObject);
begin
 freeandnil(fthreadcontainer);
 runbu.enabled:= false;
 destroybu.enabled:= false;
 createbu.enabled:= true;
end;

end.
