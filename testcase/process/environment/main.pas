unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msepipestream,
 mseprocess,msesimplewidgets,msewidgets,msedataedits,mseedit,msegrids,
 mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,msestrings,msetypes,
 msewidgetgrid,sysutils,mseterminal,msegraphedits,msescrollbar;

type
 tmainfo = class(tmainform)
   proc: tmseprocess;
   tbutton1: tbutton;
   twidgetgrid1: twidgetgrid;
   term: tterminal;
   tstatfile1: tstatfile;
   par: tstringgrid;
   env: tstringgrid;
   shell: tbooleanedit;
   procedure exe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msefileutils;
 
procedure tmainfo.exe(const sender: TObject);
var
 fna1: filenamety;
begin
 term.clear();
{$ifdef mswindows}
 fna1:= filepath('testproc/testproc.exe');
{$else}
 fna1:= filepath('testproc/testproc');
{$endif}
 if shell.value then begin
  term.optionsprocess:= term.optionsprocess + [pro_shell];
  term.optionsprocess:= term.optionsprocess - [pro_noshell];
 end
 else begin
  term.optionsprocess:= term.optionsprocess - [pro_shell];
  term.optionsprocess:= term.optionsprocess + [pro_noshell];
 end;
 term.execprog(fna1,'',par.datacols[0].datalist.asarray,
                                   env.datacols[0].datalist.asarray);
end;

end.
