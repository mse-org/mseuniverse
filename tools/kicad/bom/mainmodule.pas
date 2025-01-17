{ MSEkicad Copyright (c) 2016-2017 by Martin Schreiber
   
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
//
// under construction
//
unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mserttistat,msestat,
 msestatfile,mseact,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,
 msegraphics,msegraphutils,msegrids,msegui,mseguiglob,mseificomp,mseificompglob,
 mseifiglob,mselistbrowser,msemenus,msestream,msestrings,msesys,sysutils,
 mseactions,mdb,msebufdataset,msedb,mselocaldataset,kicadschemaparser,
 msedatabase,msefb3connection,msqldb,msesqldb,msesqlresult,msedbdispwidgets,
 msemacros,mclasses,msedbedit,msegraphedits,mselookupbuffer,msescrollbar,
 msepython,pythonconsoleform,msepostscriptprinter,mseprinter,msepipestream,
 mseprocess,mseguiprocess,msereport,mserichstring,msesplitter,msefb3service,
 mseifidbcomp;

const
 versiontext = '0.8.2';
 defaultseparator = ';';
 defaultquotechar = '"';
 
type
 complookupstatety = (cls_ok,cls_warn,cls_error);
 variantarty = array of variant;
 getvalueseventty = function (const index: int32): variantarty of object;

 drillfilekindty = (dfk_map,dfk_excellon);
 
 fileformatty = (ff_none,
  ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
 );

 docupagekindty = (dpk_none,dpk_title,dpk_schematic,dpk_layerplot,dpk_drillmap,
                   dpk_partlist,dpk_bom);
const
 fileformatexts: array[fileformatty] of msestring = (
//ff_none,ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
  '',     'gbr',    'ps',         'svg', 'dxf', 'plt', 'pdf'
 );

 docupagekinds: array[docupagekindty] of msestring = (
//dpk_none,dpk_title,dpk_schematic,dpk_layerplot,dpk_drillmap,dpk_partlist,dpk_bom
  '','Title','Schematic','PCB Layer-Plot','Drill-Map','Partlist','BOM'
 );

type
 layerty = (la_none,
    la_f_crtyd,la_f_fab,la_f_adhes,la_f_paste,la_f_silks,la_f_mask,
    la_f_cu,
    la_in1cu,la_in2cu,la_in3cu,la_in4cu,la_in5cu,la_in6cu,
    la_in7cu,la_in8cu,la_in9cu,la_in10cu,la_in11cu,la_in12cu,
    la_in13cu,la_in14cu,la_in15cu,la_in16cu,la_in17cu,la_in18cu,
    la_in19cu,la_in20cu,la_in21cu,la_in22cu,la_in23cu,la_in24cu,
    la_in25cu,la_in26cu,la_in27cu,la_in28cu,la_in29cu,la_in30cu,
    la_b_cu,
    la_b_mask,la_b_silks,la_b_paste,la_b_adhes,la_b_fab,la_b_crtyd,
    la_edge_cuts,la_margin,la_eco1_user,la_eco2_user,la_cmts_user,la_dwgs_user
 );
 culayers = la_f_cu..la_b_cu;
 layerinfoty = record
  layer: layerty;
  color: msestring;
  refon: boolean;
  refcolor: msestring;
  valon: boolean;
  valcolor: msestring;
  invison: boolean;
  drillmarks: msestring;
 end;
 layerinfoarty = array of layerinfoty;
 layerinforecty = record
  layers: layerinfoarty;
//  drillmarks: msestring;
 end;
 
 edacolorty = (
  ec_BLACK,
  ec_DARKDARKGRAY,
  ec_DARKGRAY,
  ec_LIGHTGRAY,
  ec_WHITE,
  ec_LIGHTYELLOW,
  ec_DARKBLUE,
  ec_DARKGREEN,
  ec_DARKCYAN,
  ec_DARKRED,
  ec_DARKMAGENTA,
  ec_DARKBROWN,
  ec_BLUE,
  ec_GREEN,
  ec_CYAN,
  ec_RED,
  ec_MAGENTA,
  ec_BROWN,
  ec_LIGHTBLUE,
  ec_LIGHTGREEN,
  ec_LIGHTCYAN,
  ec_LIGHTRED,
  ec_LIGHTMAGENTA,
  ec_YELLOW,
  ec_PUREBLUE,
  ec_PUREGREEN,
  ec_PURECYAN,
  ec_PURERED,
  ec_PUREMAGENTA,
  ec_PUREYELLOW
 );

 drillmarksty = (
  dm_NO_DRILL_SHAPE,
  dm_SMALL_DRILL_SHAPE,
  dm_FULL_DRILL_SHAPE
 );
   
type
 namedinfoty = record
  name: msestring;
 end;
 infoheaderty = namedinfoty;

 plotfileinfoty = record
  filename: msestring;
  layer: layerinfoty;
  format: fileformatty;
 end;
 plotfilearty = array of plotfileinfoty;

 drillfileinfoty = record
  filename: msestring;
  layera: layerty;
  layerb: layerty;
  nonplated: boolean;
 end;
 drillfilearty = array of drillfileinfoty;

 bomfieldinfoty = record
  field: msestring;
  fieldname: msestring;
 end;
 bomfieldarty = array of bomfieldinfoty;
 
 bomfileinfoty = record
  bom: boolean;
  filename: msestring;
  fields: bomfieldarty;
 end;
 bomfilearty = array of bomfileinfoty;
  
 prodplotinfoty = record
  h: infoheaderty;
  productiondir: filenamety;
  createproductionzipfile: boolean;
  productionzipfilename: filenamety;
  productionzipdir: filenamety;
  alldrill: boolean;
  alldrillpref: msestring;
  alldrillsuff: msestring;
  alldrillnpt: boolean;
  alldrillprefnpt: msestring;
  alldrillsuffnpt: msestring;
  plotfiles: plotfilearty;
  drillfiles: drillfilearty;
  bomfiles: bomfilearty;
 end;
 pprodplotinfoty = ^prodplotinfoty;
 prodplotinfoarty = array of prodplotinfoty;

 docuplotpageinfoty = record
  layername: msestring;
 end;
 pdocuplotpageinfoty = ^docuplotpageinfoty;
 docuplotpageinfoarty = array of docuplotpageinfoty;

 docuschematicpageinfoty = record
  psfile: filenamety;
 end;
 pdocuschematicpageinfoty = ^docuschematicpageinfoty;
 docuschematicpageinfoarty = array of docuschematicpageinfoty;

 docupageinfoty = record
  pagekind: docupagekindty;
  title: msestring;
  mirrorx: boolean;
  mirrory: boolean;
  rotate90: boolean;
  rotate180: boolean;
  scale: flo64;
  shifthorz: flo64;
  shiftvert: flo64;
  text: msestring;
  layers: layerinfoarty;
  layera: layerty;
  layerb: layerty;
  nonplated: boolean;
  psfile: msestring;
  showreferences: boolean;
  showdistributors: boolean;
  deflinewidth: flo64;
  font: msestring;
  fontheight: flo64;
 end;
 docupageinfoarty = array of docupageinfoty;

 docuinfoty = record
  h: infoheaderty;
  docudir: filenamety;
  psfile: filenamety;
  pdffile: filenamety;
  pagewidth: flo64;
  pageheight: flo64;
  leftmargin: flo64;
  rightmargin: flo64;
  topmargin: flo64;
  bottommargin: flo64;
  font: msestring;
  fontheight: flo64;
  pages: docupageinfoarty;
 end;
 pdocuinfoty = ^docuinfoty;
 docuinfoarty = array of docuinfoty;
 
 tglobaloptions = class(toptions)
  private
   fusername: msestring;
   fpassword: msestring;
   fhostname: msestring;
   fdatabasename: msestring;
   fpsviewer: msestring;
   fps2pdf: msestring;
   fprodplotdefines: prodplotinfoarty;
   fprodplotnames: msestringarty;
   fdocudefines: docuinfoarty;
   fdocunames: msestringarty;
   ffbdir: msestring;
   fpython: msestring;
   procedure setprodplotdefines(const avalue: prodplotinfoarty);
   procedure setdocudefines(const avalue: docuinfoarty);
  protected
   procedure readinfoheader(const areader: tstatreader;
                                                var avalue: infoheaderty);
   procedure writeinfoheader(const awriter: tstatwriter;
                                                  const avalue: infoheaderty);
   procedure dostatread(const reader: tstatreader) override;
   procedure dostatwrite(const writer: tstatwriter) override;
  public
   constructor create();
   destructor destroy(); override;
   property password: msestring read fpassword write fpassword; //not stored
   property username: msestring read fusername write fusername; //not stored
   
   property prodplotdefines: prodplotinfoarty read fprodplotdefines 
                                                    write setprodplotdefines;
   property prodplotnames: msestringarty read fprodplotnames;
   property docudefines: docuinfoarty read fdocudefines 
                                                    write setdocudefines;
   property docunames: msestringarty read fdocunames;
   function prodplotdefinebyname(const aname: msestring): pprodplotinfoty;
                     //nil if not found
   function docudefinebyname(const aname: msestring): pdocuinfoty;
                     //nil if not found
  published
//   property filename: filenamety read ffilename write ffilename;
   property hostname: msestring read fhostname write fhostname;
   property databasename: msestring read fdatabasename write fdatabasename;
   property psviewer: msestring read fpsviewer write fpsviewer;
   property ps2pdf: msestring read fps2pdf write fps2pdf;
   property fbdir: msestring read ffbdir write ffbdir;
   property python: msestring read fpython write fpython;
 end;

 filekindty = (fk_componentfootprint,fk_board);
 
 tprojectoptions = class(toptions)
  private
   fschematics: msestringarty;
   ffilenames: array[filekindty] of msestring;
   ffilewarnings: array[filekindty] of boolean;
   ffileencoding: charencodingty;
   freportencoding: int32;
   flibident: msestringarty;
   flibalias: msestringarty;
   fproductionfiles: msestringarty;
   fdocusets: msestringarty;
   fprojectname: msestring;
   fprojectmacronames: msestringarty;
   fprojectmacrovalues: msestringarty;
   freportseparator: msestring;
   freportquotechar: msestring;
   fseparator: msechar;
   fquotechar: msechar;
   procedure setreportencoding(const avalue: int32);
   procedure setreportseparator(const avalue: msestring);
   procedure setreportquotechar(const avalue: msestring);
  public
   constructor create();
   procedure storevalues(const asource: tmsecomponent;
                               const prefix: string = '') override;
   function getfilename(const akind: filekindty; 
                                 out afile: filenamety): boolean; //true if ok
   property fileencoding: charencodingty read ffileencoding;
   property separator: msechar read fseparator;
   property quotechar: msechar read fquotechar;
  published
   property schematics: msestringarty read fschematics write fschematics;
   property compfootprint: msestring read ffilenames[fk_componentfootprint]
                                        write ffilenames[fk_componentfootprint];
   property compfootprintwarn: boolean 
                           read ffilewarnings[fk_componentfootprint]
                                     write ffilewarnings[fk_componentfootprint];
   property board: msestring read ffilenames[fk_board]
                                        write ffilenames[fk_board];
   property reportencoding: int32 read freportencoding write setreportencoding;
   property reportseparator: msestring read freportseparator 
                                              write setreportseparator;
   property reportquotechar: msestring read freportquotechar
                                              write setreportquotechar;
   property libident: msestringarty read flibident write flibident;
   property libalias: msestringarty read flibalias write flibalias;
   property productionfiles: msestringarty read fproductionfiles 
                                                  write fproductionfiles;
   property docusets: msestringarty read fdocusets write fdocusets;
   property projectname: msestring read fprojectname write fprojectname;
   property projectmacronames: msestringarty read fprojectmacronames
                                                     write fprojectmacronames;
   property projectmacrovalues: msestringarty read fprojectmacrovalues
                                                     write fprojectmacrovalues;
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
   conn: tfb3connection;
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
   deletetest: tsqlresult;
   inserttest: tsqlresult;
   c_manufacturerid: tmselargeintfield;
   c_componentkindid: tmselargeintfield;
   k_manufacturer: tmselargeintfield;
   sc_manufacturer: tmselargeintfield;
   sc_manufacturername: tmsestringfield;
   k_manufacturername: tmsestringfield;
   c_manufacturername: tmsestringfield;
   c_pk: tmselargeintfield;
   c_area: tmsefloatfield;
   f_area: tmsefloatfield;
   totarea: tifireallinkcomp;
   f_description: tmsestringfield;
   c_footprintinfo: tmsestringfield;
   prodfilesact: taction;
   python: tpythonscript;
   docusetact: taction;
   psprinter: tpostscriptprinter;
   viewerproc: tguiprocess;
   ps2pdfproc: tmseprocess;
   service: tfb3service;
   distdeletetest: tsqlresult;
   c_count: tmselongintfield;
   stockcompdistribqu: tmsesqlquery;
   compfootprintgrid: tifigridlinkcomp;
   compfootprintdso: tconnectedifidatasource;
   compfootprintqu: tifisqlresult;
   compfootprintdelete: tsqlstatement;
   compfootprintupdate: tsqlstatement;
   compfootprintinsert: tsqlresult;
   copycompfootprints: tsqlstatement;
   cfp_pk: tifiint64linkcomp;
   cfp_footprintinfo: tifistringlinkcomp;
   cfp_comment: tifistringlinkcomp;
   compkindlink: tfieldparamlink;
   cfp_footprint: tifiint64linkcomp;
   stockcomplink: tfieldparamlink;
   ckfp_footprint: tifiint64linkcomp;
   ckfp_comment: tifistringlinkcomp;
   ckfp_footprintinfo: tifistringlinkcomp;
   ckfp_pk: tifiint64linkcomp;
   compkfootprintqu: tifisqlresult;
   compkfootprintdso: tconnectedifidatasource;
   compkfootprintgrid: tifigridlinkcomp;
   nostockcompfootprints: tifibooleanlinkcomp;
   footprintlinksqu: tmsesqlquery;
   fpl_link: tmselargeintfield;
   fpl_footprint: tmselargeintfield;
   fpdeletetest: tsqlresult;
   f_library: tmselargeintfield;
   getprojectfilenew: tifiactionlinkcomp;
   c_footprintident: tmsestringfield;
   complookupstate: tifiintegerlinkcomp;
   fieldquery: tsqlresult;
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
   procedure mainstatupdateev(const sender: TObject; const filer: tstatfiler);
   procedure prodfilesev(const sender: TObject);
   procedure docusetev(const sender: TObject);
   procedure saveev(const sender: TObject);
   procedure saveasev(const sender: TObject);
   procedure serviceerrorev(const sender: tfb3service; var e: Exception;
                   var handled: Boolean);
   procedure compdetailcalcfields(DataSet: TDataSet);
   procedure compfootprintdelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
   procedure compkindpostev(const sender: TDataSet; const master: TDataSet);
   procedure compkindrefreshev(const sender: TObject);
   procedure stockcompostev(const sender: TDataSet; const master: TDataSet);
   procedure stockcomprefreshev(const sender: TObject);
   procedure compkfootprintdelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
   procedure compfootopenev(const sender: TObject);
   procedure stockcompdatachaev(Sender: TObject; Field: TField);
   procedure librarydeletecheckev(DataSet: TDataSet);
   procedure afterconnev(const sender: tmdatabase);
  private
   ffbdirbefore: msestring;
   fdisconnecting: boolean;
   fhasproject: boolean;
   fmodified: boolean;
   foldname: msestring;
   fcommitcount: card32;
   fcomponentmacros: tmacrolist;
   fprojectmacros: tmacrolist;
   fprojectfile: filenamety;
   fprojectname: msestring;
   flayernames: msestringarty;
   flayercodes: msestringarty;
   fculayernames: msestringarty;
   ffileformats: msestringarty;
   fpythonconsole: tpythonconsolefo;
   flastprojectfile: filenamety;
   fdocupagekinds: msestringarty;
   fedacolornames: msestringarty;
   fdrillmarknames: msestringarty;
   fbomfieldnames: msestringarty;
   fid: int64;
   fdeletedfootprints: int64arty;
   fdeletedkfootprints: int64arty;
//   ffootprintlink: int64;
  protected
   fcurrentfootprint: int64;
   procedure checkfirebirdenv();
   procedure statechanged();
   procedure docomp(const sender: tkicadschemaparser; var info: compinfoty);
   procedure dodeletecheck(const asqlres: tsqlresult; 
                                               const aid: tmselargeintfield;
                                               const recname: msestring);
   procedure insertcheck(const namefield: tmsestringfield);
   procedure doinsertcheck(const asqlres: tsqlresult;
                                            const aname: tmsestringfield);
   function execpy(const ascript: msestring; const params: array of msestring;
                                                 const last: boolean) : boolean;
                                     //true if ok
   procedure beginpy(const acaption: msestring);
   procedure endpy();
   procedure getlayerinfo(const aindex: int32; var ainfo: layerinfoty);
   function docudefinebyname(const aname: msestring;
                       out ainfo: docuinfoty): boolean;
                                             //false if not found
   function prodplotdefinebyname(const aname: msestring;
                       out ainfo: prodplotinfoty): boolean;
                                             //false if not found
   function getdrillfilename(const boardfile: filenamety;
                                   const layera,layerb: layerty;
                                         const nonplated: boolean): msestring;
   function getfootprintitemvalues(const index: int32): variantarty;
   function getkfootprintitemvalues(const index: int32): variantarty;
   function gettargetfootprintident(const id1: int64): msestring;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   procedure createdatabase(const ahostname: msestring;
                                        const adbname: msestring);
   procedure openproject(const afilename: filenamety; const anew: boolean);
   procedure endedit();
   procedure disconnect();
   procedure checkdbcompatibility();
   function refresh(): complookupstatety;
   function closeproject(): boolean; //true if not canceled
   function saveproject(const saveas: boolean): boolean;  //true if not canceled
   function doexit: boolean;         //true if not canceled

   procedure beginedit(const aquery: tmsesqlquery; const aid: int64);
   procedure begincomponentsedit();
   procedure begincomponentedit(const idfield: tmselargeintfield);
   procedure deletecheck(const id: tmselargeintfield;
                                 const references: array of tmselargeintfield);
   function checkvalueexist(const avalue,avalue1,avalue2: msestring): boolean;
   property projectfile: filenamety read fprojectfile write fprojectfile;
   property hasproject: boolean read fhasproject;
   property projectname: msestring read fprojectname;
   property modified: boolean read fmodified;
   function expandcomponentmacros(const atext: msestring): msestring;
   function expandcomponentmacros(const afield: tmsestringfield): msestring;
   function expandprojectmacros(const atext: msestring): msestring;
   procedure updateprojectmacros(const anames: msestringarty; 
                                             const avalues: msestringarty);
   procedure hintmacros(const atext: msestring; var info: hintinfoty);

   function getboardfile(var afilename: filenamety): boolean; //true if ok
   function plotfile(const aboard: filenamety; const aplotdir: filenamety;
                      var aplotfile: filenamety; const aformat: fileformatty;
                    const adeflinewidth: flo64;
                   const alayer: layerinforecty; const alast: boolean): boolean;
   function drillfile(const aboard: filenamety; const adrillfile: filenamety;
             const akind: drillfilekindty;
             const alayera,alayerb: layerty; 
              const anonplated: boolean; const aformat: fileformatty;
              const alast: boolean): boolean;
   function drillfiles(const aboard: filenamety; const aoutputdir: filenamety;
                  const builddrill: boolean; const buildmap: boolean;
                  const mapformat: fileformatty; const alast: boolean): boolean;
   function createzipfile(const aarchivename: filenamety;
          mainzipdir: filenamety;
          const basedir: filenamety; const afiles: array of filenamety;
          const alast : boolean): boolean;
   procedure showpsfile(const afile: filenamety; const cancontinue: boolean);
   procedure ps2pdf(const source,dest: msestring;
                                          const pagewidth,pageheight: flo64);

   procedure createdocuset(const aindex: int32);
   procedure createprodfiles(const aindex: int32);

   function getid(): int64;
   function getfootprintsfromcompkind(): boolean; //false if there are none
   
   function getpagekind(const aname: msestring): docupagekindty;
   function getfileformat(const aname: msestring): fileformatty;
   function getlayer(const aname: msestring): layerty;
   procedure getcompfield(const aname: msestring; out afield: tfield;
                                                  out akindfield: tfield);
   
   property layernames: msestringarty read flayernames;
   property layercodes: msestringarty read flayercodes;
   property edacolornames: msestringarty read fedacolornames;
   property drillmarknames: msestringarty read fdrillmarknames;
   property culayernames: msestringarty read fculayernames;
   property fileformats: msestringarty read ffileformats;
   property bomfieldnames: msestringarty read fbomfieldnames;
//   property fileformatcodes: msestringarty read ffileformatcodes;
//   property fileformatexts: msestringarty read ffileformatexts;
   property docupagekinds: msestringarty read fdocupagekinds;
 end;
 
var
 mainmo: tmainmo;
 globaloptions: tglobaloptions;
 projectoptions: tprojectoptions;

procedure errormessage(const message: msestring);
function layertoplotname(const layername: msestring): msestring;

procedure updateitems(var deleted: int64arty;
      const pk: tifiint64linkcomp;
      const deletestatement,updatestatement: tsqlstatement;
      const insertstatement: tsqlresult;
      const getvalues: getvalueseventty);
procedure refreshitems(const alink: tmselargeintfield; 
          var deleted: int64arty;
          const pk: tifiint64linkcomp; const query: tmsesqlquery;
                                 const dataso: tconnectedifidatasource);


implementation
uses
 mainmodule_mfm,msewidgets,variants,msestrmacros,msefilemacros,msemacmacros,
 mseenvmacros,msefileutils,mseformatstr,msesysutils,msedate,msereal,
 msearrayutils,docureport,docupsreppage,basereppage,mserepps,main,
 partlistreppage,bomreppage,bommodule,vendormodule,dbdata,titlereppage,
 msesysintf,msefirebird;

{ tmainmo }

type
 bomfieldsty = (bf_none,bf_count,bf_ref,bf_value,bf_value1,bf_value2,bf_kind,
                bf_footprint,bf_footprintinfo,bf_area,bf_manufacturer,
                bf_description,
                bf_parameter1,bf_parameter2,bf_parameter3,bf_parameter4,
                bf_distributor,bf_partnumber);
 componentmacronamety = (
    cmn_value,cmn_value1,cmn_value2,
    cmn_footprint,cmn_footprintident,cmn_footprintlibrary,
     cmn_footprintdescription,
    cmn_manufacturer,{cmn_distributor,}
    cmn_description,cmn_parameter1,cmn_parameter2,cmn_parameter3,
    cmn_parameter4,
    cmn_k_footprint,cmn_k_footprintident,cmn_k_footprintlibrary,
    cmn_k_footprintdescription,
    cmn_k_manufacturer,{cmn_k_distributor,}cmn_k_description,
    cmn_k_parameter1,cmn_k_parameter2,cmn_k_parameter3,cmn_k_parameter4);

const
 bomfieldnames: array[bomfieldsty] of msestring = (
 //bf_none,bf_count,bf_ref,bf_value,bf_value1,bf_value2,bf_kind,
  '',        'COUNT', 'REF', 'VALUE', 'VALUE1', 'VALUE2', 'KIND',
 //bf_footprint,bf_footprintinfo,bf_area,bf_manufacturer,bf_description,
     'FOOTPRINT', 'FOOTPRINTINFO', 'AREA', 'MANUFACTURER', 'DESCRIPTION',
 //bf_parameter1,bf_parameter2,bf_parameter3,bf_parameter4
     'PARAMETER1', 'PARAMETER2', 'PARAMETER3', 'PARAMETER4',
 //bf_distributor,bf_partnumber
     'DISTRIBUTOR', 'PARTNUMBER');
 bomfields: array[bomfieldsty] of string = (
 //bf_none,bf_count,bf_ref,bf_value,bf_value1,bf_value2,bf_kind,
  '',        'count', 'REF', 'VALUE', 'VALUE1', 'VALUE2', 'componentkindname',
 //bf_footprint,bf_footprintinfo,bf_area,bf_manufacturer,bf_description,
     'FOOTPRINT', 'FOOTPRINTINFO', 'area', 'manufacturername', 'description',
 //bf_parameter1,bf_parameter2,bf_parameter3,bf_parameter4
     'PARAMETER1', 'PARAMETER2', 'PARAMETER3', 'PARAMETER4',
 //bf_distributor,bf_partnumber
     'DISTRIBUTOR', 'PARTNUMBER');

 bomkindfields: array[bomfieldsty] of string = (
 //bf_none,bf_count,bf_ref,bf_value,bf_value1,bf_value2,bf_kind,
  '',        '',      '',    '',      '',       '',       '',
 //bf_footprint,bf_footprintinfo,bf_area,bf_manufacturer,bf_description,
     '',          '',              '',     '',             '',
 //bf_parameter1,bf_parameter2,bf_parameter3,bf_parameter4
     'PARAMETER1', 'PARAMETER2', 'PARAMETER3', 'PARAMETER4',
 //bf_distributor,bf_partnumber
     '',            '');

 bomdistribfields: array[bomfieldsty] of string = (
 //bf_none,bf_count,bf_ref,bf_value,bf_value1,bf_value2,bf_kind,
  '',        '',      '',    '',      '',       '',       '',
 //bf_footprint,bf_footprintinfo,bf_area,bf_manufacturer,bf_description,
     '',          '',              '',     '',             '',
 //bf_parameter1,bf_parameter2,bf_parameter3,bf_parameter4
     '',           '',           '',           '',
 //bf_distributor,bf_partnumber
     'NAME', 'PARTNUMBER');

 bomdetailfields = [bf_parameter1,bf_parameter2,bf_parameter3,bf_parameter4];
                            //in stockcompdetailqu
 bomdistfields = [bf_distributor,bf_partnumber];
                            //in stockcoompdistribqu

 componentmacronames: array[componentmacronamety] of msestring = (
//cmn_value,cmn_value1,cmn_value2,
     'value',  'value1',  'value2',
//cmn_footprint,cmn_footprintident,cmn_footprintlibrary,
     'footprint',  'footprintident',  'footprintlibrary',
//cmn_footprintdescription,
     'footprintdescription',
//cmn_manufacturer,cmn_distributor,
     'manufacturer', { 'distributor',}
//cmn_designation,cmn_parameter1,cmn_parameter2,cmn_parameter3,
     'description',  'parameter1',  'parameter2',  'parameter3',
//cmn_parameter4,
     'parameter4',
//cmn_k_footprint,cmn_k_footprintident,cmn_k_footprintlibrary,
     'k_footprint',  'k_footprintident',  'k_footprintlibrary',
//cmn_k_footprintdescription,
     'k_footprintdescription',
//cmn_k_manufacturer,cmn_k_distributor,cmn_k_description,
     'k_manufacturer',  {'k_distributor',}  'k_description',
//cmn_k_parameter1,cmn_k_parameter2,cmn_k_parameter3,cmn_k_parameter4);
     'k_parameter1',  'k_parameter2',  'k_parameter3',  'k_parameter4'
 );
type
 projectmacronamety = (pmn_projectname);
const
 projectmacronames: array[projectmacronamety] of msestring = (
//pmn_projectname,
     'PROJECTNAME'
 );
var
 componentmacroitems: array[componentmacronamety] of pmacroinfoty; 

procedure errormessage(const message: msestring);
begin
 showerror(message);
end;
 
const
 layernames: array[layerty] of msestring = (
//  la_none
    '',
//  la_f_crtyd,la_f_fab,la_f_adhes,la_f_paste,la_f_silks,la_f_mask,
    'F.CrtYd','F.Fab','F.Adhes','F.Paste','F.SilkS','F.Mask',
//  la_f_cu,
    'F.Cu',
//  la_in1cu,la_in2cu,la_in3cu,la_in4cu,la_in5cu,la_in6cu,
    'In1.Cu','In2.Cu','In3.Cu','In4.Cu','In5.Cu','In6.Cu',
//  la_in7cu,la_in8cu,la_in9cu,la_in10cu,la_in11cu,la_in12cu,
    'In7.Cu','In8.Cu','In9.Cu','In10.Cu','In11.Cu','In12.Cu',
//  la_in13cu,la_in14cu,la_in15cu,la_in16cu,la_in17cu,la_in18cu,
    'In13.Cu','In14.Cu','In15.Cu','In16.Cu','In17.Cu','In18.Cu',
//  la_in19cu,la_in20cu,la_in21cu,la_in22cu,la_in23cu,la_in24cu,
    'In19.Cu','In20.Cu','In21.Cu','In22.Cu','In23.Cu','In24.Cu',
//  la_in25cu,la_in26cu,la_in27cu,la_in28cu,la_in29cu,la_in30cu,
    'In25.Cu','In26.Cu','In27.Cu','In28.Cu','In29.Cu','In30.Cu',
//  la_b_cu,
    'B.Cu',
//  la_b_mask,la_b_silks,la_b_paste,la_b_adhes,la_b_fab,la_b_crtyd,
    'B.Mask','B.SilkS','B.Paste','B.Adhes','B.Fab','B.CrtYd',
//  la_edge_cuts,la_margin,la_eco1_user,la_eco2_user,la_cmts_user,la_dwgs_user
    'Edge.Cuts','Margin','Eco1.User','Eco2.User','Cmts.User','Dwgs.User'{,
//  pk_drillmap
    'Drill.Map'}
 );
 layercodes: array[layerty] of msestring = (
//  la_none,
    '',
//  la_f_crtyd,la_f_fab,la_f_adhes,la_f_paste,la_f_silks,la_f_mask,
    'F_CrtYd','F_Fab','F_Adhes','F_Paste','F_SilkS','F_Mask',
//  la_f_cu,
    'F_Cu',
//  la_in1cu,la_in2cu,la_in3cu,la_in4cu,la_in5cu,la_in6cu,
    'In1_Cu','In2_Cu','In3_Cu','In4_Cu','In5_Cu','In6_Cu',
//  la_in7cu,la_in8cu,la_in9cu,la_in10cu,la_in11cu,la_in12cu,
    'In7_Cu','In8_Cu','In9_Cu','In10_Cu','In11_Cu','In12_Cu',
//  la_in13cu,la_in14cu,la_in15cu,la_in16cu,la_in17cu,la_in18cu,
    'In13_Cu','In14_Cu','In15_Cu','In16_Cu','In17_Cu','In18_Cu',
//  la_in19cu,la_in20cu,la_in21cu,la_in22cu,la_in23cu,la_in24cu,
    'In19_Cu','In20_Cu','In21_Cu','In22_Cu','In23_Cu','In24_Cu',
//  la_in25cu,la_in26cu,la_in27cu,la_in28cu,la_in29cu,la_in30cu,
    'In25_Cu','In26_Cu','In27_Cu','In28_Cu','In29_Cu','In30_Cu',
//  la_b_cu,
    'B_Cu',
//  la_b_mask,la_b_silks,la_b_paste,la_b_adhes,la_b_fab,la_b_crtyd,
    'B_Mask','B_SilkS','B_Paste','B_Adhes','B_Fab','B_CrtYd',
//  la_edge_cuts,la_margin,la_eco1_user,la_eco2_user,la_cmts_user,la_dwgs_user
    'Edge_Cuts','Margin','Eco1_User','Eco2_User','Cmts_User','Dwgs_User'{,
//  pk_drillmap
    'Drill_Map'}
 );

 layerdrillnames: array[layerty] of msestring = (
//  la_none,
    '',
//  la_f_crtyd,la_f_fab,la_f_adhes,la_f_paste,la_f_silks,la_f_mask,
    '',        '',      '',        '',        '',        '',
//  la_f_cu,
    'front',
//  la_in1cu,la_in2cu,la_in3cu,la_in4cu,la_in5cu,la_in6cu,
    'inner1','inner2','inner3','inner4','inner5','inner6',
//  la_in7cu,la_in8cu,la_in9cu,la_in10cu,la_in11cu,la_in12cu,
    'inner7','inner8','inner9','inner10','inner11','inner12',
//  la_in13cu,la_in14cu,la_in15cu,la_in16cu,la_in17cu,la_in18cu,
    'inner13','inner14','inner15','inner16','inner17','inner18',
//  la_in19cu,la_in20cu,la_in21cu,la_in22cu,la_in23cu,la_in24cu,
    'inner19','inner20','inner21','inner22','inner23','inner24',
//  la_in25cu,la_in26cu,la_in27cu,la_in28cu,la_in29cu,la_in30cu,
    'inner25','inner26','inner27','inner28','inner29','inner30',
//  la_b_cu,
    'back',
//  la_b_mask,la_b_silks,la_b_paste,la_b_adhes,la_b_fab,la_b_crtyd,
    '',       '',        '',        '',        '',      '',
//  la_edge_cuts,la_margin,la_eco1_user,la_eco2_user,la_cmts_user,la_dwgs_user
    '',          '',       '',          '',          '',          ''{,
//  pk_drillmap
    ''}
 );

 edacolornames: array[edacolorty] of msestring = (
    'BLACK',
    'DARKDARKGRAY',
    'DARKGRAY',
    'LIGHTGRAY',
    'WHITE',
    'LIGHTYELLOW',
    'DARKBLUE',
    'DARKGREEN',
    'DARKCYAN',
    'DARKRED',
    'DARKMAGENTA',
    'DARKBROWN',
    'BLUE',
    'GREEN',
    'CYAN',
    'RED',
    'MAGENTA',
    'BROWN',
    'LIGHTBLUE',
    'LIGHTGREEN',
    'LIGHTCYAN',
    'LIGHTRED',
    'LIGHTMAGENTA',
    'YELLOW',
    'PUREBLUE',
    'PUREGREEN',
    'PURECYAN',
    'PURERED',
    'PUREMAGENTA',
    'PUREYELLOW');

 drillmarknames: array[drillmarksty] of msestring = (
  'None',
  'Small',
  'Full'
 );

const
 drillfilecodes: array[drillfilekindty] of msestring = (
 //dfk_map,  dfk_excellon
  'Drill_Map','Excellon'
 );
 fileformatnames: array[fileformatty] of msestring = (
// ff_none,ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
   '',    'Gerber','Postscript','SVG','DXF','HPGL','PDF'
 );

 fileformatcodes: array[fileformatty] of msestring = (
//ff_none, ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
   '',    'GERBER','POST','SVG','DXF','HPGL','PDF'
 );
{
 docupageenums: array[docupagekindty] of msestring = (
//dpk_none,dpk_title,dpk_schematic,dpk_layerplot,dpk_drillmap,dpk_partlist,dpk_bom
  '','title','schematic','layerplot','drillmap','partlist','bom'
 );
}
function layertoplotname(const layername: msestring): msestring;
begin
 result:= mselowercase(layername);
 replacechar1(result,'.','_');
end;

procedure refreshitems(const alink: tmselargeintfield;
             var deleted: int64arty;
             const pk: tifiint64linkcomp; const query: tmsesqlquery;
                                    const dataso: tconnectedifidatasource);
var
 i1: int32;
begin
 if not mainmo.fdisconnecting and (not query.controller.posting1 or 
                       query.controller.deleting) then begin
  deleted:= nil;
  if query.controller.copying() then begin
   with pk.c.griddata do begin
    for i1:= 0 to count-1 do begin
     items[i1]:= 0; //prepare for insert
    end;
   end;
  end
  else begin
   tifisqlresult(dataso.connection).params[0].value:= alink.value;
   dataso.refresh(500000);
  end;
 end;
end;

procedure updateitems(var deleted: int64arty;
         const pk: tifiint64linkcomp;
         const deletestatement,updatestatement: tsqlstatement;
         const insertstatement: tsqlresult;
         const getvalues: getvalueseventty);
var
 i1: int32;
begin
 for i1:= 0 to high(deleted) do begin
  deletestatement.execute([deleted[i1]]);
 end;
 deleted:= nil;
 with pk.c.griddata do begin
  for i1:= 0 to count-1 do begin
   if items[i1] = 0 then begin
    insertstatement.refresh(getvalues(i1));
    items[i1]:= insertstatement[0].asid;
   end
   else begin
    updatestatement.execute(getvalues(i1));
   end;
  end;
 end;
end;

{ tmainmo }

constructor tmainmo.create(aowner: tcomponent);
var
 ma1: componentmacronamety;
 i1: int32;
begin
 fcomponentmacros:= tmacrolist.create([mao_caseinsensitive],
   initmacros([
    initmacros(componentmacronames,[],[]),
    strmacros(),filemacros(),macmacros(),envmacros()]));
 for ma1:= low(componentmacroitems) to high(componentmacroitems) do begin
  fcomponentmacros.find(componentmacronames[ma1],
                                      componentmacroitems[ma1]);
 end;
 fprojectmacros:= tmacrolist.create([mao_caseinsensitive],[]);
 setlength(flayernames,ord(high(mainmodule.layernames)));
 for i1:= 0 to high(flayernames) do begin
  flayernames[i1]:= mainmodule.layernames[layerty(i1+1)];
 end;
// flayernames:= mainmodule.layernames;
 flayercodes:= mainmodule.layercodes;
 fedacolornames:= mainmodule.edacolornames;
 fdrillmarknames:= mainmodule.drillmarknames;
 setlength(fculayernames,ord(high(culayers))-ord(low(culayers))+1);
 for i1:= 0 to high(fculayernames) do begin
  fculayernames[i1]:= mainmodule.layernames[layerty(i1+ord(low(culayers)))];
 end;
 setlength(ffileformats,ord(high(mainmodule.fileformatnames)));
 for i1:= 0 to high(ffileformats) do begin
  ffileformats[i1]:= mainmodule.fileformatnames[fileformatty(i1+1)];
 end;
 setlength(fbomfieldnames,ord(high(mainmodule.bomfieldnames)));
 for i1:= 0 to high(fbomfieldnames) do begin
  fbomfieldnames[i1]:= mainmodule.bomfieldnames[bomfieldsty(i1+1)];
 end;
// ffileformats:= fileformatnames;
// ffileformatcodes:= mainmodule.fileformatcodes;
// ffileformatexts:= mainmodule.fileformatexts;
 setlength(fdocupagekinds,ord(high(mainmodule.docupagekinds)));
 for i1:= 0 to high(fdocupagekinds) do begin
  fdocupagekinds[i1]:= mainmodule.docupagekinds[docupagekindty(i1+1)];
 end;
 inherited;
end;

destructor tmainmo.destroy();
begin
 inherited;
 fcomponentmacros.free();
 fprojectmacros.free();
end;

procedure tmainmo.createdatabase(const ahostname: msestring;
               const adbname: msestring);
var
 username1,password1: msestring;
 s1: msestring;
 stream1: tobjectdatastream;
 stream2: tmsefilestream;
begin
 conn.connected:= false;
 s1:= globaloptions.hostname;
 globaloptions.hostname:= ahostname;
 try
  checkfirebirdenv();
  getcredentialsev(nil,username1,password1); //throws abort in case of cancel
 finally
  globaloptions.hostname:= s1;
 end;
 service.username:= stringtoutf8(username1);
 service.password:= stringtoutf8(password1);
 service.hostname:= stringtoutf8(ahostname);
 service.connected:= true;
 stream1:= tobjectdatastream.create(@dbdata.data);
 stream2:= nil;
 try
  s1:= msegettempfilename('msekicadbomdb');
  stream2:= tmsefilestream.create(s1,fm_create);
  stream2.copyfrom(stream1,stream1.size);
  freeandnil(stream2);
  service.restorestart(s1,adbname,[]);
  while service.busy() do begin
   sleep(100);
   application.processmessages();
  end;
 finally
  service.connected:= false;
  stream1.free;
  stream2.free;
  if s1 <> '' then begin
   trydeletefile(s1);
  end;
 end;
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
 if flastprojectfile <> '' then begin
  openproject(flastprojectfile,false);
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

function tmainmo.refresh(): complookupstatety;
var
 parser: tkicadschemaparser;
 stream: ttextstream;
 i1: int32;
 recno1: int32;
 rowstate1: int32;
 bm1,bm2: bookmarkdataty;
 id1,id2: int64;
 area1,f1: flo64;
 menuitem1: tmenuitem;
 s1: msestring;
 hascolor0,hascolor1: boolean;
begin
 result:= cls_ok;
 try
  application.beginwait();
  try
   with mainfo.mainmenu.menu.itembynames(['make','prodfiles']) do begin
    submenu.clear();
    for i1:= 0 to high(projectoptions.productionfiles) do begin
     menuitem1:= tmenuitem.create();
     menuitem1.action:= prodfilesact;
     menuitem1.caption:= '&'+projectoptions.productionfiles[i1];
     submenu.insert(i1,menuitem1);
    end;
    enabled:= submenu.count > 0;
   end;
   with mainfo.mainmenu.menu.itembynames(['make','docuset']) do begin
    submenu.clear();
    for i1:= 0 to high(projectoptions.docusets) do begin
     menuitem1:= tmenuitem.create();
     menuitem1.action:= docusetact;
     menuitem1.caption:= '&'+projectoptions.docusets[i1];
     submenu.insert(i1,menuitem1);
    end;
    enabled:= submenu.count > 0;
   end;
   compds.disablecontrols();
   parser:= nil;
   area1:= 0;
   hascolor0:= false;
   hascolor1:= false;
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
    
    vendormo.manufacturerqu.controller.refresh(false);
    vendormo.distributorqu.controller.refresh(false);
    vendormo.compdistribqu.active:= true;
    footprintlibqu.controller.refresh(false);
    footprintqu.controller.refresh(false);
    footprintlinksqu.controller.refresh(false);

    stockcompqu.disablecontrols();
    stockcompdetailqu.disablecontrols();
    try
     stockcompqu.controller.refresh(true);
     for i1:= 0 to compds.recordcount - 1 do begin
      compds.currentasinteger[c_count,i1]:= 1;
      if stockcompqu.indexlocal[1].find(
                     [compds.currentasmsestring[c_value,i1],
                      compds.currentasmsestring[c_value1,i1],
                      compds.currentasmsestring[c_value2,i1]],
                     [compds.currentisnull[c_value,i1],
                      compds.currentisnull[c_value1,i1],
                      compds.currentisnull[c_value2,i1]]) then begin
       id1:= sc_pk.asid;
       compds.currentasid[c_stockitemid,i1]:= id1;
       id2:= sc_componentkind.asid;
       compds.currentasid[c_componentkindid,i1]:= id2;

       s1:= compds.currentasmsestring[c_footprintinfo,i1];
       if footprintlinksqu.indexlocal[0].find([id1,s1],[],bm2) or
          not sc_componentkind.isnull and 
          not footprintlinksqu.indexlocal[0].find([id1],[]) and
                                           //no component footprints
          footprintlinksqu.indexlocal[0].find([id2,s1],[],bm2)then begin
        id1:= footprintlinksqu.currentbmasid[fpl_footprint,bm2];
        compds.currentasid[c_footprintid,i1]:= id1;
        compds.currentasmsestring[c_footprintident,i1]:= 
                                       gettargetfootprintident(id1);
        if footprintqu.indexlocal[0].find([id1],[],bm1) then begin
         f1:= footprintqu.currentbmasfloat[f_area,bm1];
         if f1 <> emptyfloat64 then begin
          compds.currentasfloat[c_area,i1]:= f1;
          area1:= area1 + f1;
         end;
        end;
       end;        
       id1:= sc_manufacturer.asid;
       if (id1 = -1) and (id2 <> -1) then begin
        id1:= compkindqu.currentbmasid[k_manufacturer,bm2];
       end;
       compds.currentasid[c_manufacturerid,i1]:= id1;
       stockcompdetailqu.params[0].asid:= sc_pk.asid; 
                            //manually because of disablecontrols
       stockcompdetailqu.controller.refresh(false);
       fcurrentfootprint:= compds.currentasid[c_footprintid,i1];
       compds.currentasmsestring[c_description,i1]:=
                                         expandcomponentmacros(scd_description);
       s1:= compds.currentasmsestring[c_footprintident,i1];
       if (s1 <> '') and 
              (s1 <> compds.currentasmsestring[c_footprint,i1]) then begin
        hascolor0:= true;
        rowstate1:= 0;
       end
       else begin
        rowstate1:= -1;
       end;
      end
      else begin
       rowstate1:= 1;
       hascolor1:= true;
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
  if hascolor1 then begin
   result:= cls_error;
  end
  else begin
   if hascolor0 then begin
    result:= cls_warn;
   end;
  end;
 except
  compds.active:= false;
  application.handleexception();
 end;
 complookupstate.c.value:= ord(result);
end;

procedure tmainmo.openproject(const afilename: filenamety; const anew: boolean);
begin
// globaloptions.filename:= afilename;
 setcurrentdirmse(filedir(afilename));
 projectstat.filename:= afilename;
 try
  if not anew then begin
   projectstat.readstat();
  end;
  fhasproject:= true;
  fprojectfile:= afilename;
  fprojectname:= filenamebase(afilename);
//  setcurrentdirmse(filedir(fprojectfile));
  flastprojectfile:= fprojectfile;
  fmodified:= false;
  updateprojectmacros(projectoptions.projectmacronames,
                                         projectoptions.projectmacrovalues);
  if not anew then begin
   refresh();
  end;
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

procedure tmainmo.disconnect();
begin
 fdisconnecting:= true;
 try
  mainmo.conn.connected:= false;
 finally
  fdisconnecting:= false;
 end;
// compkfootprintdso.active:= false;
end;

procedure tmainmo.checkdbcompatibility();

 procedure getfielddefs(const atable: msestring);
 begin
  fieldquery.sql.macros[0].value.text:= atable;
  fieldquery.active:= true;
  fieldquery.active:= false;
 end;

 function checkfield(const atable,afield,adomain: msestring): boolean; 
                                                 //true if field exists
 begin
  getfielddefs(atable);
  result:= fieldquery.fielddefs.indexof(ansistring(afield)) >= 0;
  if not result then begin
   conn.executedirect(
       'alter table "'+atable+'" add "'+afield+'" "'+adomain+'"',transwrite);
  end; //checkfield
 end;
begin
 checkfield('DOCUPAGES','DEFLINEWIDTH','FLO');
 checkfield('DOCUSETS','FONT','IDENT');
 checkfield('DOCUSETS','FONTHEIGHT','FLO');
 checkfield('DOCUPAGES','FONT','IDENT');
 checkfield('DOCUPAGES','FONTHEIGHT','FLO');
 getfielddefs('COMPONENTKINDS');
 if fieldquery.fielddefs.find('NAME').size <> 40 then begin
  conn.executedirect(
  'ALTER TABLE COMPONENTKINDS DROP CONSTRAINT UNQ_COMPONENTKINDS_0',transwrite);
  conn.executedirect(
  'ALTER TABLE DISTRIBUTORS DROP CONSTRAINT UNQ_DISTRIBUTORS_0',transwrite);
  conn.executedirect(
  'ALTER TABLE MANUFACTURERS DROP CONSTRAINT UNQ_MANUFACTURERS_0',transwrite);
  conn.executedirect(
  'ALTER TABLE FOOTPRINTLIBS DROP CONSTRAINT UNQ_FOOTPRINTLIBS_0',transwrite);
  conn.executedirect(
  'ALTER TABLE FOOTPRINTS DROP CONSTRAINT UNQ_FOOTPRINTS_0',transwrite);
  conn.executedirect(
  'ALTER DOMAIN NAME TYPE varchar(40)',transwrite);
 end;
 transwrite.commit();
end;

procedure tmainmo.saveupdateev(const sender: tcustomaction);
begin
 sender.enabled:= modified;
end;

procedure tmainmo.statechanged();
begin
 updateprojectstate.controller.execute()
end;

function tmainmo.saveproject(const saveas: boolean): boolean;
var
 s1: msestring;
begin
 result:= false;
 if fmodified or saveas then begin
  if (fprojectfile = '') or saveas then begin
   s1:= fprojectfile;
   fprojectfile:= '';
   getprojectfilesave.controller.execute();
   if saveas and (fprojectfile = '') then begin
    fprojectfile:= s1;
    exit;
   end;
  end;
  if fprojectfile <> '' then begin
   projectstat.filename:= fprojectfile;
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
    if not saveproject(false) then begin
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
 fprojectfile:= '';
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
 beginedit(stockcompqu,-1);
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

procedure tmainmo.beginedit(const aquery: tmsesqlquery;
                                                 const aid: int64);
begin
 vendormo.manufacturerqu.active:= true;
 vendormo.distributorqu.active:= true;
 footprintlibqu.active:= true;
 compkindqu.active:= true;
 footprintqu.active:= true;
 stockcompdetailqu.active:= true;
 stockcompqu.active:= true;
 aquery.active:= true;
 fcurrentfootprint:= c_footprintid.asid;
 if aid <> -1 then begin
  aquery.indexlocal[0].find([aid],[]);
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
 beginedit(stockcompqu,-1);
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
                  const componentmacro,kindmacro: componentmacronamety);
 var
  ms1: msestring;
 begin
  ms1:= tmsesqlquery(afield.dataset).currentbmasmsestring[afield,abm];
  componentmacroitems[kindmacro]^.value:= ms1;
  if componentmacroitems[componentmacro]^.value = '' then begin
   componentmacroitems[componentmacro]^.value:= ms1;
  end;
 end; //updatemacro

