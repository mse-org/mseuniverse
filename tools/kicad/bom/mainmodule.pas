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
unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mserttistat,msestat,
 msestatfile,mseact,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,
 msegraphics,msegraphutils,msegrids,msegui,mseguiglob,mseificomp,mseificompglob,
 mseifiglob,mselistbrowser,msemenus,msestream,msestrings,msesys,sysutils,
 mseactions,mdb,msebufdataset,msedb,mselocaldataset,kicadschemaparser,
 msedatabase,msefbconnection,msqldb,msesqldb,msesqlresult,msedbdispwidgets;

type
 tglobaloptions = class(toptions)
  private
   ffilename: filenamety;
   fusername: msestring;
   fpassword: msestring;
   fhostname: msestring;
   fdatabasename: msestring;
  public
   constructor create();
   property password: msestring read fpassword write fpassword; //not stored
   property username: msestring read fusername write fusername; //not stored
  published
   property filename: filenamety read ffilename write ffilename;
   property hostname: msestring read fhostname write fhostname;
   property databasename: msestring read fdatabasename write fdatabasename;
 end;

 tprojectoptions = class(toptions)
  private
   fschematics: msestringarty;
  public
   procedure storevalues(const asource: tmsecomponent;
                               const prefix: string = '') override;
  published
   property schematics: msestringarty read fschematics write fschematics;
 end;
 
 tmainmo = class(tmsedatamodule)
   projectoptrtti: trttistat;
   projectstat: tstatfile;
   mainstat: tstatfile;
   mainoptrtti: trttistat;
   projectfiledialog: tfiledialog;
   getprojectfileopen: tifiactionlinkcomp;
   openprojectact: taction;
   updateprojectstate: tifiactionlinkcomp;
   newprojectact: taction;
   closeprojectact: taction;
   saveprojectact: taction;
   saveprojectasact: taction;
   getprojectfilesave: tifiactionlinkcomp;
   exitact: taction;
   projectsettingsact: taction;
   editprojectsettings: tifiactionlinkcomp;
   compds: tlocaldataset;
   compdso: tmsedatasource;
   refreshact: taction;
   c_ref: tmsestringfield;
   c_footprint: tmsestringfield;
   c_value: tmsestringfield;
   c_value1: tmsestringfield;
   c_value2: tmsestringfield;
   conn: tfbconnection;
   getdbcredentials: tifiactionlinkcomp;
   trans: tmsesqltransaction;
   stockitem: tsqlresult;
   globalsettingsact: taction;
   editglobalsettings: tifiactionlinkcomp;
   valpar: tparamconnector;
   val1par: tparamconnector;
   val2par: tparamconnector;
   s_pk: tsqlresultconnector;
   c_stockitemid: tmselargeintfield;
   c_rowstate: tmselongintfield;
   transwrite: tmsesqltransaction;
   componenteditqu: tmsesqlquery;
   componenteditdso: tmsedatasource;
   componentpkpar: tparamconnector;
   e_pk: tmselargeintfield;
   e_value: tmsestringfield;
   e_value1: tmsestringfield;
   e_value2: tmsestringfield;
   e_footprint: tmselargeintfield;
   footprintqu: tmsesqlquery;
   f_pk: tmselargeintfield;
   f_name: tmsestringfield;
   footprintdso: tmsedatasource;
   c_footprintname: tmsestringfield;
   s_footprint: tsqlresultconnector;
   c_footprintid: tmselargeintfield;
   footprintinsertcheck: tsqlresult;
   footprintdeletecheck: tsqlresult;
   c_stockvalue: tmsestringfield;
   c_stockvalue1: tmsestringfield;
   c_stockvalue2: tmsestringfield;
   s_value: tsqlresultconnector;
   s_value1: tsqlresultconnector;
   s_value2: tsqlresultconnector;
   compkindqu: tmsesqlquery;
   k_pk: tmselargeintfield;
   k_name: tmsestringfield;
   compkinddso: tmsedatasource;
   k_designation: tmsestringfield;
   e_componentkind: tmselargeintfield;
   compkindinsertcheck: tsqlresult;
   compkinddeletecheck: tsqlresult;
   stockcompqu: tmsesqlquery;
   stockcompdso: tmsedatasource;
   sc_pk: tmselargeintfield;
   sc_value: tmsestringfield;
   sc_value1: tmsestringfield;
   sc_value2: tmsestringfield;
   stockcompdetailqu: tmsesqlquery;
   stockcompdetaildso: tmsedatasource;
   stockcompdetaillink: tfieldparamlink;
   procedure getprojectoptionsev(const sender: TObject; var aobject: TObject);
   procedure getmainoptionsev(const sender: TObject; var aobject: TObject);
   procedure mainstatreadev(const sender: TObject);
   procedure openprojectev(const sender: TObject);
   procedure newprojectev(const sender: TObject);
   procedure closeprojectev(const sender: TObject);
   procedure exitev(const sender: TObject);
   procedure projectsettingsupdateev(const sender: tcustomaction);
   procedure saveupdateev(const sender: tcustomaction);
   procedure closeprojectupdateev(const sender: tcustomaction);
   procedure refreshev(const sender: TObject);
   procedure getcredentialsev(const sender: tcustomsqlconnection;
                   var ausername: msestring; var apassword: msestring);
   procedure beforeconnectev(const sender: tmdatabase);
   procedure footprintpostev(DataSet: TDataSet);
   procedure beforefootprintdeleteev(DataSet: TDataSet);
   procedure compkindupdatedataev(Sender: TObject);
   procedure beforecompkinddeleteev(DataSet: TDataSet);
   procedure compkindpostev(DataSet: TDataSet);
  private
   fhasproject: boolean;
   fmodified: boolean;
  protected
   procedure statechanged();
   procedure docomp(const sender: tkicadschemaparser; var info: compinfoty);
   procedure beginedit(const aquery: tmsesqlquery; const afield: tfield);
   function endedit(const acommit: boolean; const aquery: tmsesqlquery;
                       const amessage: msestring): boolean;
   procedure dodeletecheck(const asqlres: tsqlresult; 
                                               const aid: tmselargeintfield);
   procedure doinsertcheck(const asqlres: tsqlresult;
                                            const aname: tmsestringfield);
  public
   procedure openproject(const afilename: filenamety);
   procedure refresh();
   function closeproject(): boolean; //true if not canceled
   function saveproject(): boolean;  //true if not canceled
   function doexit: boolean;         //true if not canceled
   procedure begincomponentedit(const idfield: tmselargeintfield);
   function endcomponentedit(const acommit: boolean): boolean; //true if ok
   procedure beginfootprintedit();
   function endfootprintedit(const acommit: boolean): boolean; //true if ok
   procedure begincomponentkindedit();
   function endcomponentkindedit(const acommit: boolean): boolean; //true if ok
   procedure begincomponentsedit();
   function endcomponentsedit(const acommit: boolean): boolean; //true if ok
   function checkvalueexist(const avalue,avalue1,avalue2: msestring): boolean;
   property hasproject: boolean read fhasproject;
   property modified: boolean read fmodified;
 end;
 
