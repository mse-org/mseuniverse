{ MSEgit Copyright (c) 2012 by Martin Schreiber
   
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
unit main;
//under construction

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedockpanelform,
 msestrings,msestatfile,msedataedits,mseedit,mseifiglob,msetypes,msedock,
 dockform;

type
 tmainfo = class(tmainform)
   mainme: tmainmenu;
   panelcontroller: tdockpanelformcontroller;
   panelsta: tstatfile;
   dockfo1: tdockfo;
   procedure exitexe(const sender: TObject);
   procedure loadedexe(const sender: TObject);
   procedure newpanelexe(const sender: TObject);
   procedure showconsoleexe(const sender: TObject);
   procedure closequeryexe(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure showplotsexe(const sender: TObject);
   procedure createpanelexe(const sender: tdockpanelformcontroller;
                   var apanel: tdockpanelform);
   procedure shownetlistexe(const sender: TObject);
   procedure mainmenuupdateexe(const sender: tcustommenu);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,optionsform,mainmodule,consoleform,plotsform,netlistform;
 
procedure tmainfo.exitexe(const sender: TObject);
begin
 application.terminate;
end;

procedure tmainfo.loadedexe(const sender: TObject);
begin
 mainmo.projectoptionscomp.dialogclass:= toptionsfo;
 mainmo.loadproject('');
end;

procedure tmainfo.newpanelexe(const sender: TObject);
begin
 panelcontroller.newpanel.activate;
end;

procedure tmainfo.showconsoleexe(const sender: TObject);
begin
 consolefo.activate;
end;

procedure tmainfo.closequeryexe(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if not mainmo.closeproject then begin
  amodalresult:= mr_none;
 end;
end;

procedure tmainfo.showplotsexe(const sender: TObject);
begin
 plotsfo.activate;
end;

procedure tmainfo.createpanelexe(const sender: tdockpanelformcontroller;
               var apanel: tdockpanelform);
begin
 apanel:= tdockfo.create(sender);
end;

procedure tmainfo.shownetlistexe(const sender: TObject);
begin
 netlistfo.activate;
end;

procedure tmainfo.mainmenuupdateexe(const sender: tcustommenu);
begin
 mainmenu.menu.itembynames(['file','savenetlist']).enabled:= 
                                                 netlistfo.edit.modified;
end;

end.
