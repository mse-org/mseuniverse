unit runform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,mseterminal,mainmodule,msesimplewidgets,
 msesplitter,msepipestream,mseprocess;
type
 runstatety = (rs_none,rs_compile,rs_test,rs_canceled);
 trunfo = class(tmseform)
   tstatfile1: tstatfile;
   grid: twidgetgrid;
   term: tterminal;
   tlayouter1: tlayouter;
   okbu: tbutton;
   cancelbu: tbutton;
   proc: tmseprocess;
   procedure procfinishedexe(const sender: TObject);
   procedure showexe(const sender: TObject);
   procedure cancelexe(const sender: TObject);
   procedure outputrx(const sender: tpipereader);
   procedure errorrx(const sender: tpipereader);
  protected
   fstate: runstatety;
   ftestitem: ttestnode;
   fcurrenttest: ttestitem;
   ftestok: boolean;
   foutputbuffer: string;
   ferrorbuffer: string;
   procedure docompile();
   procedure dotest();
   procedure dofinish(const ok: boolean);
  public
//   constructor create(const atestitem: ttestnode);
   function runtest(const atestitem: ttestnode): boolean;
                    //true if ok or disabled
 end;
var
 runfo: trunfo;
implementation
uses
 runform_mfm;
 
{ trunfo }
{
constructor trunfo.create(const atestitem: ttestnode);
begin
 ftestitem:= atestitem;
 inherited create(nil);
end;
}
function trunfo.runtest(const atestitem: ttestnode): boolean;
begin
 fstate:= rs_none;
 fcurrenttest:= nil;
 ftestok:= true;
 grid.clear();
 ftestitem:= atestitem;
 show(ml_application);
 result:= ftestok;
end;

procedure trunfo.docompile();
var
 mstr1: msestring;
begin
 if fcurrenttest = nil then begin
  if ftestitem is ttestitem then begin
   fcurrenttest:= ttestitem(ftestitem);
  end
  else begin
   fcurrenttest:= ftestitem.nexttestitem();
  end;
 end
 else begin
  fcurrenttest:= fcurrenttest.nexttestitem();
 end;
 if fcurrenttest <> nil then begin
  cancelbu.enabled:= true;
  okbu.enabled:= false;
  fstate:= rs_compile;
  mstr1:= mainmo.expandmacros(fcurrenttest,fcurrenttest.compilecommand);
  if mstr1 <> '' then begin
   term.execprog(mstr1); 
  end
  else begin
   dotest();
  end;
 end;
end;

procedure trunfo.dotest();
var
 mstr1: msestring;
 int1: integer;
begin
 fstate:= rs_test;
 ferrorbuffer:= '';
 foutputbuffer:= '';
 mstr1:= mainmo.expandmacros(fcurrenttest,fcurrenttest.runcommand);
 if mstr1 <> '' then begin
  int1:= application.unlockall();
  try
   proc.commandline:= mstr1;
   proc.active:= true;
   if fcurrenttest.input <> '' then begin
    proc.input.pipewriter.write(fcurrenttest.input);
   end;
  finally
   application.relockall(int1);
  end;
 end
 else begin
  dofinish(true);
 end;
end;

procedure trunfo.dofinish(const ok: boolean);
begin
 ftestok:= ok;
 if fstate = rs_canceled then begin
  fcurrenttest.setteststate(tes_none);
 end
 else begin
  if ftestok then begin
   fcurrenttest.setteststate(tes_ok);
  end
  else begin
   fcurrenttest.setteststate(tes_error);
  end;
 end;
 cancelbu.enabled:= false;
 okbu.enabled:= true;
end;

procedure trunfo.procfinishedexe(const sender: TObject);
begin
 case fstate of
  rs_compile: begin
   fcurrenttest.compileresult:= term.exitcode();
   if fcurrenttest.compileresult <> 0 then begin
    dofinish(false);
   end
   else begin
    dotest();
   end;
  end;
  rs_test: begin
   with fcurrenttest do begin
    actualexitcode:= proc.exitcode;
    actualoutput:= foutputbuffer;
    foutputbuffer:= '';
    actualerror:= ferrorbuffer;
    ferrorbuffer:= '';
    dofinish((actualexitcode = expectedexitcode) and 
             (actualoutput = expectedoutput) and
             (actualerror = expectederror));
   end;
  end;
  else begin
   dofinish(false);
  end;
 end;
end;

procedure trunfo.showexe(const sender: TObject);
begin
 if fstate = rs_none then begin
  docompile();
 end;
end;

procedure trunfo.cancelexe(const sender: TObject);
begin
 case fstate of
  rs_compile: begin
   fstate:= rs_canceled;
   term.terminateprocess();
   term.waitforprocess();
  end;
  rs_test: begin
   fstate:= rs_canceled;
   proc.terminate();
   proc.waitforprocess();
  end;
 end;
end;

procedure trunfo.outputrx(const sender: tpipereader);
begin
 foutputbuffer:= foutputbuffer+sender.readdatastring();
end;

procedure trunfo.errorrx(const sender: tpipereader);
begin
 ferrorbuffer:= ferrorbuffer+sender.readdatastring();
end;

end.
