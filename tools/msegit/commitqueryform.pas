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
unit commitqueryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mainmodule,msestatfile,
 filelistframe,msesimplewidgets,msewidgets,msegraphedits,mseifiglob,msetypes;
type
 tcommitqueryfo = class(tmseform)
   filelist: tfilelistframefo;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tbooleanedit1: tbooleanedit;
  public
   function exec(const aitems: msegitfileitemarty): msegitfileitemarty;
//   destructor destroy; override;
 end;

var
 commitqueryfo: tcommitqueryfo;

implementation
uses
 commitqueryform_mfm,msedatanodes;

{ tcommitqueryfo }

function tcommitqueryfo.exec(
                       const aitems: msegitfileitemarty): msegitfileitemarty;
var
 ar1: msegitfileitemarty;
// int1: integer;
begin
 result:= nil;
 if aitems <> nil then begin
  ar1:= msegitfileitemarty(copylistitems(listitemarty(aitems)));
  filelist.fileitemed.itemlist.assign(listitemarty(ar1));
  if show(ml_application) = mr_ok then begin
   showmessage('Under construction.');
  end;
 end;
end;

end.
