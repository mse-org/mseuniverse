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
 mselistbrowser,msegraphedits,mseact,mseactions,mainmodule;

type
 tfilesfo = class(tdockform)
   grid: twidgetgrid;
   fileitemed: titemedit;
   originstate: tdataicon;
   filestate: tdataicon;
   gridpopup: tpopupmenu;
   commitact: taction;
   addact: taction;
   procedure udaterowvaluesexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure commitexe(const sender: TObject);
   procedure commitupdateexe(const sender: tcustomaction);
   procedure addupdateexe(const sender: tcustomaction);
   procedure addexe(const sender: TObject);
   procedure cellevexe(const sender: TObject; var info: celleventinfoty);
  private
   fpath: filenamety;
  public
   procedure loadfiles(const apath: filenamety);
   procedure synctodirtree(const apath: filenamety);
   function currentitem: tmsegitfileitem;
 end;
var
 filesfo: tfilesfo;
implementation
uses
 filesform_mfm,dirtreeform,msegitcontroller,msewidgets,mseformatstr,
 main,diffform;
 
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

procedure tfilesfo.commitexe(const sender: TObject);
begin
 mainmo.commit(tgitdirtreenode(dirtreefo.treeed.item),
                               msegitfileitemarty(fileitemed.selecteditems));
 activate;
end;

procedure tfilesfo.commitupdateexe(const sender: tcustomaction);
begin
 sender.enabled:=  mainmo.cancommit(
                               msegitfileitemarty(fileitemed.selecteditems));
end;

procedure tfilesfo.addupdateexe(const sender: tcustomaction);
begin
 sender.enabled:=  mainmo.canadd(
                               msegitfileitemarty(fileitemed.selecteditems));
end;

procedure tfilesfo.addexe(const sender: TObject);
var
 ar1: msegitfileitemarty;
begin
 ar1:= msegitfileitemarty(fileitemed.selecteditems);
 if askyesno('Do you want to add '+inttostrmse(length(ar1))+ 
                        ' files?') then begin
  if mainmo.add(tgitdirtreenode(dirtreefo.treeed.item),ar1) then begin
   mainfo.reload;
  end;
 end;    
 activate;
end;

procedure tfilesfo.cellevexe(const sender: TObject; var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  difffo.refresh(dirtreefo.currentitem,currentitem);
 end;
end;

function tfilesfo.currentitem: tmsegitfileitem;
begin
 result:= tmsegitfileitem(fileitemed.item);
end;

end.
