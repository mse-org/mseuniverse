{ MSEtoken Copyright (c) 2018 by Martin Schreiber
   
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
unit tokenoverviewform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseact,
 msedataedits,msedropdownlist,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,sysutils,msedispwidgets,mserichstring,msesimplewidgets;
type
 ttokenoverviewfo = class(tmseform)
   fromed: tdatetimeedit;
   toed: tdatetimeedit;
   issuedcount: tintegerdisp;
   issuedvalue: trealdisp;
   honouredvalue: trealdisp;
   honouredcount: tintegerdisp;
   expiredvalue: trealdisp;
   expiredcount: tintegerdisp;
   openvalue: trealdisp;
   opencount: tintegerdisp;
   tstatfile1: tstatfile;
   tbutton1: tbutton;
   tbutton2: tbutton;
   procedure todatentev(const sender: TObject);
 end;
implementation
uses
 tokenoverviewform_mfm,msestrings;
 
procedure ttokenoverviewfo.todatentev(const sender: TObject);
var
 ar1: msestringarty;
begin
 ar1:= breaklines(opencount.frame.caption);
 ar1[2]:= toed.text;
 opencount.frame.caption:= concatstrings(ar1,lineend);
 ar1:= breaklines(openvalue.frame.caption);
 ar1[2]:= toed.text;
 openvalue.frame.caption:= concatstrings(ar1,lineend);
end;

end.
