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
unit optionsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msescrollbar,msetabs,sysutils,msestatfile,msebitmap,msedataedits,
 msedatanodes,mseedit,msefiledialog,msegrids,mseifiglob,mselistbrowser,
 msestrings,msesys,msetypes,msegraphedits;

type
 toptionsfo = class(tmseform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   tstatfile1: tstatfile;
   gitcommand: tfilenameedit;
   maxlog: tintegeredit;
   showutc: tbooleanedit;
   diffcontextn: tintegeredit;
   difftool: thistoryedit;
   mergetool: thistoryedit;
   splitdiffs: tbooleanedit;
   patchtool: thistoryedit;
 end;

procedure editoptions;

implementation
uses
 optionsform_mfm,mserttistat,mainmodule;
 
procedure editoptions;
var
 fo1: toptionsfo;
begin
 fo1:= toptionsfo.create(nil);
 mainmo.optionsobj.objtovalues(fo1);
 if fo1.show(ml_application) = mr_ok then begin
  mainmo.optionsobj.valuestoobj(fo1);
  mainmo.git.resetversioncheck;
 end;
end;

end.
