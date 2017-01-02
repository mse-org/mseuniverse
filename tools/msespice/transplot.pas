{ MSEspice Copyright (c) 2012-2013 by Martin Schreiber
   
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
unit transplot;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,plotoptions,
 msedataedits,mseedit,mseifiglob,msestrings,msetypes,msegraphedits;
type
 ttransplotfo = class(tplotoptionsfo)
   tstart: trealedit;
   tlen: trealedit;
   minstep: trealedit;
   uic: tbooleanedit;
  public
   function getplotstatement: string; override;
   function getxvalue: string; override;
 end;
 
implementation
uses
 transplot_mfm,msefloattostr;
 
{ ttransplotfo }

function ttransplotfo.getplotstatement: string;
begin
 result:= 'tran 1 '+string(doubletostring(tstart.value+tlen.value)+' '+
                      doubletostring(tstart.value));
 if minstep.value <> emptyreal then begin
  result:= result+' '+string(doubletostring(minstep.value));
 end;
 if uic.value then begin
  result:= result + ' uic';
 end;
end;

function ttransplotfo.getxvalue: string;
begin
 result:= 'T';
end;

end.
