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
unit docuseteditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordnameeditform,mseact,msedataedits,msedbdialog,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestatfile,msestream,msestrings,sysutils,
 msesplitter,mseprinter,mdb,msedbedit,msegraphedits,msegrids,mselookupbuffer,
 msescrollbar,msewidgetgrid,msedatanodes,mselistbrowser;

type
 tdocuseteditfo = class(trecordnameeditfo)
   docudired: tdbfilenameedit;
   stripe3: tlayouter;
   pagesizeed: tpagesizeselector;
   leftmarged: tdbrealedit;
   widthed: tdbrealedit;
   heighted: tdbrealedit;
   rightmarged: tdbrealedit;
   topmarged: tdbrealedit;
   bottommarged: tdbrealedit;
   grid: twidgetgrid;
   titleed: tstringedit;
   pagekinded: tenumedit;
   docupageeditbu: tstockglyphdatabutton;
   pked: tint64edit;
   procedure readonlychangeev(const sender: TObject; const avalue: Boolean);
   procedure datachaev(Sender: TObject; Field: TField);
   procedure editedev(const sender: TObject);
 end;

implementation
uses
 docuseteditform_mfm;
 
procedure tdocuseteditfo.readonlychangeev(const sender: TObject;
               const avalue: Boolean);
const
 readonlyoptions = [og_autoappend,og_autofirstrow,og_rowinserting,
                    og_rowdeleting,og_rowmoving];
begin
 pagesizeed.readonly:= avalue;
 grid.datacols.readonly:= avalue;
 if avalue then begin
  grid.removeappendedrow();
  grid.optionsgrid:= grid.optionsgrid - readonlyoptions;
 end
 else begin
  grid.optionsgrid:= grid.optionsgrid + readonlyoptions;
 end;
end;

procedure tdocuseteditfo.datachaev(Sender: TObject; Field: TField);
begin
 pagesizeed.updatesize();
end;

procedure tdocuseteditfo.editedev(const sender: TObject);
begin
 dataso.dataset.edit();
end;

end.
