{ MSEgit Copyright (c) 2011-2012 by Martin Schreiber
   
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
unit lastmessageform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestatfile,
 msesimplewidgets,msewidgets,msedataedits,mseedit,msegrids,mseifiglob,
 msestrings,msetypes,msewidgetgrid;
type
 tlastmessagefo = class(tmseform)
   tstatfile1: tstatfile;
   tbutton1: tbutton;
   tbutton2: tbutton;
   grid: twidgetgrid;
   ed: tstringedit;
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
 end;
var
 lastmessagefo: tlastmessagefo;
implementation
uses
 lastmessageform_mfm;
 
procedure tlastmessagefo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if (grid.row >= 0) and (iscellclick(info,[ccr_dblclick])) then begin
  window.modalresult:= mr_ok;
 end;
end;

end.
