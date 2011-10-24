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
 msedispwidgets,msestrings,msedataedits,mseedit,msesplitter,msememodialog;
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
   procedure commitexe(const sender: TObject);
   procedure selectsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure commitupdateexe(const sender: tcustombutton);
  public
   function exec(const aroot: tgitdirtreenode;
                     const aitems: msegitfileitemarty): msegitfileitemarty;
//   destructor destroy; override;
 end;

var
 commitqueryfo: tcommitqueryfo;

implementation
uses
 commitqueryform_mfm,msedatanodes,msegitcontroller;

{ tcommitqueryfo }

function tcommitqueryfo.exec(const aroot: tgitdirtreenode;
                       const aitems: msegitfileitemarty): msegitfileitemarty;
var
 ar1: msegitfileitemarty;
 ar2: filenamearty;
 int1,int2: integer;
begin
 result:= nil;
 if aitems <> nil then begin
  setlength(ar1,length(aitems));
  int2:= 0;
  for int1:= 0 to high(ar1) do begin
   if gist_modified in aitems[int1].statey then begin
    ar1[int2]:= tmsegitfileitem.create(nil,aitems[int1]);
    inc(int2);
   end;
  end;
  setlength(ar1,int2);
  if int2 > 0 then begin
   filelist.fileitemed.itemlist.assign(listitemarty(ar1));
   filecountdisp.value:= length(ar1);
   if show(ml_application) = mr_ok then begin
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
   end;
  end
  else begin
   showmessage('No files to commit.');
  end;
 end;
end;

procedure tcommitqueryfo.commitexe(const sender: TObject);
begin
 if askyesno('Do you want to commit?') then begin
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
