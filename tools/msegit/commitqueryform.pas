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
unit commitqueryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mainmodule,msestatfile,
 filelistframe,msesimplewidgets,msewidgets,msegraphedits,mseifiglob,msetypes,
 msedispwidgets,msestrings,msedataedits,mseedit,msesplitter,msememodialog,
 msegitcontroller;
type
 tcommitqueryfo = class(tmseform)
   filelist: tfilelistframefo;
   tbutton1: tbutton;
   commit: tbutton;
   selected: tbooleanedit;
   filecountdisp: tintegerdisp;
   tstatfile1: tstatfile;
   ammend: tbutton;
   stage: tbutton;
   unstage: tbutton;
   messageed: tmemoedit;
   tsplitter1: tsplitter;
   tpopupmenu1: tpopupmenu;
   procedure commitexe(const sender: TObject);
   procedure selectsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure commitupdateexe(const sender: tcustombutton);
   procedure stageexe(const sender: TObject);
   procedure ammendexe(const sender: TObject);
   procedure unstageexe(const sender: TObject);
   procedure lastmessageexe(const sender: TObject);
   procedure messagepopupupdaexe(const sender: tcustommenu);
  private
   fkind: commitkindty;
  protected
   function checkmessage: boolean;
  public
   procedure exec(const aroot: tgitdirtreenode;
                     const aitems: msegitfileitemarty);
//   destructor destroy; override;
 end;

var
 commitqueryfo: tcommitqueryfo;

implementation
uses
 commitqueryform_mfm,msedatanodes,lastmessageform,msearrayutils;

{ tcommitqueryfo }
 
procedure tcommitqueryfo.exec(const aroot: tgitdirtreenode;
                       const aitems: msegitfileitemarty);
var
 ar1: msegitfileitemarty;
 ar2: filenamearty;
 int1,int2: integer;
begin
 if aitems <> nil then begin
//  messageed.dropdown.history:= mainmo.repostat.commitmessages;
  messageed.value:= mainmo.repostat.commitmessage;
  setlength(ar1,length(aitems));
  int2:= 0;
  for int1:= 0 to high(ar1) do begin
   with aitems[int1] do begin
    if checkcancommit(gitstate) then begin
     ar1[int2]:= tmsegitfileitem.createassign(nil,aitems[int1]);
     inc(int2);
    end;
   end;
  end;
  setlength(ar1,int2);
  if int2 > 0 then begin
   filelist.fileitemed.itemlist.assign(listitemarty(ar1));
   filecountdisp.value:= length(ar1);
   if show(ml_application) = mr_ok then begin
//    mainmo.repostat.commitmessages:= messageed.dropdown.history;
    setlength(ar2,filelist.grid.rowcount);
    int2:= 0;
    for int1:= 0 to high(ar2) do begin
     if selected[int1] then begin
      ar2[int2]:= mainmo.getpath(aroot,
                              tgitfileitem(filelist.fileitemed[int1]).caption);
      inc(int2);
     end;
    end;
    setlength(ar2,int2);
    mainmo.commit(ar2,messageed.value,fkind);
   end;
   mainmo.repostat.commitmessage:= messageed.value;
  end
  else begin
   showmessage('No files to commit.');
   release;
  end;
 end;
end;

procedure tcommitqueryfo.stageexe(const sender: TObject);
begin
 if askyesno('Do you want to stage?') then begin
  fkind:= ck_stage;
  window.modalresult:= mr_ok;
 end;
end;

procedure tcommitqueryfo.unstageexe(const sender: TObject);
begin
 if askyesno('Do you want to unstage?') then begin
  fkind:= ck_unstage;
  window.modalresult:= mr_ok;
 end;
end;

procedure tcommitqueryfo.ammendexe(const sender: TObject);
begin
 if checkmessage then begin
  if askyesno('Do you want to ammend?') then begin
   fkind:= ck_amend;
   window.modalresult:= mr_ok;
  end;
 end;
end;

procedure tcommitqueryfo.commitexe(const sender: TObject);
begin
 if checkmessage then begin
  if askyesno('Do you want to commit?') then begin
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

procedure tcommitqueryfo.commitupdateexe(const sender: tcustombutton);
var
 bo1: boolean;
begin
 bo1:= filecountdisp.value > 0;
 unstage.enabled:= bo1;
 stage.enabled:= bo1;
 ammend.enabled:= bo1;
 commit.enabled:= bo1;
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

end.
