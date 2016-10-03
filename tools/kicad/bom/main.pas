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
 msedbedit,msegraphedits,mselookupbuffer,msescrollbar,mseactions,mseskin;

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
   nameed: tdbstringedit;
   footpred: tdbstringedit;
   valueed: tdbstringedit;
   value1ed: tdbstringedit;
   valu2ed: tdbstringedit;
   menuitemframe: tframecomp;
   tfacelist1: tfacelist;
   editglobalsettings: tifiactionendpoint;
   getdbcedentials: tifiactionendpoint;
   editbutton: tstockglyphdatabutton;
   footprstock: tdbstringedit;
   tdbstringedit1: tdbstringedit;
   tdbstringedit2: tdbstringedit;
   tdbstringedit3: tdbstringedit;
   horzkonvex: tfacecomp;
   vertkonvex: tfacecomp;
   editfootprintact: taction;
   editcompkindact: taction;
   editcomponentsact: taction;
   procedure getfilenameev(const sender: TObject);
   procedure updateprojectstateev(const sender: TObject);
   procedure aboutev(const sender: TObject);
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure editprojectsettingsev(const sender: TObject);
   procedure editglobalsettingsev(const sender: TObject);
   procedure getdbcredentialsev(const sender: TObject);
   procedure editev(const sender: TObject);
   procedure editfootprint(const sender: tobject);
   procedure editcomponentkind(const sender: tobject);
   procedure editcomponents(const sender: TObject);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
  protected
  public
   procedure checkeditclose(const adataso: tdatasource;
                                        var amodalresult: modalresultty);
 end;
 
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,mainmodule,msefileutils,projectsettingsform,globalsettingsform,
 credentialsentryform,componenteditform,footprintlistform,componentkindeditform,
 componentlistform,componentkindlistform,msesqldb;
 
procedure tmainfo.checkeditclose(const adataso: tdatasource;
                                        var amodalresult: modalresultty);
begin
 if adataso.dataset.state in [dsedit,dsinsert] then begin
  case askyesnocancel('Record has been modified.'+lineend+
         'Do you want to store the modifications?','CONFIRMATION') of
   mr_yes: begin
    if not tmsesqlquery(adataso.dataset).post1() then begin
     amodalresult:= mr_none;
    end;
   end;
   mr_no: begin
    adataso.dataset.cancel();
   end;
   else begin
    amodalresult:= mr_none;
   end;
  end;
 end;
end;

procedure tmainfo.getfilenameev(const sender: TObject);
var
 kind: filedialogkindty;
begin
 kind:= fdk_open;
 if sender = getprojectsavefilename then begin
  kind:= fdk_save;
 end;
 if mainmo.projectfiledialog.execute(kind) = mr_ok then begin
  globaloptions.filename:= mainmo.projectfiledialog.controller.filename;
 end
 else begin
  globaloptions.filename:= '';
 end;
end;

procedure tmainfo.updateprojectstateev(const sender: TObject);
var
 mstr1: msestring;
begin
 if mainmo.hasproject then begin
  if globaloptions.filename = '' then begin
   mstr1:= '<new>)';
  end
  else begin
   mstr1:= filename(globaloptions.filename)+')';
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

procedure tmainfo.editglobalsettingsev(const sender: TObject);
begin
 tglobalsettingsfo.create(nil).show(ml_application);
end;

procedure tmainfo.getdbcredentialsev(const sender: TObject);
var
 fo: tcredentialsentryfo;
begin
 fo:= tcredentialsentryfo.create(nil);
 try
  case fo.show(ml_application) of
   mr_ok: begin
    globaloptions.username:= fo.usernameed.value;
    globaloptions.password:= fo.passworded.value;
   end;
   else begin
    abort();
   end;
  end;
 finally
  fo.destroy();
 end;
end;

procedure tmainfo.editev(const sender: TObject);
begin
 tcomponenteditfo.create(mainmo.c_stockitemid,true).show(ml_application);
end;

procedure tmainfo.editfootprint(const sender: tobject);
begin
 tfootprintlistfo.create().show(ml_application);
end;

procedure tmainfo.editcomponentkind(const sender: tobject);
begin
 tcomponentkindlistfo.create().show(ml_application);
end;

procedure tmainfo.editcomponents(const sender: TObject);
begin
 tcomponentlistfo.create.show(ml_application);
end;

procedure tmainfo.cellev(const sender: TObject; var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) then begin
  editbutton.execute();
 end;
end;
{
procedure tmainfo.editcomponents(const sender: TObject);
var
 res1: modalresultty;
 fo1: tcomponentlistfo;
begin
 mainmo.begincomponentsedit();
 fo1:= tcomponentlistfo.create(nil);
 try
  repeat
   res1:= fo1.show(ml_application);
  until mainmo.endcomponentsedit(res1 = mr_ok);
 finally
  fo1.destroy();
 end;
end;
}
end.
