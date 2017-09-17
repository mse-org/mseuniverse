unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,msegrids;

type
 tmainfo = class(tmainform)
   tbutton5: tbutton;
   tbutton4: tbutton;
   tbutton1: tbutton;
   nam: tstringedit;
   tstatfile1: tstatfile;
   disp: tstringgrid;
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
 main_mfm,mselibc,msesysintf1;
 
procedure tmainfo.createev(const sender: TObject);
begin
 disp[0].readpipe(lineend+'shm_open create ------'+lineend);

 fid:= shm_open(pchar(string(nam.value)),o_creat or o_rdwr,s_irusr or s_iwusr);

 disp[0].readpipe(inttostr(fid));
 if fid < 0 then begin
  disp[0].readpipe(' '+sys_geterrortext(sys_getlasterror));
 end;
 disp.showlastrow();
end;

procedure tmainfo.openev(const sender: TObject);
begin
 disp[0].readpipe(lineend+'shm_open open ------'+lineend);

 fid:= shm_open(pchar(string(nam.value)),o_rdwr,0);

 disp[0].readpipe(inttostr(fid));
 if fid < 0 then begin
  disp[0].readpipe(' '+sys_geterrortext(sys_getlasterror));
 end;
 disp.showlastrow();
end;

procedure tmainfo.closeev(const sender: TObject);
var
 i1: int32;
begin
 disp[0].readpipe(lineend+'shm_unlink ------'+lineend);
 i1:= shm_unlink(pchar(string(nam.value)));

 if i1 < 0 then begin
  disp[0].readpipe(' '+sys_geterrortext(sys_getlasterror));
 end;
 disp.showlastrow();
end;

end.
