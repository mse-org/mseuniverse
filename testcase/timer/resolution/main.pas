unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 mseificomp,mseificompglob,mseifiglob,msestrings,msetypes,msegraphedits,
 msescrollbar,msedispwidgets,mserichstring,msestatfile,msetimer;

type
 tmainfo = class(tmainform)
   intervaled: trealedit;
   mmtimered: tbooleanedit;
   tbooleanedit1: tbooleanedit;
   ndi: tintegerdisp;
   intdi: trealdisp;
   tstatfile1: tstatfile;
   ti: ttimer;
   procedure tiexe(const sender: TObject);
   procedure setintervalexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure setmmtimerexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure runsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  private
   fn: integer;
   fstart: longword;
   fti: longword;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mseformatstr,msedate,msesysutils;
 
procedure tmainfo.tiexe(const sender: TObject);
var
 dt1: longword;
begin
 dt1:= timestamp;
 inc(fn);
 write(formatfloatmse((dt1-fti)/1000000,'0..00000G'),' ');
 if fn mod 5 = 0 then begin
  writeln;
 end;
 fti:= dt1;
end;

procedure tmainfo.setintervalexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 ti.interval:= round(avalue*1000000);
end;

procedure tmainfo.setmmtimerexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  application.beginhighrestimer;
 end
 else begin
  if application.highrestimer then begin //call not from statread
   application.endhighrestimer;
  end;
 end;
end;

procedure tmainfo.runsetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  writeln('******************* start');
  intdi.value:= emptyreal;
  fn:= 0;
  ndi.value:= 0;
  fstart:= timestamp;
  ti.enabled:= true;
  fti:= fstart;
 end
 else begin
  if fn > 0 then begin
   ti.enabled:= false;
   intdi.value:= ((fti-fstart)/1000000)/fn;
   ndi.value:= fn;
   writeln;
   writeln('------------------ stop n: ',fn,' interval: ',
               formatfloatmse(intdi.value,'0..00000G'));
   writeln;
  end
  else begin
   writeln('------------------ stop');
  end;
 end;
end;

end.