var
 bm1,bm2: bookmarkdataty;
 hascomponentkind1: boolean;

begin
 result:= '';
 stockcompdetailqu.controller.checkrefresh(); //make pending refresh
 hascomponentkind1:= not sc_componentkind.isnull and 
                      compkindqu.indexlocal[0].find([sc_componentkind],bm1);
 componentmacroitems[cmn_value]^.value:= sc_value.asmsestring;
 componentmacroitems[cmn_value1]^.value:= sc_value1.asmsestring;
 componentmacroitems[cmn_value2]^.value:= sc_value2.asmsestring;

 if footprintqu.indexlocal[0].find([fcurrentfootprint],[],bm2) then begin
  componentmacroitems[cmn_footprint]^.value:= 
                     footprintqu.currentbmasmsestring[f_name,bm2];
  componentmacroitems[cmn_footprintident]^.value:= 
                     footprintqu.currentbmasmsestring[f_ident,bm2];
  componentmacroitems[cmn_footprintlibrary]^.value:= 
                     footprintqu.currentbmasmsestring[f_libname,bm2];
  componentmacroitems[cmn_footprintdescription]^.value:= 
                     footprintqu.currentbmasmsestring[f_description,bm2];
 end
 else begin
  componentmacroitems[cmn_footprint]^.value:= '';
  componentmacroitems[cmn_footprintident]^.value:= '';
  componentmacroitems[cmn_footprintlibrary]^.value:= '';
  componentmacroitems[cmn_footprintdescription]^.value:= '';
 end;
 componentmacroitems[cmn_manufacturer]^.value:= 
                                    sc_manufacturername.asmsestring;
{
 componentmacroitems[cmn_distributor]^.value:= 
                                     sc_distributorname.asmsestring;
}
 componentmacroitems[cmn_description]^.value:= 
                                     scd_description.asmsestring;
 componentmacroitems[cmn_parameter1]^.value:= scd_parameter1.asmsestring;
 componentmacroitems[cmn_parameter2]^.value:= scd_parameter2.asmsestring;
 componentmacroitems[cmn_parameter3]^.value:= scd_parameter3.asmsestring;
 componentmacroitems[cmn_parameter4]^.value:= scd_parameter4.asmsestring;

 if hascomponentkind1 then begin 
 {
  if footprintqu.indexlocal[0].find(
            [compkindqu.currentbmasid[c_footprintid,bm1]],[],bm2) then begin
   updatemacro(bm2,f_name,cmn_footprint,cmn_k_footprint);
   updatemacro(bm2,f_ident,cmn_footprintident,cmn_k_footprintident);
   updatemacro(bm2,f_libname,cmn_footprintlibrary,cmn_k_footprintlibrary);
   updatemacro(bm2,f_description,cmn_footprintdescription,
                                              cmn_k_footprintdescription);
  end
  else begin
   componentmacroitems[cmn_k_footprint]^.value:= '';
   componentmacroitems[cmn_k_footprintident]^.value:= '';
   componentmacroitems[cmn_k_footprintlibrary]^.value:= '';
   componentmacroitems[cmn_k_footprintdescription]^.value:= '';
  end;
  }
  updatemacro(bm1,k_manufacturername,cmn_manufacturer,cmn_k_manufacturer);
