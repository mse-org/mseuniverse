{ MSEkicad Copyright (c) 2016-2017 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit docupage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetabs,
 msesplitter,mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msebitmap,msedatanodes,msefiledialog,
 msegrids,mselistbrowser,msesys,msewidgetgrid,msegraphedits,msescrollbar,
 mseactions,mainmodule,mseprinter,msesimplewidgets;
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
   pageitems: titemedit;
   statf: tstatfile;
   tlayouter3: tlayouter;
   pagesizeed: tpagesizeselector;
   leftmargined: trealedit;
   bottommargined: trealedit;
   topmargined: trealedit;
   rightmargined: trealedit;
   pagewidthed: trealedit;
   pageheighted: trealedit;
   procedure namesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
   procedure docupageeditev(const sender: tcustomaction);
   procedure selectev(const sender: TObject);
   procedure deselectev(const sender: TObject);
   procedure setdocudirev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
   procedure colmacrohintev(const sender: tdatacol; const arow: Integer;
                                                        var info: hintinfoty);
   procedure titlesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure creatpageitemev(const sender: tcustomitemlist;
                   var item: tlistedititem);
   procedure setkindev(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
  private
//   fdocupages: docupagearty;
//   fplots: docuplotpageinfoarty;
//   fschematics: docuschematicpageinfoarty;
   procedure setdocudir(const avalue: filenamety);
   function getdocupages: docupagearty;
  protected
   function curpage: tdocupage;
  public
   constructor create(const apages: docupagearty); reintroduce;
   destructor destroy(); override;
   property docupages: docupagearty read getdocupages;
//   property plots: docuplotpageinfoarty read fplots write fplots;
//   property schematics: docuschematicpageinfoarty read fschematics
//                                                         write fschematics;
   property docudir: filenamety write setdocudir;
 end;

implementation
uses
 docupage_mfm,layerplotdialog,schematicplotdialog,drillmapdialog,
 msedatalist,mserttistat,titledialogform,bomdialogform;

type
 tpageitem = class(tlistedititem)
  private
   fpage: tdocupage;
  public
   destructor destroy(); override;
 end;

constructor tdocupagefo.create(const apages: docupagearty);
var
 i1: int32;
begin
 inherited create(nil);
 grid.rowcount:= length(apages);
 for i1:= 0 to high(apages) do begin
  tpageitem(pageitems[i1]).fpage:= tdocupage(dupplicateobject(apages[i1]));
  with apages[i1] do begin
   titleed[i1]:= title;
   pagekinded[i1]:= kindid;
  end;
 end;
 pagekinded.dropdown.cols[0].asarray:= mainmo.docupagekinds;
end;

destructor tdocupagefo.destroy();
begin
// docupagesetlength(fdocupages,0);
 inherited;
end;

procedure tdocupagefo.namesetev(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 caption:= avalue;
end;

procedure tdocupagefo.cellev(const sender: TObject; var info: celleventinfoty);
begin
 if (info.cell.row >= 0) and iscellclick(info,
                                  [ccr_dblclick,ccr_nokeyreturn]) then begin
  docupageeditact.execute();
 end;
end;

procedure tdocupagefo.docupageeditev(const sender: tcustomaction);
var
 pag1: tdocupage;
begin
 if canclose(nil) then begin
  pag1:= tpageitem(pageitems.item).fpage;
  case docupagekindty(pagekinded.value+1) of
   dpk_title: begin
//    ttitledialogfo.create(ttitlepage(pag1)).show(ml_application);
   end;
   dpk_schematic: begin
//    tschematicplotdialogfo.create(tschematicplotpage(pag1)).show(ml_application);
   end;
   dpk_layerplot: begin
//    tlayerplotdialogfo.create(tlayerplotpage(pag1)).show(ml_application);
   end;
   dpk_drillmap: begin
//    tdrillmapdialogfo.create(tbompage(pag1)).show(ml_application);
   end;
   dpk_bom: begin
//    tbomdialogfo.create(tdrillmappage(pag1)).show(ml_application);
   end;
  end;
  titleed.value:= pag1.title;
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

function tdocupagefo.curpage: tdocupage;
begin
 result:= tpageitem(pageitems.item).fpage;
end;

function tdocupagefo.getdocupages: docupagearty;
var
 i1: int32;
begin
 setlength(result,grid.datarowhigh+1);
 for i1:= 0 to high(result) do begin
  with tpageitem(pageitems[i1]) do begin
   result[i1]:= fpage;
   fpage:= nil; //no destroy
  end;
 end;
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

procedure tdocupagefo.titlesetev(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if curpage <> nil then begin
  curpage.title:= avalue;
 end;
end;

procedure tdocupagefo.creatpageitemev(const sender: tcustomitemlist;
               var item: tlistedititem);
begin
 item:= tpageitem.create(sender);
end;

procedure tdocupagefo.setkindev(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 with tpageitem(pageitems.item) do begin
  updatedocupageobj(fpage,docupagekindty(avalue+1));
  fpage.title:= titleed.value;
 end;
end;

{ tpageitem }

destructor tpageitem.destroy();
begin
 fpage.free();
 inherited;
end;

end.
