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
unit schematicplotdialog;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,mainmodule,msebitmap,
 msedatanodes,msefiledialog,msegrids,mselistbrowser,msesys;
type
 tschematicplotdialogfo = class(tmseform)
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   tlayouter1: tlayouter;
   val_title: tstringedit;
   val_psfile: tfilenameedit;
   procedure closeev(const sender: TObject);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
  private
   fpage: tschematicplotpage;
  public
   constructor create(const apage: tschematicplotpage);
 end;

implementation
uses
 schematicplotdialog_mfm;
 
{ tschematicplotdialogfo }

constructor tschematicplotdialogfo.create(const apage: tschematicplotpage);
begin
 fpage:= apage;
 inherited create(nil);
 apage.loadvalues(self,'val_');
 caption:= 'PCB-Layer-Plot '+val_title.value;
end;

procedure tschematicplotdialogfo.closeev(const sender: TObject);
begin
 if window.modalresult = mr_ok then begin
  fpage.storevalues(self,'val_');
 end;
end;

procedure tschematicplotdialogfo.macrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 mainmo.hintmacros(tedit(sender).text,info);
end;

end.
