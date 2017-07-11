unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,msedispwidgets,
 mserichstring;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   reccounted: tintegeredit;
   tstatfile1: tstatfile;
   runtimedi: trealdisp;
   procedure testexe(const sender: TObject);
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,dbmodule,mseadifpars,msedate,mseformatstr;
 
procedure tmainfo.testexe(const sender: TObject);
var
 rec1: adlogrecty;
 t1,t2: tdatetime;
 i1: int32;
 f1: adiftagty;
begin
 for f1:= firstlogfield to lastlogfield do begin
  rec1.fields[f1]:= msestring(adiftagnames[f1]);
 end;
 t1:= nowutc();
 rec1.fields[at_qso_date]:= datetoadif(t1);
 rec1.fields[at_time_on]:= timetoadif(t1);
 dbmo.init();
 t1:= nowutc();
 for i1:= 1 to reccounted.value do begin
  rec1.fields[at_call]:= inttostrmse(i1);
  dbmo.writelogrec(rec1);
 end;
 dbmo.commit();
 t2:= nowutc();
 runtimedi.value:=  (t2-t1)*24*60*60;
end;

end.
