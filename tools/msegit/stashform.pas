{ MSEgit Copyright (c) 2011-2012 by Martin Schreiber
   
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
unit stashform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,dispform,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid;

type
 tstashfo = class(tdispfo)
   stashgrid: twidgetgrid;
   stashed: tstringedit;
   messageed: tstringedit;
   tpopupmenu1: tpopupmenu;
   procedure applyexe(const sender: TObject);
   procedure clearexe(const sender: TObject);
   procedure dropexe(const sender: TObject);
   procedure updatapopup(const sender: tcustommenu);
  protected
   procedure dorefresh; override;
   procedure doclear; override;
   procedure refreshstash;
 end;
 
var
 stashfo: tstashfo;
 
implementation
uses
 stashform_mfm,mainmodule,msewidgets;
 
{ tstashfo }

procedure tstashfo.dorefresh;
var
 int1: integer;
begin
 stashgrid.beginupdate;
 stashgrid.rowcount:= length(mainmo.stashes);
 for int1:= 0 to stashgrid.rowhigh do begin
  with mainmo.stashes[int1] do begin
   stashed[int1]:= name;
   messageed[int1]:= message;
  end;
 end;
 stashgrid.endupdate;
end;

procedure tstashfo.doclear;
begin
 stashgrid.clear;
end;

procedure tstashfo.applyexe(const sender: TObject);
begin
 if askyesno('Do you want to apply "'+messageed.value+'"?') then begin
  if mainmo.execgitconsole('stash apply '+
           mainmo.git.encodestringparam(stashed.value)) then begin
   mainmo.reload;
  end;
 end;
end;

procedure tstashfo.clearexe(const sender: TObject);
begin
 if askyesno('Do you want to delete all stashes?') then begin
  if mainmo.execgitconsole('stash clear') then begin
   refreshstash;
  end;
 end;
end;

procedure tstashfo.dropexe(const sender: TObject);
begin
 if askyesno('Do you want to delete "'+messageed.value+'"?') then begin
  if mainmo.execgitconsole('stash drop '+
                    mainmo.git.encodestringparam(stashed.value)) then begin
   refreshstash;
  end;
 end;
end;

procedure tstashfo.updatapopup(const sender: tcustommenu);
begin 
 sender.menu.enabled:= stashgrid.row >= 0;
end;

procedure tstashfo.refreshstash;
var
 int1: integer;
begin
 mainmo.loadstash;
 int1:= stashgrid.row;
 refresh;
 stashgrid.row:= int1;
end;

end.
