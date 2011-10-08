unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 msestrings,msetypes,msesimplewidgets,msewidgets,msegrids,msestatfile,
 msethreadcomp;

type
 threadcomparty = array of tthreadcomp;
 
 tmainfo = class(tmainform)
   threadcount: tintegeredit;
   tbutton1: tbutton;
   tbutton2: tbutton;
   threadnum: tintegeredit;
   list: tstringgrid;
   tbutton3: tbutton;
   tstatfile1: tstatfile;
   tbutton4: tbutton;
   procedure doexecute(const sender: tthreadcomp);
   procedure dostart(const sender: tthreadcomp);
   procedure doterminate(const sender: tthreadcomp);
   procedure createexe(const sender: TObject);
   procedure destroyexe(const sender: TObject);
   procedure posteventexe(const sender: TObject);
   procedure terminateexe(const sender: TObject);
  private
   fthreads: threadcomparty;
   procedure listmessage(const sender: tthreadcomp; const amessage: msestring);
   function checkthreadnum: boolean;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,sysutils,msesysintf;
 
procedure tmainfo.listmessage(const sender: tthreadcomp; const amessage: msestring);
begin
 if not application.terminated then begin
  list.appendrow('<'+inttostr(sender.tag)+'>'+' '+amessage+'.');
  list.showlastrow;
 end;
end;

procedure tmainfo.doexecute(const sender: tthreadcomp);
var
 event1: tevent;
begin
 with sender do begin
  while not terminated do begin
   event1:= waitevent; 
   if event1 <> nil then begin
    event1.destroy;
    application.lock;
    try
     listmessage(sender,'event received');
    finally
     application.unlock;
    end;
   end;
  end;
 end;
end;

procedure tmainfo.dostart(const sender: tthreadcomp);
begin 
 //application is locked in onstart, GUI-elements are accessible
 listmessage(sender,'started');
end;

procedure tmainfo.doterminate(const sender: tthreadcomp);
begin
 //application is locked in onterminate, GUI-elements are accessible
 listmessage(sender,'terminated');
end;

procedure tmainfo.createexe(const sender: TObject);
var
 int1: integer;
begin
 destroyexe(nil);
 setlength(fthreads,threadcount.value);
 for int1:= 0 to high(fthreads) do begin
  fthreads[int1]:= tthreadcomp.create(self);
  with fthreads[int1] do begin
   tag:= int1;
   onstart:= @dostart;
   onexecute:= @doexecute;
   onterminate:= @doterminate;
   active:= true;
  end;
 end;
end;

procedure tmainfo.destroyexe(const sender: TObject);
var
 int1: integer;
begin
 for int1:= 0 to high(fthreads) do begin
  freeandnil(fthreads[int1]);
 end;
 fthreads:= nil;
end;

function tmainfo.checkthreadnum: boolean;
begin
 result:= (threadnum.value >= 0) and (threadnum.value <= high(fthreads)) and
     (fthreads[threadnum.value] <> nil);
 if not result then begin
  showerror('Invalid thread number.');
 end;
end;

procedure tmainfo.posteventexe(const sender: TObject);
begin
 if checkthreadnum then begin
  fthreads[threadnum.value].postevent(tevent.create(ek_none));
 end;
end;

procedure tmainfo.terminateexe(const sender: TObject);
begin
 if checkthreadnum then begin
  fthreads[threadnum.value].terminate;
 end;
// application.unlock;
// sys_waitforthread;
// application.lock;
end;

end.
