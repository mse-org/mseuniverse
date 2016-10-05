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
 msedatabase,msefbconnection,msqldb,msesqldb,msesqlresult,msedbdispwidgets,
 msemacros,mclasses;

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
   globalsettingsact: taction;
   editglobalsettings: tifiactionlinkcomp;
   c_stockitemid: tmselargeintfield;
   c_rowstate: tmselongintfield;
   transwrite: tmsesqltransaction;
   footprintqu: tmsesqlquery;
   f_pk: tmselargeintfield;
   f_name: tmsestringfield;
   footprintdso: tmsedatasource;
   c_footprintname: tmsestringfield;
   c_footprintid: tmselargeintfield;
   footprintinsertcheck: tsqlresult;
   footprintdeletecheck: tsqlresult;
   c_stockvalue: tmsestringfield;
   c_stockvalue1: tmsestringfield;
   c_stockvalue2: tmsestringfield;
   compkindqu: tmsesqlquery;
   k_pk: tmselargeintfield;
   k_name: tmsestringfield;
   compkinddso: tmsedatasource;
   k_designation: tmsestringfield;
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
   sc_footprint: tmselargeintfield;
   sc_componentkind: tmselargeintfield;
   scd_designation: tmsestringfield;
   scd_parameter1: tmsestringfield;
   scd_parameter2: tmsestringfield;
   scd_parameter3: tmsestringfield;
   scd_parameter4: tmsestringfield;
   k_parameter1: tmsestringfield;
   k_parameter2: tmsestringfield;
   k_parameter3: tmsestringfield;
   k_parameter4: tmsestringfield;
   k_footprint: tmselargeintfield;
   k_footprintname: tmsestringfield;
   sc_footprintname: tmsestringfield;
   sc_kindname: tmsestringfield;
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
   procedure stockcompbeforepostev(DataSet: TDataSet);
   procedure aftercopyrecordev(DataSet: TDataSet);
   procedure beforecopyrecordev(DataSet: TDataSet);
   procedure bforecompcopyev(DataSet: TDataSet);
//   procedure componentkindvalidateev(Sender: TField);
   procedure stockcompinternalcalcev(const sender: tmsebufdataset;
                   const fetching: Boolean);
  private
   fhasproject: boolean;
   fmodified: boolean;
   foldname: msestring;
   fcompappliedcount: card32;
   fmacros: tmacrolist;
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
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   procedure openproject(const afilename: filenamety);
   procedure refresh();
   function closeproject(): boolean; //true if not canceled
   function saveproject(): boolean;  //true if not canceled
   function doexit: boolean;         //true if not canceled

   procedure begincomponentedit(const idfield: tmselargeintfield);
   procedure endcomponentedit(const fullrefresh: boolean);
   procedure begincomponentlistedit();
   procedure endcomponentlistedit();
   procedure beginfootprintedit(const idfield: tmselargeintfield);
   procedure endfootprintedit();
   procedure begincomponentkindedit();
   procedure endcomponentkindedit();
   procedure begincomponentsedit();
   function endcomponentsedit(const acommit: boolean): boolean; //true if ok
   function checkvalueexist(const avalue,avalue1,avalue2: msestring): boolean;
   property hasproject: boolean read fhasproject;
   property modified: boolean read fmodified;
   function expandcomponentmacros(const afield: tmsestringfield): msestring;
 end;
 
var
 mainmo: tmainmo;
 globaloptions: tglobaloptions;
 projectoptions: tprojectoptions;
 
implementation
uses
 mainmodule_mfm,msewidgets,variants,msestrmacros,msefilemacros,msemacmacros,
 mseenvmacros;

{ tmainmo }
type
 macronamety = (
    mn_value,mn_value1,mn_value2,mn_footprint,
    mn_designation,mn_parameter1,mn_parameter2,mn_parameter3,mn_parameter4,
    mn_k_footprint,mn_k_designation,
    mn_k_parameter1,mn_k_parameter2,mn_k_parameter3,mn_k_parameter4);

const
 macronames: array[macronamety] of msestring = (
//mn_value,mn_value1,mn_value2,mn_footprint,
    'value', 'value1', 'value2', 'footprint',
//mn_designation,mn_parameter1,mn_parameter2,mn_parameter3,mn_parameter4,
    'designation', 'parameter1', 'parameter2', 'parameter3', 'parameter4',
//mn_k_footprint,mn_k_designation,
    'k_footprint', 'k_designation',
//mn_k_parameter1,mn_k_parameter2,mn_k_parameter3,mn_k_parameter4);
    'k_parameter1', 'k_parameter2', 'k_parameter3', 'k_parameter4'
 );
var
 macroitems: array[macronamety] of pmacroinfoty; 

constructor tmainmo.create(aowner: tcomponent);
var
 ma1: macronamety;
