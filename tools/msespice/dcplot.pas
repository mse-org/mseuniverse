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
unit dcplot;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,plotoptions,
 msedataedits,mseedit,mseifiglob,msestrings,msetypes;
type
 tdcplotfo = class(tplotoptionsfo)
   stop: trealedit;
   start: trealedit;
   source: tstringedit;
   increment: trealedit;
   increment2: trealedit;
   stop2: trealedit;
   start2: trealedit;
   source2: tstringedit;
  public
   function getplotstatement: string; override;
   function getxvalue: string; override;
 end;

implementation
uses
 dcplot_mfm;

{ tdcplotfo }

function tdcplotfo.getplotstatement: string;
begin
 result:= 'dc '+source.value+' '+start.asstring+' '+
                             stop.asstring+' '+increment.asstring;
 if not(source2.isnull or start2.isnull or stop2.isnull or 
                                        increment2.isnull) then begin
  result:= result + ' '+source2.value+' '+start2.asstring+' '+
                             stop2.asstring+' '+increment2.asstring;
 end;
end;

function tdcplotfo.getxvalue: string;
begin
 result:= '';
end;

end.
