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
unit remotesform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msegraphedits,
 msememodialog,mseact,mseactions;

type
 tremotesfo = class(tdockform)
   grid: twidgetgrid;
   remote: tstringedit;
   fetch: tmemodialogedit;
   push: tmemodialogedit;
   repoloadedact: taction;
   repoclosedact: taction;
   procedure repoloadedexe(const sender: TObject);
   procedure repoclosedexe(const sender: TObject);
   procedure activesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure remoteset(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure fetchsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure pushsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure rowdeleteexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure rowmovedexe(const sender: tcustomgrid; const fromindex: Integer;
                   const toindex: Integer; const acount: Integer);
  private
   fhasremote: boolean;
   function changeurl(const afetch,apush: msestring): boolean;
  public
   procedure refresh;
 end;
var
 remotesfo: tremotesfo;
 
implementation
uses
 remotesform_mfm,mainmodule,msegitcontroller,sysutils,main;

{ tremotesfo }

procedure tremotesfo.refresh;
var
 ar1: remoteinfoarty;
 int1: integer;
begin
 grid.beginupdate;
 ar1:= mainmo.remotesinfo;
 grid.rowcount:= length(ar1);
// remoteactive.checkedrow:= -1;
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   remote[int1]:= name;
   fetch[int1]:= fetchurl;
   push[int1]:= pushurl;
//   if name = mainmo.activeremote then begin
//    remoteactive.checkedrow:= int1;
//   end;
  end;
 end;
 grid.endupdate;
end;

procedure tremotesfo.repoloadedexe(const sender: TObject);
begin
 with grid do begin
  optionsgrid:= optionsgrid + [og_autofirstrow,og_autoappend];
 end;
 refresh;
end;

procedure tremotesfo.repoclosedexe(const sender: TObject);
begin
 with grid do begin
  optionsgrid:= optionsgrid - [og_autofirstrow,og_autoappend];
  clear;
 end;
end;

procedure tremotesfo.activesetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  mainmo.activeremote:= remote[-1];
 end
 else begin
  mainmo.activeremote:= '';
 end;
end;

procedure tremotesfo.remoteset(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 accept:= checkname(avalue);
 if accept then begin
  if grid.canexitrow(true) then begin //check notnull
   if remote.value = '' then begin
    accept:= mainmo.createremote(avalue,fetch.value,push.value);
    fhasremote:= accept;
   end
   else begin
    accept:= mainmo.changeremote(remote.value,avalue,fetch.value,push.value);
   end;
  end
  else begin
   remote.value:= avalue;
   abort;
  end;
 end;
end;

function tremotesfo.changeurl(const afetch,apush: msestring): boolean;
begin
 result:= true;
 if remote.value <> '' then begin
  if fhasremote then begin
   result:= mainmo.changeremote(remote.value,remote.value,afetch,apush);
  end
  else begin
   fhasremote:= mainmo.createremote(remote.value,afetch,apush);
   result:= fhasremote;
  end;
 end;
end;

procedure tremotesfo.fetchsetexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if push.value = '' then begin
  push.value:= avalue;
 end;
 accept:= changeurl(avalue,push.value);
end;

procedure tremotesfo.pushsetexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 accept:= changeurl(fetch.value,avalue);
end;

procedure tremotesfo.rowdeleteexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
begin
 if (remote.value <> '') and not mainmo.deleteremote(remote.value) then begin
//  acount:= 0;
 end;
end;

procedure tremotesfo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  fhasremote:= remote.value <> '';
 end;
end;

procedure tremotesfo.rowmovedexe(const sender: tcustomgrid;
               const fromindex: Integer; const toindex: Integer;
               const acount: Integer);
var
 int1: integer;
begin
 int1:= grid.row;
 mainmo.updateremotesorder;
 mainfo.reload;
 grid.row:= int1;
end;

end.
