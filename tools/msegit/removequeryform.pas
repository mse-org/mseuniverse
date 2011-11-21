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
unit removequeryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mainmodule,msestatfile,
 filelistframe,msesimplewidgets,msewidgets,msegraphedits,mseifiglob,msetypes,
 msedispwidgets,msestrings,msedataedits,mseedit,msesplitter,msememodialog,
 msegitcontroller,commitdiffform,msegrids,filechecklistframe;
type
 tremovequeryfo = class(tmseform)
   tbutton1: tbutton;
   revert: tbutton;
   filecountdisp: tintegerdisp;
   tstatfile1: tstatfile;
   diff: tcommitdifffo;
   tsplitter2: tsplitter;
   filelist: tfilechecklistframefo;
   tbutton2: tbutton;
   procedure selectsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure removeexe(const sender: TObject);
   procedure removeupdateexe(const sender: tcustombutton);
   procedure untrackexe(const sender: TObject);
  private
   froot: tgitdirtreenode;
   funtrack: boolean;
  protected
  public
   function exec(const aroot: tgitdirtreenode;
                     const aitems: msegitfileitemarty): boolean;
 end;

implementation
uses
 removequeryform_mfm,msedatanodes,lastmessageform,msearrayutils;

{ tremovequeryfo }
 
function tremovequeryfo.exec(const aroot: tgitdirtreenode;
                       const aitems: msegitfileitemarty): boolean;
var
 ar1: msegitfileitemarty;
 int1,int2: integer;
begin
 result:= true;
 try
  froot:= aroot;
  setlength(ar1,length(aitems));
  int2:= 0;
  for int1:= 0 to high(ar1) do begin
   with aitems[int1] do begin
    if checkcanremove(gitstate) then begin
     ar1[int2]:= tmsegitfileitem.createassign(nil,aitems[int1]);
     inc(int2);
    end;
   end;
  end;
  setlength(ar1,int2);
  filelist.fileitemed.itemlist.assign(listitemarty(ar1));
  filecountdisp.value:= length(ar1);
  if show(ml_application) = mr_ok then begin
   result:= mainmo.remove(filelist.selectedfiles(aroot),funtrack);
  end;
 finally
  release;
 end;
end;

procedure tremovequeryfo.selectsetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
begin
 if avalue then begin
  filecountdisp.value:= filecountdisp.value + 1;
 end
 else begin
  filecountdisp.value:= filecountdisp.value - 1;
 end;
end;

procedure tremovequeryfo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  diff.refresh(froot,filelist.currentitem,'','');
 end;
end;

procedure tremovequeryfo.removeexe(const sender: TObject);
begin
 if askyesno('Do you want to remove the selected files?') then begin
  window.modalresult:= mr_ok;
 end;
end;

procedure tremovequeryfo.removeupdateexe(const sender: tcustombutton);
begin
 sender.enabled:= filecountdisp.value > 0;
end;

procedure tremovequeryfo.untrackexe(const sender: TObject);
begin
 if askyesno('Do you want to untrack the selected files?') then begin
  funtrack:= true;
  window.modalresult:= mr_ok;
 end;
end;

end.
