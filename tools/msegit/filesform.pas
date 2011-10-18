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
 mselistbrowser,msegraphedits;

type
 tfilesfo = class(tdockform)
   grid: twidgetgrid;
   fileitemed: titemedit;
   originstate: tdataicon;
   filestate: tdataicon;
   procedure udaterowvaluesexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
  private
   fpath: filenamety;
  public
   procedure loadfiles(const apath: filenamety);
   procedure synctodirtree(const apath: filenamety);
 end;
var
 filesfo: tfilesfo;
implementation
uses
 filesform_mfm,mainmodule,dirtreeform,msegitcontroller;
 
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

procedure tfilesfo.synctodirtree(const apath: filenamety);
begin
 loadfiles(mainmo.repo+'/'+apath);
end;

procedure tfilesfo.udaterowvaluesexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
//var
// int1: integer;
begin
 with tmsegitfileitem(aitem) do begin
  filestate[aindex]:= imagenr;
  originstate[aindex]:= getoriginicon;
 end;
end;

end.