//  updatemacro(bm1,k_distributorname,cmn_distributor,cmn_k_distributor);
  updatemacro(bm1,k_description,cmn_description,cmn_k_description);
  updatemacro(bm1,k_parameter1,cmn_parameter1,cmn_k_parameter1);
  updatemacro(bm1,k_parameter2,cmn_parameter2,cmn_k_parameter2);
  updatemacro(bm1,k_parameter3,cmn_parameter3,cmn_k_parameter3);
  updatemacro(bm1,k_parameter4,cmn_parameter4,cmn_k_parameter4);
 end
 else begin
//  componentmacroitems[cmn_k_footprint]^.value:= '';
//  componentmacroitems[cmn_k_footprintident]^.value:= '';
//  componentmacroitems[cmn_k_footprintdescription]^.value:= '';
  componentmacroitems[cmn_k_manufacturer]^.value:= '';
//  componentmacroitems[cmn_k_distributor]^.value:= '';
  componentmacroitems[cmn_k_description]^.value:= '';
  componentmacroitems[cmn_k_parameter1]^.value:= '';
  componentmacroitems[cmn_k_parameter2]^.value:= '';
  componentmacroitems[cmn_k_parameter3]^.value:= '';
  componentmacroitems[cmn_k_parameter4]^.value:= '';
 end;
 result:= fcomponentmacros.expandmacros(atext);
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

