{ MSEspice Copyright (c) 2012 by Martin Schreiber
   
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
unit acplot;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,plotoptions,msedataedits,mseedit,mseifiglob,msestrings,msetypes;
type
 tacplotfo = class(tplotoptionsfo)
   fstop: trealedit;
   fstart: trealedit;
   stepkind: tenumedit;
   stepcount: tintegeredit;
   procedure setstopexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure setstartexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
  public
   function getplotstatement: string; override;
   function getxvalue: string; override;
 end;
 
implementation
uses
 acplot_mfm,mseformatstr,msefloattostr,sysutils;
 
type
 acstepkindty = (acsk_dec,acsk_oct,acsk_lin);
const
 acsteptags: array[acstepkindty] of string = (
             'DEC','OCT','LIN');

procedure tacplotfo.setstopexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 if fstart.value > avalue then begin
  fstart.value:= avalue;
 end;
end;

procedure tacplotfo.setstartexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 if fstop.value < avalue then begin
  fstop.value:= avalue;
 end;
end;

function tacplotfo.getplotstatement: string;
begin
 result:= '.AC '+acsteptags[acstepkindty(stepkind.value)]+' '+
              inttostr(stepcount.value)+ ' ' +
             doubletostring(fstart.value)+' '+doubletostring(fstop.value);
end;

function tacplotfo.getxvalue: string;
begin
 result:= 'F';
end;

end.

