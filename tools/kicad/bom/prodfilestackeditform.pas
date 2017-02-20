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
unit prodfilestackeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordnameeditform,mseact,msedataedits,msedbdialog,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestatfile,msestream,msestrings,sysutils,
 msesplitter,mdb,msedbedit,msegraphedits,msegrids,mselookupbuffer,msescrollbar,
 msewidgetgrid,msedragglob,msetabs,mseactions;

type
 tprodfilestackeditfo = class(trecordnameeditfo)
   outputdired: tdbfilenameedit;
   stripe3: tlayouter;
   createziped: tdbbooleanedit;
   zipfileed: tdbfilenameedit;
   mainzipdired: tdbstringedit;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   plotsgrid: twidgetgrid;
   layered: tdropdownlistedit;
   plotfileed: tstringedit;
   plotformated: tdropdownlistedit;
   drillmarked: tdropdownlistedit;
   ttabpage2: ttabpage;
   drillgrid: twidgetgrid;
   layeraed: tdropdownlistedit;
   layerbed: tdropdownlistedit;
   nonplateded: tbooleanedit;
   drillfileed: tstringedit;
   plotpk: tint64edit;
   val_refon: tbooleanedit;
   val_valon: tbooleanedit;
   val_invison: tbooleanedit;
   drillpk: tint64edit;
   stripe4: tlayouter;
   alldrilled: tdbbooleanedit;
   drillpreved: tdbstringedit;
   drillsuffed: tdbstringedit;
   alldrillnpted: tdbbooleanedit;
   drillprefnpted: tdbstringedit;
   drillsuffnpted: tdbstringedit;
   ttabpage3: ttabpage;
   posgrid: twidgetgrid;
   tint64edit2: tint64edit;
   posfronted: tbooleanedit;
   posbacked: tbooleanedit;
   posfileed: tstringedit;
   selsmded: tbooleanedit;
   bompage: ttabpage;
   bomgrid: twidgetgrid;
   tint64edit3: tint64edit;
   bomed: tbooleanedit;
   partlistfileed: tstringedit;
   tstockglyphdatabutton1: tstockglyphdatabutton;
   bomfieldact: taction;
   procedure editedev(const sender: TObject);
   procedure readonlychangeev(const sender: TObject; const avalue: Boolean);
   procedure formatsetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure plotfilesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure drillfilesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure bomfieldeditev(const sender: tcustomaction);
   procedure bomfieldcellev(const sender: TObject; var info: celleventinfoty);
   procedure updatedataev(Sender: TObject);
 end;
implementation
uses
 prodfilestackeditform_mfm,bommodule,msefileutils,mainmodule,msegridsglob,
 msekeyboard,msesqldb;
 
procedure tprodfilestackeditfo.editedev(const sender: TObject);
begin
// if not (bommo.plotitemdso.refreshing or bommo.drillitemdso.refreshing or 
//     bommo.positemdso.refreshing or bommo.bomitemdso.refreshing) then begin
// if not (plotsgrid.autoremoving or drillgrid.autoremoving or
//         posgrid.autoremoving or bomgrid.autoremoving) then begin
 if not tmsesqlquery(dataso.dataset).controller.canceling then begin
  dataso.dataset.edit();
  dataso.dataset.modify(); //set modified flag
 end;
end;

procedure tprodfilestackeditfo.readonlychangeev(const sender: TObject;
               const avalue: Boolean);
begin
 plotsgrid.datacols.readonly:= avalue;
 drillgrid.datacols.readonly:= avalue;
 posgrid.datacols.readonly:= avalue;
 bomgrid.datacols.readonly:= avalue;
 plotsgrid.norowedit:= avalue;
 drillgrid.norowedit:= avalue;
 posgrid.norowedit:= avalue;
 bomgrid.norowedit:= avalue;
 if avalue then begin
  plotsgrid.removeappendedrow();
  drillgrid.removeappendedrow();
  posgrid.removeappendedrow();
  bomgrid.removeappendedrow();
 end
 else begin
//  if not tmsesqlquery(dataso.dataset).controller.posting1 then begin
   plotsgrid.checkreautoappend();
   drillgrid.checkreautoappend();
   posgrid.checkreautoappend();
   bomgrid.checkreautoappend();
  end;
// end;
end;

procedure tprodfilestackeditfo.formatsetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if plotfileed.value <> '' then begin
  if fileext(plotfileed.value) = 
      fileformatexts[mainmo.getfileformat(plotformated.value)] then begin
   plotfileed.value:= replacefileext(plotfileed.value,
                                fileformatexts[mainmo.getfileformat(avalue)]);
  end;
 end;
end;

procedure tprodfilestackeditfo.plotfilesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if not hasfileext(avalue) and (plotformated.value <> '') then begin
  avalue:= replacefileext(avalue,
           fileformatexts[mainmo.getfileformat(plotformated.value)]);
 end;
end;

procedure tprodfilestackeditfo.drillfilesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if (avalue <> '') and not hasfileext(avalue) then begin
  avalue:= avalue + '.drl';
 end;
end;

procedure tprodfilestackeditfo.bomfieldeditev(const sender: tcustomaction);
begin
 bommo.editbomfields(bomgrid.row);
end;

procedure tprodfilestackeditfo.bomfieldcellev(const sender: TObject;
               var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) or (info.eventkind = cek_keydown) and
                (info.keyeventinfopo^.key = key_f3) then begin
  bomfieldact.execute();
 end;
end;

procedure tprodfilestackeditfo.updatedataev(Sender: TObject);
begin
 bomgrid.removeappendedrow();
end;

end.
