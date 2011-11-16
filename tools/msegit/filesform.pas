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
 mselistbrowser,msegraphedits,mseact,mseactions,mainmodule,filelistframe,
 msetimer;

type
 tfilesfo = class(tdockform)
   gridpopup: tpopupmenu;
   commitact: taction;
   addact: taction;
   filelist: tfilelistframefo;
   revertact: taction;
   mergetoolact: taction;
   procedure udaterowvaluesexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure commitexe(const sender: TObject);
   procedure commitupdateexe(const sender: tcustomaction);
   procedure addupdateexe(const sender: tcustomaction);
   procedure addexe(const sender: TObject);
   procedure cellevexe(const sender: TObject; var info: celleventinfoty);
   procedure gridenterexe(const sender: TObject);
   procedure revertupdateexe(const sender: tcustomaction);
   procedure revertexe(const sender: TObject);
   procedure mergetoolexe(const sender: tcustomaction);
  private
   fpath: filenamety;
   ffilebefore: msestring;
  public
   procedure loadfiles(const apath: filenamety);
   procedure synctodirtree(const apath: filenamety);
   function currentitem: tmsegitfileitem;
   function currentfilepath: filenamety;
   procedure savestate;
   procedure restorestate;
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
  filelist.grid.clear;
 end
 else begin
  filelist.fileitemed.itemlist.assign(listitemarty(mainmo.getfiles(apath)));
 end;
end;

procedure tfilesfo.synctodirtree(const apath: filenamety);
begin
 loadfiles(mainmo.repo+'/'+apath);
 mainfo.objchanged;
end;

procedure tfilesfo.udaterowvaluesexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
//var
// int1: integer;
begin
 with tmsegitfileitem(aitem) do begin
  filelist.filestate[aindex]:= imagenr;
  filelist.originstate[aindex]:= getoriginicon;
 end;
end;

procedure tfilesfo.commitexe(const sender: TObject);
begin
 if mainmo.commit(tgitdirtreenode(dirtreefo.treeed.item), 
        msegitfileitemarty(filelist.fileitemed.selecteditems),false) then begin
  activate;
 end;
end;

procedure tfilesfo.commitupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= filelist.fileitemed.selecteditems <> nil;
// sender.enabled:=  mainmo.cancommit(
//                      msegitfileitemarty(filelist.fileitemed.selecteditems));
end;

procedure tfilesfo.addupdateexe(const sender: tcustomaction);
begin
 sender.enabled:=  mainmo.canadd(
                      msegitfileitemarty(filelist.fileitemed.selecteditems));
end;

procedure tfilesfo.addexe(const sender: TObject);
var
 ar1: msegitfileitemarty;
begin
 ar1:= msegitfileitemarty(filelist.fileitemed.selecteditems);
 if askyesno('Do you want to add '+inttostrmse(length(ar1))+ 
                        ' files?') then begin
  if mainmo.add(tgitdirtreenode(dirtreefo.treeed.item),ar1) then begin
   mainfo.reload;
  end;
 end;    
 activate;
end;

procedure tfilesfo.revertupdateexe(const sender: tcustomaction);
begin
 sender.enabled:=  mainmo.canrevert(
                      msegitfileitemarty(filelist.fileitemed.selecteditems));
end;

procedure tfilesfo.revertexe(const sender: TObject);
begin
 if mainmo.revert(tgitdirtreenode(dirtreefo.treeed.item),
             msegitfileitemarty(filelist.fileitemed.selecteditems)) then begin
  activate;
 end;
end;

procedure tfilesfo.cellevexe(const sender: TObject; var info: celleventinfoty);
begin
 if isrowenter(info) or isrowexit(info,true) then begin
  mainfo.objchanged;
 end;
end;

function tfilesfo.currentitem: tmsegitfileitem;
begin
 result:= tmsegitfileitem(filelist.fileitemed.item);
end;

function tfilesfo.currentfilepath: filenamety;
var
 n1: tmsegitfileitem;
begin
 result:= '';
 n1:= currentitem;
 if n1 <> nil then begin
  result:= mainmo.getpath(dirtreefo.currentitem,n1.caption);
 end;
end;

procedure tfilesfo.gridenterexe(const sender: TObject);
begin
 dirtreefo.grid.datacols.clearselection;
end;

procedure tfilesfo.mergetoolexe(const sender: tcustomaction);
var
 ar1: filenamearty;
begin
 setlength(ar1,1);
 ar1[0]:= currentfilepath;
 if ar1[0] <> '' then begin
  if mainmo.mergetoolcall(ar1) then begin
   activate;
  end;
 end;
end;

procedure tfilesfo.savestate;
begin
 ffilebefore:= filelist.currentfile;
end;

procedure tfilesfo.restorestate;
begin
 filelist.setcurrentfile(ffilebefore);
end;

end.
