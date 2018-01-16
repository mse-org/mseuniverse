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
unit newtokenform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msestatfile,mdb,msedb,mseifiglob,mseact,msedataedits,
 msedbedit,msedropdownlist,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mselookupbuffer,msescrollbar,msestream,sysutils,msedbdialog;
type
 tnewtokenfo = class(tmseform)
   tbutton1: tbutton;
   tstatfile1: tstatfile;
   dataso: tmsedatasource;
   numberdisp: tdbintegeredit;
   objected: tdbenum64editdb;
   quantityed: tdbrealedit;
   unitdisp: tdbstringedit;
   valuedisp: tdbrealedit;
   customered: tdbstringedit;
   durationdisp: tdbrealedit;
   recipiented: tdbstringedit;
   commented: tdbmemodialogedit;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton4: tbutton;
   tbutton5: tbutton;
   dateed: tdbdatetimeedit;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
 end;
implementation
uses
 newtokenform_mfm,mainmodule;
 
procedure tnewtokenfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 mainmo.closequery(dataso,amodalresult);
end;

end.
