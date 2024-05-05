unit barform;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 msegui,mseclasses,mseforms,msegraphedits,mseevent,msegraphics,msegraphutils,
 msemenus,msesimplewidgets,msewidgets,msethreadcomp;

type
 tbarfo = class(tmseform)
   bar: tprogressbar;
   tbutton1: tbutton;
   thrTask: tthreadcomp;
   procedure cancelex(const sender: TObject);
   procedure taskexecute(const sender: tthreadcomp);
   procedure taskfinished(const sender: tthreadcomp);
 end;

implementation

uses
 barform_mfm,main,sysutils;

procedure tbarfo.taskexecute(const sender: tthreadcomp);
var
 i: integer;
const
 cnt = 20;
begin
 for i:= 1 to cnt  do begin
  application.lock;
  try
   bar.value:= i/cnt;
   //tprogressbar.value is thread safe.
   //calling application.lock/unlock is
   //actually not necessary if you don't access other GUI
   //elements.
  finally
   application.unlock;
  end; 
  //do some useful stuff
  sleep(200);
  if sender.terminated then begin
   break;
  end;
 end;
end;

procedure tbarfo.taskfinished(const sender: tthreadcomp);
begin //application has already been locked by tthreadcomp
 release;
end;

procedure tbarfo.cancelex(const sender: TObject);
begin
 application.lock;            //avoid calling taskfinished
 try
  if not releasing then begin //there could be a race condition 
                              //with terminated thread
   if askyesno('Do you wish to cancel the task?') then begin
    thrTask.terminate;
   end;
  end;
 finally
  application.unlock;
 end;
end;

end.
