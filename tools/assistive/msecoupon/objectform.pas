{ MSEcoupon Copyright (c) 2018 by Martin Schreiber
   
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
unit objectform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msesimplewidgets,mdb,mseact,msedataedits,msedbedit,msedropdownlist,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestream,sysutils,msedbdialog,msedb;
type
 tobjectfo = class(tmseform)
   tstatfile1: tstatfile;
   finibu: tbutton;
   nameed: tdbstringedit;
   priceed: tdbrealedit;
   united: tdbstringedit;
   descriptioned: tdbstringedit;
   commented: tdbdialogstringedit;
   dataso: tmsedatasource;
   cancelbu: tbutton;
   durationed: tdbrealedit;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
 end;
var
 objectfo: tobjectfo;
implementation
uses
 objectform_mfm,mainmodule;
 
procedure tobjectfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 mainmo.closequery(dataso,amodalresult);
end;

end.