function tmainmo.expandprojectmacros(const atext: msestring): msestring;
begin
 result:= fprojectmacros.expandmacros(atext);
end;

procedure tmainmo.updateprojectmacros(const anames: msestringarty; 
                                                  const avalues: msestringarty);
begin
 fprojectmacros.clear();
 fprojectmacros.add(initmacros([
                  strmacros(),filemacros(),macmacros(),envmacros(),          
                                  initmacros(projectmacronames,[],[])]));
 fprojectmacros.add(anames,avalues,[]);
 with fprojectmacros.itembyname(projectmacronames[pmn_projectname])^ do begin
  value:= projectoptions.projectname;
  if value = '' then begin
   value:= self.projectname;
  end;
 end;
end;

procedure tmainmo.hintmacros(const atext: msestring; var info: hintinfoty);
begin
 info.caption:= expandprojectmacros(atext);
 include(info.flags,hfl_show); //hint empty text
end;

procedure tmainmo.openprojectev(const sender: TObject);
begin
 if closeproject() then begin
  getprojectfileopen.controller.execute();
  if fprojectfile <> '' then begin
   openproject(fprojectfile,false);
   statechanged();
  end;
 end;
end;

procedure tmainmo.newprojectev(const sender: TObject);
begin
 if closeproject() then begin
  getprojectfilenew.controller.execute();
  if fprojectfile <> '' then begin
   openproject(fprojectfile,true);
   projectsettingsact.execute(true); //do not check enabled
  end;
 end;
