{ MSEkicad Copyright (c) 2016 by Martin Schreiber
   
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
unit globalsettingsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msesplitter,msesimplewidgets,msedragglob,msescrollbar,msetabs,mseact,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msebitmap,msedatanodes,msefiledialog,
 mselistbrowser,msesys,mseactions;
type
 tglobalsettingsfo = class(tmseform)
   tstatfile1: tstatfile;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   tabs: ttabwidget;
   maintab: ttabpage;
   val_databasename: tstringedit;
   val_hostname: tstringedit;
   prodplottab: ttabpage;
   prodplotstacktabs: ttabwidget;
   pagemenu: tpopupmenu;
   docutab: ttabpage;
   docusettabs: ttabwidget;
   val_psviewer: tfilenameedit;
   val_ps2pdf: tfilenameedit;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure createev(const sender: TObject);
   procedure newpageev(const sender: TObject);
   procedure deletepageev(const sender: tobject);
   procedure pagepopupupdateev(const sender: tcustommenu);
 end;
 
implementation
uses
 globalsettingsform_mfm,mainmodule,productionpage,docupage;
const
 valueprefix = 'val_';
  
procedure tglobalsettingsfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
var
 ar1: prodplotinfoarty;
 ar2: docuinfoarty;
 i1: int32;
begin
 if amodalresult in [mr_ok,mr_f10] then begin
  globaloptions.storevalues(self,valueprefix);
  setlength(ar1,prodplotstacktabs.count);
  for i1:= 0 to high(ar1) do begin
   with tproductionpagefo(prodplotstacktabs.items[i1]),ar1[i1] do begin
    h.name:= nameed.value;
    plotdir:= plotdired.value;
    createplotzipfile:= createplotziped.value;
    plotzipfilename:= plotzipfilenameed.value;
    plotzipdir:= plotzipdired.value;
    layernames:= layered.griddata.asarray;
    plotformats:= plotformated.griddata.asarray;
    plotfiles:= plotfileed.griddata.asarray;
   end;
  end;
  globaloptions.prodplotdefines:= ar1;
  setlength(ar2,docusettabs.count);
  for i1:= 0 to high(ar2) do begin
   with tdocupagefo(docusettabs.items[i1]),ar2[i1] do begin
    h.name:= nameed.value;
    docudir:= docudired.value;
    psfile:= psfileed.value;
    pdffile:= pdffileed.value;
    titles:= titleed.griddata.asarray;
    pagekinds:= pagekinded.griddata.asarray;
    layerplots:= plots;
   end;
  end;
  globaloptions.docudefines:= ar2;
  if mainmo.conn.connected then begin
   mainmo.conn.connected:= false;
   mainmo.refresh();
  end;
 end;
end;

procedure tglobalsettingsfo.createev(const sender: TObject);
var
 i1: int32;
 fo1: tproductionpagefo;
 fo2: tdocupagefo;
begin
 globaloptions.loadvalues(self,valueprefix);
 for i1:= 0 to high(globaloptions.prodplotdefines) do begin
  fo1:= tproductionpagefo.create(nil);
  with globaloptions.prodplotdefines[i1] do begin
   fo1.caption:= h.name;
   fo1.nameed.value:= h.name;
   fo1.plotdired.value:= plotdir;
   fo1.createplotziped.value:= createplotzipfile;
   fo1.plotzipfilenameed.value:= plotzipfilename;
   fo1.plotzipdired.value:= plotzipdir;
   fo1.layered.griddata.asarray:= layernames;
   fo1.plotfileed.griddata.asarray:= plotfiles;
   fo1.plotformated.griddata.asarray:= plotformats;
   prodplotstacktabs.add(itabpage(fo1));
  end;
 end;
 for i1:= 0 to high(globaloptions.docudefines) do begin
  fo2:= tdocupagefo.create(nil);
  with globaloptions.docudefines[i1] do begin
   fo2.caption:= h.name;
   fo2.nameed.value:= h.name;
   fo2.docudir:= docudir;
   fo2.psfileed.value:= psfile;
   fo2.pdffileed.value:= pdffile;
   fo2.titleed.griddata.asarray:= titles;
   fo2.pagekinded.griddata.asarray:= pagekinds;
   fo2.plots:= layerplots;
   docusettabs.add(itabpage(fo2));
  end;
 end;
end;

procedure tglobalsettingsfo.newpageev(const sender: TObject);
begin
 if prodplotstacktabs.checkdescendent(application.lastshowmenuwidget) then begin
  prodplotstacktabs.add(itabpage(tproductionpagefo.create(nil)));
 end
 else begin
  docusettabs.add(itabpage(tdocupagefo.create(nil)));
 end;
end;

procedure tglobalsettingsfo.deletepageev(const sender: tobject);

 procedure checkdelete(const atabwidget: ttabwidget);
 var
  pag1: ttabform;
 begin
  pag1:= ttabform(atabwidget.activepage);
  if (pag1 <> nil) and askconfirmation(
      'Do you want to delete page "'+pag1.caption+'"?') then begin
   pag1.release();
  end;
 end; //checkdelete
 
begin
 if prodplotstacktabs.checkdescendent(application.lastshowmenuwidget) then begin
  checkdelete(prodplotstacktabs);
 end
 else begin
  checkdelete(docusettabs);
 end;
end;

procedure tglobalsettingsfo.pagepopupupdateev(const sender: tcustommenu);
begin
 with sender.menu.itembyname('delete') do begin
  enabled:= ttabwidget(application.lastshowmenuwidget).activepage <> nil;
 end;
end;

end.
