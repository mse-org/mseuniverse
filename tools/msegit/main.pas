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
unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msedockpanelform,msestrings,msestatfile,mseact,mseactions,mseifiglob,msebitmap;

type
 tmainfo = class(tmainform)
   dockpanel: tdockpanel;
   mainmen: tmainmenu;
   panelcontroller: tdockpanelformcontroller;
   formsta: tstatfile;
   mainfosta: tstatfile;
   repoloadedact: taction;
   repoclosedact: taction;
   images: timagelist;
   procedure newpanelexe(const sender: TObject);
   procedure showdirtreeexe(const sender: TObject);
   procedure showuntrackedexe(const sender: TObject);
   procedure formstaafterreadexe(const sender: TObject);
   procedure repoloadedexe(const sender: TObject);
   procedure repoclosedexe(const sender: TObject);
   procedure optionsexe(const sender: TObject);
   procedure showfilesexe(const sender: TObject);
   procedure reloadeexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;

implementation

uses
 main_mfm,dirtreeform,mainmodule,optionsform,filesform;
 
procedure tmainfo.newpanelexe(const sender: TObject);
begin
 with panelcontroller.newpanel do begin
  activate;
 end;
end;

procedure tmainfo.showdirtreeexe(const sender: TObject);
begin
 dirtreefo.activate;
end;

procedure tmainfo.showfilesexe(const sender: TObject);
begin
 filesfo.activate;
end;

procedure tmainfo.showuntrackedexe(const sender: TObject);
begin
 mainmo.opt.showuntrackeditems:= tmenuitem(sender).checked;
end;

procedure tmainfo.formstaafterreadexe(const sender: TObject);
begin
 with mainmo.opt do begin
  mainmen.menu.itembynames(['view','untracked']).checked:= showuntrackeditems;
 end;
end;

procedure tmainfo.repoloadedexe(const sender: TObject);
begin
 caption:= 'MSEgit '+mainmo.repo;
end;

procedure tmainfo.repoclosedexe(const sender: TObject);
begin
 caption:= 'MSEgit';
end;

procedure tmainfo.optionsexe(const sender: TObject);
begin
 editoptions;
end;

procedure tmainfo.reloadeexe(const sender: TObject);
begin
 dirtreefo.savestate;
 try
  mainmo.repo:= mainmo.repo;
 finally
  dirtreefo.restorestate;
 end;
end;

end.
