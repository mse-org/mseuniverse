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
 msemacros,mclasses,msedbedit,msegraphedits,mselookupbuffer,msescrollbar;

const
 versiontext = '0.0';

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

 filekindty = (fk_componentfootprint);
 tprojectoptions = class(toptions)
  private
   fschematics: msestringarty;
   ffilenames: array[filekindty] of msestring;
   ffilewarnings: array[filekindty] of boolean;
   ffileencoding: charencodingty;
   freportencoding: int32;
   flibident: msestringarty;
   flibalias: msestringarty;
   procedure setreportencoding(const avalue: int32);
  public
   constructor create();
   procedure storevalues(const asource: tmsecomponent;
                               const prefix: string = '') override;
   function getfilename(const akind: filekindty; 
                                 out afile: filenamety): boolean; //true if ok
   property fileencoding: charencodingty read ffileencoding;
  published
   property schematics: msestringarty read fschematics write fschematics;
   property compfootprint: msestring read ffilenames[fk_componentfootprint]
                                        write ffilenames[fk_componentfootprint];
   property compfootprintwarn: boolean 
                           read ffilewarnings[fk_componentfootprint]
                                     write ffilewarnings[fk_componentfootprint];
   property reportencoding: int32 read freportencoding write setreportencoding;
   property libident: msestringarty read flibident write flibident;
   property libalias: msestringarty read flibalias write flibalias;
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
   compkindqu: tmsesqlquery;
   k_pk: tmselargeintfield;
   k_name: tmsestringfield;
   compkinddso: tmsedatasource;
   k_description: tmsestringfield;
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
   scd_description: tmsestringfield;
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
   sc_kindname: tmsestringfield;
   footprintlibqu: tmsesqlquery;
   footprintlibdso: tmsedatasource;
   f_libname: tmsestringfield;
   cmplistact: taction;
   f_libident: tmsestringfield;
   f_ident: tmsestringfield;
   c_timestamp: tmsestringfield;
   fl_name: tmsestringfield;
   fl_ident: tmsestringfield;
   c_componentkindname: tmsestringfield;
   fl_pk: tmselargeintfield;
   c_description: tmsestringfield;
   manufacturerdso: tmsedatasource;
   manufacturerqu: tmsesqlquery;
   m_ident: tmsestringfield;
   m_name: tmsestringfield;
   m_pk: tmselargeintfield;
   distributordso: tmsedatasource;
   distributorqu: tmsesqlquery;
   d_ident: tmsestringfield;
   d_name: tmsestringfield;
   d_pk: tmselargeintfield;
   deletetest: tsqlresult;
   inserttest: tsqlresult;
   c_manufacturerid: tmselargeintfield;
   c_distributorid: tmselargeintfield;
   c_componentkindid: tmselargeintfield;
   k_manufacturer: tmselargeintfield;
   k_distributor: tmselargeintfield;
   sc_manufacturer: tmselargeintfield;
   sc_distributor: tmselargeintfield;
   sc_footprintname: tmsestringfield;
   sc_manufacturername: tmsestringfield;
   sc_distributorname: tmsestringfield;
   k_distributorname: tmsestringfield;
   k_manufacturername: tmsestringfield;
   c_manufacturername: tmsestringfield;
   c_distributorname: tmsestringfield;
   c_pk: tmselargeintfield;
   c_area: tmsefloatfield;
   f_area: tmsefloatfield;
   totarea: tifireallinkcomp;
   f_description: tmsestringfield;
   sc_footprintinfo: tmsestringfield;
   c_footprintinfo: tmsestringfield;
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
//   procedure compkindupdatedataev(Sender: TObject);
   procedure cmpkinddeletecheckev(DataSet: TDataSet);
   procedure stockcompbeforepostev(DataSet: TDataSet);
   procedure aftercopyrecordev(DataSet: TDataSet);
   procedure beforecopyrecordev(DataSet: TDataSet);
   procedure bforecompcopyev(DataSet: TDataSet);
   procedure stockcompinternalcalcev(const sender: tmsebufdataset;
                   const fetching: Boolean);
   procedure validprojectupdateev(const sender: tcustomaction);
   procedure componentfootprintlistev(const sender: TObject);
   procedure aftercommitev(const sender: TSQLTransaction);
   procedure footprintdeletecheckev(DataSet: TDataSet);
   procedure namecheckev(DataSet: TDataSet);
   procedure validatenameidentev(Sender: TField);
   procedure distributordeletecheckev(DataSet: TDataSet);
   procedure maufaturerdeletecheckev(DataSet: TDataSet);
  private
   fhasproject: boolean;
   fmodified: boolean;
   foldname: msestring;
   fcommitcount: card32;
   fmacros: tmacrolist;
   fprojectname: msestring;
  protected
   procedure statechanged();
   procedure docomp(const sender: tkicadschemaparser; var info: compinfoty);
   procedure dodeletecheck(const asqlres: tsqlresult; 
                                               const aid: tmselargeintfield;
                                               const recname: msestring);
   procedure deletecheck(const id: tmselargeintfield;
                                 const references: array of tmselargeintfield);
   procedure insertcheck(const namefield: tmsestringfield);
   procedure doinsertcheck(const asqlres: tsqlresult;
                                            const aname: tmsestringfield);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   procedure openproject(const afilename: filenamety);
   procedure endedit();
   procedure refresh();
   function closeproject(): boolean; //true if not canceled
   function saveproject(): boolean;  //true if not canceled
   function doexit: boolean;         //true if not canceled

   procedure beginedit(const aquery: tmsesqlquery; const afield: tfield);
   procedure begincomponentsedit();
   procedure begincomponentedit(const idfield: tmselargeintfield);

   function checkvalueexist(const avalue,avalue1,avalue2: msestring): boolean;
   property hasproject: boolean read fhasproject;
   property projectname: msestring read fprojectname;
   property modified: boolean read fmodified;
   function expandcomponentmacros(const atext: msestring): msestring;
   function expandcomponentmacros(const afield: tmsestringfield): msestring;
 end;
 
