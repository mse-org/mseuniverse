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
 msegraphedits,mseact,mseactions,mselistbrowser,msedatanodes;

type
 logbranchinfoty = record
  remotename: msestring;
  branchname: msestring;
 end;
 logbranchinfoarty = array of logbranchinfoty;
 
 tlogitem = class(trichlistedititem)
  protected
   fbranchinfo: logbranchinfoarty;
  public
//   constructor create(const aowner: tcustomitemlist); override;
 end;
 plogitem = ^tlogitem;
 
 tlogfo = class(tdispfo)
   grid: twidgetgrid;
   message: titemedit;
   commit: tstringedit;
   commitdate: tdatetimeedit;
   committer: tstringedit;
   diffbase: tbooleaneditradio;
   tpopupmenu1: tpopupmenu;
   checkoutact: taction;
   num: tintegeredit;
   branchact: taction;
   cherrypickact: taction;
   diffmode: tdatabutton;
   procedure diffbasesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure getmorerowsexe(const sender: tcustomgrid; const count: Integer);
   procedure checkoutexe(const sender: TObject);
   procedure updateexe(const sender: tcustomaction);
   procedure createmessageitemexe(const sender: tcustomitemlist;
                   var item: tlistedititem);
   procedure branchexe(const sender: TObject);
   procedure cherrypickexe(const sender: TObject);
   procedure modeselexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
  private
   fpath: filenamety;
  protected
   procedure dorepoloaded; override;
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
 logform_mfm,msegitcontroller,main,dirtreeform,filesform,msewidgets,
 mserichstring,branchform,mseeditglob;

{ tlogfo }

procedure tlogfo.getrevs(const skip: integer);
var
 ar1: refinfoarty;
 po1: plogitem;
 po2,po4: pmsestring;
 po3: pdatetime;
 po5: pinteger;
 int1,int2: integer;
 ar2: refsitemarty;
 fm1: formatinfoarty;
 rs1: richstringty;
 cl1: colorty;
 mstr1: msestring;
 currentbranch,currentremote,currentremotebranch: msestring;
begin
 mstr1:= mainmo.repostat.activelogcommit;
 if (mstr1 <> '') and mainmo.git.revlist(ar1,mstr1,fpath,
                mainmo.opt.maxlog,skip) then begin
  if skip = 0 then begin
   diffbase.checkedrow:= -1;
  end;
  grid.beginupdate;
  currentbranch:= mainmo.activebranch;
  currentremote:= mainmo.activeremote;
  currentremotebranch:= mainmo.activeremotebranch[currentremote];
  grid.rowcount:= length(ar1)+skip;
  po1:= message.griddata.datapo;
  po2:= commit.griddata.datapo;
  po3:= commitdate.griddata.datapo;
  po4:= committer.griddata.datapo;
  po5:= num.griddata.datapo;
  fm1:= setcolorbackground(nil,0,bigint,cl_transparent);
  for int1:= skip to high(ar1)+skip do begin
   with ar1[int1-skip] do begin
    with po1[int1] do begin
     fcaption:= message;
     fformat:= nil;
     ar2:= mainmo.refsinfo.getitemsbycommit(commit);
     setlength(fbranchinfo,length(ar2));
     for int2:= high(ar2) downto 0 do begin
      with fbranchinfo[int2] do begin
       remotename:= ar2[int2].remote;
       branchname:= ar2[int2].info.name;
       cl1:= cl_ltgreen;
       if remotename = '' then begin
        if branchname = currentbranch then begin
         cl1:= cl_ltred;
        end;
       end
       else begin
        if (remotename = currentremote) and 
               (branchname = currentremotebranch) then begin
         cl1:= cl_ltred;
        end;
       end;
       if fformat = nil then begin
        fformat:= fm1;
       end;
       rs1:= richconcat(' ',richcaption,[],cl_none,cl_transparent);
       if remotename <> '' then begin
        rs1:= richconcat(remotename+'/'+branchname,rs1,[],cl_none,cl1);
       end
       else begin
        rs1:= richconcat(branchname,rs1,[],cl_none,cl1);
       end;
       fcaption:= rs1.text;
       fformat:= rs1.format;
      end;
     end;
    end;
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
 if mainmo.repoloaded then begin
  int1:= count;
  if (grid.datacols.sortcol = commitdate.gridcol) and 
                  not (co_sortdescend in commitdate.widgetcol.options) then begin
   int1:= -int1;
  end;
  if int1 > 0 then begin
   getrevs(grid.rowcount);
  end;
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
  fpath:= adir.gitbasepath;
 end;
 if afile <> nil then begin
  fpath:= fpath+afile.caption;
 end;
 inherited refresh;
