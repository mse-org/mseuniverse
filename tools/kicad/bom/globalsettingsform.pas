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
 mselistbrowser,msesys;
type
 tglobalsettingsfo = class(tmseform)
   tstatfile1: tstatfile;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   ttabwidget1: ttabwidget;
   maintab: ttabpage;
   val_databasename: tstringedit;
   val_hostname: tstringedit;
   prodplottab: ttabpage;
   prodplotstacktabs: ttabwidget;
   plotstackmenu: tpopupmenu;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure createev(const sender: TObject);
   procedure newprodplotpageev(const sender: TObject);
 end;
 
implementation
uses
 globalsettingsform_mfm,mainmodule,productionpage;
const
 valueprefix = 'val_';
  
procedure tglobalsettingsfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
var
 ar1: prodplotinfoarty;
 i1: int32;
begin
 if amodalresult in [mr_ok,mr_f10] then begin
  globaloptions.storevalues(self,valueprefix);
  setlength(ar1,prodplotstacktabs.count);
  for i1:= 0 to high(ar1) do begin
   with tproductionpagefo(prodplotstacktabs.items[i1]),ar1[i1] do begin
    name:= nameed.value;
    layernames:= layered.griddata.asarray;
    plotformats:= plotformated.griddata.asarray;
    plotfiles:= plotfileed.griddata.asarray;
   end;
  end;
  globaloptions.prodplotdefines:= ar1;
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
begin
 globaloptions.loadvalues(self,valueprefix);
 for i1:= 0 to high(globaloptions.prodplotdefines) do begin
  fo1:= tproductionpagefo.create(nil);
  with globaloptions.prodplotdefines[i1] do begin
   fo1.caption:= name;
   fo1.nameed.value:= name;
   fo1.layered.griddata.asarray:= layernames;
   fo1.plotfileed.griddata.asarray:= plotfiles;
   fo1.plotformated.griddata.asarray:= plotformats;
   prodplotstacktabs.add(itabpage(fo1));
  end;
 end;
end;

procedure tglobalsettingsfo.newprodplotpageev(const sender: TObject);
begin
 prodplotstacktabs.add(itabpage(tproductionpagefo.create(nil)));
end;

end.
