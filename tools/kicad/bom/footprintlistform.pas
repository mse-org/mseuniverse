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
unit footprintlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils,msedb;

type
 tfootprintlistfo = class(tlisteditfo)
   areaed: tdbrealedit;
   tdbenum64editdb1: tdbenum64editdb;
   idented: tdbstringedit;
 //  procedure closeev(const sender: TObject);
   procedure libeditev(const sender: TObject);
  public
//   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 footprintlistform_mfm,mainmodule,main;

{ tfootprintlistfo }
{
constructor tfootprintlistfo.create(const aid: tmselargeintfield);
begin
 mainmo.beginfootprintedit(aid);
 inherited create(nil);
end;
}
{
procedure tfootprintlistfo.closeev(const sender: TObject);
begin
 mainmo.endfootprintedit();
end;
}
procedure tfootprintlistfo.libeditev(const sender: TObject);
begin
 mainfo.editfootprintlibev(nil);
end;

end.
