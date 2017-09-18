unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,msegrids,msewidgetgrid,
 mseterminal,msectypes,msetimer;

type
 tmainfo = class(tmainform)
   tbutton5: tbutton;
   tbutton4: tbutton;
   tbutton1: tbutton;
   nam: tstringedit;
   tstatfile1: tstatfile;
   grid: twidgetgrid;
   disp: tterminal;
   fded: tintegeredit;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton6: tbutton;
   dataed: thexstringedit;
   datadi: thexstringedit;
   timer: ttimer;
   setsizebu: tbutton;
   unmapbu: tbutton;
   mapbu: tbutton;
   procedure createev(const sender: TObject);
   procedure openev(const sender: TObject);
   procedure closeev(const sender: TObject);
   procedure sharedlockev(const sender: TObject);
   procedure exclusivelockev(const sender: TObject);
   procedure unlockev(const sender: TObject);
   procedure tiev(const sender: TObject);
   procedure mapev(const sender: TObject);
   procedure unmapev(const sender: TObject);
   procedure setsizeev(const sender: TObject);
   procedure datasetev(const sender: TObject; var avalue: AnsiString;
                   var accept: Boolean);
  private
   fdata: pointer;
   procedure checkerror(const aerror: cint);
   procedure setdata(const avalue: pointer);
  public
   property data: pointer read fdata write setdata;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mselibc,msesysintf1,mseformatstr;
 
procedure tmainfo.createev(const sender: TObject);
begin
 disp.addline('shm_open create ------');

 fded.value:= shm_open(pchar(string(nam.value)),o_creat or o_rdwr,s_irusr or s_iwusr);

 disp.addchars(inttostrmse(fded.value));
 if fded.value < 0 then begin
  disp.addchars(' '+msestring(sys_geterrortext(sys_getlasterror)));
 end;
 disp.addline('');
end;

procedure tmainfo.openev(const sender: TObject);
begin
 disp.addline('shm_open open ------');

 fded.value:= shm_open(pchar(string(nam.value)),o_rdwr,0);

 disp.addchars(inttostrmse(fded.value));
 if fded.value < 0 then begin
  disp.addchars(' ***'+msestring(sys_geterrortext(sys_getlasterror)));
 end;
 disp.addline('');
end;

procedure tmainfo.checkerror(const aerror: cint);
begin
 if aerror <> 0 then begin
  disp.addline('*** '+msestring(sys_geterrortext(sys_getlasterror)));
 end;
end;

procedure tmainfo.setdata(const avalue: pointer);
var
 b1: boolean;
begin
 fdata:= avalue;
 b1:= (fdata = nil) or (fdata = map_failed);
 mapbu.enabled:= b1;
 unmapbu.enabled:= not b1;
 dataed.enabled:= not b1;
 timer.enabled:= not b1;
 if b1 then begin
  datadi.value:= '';
 end;
end;

procedure tmainfo.closeev(const sender: TObject);
begin
 disp.addline('shm_unlink ------');
 checkerror(shm_unlink(pchar(string(nam.value))));

end;

procedure tmainfo.sharedlockev(const sender: TObject);
begin
 disp.addline('flock sh ------');
 checkerror(flock(fded.value,lock_nb or lock_sh));
end;

procedure tmainfo.exclusivelockev(const sender: TObject);
begin
 disp.addline('flock ex ------');
 checkerror(flock(fded.value,lock_nb or lock_ex));
end;

procedure tmainfo.unlockev(const sender: TObject);
begin
 disp.addline('flock un ------');
 checkerror(flock(fded.value,lock_nb or lock_un));
end;

const
 memsize = 20;

procedure tmainfo.setsizeev(const sender: TObject);
begin
 disp.addline('ftruncate64 ------');
 checkerror(ftruncate64(fded.value,memsize));
end;
 
procedure tmainfo.mapev(const sender: TObject);
begin
 disp.addline('mmap ------');
 data:= mmap(nil,memsize,prot_read or prot_write,map_shared,fded.value,0);
 if data = map_failed then begin
  checkerror(-1);
 end;
 tiev(nil);
end;

procedure tmainfo.unmapev(const sender: TObject);
begin
 disp.addline('munmap ------');
 checkerror(munmap(data,memsize));
 data:= nil;
end;

procedure tmainfo.tiev(const sender: TObject);
var
 s1: string;
begin
 try
  setlength(s1,memsize);
  move(data^,pointer(s1)^,length(s1));
  datadi.value:= s1;
 except
  on e: exception do begin
   datadi.value:= '';
   datadi.text:= msestring(e.message);
  end;
 end;
end;

procedure tmainfo.datasetev(const sender: TObject; var avalue: AnsiString;
               var accept: Boolean);
begin
 move(pointer(avalue)^,data^,length(avalue));
 tiev(nil);
end;


end.
