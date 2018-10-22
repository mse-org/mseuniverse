unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mseclasses,msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,
 msestat,msemenus,msegui,msegraphics,msegraphutils,mseevent,msewidgets,mseforms,
 msesimplewidgets,mseact,msebitmap,msedataedits,msedatanodes,msedragglob,
 msedropdownlist,mseedit,msefiledialog,msegrids,msegridsglob,mseificomp,
 mseificompglob,mseifiglob,mselistbrowser,msestatfile,msestream,msesys,sysutils,
 msewidgetgrid,msedispwidgets,mserichstring;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   fna: tfilenameedit;
   tstatfile1: tstatfile;
   grid: twidgetgrid;
   namedisp: tstringedit;
   iddisp: tintegeredit;
   loadtime: trealdisp;
   gridtime: trealdisp;
   fpjsonloadtime: trealdisp;
   procedure exeev(const sender: TObject);
  protected
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msejson,msedate,fpjson,jsonparser;

type
 loadinfoty = record
  pname: pmsestring;
  pid: pint32;
 end;
 
procedure loadstart(var adata; const acount: int32);
begin
 mainfo.grid.rowcount:= acount;
 with loadinfoty(adata) do begin
  pname:= mainfo.namedisp.griddata.datapo;
  pid:= mainfo.iddisp.griddata.datapo;
 end;
end;

procedure loaditem(var adata; const aindex: int32; const aitem: jsonvaluety);
begin
 with loadinfoty(adata) do begin
  pname^:= jsonasstring(aitem,['name']);
  pid^:= jsonasint32(aitem,['id']);
  inc(pname);
  inc(pid);
 end;
end;
 
procedure tmainfo.exeev(const sender: TObject);
var
 v: jsonvaluety;
 l1: loadinfoty;
 t1,t2: tdatetime;
 stream1: tfilestream;
 j1: tjsondata;
begin
 t1:= nowutc();
 jsondecode(readfiledatastring(fna.value),v);
 t2:= nowutc();
 loadtime.value:= (t2-t1)*24*60*60;
 t1:= nowutc();
 grid.beginupdate();
 try
  jsoniteratearray(v,[],l1,@loadstart,@loaditem);
 finally
  grid.endupdate();
 end;
 t2:= nowutc();
 gridtime.value:= (t2-t1)*24*60*60;
 jsonvaluefree(v);
 t1:= nowutc();
 stream1:= tfilestream.create(ansistring(fna.controller.sysfilename),
                                                                fmopenread);
 try
  j1:= getjson(stream1);
  t2:= nowutc();
  fpjsonloadtime.value:= (t2-t1)*24*60*60;
 finally
  stream1.free;
  j1.free;
 end;
end;

end.
