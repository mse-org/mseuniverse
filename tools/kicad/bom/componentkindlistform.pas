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
unit componentkindlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils;

type
 tcomponentkindlistfo = class(tlisteditfo)
   designationed: tdbstringedit;
   descriptioned: tdbstringedit;
 //  procedure closeev(const sender: TObject);
   descriptionselector: tenum64editdb;
   nameselector: tenum64editdb;
   procedure dialogev(const sender: TObject);
  public
//   constructor create(); reintroduce;
 end;

implementation
uses
 componentkindlistform_mfm,mainmodule,componentkindeditform;

{ tcomponentkindlistform }
{
constructor tcomponentkindlistfo.create();
begin
 mainmo.begincomponentkindedit();
 inherited create(nil);
end;
}
{
procedure tcomponentkindlistfo.closeev(const sender: TObject);
begin
 mainmo.endcomponentkindedit();
end;
}
procedure tcomponentkindlistfo.dialogev(const sender: TObject);
begin
 tcomponentkindeditfo.create(nil).show(ml_application);
end;

end.
