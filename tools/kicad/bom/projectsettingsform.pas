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
unit projectsettingsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msesplitter,msesimplewidgets,msedragglob,msescrollbar,msetabs,mseact,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msebitmap,msedatanodes,msefiledialog,
 mselistbrowser,msesys,msegraphedits;
type
 tprojectsettingsfo = class(tmseform)
   tstatfile1: tstatfile;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   schematicgrid: twidgetgrid;
   val_schematics: tfilenameedit;
   ttabpage2: ttabpage;
   strip1: tlayouter;
   val_compfootprint: tfilenameedit;
   val_compfootprintwarn: tbooleanedit;
   strip0: tlayouter;
   tlabel1: tlabel;
   tlabel2: tlabel;
   strip3: tlayouter;
   val_reportencoding: tenumtypeedit;
   ttabpage3: ttabpage;
   libaliasgrid: twidgetgrid;
   val_libident: tstringedit;
   val_libalias: tstringedit;
   strip4: tlayouter;
   val_plotstack: tdropdownlistedit;
   strip2: tlayouter;
   val_board: tfilenameedit;
   tsimplewidget2: tsimplewidget;
   macropage: ttabpage;
   tlayouter1: tlayouter;
   val_projectname: tstringedit;
   twidgetgrid1: twidgetgrid;
   val_projectmacronames: tstringedit;
   val_projectmacrovalues: tstringedit;
   val_docustack: tdropdownlistedit;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure createev(const sender: TObject);
   procedure initencodingev(const sender: tenumtypeedit);
   procedure projectmacrohintev(const sender: TObject; var info: hintinfoty);
   procedure showprojectmacrohintcolev(const sender: tdatacol;
                   const arow: Integer; var info: hintinfoty);
  protected
   procedure projectmacrohint(const atext: msestring; var info: hintinfoty);
 end;
 
implementation
uses
 projectsettingsform_mfm,mainmodule;
 
const
 valueprefix = 'val_';
  
procedure tprojectsettingsfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if amodalresult in [mr_ok,mr_f10] then begin
  projectoptions.storevalues(self,valueprefix);
 end;
end;

procedure tprojectsettingsfo.createev(const sender: TObject);
begin
 projectoptions.loadvalues(self,valueprefix);
 val_plotstack.dropdown.cols[0].asarray:= globaloptions.prodplotnames;
 val_docustack.dropdown.cols[0].asarray:= globaloptions.docunames;
end;

procedure tprojectsettingsfo.initencodingev(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(charencodingty);
end;

procedure tprojectsettingsfo.projectmacrohint(const atext: msestring;
                                                      var info: hintinfoty);
var
 s1: msestring;
begin
 s1:= projectoptions.projectname;
 projectoptions.projectname:= val_projectname.value;
 mainmo.updateprojectmacros(val_projectmacronames.griddata.asarray,
                              val_projectmacrovalues.griddata.asarray);
 projectoptions.projectname:= s1;
 info.caption:= mainmo.expandprojectmacros(atext);
 include(info.flags,hfl_show); //show empty caption
end;

procedure tprojectsettingsfo.projectmacrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 projectmacrohint(tdataedit(sender).text,info);
end;

procedure tprojectsettingsfo.showprojectmacrohintcolev(const sender: tdatacol;
               const arow: Integer; var info: hintinfoty);
begin
 projectmacrohint(val_projectmacrovalues[arow],info);
end;

end.
