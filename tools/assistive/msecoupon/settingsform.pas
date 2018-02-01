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
unit settingsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msesimplewidgets,msegraphedits,mseificomp,mseificompglob,mseifiglob,
 msescrollbar,mseact,msedataedits,msedropdownlist,mseedit,msestream,sysutils,
 msebitmap,msedatanodes,msefiledialog,msegrids,mselistbrowser,msesys,
 mseassistivehandler,msesplitter,msememodialog;
type
 tsettingsfo = class(tmseform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   pdfvariables: tbooleaneditradio;
   psbackground: tbooleaneditradio;
   backgroundsettings: tgroupbox;
   origx: trealedit;
   origy: trealedit;
   donatoron: tbooleanedit;
   donatorcapt: tstringedit;
   donatory: trealedit;
   donatorx: trealedit;
   recipienton: tbooleanedit;
   recipientcapt: tstringedit;
   recipienty: trealedit;
   recipientx: trealedit;
   descriptionon: tbooleanedit;
   descriptioncapt: tstringedit;
   descriptiony: trealedit;
   descriptionx: trealedit;
   quantityon: tbooleanedit;
   quantitycapt: tstringedit;
   quantityy: trealedit;
   quantityx: trealedit;
   barcodeon: tbooleanedit;
   barcodecapt: tstringedit;
   barcodey: trealedit;
   barcodex: trealedit;
   numberon: tbooleanedit;
   numbercapt: tstringedit;
   numbery: trealedit;
   numberx: trealedit;
   durationon: tbooleanedit;
   durationcapt: tstringedit;
   durationy: trealedit;
   durationx: trealedit;
   expirydateon: tbooleanedit;
   expirydatecapt: tstringedit;
   expirydatey: trealedit;
   expirydatex: trealedit;
   issuedatecapt: tstringedit;
   issuedatey: trealedit;
   issuedatex: trealedit;
   issuedateon: tbooleanedit;
   tstatfile1: tstatfile;
   tokenfile: tfilenameedit;
   tassistivewidgetitem1: tassistivewidgetitem;
   ps2pdf: tfilenameedit;
   pdftk: tfilenameedit;
   psviewer: tfilenameedit;
   issuedatew: trealedit;
   expirydatew: trealedit;
   durationw: trealedit;
   numberw: trealedit;
   barcodew: trealedit;
   quantityw: trealedit;
   descriptionw: trealedit;
   recipientw: trealedit;
   donatorw: trealedit;
   gs: tfilenameedit;
   preview: tbooleanedit;
   gsparams: tmemodialogedit;
   tsplitter1: tsplitter;
   tsplitter2: tsplitter;
   ps2pdfparams: tmemodialogedit;
   tsplitter3: tsplitter;
   pdftkparams: tmemodialogedit;
   concatdesc: tbooleanedit;
   tbutton3: tbutton;
   tsplitter4: tsplitter;
   psviewerparams: tmemodialogedit;
   tbutton4: tbutton;
   procedure datentev(const sender: TObject);
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure updatewidgets(const sender: TObject);
   procedure aboutev(const sender: TObject);
  protected
   fmodified: boolean;
 end;

implementation
uses
 settingsform_mfm,mainmodule;
 
procedure tsettingsfo.datentev(const sender: TObject);
begin
 fmodified:= true;
end;

procedure tsettingsfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if fmodified then begin
  mainmo.closequery(self,amodalresult);
 end;
end;

procedure tsettingsfo.updatewidgets(const sender: TObject);
begin
 backgroundsettings.enabled:= psbackground.value;
end;

procedure tsettingsfo.aboutev(const sender: TObject);
begin
 showmessage('MSEcoupon version: '+versiontext+lineend+
             'MSEgui version: '+mseguiversiontext+lineend+
             'Host: '+platformtext+lineend+lineend+
             'Copyright 1999-2018'+lineend+'by Martin Schreiber','About');
end;

end.
