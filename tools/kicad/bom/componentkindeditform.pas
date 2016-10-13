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
 msescrollbar,msestatfile,msestream,msestrings,sysutils,msedbdialog;

type
 tcomponentkindeditfo = class(trecordnameeditfo)
   stripe3: tlayouter;
   descriptioned: tdbdialogstringedit;
   param1ed: tdbmemodialogedit;
   param2ed: tdbmemodialogedit;
   commented: tdbmemodialogedit;
   param3ed: tdbmemodialogedit;
   footprinted: tdbenum64editdb;
   param4ed: tdbmemodialogedit;
   distributored: tdbenum64editdb;
   manufacturered: tdbenum64editdb;
   procedure footprintedev(const sender: TObject);
 end;

implementation
uses
 componentkindeditform_mfm,main,mainmodule;
 
procedure tcomponentkindeditfo.footprintedev(const sender: TObject);
begin
 mainfo.editfootprint(mainmo.k_footprint);
end;

end.
