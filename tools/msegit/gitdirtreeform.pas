{ MSEgit Copyright (c) 2011-2012 by Martin Schreiber
   
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
unit gitdirtreeform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msestatfile,
 msedataedits,mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,
 msedatanodes,mselistbrowser,mseact,mseactions,msebitmap,mainmodule,mseificomp,
 mseificompglob;

type
 tgitdirtreefo = class(tdockform)
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   repoloadedact: taction;
   repoclosedact: taction;
   commitact: taction;
   gridpopup: tpopupmenu;
   reporefreshsedact: taction;
   addact: taction;
   restoreact: taction;
   removeact: taction;
   commitstagedact: taction;
   renameact: taction;
   procedure loadedexe(const sender: TObject);
   procedure closedexe(const sender: TObject);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure commitupdataexe(const sender: tcustomaction);
   procedure commitexe(const sender: TObject);
   procedure refreshedexe(const sender: TObject);
   procedure addexe(const sender: TObject);
   procedure addupdateexe(const sender: tcustomaction);
   procedure gridenterexe(const sender: TObject);
   procedure restoreupdateexe(const sender: tcustomaction);
   procedure restoreexe(const sender: TObject);
   procedure commitstagedexe(const sender: TObject);
   procedure removeexe(const sender: TObject);
   procedure removeupdateexe(const sender: tcustomaction);
   procedure openrepoexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu);
   procedure renameupdate(const sender: tcustomaction);
   procedure renameexe(const sender: TObject);
  private
   fexpandedsave: expandedinfoarty;
   fdirbefore: filenamety;
   fdirtreebefore: tgitdirtreenode;
  protected
  public
   function syncfilesfo(const refreshlog: boolean): filenamety;
   procedure savestate;
   procedure restorestate;
   function currentgitdir: filenamety;
   function setcurrentgitdir(const adir: filenamety): boolean;
                     //true if found
   function currentitem: tgitdirtreenode;
 end;

var
 gitdirtreefo: tgitdirtreefo;

implementation
uses
 gitdirtreeform_mfm,filesform,gitconsole,msewidgets,mseformatstr,
 main,mseeditglob,msearrayutils,sysutils;
 
procedure tgitdirtreefo.loadedexe(const sender: TObject);
begin
 mainmo.dirtree.expanded:= true;
 if mainfo.refreshing then begin
  grid.clear;
 end;
 treeed.itemlist.add(mainmo.dirtree,false);
 if not mainfo.refreshing then begin
  grid.row:= 0;
  syncfilesfo(true);
 end;
// treeedit.itemlist.assign(mainmo.dirtree,false);
end;

procedure tgitdirtreefo.closedexe(const sender: TObject);
begin
 if not mainfo.refreshing then begin
  treeed.itemlist.clear;
 end;
end;

function tgitdirtreefo.syncfilesfo(const refreshlog: boolean): filenamety;
begin
 result:= tgitdirtreenode(treeed.item).gitpath;
 if not application.terminated then begin
  filesfo.synctodirtree(result,refreshlog);
 end;
end;

procedure tgitdirtreefo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
var
 fna1: filenamety;
begin
 if wasrowenter(info,true) and not application.terminated then begin
  mainfo.objchanged(true);
  fna1:= syncfilesfo(true);
  gitconsolefo.synctodirtree(fna1);
  filesfo.filelist.grid.datacols.clearselection;
 end;
end;

procedure tgitdirtreefo.savestate;
begin
 grid.beginupdate;
 fexpandedsave:= treeed.itemlist.expandedstate;
 fdirbefore:= currentgitdir;
 fdirtreebefore:= mainmo.dirtree;
 mainmo.releasedirtree;
end;

procedure tgitdirtreefo.restorestate;
begin
 freeandnil(fdirtreebefore);
 grid.endupdate;
 if fexpandedsave <> nil then begin
  treeed.itemlist.expandedstate:= fexpandedsave;
 end;
 if grid.row < 0 then begin
  grid.row:= 0;
 end;
 setcurrentgitdir(fdirbefore);
end;

procedure tgitdirtreefo.commitupdataexe(const sender: tcustomaction);
begin
 sender.enabled:= treeed.selecteditems <> nil;
// sender.enabled:= mainmo.cancommit(
//                                gitdirtreenodearty(treeed.selecteditems));
end;

procedure tgitdirtreefo.commitexe(const sender: TObject);
begin
 if mainmo.commit(gitdirtreenodearty(treeed.selecteditems),false) then begin
  activate;
 end;
end;

procedure tgitdirtreefo.commitstagedexe(const sender: TObject);
begin
 grid.datacols.clearselection;
 grid.datacols.rowselected[grid.row]:= true;
 if mainmo.commit(gitdirtreenodearty(treeed.selecteditems),true) then begin
  activate;
 end;
end;


function tgitdirtreefo.currentgitdir: filenamety;
begin
 result:= '';
 if treeed.item <> nil then begin
  result:= tgitdirtreenode(treeed.item).gitpath;
 end;
end;

procedure tgitdirtreefo.refreshedexe(const sender: TObject);
begin
 syncfilesfo(true);
end;

procedure tgitdirtreefo.addexe(const sender: TObject);
var
 ar1: gitdirtreenodearty;
begin
 ar1:= gitdirtreenodearty(treeed.selecteditems);
 if askconfirmation('Do you want to add '+inttostrmse(length(ar1))+ 
                        ' directories?') then begin
  if mainmo.add(ar1) then begin
   mainfo.reloadact.execute;
  end;
 end;
 activate;
end;

procedure tgitdirtreefo.addupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= mainmo.canadd(gitdirtreenodearty(treeed.selecteditems));
end;

function tgitdirtreefo.currentitem: tgitdirtreenode;
begin
 result:= tgitdirtreenode(treeed.item);
end;

procedure tgitdirtreefo.gridenterexe(const sender: TObject);
begin
 filesfo.filelist.grid.datacols.clearselection;
 mainfo.objchanged(true);
end;

procedure tgitdirtreefo.restoreupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= mainmo.canrevert(gitdirtreenodearty(treeed.selecteditems));
end;

procedure tgitdirtreefo.restoreexe(const sender: TObject);
begin
 if mainmo.restore(gitdirtreenodearty(treeed.selecteditems)) then begin
  activate;
 end;
end;

procedure tgitdirtreefo.removeexe(const sender: TObject);
begin
 if mainmo.remove(gitdirtreenodearty(treeed.selecteditems)) then begin
  activate;
 end;
end;

procedure tgitdirtreefo.removeupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= mainmo.canremove(gitdirtreenodearty(treeed.selecteditems));
end;

function tgitdirtreefo.setcurrentgitdir(const adir: filenamety): boolean;
var
 ar1: msestringarty;
 n1: ttreelistitem;
begin
 result:= false;
 if (grid.rowcount > 0){ and (adir <> '')} then begin
  ar1:= splitstring(adir,msechar('/'));
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

procedure tgitdirtreefo.openrepoexe(const sender: TObject);
begin
 mainmo.repo:= mainmo.reporoot + '/'+currentitem.gitbasepath;
end;

procedure tgitdirtreefo.popupupdateexe(const sender: tcustommenu);
begin
 sender.menu.itembyname('openrepo').enabled:= treeed.item <> nil;
end;

procedure tgitdirtreefo.renameupdate(const sender: tcustomaction);
begin
 sender.enabled:= currentitem <> nil;
end;

procedure tgitdirtreefo.renameexe(const sender: TObject);
begin
 mainmo.rename(currentitem.gitbasepath);
end;

end.
