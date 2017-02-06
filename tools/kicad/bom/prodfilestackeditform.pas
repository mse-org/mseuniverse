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
 msesplitter,mdb,msedbedit,msegraphedits,msegrids,mselookupbuffer,msescrollbar;

type
 tprodfilestackeditfo = class(trecordnameeditfo)
   outputdired: tdbfilenameedit;
   stripe3: tlayouter;
   createziped: tdbbooleanedit;
   zipfileed: tdbfilenameedit;
   mainzipdired: tdbstringedit;
 end;
implementation
uses
 prodfilestackeditform_mfm;
end.