var
 mainmo: tmainmo;
 globaloptions: tglobaloptions;
 projectoptions: tprojectoptions;
 
implementation
uses
 mainmodule_mfm,msewidgets;

procedure tmainmo.getprojectoptionsev(const sender: TObject;
               var aobject: TObject);
begin
 aobject:= projectoptions;
end;

procedure tmainmo.getmainoptionsev(const sender: TObject; var aobject: TObject);
begin
 aobject:= globaloptions;
end;

procedure tmainmo.mainstatreadev(const sender: TObject);
begin
 if projectfiledialog.controller.filename <> '' then begin
  openproject(projectfiledialog.controller.filename);
 end;
end;

procedure tmainmo.refresh();
var
 parser: tkicadschemaparser;
 stream: ttextstream;
 i1: int32;
 recno1: int32;
 rowstate1: int32;
 par1,par2,par3: tmseparam;
 col1,col2,col3,col4,col5: tdbcol;
begin
 compds.disablecontrols();
 parser:= nil;
 try
  recno1:= compds.recno;
  compds.active:= false;
  compds.active:= true;
  parser:= tkicadschemaparser.create(nil);
  parser.oncomp:= @docomp;
  for i1:= 0 to high(projectoptions.schematics) do begin
   stream:= ttextstream.create(projectoptions.schematics[i1],fm_read);
   try
    stream.encoding:= ce_utf8;
    parser.parse(stream);
   finally
    stream.destroy();
   end;
  end;
  footprintqu.controller.refresh(false);  
  par1:= valpar.param;
  par2:= val1par.param;
  par3:= val2par.param;
  stockitem.active:= true;
  col1:= s_pk.col;
  col2:= s_footprint.col;
  col3:= s_value.col;
  col4:= s_value1.col;
  col5:= s_value2.col;
  for i1:= 0 to compds.recordcount - 1 do begin
   par1.asnullmsestring:= compds.currentasmsestring[c_value,i1];
   par2.asnullmsestring:= compds.currentasmsestring[c_value1,i1];
   par3.asnullmsestring:= compds.currentasmsestring[c_value2,i1];
   stockitem.refresh();
   if not stockitem.eof then begin
    compds.currentaslargeint[c_stockitemid,i1]:= col1.aslargeint;
    compds.currentaslargeint[c_footprintid,i1]:= col2.aslargeint;
    compds.currentasmsestring[c_stockvalue,i1]:= col3.asmsestring;
    compds.currentasmsestring[c_stockvalue1,i1]:= col4.asmsestring;
    compds.currentasmsestring[c_stockvalue2,i1]:= col5.asmsestring;
    rowstate1:= -1;
   end
   else begin
    rowstate1:= 0;
   end;
   compds.currentasinteger[c_rowstate,i1]:= rowstate1;
  end;
  componenteditqu.controller.refresh(false);
  if recno1 <= 0 then begin
   compds.first();
  end
  else begin
   if recno1 > compds.recordcount then begin
    compds.last();
   end
   else begin
    compds.recno:= recno1;
   end;
  end;
 finally
  parser.free();
  if compds.active then begin
   compds.post();
  end;
  compds.enablecontrols();
  stockitem.active:= false;
 end;
