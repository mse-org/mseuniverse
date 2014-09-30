unit runform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,mseterminal,mainmodule,msesimplewidgets;
type
 runstatety = (rs_none,rs_compile,rs_test);
 trunfo = class(tmseform)
   tstatfile1: tstatfile;
   grid: twidgetgrid;
   term: tterminal;
   cancelbu: tbutton;
   okbu: tbutton;
   procedure procfinishedexe(const sender: TObject);
   procedure showexe(const sender: TObject);
  protected
   fstate: runstatety;
   ftestitem: ttestnode;
   fcurrenttest: ttestitem;
   ftestok: boolean;
   procedure docompile();
   procedure dotest();
   procedure dofinish();
  public
   function runtest(const atestitem: ttestnode): boolean;
                    //true if ok or disabled
 end;
var
 runfo: trunfo;
implementation
uses
 runform_mfm;
 
{ trunfo }

function trunfo.runtest(const atestitem: ttestnode): boolean;
var
 mstr1: msestring;
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
  mstr1:= mainmo.expandmacros(fcurrenttest.compilecommand);
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
begin
 fstate:= rs_test;
 mstr1:= mainmo.expandmacros(fcurrenttest.runcommand);
 if mstr1 <> '' then begin
  term.execprog(mstr1); 
 end
 else begin
  dofinish();
 end;
end;

procedure trunfo.dofinish();
begin
 cancelbu.enabled:= false;
 okbu.enabled:= true;
end;

procedure trunfo.procfinishedexe(const sender: TObject);
begin
 case fstate of
  rs_compile: begin
   dotest();
  end;
  rs_test: begin
   dofinish();
  end;
 end;
end;

procedure trunfo.showexe(const sender: TObject);
begin
 if fstate = rs_none then begin
  docompile();
 end;
end;

end.
