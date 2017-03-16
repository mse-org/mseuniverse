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
unit schematicplotdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,mainmodule,msebitmap,
 msedatanodes,msefiledialog,msegrids,mselistbrowser,msesys,plotsettings,
 docupageeditform,plotpageeditform,msedbdialog;
type
 tschematicplotdialogfo = class(tplotpageeditfo)
   strip2: tlayouter;
   val_psfile: tdbfilenameedit;
  private
  protected
{
   procedure loadvalues() override;
   procedure storevalues() override;
}
  public
//   constructor create(const apage: tschematicplotpage);
 end;

implementation
uses
 schematicplotdialogform_mfm;
 
{ tschematicplotdialogfo }
{
constructor tschematicplotdialogfo.create(const apage: tschematicplotpage);
begin
 inherited create(apage);
 caption:= 'PCB-Layer-Plot '+val_title.value;
end;

procedure tschematicplotdialogfo.loadvalues();
begin
 inherited;
 fpage.loadvalues(plotsettings,'val_');
end;

procedure tschematicplotdialogfo.storevalues();
begin
 inherited;
 fpage.storevalues(plotsettings,'val_');
end;
}
end.
