{ MSEgit Copyright (c) 2011-2013 by Martin Schreiber
   
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
 msegraphedits,mseact,mseactions,mselistbrowser,msedatanodes,msethreadcomp,
 msesystypes,classes,mclasses,mseificomp,mseificompglob,msestatfile,msestream,
 sysutils,msegitcontroller;

type
 logbranchinfoty = record
  remotename: msestring;
  branchname: msestring;
 end;
 logbranchinfoarty = array of logbranchinfoty;
 
 tlogitem = class(trichlistedititem)
  protected
   fbranchinfo: logbranchinfoarty;
   fmessage: msestring;
   function compare(const r: tlistitem;
                          const acasesensitive: boolean): integer; override;
  public
   property origmessage: msestring read fmessage;
 end;

 plogitem = ^tlogitem;
 logitematy = array[0..0] of tlogitem;
 plogitematy = ^logitematy;
 
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
   tagact: taction;
   refreshthread: tthreadcomp;
   revertact: taction;
   diffmodelink: tifiintegerlinkcomp;
   authordate: tdatetimeedit;
   author: tstringedit;
   parent: tstringedit;
   tree: tstringedit;
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
   procedure messagecelleventexe(const sender: TObject;
                   var info: celleventinfoty);
   procedure tagexe(const sender: TObject);
   procedure dorefreshexe(const sender: tthreadcomp);
   procedure filtereditexe(const sender: TObject);
   procedure revertexe(const sender: TObject);
   procedure diffmodeexe(const sender: TObject; const aclient: iificlient;
                   var avalue: Integer; var accept: Boolean;
                   const aindex: Integer);
  private
   fpath: filenamety;
  protected
   fgitproc: prochandlety;
   fasyncskip: integer;
   procedure dorepoloaded; override;
   procedure dorefresh; override;
   procedure doclear; override;   
   function dogetrevs(out alist: refinfoarty; const abranch: msestring;
              const acommitfilter: msestring; const amaxcount: integer;
              const askip: integer): boolean;
   procedure getrevs1(const sender: tthreadcomp; const skip: integer;
                                             const maxcount: int32 = 0);
   procedure getrevs(const async: boolean; const skip: integer);
   procedure updatefilterdisp();
   procedure setrefmode(const avalue: boolean);
  public
   constructor create(aowner: tcomponent); override;
   procedure refresh(const adir: tgitdirtreenode; const afile: tmsegitfileitem);
   function currentcommit: msestring;
   function isbasediff: boolean;
           //true if diffwindow shows diff to head
   function findcommit(const acommit: msestring): boolean;
 end;

var
 logfo: tlogfo;

implementation

uses
 logform_mfm,main,gitdirtreeform,filesform,msewidgets,
 mserichstring,branchform,mseeditglob,msegridsglob,tagdialogform,
 mseprocutils,editlogfilterform,commitdispform;

{ tlogfo }

constructor tlogfo.create(aowner: tcomponent);
begin
 fgitproc:= invalidprochandle;
 inherited;
end;

function tlogfo.dogetrevs(out alist: refinfoarty; const abranch: msestring;
              const acommitfilter: msestring; const amaxcount: integer;
              const askip: integer): boolean;
begin
 result:= mainmo.git.revlist(alist,abranch,fpath,
                            amaxcount,askip,
                            mainmo.repostat.logfilterauthor,
                            acommitfilter,
                            mainmo.repostat.logfilterdatemin,
                            mainmo.repostat.logfilterdatemax,
                            mainmo.repostat.logfiltercommitter,
                            mainmo.repostat.logfiltermessage,
                            mainmo.repostat.logfiltercasesens,
                            mainmo.repostat.logfiltercomplexregex);
end;

procedure tlogfo.getrevs1(const sender: tthreadcomp; const skip: integer;
                                                const maxcount: int32 = 0);
var
 ar1: refinfoarty;
 po1: plogitem;
 po2,po4: pmsestring;
 po3: pdatetime;
 po5: pinteger;
 pparent: pmsestringaty;
 ptree: pmsestringaty;
 pauthordate: pdatetimeaty;
 pauthor: pmsestringaty;
 int1,int2: integer;
 ar2: refsitemarty;
 fm1: formatinfoarty;
 rs1: richstringty;
 cl1: colorty;
 mstr1: msestring;
 currentbranch,currentremote,currentremotebranch: msestring;
 first: boolean;
 lastvisrow: integer; 
// fpath1: msestring;
 maxlog1: integer;
begin
 application.lock;
 mstr1:= mainmo.repostat.activelogcommit(true);
 maxlog1:= maxcount;
 if maxlog1 <= 0 then begin
  maxlog1:= mainmo.opt.maxlog;
 end;
 if sender <> nil then begin
  mainfo.beginbackground;
 end;
 application.unlock;
 
 if (mstr1 <> '') and dogetrevs(ar1,mstr1,mainmo.repostat.logfiltercommit,
                                                      maxlog1,skip) then begin
  application.lock;
  try
   if sender <> nil then begin
    mainfo.endbackground;
    if sender.terminated then begin
     exit;
    end;
   end;
   if skip = 0 then begin
    diffbase.checkedrow:= -1;
   end;
   lastvisrow:= grid.lastvisiblerow;
   grid.beginupdate;
   currentbranch:= mainmo.activebranch;
   currentremote:= mainmo.activeremote;
   currentremotebranch:= mainmo.activeremotebranch[currentremote];
   grid.rowcount:= length(ar1)+skip;
   po1:= message.griddata.datapo;
   po2:= commit.griddata.datapo;
   pparent:= parent.griddata.datapo;
   ptree:= tree.griddata.datapo;
   po3:= commitdate.griddata.datapo;
   po4:= committer.griddata.datapo;
   po5:= num.griddata.datapo;
   pauthordate:= authordate.griddata.datapo;
   pauthor:= author.griddata.datapo;
   fm1:= setcolorbackground(nil,0,bigint,cl_transparent);
   for int1:= skip to high(ar1)+skip do begin
    with ar1[int1-skip] do begin
     with plogitematy(po1)^[int1] do begin
      fcaption:= removelinebreaks(message);
      fmessage:= message;
      fformat:= nil;
      ar2:= mainmo.refsinfo.getitemsbycommit(commit);
      setlength(fbranchinfo,length(ar2));
      first:= true;
      for int2:= high(ar2) downto 0 do begin
       with fbranchinfo[int2] do begin
        remotename:= ar2[int2].remote;
        branchname:= ar2[int2].info.name;
        if ar2[int2].info.kind = refk_tag then begin
         cl1:= cl_ltyellow;
        end
        else begin
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
        end;
        if fformat = nil then begin
         fformat:= fm1;
        end;
        if first then begin
         rs1:= richconcat(lineend,richcaption,[],cl_none,cl_transparent);
         first:= false;
        end
        else begin
         rs1:= richconcat(' ',richcaption,[],cl_none,cl_transparent);
        end;
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
     pmsestringaty(po2)^[int1]:= commit;
     pparent^[int1]:= parent;
     ptree^[int1]:= tree;
     pdatetimeaty(po3)^[int1]:= commitdate;
     pmsestringaty(po4)^[int1]:= committer;
     pintegeraty(po5)^[int1]:= int1;
     pauthordate^[int1]:= authordate;
     pauthor^[int1]:= author;
    end;
   end;
   if (skip = 0) and (grid.rowcount > 0) then begin
    grid.row:= 0;
   end;
   grid.rowdatachanged;
   grid.endupdate;
   if skip > 0 then begin
    grid.showrow(lastvisrow);
   end;
   if diffbase.checkedrow >= 0 then begin
    mainfo.diffchanged;
   end;
   commitdispfo.refresh();
  finally
   application.unlock;
  end;
 end
 else begin
  application.lock;
  try
   mainfo.endbackground;
   grid.clear;
   commitdispfo.refresh();
  finally
   application.unlock;
  end;
 end;
 if sender <> nil then begin
  application.lock;
  mainfo.diffrefreshtimer.enabled:= false;
  mainfo.refreshdiff;
  application.unlock;
 end;
end;

procedure tlogfo.getrevs(const async: boolean; const skip: integer);
begin
 if async then begin
  refreshthread.terminate;
  terminateprocess(fgitproc);
  fasyncskip:= skip;
  refreshthread.run;
 end
 else begin
  getrevs1(nil,skip);
 end;
end;

procedure tlogfo.dorefresh;
begin
 mainfo.diffrefreshtimer.enabled:= false;
 setrefmode(false);
 getrevs(true,0);
// mainfo.diffrefreshtimer.restart;
end;

procedure tlogfo.dorefreshexe(const sender: tthreadcomp);
begin
 getrevs1(sender,fasyncskip);
end;

procedure tlogfo.getmorerowsexe(const sender: tcustomgrid;
               const count: Integer);
var
 int1: integer;
begin
 if mainmo.isrepoloaded then begin
  int1:= count;
  if (grid.datacols.sortcol = commitdate.gridcol) and 
                  not (co_sortdescend in commitdate.widgetcol.options) then begin
   int1:= -int1;
  end;
  if int1 > 0 then begin
   getrevs(false,grid.rowcount);
  end;
 end;
end;

procedure tlogfo.doclear;
begin
 if not mainfo.refreshing then begin
  fpath:= '';
  grid.clear;
  setrefmode(false);
 end;
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
  commitdispfo.refresh();
 end;
end;

procedure tlogfo.updateexe(const sender: tcustomaction);
var
 bo1: boolean;
begin
 bo1:= mainmo.isrepoloaded and (grid.row >= 0);
 checkoutact.enabled:= bo1;
 branchact.enabled:= bo1;
 tagact.enabled:= bo1;
 cherrypickact.enabled:= bo1 and (diffmode.value = 1);
 revertact.enabled:= cherrypickact.enabled and 
          (mainmo.activebranch = mainmo.repostat.activelocallogbranch);
end;

procedure tlogfo.checkoutexe(const sender: TObject);
begin
 mainfo.checkout(commit.value,true);
end;

procedure tlogfo.branchexe(const sender: TObject);
begin
 branchfo.createbranch(self.commit.value);
end;

procedure tlogfo.tagexe(const sender: TObject);
begin
 ttagdialogfo.create(nil).exec(commit.value);
end;

procedure tlogfo.cherrypickexe(const sender: TObject);
var
 ar1: integerarty;
 ar2: msestringarty;
 int1: integer;
begin
 if mainmo.repobase <> '' then begin
  showmessage('Cherry-pick not possible in sub-directories.','ERROR');
 end
 else begin
  if askconfirmation('Do you want to apply the changes of the selected commits to '+
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
end;

procedure tlogfo.revertexe(const sender: TObject);
var
 ar1: integerarty;
 ar2: msestringarty;
 int1: integer;
begin
 if mainmo.repobase <> '' then begin
  showmessage('Reverting commits not possible in sub-directories.','ERROR');
 end
 else begin
  if askconfirmation('Do you want to revert the selected commits?') then begin
   ar1:= grid.datacols.selectedrows;
   setlength(ar2,length(ar1));
   for int1:= 0 to high(ar1) do begin
    ar2[int1]:= commit[ar1[int1]];
   end;
   mainmo.revert(ar2);
   mainfo.reload;
  end;
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
{
function tlogfo.currentcommithint: msestring;
begin
 if not isvisible or (grid.row < 0) then begin
  result:= 'HEAD';
 end
 else begin
  result:= commit.value + lineend + firstline(message.item.caption);
 end;
end;
}
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
  if diffmode.value <> 0 then begin
   accept:= false;
   exit;
  end;
  grid.rowcolorstate[-1]:= 0;
  setrefmode(true);
 end
 else begin
  setrefmode(false);
 end;
 if visible then begin
  mainfo.diffchanged;
 end;
end;

procedure tlogfo.diffmodeexe(const sender: TObject; const aclient: iificlient;
               var avalue: Integer; var accept: Boolean; const aindex: Integer);
begin
 case avalue of
  1: begin
   setrefmode(false);
//   diffmode.caption:= 'C';
//   diffmode.color:= $EDBBBB;
   grid.rowcolorstate[diffbase.checkedrow]:= -1;
   diffbase.checkedrow:= -1;
   grid.datacols.options:= grid.datacols.options + 
                                    [co_keyselect,co_mouseselect];
  end;
  else begin
//   diffmode.caption:= 'D';
//   diffmode.color:= $BBEDBB;
   grid.datacols.clearselection;
   grid.datacols.options:= grid.datacols.options - 
                                   [co_keyselect,co_mouseselect];
   if grid.row >= 0 then begin
    grid.datacols.rowselected[grid.row]:= true;
   end;
  end;
 end;
 if visible and mainmo.isrepoloaded then begin
  mainfo.diffchanged;
 end;
end;

const
 filtercolor = $e0c0c0;

procedure tlogfo.updatefilterdisp();
 procedure updatecell(const aname: string; const filtered: boolean);
 begin
  with grid.fixrows[-1].captions[
                   grid.datacols.colbyname(aname).index] do begin
   if filtered then begin
    color:= filtercolor;
    createface;
    hint:= 'Filtered';
   end
   else begin
    color:= cl_parent;
    face:= nil;
    hint:= '';
   end;
  end;
 end; //updatecell
begin
 with mainmo.repostat do begin
  updatecell('commit',logfiltercommit <> '');
  updatecell('committer',logfiltercommitter <> '');
  updatecell('commitdate',(logfilterdatemin <> emptydatetime) or 
                  (logfilterdatemax <> emptydatetime));
  updatecell('author',logfilterauthor <> '');
  updatecell('message',logfiltermessage <> '');
 end;
end;
 
procedure tlogfo.setrefmode(const avalue: boolean); 
begin
 with grid.fixrows[-1].captions[0] do begin
  if avalue then begin
   color:= grid.rowcolors[0];
  end
  else begin
   color:= cl_parent;
  end;
 end;
 updatefilterdisp();
end;

procedure tlogfo.messagecelleventexe(const sender: TObject;
               var info: celleventinfoty);
var
 mstr1: msestring;
 int1: integer;
begin
 if (info.eventkind = cek_firstmousepark) and
    application.active and  message.textclipped(info.cell.row) then begin
  with tlogitem(message.items[info.cell.row]) do begin
   if fbranchinfo <> nil then begin
    mstr1:= '';
    for int1:= 0 to high(fbranchinfo) do begin
     with fbranchinfo[int1] do begin
      if remotename <> '' then begin
       mstr1:= mstr1 + remotename + '/';
      end;
      mstr1:= mstr1 + branchname + ' ';
     end;
    end;
    mstr1:= mstr1 + lineend + fmessage;
   end
   else begin
    mstr1:= fmessage;
   end;
  end;
  application.showhint(grid,mstr1);
 end;
end;

procedure tlogfo.filtereditexe(const sender: TObject);
begin
 teditlogfilterfo.create(nil);
end;

function tlogfo.isbasediff: boolean;
begin
 result:= (diffmode.value = 0) and (grid.row = 0) and mainmo.logfilterempty and
      (diffbase.checkedrow = -1) and 
      (mainmo.repostat.activelogcommit(false) = mainmo.activebranch);;
end;

function tlogfo.findcommit(const acommit: msestring): boolean;
var
 i1: int32;
 ar1: refinfoarty;
 ar2: msestringarty;
 mstr1: msestring;
 bo1: boolean;
 commit1: msestring;
begin
 result:= false;
 mstr1:= mainmo.repostat.activelogcommit(false);
 if mstr1 <> '' then begin
  if mainmo.git.findbranches(acommit,ar2) then begin
   if mainmo.repostat.logfiltercommit <> '' then begin
    mainmo.repostat.logfiltercommit:= '';
    grid.clear();
   end;
   bo1:= false;
   for i1:= 0 to high(ar2) do begin
    if ar2[i1] = mstr1 then begin
     bo1:= true;
     break;
    end;
   end;
   if dogetrevs(ar1,'',acommit,1,0) and 
                                    (ar1 <> nil) then begin
    commit1:= ar1[0].commit;
    if not bo1 and (ar2 <> nil) then begin
     showmessage('Commit '+acommit+lineend+
             'not found in current log list.'+lineend+
             'It is available in '+lineend+concatstrings(ar2,lineend),'Hint');
     mainmo.repostat.logfiltercommit:= acommit;
//     fcommitbranches:= ar2;
     diffmode.value:= 1;
     diffmode.checkvalue();
     getrevs1(nil,0);
     exit;
    end;
    if bo1 then begin
     diffmode.value:= 1;
     diffmode.checkvalue();
     application.beginwait();
     try
      i1:= 0;
      repeat
       for i1:= i1 to grid.rowhigh do begin
        if commit[i1] = commit1 then begin
         grid.row:= i1;
         result:= true;
         exit;
        end;
       end;
       i1:= grid.rowcount;
       if i1 > 5000 then begin
        getrevs1(nil,i1,5000);
       end
       else begin
        getrevs1(nil,i1,i1);
       end;
      until grid.rowcount = i1;
     finally
      application.endwait();
     end;
    end;
   end;
  end;
 end;
 if not result then begin
  showerror('Commit '+acommit+lineend+'not found in current log list.');
  updatefilterdisp();
 end;
end;

{ tlogitem }

function tlogitem.compare(const r: tlistitem;
               const acasesensitive: boolean): integer;
begin
 result:= msecomparetext(fmessage,tlogitem(r).fmessage);
end;

end.
