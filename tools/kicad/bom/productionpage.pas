unit productionpage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetabs,
 msesplitter,mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msegrids,msewidgetgrid,msebitmap,
 msedatanodes,msefiledialog,mselistbrowser,msesys,msegraphedits,msescrollbar,
 msedragglob;
type
 tproductionpagefo = class(ttabform)
   tlayouter1: tlayouter;
   nameed: tstringedit;
   productiondired: tfilenameedit;
   tlayouter2: tlayouter;
   productionzipfilenameed: tfilenameedit;
   tlayouter3: tlayouter;
   createproductionziped: tbooleanedit;
   productionzipdired: tstringedit;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   plotsgrid: twidgetgrid;
   layered: tdropdownlistedit;
   plotfileed: tstringedit;
   plotformated: tenumedit;
   ttabpage2: ttabpage;
   drillgrid: twidgetgrid;
   layerbed: tdropdownlistedit;
   drillfileed: tstringedit;
   layeraed: tdropdownlistedit;
   nonplateded: tbooleanedit;
   statf: tstatfile;
   procedure namesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure layersetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure createev(const sender: TObject);
   procedure showhintev(const sender: TObject; var info: hintinfoty);
   procedure hintplotfilenamecolev(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
   procedure hintdrillfilenamecolev(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
   procedure selectev(const sender: TObject);
   procedure deselectev(const sender: TObject);
  protected
 end;

implementation
uses
 productionpage_mfm,mainmodule;

procedure tproductionpagefo.createev(const sender: TObject);
begin
 layered.dropdown.cols[0].asarray:= mainmo.layernames;
 layeraed.dropdown.cols[0].asarray:= mainmo.culayernames;
 layerbed.dropdown.cols[0].asarray:= mainmo.culayernames;
 plotformated.dropdown.cols[0].asarray:= mainmo.fileformats;
end;

procedure tproductionpagefo.namesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 caption:= avalue;
end;

procedure tproductionpagefo.layersetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if (plotfileed.value = '') or 
           (plotfileed.value = layertoplotname(layered.value)) then begin
  plotfileed.value:= layertoplotname(avalue);
 end;
end;

procedure tproductionpagefo.showhintev(const sender: TObject;
               var info: hintinfoty);
begin
 mainmo.hintmacros(tedit(sender).text,info);
end;

procedure tproductionpagefo.hintplotfilenamecolev(const sender: tdatacol;
               const arow: Integer; var info: hintinfoty);
begin
 mainmo.hintmacros(plotfileed[arow],info);
end;

procedure tproductionpagefo.hintdrillfilenamecolev(const sender: tdatacol;
               const arow: Integer; var info: hintinfoty);
begin
 mainmo.hintmacros(drillfileed[arow],info);
end;

procedure tproductionpagefo.selectev(const sender: TObject);
begin
 statf.readstat();
end;

procedure tproductionpagefo.deselectev(const sender: TObject);
begin
 statf.writestat();
end;

end.