end;

procedure tmainmo.closeprojectev(const sender: TObject);
begin
 closeproject();
 flastprojectfile:= '';
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
 if globaloptions.hostname = '' then begin
  ausername:= '';
  apassword:= '';
 end
 else begin
  getdbcredentials.controller.execute;
  ausername:= globaloptions.username;
  apassword:= globaloptions.password;
 end;
 globaloptions.fpassword:= '';
end;

procedure tmainmo.checkfirebirdenv();
var
 s1: msestring;
begin
{$ifndef mswindows}
 if (globaloptions.hostname = '') and 
                             not sys_getenv('FIREBIRD_LOCK',s1) then begin
  s1:= sys_gettempdir()+'msekicadbom_lock_'+sys_getusername();
  createdirpath(s1);
  sys_setenv('FIREBIRD_LOCK',s1);  
 end;
{$endif}
 if (globaloptions.fbdir <> ffbdirbefore) then begin
  ffbdirbefore:= globaloptions.fbdir;
  conn.connected:= false; //to be sure, release fbapi
  releasefirebird();
  initializefirebird([]);
  sys_setenv('FIREBIRD',tosysfilepath(globaloptions.fbdir));
 end;
end;

procedure tmainmo.beforeconnectev(const sender: tmdatabase);
begin
 checkfirebirdenv();
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

function tmainmo.execpy(const ascript: msestring;
               const params: array of msestring;
               const last: boolean): boolean;
var
 i1: int32;
begin
 if globaloptions.python = '' then begin
  showmessage('Python compiler not defined in ''Global options''','ERROR');
  result:= false;
  exit;
 end;
 python.filename:= globaloptions.python;
 python.params.count:= high(params) + 2;
 python.params[0]:= '-';
 for i1:= 0 to high(params) do begin
  python.params[i1+1]:= params[i1];
 end;
 python.scripts.itembyname(ascript).execute(0);
 fpythonconsole.show(last);
 result:= python.exitcode = 0;
end;

procedure tmainmo.beginpy(const acaption: msestring);
begin
 fpythonconsole:= tpythonconsolefo.create(nil);
 fpythonconsole.caption:= acaption;
end;

procedure tmainmo.endpy();
begin
 freeandnil(fpythonconsole);
end;

procedure tmainmo.dodeletecheck(const asqlres: tsqlresult; 
                                const aid: tmselargeintfield;
                                             const recname: msestring);
begin
 asqlres.params[0].asid:= aid.asid;
 asqlres.refresh();
 if not asqlres.eof then begin
  if asqlres.datacols.count > 1 then begin
   showmessage('Record can not be deleted,'+lineend+
              'it is in use by component "'+
              asqlres.datacols.colbyname('VALUE').asmsestring+','+
              asqlres.datacols.colbyname('VALUE1').asmsestring+','+
              asqlres.datacols.colbyname('VALUE1').asmsestring+'"','ERROR');
  end
  else begin
   showmessage('Record can not be deleted,'+lineend+
              'it is in use by '+recname+' "'+
              asqlres.datacols.colbyname('NAME').asmsestring+'"','ERROR');
  end;
  abort();
 end;
end;

procedure tmainmo.deletecheck(const id: tmselargeintfield;
                      const references: array of tmselargeintfield);
var
 i1: int32;
 mstr1,mstr2: msestring;
 deltest: tsqlresult;
begin
 if id.dataset = vendormo.distributorqu then begin
  deltest:= distdeletetest;
 end
 else begin
  if id.dataset = footprintqu then begin
   deltest:= fpdeletetest;
  end
  else begin
   deltest:= deletetest;
  end;
 end;
 for i1:= 0 to high(references) do begin
  with references[i1] do begin
   deltest.active:= false;
   mstr1:= msestring(tmsesqlquery(dataset).tablename);
   mstr2:= 'b.'+msestring(fieldname);
   deltest.sql.macros.itembyname('table').value.text:= mstr1;
   deltest.sql.macros.itembyname('field').value.text:= mstr2;
   if references[i1].dataset = stockcompqu then begin
    mstr2:= '(coalesce(b."VALUE",'''')||'',''||coalesce(b.VALUE1,'''')||'+
              ''',''||coalesce(b.VALUE2,'''')) as NAME';
   end
   else begin
    mstr2:= 'b.NAME';
   end;
   deltest.sql.macros.itembyname('fields').value.text:= mstr2;
   deltest.params[0].asid:= id.asid;
   deltest.active:= true;
   if not deltest.eof then begin
    if deltest = fpdeletetest then begin
     if not deltest.datacols[1].isnull then begin
      mstr1:= 'component kind';
      compkindqu.indexlocal[0].find([deltest.datacols[1].asid],[]);
     end
     else begin
      stockcompqu.indexlocal[0].find([deltest.datacols[2].asid],[]);
      mstr1:= 'component';
     end;
    end
    else begin
     tmsesqlquery(dataset).indexlocal[0].find([deltest.datacols[1].asid],[]);
    end;
    errormessage('Record can not be deleted,'+lineend+
              'it is in use by '+mstr1+' "'+
                             deltest.datacols[0].asmsestring+'"'+ lineend+
              'and '+inttostrmse(deltest.countrest-1)+' other items');
    deltest.active:= false;
    abort(); 
   end;
  end;
 end;
 deltest.active:= false;
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
 deletecheck(f_pk,[fpl_footprint]);
end;

procedure tmainmo.librarydeletecheckev(DataSet: TDataSet);
begin
 deletecheck(fl_pk,[f_library]);
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
begin
{
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
}
end;

procedure tmainmo.validprojectupdateev(const sender: tcustomaction);
begin
 sender.enabled:= hasproject and (compds.recordcount > 0);
end;

function tmainmo.gettargetfootprintident(const id1: int64): msestring;
var
 s1: msestring;
 p1,p2,pe: pmsestring;
 i1,i2: int32;
 bm1: bookmarkdataty;
begin
 result:= '';
 if (id1 <> -1) and footprintqu.indexlocal[0].find([id1],[],bm1) then begin
  s1:= footprintqu.currentbmasmsestring[f_libident,bm1];
  i1:= length(projectoptions.libident);
  
  i2:= length(projectoptions.libalias);
  if i2 < i1 then begin
   i1:= i2;
  end;
  p1:= pointer(projectoptions.libident);
  pe:= p1 + i1;
  p2:= pointer(projectoptions.libalias);
  while p1 < pe do begin
   if s1 = p1^ then begin
    s1:= p2^;
    break;
   end;
   inc(p1);
   inc(p2);
  end;
  result:= s1 + ':'+footprintqu.currentbmasmsestring[f_ident,bm1];
 end;
end;

procedure tmainmo.componentfootprintlistev(const sender: TObject);
var
 fna1: filenamety;
 i1: int32;
 stream1: ttextstream;
 footprintident1: msestring;
begin
 if projectoptions.getfilename(fk_componentfootprint,fna1) then begin
  stream1:= ttextstream.createtransaction(fna1);
  try
   stream1.encoding:= projectoptions.fileencoding;
   stream1.usewritebuffer:= true;
   stream1.writeln('Cmp-Mod V01 Created by MSEkicadBOM V'+versiontext+
               ' date = '+formatdatetimemse('III',nowutc())+' UTC');
   
   for i1:= 0 to compds.recordcount - 1 do begin
    footprintident1:= 
               gettargetfootprintident(compds.currentasid[c_footprintid,i1]);
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

procedure tmainmo.mainstatupdateev(const sender: TObject;
               const filer: tstatfiler);
begin
 filer.updatevalue('projectfile',flastprojectfile);
end;

function tmainmo.getboardfile(var afilename: filenamety): boolean;
begin
 result:= false;
 if projectoptions.board = '' then begin
  errormessage('Boardfile not defined in projectoptions');
  exit;
 end;
 afilename:= tosysfilepath(filepath(expandprojectmacros(projectoptions.board)));
 result:= true;
end;

function tmainmo.plotfile(const aboard: filenamety; const aplotdir: filenamety;
                      var aplotfile: filenamety; const aformat: fileformatty;
                      const adeflinewidth: flo64;
                 const alayer: layerinforecty; const alast: boolean): boolean;
var
 dir1: filenamety;
 d1,n1,s1: filenamety;
 s2,s3,s4,s5,s6,s7,s8,s9: msestring;
 i1: int32;
begin
 if alayer.layers = nil then begin
  exit;
 end;
 if aplotfile <> '' then begin
  splitfilepath(aplotfile,d1,n1);
  if not isrelativepath(d1) then begin
   dir1:= d1;
  end
  else begin
   dir1:= filepath(aplotdir,d1,fk_dir);
  end;
 end
 else begin
  dir1:= filepath(aplotdir,fk_dir);
 end;
 s2:= '';
 s3:= '';
 s4:= '';
 s5:= '';
 s6:= '';
 s7:= '';
 s8:= '';
 s9:= '';
 for i1:= 0 to high(alayer.layers) do begin
  with alayer.layers[i1] do begin
   s2:= s2+mainmodule.layercodes[layer]+',';
   s3:= s3+color+',';
   s4:= s4+pyboolstrings[refon]+',';
   s5:= s5+refcolor+',';
   s6:= s6+pyboolstrings[valon]+',';
   s7:= s7+valcolor+',';
   s8:= s8+pyboolstrings[invison]+',';
   s9:= s9+drillmarks+',';
  end;
 end;
 setlength(s2,length(s2)-1); //remove last comma
 setlength(s3,length(s3)-1); //remove last comma
 setlength(s4,length(s4)-1); //remove last comma
 setlength(s5,length(s5)-1); //remove last comma
 setlength(s6,length(s6)-1); //remove last comma
 setlength(s7,length(s7)-1); //remove last comma
 setlength(s8,length(s8)-1); //remove last comma
 setlength(s9,length(s9)-1); //remove last comma
 with alayer do begin
  result:= execpy('plotfile',
      [aboard,tosysfilepath(dir1),mainmodule.fileformatcodes[aformat],
                  realtytostrmse(adeflinewidth,true),
                  s2,s3,s4,s5,s6,s7,s8,s9],alast);
 end;
 s1:= filenamebase(aboard)+'-'+mainmodule.layercodes[alayer.layers[0].layer]+'.'+
                                       mainmodule.fileformatexts[aformat];
 if n1 <> '' then begin
  aplotfile:= dir1+n1;
  if not hasfileext(aplotfile) then begin
   aplotfile:= aplotfile+'.'+mainmodule.fileformatexts[aformat];
  end;
  renamefile(dir1+s1,aplotfile);
 end
 else begin
  aplotfile:= dir1+s1;
 end;
end;

function tmainmo.drillfile(const aboard: filenamety; const adrillfile: filenamety;
             const akind: drillfilekindty;
             const alayera,alayerb: layerty; 
              const anonplated: boolean; const aformat: fileformatty;
              const alast: boolean): boolean;
begin
 result:= execpy('drillfile',
   [aboard,tosysfilepath(adrillfile),mainmodule.drillfilecodes[akind],
    mainmodule.layercodes[alayera],mainmodule.layercodes[alayerb],
                              pyboolean(anonplated),
                                   mainmodule.fileformatcodes[aformat]],alast);
