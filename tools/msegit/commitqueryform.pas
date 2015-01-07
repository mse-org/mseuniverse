{ MSEgit Copyright (c) 2012-2014 by Martin Schreiber
   
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
unit commitqueryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mainmodule,msestatfile,
 filelistframe,msesimplewidgets,msewidgets,msegraphedits,mseifiglob,msetypes,
 msedispwidgets,msestrings,msedataedits,mseedit,msesplitter,msememodialog,
 msegitcontroller,commitdiffform,msegrids,filechecklistframe,msetimer,
 mserichstring;
type
 tcommitqueryfo = class(tmseform)
   tstatfile1: tstatfile;
   difftimer: ttimer;
   bottomstrip: tlayouter;
   tbutton1: tbutton;
   commit: tbutton;
   amend: tbutton;
   stage: tbutton;
   unstage: tbutton;
   tbutton2: tbutton;
   filecountdisp: tintegerdisp;
   mainarea: tsimplewidget;
   tsplitter2: tsplitter;
   diff: tcommitdifffo;
   tsimplewidget2: tsimplewidget;
   messageed: tmemoedit;
   tsplitter1: tsplitter;
   filelist: tfilechecklistframefo;
   procedure commitexe(const sender: TObject);
   procedure selectsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure commitupdateexe(const sender: tcustombutton);
   procedure stageexe(const sender: TObject);
   procedure amendexe(const sender: TObject);
   procedure unstageexe(const sender: TObject);
   procedure lastmessageexe(const sender: TObject);
   procedure messagepopupupdaexe(const sender: tcustommenu);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure difftiexe(const sender: TObject);
   procedure createexe(const sender: TObject);
  private
   fkind: commitkindty;
   fstaged: boolean;
   froot: tgitdirtreenode;
  protected
   function checkmessage: boolean;
   procedure checkallexe(const sender: tobject; const acheck: boolean);
  public
   function exec(const aroot: tgitdirtreenode;
           const aitems: msegitfileitemarty; const staged: boolean;
           const amessage: msestring): boolean;
 end;

var
 commitqueryfo: tcommitqueryfo;

implementation
uses
 commitqueryform_mfm,msedatanodes,lastmessageform,msearrayutils,main,
 logform,gitdirtreeform,filesform,msefileutils;

{ tcommitqueryfo }
 
function tcommitqueryfo.exec(const aroot: tgitdirtreenode;
                       const aitems: msegitfileitemarty; const staged: boolean;
                       const amessage: msestring): boolean;
var
 ar1: msegitfileitemarty;
 ar2,ar3: filenamearty;
 int1,int2: integer;
 needsrefresh: boolean;
begin
 result:= false;
 try
  fstaged:= staged;
  froot:= aroot;
  if amessage <> '' then begin
   messageed.value:= amessage;
  end
  else begin
   messageed.value:= mainmo.repostat.commitmessage;
  end;
  setlength(ar1,length(aitems));
  int2:= 0;
  needsrefresh:= true;
  for int1:= 0 to high(ar1) do begin
   with aitems[int1] do begin
    if checkcancommit(gitstate) then begin
     ar1[int2]:= tmsegitfileitem.createassign(nil,aitems[int1]);
     inc(int2);
    end;
   end;
  end;
  setlength(ar1,int2);
  filelist.fileitemed.itemlist.assign(listitemarty(ar1));
  filecountdisp.value:= length(ar1);
  if staged then begin 
   filelist.selected.enabled:= false;
  end;
  filelist.grid.row:= 0;
  difftimer.restart; //show first diff
  if show(ml_application) = mr_ok then begin
   if staged then begin
    result:= mainmo.commitstaged(aroot,filelist.selectedfiles(aroot),
                                                            messageed.value);
   end
   else begin
    ar1:= filelist.checkeditems();
    ar2:= filelist.selectedfiles(aroot);
    setlength(ar3,length(ar2));
    try
     for int1:= 0 to high(ar1) do begin
      if (gist_deleted in ar1[int1].gitstate.statex) and 
                                 findfile(ar2[int1]) then begin
       ar3[int1]:= intermediatefilename(ar2[int1]);
       renamefile(ar2[int1],ar3[int1],false); 
                                        //remove untracked files intermediately
      end;
     end;
     result:= mainmo.commit(ar2,messageed.value,fkind);
    finally
     for int1:= 0 to high(ar3) do begin
      if ar3[int1] <> '' then begin
       try
        renamefile(ar3[int1],ar2[int1],false); //restore untracked files
       except
       end;
      end;
     end;
    end;
   end;
   if result then begin
    needsrefresh:= false;
    ar1:= filelist.checkeditems;
    for int1:= 0 to high(ar1) do begin
     if gist_deleted in ar1[int1].gitstate.statex then begin
      needsrefresh:= true;
      break;
     end;
    end;
   end;
   if needsrefresh then begin
    mainfo.reload;
   end
   else begin
    mainfo.updatestate;
    if fkind = ck_commit then begin
     logfo.refresh(gitdirtreefo.currentitem,filesfo.currentitem);
    end;
   end;
  end;
  mainmo.repostat.commitmessage:= messageed.value;
 finally
  release;
 end;
end;

procedure tcommitqueryfo.stageexe(const sender: TObject);
begin
 if askconfirmation('Do you want to stage?') then begin
  fkind:= ck_stage;
  window.modalresult:= mr_ok;
 end;
end;

procedure tcommitqueryfo.unstageexe(const sender: TObject);
begin
 if askconfirmation('Do you want to unstage?') then begin
  fkind:= ck_unstage;
  window.modalresult:= mr_ok;
 end;
end;

procedure tcommitqueryfo.amendexe(const sender: TObject);
begin
 if checkmessage then begin
  if askconfirmation('Do you want to amend?') then begin
   fkind:= ck_amend;
   window.modalresult:= mr_ok;
  end;
 end;
end;

procedure tcommitqueryfo.commitexe(const sender: TObject);
begin
 if checkmessage then begin
  if askconfirmation('Do you want to commit?') then begin
   fkind:= ck_commit;
   window.modalresult:= mr_ok;
  end;
 end;
end;

procedure tcommitqueryfo.selectsetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
begin
 if avalue then begin
  filecountdisp.value:= filecountdisp.value + 1;
 end
 else begin
  filecountdisp.value:= filecountdisp.value - 1;
 end;
end;

procedure tcommitqueryfo.checkallexe(const sender: tobject;
               const acheck: boolean);
begin
 if acheck then begin
  filecountdisp.value:= filelist.grid.rowcount;
 end
 else begin
  filecountdisp.value:= 0;
 end;
end;

procedure tcommitqueryfo.commitupdateexe(const sender: tcustombutton);
var
 bo1: boolean;
begin
 bo1:= filecountdisp.value > 0;
 unstage.enabled:= bo1 and not fstaged;
 stage.enabled:= bo1 and not fstaged;
 amend.enabled:= {bo1 and} not fstaged;
 commit.enabled:= bo1 or fstaged;
end;

procedure tcommitqueryfo.lastmessageexe(const sender: TObject);
begin
 with tlastmessagefo.create(nil) do begin
  ed.gridvalues:= mainmo.repostat.commitmessages;
  grid.row:= 0;
  if show(ml_application) = mr_ok then begin
   messageed.value:= ed.value;
  end;
 end;
end;

procedure tcommitqueryfo.messagepopupupdaexe(const sender: tcustommenu);
begin
 sender.menu.itembyname('lastmessage').enabled:= 
                                mainmo.repostat.commitmessages <> nil;
end;

function tcommitqueryfo.checkmessage: boolean;
var
 int1: integer;
 ar1: msestringarty;
begin
 result:= messageed.value <> '';
 if not result then begin
  showmessage('Empty commit message.','***ERROR***');
 end
 else begin
  ar1:= mainmo.repostat.commitmessages;
  for int1:= high(ar1) downto 0  do begin
   if ar1[int1] = messageed.value then begin
    deleteitem(ar1,int1);
   end;
  end;
  if high(ar1) >= 10 then begin
   setlength(ar1,high(ar1));
  end;
  insertitem(ar1,0,messageed.value);
  mainmo.repostat.commitmessages:= ar1;
 end;   
end;

procedure tcommitqueryfo.difftiexe(const sender: TObject);
begin
 if filelist.currentitem <> nil then begin
  diff.refresh(froot,filelist.currentitem,'','');
//  diff.visible:= true;
 end;
 diff.tabs.visible:= true;
end;

procedure tcommitqueryfo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  difftimer.restart;
 end;
end;

procedure tcommitqueryfo.createexe(const sender: TObject);
begin
 diff.iscommits:= true;
 filelist.oncheckall:= {$ifdef FPC}@{$endif}checkallexe;
end;

end.