end;

procedure tmainmo.openproject(const afilename: filenamety);
begin
 globaloptions.filename:= afilename;
 projectstat.filename:= afilename;
 try
  projectstat.readstat();
  fhasproject:= true;
  fmodified:= false;
  refresh();
 except
  compds.active:= false;
  application.handleexception();
 end;
 statechanged();
end;

procedure tmainmo.saveupdateev(const sender: tcustomaction);
begin
 sender.enabled:= modified;
end;

procedure tmainmo.statechanged();
begin
 updateprojectstate.controller.execute()
end;

procedure tmainmo.docomp(const sender: tkicadschemaparser;
               var info: compinfoty);
//todo: make field names variable               

 function checkfield(const aname: msestring; const info: compfieldinfoty;
                     var val: msestring; var nval: boolean): boolean;
 begin
  if info.name = aname then begin
   if info.text <> '' then begin
    val:= info.text;
    nval:= false;
   end;
   result:= true;
  end
  else begin
   result:= false;
  end;
 end;//checkfield

var
 footpr,val,val1,val2: msestring;
 nfootpr,nval,nval1,nval2: boolean; //nullflags
 po1,pe: pcompfieldinfoty;
begin
 if (info.reference <> '') and (info.reference[1] <> '#') then begin
                                          //skip power marks
  nfootpr:= true;
  nval:= true;
  nval1:= true;
  nval2:= true;
  po1:= pointer(info.fields);
  pe:= po1 + length(info.fields);
  while po1 < pe do begin
   if not checkfield('FOOTPRINT',po1^,footpr,nfootpr) then begin
    if not checkfield('VALUE',po1^,val,nval) then begin
     if not checkfield('VALUE1',po1^,val1,nval1) then begin
      if not checkfield('VALUE2',po1^,val2,nval2) then begin
      end;
     end;
    end
   end;
   inc(po1);
  end;
  compds.controller.appendrecord1([info.reference,footpr,val,val1,val2],
                                            [false,nfootpr,nval,nval1,nval2]);
 end;
end;

function tmainmo.saveproject(): boolean;
begin
 result:= false;
 if fmodified then begin
  if globaloptions.filename = '' then begin
   getprojectfilesave.controller.execute();
  end;
  if globaloptions.filename <> '' then begin
   projectstat.filename:= globaloptions.filename;
   try
    projectstat.writestat();
    fmodified:= false;
    result:= true;
   except
    application.handleexception();
   end;
  end;
 end
 else begin
  result:= true;
 end;
 statechanged();
end;

