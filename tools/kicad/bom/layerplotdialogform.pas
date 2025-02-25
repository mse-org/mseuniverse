{ MSEkicad Copyright (c) 2016-2017 by Martin Schreiber
   
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
unit layerplotdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,sysutils,msesplitter,msesimplewidgets,mainmodule,plotsettings,
 msegrids,msewidgetgrid,msegraphedits,msescrollbar,plotpageeditform,mdb,
 msedbedit,mselookupbuffer;
type
 tlayerplotdialogfo = class(tplotpageeditfo)
   tlayouter1: tlayouter;
   grid: twidgetgrid;
   val_layernames: tdropdownlistedit;
   val_colornames: tdropdownlistedit;
   tlayouter4: tlayouter;
   val_refon: tbooleanedit;
   val_refcolor: tdropdownlistedit;
   val_valon: tbooleanedit;
   val_valcolor: tdropdownlistedit;
   val_invison: tbooleanedit;
   pked: tint64edit;
   val_drillmarks: tdropdownlistedit;
   plotoptcont: tlayouter;
   linewidthed: tdbrealedit;
   procedure editedev(const sender: TObject);
   procedure layoutev(const sender: TObject);
  private
  protected
//   procedure loadvalues() override;
//   procedure storevalues() override;
  public
//   constructor create(const apage: tlayerplotpage);
 end;

implementation
uses
 layerplotdialogform_mfm,bommodule;

{ tlayerplotdialogfo }
{
constructor tlayerplotdialogfo.create(const apage: tlayerplotpage);
begin
 inherited create(apage);
 val_layernames.dropdown.cols[0].asarray:= mainmo.layernames;
 val_colornames.dropdown.cols[0].asarray:= mainmo.edacolornames;
 val_refcolor.dropdown.cols[0].asarray:= mainmo.edacolornames;
 val_valcolor.dropdown.cols[0].asarray:= mainmo.edacolornames;
 val_drillmarks.dropdown.cols[0].asarray:= mainmo.drillmarknames;
end;

procedure tlayerplotdialogfo.loadvalues();
begin
 inherited;
 fpage.loadvalues(plotsettings,'val_');
end;

procedure tlayerplotdialogfo.storevalues();
begin
 inherited;
 fpage.storevalues(plotsettings,'val_');
end;
}
procedure tlayerplotdialogfo.editedev(const sender: TObject);
begin
 if not bommo.plotitemdso.refreshing then begin
  dataso.dataset.edit();
  dataso.dataset.modify(); //set modified flag
 end;
end;

procedure tlayerplotdialogfo.layoutev(const sender: TObject);
begin
 aligny(wam_center,[plotsettingsfo.val_shiftvert,linewidthed]);
end;

end.
