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
unit componentkindeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordnameeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils,msedbdialog,mseactions,
 msewidgetgrid,msememodialog;

type
 tcomponentkindeditfo = class(trecordnameeditfo)
   stripe3: tlayouter;
   descriptioned: tdbdialogstringedit;
   param1ed: tdbmemodialogedit;
   param2ed: tdbmemodialogedit;
   commented: tdbmemodialogedit;
   param3ed: tdbmemodialogedit;
   footprinted1: tdbenum64editdb;
   param4ed: tdbmemodialogedit;
   distributored: tdbenum64editdb;
   manufacturered: tdbenum64editdb;
   footprintgrid: twidgetgrid;
   pked: tint64edit;
   footprintinfoed: tstringedit;
   footprintcommented: tmemodialogedit;
   tenum64editdb1: tenum64editdb;
   procedure footprintedev(const sender: TObject);
   procedure editmanufactorerev(const sender: TObject);
   procedure editdistributorev(const sender: TObject);
   procedure editev(const sender: TObject);
   procedure redonlychangeev(const sender: TObject; const avalue: Boolean);
   procedure updatedataev(Sender: TObject);
 end;

implementation
uses
 componentkindeditform_mfm,main,mainmodule,msesqldb;
 
procedure tcomponentkindeditfo.footprintedev(const sender: TObject);
begin
 mainfo.editfootprint(mainmo.k_footprint);
end;

procedure tcomponentkindeditfo.editmanufactorerev(const sender: TObject);
begin
 mainfo.editmanufacturer(mainmo.k_manufacturer);
end;

procedure tcomponentkindeditfo.editdistributorev(const sender: TObject);
begin
 mainfo.editdistributor(mainmo.k_distributor);
end;

procedure tcomponentkindeditfo.editev(const sender: TObject);
begin
// if not mainmo.compkfootprintdso.refreshing then begin
 if not tmsesqlquery(dataso.dataset).controller.canceling then begin
  dataso.dataset.edit();
  dataso.dataset.modify(); //set modified flag
 end;
end;

procedure tcomponentkindeditfo.redonlychangeev(const sender: TObject;
               const avalue: Boolean);
begin
 with footprintgrid do begin
  datacols.readonly:= avalue;
  norowedit:= avalue;
  if avalue then begin
   removeappendedrow();
  end
  else begin
   checkreautoappend();
  end;
 end;
end;

procedure tcomponentkindeditfo.updatedataev(Sender: TObject);
begin
 footprintgrid.removeappendedrow();
end;

end.
