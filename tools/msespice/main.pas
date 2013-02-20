{ MSEgit Copyright (c) 2012-2013 by Martin Schreiber
   
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
 dockform,msebitmap,msesplitter,msedispwidgets,mserichstring;

const
 versiontext = '0.8.6';
type
 messagetextkindty = (mtk_info,mtk_running,mtk_finished,mtk_error,mtk_signal);

 tmainfo = class(tdockform)
   mainme: tmainmenu;
   panelcontroller: tdockpanelformcontroller;
   panelsta: tstatfile;
   dockfo1: tdockfo;
   imagelist: timagelist;
   tspacer1: tspacer;
   statdisp: tstringdisp;
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
   procedure showparamsexe(const sender: TObject);
   procedure aboutexe(const sender: TObject);
   procedure panelstatreadexe(const sender: TObject; const reader: tstatreader);
  public
   procedure setstattext(const atext: msestring; 
                   const akind: messagetextkindty = mtk_info);
 end;

var
 mainfo: tmainfo;

implementation
uses
 main_mfm,optionsform,mainmodule,consoleform,plotsform,netlistform,
 paramform,msewidgets;
 
procedure tmainfo.setstattext(const atext: msestring; 
                   const akind: messagetextkindty = mtk_info);
begin
 with statdisp do begin
  value:= removelinebreaks(atext);
  case akind of
   mtk_finished: color:= cl_ltgreen;
   mtk_error: color:= cl_ltyellow;
   mtk_signal: color:= cl_ltred;
   else color:= cl_parent;
  end;
  case akind of
   mtk_running: font.color:= cl_red;
   else font.color:= cl_black;
  end;
 end;
end;

procedure tmainfo.exitexe(const sender: TObject);
begin
 application.terminate;
end;

procedure tmainfo.loadedexe(const sender: TObject);
begin
 mainmo.projectoptionscomp.dialogclass:= toptionsfo;
 if mainmo.projectmainstat.filename <> '' then begin
  mainmo.loadproject('');
 end;
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

procedure tmainfo.showparamsexe(const sender: TObject);
begin
 paramfo.activate;
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
 mainmenu.menu.itembynames(['simulation']).enabled:= mainmo.projectloaded;
end;

procedure tmainfo.aboutexe(const sender: TObject);
begin
 showmessage('MSEspice version: '+versiontext+c_linefeed+
             'MSEgui version: '+mseguiversiontext+c_linefeed+             
             'Host: '+ platformtext+ c_linefeed+
             c_linefeed+
             'Copyright 1999-2013'+c_linefeed+
             'by Martin Schreiber'
             ,'About MSEspice');
end;

procedure tmainfo.panelstatreadexe(const sender: TObject;
               const reader: tstatreader);
begin
 dostatread(reader); //backward compatibility
end;

end.