end;

function tmainmo.drillfiles(const aboard: filenamety;
               const aoutputdir: filenamety; const builddrill: boolean;
               const buildmap: boolean; const mapformat: fileformatty; 
                                              const alast: boolean): boolean;
begin
 result:= execpy('drillfiles',
   [aboard,tosysfilepath(aoutputdir),pyboolean(builddrill),
                                 pyboolean(buildmap),
                                 mainmodule.fileformatcodes[mapformat]],alast);
end;

function tmainmo.createzipfile(const aarchivename: filenamety;
          mainzipdir: filenamety;
          const basedir: filenamety; const afiles: array of filenamety;
          const alast : boolean): boolean;
var
 i1: int32;
 ar1: msestringarty;
 base1,s1: filenamety;
begin
 result:= false;
 mainzipdir:= tosysfilepath(filepath(mainzipdir,fk_dir,true));
 ar1:= nil; //compiler warning
 setlength(ar1,1+2*length(afiles));
 ar1[0]:= tosysfilepath(filepath(aarchivename));
 base1:= filepath(basedir);
 for i1:= 0 to high(afiles) do begin
  ar1[i1*2+1]:= tosysfilepath(filepath(afiles[i1]));
  s1:= relativepath(tomsefilepath(afiles[i1]),base1);
  if msestartsstr('..',s1) then begin
   fpythonconsole.writeln(
     '******* Zip error: File destination not in archive: "'+s1+'"');
   fpythonconsole.writeln('Press Enter');
   fpythonconsole.show(alast);
   exit;
  end;
  ar1[i1*2+2]:= mainzipdir+s1;
 end;
 execpy('createzip',ar1,alast); //zipfile,zipdir,{file}
 result:= true;
end;

function tmainmo.getpagekind(const aname: msestring): docupagekindty;
var
 pk1: docupagekindty;
begin
 result:= dpk_none;
 for pk1:= succ(dpk_none) to high(docupagekindty) do begin
  if aname = mainmodule.docupagekinds[pk1] then begin
   result:= pk1;
   break;
  end;
 end;
end;

function tmainmo.getfileformat(const aname: msestring): fileformatty;
var
 ff1: fileformatty;
begin
 result:= ff_none;
 for ff1:= succ(ff_none) to high(fileformatty) do begin
  if aname = mainmodule.fileformatnames[ff1] then begin
   result:= ff1;
   break;
  end;
 end;
end;

function tmainmo.getlayer(const aname: msestring): layerty;
var
 la1: layerty;
begin
 result:= la_none;
 for la1:= succ(la_none) to high(layerty) do begin
  if aname = mainmodule.layernames[la1] then begin
   result:= la1;
   break;
  end;
 end;
end;

procedure tmainmo.getcompfield(const aname: msestring; out afield: tfield;
                                                  out akindfield: tfield);
var
 f1: bomfieldsty;
begin
 afield:= nil;
 akindfield:= nil;
 for f1:= succ(bf_none) to high(bomfieldsty) do begin
  if aname = mainmodule.bomfieldnames[f1] then begin
   if f1 in bomdetailfields then begin
    afield:= stockcompdetailqu.fieldbyname(bomfields[f1]);
    if bomkindfields[f1] <> '' then begin
     akindfield:= compkindqu.fieldbyname(bomkindfields[f1]);
    end;
   end
   else begin
    if f1 in bomdistfields then begin
     afield:= stockcompdistribqu.fieldbyname(bomdistribfields[f1]);
    end
    else begin
     afield:= compds.fieldbyname(bomfields[f1]);
    end;
   end;
   break;
  end;
 end;
 
end;

procedure tmainmo.getlayerinfo(const aindex: int32; var ainfo: layerinfoty);
begin
 with ainfo,bommo do begin
  layer:= getlayer(pli_layer.c.griddata[aindex]);
  color:= pli_color.c.griddata[aindex];
  refon:= pli_refon.c.griddata[aindex];
  refcolor:= pli_refcolor.c.griddata[aindex];
  valon:= pli_valon.c.griddata[aindex];
  valcolor:= pli_valcolor.c.griddata[aindex];
  invison:= pli_invison.c.griddata[aindex];
  drillmarks:= pli_drillmarks.c.griddata[aindex];
  if drillmarks = '' then begin
   drillmarks:= mainmodule.drillmarknames[dm_no_drill_shape];
  end;
 end;
end;

function tmainmo.docudefinebyname(const aname: msestring;
                                    out ainfo: docuinfoty): boolean;
const
 deffontheight = 10;
 ppmm = 3;
var
 i1,i2: int32;
begin
 with ainfo,bommo do begin
  docusetqu.controller.refresh();
  result:= docusetqu.indexlocal[1].find([aname],[]);
  if result then begin
   docudir:= expandprojectmacros(ds_docudir.asmsestring);
   psfile:= expandprojectmacros(ds_psfile.asmsestring);
   pdffile:= expandprojectmacros(ds_pdffile.asmsestring);
   pagewidth:= ds_width.asfloat;
   pageheight:= ds_height.asfloat ;
   leftmargin:= ds_margleft.asfloat;
   rightmargin:= ds_margright.asfloat;
   topmargin:= ds_margtop.asfloat;
   bottommargin:= ds_margbottom.asfloat;
   font:= ds_font.asmsestring;
   fontheight:= ds_fontheight.asfloat;
   if fontheight = emptyreal then begin
    fontheight:= deffontheight;
   end
   else begin
    fontheight:= fontheight*ppmm;
   end;
   docupagedso.refresh();
   setlength(pages,dpg_pk.c.datalist.count);
   for i1:= 0 to high(pages) do begin
    pageitempkpar.param.value:= dpg_pk.c.griddata[i1];
    pageitemqu.controller.refresh();
    with pages[i1] do begin
     pagekind:= getpagekind(pi_kind.asmsestring);
     title:= expandprojectmacros(pi_title.asmsestring);
     mirrorx:= pi_mirrorhorz.asboolean;
     mirrory:= pi_mirrorvert.asboolean;
     rotate90:= pi_rotate90.asboolean;
     rotate180:= pi_rotate180.asboolean;
     scale:= pi_scale.asfloat;
     shifthorz:= pi_shifthorz.asfloat;
     shiftvert:= pi_shiftvert.asfloat;
     font:= pi_font.asmsestring;
     fontheight:= pi_fontheight.asfloat;
     if fontheight <> emptyreal then begin
      fontheight:= fontheight*ppmm;
     end;
     text:= expandprojectmacros(pi_text.asmsestring);
     layera:= getlayer(pi_layera.asmsestring);
     layerb:= getlayer(pi_layerb.asmsestring);
     nonplated:= pi_npt.asboolean;
     psfile:= expandprojectmacros(pi_filename.asmsestring);
     showreferences:= pi_showref.asboolean;
     showdistributors:= pi_showdist.asboolean;
     deflinewidth:= pi_deflinewidth.asfloat;
     plotitemdso.refresh();
     setlength(layers,pli_pk.c.griddata.count);
     for i2:= 0 to high(layers) do begin
      getlayerinfo(i2,layers[i2]);
     end;
    end;
   end;
   plotitemdso.active:= false;
   pageitemqu.active:= false;
   docusetqu.active:= false;
   docupagedso.active:= false;
  end;
 end;
end;

function tmainmo.prodplotdefinebyname(const aname: msestring;
               out ainfo: prodplotinfoty): boolean;
var
 i1,i2: int32;
begin
 with ainfo,bommo do begin
  prodfilestackqu.controller.refresh();
  result:= prodfilestackqu.indexlocal[1].find([aname],[]);
  if result then begin
   bommo.plotitemdso.active:= true;
   bommo.drillitemdso.active:= true;
   bommo.bomitemdso.active:= true;
   productiondir:= expandprojectmacros(pf_outputdir.asmsestring);
   createproductionzipfile:= pf_createzip.asboolean;
   productionzipfilename:= expandprojectmacros(pf_zipfile.asmsestring);
   productionzipdir:= expandprojectmacros(pf_zipmaindir.asmsestring);
   alldrill:= pf_alldrill.asboolean;
   alldrillpref:= expandprojectmacros(pf_alldrillpref.asmsestring);
   alldrillsuff:= expandprojectmacros(pf_alldrillsuff.asmsestring);
   alldrillnpt:= pf_alldrillnpt.asboolean;
   alldrillprefnpt:= expandprojectmacros(pf_alldrillprefnpt.asmsestring);
   alldrillsuffnpt:= expandprojectmacros(pf_alldrillsuffnpt.asmsestring);
   
   setlength(plotfiles,pli_pk.c.griddata.count);
   for i1:= 0 to high(plotfiles) do begin
    with plotfiles[i1] do begin
     filename:= expandprojectmacros(pli_filename.c.griddata[i1]);
     getlayerinfo(i1,layer);
     format:= getfileformat(pli_format.c.griddata[i1]);
    end;
   end;
   setlength(drillfiles,dri_pk.c.griddata.count);
   for i1:= 0 to high(drillfiles) do begin
    with drillfiles[i1] do begin
     filename:= expandprojectmacros(dri_filename.c.griddata[i1]);
     layera:= getlayer(dri_layera.c.griddata[i1]);
     layerb:= getlayer(dri_layerb.c.griddata[i1]);
     nonplated:= dri_npt.c.griddata[i1];
    end;
   end;
   setlength(bomfiles,bom_pk.c.griddata.count);
   for i1:= 0 to high(bomfiles) do begin
    with bomfiles[i1] do begin
     bom:= bom_bom.c.griddata[i1];
     filename:= expandprojectmacros(bom_filename.c.griddata[i1]);
     bomfieldqu.params[0].value:= bom_pk.c.griddata[i1];
     bomfielddso.refresh();
     setlength(fields,bof_pk.c.griddata.count);
     for i2:= 0 to high(fields) do begin
      with fields[i2] do begin
       field:= bof_field.c.griddata[i2];
       fieldname:= bof_fieldname.c.griddata[i2];
      end;
     end;
    end;
   end;
   bommo.plotitemdso.active:= false;
   bommo.drillitemdso.active:= false;
   bommo.bomitemdso.active:= false;
  end;
 end;
end;

function tmainmo.getid(): int64;
begin
 dec(fid);
 result:= fid;
end;

function tmainmo.getfootprintsfromcompkind(): boolean;
begin
 compkfootprintqu.params[0].value:= sc_componentkind.asid;
 compkfootprintdso.refresh();
 result:= ckfp_pk.c.griddata.count > 0;
 cfp_pk.c.griddata.assign(ckfp_pk.c.griddata);
 cfp_footprint.c.griddata.assign(ckfp_footprint.c.griddata);
 cfp_footprintinfo.c.griddata.assign(ckfp_footprintinfo.c.griddata);
 cfp_comment.c.griddata.assign(ckfp_comment.c.griddata);
end;

procedure tmainmo.prodfilesev(const sender: TObject);
begin
 createprodfiles(tmenuitem(sender).index);
end;

procedure tmainmo.showpsfile(const afile: filenamety; 
                                           const cancontinue: boolean);
var
 s1: msestring;
begin
 s1:= globaloptions.psviewer;
 if s1 = '' then begin
  errormessage('Postscript viewer not defined in global settings.');
 end
 else begin
  viewerproc.filename:= s1;
  viewerproc.parameter:= quotefilename(tosysfilepath(afile));
  viewerproc.cancontinue:= cancontinue;
  viewerproc.active:= true;
  if not application.waitcanceled and (viewerproc.exitcode <> 0) then begin
   showerror('Global settings Postscript viewer "'+s1+'": error '+
                             inttostrmse(viewerproc.exitcode));
  end;
 end;
end;

procedure tmainmo.ps2pdf(const source: msestring; const dest: msestring;
                                          const pagewidth,pageheight: flo64);
{$ifdef mswindows}
var
 s1: msestring;
{$endif}
begin
 if globaloptions.ps2pdf = '' then begin
  errormessage('ps2pdf program not defined in global settings.');
 end
 else begin
 {$ifdef mswindows}
  sys_getenv('PATH',s1);
  s1:= s1+';'+tosysfilepath(filepath(filedir(globaloptions.ps2pdf)+'/../bin'));
  ps2pdfproc.envvars.clear();
  ps2pdfproc.envvars.add('PATH='+s1);
 {$endif}
  createdirpath(filedir(filepath(dest)));
  ps2pdfproc.filename:= globaloptions.ps2pdf;
  ps2pdfproc.params.count:= 3;
  ps2pdfproc.params[0]:= '-g'+
                   inttostrmse(round(pagewidth*mmtoprintscale*10))+'x'+
                   inttostrmse(round(pageheight*mmtoprintscale*10));
  ps2pdfproc.params[1]:= tosysfilepath(source);
  ps2pdfproc.params[2]:= tosysfilepath(dest);
  ps2pdfproc.active:= true;
  ps2pdfproc.waitforprocess();
 end;
end;

function tmainmo.getdrillfilename(const boardfile: filenamety;
                                       const layera,layerb: layerty;
                                         const nonplated: boolean): msestring;
var
 la1,la2: layerty;
 s1: msestring;
begin
 s1:= '';
 if layera < layerb then begin
  la1:= layera;
  la2:= layerb;
 end
 else begin
  la1:= layerb;
  la2:= layera;
 end;
 if (la1 <> la_f_cu) or (la2 <> la_b_cu) then begin
  s1:= '-'+layerdrillnames[la1]+'-'+layerdrillnames[la2];
 end;
 if nonplated then begin
  s1:= s1 + '-NPTH';
 end;
 result:= filenamebase(boardfile)+s1;