function tmainmo.closeproject(): boolean;
begin
 if fhasproject and fmodified then begin
  result:= false;
  case askyesnocancel('Project has been modified.'+lineend+
                      'Do you want to save it?','CONFIRMATION') of
   mr_yes: begin
    if not saveproject() then begin
     exit;
    end;
   end;
   mr_no: begin
   end;
   else begin //cancel
    exit;
   end;
  end;
 end;
 compds.active:= false;
 projectoptions.destroy();
 projectoptions:= tprojectoptions.create(); //initial state
 fhasproject:= false;
 projectfiledialog.controller.filename:= '';
 globaloptions.filename:= '';
 result:= true;
 statechanged();
end;

function tmainmo.doexit: boolean;
begin
 result:= closeproject();
 if result then begin
  application.terminated:= true;
 end;
end;

procedure tmainmo.begincomponentedit(const idfield: tmselargeintfield);
begin
 footprintqu.controller.refresh(false);
 compkindqu.controller.refresh(false);
 if idfield = nil then begin
  stockcompqu.controller.refresh(true);
 end
 else begin
  stockcompqu.controller.refresh(false);
  if idfield.isnull then begin
   stockcompqu.insert();
   sc_value.asmsestring:= c_value.asmsestring;
   sc_value1.asmsestring:= c_value1.asmsestring;
   sc_value2.asmsestring:= c_value2.asmsestring;
  end
  else begin
   stockcompqu.indexlocal[0].find([idfield]);
  end; 
 end;
{
 componentpkpar.param.asid:= idfield.asid;
 componenteditqu.controller.refresh(false);
 if componenteditqu.eof then begin
  componenteditqu.insert();
  e_value.asmsestring:= c_value.asmsestring;
  e_value1.asmsestring:= c_value1.asmsestring;
  e_value2.asmsestring:= c_value2.asmsestring;
 end
}
end;

function tmainmo.endcomponentedit(const acommit: boolean): boolean;
begin
 result:= true;
{
 if acommit then begin
  try
   if (componenteditqu.state = dsinsert) and 
                   checkvalueexist(e_value.asmsestring,
                          e_value1.asmsestring,e_value2.asmsestring) then begin
    showmessage('Stock component with this value key exists.','ERROR');
    result:= false;
    exit;
   end;   
   componenteditqu.applyupdates();
   transwrite.commit();
  except
   application.handleexception();
   result:= false;
  end;
 end
 else begin
  transwrite.rollback();
 end;
 if acommit then begin
  refresh();
 end;
}
end;

function tmainmo.endedit(const acommit: boolean; const aquery: tmsesqlquery;
                       const amessage: msestring): boolean;
begin
 result:= true;
 if acommit then begin
  try
   aquery.applyupdates();
   transwrite.commit();
  except
   application.handleexception();
   result:= false;
  end;
 end
 else begin
  if aquery.changecount > 0 then begin
   if not askyesno('The data of '+amessage+' has been modified.'+lineend+
            'Do you want to cancel the modifications?') then begin
    result:= false;
   end
   else begin
    aquery.cancelupdates();
   end;
  end;
 end;
end;

procedure tmainmo.beginedit(const aquery: tmsesqlquery;
                                                 const afield: tfield);
begin
 aquery.active:= true;
 aquery.indexlocal[0].find([afield]);
end;

procedure tmainmo.beginfootprintedit();
begin
 beginedit(footprintqu,e_footprint);
end;

function tmainmo.endfootprintedit(const acommit: boolean): boolean;
begin
 result:= endedit(acommit,footprintqu,'footprint');
end;

procedure tmainmo.begincomponentkindedit();
begin
 beginedit(compkindqu,e_componentkind);
end;

function tmainmo.endcomponentkindedit(const acommit: boolean): boolean;
begin
 result:= endedit(acommit,compkindqu,'component kind');
end;

procedure tmainmo.begincomponentsedit();
begin
 stockcompqu.controller.refresh(false);
 stockcompqu.indexlocal.indexbyname('MAIN').find(
                                 [c_stockvalue,c_stockvalue1,c_stockvalue2]);
end;

function tmainmo.endcomponentsedit(const acommit: boolean): boolean;
begin
 result:= endedit(acommit,stockcompqu,'component');
 if result then begin
//  stockcompqu.active:= false;
  refresh();
 end;
end;

