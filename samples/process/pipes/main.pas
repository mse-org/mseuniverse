unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msebitmap,
 msedataedits,msedatanodes,mseedit,msefiledialog,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselistbrowser,msestrings,msesys,msesimplewidgets,
 msepipestream,mseprocess;

type
 tmainfo = class(tmainform)
   proged: tfilenameedit;
   runbu: tbutton;
   txtexted: tstringedit;
   grid: tstringgrid;
   proc: tmseprocess;
   procedure runexe(const sender: TObject);
   procedure inputavailexe(const sender: tpipereader);
   procedure procfinishedexe(const sender: TObject);
   procedure setvalueexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.runexe(const sender: TObject);
begin
 proc.active:= false;
 grid.clear;
 proc.commandline:= proged.value;
 proc.active:= true;
end;

procedure tmainfo.inputavailexe(const sender: tpipereader);
begin
 grid[0].readpipe(sender);
 grid.showlastrow;
end;

procedure tmainfo.procfinishedexe(const sender: TObject);
begin
 grid.appendrow('*** process finished ***');
end;

procedure tmainfo.setvalueexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 proc.input.pipewriter.writeln(avalue);
end;

end.
