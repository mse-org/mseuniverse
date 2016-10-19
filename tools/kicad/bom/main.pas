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
 msesys,sysutils,msesimplewidgets,kicadschemaparser,mseifiendpoint,mdb,msedb,
 msedbedit,msegraphedits,mselookupbuffer,msescrollbar,mseactions,mseskin,
 msedispwidgets,mserichstring;

const
 maincaption = 'MSEkicadBOM';
type
 tmainfo = class(tmainform)
   mainfosta: tstatfile;
   mainmen: tmainmenu;
   getprojectopenfilename: tifiactionendpoint;
   updateprojectstate: tifiactionendpoint;
   getprojectsavefilename: tifiactionendpoint;
   editprojectsettings: tifiactionendpoint;
   menuitemframe: tframecomp;
   tfacelist1: tfacelist;
   editglobalsettings: tifiactionendpoint;
   getdbcedentials: tifiactionendpoint;
   horzkonvex: tfacecomp;
   vertkonvex: tfacecomp;
   editfootprintact: taction;
   editcompkindact: taction;
   editcomponentsact: taction;
   editfootprintlibact: taction;
   editmanufactureract: taction;
   editdistributoract: taction;
   grid: tdbwidgetgrid;
   refselector: tenum64editdb;
   valueselector: tenum64editdb;
   value1selector: tenum64editdb;
   value2selector: tenum64editdb;
   footprselector: tenum64editdb;
   nameed: tdbstringedit;
   valueed: tdbstringedit;
   value1ed: tdbstringedit;
   valu2ed: tdbstringedit;
   footpred: tdbstringedit;
   footprint: tdbstringedit;
   kind: tdbstringedit;
   description: tdbstringedit;
   manufacturer: tdbstringedit;
   distributor: tdbstringedit;
   editbutton: tstockglyphdatabutton;
   footprintselector: tenum64editdb;
   kindselector: tenum64editdb;
   descriptionselect: tenum64editdb;
   manufacturerselect: tenum64editdb;
   distributorselect: tenum64editdb;
   tdbdataicon1: tdbdataicon;
   editcomponentact: taction;
   areaed: tdbrealedit;
   areadisp: trealdisp;
   footprintinfoed: tdbstringedit;
   footprintinfoselector: tenum64editdb;
   procedure getfilenameev(const sender: TObject);
   procedure updateprojectstateev(const sender: TObject);
   procedure aboutev(const sender: TObject);
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure editprojectsettingsev(const sender: TObject);
   procedure editglobalsettingsev(const sender: TObject);
   procedure getdbcredentialsev(const sender: TObject);
   procedure editev(const sender: TObject);
   procedure editfootprintev(const sender: tobject);
   procedure editcomponentkindlist(const sender: tobject);
   procedure editcomponents(const sender: TObject);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
   procedure editfootprintlibev(const sender: TObject);
   procedure editmanufacturerev(const sender: TObject);
   procedure editdistributorev(const sender: TObject);
   procedure rowselectev(const sender: TObject; var avalue: Int64;
                   var accept: Boolean);
   procedure updateeditev(const sender: tcustomaction);
   procedure hintareaev(const sender: TObject; var info: hintinfoty);
  protected
  public
   procedure checkeditclose(const adataso: tdatasource;
                                        var amodalresult: modalresultty);
   procedure editcomponentkind(const aid: tmselargeintfield);
   procedure editfootprint(const aid: tmselargeintfield);
   procedure editmanufacturer(const aid: tmselargeintfield);
   procedure editdistributor(const aid: tmselargeintfield);
 end;
 
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,mainmodule,msefileutils,projectsettingsform,globalsettingsform,
 credentialsentryform,componenteditform,footprintlistform,footprintliblistform,
 componentkindeditform,manufacturerlistform,distributorlistform,
 componentlistform,componentkindlistform,msesqldb;
 
procedure tmainfo.checkeditclose(const adataso: tdatasource;
                                        var amodalresult: modalresultty);
var
 modres1: modalresultty;
begin
 modres1:= amodalresult;
 if adataso.dataset.state in [dsedit,dsinsert] then begin
  if amodalresult = mr_f10 then begin
   if not tmsesqlquery(adataso.dataset).post1() then begin
    amodalresult:= mr_none;
   end;
  end
  else begin
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
 if modres1 = amodalresult then begin
  mainmo.endedit();
 end;
end;

procedure tmainfo.editcomponentkind(const aid: tmselargeintfield);
begin
 tcomponentkindeditfo.create(aid).show(ml_application);
end;

procedure tmainfo.getfilenameev(const sender: TObject);
var
 kind1: filedialogkindty;
begin
 kind1:= fdk_open;
 if sender = getprojectsavefilename then begin
  kind1:= fdk_save;
 end;
 if mainmo.projectfiledialog.execute(kind1) = mr_ok then begin
  mainmo.projectfile:= mainmo.projectfiledialog.controller.filename;
 end
 else begin
  mainmo.projectfile:= '';
 end;
end;

procedure tmainfo.updateprojectstateev(const sender: TObject);
var
 mstr1: msestring;
begin
 if mainmo.hasproject then begin
  if mainmo.projectname = '' then begin
   mstr1:= '<new>)';
  end
  else begin
   mstr1:= mainmo.projectname+')';
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
  areadisp.clear();
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
   mr_ok,mr_f10: begin
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

procedure tmainfo.editfootprintev(const sender: tobject);
begin
 tfootprintlistfo.create(mainmo.sc_footprint).show(ml_application);
end;

procedure tmainfo.editfootprintlibev(const sender: TObject);
begin
 tfootprintliblistfo.create(mainmo.f_pk).show(ml_application);
end;

procedure tmainfo.editfootprint(const aid: tmselargeintfield);
begin
 tfootprintlistfo.create(aid).show(ml_application);
end;

procedure tmainfo.editmanufacturer(const aid: tmselargeintfield);
begin
 tmanufacturerlistfo.create(aid).show(ml_application);
end;

procedure tmainfo.editdistributor(const aid: tmselargeintfield);
begin
 tdistributorlistfo.create(aid).show(ml_application);
end;

procedure tmainfo.editcomponentkindlist(const sender: tobject);
begin
 tcomponentkindlistfo.create(mainmo.c_componentkindid).show(ml_application);
end;

procedure tmainfo.editmanufacturerev(const sender: TObject);
begin
 tmanufacturerlistfo.create(mainmo.c_manufacturerid).show(ml_application);
end;

procedure tmainfo.editdistributorev(const sender: TObject);
begin
 tdistributorlistfo.create(mainmo.c_distributorid).show(ml_application);
end;

procedure tmainfo.editcomponents(const sender: TObject);
begin
 tcomponentlistfo.create(mainmo.c_stockitemid).show(ml_application);
end;

procedure tmainfo.cellev(const sender: TObject; var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick,ccr_nokeyreturn]) then begin
  editcomponentact.asyncexecute();
 end;
end;

procedure tmainfo.rowselectev(const sender: TObject; var avalue: Int64;
               var accept: Boolean);
begin
 mainmo.compds.indexlocal[0].find([avalue],[]);
 grid.setfocus();
end;

procedure tmainfo.updateeditev(const sender: tcustomaction);
begin
 sender.enabled:= grid.row >= 0; //has active row
end;

procedure tmainfo.hintareaev(const sender: TObject; var info: hintinfoty);
begin
 info.caption:= 'Total footprint area:'+lineend+areadisp.disptext+'mm^2';
end;

end.