function tmainmo.checkvalueexist(const avalue: msestring;
               const avalue1: msestring; const avalue2: msestring): boolean;
begin
 valpar.param.asnullmsestring:= avalue;
 val1par.param.asnullmsestring:= avalue1;
 val2par.param.asnullmsestring:= avalue2;
 stockitem.refresh();
 result:= not stockitem.eof;
 stockitem.active:= false;
end;

procedure tmainmo.openprojectev(const sender: TObject);
begin
 if closeproject() then begin
  getprojectfileopen.controller.execute();
  if globaloptions.filename <> '' then begin
   openproject(globaloptions.filename);
   statechanged();
  end;
 end;
end;

procedure tmainmo.newprojectev(const sender: TObject);
begin
 if closeproject() then begin
  globaloptions.filename:= '';
  fhasproject:= true;
  statechanged();
  projectsettingsact.execute(true); //do not check enabled
 end;
end;

procedure tmainmo.closeprojectev(const sender: TObject);
begin
 closeproject();
end;

procedure tmainmo.exitev(const sender: TObject);
begin
 doexit();
end;

procedure tmainmo.projectsettingsupdateev(const sender: tcustomaction);
begin
 sender.enabled:= hasproject;
end;

procedure tmainmo.closeprojectupdateev(const sender: tcustomaction);
begin
 sender.enabled:= hasproject;
end;

procedure tmainmo.refreshev(const sender: TObject);
begin
 refresh();
end;

procedure tmainmo.getcredentialsev(const sender: tcustomsqlconnection;
               var ausername: msestring; var apassword: msestring);
begin
 getdbcredentials.controller.execute;
 ausername:= globaloptions.username;
 apassword:= globaloptions.password;
 globaloptions.fpassword:= '';
end;

procedure tmainmo.beforeconnectev(const sender: tmdatabase);
begin
 conn.hostname:= globaloptions.hostname;
 conn.databasename:= globaloptions.databasename;
end;

procedure tmainmo.doinsertcheck(const asqlres: tsqlresult;
                                            const aname: tmsestringfield);
begin
 asqlres.params[0].asmsestring:= aname.asmsestring;
 asqlres.refresh();
 if not asqlres.eof then begin
  showmessage('Record with this name already exists.','ERROR');
  abort();
 end;
end;

procedure tmainmo.dodeletecheck(const asqlres: tsqlresult; 
                                            const aid: tmselargeintfield);
begin
 asqlres.params[0].asid:= aid.asid;
 asqlres.refresh();
 if not asqlres.eof then begin
  showmessage('Record can not be deleted,'+lineend+
              'it is in use by component "'+
              asqlres.cols.colbyname('VALUE').asmsestring+','+
              asqlres.cols.colbyname('VALUE1').asmsestring+','+
              asqlres.cols.colbyname('VALUE1').asmsestring+'"','ERROR');
  abort();
 end;
end;

procedure tmainmo.footprintpostev(DataSet: TDataSet);
begin
 doinsertcheck(footprintinsertcheck,f_name);
end;

procedure tmainmo.beforefootprintdeleteev(DataSet: TDataSet);
begin
 dodeletecheck(footprintdeletecheck,f_pk);
end;

procedure tmainmo.compkindupdatedataev(Sender: TObject);
begin
 if (k_designation.asmsestring = '') or 
                  (k_designation.value = k_name.curvalue) then begin
  k_designation.asmsestring:= k_name.asmsestring;
 end;
end;

procedure tmainmo.beforecompkinddeleteev(DataSet: TDataSet);
begin
 dodeletecheck(compkinddeletecheck,k_pk);
end;

procedure tmainmo.compkindpostev(DataSet: TDataSet);
begin
 doinsertcheck(compkindinsertcheck,k_name);
end;

{ tprojectoptions }

procedure tprojectoptions.storevalues(const asource: tmsecomponent;
               const prefix: string = '');
begin
 inherited;
 mainmo.fmodified:= true;
 mainmo.statechanged();
 mainmo.refresh();
end;

{ tmainoptions }

{ tglobaloptions }

constructor tglobaloptions.create();
begin
 fhostname:= 'localhost';
 fdatabasename:= 'stock';
end;

initialization
 globaloptions:= tglobaloptions.create();
 projectoptions:= tprojectoptions.create();
finalization
 projectoptions.free();
 globaloptions.free();
end.