var
 mainmo: tmainmo;
 globaloptions: tglobaloptions;
 projectoptions: tprojectoptions;

procedure errormessage(const message: msestring);
 
implementation
uses
 mainmodule_mfm,msewidgets,variants,msestrmacros,msefilemacros,msemacmacros,
 mseenvmacros,msefileutils,mseformatstr,msesysutils,msedate,msereal;

{ tmainmo }
type
 macronamety = (
    mn_value,mn_value1,mn_value2,
    mn_footprint,mn_footprintident,mn_footprintlibrary,
    mn_footprintdescription,
    mn_manufacturer,mn_distributor,
    mn_description,mn_parameter1,mn_parameter2,mn_parameter3,mn_parameter4,
    mn_k_footprint,mn_k_footprintident,mn_k_footprintlibrary,
    mn_k_footprintdescription,
    mn_k_manufacturer,mn_k_distributor,mn_k_description,
    mn_k_parameter1,mn_k_parameter2,mn_k_parameter3,mn_k_parameter4);

const
 macronames: array[macronamety] of msestring = (
//mn_value,mn_value1,mn_value2,
    'value', 'value1', 'value2',
//mn_footprint,mn_footprintident,mn_footprintlibrary,
    'footprint', 'footprintident', 'footprintlibrary',
//mn_footprintdescription,
    'footprintdescription',
//mn_manufacturer,mn_distributor,
    'manufacturer', 'distributor',
//mn_designation,mn_parameter1,mn_parameter2,mn_parameter3,mn_parameter4,
    'description', 'parameter1', 'parameter2', 'parameter3', 'parameter4',
//mn_k_footprint,mn_k_footprintident,mn_k_footprintlibrary,
    'k_footprint','k_footprintident','k_footprintlibrary',
//mn_k_footprintdescription,
    'k_footprintdescription',
//mn_k_manufacturer,mn_k_distributor,mn_k_description,
    'k_manufacturer', 'k_distributor', 'k_description',
//mn_k_parameter1,mn_k_parameter2,mn_k_parameter3,mn_k_parameter4);
    'k_parameter1', 'k_parameter2', 'k_parameter3', 'k_parameter4'
 );
var
 macroitems: array[macronamety] of pmacroinfoty; 

procedure errormessage(const message: msestring);
begin
 showmessage(message,'ERROR');
end;

constructor tmainmo.create(aowner: tcomponent);
var
 ma1: macronamety;
