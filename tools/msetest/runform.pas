unit runform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,mseterminal,mainmodule,msesimplewidgets,
 msesplitter,msepipestream,mseprocess,msedispwidgets,mserichstring;
type
 runstatety = (rs_none,rs_compile,rs_test,rs_canceled);
 trunfo = class(tmseform)
   tstatfile1: tstatfile;
   grid: twidgetgrid;
   term: tterminal;
   proc: tmseprocess;
   tlayouter2: tlayouter;
   tlayouter1: tlayouter;
   okbu: tbutton;
   cancelbu: tbutton;
   tlayouter3: tlayouter;
   nrdi: tintegerdisp;
   captiondi: tstringdisp;
   okdi: tintegerdisp;
   errordi: tintegerdisp;
   againbu: tbutton;
   procedure procfinishedexe(const sender: TObject);
   procedure showexe(const sender: TObject);
   procedure cancelexe(const sender: TObject);
   procedure outputrx(const sender: tpipereader);
   procedure errorrx(const sender: tpipereader);
   procedure againexe(const sender: TObject);
  protected
   fstate: runstatety;
   ftestitem: ttestnode;
   fcurrenttest: ttestitem;
   ftestok: boolean;
   foutputbuffer: string;
   ferrorbuffer: string;
   procedure start();
   procedure docompile();
   procedure dotest();
   procedure dofinish(const ok: boolean);
  protected
   procedure stop();
  public
//   constructor create(const atestitem: ttestnode);
   function runtest(const atestitem: ttestnode): boolean;
                    //true if ok or disabled
 end;
var
 runfo: trunfo;
implementation
uses
 runform_mfm,msesystypes;
 
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
 ftestitem:= atestitem;
 show(ml_application);
 result:= ftestok;
end;

procedure trunfo.start;
begin
 ftestok:= true;
 cancelbu.enabled:= true;
 okbu.enabled:= false;
 againbu.enabled:= false;
 okdi.value:= 0;
 errordi.value:= 0;
 if ftestitem is ttestitem then begin
  fcurrenttest:= ttestitem(ftestitem);
 end
 else begin
  fcurrenttest:= ftestitem.firsttestitem();
 end;
 if fcurrenttest <> nil then begin
  docompile();
 end
 else begin
  stop();
 end;
end;


procedure trunfo.docompile();
var
 mstr1: msestring;
begin
 grid.clear();
 fcurrenttest.inputerror:= false;
 captiondi.value:= fcurrenttest.caption;
 nrdi.value:= fcurrenttest.nr;
 fstate:= rs_compile;
 mstr1:= mainmo.expandmacros(fcurrenttest,fcurrenttest.compilecommand);
 if mstr1 <> '' then begin
  term.execprog(mstr1); 
 end
 else begin
  dotest();
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
   if proc.prochandle = invalidprochandle then begin
    with fcurrenttest do begin
     actualexitcode:= -1;
     actualoutput:= '';
     actualerror:= '';
    end;
    dofinish(false);
   end
   else begin
    if fcurrenttest.input <> '' then begin
     try
      proc.input.pipewriter.write(fcurrenttest.input);
     except
      fcurrenttest.inputerror:= true;
      proc.kill();
      dofinish(false);
     end;
    end;
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
  stop();
 end
 else begin
  if ftestok then begin
   fcurrenttest.setteststate(tes_ok);
   okdi.value:= okdi.value+1;
  end
  else begin
   fcurrenttest.setteststate(tes_error);
   errordi.value:= errordi.value+1;
  end;
  if ftestitem = fcurrenttest then begin //single
   stop();
  end
  else begin
   fcurrenttest:= fcurrenttest.nexttestitem(ftestitem);
   if fcurrenttest = nil then begin
    stop();
   end
   else begin
    docompile();
   end;   
  end;
 end;
end;

procedure trunfo.stop();
begin
 cancelbu.enabled:= false;
 okbu.enabled:= true;
 againbu.enabled:= true;
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
  start();
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

procedure trunfo.againexe(const sender: TObject);
begin
 start();
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