end;

procedure tmainmo.createprodfiles(const aindex: int32);
var
 i1,i2,i3: int32;
 board1,boardname1,plotdir1: filenamety;
 info1: prodplotinfoty;
 ar1,ar2: filenamearty;
 s1,s2: msestring;
 lainf1: layerinforecty;
 tmpf: filenamety;
 hasdrill,hasdetailfield,hasdistfield: boolean;
 cvsstream: ttextdatastream;
 ar3: msestringarty;
 ar4,ar5: fieldarty;
 recnobefore,indexbefore: int32;
 ds1: tdataset;
 
begin
 if not getboardfile(board1) then begin
  exit;
 end;
 if not prodplotdefinebyname(projectoptions.productionfiles[aindex],info1)
                                                                    then begin
  errormessage('Production file stack "'+projectoptions.productionfiles[aindex]+'"'+lineend+
               'is invalid');
  exit;
 end;
 beginpy('Create Plots');
 try
  boardname1:= filenamebase(board1);
  with info1 do begin
   hasdrill:= (drillfiles <> nil) or alldrill or alldrillnpt;
   plotdir1:= tosysfilepath(filepath(productiondir,fk_dir));
   
   setlength(lainf1.layers,1);
   setlength(ar1,length(plotfiles));
   for i1:= 0 to high(plotfiles) do begin
    with plotfiles[i1] do begin
     lainf1.layers[0]:= layer;
     s1:= filename;
     if not plotfile(board1,plotdir1,s1,format,emptyreal,lainf1,
           (i1 = high(plotfiles)) and not hasdrill and 
                                      not createproductionzipfile) then begin
      break;
     end;
     ar1[i1]:= s1;
    end;
   end;
   
   if hasdrill then begin
    tmpf:= intermediatefilename(msegettempdir()+'msekicadbom');
    createdirpath(tmpf);
    if self.drillfiles(board1,tmpf,true,false,ff_none,
                                     not createproductionzipfile) then begin   
     for i1:= 0 to high(drillfiles) do begin
      with drillfiles[i1] do begin
       s1:= plotdir1+filename;
       s2:= tmpf+'/'+getdrillfilename(board1,layera,layerb,nonplated)+'.drl';
       if findfile(s2) then begin
        copyfile(s2,s1);
        additem(ar1,s1);
       end;
      end;
     end;
     i2:= length(boardname1)+1;
     if alldrill then begin
      ar2:= searchfilenames('*.drl',tmpf);
      for i1:= 0 to high(ar2) do begin
       s1:= ar2[i1];
       if length(s1) > i2 then begin
        if pos('-NPTH.drl',s1) <> length(s1) - 8 then begin
         s1:= copy(s1,i2,bigint);
         setlength(s1,length(s1)-4); //remove .drl
         s1:= plotdir1+alldrillpref+s1+alldrillsuff;
         copyfile(tmpf+'/'+ar2[i1],s1);
         additem(ar1,s1);
        end;
       end;
      end;
     end;
     if alldrillnpt then begin
      ar2:= searchfilenames('*-NPTH.drl',tmpf);
      for i1:= 0 to high(ar2) do begin
       s1:= ar2[i1];
       if length(s1) > i2 then begin
        s1:= copy(s1,i2,bigint);
        setlength(s1,length(s1)-9); //remove -NPTH.drl 
        s1:= plotdir1+alldrillprefnpt+s1+alldrillsuffnpt;
        copyfile(tmpf+'/'+ar2[i1],s1);
        additem(ar1,s1);
       end;
      end;
     end;
    end;
   end;

   {creating individual drillfiles is currently not possible because of
    limitations in pcbnew.py   
   for i1:= 0 to high(drillfiles) do begin
    with drillfiles[i1] do begin
     s1:= filename;
     if not drillfile(board1,filepath(plotdir1,s1),dfk_excellon,
                          layera,layerb,nonplated,ff_gerber, //dummy
            (i1 = high(drillfiles)) and not createproductionzipfile) then begin
      break;
     end;
     ar1[i1+length(plotfiles)]:= s1;
    end;
   end;
   }

   for i1:= 0 to high(bomfiles) do begin
    with bomfiles[i1] do begin
     setlength(ar3,length(fields));
     setlength(ar4,length(fields));
     setlength(ar5,length(fields));
     hasdetailfield:= false;
     hasdistfield:= false;
     for i2:= 0 to high(ar3) do begin
      with fields[i2] do begin
       ar3[i2]:= fieldname;
       getcompfield(field,ar4[i2],ar5[i2]);
       if ar4[i2] = nil then begin
        raise exception.create(ansistring('Invalid BOM field "'+field+'"'));
       end;
       if ar4[i2].dataset = stockcompdetailqu then begin
        hasdetailfield:= true;
       end;
       if ar4[i2].dataset = stockcompdistribqu then begin
        hasdistfield:= true;
       end;
      end;
     end;
     s1:= filepath(plotdir1,filename);
     cvsstream:= ttextdatastream.create(s1,fm_create);
     recnobefore:= compds.recno;
     indexbefore:= compds.indexlocal.activeindex;
     compds.disablecontrols();
     stockcompdetailqu.disablecontrols();
     compkindqu.disablecontrols();
     application.beginwait();
     try
      cvsstream.encoding:= projectoptions.fileencoding;
      cvsstream.separator:= projectoptions.separator;
      cvsstream.quotechar:= projectoptions.quotechar;
      cvsstream.writerecord(ar3);
      if bom then begin
       bommo.isbomcvs:= true;
       ds1:= bommo.bomds;
       ds1.active:= true;
       for i2:= 0 to high(ar4) do begin
        if ar4[i2] = c_count then begin
         ar4[i2]:= bommo.bom_count;
        end;
        if ar4[i2] = c_ref then begin
         ar4[i2]:= bommo.bom_ref;
        end;
       end;
      end
      else begin
       compds.indexlocal.indexbyname('ref').active:= true;
       ds1:= compds;
      end;
      ds1.first();
      while not ds1.eof do begin
       if bom then begin
        compds.indexlocal[0].find([bommo.bom_comppk]);
       end;
       if hasdetailfield then begin
        stockcompdetailqu.refresh([c_stockitemid.value]);
       end;
       if hasdistfield then begin
        stockcompdistribqu.refresh([c_stockitemid.value]);
       end;
       for i2:= 0 to high(ar3) do begin
        if ar4[i2].dataset = stockcompdistribqu then begin
         s2:= '';
         for i3:= 0 to stockcompdistribqu.recordcount-1 do begin
          s2:= s2+stockcompdistribqu.currentasmsestring[ar4[i2],i3]+c_tab;
         end;
         if s2 <> '' then begin
          setlength(s2,length(s2)-1); //remove last tab
         end;
         ar3[i2]:= s2;
        end
        else begin
         ar3[i2]:= ar4[i2].asmsestring;
         if ar4[i2].dataset = stockcompdetailqu then begin
          if (ar3[i2] = '') and (ar5[i2] <> nil) then begin
           compkindqu.indexlocal[0].find([c_componentkindid]);
           ar3[i2]:= ar5[i2].asmsestring;
          end;
          ar3[i2]:= expandcomponentmacros(ar3[i2]);
         end;
        end;
       end;
       cvsstream.writerecord(ar3);
       ds1.next();
      end;
      additem(ar1,s1);
     finally
      application.endwait();
      bommo.bomds.active:= false;
      bommo.isbomcvs:= false;
      compds.recno:= recnobefore;
      compds.indexlocal.activeindex:= indexbefore;
      compds.enablecontrols();
      stockcompdetailqu.enablecontrols();
      compkindqu.enablecontrols();
      cvsstream.destroy();
     end;
    end;
   end;

   if createproductionzipfile then begin
    createzipfile(filepath(plotdir1,productionzipfilename),productionzipdir,
                                                            plotdir1,ar1,true);
   end;
  end;
 finally
  if tmpf <> '' then begin
   deletedir(tmpf);
  end;
  endpy();
 end;
end;

procedure tmainmo.createdocuset(const aindex: int32);
var
 tmpf: msestring;
 tmpfile: filenamety;
 tmpfileindex: int32;
 
 procedure inctempfile();
 begin
  inc(tmpfileindex);
  tmpfile:= tmpf+'/f'+inttostrmse(tmpfileindex);
 end;//inctempfile

var
 info1: docuinfoty;
 rep: tdocure;
 i1: int32;
 error1: boolean;
 boardfile1,s1,s2: filenamety;
 b1: boolean;
 pa1: treppageform;
 la1: layoutflagsty;
 lainf1: layerinforecty;
 drillfilesmade: boolean;
 indexbefore: int32;
begin
 if not docudefinebyname(projectoptions.docusets[aindex],info1) then begin
  errormessage('Docuset "'+projectoptions.docusets[aindex]+'"'+lineend+
               'is invalid');
  exit;
 end;
 fillchar(lainf1,sizeof(lainf1),0);
 with info1 do begin
  psprinter.pa_width:= pagewidth;
  psprinter.pa_height:= pageheight;
  psprinter.pa_frameleft:= leftmargin;
  psprinter.pa_frameright:= rightmargin;
  psprinter.pa_frametop:= topmargin;
  psprinter.pa_framebottom:= bottommargin;
 end;
 rep:= nil;
 error1:= false;
 tmpfileindex:= 0;
 tmpf:= intermediatefilename(msegettempdir()+'msekicadbom');
 createdirpath(tmpf);
 drillfilesmade:= false;
 indexbefore:= compds.indexlocal.activeindex;
 compds.disablecontrols();
 beginpy('Create Docu');
 rep:= tdocure.create(nil);
 try
  rep.clear(); //remove defaultpage
  rep.pagewidth:= psprinter.clientwidth;
  rep.pageheight:= psprinter.clientheight;
  with info1 do begin
   if font <> '' then begin
    rep.font.name:= ansistring(font);
   end;
   if fontheight <> emptyreal then begin
    rep.font.heightflo:= fontheight * rep.ppmm;
   end;
  end;
  for i1:= 0 to high(info1.pages) do begin
   pa1:= nil;
   case info1.pages[i1].pagekind of
    dpk_title: begin
     pa1:= ttitlereppa.create(rep,info1,info1.pages[i1]);
    end;
    dpk_layerplot: begin
     inctempfile();
     if not getboardfile(boardfile1) then begin
      error1:= true;
      break;
     end;
     with info1.pages[i1] do begin
      lainf1.layers:= layers;
      if lainf1.layers <> nil then begin
       s1:= tmpfile;
       if not plotfile(boardfile1,tmpf,s1,ff_postscript,deflinewidth,
                                                 lainf1,false) then begin
        error1:= true;
        break;
       end;
       pa1:= tdocupsreppa.create(rep,info1,info1.pages[i1]);
      end;
     end;
    end;
    dpk_drillmap: begin
     inctempfile();
     if not getboardfile(boardfile1) then begin
      error1:= true;
      break;
     end;
     with info1.pages[i1] do begin
      if (layera = la_none) or (layerb = la_none) then begin
       error1:= true;
       break;
      end;
      s1:= tmpfile+'.'+mainmodule.fileformatexts[ff_postscript];
      
      {creating individual drillfiles is currently not possible because of
       limitations in pcbnew.py   
      if not drillfile(boardfile1,s1,dfk_map,
                     layera,layerb,nonplated,ff_postscript,false) then begin
       error1:= true;
       break;
      end;
      }

      if not drillfilesmade then begin
       drillfilesmade:= true;
       if not drillfiles(boardfile1,tmpf,false,true,
                                          ff_postscript,false) then begin
        error1:= true;
        break;
       end;
      end;
      s2:= tmpf+'/'+getdrillfilename(boardfile1,layera,layerb,nonplated)+
                                                             '-drl_map.ps';
      if findfile(s2) then begin
       copyfile(s2,s1);
       pa1:= tdocupsreppa.create(rep,info1,info1.pages[i1]);
      end;
     end;
    end;
    dpk_schematic: begin
     with info1.pages[i1] do begin
      pa1:= tdocupsreppa.create(rep,info1,info1.pages[i1]);
      s1:= psfile;
     end;
    end;
    dpk_partlist: begin
     pa1:= tpartlistreppa.create(rep,info1,info1.pages[i1]);
    end;
    dpk_bom: begin
     pa1:= tbomreppa.create(rep,info1,info1.pages[i1]);
     bommo.bomds.active:= true;
    end;
   end;
   if pa1 <> nil then begin
    if pa1 is tdocupsreppa then begin
     with tdocupsreppa(pa1) do begin
      ps.psfile:= s1;
      la1:= ps.layout;
      with info1.pages[i1] do begin
       titledi.value:= title;
       if mirrorx then begin
        include(la1,la_mirrorx);
       end;
       if mirrory then begin
        include(la1,la_mirrory);
       end;
       if rotate90 then begin
        include(la1,la_rotate90);
       end;
       if rotate180 then begin
        include(la1,la_rotate180);
       end;
      end;
      ps.layout:= la1;
     end;
    end;
   end;
  end;
  if not error1 then begin
   compds.indexlocal.indexbyname('ref').active:= true;
   inctempfile();
   tmpfile:= tmpfile+'.ps';
   rep.render(psprinter,ttextstream.create(tmpfile,fm_create));
   if info1.pdffile <> '' then begin
    ps2pdf(tmpfile,filepath(info1.docudir,info1.pdffile),info1.pagewidth,info1.pageheight);
   end;
   b1:= false;
   if info1.psfile <> '' then begin
    b1:= true;
    s1:= filepath(info1.docudir,info1.psfile);
    createdirpath(filedir(filepath(s1)));
    copyfile(tmpfile,s1);
    tmpfile:= s1;
   end;
   showpsfile(tmpfile,b1);
  end;
 finally
  deletedir(tmpf);
  endpy();
  rep.destroy();
  bommo.bomds.active:= false;
  bommo.compdistribqu.active:= false;
  compds.indexlocal.activeindex:= indexbefore;
  compds.enablecontrols;
 end;
