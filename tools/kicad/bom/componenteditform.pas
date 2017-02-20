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
unit componenteditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils,msedb,msedbdialog,
 msewidgetgrid,msememodialog,mseifiendpoint;

type
 tcomponenteditfo = class(trecordeditfo)
   stripe2: tlayouter;
   value2ed: tdbstringedit;
   value1ed: tdbstringedit;
   valueed: tdbstringedit;
   stripe3: tlayouter;
   footprinted: tdbenum64editdb;
   compkinded: tdbenum64editdb;
   stripe4: tlayouter;
   descriptioned: tdbmemodialogedit;
//   procedure closeev(const sender: TObject);
   parameter1ed: tdbmemodialogedit;
   parameter2ed: tdbmemodialogedit;
   parameter3ed: tdbmemodialogedit;
   parameter4ed: tdbmemodialogedit;
   commented: tdbmemodialogedit;
   manufacturered: tdbenum64editdb;
   footprintinfoed: tdbstringedit;
   tsimplewidget1: tsimplewidget;
   stripe5: tlayouter;
   distributorgrid: tdbwidgetgrid;
   distributored: tdbenum64editdb;
   partnumed: tdbstringedit;
   tdbmemodialogedit1: tdbmemodialogedit;
   tsplitter1: tsplitter;
   footprintgrid: twidgetgrid;
   pked: tint64edit;
   tenum64editdb1: tenum64editdb;
   tstringedit2: tstringedit;
   footprintcommented: tmemodialogedit;
   nofootprints: tifibooleanendpoint;
   procedure editfootprintev(const sender: TObject);
   procedure editcompkindev(const sender: TObject);
   procedure datachangeev(Sender: TObject; Field: TField);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
   procedure editmanufacturerev(const sender: TObject);
   procedure editdistributorev(const sender: TObject);
   procedure statechangeev(Sender: TObject);
   procedure editev(const sender: TObject);
   procedure readonlychangeev(const sender: TObject; const avalue: Boolean);
   procedure nofootprintschaev(const sender: TObject; var avalue: Boolean);
   procedure updatedataev(Sender: TObject);
  private
   fstatebefore: tdatasetstate;
   fhaskindfootprints: boolean;
  protected
   procedure checkfootprints();
   procedure resetkindfootprints();
   procedure refreshkindfootprints();
  public
   constructor create(const idfield: tmselargeintfield;
                                        const nonavig: boolean); reintroduce;
 end;
implementation
uses
 componenteditform_mfm,mainmodule,vendormodule,main,msebufdataset,msesqldb;

{ tcomponenteditfo }

constructor tcomponenteditfo.create(const idfield: tmselargeintfield;
                                                    const nonavig: boolean);
begin
 mainmo.begincomponentedit(idfield);
 inherited create(nil);
 if nonavig then begin
  navig.options:= navig.options + [dno_nonavig,dno_noinsert];
 end
 else begin
  navig.options:= navig.options - [dno_nonavig,dno_noinsert];
 end;
 fstatebefore:= dataso.dataset.state;
 checkfootprints();
end;
{
procedure tcomponenteditfo.closeev(const sender: TObject);
begin
 mainmo.endcomponentedit(dno_nonavig in navig.options); //true -> full refresh
end;
}
procedure tcomponenteditfo.editfootprintev(const sender: TObject);
begin
 mainfo.editfootprint(mainmo.sc_footprint);
 datachangeev(nil,nil); //refresh empty text
end;

procedure tcomponenteditfo.editcompkindev(const sender: TObject);
begin
 mainfo.editcomponentkind(mainmo.sc_componentkind);
 datachangeev(nil,nil); //refresh empty text
end;

procedure tcomponenteditfo.editmanufacturerev(const sender: TObject);
begin
 mainfo.editmanufacturer(mainmo.sc_manufacturer);
end;

procedure tcomponenteditfo.editdistributorev(const sender: TObject);
begin
 mainfo.editdistributor(vendormo.cd_distributor);
end;

procedure tcomponenteditfo.datachangeev(Sender: TObject; Field: TField);
var
 bm1: bookmarkdataty;
begin
 with mainmo do begin
  if (field = nil) or (field = sc_componentkind) then begin
   if not sc_componentkind.isnull and 
         compkindqu.indexlocal[0].find([sc_componentkind],bm1) then begin
    footprinted.empty_text:= 
                     compkindqu.currentbmasmsestring[k_footprintname,bm1];

    descriptioned.empty_text:= 
                     compkindqu.currentbmasmsestring[k_description,bm1];
    parameter1ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter1,bm1];
    parameter2ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter2,bm1];
    parameter3ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter3,bm1];
    parameter4ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter4,bm1];
   end
   else begin
    footprinted.empty_text:= '';
    descriptioned.empty_text:= '';
    parameter1ed.empty_text:= '';
    parameter2ed.empty_text:= '';
    parameter3ed.empty_text:= '';
    parameter4ed.empty_text:= '';
   end;
  end;
 end;
end;

procedure tcomponenteditfo.macrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 info.caption:= mainmo.expandcomponentmacros(
                         tmsestringfield(tdbstringedit(sender).datalink.field));
 include(info.flags,hfl_show); //show empty hint
end;

procedure tcomponenteditfo.statechangeev(Sender: TObject);
var
 ds1: tdatasetstate;
begin
 with tmsesqlquery(dataso.dataset) do begin
  ds1:= state;
  if (dno_nonavig in navig.options) and (ds1 = dsbrowse) and 
             (fstatebefore = dsinsert) and controller.canceling then begin
   window.modalresult:= mr_cancel;
  end;
  checkfootprints();
 end;
 fstatebefore:= ds1;
end;

procedure tcomponenteditfo.editev(const sender: TObject);
begin
// if not mainmo.compfootprintdso.refreshing then begin
 if not tmsesqlquery(dataso.dataset).controller.canceling then begin
  dataso.dataset.edit();
  dataso.dataset.modify(); //set modified flag
 end;
end;

procedure tcomponenteditfo.readonlychangeev(const sender: TObject;
               const avalue: Boolean);
begin
 with footprintgrid do begin
  datacols.readonly:= avalue;
  norowedit:= avalue;
  if avalue then begin
   removeappendedrow();
  end;  
  checkfootprints();
 end;
end;

procedure tcomponenteditfo.nofootprintschaev(const sender: TObject;
               var avalue: Boolean);
begin
 checkfootprints();
end;

procedure tcomponenteditfo.checkfootprints();
begin
// if (not footprintgrid.entered or not navig.canautoedit) and
 if not tmsesqlquery(dataso.dataset).controller.posting1 then begin
  if not (dataso.state in [dsedit,dsinsert]) and nofootprints.value then begin
   mainmo.getfootprintsfromcompkind();
   if not fhaskindfootprints then begin
    fhaskindfootprints:= true;
    with footprintgrid.datacols.font do begin
     color:= cl_dkgray;
     italic:= true;
    end;
   end;
  end
  else begin
   resetkindfootprints;
  end;
 end;
end;

procedure tcomponenteditfo.resetkindfootprints();
begin
 if fhaskindfootprints then begin
  mainmo.compfootprintdso.refresh();
   with footprintgrid.datacols.font do begin
    color:= cl_text;
    italic:= false;
   end;
  fhaskindfootprints:= false;
 end;
end;

procedure tcomponenteditfo.refreshkindfootprints();
begin
 if fhaskindfootprints then begin
  mainmo.getfootprintsfromcompkind();
 end;
end;

procedure tcomponenteditfo.updatedataev(Sender: TObject);
begin
 footprintgrid.removeappendedrow();
end;

end.
