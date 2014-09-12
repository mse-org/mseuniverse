unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetimer,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar;

type
 tmainfo = class(tmainform)
   timer: ttimer;
   tbooleanedit1: tbooleanedit;
   procedure timerexe(const sender: TObject);
   procedure setexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  private
   n: longword;
   last: longword;
   sum: qword;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mseformatstr,msesysutils;
 
procedure tmainfo.timerexe(const sender: TObject);
var
 lwo1,lwo2: longword;
begin
 lwo1:= timestamp();
 lwo2:= lwo1 - last;
 sum:= sum + lwo2;
 inc(n);
 writeln(n,' ',formatfloatmse(lwo2/1000000,'0.000000'),' ',
                                    formatfloatmse(sum/(1000000*n),'0.000000'));
 last:= lwo1;
end;

procedure tmainfo.setexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  application.beginhighrestimer();
  writeln('n   tp (s)  average (s)');
  sum:= 0;
  n:= 0;
  last:= timestamp();
 end
 else begin
  application.endhighrestimer();
 end;
 timer.enabled:= avalue;
end;

end.
