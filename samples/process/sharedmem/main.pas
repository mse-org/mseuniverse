unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,msegrids,msewidgetgrid,
 mseterminal;

type
 tmainfo = class(tmainform)
   tbutton5: tbutton;
   tbutton4: tbutton;
   tbutton1: tbutton;
   nam: tstringedit;
   tstatfile1: tstatfile;
   grid: twidgetgrid;
   disp: tterminal;
   procedure createev(const sender: TObject);
   procedure openev(const sender: TObject);
   procedure closeev(const sender: TObject);
  private
   fid: int32;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mselibc,msesysintf1,mseformatstr;
 
procedure tmainfo.createev(const sender: TObject);
begin
 disp.addline('shm_open create ------');

 fid:= shm_open(pchar(string(nam.value)),o_creat or o_rdwr,s_irusr or s_iwusr);

 disp.addchars(inttostrmse(fid));
 if fid < 0 then begin
  disp.addchars(' '+sys_geterrortext(sys_getlasterror));
 end;
 disp.addline('');
end;

procedure tmainfo.openev(const sender: TObject);
begin
 disp.addline('shm_open open ------');

 fid:= shm_open(pchar(string(nam.value)),o_rdwr,0);

 disp.addchars(inttostrmse(fid));
 if fid < 0 then begin
  disp.addchars(' '+msestring(sys_geterrortext(sys_getlasterror)));
 end;
 disp.addline('');
end;

procedure tmainfo.closeev(const sender: TObject);
var
 i1: int32;
begin
 disp.addline('shm_unlink ------');
 i1:= shm_unlink(pchar(string(nam.value)));

 if i1 < 0 then begin
  disp.addchars(' '+msestring(sys_geterrortext(sys_getlasterror)));
 end;
 disp.addline('');
end;

end.
