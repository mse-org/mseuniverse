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
unit filesform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msedatanodes,
 mselistbrowser;

type
 tfilesfo = class(tdockform)
   grid: twidgetgrid;
   fileitemed: titemedit;
  private
   fpath: filenamety;
  public
   procedure loadfiles(const apath: filenamety);
   procedure synctodirtree;
 end;
var
 filesfo: tfilesfo;
implementation
uses
 filesform_mfm,mainmodule,dirtreeform;
 
{ tfilesfo }

procedure tfilesfo.loadfiles(const apath: filenamety);
begin
 fpath:= apath;
 if apath = '' then begin
  grid.clear;
 end
 else begin
  fileitemed.itemlist.assign(listitemarty(mainmo.getfiles(apath)));
 end;
end;

procedure tfilesfo.synctodirtree;
var
 ar1: msestringarty;
 mstr1: msestring;
begin
 if visible and (dirtreefo.grid.row >= 0) then begin
  ar1:= dirtreefo.treeed.item.rootcaptions;
  mstr1:= '';
  if high(ar1) > 0 then begin
   mstr1:= concatstrings(copy(dirtreefo.treeed.item.rootcaptions,1,bigint),'/');
  end;
  loadfiles(mainmo.repo+'/'+mstr1);
 end;
end;

end.