begin
 fmacros:= tmacrolist.create([mao_caseinsensitive],
   initmacros([
               //0       1        2        3

    initmacros(macronames,
{
    ['value','value1','value2','footprint',
   //4             5            6            7            8
    'designation','parameter1','parameter2','parameter3','parameter4',
   //9             10
    'k_footprint','k_designation',
   //11             12             13             14
    'k_parameter1','k_parameter2','k_parameter3','k_parameter4'
    ],}[],[]),
    strmacros(),filemacros(),macmacros(),envmacros()]));
 for ma1:= low(macroitems) to high(macroitems) do begin
  fmacros.find(macronames[ma1],macroitems[ma1]);
 end;
 inherited;
end;

destructor tmainmo.destroy();
begin
 inherited;
 fmacros.free();
end;

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
 if globaloptions.filename <> '' then begin
  openproject(globaloptions.filename);
 end;
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
 bm1: bookmarkdataty;
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
  if not compds.indexlocal[0].find([info.reference],[],bm1) then begin
   compds.controller.appendrecord1([info.reference,footpr,val,val1,val2],
                                            [false,nfootpr,nval,nval1,nval2]);
    //duplicates are several units in same case
  end;
 end;
end;

procedure tmainmo.refresh();
var
 parser: tkicadschemaparser;
 stream: ttextstream;
 i1: int32;
 recno1: int32;
 rowstate1: int32;
 bm1: bookmarkdataty;
begin
 application.beginwait();
 try
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
   stockcompqu.controller.refresh(true);
   for i1:= 0 to compds.recordcount - 1 do begin
    if stockcompqu.indexlocal[1].find(
                   [compds.currentasmsestring[c_value,i1],
                    compds.currentasmsestring[c_value1,i1],
                    compds.currentasmsestring[c_value2,i1]],
                   [compds.currentisnull[c_value,i1],
                    compds.currentisnull[c_value1,i1],
                    compds.currentisnull[c_value2,i1]],bm1) then begin
     compds.currentaslargeint[c_stockitemid,i1]:= 
                   stockcompqu.currentbmaslargeint[sc_pk,bm1];
     compds.currentaslargeint[c_footprintid,i1]:=
                   stockcompqu.currentbmaslargeint[sc_footprint,bm1];
     compds.currentasmsestring[c_stockvalue,i1]:= 
                   stockcompqu.currentbmasmsestring[sc_value,bm1];
     compds.currentasmsestring[c_stockvalue1,i1]:= 
                   stockcompqu.currentbmasmsestring[sc_value1,bm1];
     compds.currentasmsestring[c_stockvalue2,i1]:=
                   stockcompqu.currentbmasmsestring[sc_value2,bm1];
     rowstate1:= -1;
    end
    else begin
     rowstate1:= 0;
    end;
    compds.currentasinteger[c_rowstate,i1]:= rowstate1;
   end;
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
  end;
 finally
  application.endwait();
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
 footprintqu.active:= true;
 compkindqu.active:= true;
 stockcompqu.active:= true;
 fcompappliedcount:= stockcompqu.appliedcount;
 if idfield <> nil then begin
  if idfield.isnull then begin
   stockcompqu.insert();
   sc_value.asnullmsestring:= c_value.asnullmsestring;
   sc_value1.asnullmsestring:= c_value1.asnullmsestring;
   sc_value2.asnullmsestring:= c_value2.asnullmsestring;
  end
  else begin
   stockcompqu.indexlocal[0].find([idfield]);
  end; 
 end;
end;

procedure tmainmo.endcomponentedit(const fullrefresh: boolean);
begin
 if fullrefresh and (fcompappliedcount <> stockcompqu.appliedcount) then begin
  refresh();
 end;
end;

procedure tmainmo.begincomponentlistedit();
begin
 application.beginwait();
 try
  footprintqu.controller.refresh(false);
  compkindqu.controller.refresh(false);
  stockcompqu.controller.refresh(true);
 finally
  application.endwait();
 end;
 fcompappliedcount:= stockcompqu.appliedcount;
end;

procedure tmainmo.endcomponentlistedit();
begin
 if fcompappliedcount <> stockcompqu.appliedcount then begin
  refresh();
 end;
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
            'Do you want to store the modifications?') then begin
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

procedure tmainmo.beginfootprintedit(const idfield: tmselargeintfield);
begin
 beginedit(footprintqu,idfield);
end;

procedure tmainmo.endfootprintedit();
begin
 //dummy
end;

procedure tmainmo.begincomponentkindedit();
begin
 beginedit(compkindqu,sc_componentkind);
end;

procedure tmainmo.endcomponentkindedit();
begin
 //dummy
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
var
 bm1: bookmarkdataty;
begin
 result:= stockcompqu.indexlocal[1].find([avalue1,avalue,avalue2],[],bm1);
end;

function tmainmo.expandcomponentmacros(
                     const afield: tmsestringfield): msestring;
var
 bm1: bookmarkdataty;
 ms1: msestring;
 bo1: boolean;
