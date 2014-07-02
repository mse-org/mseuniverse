{ MSEgit Copyright (c) 2011-2014 by Martin Schreiber
   
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
unit deletequeryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 removequeryform,mainmodule,msesimplewidgets;

type
 tdeletequeryfo = class(tremovequeryfo)
   removebu: tbutton;
   procedure deleteexe(const sender: TObject);
  public
   function exec(const aroot: tgitdirtreenode;
                     const aitems: msegitfileitemarty): boolean;
 end;

implementation
uses
 deletequeryform_mfm,msegitcontroller,msedatanodes,main;
 
{ tdeletequeryfo }

function tdeletequeryfo.exec(const aroot: tgitdirtreenode;
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
    if checkcandelete(gitstate) then begin
     ar1[int2]:= tmsegitfileitem.createassign(nil,aitems[int1]);
     inc(int2);
    end;
   end;
  end;
  setlength(ar1,int2);
  filelist.fileitemed.itemlist.assign(listitemarty(ar1));
  filecountdisp.value:= length(ar1);
  if show(ml_application) = mr_ok then begin
   result:= mainmo.delete(filelist.selectedfiles(aroot));
  end;
 finally
  release;
 end;
end;

procedure tdeletequeryfo.deleteexe(const sender: TObject);
begin
 if askconfirmation('Do you want to delete the selected files?') then begin
  window.modalresult:= mr_ok;
 end;
end;

end.
