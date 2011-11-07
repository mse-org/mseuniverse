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
//
// under construction
//
unit filechecklistframe;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,filelistframe,
 msegraphedits,mseifiglob,msetypes,mainmodule,msestrings,msegitcontroller;

type
 tfilechecklistframefo = class(tfilelistframefo)
   selected: tbooleanedit;
  public
   function selectedfiles(const aroot: tgitdirtreenode): filenamearty;
 end;

var
 filechecklistframefo: tfilechecklistframefo;

implementation
uses
 filechecklistframe_mfm;

{ tfilechecklistframe }

function tfilechecklistframefo.selectedfiles(
                  const aroot: tgitdirtreenode): filenamearty; 
var
 int1,int2: integer;
begin
 setlength(result,grid.rowcount);
 int2:= 0;
 for int1:= 0 to high(result) do begin
  if selected[int1] then begin
   result[int2]:= mainmo.getpath(aroot,
                           tgitfileitem(fileitemed[int1]).caption);
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;

end.