begin
 result:= '';
 stockcompdetailqu.controller.checkrefresh(); //make pending refresh
 bo1:= not sc_componentkind.isnull and 
                      compkindqu.indexlocal[0].find([sc_componentkind],bm1);
 ms1:= afield.asmsestring;
 if (ms1 = '') and bo1 then begin
  if afield = scd_designation then begin
   ms1:= compkindqu.currentbmasmsestring[k_designation,bm1];
  end
  else begin
   if afield = scd_parameter1 then begin
    ms1:= compkindqu.currentbmasmsestring[k_parameter1,bm1];
   end
   else begin
    if afield = scd_parameter2 then begin
     ms1:= compkindqu.currentbmasmsestring[k_parameter2,bm1];
    end
    else begin
     if afield = scd_parameter3 then begin
      ms1:= compkindqu.currentbmasmsestring[k_parameter3,bm1];
     end
     else begin
      if afield = scd_parameter4 then begin
       ms1:= compkindqu.currentbmasmsestring[k_parameter4,bm1];
      end;
     end;
    end;
   end;
  end;
 end;
 macroitems[mn_value]^.value:= sc_value.asmsestring;
 macroitems[mn_value1]^.value:= sc_value1.asmsestring;
 macroitems[mn_value2]^.value:= sc_value2.asmsestring;
 macroitems[mn_footprint]^.value:= sc_footprintname.asmsestring;
 macroitems[mn_designation]^.value:= scd_designation.asmsestring;
 macroitems[mn_parameter1]^.value:= scd_parameter1.asmsestring;
 macroitems[mn_parameter2]^.value:= scd_parameter2.asmsestring;
 macroitems[mn_parameter3]^.value:= scd_parameter3.asmsestring;
 macroitems[mn_parameter4]^.value:= scd_parameter4.asmsestring;
 if bo1 then begin
  macroitems[mn_k_footprint]^.value:= 
                         compkindqu.currentbmasmsestring[k_footprintname,bm1];
  macroitems[mn_k_designation]^.value:= 
                         compkindqu.currentbmasmsestring[k_designation,bm1];
  macroitems[mn_k_parameter1]^.value:= 
                         compkindqu.currentbmasmsestring[k_parameter1,bm1];
  macroitems[mn_k_parameter2]^.value:= 
                         compkindqu.currentbmasmsestring[k_parameter2,bm1];
  macroitems[mn_k_parameter3]^.value:= 
                         compkindqu.currentbmasmsestring[k_parameter3,bm1];
  macroitems[mn_k_parameter4]^.value:= 
                         compkindqu.currentbmasmsestring[k_parameter4,bm1];
 end
 else begin
  macroitems[mn_k_footprint]^.value:= '';
  macroitems[mn_k_designation]^.value:= '';
  macroitems[mn_k_parameter1]^.value:= '';
  macroitems[mn_k_parameter2]^.value:= '';
  macroitems[mn_k_parameter3]^.value:= '';
  macroitems[mn_k_parameter4]^.value:= '';
 end;
 result:= fmacros.expandmacros(ms1);
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
exit;
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
exit;
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

procedure tmainmo.stockcompbeforepostev(DataSet: TDataSet);
var
 bm1: bookmarkdataty;
begin
 with tmsesqlquery(dataset) do begin
  if indexlocal[1].find([sc_value,sc_value1,sc_value2],bm1,false,false,true) and
                           (currentbmasid[sc_pk,bm1] <> sc_pk.asid) then begin
   showmessage('Component with this values exist.','ERROR');
   abort();
  end;
 end;
end;

procedure tmainmo.beforecopyrecordev(DataSet: TDataSet);
begin
 with dataset.fieldbyname('NAME') do begin
  foldname:= asmsestring;
 end;
end;

procedure tmainmo.aftercopyrecordev(DataSet: TDataSet);
begin
 with dataset.fieldbyname('NAME') do begin
  asmsestring:= foldname+'_copy';
 end;
end;

procedure tmainmo.bforecompcopyev(DataSet: TDataSet);
begin
 stockcompdetailqu.controller.copyrecord();
end;

procedure tmainmo.stockcompinternalcalcev(const sender: tmsebufdataset;
               const fetching: Boolean);
var
 bm1: bookmarkdataty;
 bo1: boolean;
begin
 if sc_footprint.isnull then begin
  bo1:= false;
  if not sc_componentkind.isnull then begin
   if compkindqu.indexlocal[0].find([sc_componentkind],bm1) then begin
    if footprintqu.indexlocal[0].find(
               [compkindqu.currentbmasid[k_footprint,bm1]],[],bm1) then begin

     sc_footprintname.asmsestring:= 
                footprintqu.currentbmasmsestring[f_name,bm1];
     bo1:= true;
    end;
   end;
  end;
  if not bo1 then begin
   sc_footprintname.clear;
  end;
 end
 else begin
  if footprintqu.indexlocal[0].find([sc_footprint],bm1) then begin
   sc_footprintname.asmsestring:= footprintqu.currentbmasmsestring[f_name,bm1];
  end;
 end;
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
end
.
