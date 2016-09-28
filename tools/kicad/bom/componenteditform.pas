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
unit componenteditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestream,msestrings,
 sysutils,msesplitter,msesimplewidgets,msedbdispwidgets;

type
 tcomponenteditfo = class(tmseform)
   tstatfile1: tstatfile;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   texpandingwidget1: texpandingwidget;
   strip1: tlayouter;
   tdbdatetimedisp1: tdbdatetimedisp;
   tdbdatetimedisp2: tdbdatetimedisp;
   tsimplewidget1: tsimplewidget;
   strip2: tlayouter;
   value2ed: tdbstringedit;
   value1ed: tdbstringedit;
   valueed: tdbstringedit;
   strip3: tlayouter;
   footprinted: tdbenum64editdb;
   strip0: texpandingwidget;
   navig: tdbnavigator;
   strip4: tlayouter;
   tdbenum64editdb2: tdbenum64editdb;
   tdbenum64editdb3: tdbenum64editdb;
   tsimplewidget2: tsimplewidget;
   procedure editfootprintev(const sender: TObject);
   procedure editkindev(const sender: TObject);
 end;

implementation
uses
 componenteditform_mfm,mainmodule,footprinteditform,componentkindeditform;
 
procedure tcomponenteditfo.editfootprintev(const sender: TObject);
var
 res1: modalresultty;
 fo1: tfootprinteditfo;
begin
 mainmo.beginfootprintedit();
 fo1:= tfootprinteditfo.create(nil);
 try
  repeat
   res1:= fo1.show(ml_application);
  until mainmo.endfootprintedit(res1 = mr_ok);
 finally
  fo1.destroy();
 end;
end;

procedure tcomponenteditfo.editkindev(const sender: TObject);
var
 res1: modalresultty;
 fo1: tcomponentkindeditfo;
begin
 mainmo.begincomponentkindedit();
 fo1:= tcomponentkindeditfo.create(nil);
 try
  repeat
   res1:= fo1.show(ml_application);
  until mainmo.endcomponentkindedit(res1 = mr_ok);
 finally
  fo1.destroy();
 end;
end;

end.
