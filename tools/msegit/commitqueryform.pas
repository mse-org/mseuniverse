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
   tbutton2: tbutton;
   selected: tbooleanedit;
   filecountdisp: tintegerdisp;
   tstatfile1: tstatfile;
   messageed: tmemodialoghistoryedit;
   tspacer1: tspacer;
   tbutton3: tbutton;
   tbutton4: tbutton;
   tbutton5: tbutton;
   procedure commitexe(const sender: TObject);
   procedure selectsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure commitupdateexe(const sender: tcustombutton);
   procedure stageexe(const sender: TObject);
   procedure ammendexe(const sender: TObject);
   procedure unstageexe(const sender: TObject);
  private
   fkind: commitkindty;
  public
   procedure exec(const aroot: tgitdirtreenode;
                     const aitems: msegitfileitemarty);
//   destructor destroy; override;
 end;

var
 commitqueryfo: tcommitqueryfo;

implementation
uses
 commitqueryform_mfm,msedatanodes;

{ tcommitqueryfo }
 
procedure tcommitqueryfo.exec(const aroot: tgitdirtreenode;
                       const aitems: msegitfileitemarty);
var
 ar1: msegitfileitemarty;
 ar2: filenamearty;
 int1,int2: integer;
begin
 if aitems <> nil then begin
  messageed.dropdown.history:= mainmo.repostat.commitmessages;
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
    mainmo.repostat.commitmessages:= messageed.dropdown.history;
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
 if askyesno('Do you want to ammend?') then begin
  fkind:= ck_ammend;
  window.modalresult:= mr_ok;
 end;
end;

procedure tcommitqueryfo.commitexe(const sender: TObject);
begin
 if askyesno('Do you want to commit?') then begin
  fkind:= ck_commit;
  window.modalresult:= mr_ok;
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
begin
 sender.enabled:= filecountdisp.value > 0;
end;

end.
