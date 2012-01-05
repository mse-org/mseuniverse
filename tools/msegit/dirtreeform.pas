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
unit dirtreeform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msestatfile,
 msedataedits,mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,
 msedatanodes,mselistbrowser,mseact,mseactions,msebitmap,mainmodule;

type
 tdirtreefo = class(tdockform)
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   repoloadedact: taction;
   repoclosedact: taction;
   commitact: taction;
   gridpopup: tpopupmenu;
   reporefreshsedact: taction;
   addact: taction;
   revertact: taction;
   removeact: taction;
   procedure loadedexe(const sender: TObject);
   procedure closedexe(const sender: TObject);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure commitupdataexe(const sender: tcustomaction);
   procedure commitexe(const sender: TObject);
   procedure refreshedexe(const sender: TObject);
   procedure addexe(const sender: TObject);
   procedure addupdateexe(const sender: tcustomaction);
   procedure gridenterexe(const sender: TObject);
   procedure revertupdateexe(const sender: tcustomaction);
   procedure revertexe(const sender: TObject);
   procedure commitstagedexe(const sender: TObject);
   procedure removeexe(const sender: TObject);
   procedure removeupdateexe(const sender: tcustomaction);
  private
//   frowsave: integer;
   fexpandedsave: expandedinfoarty;
   fdirbefore: filenamety;
  protected
   function syncfilesfo: filenamety;
  public
   procedure savestate;
   procedure restorestate;
   function currentgitdir: filenamety;
   function setcurrentgitdir(const adir: filenamety): boolean;
                     //true if found
   function currentitem: tgitdirtreenode;
 end;

var
 dirtreefo: tdirtreefo;

implementation
uses
 dirtreeform_mfm,filesform,gitconsole,msewidgets,mseformatstr,
 main,mseeditglob,msearrayutils;
 
procedure tdirtreefo.loadedexe(const sender: TObject);
begin
 mainmo.dirtree.expanded:= true;
 treeed.itemlist.add(mainmo.dirtree,false);
 if not mainfo.refreshing then begin
  grid.row:= 0;
  syncfilesfo;
 end;
// treeedit.itemlist.assign(mainmo.dirtree,false);
end;

procedure tdirtreefo.closedexe(const sender: TObject);
begin
 treeed.itemlist.clear;
end;
{
 result:= '';
 .parent <> nil then begin
  result:= concatstrings(copy(treeed.item.rootcaptions,1,bigint),'/');
 end;
}
function tdirtreefo.syncfilesfo: filenamety;
begin
 result:= tgitdirtreenode(treeed.item).gitpath;
 if not application.terminated then begin
  filesfo.synctodirtree(result);
 end;
end;

procedure tdirtreefo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
var
 fna1: filenamety;
begin
 if isrowenter(info,true) and not application.terminated then begin
  mainfo.objchanged;
  fna1:= syncfilesfo;
  gitconsolefo.synctodirtree(fna1);
 end;
end;

procedure tdirtreefo.savestate;
begin
 grid.beginupdate;
 fexpandedsave:= treeed.itemlist.expandedstate;
 fdirbefore:= currentgitdir;
end;

procedure tdirtreefo.restorestate;
begin
 grid.endupdate;
 if fexpandedsave <> nil then begin
  treeed.itemlist.expandedstate:= fexpandedsave;
 end;
 setcurrentgitdir(fdirbefore);
end;

procedure tdirtreefo.commitupdataexe(const sender: tcustomaction);
begin
 sender.enabled:= treeed.selecteditems <> nil;
// sender.enabled:= mainmo.cancommit(
//                                gitdirtreenodearty(treeed.selecteditems));
end;

procedure tdirtreefo.commitexe(const sender: TObject);
begin
 if mainmo.commit(gitdirtreenodearty(treeed.selecteditems),false) then begin
  activate;
 end;
end;

procedure tdirtreefo.commitstagedexe(const sender: TObject);
begin
 grid.datacols.clearselection;
 grid.datacols.rowselected[grid.row]:= true;
 if mainmo.commit(gitdirtreenodearty(treeed.selecteditems),true) then begin
  activate;
 end;
end;


function tdirtreefo.currentgitdir: filenamety;
begin
 result:= '';
 if treeed.item <> nil then begin
  result:= tgitdirtreenode(treeed.item).gitpath;
 end;
end;

procedure tdirtreefo.refreshedexe(const sender: TObject);
begin
 syncfilesfo;
end;

procedure tdirtreefo.addexe(const sender: TObject);
var
 ar1: gitdirtreenodearty;
begin
 ar1:= gitdirtreenodearty(treeed.selecteditems);
 if askyesno('Do you want to add '+inttostrmse(length(ar1))+ 
                        ' directories?') then begin
  if mainmo.add(ar1) then begin
   mainfo.reloadact.execute;
  end;
 end;
 activate;
end;

procedure tdirtreefo.addupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= mainmo.canadd(gitdirtreenodearty(treeed.selecteditems));
end;

function tdirtreefo.currentitem: tgitdirtreenode;
begin
 result:= tgitdirtreenode(treeed.item);
end;

procedure tdirtreefo.gridenterexe(const sender: TObject);
begin
 filesfo.filelist.grid.datacols.clearselection;
 mainfo.objchanged;
end;

procedure tdirtreefo.revertupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= mainmo.canrevert(gitdirtreenodearty(treeed.selecteditems));
end;

procedure tdirtreefo.revertexe(const sender: TObject);
begin
 if mainmo.revert(gitdirtreenodearty(treeed.selecteditems)) then begin
  activate;
 end;
end;

procedure tdirtreefo.removeexe(const sender: TObject);
begin
 if mainmo.remove(gitdirtreenodearty(treeed.selecteditems)) then begin
  activate;
 end;
end;

procedure tdirtreefo.removeupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= mainmo.canremove(gitdirtreenodearty(treeed.selecteditems));
end;

function tdirtreefo.setcurrentgitdir(const adir: filenamety): boolean;
var
 ar1: msestringarty;
 n1: ttreelistitem;
begin
 result:= false;
 if (grid.rowcount > 0){ and (adir <> '')} then begin
  ar1:= splitstring(adir,'/');
  n1:= treeed.items[0];
  if ar1 <> nil then begin
   setlength(ar1,high(ar1));
  end;
  if high(ar1) >= 0 then begin
//   deleteitem(ar1,0);   
   n1:= n1.finditembycaption(ar1,true,true);
  end;
  result:= n1 <> nil;
  if result and (n1.index >= 0) then begin
   grid.row:= n1.index;
   if not grid.entered then begin
    grid.datacols.clearselection;
   end;
  end;
 end;
end;

end.