end;

procedure tmainmo.docusetev(const sender: TObject);
begin
 createdocuset(tmenuitem(sender).index);
end;

procedure tmainmo.saveev(const sender: TObject);
begin
 saveproject(false);
end;

procedure tmainmo.saveasev(const sender: TObject);
begin
 saveproject(true);
end;

procedure tmainmo.serviceerrorev(const sender: tfb3service; var e: Exception;
               var handled: Boolean);
begin
 errormessage(utf8tostring(e.message));
 handled:= true;
end;

procedure tmainmo.compdetailcalcfields(DataSet: TDataSet);
begin
end;

procedure tmainmo.compfootprintdelev(const sender: TObject; var aindex: Integer;
               var acount: Integer);
begin
 additem(fdeletedfootprints,cfp_pk.c.griddata[aindex]);
end;

procedure tmainmo.compkfootprintdelev(const sender: TObject;
               var aindex: Integer; var acount: Integer);
begin
 additem(fdeletedkfootprints,ckfp_pk.c.griddata[aindex]);
end;

function tmainmo.getfootprintitemvalues(const index: int32): variantarty;
begin
 setlength(result,6);
 result[0]:= cfp_pk.c.griddata[index];
 result[1]:= sc_pk.asid;
 result[2]:= index;
 result[3]:= cfp_footprint.c.griddata[index];
 result[4]:= cfp_footprintinfo.c.griddata[index];
 result[5]:= cfp_comment.c.griddata[index];
end;

function tmainmo.getkfootprintitemvalues(const index: int32): variantarty;
begin
 setlength(result,6);
 result[0]:= ckfp_pk.c.griddata[index];
 result[1]:= k_pk.asid;
 result[2]:= index;
 result[3]:= ckfp_footprint.c.griddata[index];
 result[4]:= ckfp_footprintinfo.c.griddata[index];
 result[5]:= ckfp_comment.c.griddata[index];
end;

procedure tmainmo.compkindpostev(const sender: TDataSet;
               const master: TDataSet);
begin
// ffootprintlink:= k_pk.asid;
 updateitems(fdeletedkfootprints,ckfp_pk,compfootprintdelete,compfootprintupdate,
                 compfootprintinsert,@getkfootprintitemvalues);
end;

procedure tmainmo.compkindrefreshev(const sender: TObject);
begin
 refreshitems(k_pk,fdeletedkfootprints,ckfp_pk,compkindqu,compkfootprintdso);
end;

procedure tmainmo.stockcompostev(const sender: TDataSet;
               const master: TDataSet);
begin
// ffootprintlink:= sc_pk.asid;
 updateitems(fdeletedfootprints,cfp_pk,compfootprintdelete,compfootprintupdate,
                 compfootprintinsert,@getfootprintitemvalues);
end;

procedure tmainmo.stockcomprefreshev(const sender: TObject);
begin
 refreshitems(sc_pk,fdeletedfootprints,cfp_pk,stockcompqu,compfootprintdso);
end;

procedure tmainmo.compfootopenev(const sender: TObject);
begin
 nostockcompfootprints.c.value:= cfp_pk.c.griddata.count = 0;
end;

procedure tmainmo.stockcompdatachaev(Sender: TObject; Field: TField);
begin
 if not fdisconnecting and ((field = nil) or (field = sc_componentkind)) and 
                             not stockcompqu.controller.copying then begin
  compfootprintdso.refresh(500000);
 end;
end;

procedure tmainmo.afterconnev(const sender: tmdatabase);
begin
 checkdbcompatibility();
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

procedure tprojectoptions.setreportseparator(const avalue: msestring);
begin
 if avalue = '' then begin
  freportseparator:= defaultseparator;
 end
 else begin
  freportseparator:= copy(avalue,1,1);
 end;
 fseparator:= freportseparator[1];
end;

procedure tprojectoptions.setreportquotechar(const avalue: msestring);
begin
 if avalue = '' then begin
  freportquotechar:= defaultquotechar;
 end
 else begin
  freportquotechar:= copy(avalue,1,1);
 end;
 fquotechar:= freportquotechar[1];
end;

constructor tprojectoptions.create();
var
 fiki: filekindty;
begin
 for fiki:= low(ffilewarnings) to high(ffilewarnings) do begin
  ffilewarnings[fiki]:= true;
 end;
 reportencoding:= ord(ce_utf8);
 reportseparator:= defaultseparator;
 reportquotechar:= defaultquotechar;
end;

procedure tprojectoptions.storevalues(const asource: tmsecomponent;
               const prefix: string = '');
begin
 inherited;
 mainmo.updateprojectmacros(projectoptions.projectmacronames,
                                           projectoptions.projectmacrovalues);
 mainmo.fmodified:= true;
 mainmo.statechanged();
 mainmo.refresh();
end;

const
 fileextensions: array[filekindty] of msestring = ('cmp','kicad_pcb');
 
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
  afile:= mainmo.expandprojectmacros(afile);
  if ffilewarnings[akind] and findfile(afile) and 
          not askyesno('File "'+afile+'" exists.'+lineend+
       'Do you want to overwrite it?','CONFIRMATION') then begin
   result:= false;
  end;
 end;
end;

{ tglobaloptions }

constructor tglobaloptions.create();
begin
{$ifdef mswindows}
 fpsviewer:= 'gsview';
 fpython:= 'pythonw.exe';
{$else}
 fpsviewer:= 'okular';
 fpython:= 'python';
{$endif}
 fps2pdf:= 'ps2pdf';
end;

destructor tglobaloptions.destroy();
begin
 docudefines:= nil; //free pages
 inherited;
end;

function tglobaloptions.prodplotdefinebyname(
              const aname: msestring): pprodplotinfoty;
var
 p1,pe: pprodplotinfoty;
begin
 result:= nil;
 p1:= pointer(fprodplotdefines);
 pe:= p1 + length(fprodplotdefines);
 while p1 < pe do begin
  if p1^.h.name = aname then begin
   result:= p1;
   break;
  end;
  inc(p1);
 end;
end;

function tglobaloptions.docudefinebyname(const aname: msestring): pdocuinfoty;
var
 p1,pe: pdocuinfoty;
begin
 result:= nil;
 p1:= pointer(fdocudefines);
 pe:= p1 + length(fdocudefines);
 while p1 < pe do begin
  if p1^.h.name = aname then begin
   result:= p1;
   break;
  end;
  inc(p1);
 end;
end;

procedure tglobaloptions.setprodplotdefines(const avalue: prodplotinfoarty);
var
 i1: int32;
begin
 fprodplotdefines:= avalue;
 setlength(fprodplotnames,length(fprodplotdefines));
 for i1:= 0 to high(fprodplotdefines) do begin
  fprodplotnames[i1]:= fprodplotdefines[i1].h.name;
 end;
end;

procedure tglobaloptions.setdocudefines(const avalue: docuinfoarty);
var
 i1: int32;
begin
 for i1:= 0 to high(fdocudefines) do begin
//  docupagesetlength(fdocudefines[i1].pages,0);
 end;
// fdocudefines:= avalue;
 setlength(fdocunames,length(fdocudefines));
 for i1:= 0 to high(fdocudefines) do begin
  fdocunames[i1]:= fdocudefines[i1].h.name;
 end;
end;

procedure tglobaloptions.readinfoheader(const areader: tstatreader;
                                             var avalue: infoheaderty);
begin
 with avalue do begin
  name:= areader.readmsestring('name','');
 end;
end;

procedure tglobaloptions.dostatread(const reader: tstatreader);
begin
 inherited;
end;

procedure tglobaloptions.writeinfoheader(const awriter: tstatwriter;
                                                  const avalue: infoheaderty);
begin
 with avalue do begin
  awriter.writemsestring('name',avalue.name);
 end;
end;

procedure tglobaloptions.dostatwrite(const writer: tstatwriter);
var
 i1,i2: int32;
begin
 inherited;
 if fprodplotdefines <> nil then begin
  writer.beginlist('prodplotstack');
  for i1:= 0 to high(fprodplotdefines) do begin
   writer.beginlist('item'+inttostrmse(i1));
   with fprodplotdefines[i1] do begin
    writeinfoheader(writer,h);
    writer.writemsestring('productiondir',productiondir);
    writer.writeboolean('createproductionzip',createproductionzipfile);
    writer.writemsestring('productionzipfile',productionzipfilename);
    writer.writemsestring('productionzipdir',productionzipdir);
    writer.writearray('layernames',layernames);
//    writer.writearray('plotfiles',plotfiles);
//    writer.writearray('plotformats',plotformats);
//    writer.writearray('drillmarks',drillmarks);
//    writer.writearray('layeranames',layeranames);
//    writer.writearray('layerbnames',layerbnames);
//    writer.writearray('nonplated',nonplated);
//    writer.writearray('drillfiles',drillfiles);
   end;
   writer.endlist();
  end;
  writer.endlist();
 end;
 if fdocudefines <> nil then begin
  writer.beginlist('docustack');
  for i1:= 0 to high(fdocudefines) do begin
   writer.beginlist('item'+inttostrmse(i1));
   with fdocudefines[i1] do begin
    writeinfoheader(writer,h);
    writer.writemsestring('docudir',docudir);
    writer.writemsestring('psfile',psfile);
    writer.writemsestring('pdffile',pdffile);
    writer.writereal('pagewidth',pagewidth);
    writer.writereal('pageheight',pageheight);
    writer.writereal('rightmargin',rightmargin);
    writer.writereal('leftmargin',leftmargin);
    writer.writereal('topmargin',topmargin);
    writer.writereal('bottommargin',bottommargin);
    writer.beginlist('pages');
    for i2:= 0 to high(pages) do begin
     writer.beginlist('item'+inttostrmse(i2));
//     pages[i2].writestat(writer,'');
     writer.endlist();
    end;
    writer.endlist();
{    
    writer.writearray('titles',titles);
    writer.writearray('pagekinds',pagekinds);
    writer.beginlist('layerplots');
    for i2:= 0 to high(layerplots) do begin
     writer.beginlist('item'+inttostrmse(i2));
     with layerplots[i2] do begin
      writer.writemsestring('layername',layername);
     end;
     writer.endlist();
    end;
    writer.endlist();
    writer.beginlist('schematicplots');
    for i2:= 0 to high(schematicplots) do begin
     writer.beginlist('item'+inttostrmse(i2));
     with schematicplots[i2] do begin
      writer.writemsestring('psfile',psfile);
     end;
     writer.endlist();
    end;
    writer.endlist();
 }
   end;
   writer.endlist();
  end;
  writer.endlist();
 end;
end;
(*
{ tdocupage }

constructor tdocupage.create();
begin
 fscale:= 1;
end;

function tdocupage.getkind(): msestring;
begin
 result:= docupageenums[getpagekind];
end;

procedure tdocupage.setkind(const avalue: msestring);
begin
 //dummy
end;

class function tdocupage.getpagekind: docupagekindty;
begin
 result:= dpk_none;
end;

function tdocupage.getkindid: int32;
begin
 result:= ord(getpagekind)-1;
end;

{ tlayerplotpage }

constructor tlayerplotpage.create();
begin
 inherited;
 fdrillmarks:= 'None';
end;

class function tlayerplotpage.getpagekind: docupagekindty;
begin
 result:= dpk_layerplot;
end;

procedure tlayerplotpage.dostatread(const reader: tstatreader);
var
 i1: int32;
begin
 inherited;
 i1:= length(flayernames);
 setlength(fcolornames,i1);
 setlength(frefon,i1);
 setlength(frefcolor,i1);
 setlength(fvalon,i1);
 setlength(fvalcolor,i1);
 setlength(finvison,i1);
end;

{ tschematicplotpage }

class function tschematicplotpage.getpagekind: docupagekindty;
begin
 result:= dpk_schematic;
end;


{ tdrillmappage }

class function tdrillmappage.getpagekind: docupagekindty;
begin
 result:= dpk_drillmap;
end;

constructor tdrillmappage.create();
begin
 flayeraname:= layernames[la_f_cu];
 flayerbname:= layernames[la_b_cu];
end;

{ tpartlistpage }

class function tpartlistpage.getpagekind: docupagekindty;
begin
 result:= dpk_partlist;
end;

{ tbompage }

class function tbompage.getpagekind: docupagekindty;
begin
 result:= dpk_bom;
end;

{ ttitlepage }

class function ttitlepage.getpagekind: docupagekindty;
begin
 result:= dpk_title;
end;
*)
initialization
 globaloptions:= tglobaloptions.create();
 projectoptions:= tprojectoptions.create();
finalization
 projectoptions.free();
 globaloptions.free();
end
.
