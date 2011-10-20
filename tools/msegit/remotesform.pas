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
   remotename: tstringedit;
   remoteactive: tbooleaneditradio;
   remotefetchurl: tmemodialogedit;
   remotepushurl: tmemodialogedit;
   repoloadedact: taction;
   repoclosedact: taction;
   procedure repoloadedexe(const sender: TObject);
   procedure repoclosedexe(const sender: TObject);
   procedure activesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  public
   procedure refresh;
 end;
var
 remotesfo: tremotesfo;
implementation
uses
 remotesform_mfm,mainmodule,msegitcontroller;

{ tremotesfo }

procedure tremotesfo.refresh;
var
 ar1: remoteinfoarty;
 int1: integer;
begin
 grid.beginupdate;
 ar1:= mainmo.remotesinfo;
 grid.rowcount:= length(ar1);
 remoteactive.checkedrow:= -1;
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   remotename[int1]:= name;
   remotefetchurl[int1]:= fetchurl;
   remotepushurl[int1]:= pushurl;
   if name = mainmo.activeremote then begin
    remoteactive.checkedrow:= int1;
   end;
  end;
 end;
 grid.endupdate;
end;

procedure tremotesfo.repoloadedexe(const sender: TObject);
begin
 refresh;
end;

procedure tremotesfo.repoclosedexe(const sender: TObject);
begin
 grid.clear;
end;

procedure tremotesfo.activesetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  mainmo.activeremote:= remotename[-1];
 end
 else begin
  mainmo.activeremote:= '';
 end;
end;

end.
