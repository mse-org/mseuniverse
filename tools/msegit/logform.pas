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
unit logform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,dispform,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,mainmodule,
 msegraphedits,mseact,mseactions;

type
 tlogfo = class(tdispfo)
   grid: twidgetgrid;
   message: tstringedit;
   commit: tstringedit;
   commitdate: tdatetimeedit;
   committer: tstringedit;
   diffbase: tbooleaneditradio;
   tpopupmenu1: tpopupmenu;
   checkoutact: taction;
   num: tintegeredit;
   procedure diffbasesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure getmorerowsexe(const sender: tcustomgrid; const count: Integer);
   procedure checkoutexe(const sender: TObject);
   procedure updateexe(const sender: tcustomaction);
  private
   fpath: filenamety;
  protected
   procedure dorefresh; override;
   procedure doclear; override;   
   procedure getrevs(const skip: integer);
  public
   procedure refresh(const adir: tgitdirtreenode; const afile: tmsegitfileitem);
   function currentcommit: msestring;
   function currentcommithint: msestring;
 end;

var
 logfo: tlogfo;
implementation
uses
 logform_mfm,msegitcontroller,main,dirtreeform,filesform,msewidgets;

{ tlogfo }

procedure tlogfo.getrevs(const skip: integer);
var
 ar1: refinfoarty;
 po1,po2,po4: pmsestring;
 po3: pdatetime;
 po5: pinteger;
 int1: integer;
begin
 if mainmo.git.revlist(ar1,fpath,mainmo.opt.maxlog,skip) then begin
  if skip = 0 then begin
   diffbase.checkedrow:= -1;
  end;
  grid.beginupdate;
  grid.rowcount:= length(ar1)+skip;
  po1:= message.griddata.datapo;
  po2:= commit.griddata.datapo;
  po3:= commitdate.griddata.datapo;
  po4:= committer.griddata.datapo;
  po5:= num.griddata.datapo;
  for int1:= skip to high(ar1)+skip do begin
   with ar1[int1-skip] do begin
    po1[int1]:= message;
    po2[int1]:= commit;
    po3[int1]:= commitdate;
    po4[int1]:= committer;
    po5[int1]:= int1;
   end;
  end;
  if (skip = 0) and (grid.rowcount > 0) then begin
   grid.row:= 0;
  end;
  grid.rowdatachanged;
  grid.endupdate;
  if diffbase.checkedrow >= 0 then begin
   mainfo.diffchanged;
  end;
 end
 else begin
  grid.clear;
 end;
end;

procedure tlogfo.dorefresh;
begin
 getrevs(0);
end;

procedure tlogfo.getmorerowsexe(const sender: tcustomgrid;
               const count: Integer);
var
 int1: integer;
begin
 int1:= count;
 if (grid.datacols.sortcol = commitdate.gridcol) and 
                 not (co_sortdescend in commitdate.widgetcol.options) then begin
  int1:= -int1;
 end;
 if int1 > 0 then begin
  getrevs(grid.rowcount);
 end;
end;

procedure tlogfo.doclear;
begin
 fpath:= '';
 grid.clear;
end;

procedure tlogfo.refresh(const adir: tgitdirtreenode;
               const afile: tmsegitfileitem);
begin
 fpath:= '';
 if (adir <> nil) then begin
  fpath:= adir.gitpath;
  if afile <> nil then begin
   fpath:= fpath+afile.caption;
  end;
 end;
 inherited refresh;
end;

procedure tlogfo.diffbasesetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if visible then begin
  mainfo.diffchanged;
 end;
end;

procedure tlogfo.celleventexe(const sender: TObject; var info: celleventinfoty);
begin
 if visible and isrowenter(info,true) and (diffbase.checkedrow >= 0) then begin
  mainfo.diffchanged;
 end;
end;

procedure tlogfo.updateexe(const sender: tcustomaction);
var
 bo1: boolean;
begin
 bo1:= mainmo.repoloaded and (grid.row >= 0);
 checkoutact.enabled:= bo1;
end;

procedure tlogfo.checkoutexe(const sender: TObject);
begin
 if askyesno('Do you want to checkout ' + commit.value+'?') and
              mainmo.checkout(commit.value,dirtreefo.currentitem,
                            filesfo.filelist.currentitems) then begin
  mainfo.reload;
 end;
end;

function tlogfo.currentcommit: msestring;
begin
 if not isvisible or (grid.row < 0) then begin
  result:= 'HEAD';
 end
 else begin
  result:= commit.value;
 end;
end;

function tlogfo.currentcommithint: msestring;
begin
 if not isvisible or (grid.row < 0) then begin
  result:= 'HEAD';
 end
 else begin
  result:= commit.value + lineend + firstline(message.value);
 end;
end;

end.
