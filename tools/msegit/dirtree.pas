{ MSEgit Copyright (c) 2011 by Martin Schreiber
   
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
//
// under construction
//
unit dirtree;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msestatfile,
 msedataedits,mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,
 msedatanodes,mselistbrowser,mseact,mseactions,msebitmap;

type
 tdirtreefo = class(tdockform)
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   repoloadedact: taction;
   repoclosedact: taction;
   procedure loadedexe(const sender: TObject);
   procedure closedexe(const sender: TObject);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
  private
   frowsave: integer;
   fexpandedsave: expandedinfoarty;
  public
   procedure savestate;
   procedure restorestate;
 end;
var
 dirtreefo: tdirtreefo;
implementation
uses
 dirtree_mfm,mainmodule,filesform;
 
procedure tdirtreefo.loadedexe(const sender: TObject);
begin
 mainmo.dirtree.expanded:= true;
 treeed.itemlist.add(mainmo.dirtree,false);
 grid.row:= 0;
// treeedit.itemlist.assign(mainmo.dirtree,false);
end;

procedure tdirtreefo.closedexe(const sender: TObject);
begin
 treeed.itemlist.clear;
end;

procedure tdirtreefo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  filesfo.synctodirtree;
 end;
end;

procedure tdirtreefo.savestate;
begin
 grid.beginupdate;
 fexpandedsave:= treeed.itemlist.expandedstate;
end;

procedure tdirtreefo.restorestate;
begin
 grid.endupdate;
 treeed.itemlist.expandedstate:= fexpandedsave;
end;

end.
