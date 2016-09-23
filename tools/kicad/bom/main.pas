{ MSEkicad Copyright (c) 2016 by Martin Schreiber
   
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
unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mseact,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselistbrowser,msestream,msestrings,
 msesys,sysutils,msesimplewidgets,kicadschemaparser,mseifiendpoint,mdb,
 msedbedit,msegraphedits,mselookupbuffer,msescrollbar;

const
 maincaption = 'MSEkicadBOM';
 versiontext = '0.0';
type
 tmainfo = class(tmainform)
   mainfosta: tstatfile;
   mainmen: tmainmenu;
   getprojectopenfilename: tifiactionendpoint;
   updateprojectstate: tifiactionendpoint;
   getprojectsavefilename: tifiactionendpoint;
   editprojectsettings: tifiactionendpoint;
   tdbwidgetgrid1: tdbwidgetgrid;
   tdbstringedit1: tdbstringedit;
   tdbstringedit2: tdbstringedit;
   tdbstringedit3: tdbstringedit;
   tdbstringedit4: tdbstringedit;
   tdbstringedit5: tdbstringedit;
   procedure getfilenameev(const sender: TObject);
   procedure updateprojectstateev(const sender: TObject);
   procedure aboutev(const sender: TObject);
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure editprojectsettingsev(const sender: TObject);
  protected
 end;
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,mainmodule,msefileutils,projectsettingsform;
 
procedure tmainfo.getfilenameev(const sender: TObject);
var
 kind: filedialogkindty;
begin
 kind:= fdk_open;
 if sender = getprojectsavefilename then begin
  kind:= fdk_save;
 end;
 if mainmo.projectfiledialog.execute(kind) = mr_ok then begin
  mainoptions.filename:= mainmo.projectfiledialog.controller.filename;
 end
 else begin
  mainoptions.filename:= '';
 end;
end;

procedure tmainfo.updateprojectstateev(const sender: TObject);
var
 mstr1: msestring;
begin
 if mainmo.hasproject then begin
  if mainoptions.filename = '' then begin
   mstr1:= '<new>)';
  end
  else begin
   mstr1:= filename(mainoptions.filename)+')';
  end;
  if mainmo.modified then begin
   mstr1:= maincaption + ' (*'+mstr1;
  end
  else begin
   mstr1:= maincaption + ' ('+mstr1;
  end;
 end
 else begin
  mstr1:= maincaption;
 end;
 caption:= mstr1;
end;

procedure tmainfo.aboutev(const sender: TObject);
begin
 showmessage(maincaption+' version '+versiontext+lineend+
             'MSEgui version '+mseguiversiontext+lineend+
             lineend+
             copyrighttext+lineend+
             'by Martin Schreiber','About MSEkicadBOM');
end;

procedure tmainfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if not mainmo.doexit() then begin
  amodalresult:= mr_none;
 end;
end;

procedure tmainfo.editprojectsettingsev(const sender: TObject);
begin
 tprojectsettingsfo.create(nil).show(ml_application);
end;

end.
