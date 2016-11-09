unit docupage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetabs,
 msesplitter,mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msebitmap,msedatanodes,msefiledialog,
 msegrids,mselistbrowser,msesys,msewidgetgrid,msegraphedits,msescrollbar,
 mseactions,mainmodule;
type
 tdocupagefo = class(ttabform)
   tlayouter1: tlayouter;
   nameed: tstringedit;
   docudired: tfilenameedit;
   grid: twidgetgrid;
   pagekinded: tenumedit;
   titleed: tstringedit;
   docupageeditbu: tstockglyphdatabutton;
   docupageeditact: taction;
   gridpopup: tpopupmenu;
   tlayouter2: tlayouter;
   psfileed: tfilenameedit;
   pdffileed: tfilenameedit;
   statf: tstatfile;
   procedure namesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure createev(const sender: TObject);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
   procedure docupageeditev(const sender: tcustomaction);
   procedure selectev(const sender: TObject);
   procedure deselectev(const sender: TObject);
   procedure setdocudirev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
   procedure colmacrohintev(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
  private
   fplots: docuplotpageinfoarty;
   procedure setdocudir(const avalue: filenamety);
  public
   property plots: docuplotpageinfoarty read fplots write fplots;
   property docudir: filenamety write setdocudir;
 end;

implementation
uses
 docupage_mfm,layerplotdialog,msedatalist;
 
procedure tdocupagefo.namesetev(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 caption:= avalue;
end;

procedure tdocupagefo.createev(const sender: TObject);
begin
 pagekinded.dropdown.cols[0].asarray:= mainmo.docupagekinds;
end;

procedure tdocupagefo.cellev(const sender: TObject; var info: celleventinfoty);
begin
 if (info.cell.row >= 0) and iscellclick(info,[ccr_dblclick]) then begin
  docupageeditact.execute();
 end;
end;

procedure tdocupagefo.docupageeditev(const sender: tcustomaction);
var
 s1: msestring;
begin
 case docupagekindty(pagekinded.value) of
  dpk_layerplot: begin
   s1:= titleed.value;
   if high(fplots) < grid.row then begin
    setlength(fplots,grid.row+1);
   end;
   if tlayerplotdialogfo.create(fplots[grid.row],s1).show(
                                         ml_application) = mr_ok then begin
    titleed.value:= s1;
   end;
  end;
 end;
end;

procedure tdocupagefo.selectev(const sender: TObject);
begin
 statf.readstat();
end;

procedure tdocupagefo.deselectev(const sender: TObject);
begin
 statf.writestat();
end;

procedure tdocupagefo.setdocudirev(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 docudir:= avalue;
end;

procedure tdocupagefo.setdocudir(const avalue: filenamety);
begin
 docudired.value:= avalue;
 psfileed.controller.lastdir:= avalue;
 pdffileed.controller.lastdir:= avalue;
 psfileed.controller.basedir:= avalue;
 pdffileed.controller.basedir:= avalue;
end;

procedure tdocupagefo.macrohintev(const sender: TObject; var info: hintinfoty);
begin
 mainmo.hintmacros(tedit(sender).text,info);
end;

procedure tdocupagefo.colmacrohintev(const sender: tdatacol;
               const arow: Integer; var info: hintinfoty);
begin
 mainmo.hintmacros(tmsestringdatalist(sender.datalist)[arow],info);
end;

end.
