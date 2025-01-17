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
unit honourform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,mseact,msedataedits,msedropdownlist,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestatfile,msestream,sysutils,mdb,msedbedit,
 msegraphedits,msegrids,mselookupbuffer,msescrollbar,msedbdialog,mseifiendpoint;
type
 thonourfo = class(tmseform)
   honourbu: tbutton;
   tbutton2: tbutton;
   checkdisp: tstringedit;
   numbered: tenum64editdb;
   tstatfile1: tstatfile;
   recipientdisp: tdbstringedit;
   quantitydisp: tdbrealedit;
   valuedisp: tdbrealedit;
   expyirydatedisp: tdbdatetimeedit;
   isuedatedisp: tdbdatetimeedit;
   honourdateed: tdatetimeedit;
   descriptiondisp: tdbstringedit;
   customerdisp: tdbstringedit;
   commentdisp: tdbmemodialogedit;
   unitydisp: tdbstringedit;
   donatordisp: tdbstringedit;
   numbertext: tifistringendpoint;
   procedure numbereditev(const sender: tcustomedit; var atext: msestring);
 end;

implementation
uses
 honourform_mfm,mseformatstr;

procedure thonourfo.numbereditev(const sender: tcustomedit;
               var atext: msestring);
begin
 numbertext.value:= atext;
end;

end.
