unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,
 msebufdataset,msedb,mseifiglob,mselocaldataset,mseact,msedataedits,msedbedit,
 msedropdownlist,mseedit,msegraphedits,msegrids,mseificomp,mseificompglob,
 mselookupbuffer,msescrollbar,msestatfile,msestream,sysutils,msewidgetgrid,
 msedatanodes,mselistbrowser,msesimplewidgets,msesplitter;

type
 tmainfo = class(tmainform)
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   intvaled: tintegeredit;
   floatvaled: trealedit;
   tlabel1: tlabel;
   tspacer1: tspacer;
   tbutton1: tbutton;
   tstatfile1: tstatfile;
   tbutton2: tbutton;
   procedure eventloopstartev(const sender: TObject);
   procedure updatevalueev(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure intvalsetev(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure floatvalsetev(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure refreshev(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mainmodule;
 
procedure tmainfo.eventloopstartev(const sender: TObject);
var
 n1: ttreelistedititem;
begin
 n1:= mainmo.gettreedata();
 treeed.itemlist.addchildren(n1);
 n1.releasechildren();
 n1.destroy();
 grid.row:= 0;
end;

procedure tmainfo.updatevalueev(const sender: TObject; const aindex: Integer;
               const aitem: tlistitem);
begin
 with titemnode(aitem) do begin
  intvaled[aindex]:= intval;
  floatvaled[aindex]:= floatval;
 end;
end;

procedure tmainfo.intvalsetev(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 with titemnode(treeed.item) do begin
  intval:= avalue;
 end;
 treeed.checkvalue(); //trigger ifi link onclientdataentered
end;

procedure tmainfo.floatvalsetev(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 with titemnode(treeed.item) do begin
  floatval:= avalue;
 end;
 treeed.checkvalue(); //trigger ifi link onclientdataentered
end;

procedure tmainfo.refreshev(const sender: TObject);
begin
 grid.clear();
 eventloopstartev(nil);
end;

end.
