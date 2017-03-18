{ MSEkicad Copyright (c) 2016 by Martin Schreiber
   
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
unit globalsettingsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msesplitter,msesimplewidgets,msedragglob,msescrollbar,msetabs,mseact,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msebitmap,msedatanodes,msefiledialog,
 mselistbrowser,msesys,mseactions;
type
 tglobalsettingsfo = class(tmseform)
   tstatfile1: tstatfile;
   createdbact: taction;
   texpandingwidget1: texpandingwidget;
   strip1: tlayouter;
   val_psviewer: tfilenameedit;
   val_ps2pdf: tfilenameedit;
   strip0: tlayouter;
   val_databasename: tfilenameedit;
   tbutton3: tbutton;
   val_hostname: tstringedit;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   strip2: tlayouter;
   val_fbdir: tfilenameedit;
   val_python: tfilenameedit;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure createev(const sender: TObject);
//   procedure newpageev(const sender: TObject);
//   procedure deletepageev(const sender: tobject);
   procedure pagepopupupdateev(const sender: tcustommenu);
   procedure dbdataenteredev(const sender: TObject);
   procedure asyncev(const sender: TObject; var atag: Integer);
   procedure databaseafterlayoutev(const sender: tcustomlayouter);
   procedure createdbudateev(const sender: tcustomaction);
   procedure createdbev(const sender: TObject);
  private
   fdbchanged: boolean;
 end;
 
implementation
uses
 globalsettingsform_mfm,mainmodule;
const
 valueprefix = 'val_';
 dbrefreshtag = 72957329;
   
procedure tglobalsettingsfo.asyncev(const sender: TObject; var atag: Integer);
begin
 if atag = dbrefreshtag then begin
  mainmo.disconnect();
  mainmo.refresh();
 end;
end;

procedure tglobalsettingsfo.createev(const sender: TObject);
begin
 globaloptions.loadvalues(self,valueprefix);
end;

procedure tglobalsettingsfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if amodalresult in [mr_ok,mr_f10] then begin
  window.nofocus(); //remove empty rows
  globaloptions.storevalues(self,valueprefix);
  mainmo.mainstat.writestat();
  if fdbchanged and mainmo.conn.connected then begin
   asyncevent(dbrefreshtag,[peo_modaldefer]);
  end;
 end;
end;

procedure tglobalsettingsfo.pagepopupupdateev(const sender: tcustommenu);
begin
 with sender.menu.itembyname('delete') do begin
  enabled:= ttabwidget(application.lastshowmenuwidget).activepage <> nil;
 end;
end;

procedure tglobalsettingsfo.dbdataenteredev(const sender: TObject);
begin
 fdbchanged:= true;
end;

procedure tglobalsettingsfo.databaseafterlayoutev(
              const sender: tcustomlayouter);
begin
 val_hostname.width:= val_databasename.width;
end;

procedure tglobalsettingsfo.createdbudateev(const sender: tcustomaction);
begin
 sender.enabled:= val_databasename.value <> '';
end;

procedure tglobalsettingsfo.createdbev(const sender: TObject);
begin
 if askconfirmation(
      'Do you want to create an empty MSEkicadBOM database '+lineend+
                                '"'+val_databasename.value+'"?') then begin
  mainmo.createdatabase(val_hostname.value,val_databasename.value);
 end;
end;

end.
