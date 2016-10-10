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
unit footprintliblistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 msedb,mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,
 msestream,msestrings,sysutils;

type
 tfootprintliblistfo = class(tlisteditfo)
   tdbstringedit1: tdbstringedit;
//   procedure closeev(const sender: TObject);
  public
//   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 footprintliblistform_mfm,mainmodule;
 
{ tfootprintliblistfo }
{
constructor tfootprintliblistfo.create(const aid: tmselargeintfield);
begin
 mainmo.beginfootprintlibedit(aid);
 inherited create(nil);
end;
}
{
procedure tfootprintliblistfo.closeev(const sender: TObject);
begin
 mainmo.endfootprintlibedit();
end;
}
end.