end;

procedure tlogfo.celleventexe(const sender: TObject; var info: celleventinfoty);
begin
 if visible and isrowenter(info,true) {and (diffbase.checkedrow >= 0)} then begin
  mainfo.diffchanged;
 end;
end;

procedure tlogfo.updateexe(const sender: tcustomaction);
var
 bo1: boolean;
begin
 bo1:= mainmo.repoloaded and (grid.row >= 0);
 checkoutact.enabled:= bo1;
 branchact.enabled:= bo1;
 cherrypickact.enabled:= bo1 and (diffmode.value = 1); 
end;

procedure tlogfo.checkoutexe(const sender: TObject);
begin
 if askyesno('Do you want to checkout ' + commit.value+'?') and
              mainmo.checkout(commit.value,dirtreefo.currentitem,
                            filesfo.filelist.currentitems) then begin
  mainfo.reload;
 end;
end;

procedure tlogfo.branchexe(const sender: TObject);
begin
 with branchfo do begin 
  localcreateexe(nil);
  localgrid.focuscell(mgc(1,localgrid.rowhigh));
  localbranchcommit.value:= self.commit.value;
  localgrid.activate;
 end;
end;

procedure tlogfo.cherrypickexe(const sender: TObject);
var
 ar1: integerarty;
 ar2: msestringarty;
 int1: integer;
begin
 if askyesno('Do you want to apply the changes of the selected commits to '+
                mainmo.activebranch+'?') then begin
  ar1:= grid.datacols.selectedrows;
  setlength(ar2,length(ar1));
  for int1:= 0 to high(ar1) do begin
   ar2[int1]:= commit[ar1[int1]];
  end;
  mainmo.cherrypick(ar2);
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
  result:= commit.value + lineend + firstline(message.item.caption);
 end;
end;

procedure tlogfo.createmessageitemexe(const sender: tcustomitemlist;
               var item: tlistedititem);
begin
 item:= tlogitem.create(sender);
end;

procedure tlogfo.dorepoloaded;
begin
 //dummy
end;

procedure tlogfo.diffbasesetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 grid.rowcolorstate[diffbase.checkedrow]:= -1;
 if avalue then begin
  grid.rowcolorstate[-1]:= 0;
  if diffmode.value <> 0 then begin
   accept:= false;
   exit;
  end;
 end;
 if visible then begin
  mainfo.diffchanged;
 end;
end;

procedure tlogfo.modeselexe(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 case avalue of
  1: begin
   diffmode.caption:= 'C';
   diffmode.color:= $EDBBBB;
   grid.rowcolorstate[diffbase.checkedrow]:= -1;
   diffbase.checkedrow:= -1;
   grid.datacols.options:= grid.datacols.options + 
                                    [co_keyselect,co_mouseselect];
  end;
  else begin
   diffmode.caption:= 'D';
   diffmode.color:= $BBEDBB;
   grid.datacols.clearselection;
   grid.datacols.options:= grid.datacols.options - 
                                   [co_keyselect,co_mouseselect];
   if grid.row >= 0 then begin
    grid.datacols.rowselected[grid.row]:= true;
   end;
  end;
 end;
 if visible and mainmo.repoloaded then begin
  mainfo.diffchanged;
 end;
end;

{ tlogitem }

end.
