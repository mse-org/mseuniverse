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
unit optionsform;
//under construction

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msescrollbar,
 msestatfile,msestream,msestrings,msetabs,msewidgets,sysutils,msesplitter,
 msesimplewidgets,msefiledialog,msebitmap,msedataedits,msedatanodes,mseedit,
 msegrids,mseifiglob,mselistbrowser,msesys,msetypes;

type
 toptionsfo = class(tmseform)
   ttabwidget1: ttabwidget;
   tlayouter1: tlayouter;
   tbutton1: tbutton;
   tbutton2: tbutton;
   ttabpage1: ttabpage;
   ngspice: tfilenameedit;
   ttabpage2: ttabpage;
   tstatfile1: tstatfile;
   netlist: tfilenameedit;
 end;

implementation
uses
 optionsform_mfm;
end.
