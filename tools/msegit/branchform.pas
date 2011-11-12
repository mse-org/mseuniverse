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
unit branchform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msegraphedits,
 msememodialog,mseact,mseactions,msegitcontroller;

type
 tbranchfo = class(tdockform)
   grid: twidgetgrid;
   activeed: tbooleanedit;
   branchname: tstringedit;
   repoloadedact: taction;
   repoclosedact: taction;
   remotename: tstringedit;
   procedure repoclosedexe(const sender: TObject);
   procedure repoloadedexe(const sender: TObject);
   procedure showexe(const sender: TObject);
   procedure branchsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
  protected
   function currentremote: msestring;
  private
   finfovalid: boolean;
 end;
var
 branchfo: tbranchfo;
implementation
uses
 branchform_mfm,mainmodule,msewidgets;
 
procedure tbranchfo.repoclosedexe(const sender: TObject);
begin
 grid.clear;
end;

procedure tbranchfo.repoloadedexe(const sender: TObject);
var
 int1,int2,int3: integer;
begin
 if visible then begin
  finfovalid:= true;
  grid.rowcount:= length(mainmo.branches);
  for int1:= 0 to grid.rowhigh do begin
   with mainmo.branches[int1] do begin
    branchname[int1]:= name;
    activeed[int1]:= active;
   end;
  end;
  int3:= grid.rowcount;
  for int1:= 0 to high(mainmo.remotesinfo) do begin
   with mainmo.remotesinfo[int1] do begin
    if name <> '' then begin
     grid.rowcount:= 1+int3 + length(branches);
     remotename[int3]:= name;
     if name = mainmo.activeremote then begin
      activeed[int3]:= true;
     end;
     grid.datacols.mergecols(int3,0,1);
     inc(int3);
     for int2:= 0 to high(branches) do begin
      branchname[int3]:= branches[int2].name;
      inc(int3);
     end;
    end;
   end;
  end;
 end
 else begin
  finfovalid:= false;
 end;
end;

procedure tbranchfo.showexe(const sender: TObject);
begin
 if not finfovalid then begin
  repoloadedexe(nil);
 end;
end;

procedure tbranchfo.branchsetexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
var
 mstr1: msestring;
begin
 accept:= checkname(avalue);
 if accept then begin
  mstr1:= currentremote;
  if mstr1 = '' then begin
   accept:= askyesno('Do you want to rename branch "'+branchname.value+'" to "'+
                        avalue+'"?');
  end
  else begin
   accept:= askyesno('Do you want to rename remote branch '+mstr1+
                 ' "'+branchname.value+'" to "'+
                        avalue+'"?','***WARNING***');
  end;
  if accept then begin
   if not mainmo.renamebranch(currentremote,branchname.value,avalue) then begin
    avalue:= branchname.value;
   end;
  end;
 end;
end;

function tbranchfo.currentremote: msestring;
var
 int1: integer;
begin
 result:= '';
 for int1:= grid.row downto 0 do begin
  if remotename[int1] <> '' then begin
   result:= remotename[int1];
   break;
  end;
 end;
end;


end.