begin
 fmacros:= tmacrolist.create([mao_caseinsensitive],
   initmacros([
    initmacros(macronames,[],[]),
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
 footpr,val,val1,val2,footprinfo: msestring;
 nfootpr,nval,nval1,nval2,nfootprinfo: boolean; //nullflags
 po1,pe: pcompfieldinfoty;
 bm1: bookmarkdataty;
begin
 if (info.reference <> '') and (info.reference[1] <> '#') then begin
                                          //skip power marks
  nfootpr:= true;
  nval:= true;
  nval1:= true;
  nval2:= true;
  nfootprinfo:= true;
  po1:= pointer(info.fields);
  pe:= po1 + length(info.fields);
  while po1 < pe do begin
   if not checkfield('FOOTPRINT',po1^,footpr,nfootpr) then begin
    if not checkfield('VALUE',po1^,val,nval) then begin
     if not checkfield('VALUE1',po1^,val1,nval1) then begin
      if not checkfield('VALUE2',po1^,val2,nval2) then begin
       if not checkfield('FOOTPRINTINFO',po1^,footprinfo,
                                                  nfootprinfo) then begin
       end;
      end;
     end;
    end
   end;
   inc(po1);
  end;
  if not compds.indexlocal[1].find([info.reference],[],bm1) then begin
   compds.controller.appendrecord1([compds.recordcount,info.reference,
                    info.timestamp,footpr,val,val1,val2,footprinfo],
                    [false,false,false,nfootpr,nval,nval1,nval2,nfootprinfo]);
    //duplicates are several units in same housing
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
 bm1,bm2: bookmarkdataty;
 id1,id2: int64;
 bo1: boolean;
 area1,f1: flo64;
begin
 application.beginwait();
 try
  compds.disablecontrols();
  parser:= nil;
  area1:= 0;
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
   compds.post(); //last inserted record
   
   manufacturerqu.controller.refresh(false);
   distributorqu.controller.refresh(false);
   footprintlibqu.controller.refresh(false);
   footprintqu.controller.refresh(false);
   stockcompqu.disablecontrols();
   stockcompdetailqu.disablecontrols();
   try
    stockcompqu.controller.refresh(true);
    for i1:= 0 to compds.recordcount - 1 do begin
     if stockcompqu.indexlocal[1].find(
                    [compds.currentasmsestring[c_value,i1],
                     compds.currentasmsestring[c_value1,i1],
                     compds.currentasmsestring[c_value2,i1],
                     compds.currentasmsestring[c_footprintinfo,i1]],
                    [compds.currentisnull[c_value,i1],
                     compds.currentisnull[c_value1,i1],
                     compds.currentisnull[c_value2,i1],
                     compds.currentisnull[c_footprintinfo,i1]]) then begin
      compds.currentasid[c_stockitemid,i1]:= sc_pk.asid;

      id2:= sc_componentkind.asid;
      compds.currentasid[c_componentkindid,i1]:= id2;
      bo1:= (id2 >= 0) and compkindqu.indexlocal[0].find([id2],[],bm2);

      id1:= sc_footprint.asid;
      if (id1 < 0) and bo1 then begin
       id1:= compkindqu.currentbmasid[k_footprint,bm2];
      end;
      compds.currentasid[c_footprintid,i1]:= id1;
      if (id1 >= 0) and footprintqu.indexlocal[0].find([id1],[],bm1) then begin
       f1:= footprintqu.currentbmasfloat[f_area,bm1];
       if f1 <> emptyfloat64 then begin
        compds.currentasfloat[c_area,i1]:= f1;
        area1:= area1 + f1;
       end;
      end;

      id1:= sc_manufacturer.asid;
      if (id1 < 0) and bo1 then begin
       id1:= compkindqu.currentbmasid[k_manufacturer,bm2];
      end;
      compds.currentasid[c_manufacturerid,i1]:= id1;

      id1:= sc_distributor.asid;
      if (id1 < 0) and bo1 then begin
       id1:= compkindqu.currentbmasid[k_distributor,bm2];
      end;
      compds.currentasid[c_distributorid,i1]:= id1;

//      compds.currentasmsestring[c_stockvalue,i1]:= sc_value.asmsestring;
//      compds.currentasmsestring[c_stockvalue1,i1]:= sc_value1.asmsestring;
//      compds.currentasmsestring[c_stockvalue2,i1]:= sc_value2.asmsestring;
      stockcompdetailqu.params[0].asid:= sc_pk.asid; 
                           //manually because of disablecontrols
      stockcompdetailqu.controller.refresh(false);
      compds.currentasmsestring[c_description,i1]:=
                                        expandcomponentmacros(scd_description);
      rowstate1:= -1;
     end
     else begin
      rowstate1:= 0;
     end;
     compds.currentasinteger[c_rowstate,i1]:= rowstate1;
    end;
   finally
    stockcompqu.enablecontrols();
    stockcompdetailqu.enablecontrols();
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
   totarea.controller.value:= area1;
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
  fprojectname:= filenamebase(afilename);
  fmodified:= false;
  refresh();
 except
  compds.active:= false;
  application.handleexception();
 end;
 statechanged();
end;

procedure tmainmo.endedit();
begin
 if (application.modallevel = 1) and (fcommitcount <> 0) then begin
  refresh();
 end;
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
 fprojectname:= '';
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
 beginedit(stockcompqu,nil);
 if idfield <> nil then begin
  if idfield.isnull then begin
   stockcompqu.insert();
   sc_value.asnullmsestring:= c_value.asnullmsestring;
   sc_value1.asnullmsestring:= c_value1.asnullmsestring;
   sc_value2.asnullmsestring:= c_value2.asnullmsestring;
   sc_footprintinfo.asnullmsestring:= c_footprintinfo.asnullmsestring;
  end
  else begin
   stockcompqu.indexlocal[0].find([idfield]);
  end; 
 end;
end;

procedure tmainmo.beginedit(const aquery: tmsesqlquery;
                                                 const afield: tfield);
begin
 manufacturerqu.active:= true;
 distributorqu.active:= true;
 footprintlibqu.active:= true;
 compkindqu.active:= true;
 footprintqu.active:= true;
 stockcompdetailqu.active:= true;
 stockcompqu.active:= true;
 aquery.active:= true;
 if afield <> nil then begin
  aquery.indexlocal[0].find([afield]);
 end;
 if application.modallevel = 0 then begin
  fcommitcount:= 0;
 end;
end;

procedure tmainmo.begincomponentsedit();
begin
 stockcompqu.controller.refresh(false);
 stockcompqu.indexlocal[0].find([c_stockitemid]);
// stockcompqu.indexlocal.indexbyname('MAIN').find(
//                                 [c_stockvalue,c_stockvalue1,c_stockvalue2]);
 beginedit(stockcompqu,nil);
end;

function tmainmo.checkvalueexist(const avalue: msestring;
               const avalue1: msestring; const avalue2: msestring): boolean;
var
 bm1: bookmarkdataty;
begin
 result:= stockcompqu.indexlocal[1].find([avalue1,avalue,avalue2],[],bm1);
end;

function tmainmo.expandcomponentmacros(const atext: msestring): msestring;

 procedure updatemacro(const abm: bookmarkdataty; const afield: tfield; 
                         const componentmacro,kindmacro: macronamety);
 var
  ms1: msestring;
 begin
  ms1:= tmsesqlquery(afield.dataset).currentbmasmsestring[afield,abm];
  macroitems[kindmacro]^.value:= ms1;
  if macroitems[componentmacro]^.value = '' then begin
   macroitems[componentmacro]^.value:= ms1;
  end;
 end; //updatemacro

var
 bm1,bm2: bookmarkdataty;
 bo1: boolean;

begin
 result:= '';
 stockcompdetailqu.controller.checkrefresh(); //make pending refresh
 bo1:= not sc_componentkind.isnull and 
                      compkindqu.indexlocal[0].find([sc_componentkind],bm1);
 macroitems[mn_value]^.value:= sc_value.asmsestring;
 macroitems[mn_value1]^.value:= sc_value1.asmsestring;
 macroitems[mn_value2]^.value:= sc_value2.asmsestring;
 if footprintqu.indexlocal[0].find([sc_footprint],bm2) then begin
  macroitems[mn_footprint]^.value:= 
                            footprintqu.currentbmasmsestring[f_name,bm2];
  macroitems[mn_footprintident]^.value:= 
                            footprintqu.currentbmasmsestring[f_ident,bm2];
  macroitems[mn_footprintlibrary]^.value:= 
                            footprintqu.currentbmasmsestring[f_libname,bm2];
  macroitems[mn_footprintdescription]^.value:= 
                            footprintqu.currentbmasmsestring[f_description,bm2];
 end
 else begin
  macroitems[mn_footprint]^.value:= '';
  macroitems[mn_footprintident]^.value:= '';
  macroitems[mn_footprintlibrary]^.value:= '';
  macroitems[mn_footprintdescription]^.value:= '';
 end;
 macroitems[mn_manufacturer]^.value:= sc_manufacturername.asmsestring;
 macroitems[mn_distributor]^.value:= sc_distributorname.asmsestring;
 macroitems[mn_description]^.value:= scd_description.asmsestring;
 macroitems[mn_parameter1]^.value:= scd_parameter1.asmsestring;
 macroitems[mn_parameter2]^.value:= scd_parameter2.asmsestring;
 macroitems[mn_parameter3]^.value:= scd_parameter3.asmsestring;
 macroitems[mn_parameter4]^.value:= scd_parameter4.asmsestring;

 if bo1 then begin
  if footprintqu.indexlocal[0].find(
            [compkindqu.currentbmasid[k_footprint,bm1]],[],bm2) then begin
   updatemacro(bm2,f_name,mn_footprint,mn_k_footprint);
   updatemacro(bm2,f_ident,mn_footprintident,mn_k_footprintident);
   updatemacro(bm2,f_libname,mn_footprintlibrary,mn_k_footprintlibrary);
   updatemacro(bm2,f_description,mn_footprintdescription,
                                                 mn_k_footprintdescription);
  end
  else begin
   macroitems[mn_k_footprint]^.value:= '';
   macroitems[mn_k_footprintident]^.value:= '';
   macroitems[mn_k_footprintlibrary]^.value:= '';
   macroitems[mn_k_footprintdescription]^.value:= '';
  end;
  updatemacro(bm1,k_manufacturername,mn_manufacturer,mn_k_manufacturer);
  updatemacro(bm1,k_distributorname,mn_distributor,mn_k_distributor);
  updatemacro(bm1,k_description,mn_description,mn_k_description);
  updatemacro(bm1,k_parameter1,mn_parameter1,mn_k_parameter1);
  updatemacro(bm1,k_parameter2,mn_parameter2,mn_k_parameter2);
  updatemacro(bm1,k_parameter3,mn_parameter3,mn_k_parameter3);
  updatemacro(bm1,k_parameter4,mn_parameter4,mn_k_parameter4);
 end
 else begin
  macroitems[mn_k_footprint]^.value:= '';
  macroitems[mn_k_footprintident]^.value:= '';
  macroitems[mn_k_footprintdescription]^.value:= '';
  macroitems[mn_k_manufacturer]^.value:= '';
  macroitems[mn_k_distributor]^.value:= '';
  macroitems[mn_k_description]^.value:= '';
  macroitems[mn_k_parameter1]^.value:= '';
  macroitems[mn_k_parameter2]^.value:= '';
  macroitems[mn_k_parameter3]^.value:= '';
  macroitems[mn_k_parameter4]^.value:= '';
 end;
 result:= fmacros.expandmacros(atext);
end;

function tmainmo.expandcomponentmacros(
                     const afield: tmsestringfield): msestring;
var
 bm1: bookmarkdataty;
 ms1: msestring;
 bo1: boolean;
begin
 stockcompdetailqu.controller.checkrefresh(); //make pending refresh
 bo1:= not sc_componentkind.isnull and 
                      compkindqu.indexlocal[0].find([sc_componentkind],bm1);
 ms1:= afield.asmsestring;
 if (ms1 = '') and bo1 then begin
  if afield = scd_description then begin
   ms1:= compkindqu.currentbmasmsestring[k_description,bm1];
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
 result:= expandcomponentmacros(ms1);
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
 if aname.dataset.state = dsinsert then begin
  asqlres.params[0].asmsestring:= aname.asmsestring;
  asqlres.refresh();
  if not asqlres.eof then begin
   showmessage('Record with this name already exists.','ERROR');
   abort();
  end;
 end;
end;

procedure tmainmo.dodeletecheck(const asqlres: tsqlresult; 
                                const aid: tmselargeintfield;
                                             const recname: msestring);
begin
 asqlres.params[0].asid:= aid.asid;
 asqlres.refresh();
 if not asqlres.eof then begin
  if asqlres.cols.count > 1 then begin
   showmessage('Record can not be deleted,'+lineend+
              'it is in use by component "'+
              asqlres.cols.colbyname('VALUE').asmsestring+','+
              asqlres.cols.colbyname('VALUE1').asmsestring+','+
              asqlres.cols.colbyname('VALUE1').asmsestring+'"','ERROR');
  end
  else begin
   showmessage('Record can not be deleted,'+lineend+
              'it is in use by '+recname+' "'+
              asqlres.cols.colbyname('NAME').asmsestring+'"','ERROR');
  end;
  abort();
 end;
end;

procedure tmainmo.deletecheck(const id: tmselargeintfield;
                                const references: array of tmselargeintfield);
var
 i1: int32;
 mstr1,mstr2: msestring;
begin
 for i1:= 0 to high(references) do begin
  with references[i1] do begin
   deletetest.active:= false;
   mstr1:= msestring(tmsesqlquery(dataset).tablename);
   mstr2:= msestring(fieldname);
   deletetest.sql.macros.itembyname('table').value.text:= mstr1;
   deletetest.sql.macros.itembyname('field').value.text:= mstr2;
   if references[i1].dataset = stockcompqu then begin
    mstr2:= '(coalesce("VALUE",'''')||'',''||coalesce(VALUE1,'''')||'+
              ''',''||coalesce(VALUE2,'''')) as NAME';
   end
   else begin
    mstr2:= 'NAME';
   end;
   deletetest.sql.macros.itembyname('fields').value.text:= mstr2;
   deletetest.params[0].asid:= id.asid;
   deletetest.active:= true;
   if not deletetest.eof then begin
    errormessage('Record can not be deleted,'+lineend+
              'it is in use by '+mstr1+' "'+deletetest.cols[0].asmsestring+'"');
    deletetest.active:= false;
    abort(); 
   end;
  end;
 end;
 deletetest.active:= false;
end;

procedure tmainmo.insertcheck(const namefield: tmsestringfield);
begin
 inserttest.active:= false;
 inserttest.sql.macros.itembyname('table').value.text:= 
                        msestring(tmsesqlquery(namefield.dataset).tablename);
 inserttest.params[0].asmsestring:= namefield.asmsestring;
 inserttest.params[1].asid:= namefield.dataset.fieldbyname('PK').asid;
 inserttest.active:= true;
 if not inserttest.eof then begin
  errormessage('Record with this name already exists.');
  inserttest.active:= false;
  abort();
 end;
 inserttest.active:= false;
end;

procedure tmainmo.namecheckev(DataSet: TDataSet);
begin
 insertcheck(tmsestringfield(dataset.fieldbyname('NAME')));
end;

procedure tmainmo.footprintdeletecheckev(DataSet: TDataSet);
begin
 deletecheck(f_pk,[sc_footprint,k_footprint]);
end;
{
procedure tmainmo.compkindupdatedataev(Sender: TObject);
begin
 if (k_designation.asmsestring = '') or 
                  (k_designation.value = k_name.curvalue) then begin
  k_designation.asmsestring:= k_name.asmsestring;
 end;
end;
}
procedure tmainmo.cmpkinddeletecheckev(DataSet: TDataSet);
begin
 deletecheck(k_pk,[sc_componentkind]);
end;

procedure tmainmo.stockcompbeforepostev(DataSet: TDataSet);
var
 bm1: bookmarkdataty;
begin
 with tmsesqlquery(dataset) do begin
  if indexlocal[1].find([sc_value,sc_value1,sc_value2,sc_footprintinfo],bm1,false,false,true) and
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

procedure tmainmo.validprojectupdateev(const sender: tcustomaction);
begin
 sender.enabled:= hasproject and (compds.recordcount > 0);
end;

procedure tmainmo.componentfootprintlistev(const sender: TObject);
var
 fna1: filenamety;
 i1,i2: int32;
 stream1: ttextstream;
 id1,id2: int64;
 bm1,bm2: bookmarkdataty;
 footprintident1: msestring;
 s1: msestring;
 p1,p2,ps1,ps2,pe: pmsestring;
begin
 if projectoptions.getfilename(fk_componentfootprint,fna1) then begin
  stream1:= ttextstream.createtransaction(fna1);
  try
   stream1.encoding:= projectoptions.fileencoding;
   stream1.usewritebuffer:= true;
   stream1.writeln('Cmp-Mod V01 Created by MSEkicadBOM V'+versiontext+
               ' date = '+formatdatetimemse('III',nowutc())+' UTC');
   i1:= high(projectoptions.libident);
   
   i2:= high(projectoptions.libalias);
   if i2 < i1 then begin
    i1:= i2;
   end;
   ps1:= pointer(projectoptions.libident);
   pe:= ps1 + i1;
   ps2:= pointer(projectoptions.libalias);
   
   for i1:= 0 to compds.recordcount - 1 do begin
    footprintident1:= '';
    id1:= compds.currentasid[c_stockitemid,i1];
    if (id1 >= 0) and stockcompqu.indexlocal[0].find([id1],[],bm1) then begin
     id1:= stockcompqu.currentbmasid[sc_footprint,bm1];
     if (id1 < 0) then begin
      id2:= stockcompqu.currentbmasid[sc_componentkind,bm1];
      if (id2 >= 0) and compkindqu.indexlocal[0].find([id2],[],bm2) then begin
       id1:= compkindqu.currentbmasid[k_footprint,bm2];
      end;
     end;
    end;
    if (id1 >= 0) and footprintqu.indexlocal[0].find([id1],[],bm1) then begin
     s1:= footprintqu.currentbmasmsestring[f_libident,bm1];
     p1:= ps1;
     p2:= ps2;
     while p1 <= pe do begin
      if s1 = p1^ then begin
       s1:= p2^;
       break;
      end;
      inc(p1);
      inc(p2);
     end;
     footprintident1:= s1 + ':'+
                        footprintqu.currentbmasmsestring[f_ident,bm1];
    end;
    if footprintident1 <> '' then begin
     stream1.writeln();
     stream1.writeln('BeginCmp');
     stream1.writeln('TimeStamp = '+
                             compds.currentasmsestring[c_timestamp,i1]+';');
     stream1.writeln('Reference = '+
                             compds.currentasmsestring[c_ref,i1]+';');
     stream1.writeln('IdModule = '+ footprintident1+';');
     stream1.writeln('EndCmp');
    end;
   end;
   stream1.writeln();
   stream1.writeln('EndListe');
  finally
   stream1.destroy();
  end;
 end;
end;

procedure tmainmo.aftercommitev(const sender: TSQLTransaction);
begin
 inc(fcommitcount);
end;

procedure tmainmo.validatenameidentev(Sender: TField);
var
 mstr1: msestring;
 identfield: tfield;
begin                      //synchronise NAME->IDENT
 identfield:= sender.dataset.fieldbyname('IDENT');
 mstr1:= identfield.asmsestring;
 if (mstr1 = '') or not varisnull(sender.buffervalue) and 
                      (msestring(sender.buffervalue) = mstr1) then begin
  identfield.asmsestring:= sender.asmsestring;
 end;
end;

procedure tmainmo.distributordeletecheckev(DataSet: TDataSet);
begin
 deletecheck(d_pk,[sc_distributor,k_distributor]);
end;

procedure tmainmo.maufaturerdeletecheckev(DataSet: TDataSet);
begin
 deletecheck(m_pk,[sc_manufacturer,k_manufacturer]);
end;

{ tprojectoptions }

procedure tprojectoptions.setreportencoding(const avalue: int32);
begin
 freportencoding:= avalue;
 if (avalue >= 0) and (avalue <= ord(high(charencodingty))) then begin
  ffileencoding:= charencodingty(avalue);
 end
 else begin
  ffileencoding:= ce_utf8;
 end;
end;

constructor tprojectoptions.create();
var
 fiki: filekindty;
begin
 for fiki:= low(ffilewarnings) to high(ffilewarnings) do begin
  ffilewarnings[fiki]:= true;
 end;
 reportencoding:= ord(ce_utf8);
end;

procedure tprojectoptions.storevalues(const asource: tmsecomponent;
               const prefix: string = '');
begin
 inherited;
 mainmo.fmodified:= true;
 mainmo.statechanged();
 mainmo.refresh();
end;

const
 fileextensions: array[filekindty] of msestring = ('cmp');
 
function tprojectoptions.getfilename(const akind: filekindty;
                                     out afile: filenamety): boolean;
begin
 result:= false;
 afile:= ffilenames[akind];
 if afile = '' then begin
  if mainmo.hasproject then begin
   afile:= mainmo.projectname+'.'+fileextensions[akind];
  end;
 end;
 if afile <> '' then begin
  result:= true;
  if ffilewarnings[akind] and findfile(afile) and 
          not askyesno('File "'+afile+'" exists.'+lineend+
       'Do you want to overwrite it?','CONFIRMATION') then begin
   result:= false;
  end;
 end;
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
