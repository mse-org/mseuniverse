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
 mseprocess,mseguiprocess,msereport,mserichstring,msesplitter,msefb3service;

const
 versiontext = '0.0';

type
 drillfilekindty = (dfk_map,dfk_excellon);
 
 fileformatty = (
  ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
 );

 layerty = (
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
 
type
 namedinfoty = record
  name: msestring;
 end;
 infoheaderty = namedinfoty;
 prodplotinfoty = record
  h: infoheaderty;
  productiondir: filenamety;
  createproductionzipfile: boolean;
  productionzipfilename: filenamety;
  productionzipdir: filenamety;
  layernames: msestringarty;
  plotfiles: msestringarty;
  plotformats: integerarty;
  layeranames: msestringarty;
  layerbnames: msestringarty;
  nonplated: booleanarty;
  drillfiles: msestringarty;
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

 docupagekindty = (dpk_none,dpk_title,dpk_schematic,dpk_layerplot,dpk_drillmap,
                   dpk_partlist,dpk_bom);

 tdocupage = class(toptions)
  private
   ftitle: msestring;
   fmirrorx: boolean;
   fmirrory: boolean;
   frotate90: boolean;
   frotate180: boolean;
   procedure setkind(const avalue: msestring);
   function getkind(): msestring;
   function getkindid(): int32;
  protected
   class function getpagekind: docupagekindty virtual;
  public
   constructor create(); virtual;
   property pagekind: docupagekindty read getpagekind;
   property kindid: int32 read getkindid{ write setkind};
  published
   property kind: msestring read getkind write setkind;
   property title: msestring read ftitle write ftitle;
   property mirrorx: boolean read fmirrorx write fmirrorx;
   property mirrory: boolean read fmirrory write fmirrory;
   property rotate90: boolean read frotate90 write frotate90;
   property rotate180: boolean read frotate180 write frotate180;
 end;
 docupageclassty = class of tdocupage;
 docupagearty = array of tdocupage;
 
 ttitlepage = class(tdocupage)
  private
   ftext: msestring;
  protected
   class function getpagekind: docupagekindty override;
  published
   property text: msestring read ftext write ftext;
 end;

 tlayerplotpage = class(tdocupage)
  private
   flayername: msestring;
  protected
   class function getpagekind: docupagekindty override;
  published
   property layername: msestring read flayername write flayername;
 end;

 tdrillmappage = class(tdocupage)
  private
   flayeraname: msestring;
   flayerbname: msestring;
   fnonplated: boolean;
  protected
   class function getpagekind: docupagekindty override;
  public
   constructor create(); override;
  published
   property layeraname: msestring read flayeraname write flayeraname;
   property layerbname: msestring read flayerbname write flayerbname;
   property nonplated: boolean read fnonplated write fnonplated;
 end;

 tschematicplotpage = class(tdocupage)
  private
   fpsfile: msestring;
  protected
   class function getpagekind: docupagekindty override;
  published
   property psfile: msestring read fpsfile write fpsfile;
 end;

 tpartlistpage = class(tdocupage)
  protected
   class function getpagekind: docupagekindty override;
 end;

 tbompage = class(tdocupage)
  protected
   class function getpagekind: docupagekindty override;
 end;
    
 docuinfoty = record
  h: infoheaderty;
  docudir: filenamety;
  psfile: filenamety;
  pdffile: filenamety;
  pages: docupagearty;
 {
  titles: msestringarty;
  pagekinds: integerarty;
  layerplots: docuplotpageinfoarty;
  schematicplots: docuschematicpageinfoarty;
 }
 end;
 pdocuinfoty = ^docuinfoty;
 docuinfoarty = array of docuinfoty;
 
 tglobaloptions = class(toptions)
  private
//   ffilename: filenamety;
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
   fplotstack: msestring;
   fdocuset: msestring;
   fprojectname: msestring;
   fprojectmacronames: msestringarty;
   fprojectmacrovalues: msestringarty;
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
   property board: msestring read ffilenames[fk_board]
                                        write ffilenames[fk_board];
   property reportencoding: int32 read freportencoding write setreportencoding;
   property libident: msestringarty read flibident write flibident;
   property libalias: msestringarty read flibalias write flibalias;
   property plotstack: msestring read fplotstack write fplotstack;
   property docuset: msestring read fdocuset write fdocuset;
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
   prodfilesact: taction;
   python: tpythonscript;
   docusetact: taction;
   psprinter: tpostscriptprinter;
   viewerproc: tguiprocess;
   ps2pdfproc: tmseprocess;
   service: tfb3service;
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
  private
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
   ffileformatcodes: msestringarty;
   fpythonconsole: tpythonconsolefo;
   flastprojectfile: filenamety;
   ffileformatexts: msestringarty;
   fdocupagekinds: msestringarty;
  protected
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
   function getlayer(const aname: msestring; out akind: layerty): boolean;
                                            //true if OK
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   procedure createdatabase(const ahostname: msestring;
                                        const adbname: msestring);
   procedure openproject(const afilename: filenamety);
   procedure endedit();
   procedure refresh();
   function closeproject(): boolean; //true if not canceled
   function saveproject(const saveas: boolean): boolean;  //true if not canceled
   function doexit: boolean;         //true if not canceled

   procedure beginedit(const aquery: tmsesqlquery; const afield: tfield);
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
                       const alayer: layerty; const alast: boolean): boolean;
   function drillfile(const aboard: filenamety; const adrillfile: filenamety;
             const akind: drillfilekindty;
             const alayera,alayerb: layerty; 
              const anonplated: boolean; const aformat: fileformatty;
              const alast: boolean): boolean;
   function createzipfile(const aarchivename: filenamety;
          const basedir: filenamety; const afiles: array of filenamety;
          const alast : boolean): boolean;
   procedure showpsfile(const afile: filenamety; const cancontinue: boolean);
   procedure ps2pdf(const source,dest: msestring);

   procedure createdocuset();
   procedure createprodfiles();
   
   property layernames: msestringarty read flayernames;
   property layercodes: msestringarty read flayercodes;
   property culayernames: msestringarty read fculayernames;
   property fileformats: msestringarty read ffileformats;
   property fileformatcodes: msestringarty read ffileformatcodes;
   property fileformatexts: msestringarty read ffileformatexts;
   property docupagekinds: msestringarty read fdocupagekinds;
 end;
 
var
 mainmo: tmainmo;
 globaloptions: tglobaloptions;
 projectoptions: tprojectoptions;

procedure errormessage(const message: msestring);
function layertoplotname(const layername: msestring): msestring;
//procedure docupagesetlength(var pages: docupagearty; const count: int32);
//function updatedocupageobj(var pages: docupagearty; const index: int32;
//                                         const kind: docupagekindty): tdocupage;
procedure updatedocupageobj(var page: tdocupage;
                                      const kind: docupagekindty);
implementation
uses
 mainmodule_mfm,msewidgets,variants,msestrmacros,msefilemacros,msemacmacros,
 mseenvmacros,msefileutils,mseformatstr,msesysutils,msedate,msereal,
 msearrayutils,docureport,docupsreppage,basereppage,mserepps,
 partlistreppage,bomreppage,bommodule,vendormodule,dbdata,titlereppage;

var
 docupageclasses: array[docupagekindty] of docupageclassty = (
 //dpk_none,dpk_title, dpk_schematic,     dpk_layerplot,dpk_drillmap
  nil,      ttitlepage,tschematicplotpage,tlayerplotpage,tdrillmappage,
 //dpk_partlist,dpk_bom
  tpartlistpage,tbompage
  );

procedure docupagesetlength(var pages: docupagearty; const count: int32);
var
 i1: int32;
begin
 for i1:= high(pages) downto count do begin
  pages[i1].free();
 end;
 setlength(pages,count);
end;
{
function updatedocupageobj(var pages: docupagearty; const index: int32;
                                        const kind: docupagekindty): tdocupage;
begin
 pages[index].free();
 result:= docupageclasses[kind].create();
 pages[index]:= result;
end;
}
procedure updatedocupageobj(var page: tdocupage;

                                      const kind: docupagekindty);
begin
 page.free();
 page:= docupageclasses[kind].create();
end;

{ tmainmo }

type
 componentmacronamety = (
    cmn_value,cmn_value1,cmn_value2,
    cmn_footprint,cmn_footprintident,cmn_footprintlibrary,
     cmn_footprintdescription,
    cmn_manufacturer,cmn_distributor,
    cmn_description,cmn_parameter1,cmn_parameter2,cmn_parameter3,
    cmn_parameter4,
    cmn_k_footprint,cmn_k_footprintident,cmn_k_footprintlibrary,
    cmn_k_footprintdescription,
    cmn_k_manufacturer,cmn_k_distributor,cmn_k_description,
    cmn_k_parameter1,cmn_k_parameter2,cmn_k_parameter3,cmn_k_parameter4);

const
 componentmacronames: array[componentmacronamety] of msestring = (
//cmn_value,cmn_value1,cmn_value2,
     'value',  'value1',  'value2',
//cmn_footprint,cmn_footprintident,cmn_footprintlibrary,
     'footprint',  'footprintident',  'footprintlibrary',
//cmn_footprintdescription,
     'footprintdescription',
//cmn_manufacturer,cmn_distributor,
     'manufacturer',  'distributor',
//cmn_designation,cmn_parameter1,cmn_parameter2,cmn_parameter3,
     'description',  'parameter1',  'parameter2',  'parameter3',
//cmn_parameter4,
     'parameter4',
//cmn_k_footprint,cmn_k_footprintident,cmn_k_footprintlibrary,
     'k_footprint',  'k_footprintident',  'k_footprintlibrary',
//cmn_k_footprintdescription,
     'k_footprintdescription',
//cmn_k_manufacturer,cmn_k_distributor,cmn_k_description,
     'k_manufacturer',  'k_distributor',  'k_description',
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
//  la_f_crtyd,la_f_fab,la_f_adhes,la_f_paste,la_f_silks,la_f_mask,
    'F.CrtYd','F.Fab','F.Adhes','F.Paste','F.SilkS','F.mask',
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
    'In29.Cu','In26.Cu','In27.Cu','In28.Cu','In29.Cu','In30.Cu',
//  la_b_cu,
    'B.Cu',
//  la_b_mask,la_b_silks,la_b_paste,la_b_adhes,la_b_fab,la_b_crtyd,
    'B.Mmask','B.SilkS','B.Paste','B.Adhes','B.Fab','B.CrtYd',
//  la_edge_cuts,la_margin,la_eco1_user,la_eco2_user,la_cmts_user,la_dwgs_user
    'Edge.Cuts','Margin','Eco1.User','Eco2.User','Cmts.User','Dwgs.User'{,
//  pk_drillmap
    'Drill.Map'}
 );
 layercodes: array[layerty] of msestring = (
//  la_f_crtyd,la_f_fab,la_f_adhes,la_f_paste,la_f_silks,la_f_mask,
    'F_CrtYd','F_Fab','F_Adhes','F_Paste','F_SilkS','F_mask',
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
    'In29_Cu','In26_Cu','In27_Cu','In28_Cu','In29_Cu','In30_Cu',
//  la_b_cu,
    'B_Cu',
//  la_b_mask,la_b_silks,la_b_paste,la_b_adhes,la_b_fab,la_b_crtyd,
    'B_Mmask','B_SilkS','B_Paste','B_Adhes','B_Fab','B_CrtYd',
//  la_edge_cuts,la_margin,la_eco1_user,la_eco2_user,la_cmts_user,la_dwgs_user
    'Edge_Cuts','Margin','Eco1_User','Eco2_User','Cmts_User','Dwgs_User'{,
//  pk_drillmap
    'Drill_Map'}
 );

const
 drillfilecodes: array[drillfilekindty] of msestring = (
 //dfk_map,  dfk_excellon
  'Drill_Map','Excellon'
 );
 fileformatnames: array[fileformatty] of msestring = (
//  ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
    'Gerber','Postscript','SVG','DXF','HPGL','PDF'
 );

 fileformatcodes: array[fileformatty] of msestring = (
//  ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
    'GERBER','POST','SVG','DXF','HPGL','PDF'
 );

 fileformatexts: array[fileformatty] of msestring = (
//  ff_gerber,ff_postscript,ff_svg,ff_dxf,ff_hpgl,ff_pdf
      'gbr',    'ps',         'svg', 'dxf', 'plt', 'pdf'
 );

 docupageenums: array[docupagekindty] of msestring = (
//dpk_none,dpk_title,dpk_schematic,dpk_layerplot,dpk_drillmap,dpk_partlist,dpk_bom
  '','title','schematic','layerplot','drillmap','partlist','bom'
 );
 docupagekinds: array[0..ord(high(docupagekindty))-1] of msestring = (
//dpk_title,dpk_schematic,dpk_layerplot,dpk_drillmap,dpk_partlist,dpk_bom
   'Title','Schematic','PCB Layer-Plot','Drill-Map','Partlist','BOM'
 );
 
function layertoplotname(const layername: msestring): msestring;
begin
 result:= mselowercase(layername);
 replacechar1(result,'.','_');
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
 flayernames:= mainmodule.layernames;
 flayercodes:= mainmodule.layercodes;
 setlength(fculayernames,ord(high(culayers))-ord(low(culayers))+1);
 for i1:= 0 to high(fculayernames) do begin
  fculayernames[i1]:= mainmodule.layernames[layerty(i1+ord(low(culayers)))];
 end;
 ffileformats:= fileformatnames;
 ffileformatcodes:= mainmodule.fileformatcodes;
 ffileformatexts:= mainmodule.fileformatexts;
 fdocupagekinds:= mainmodule.docupagekinds;
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
 s1,s2: msestring;
 stream1: tobjectdatastream;
 stream2: tmsefilestream;
begin
 conn.connected:= false;
 getcredentialsev(nil,username1,password1);
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
  openproject(flastprojectfile);
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
 try
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
    
    vendormo.manufacturerqu.controller.refresh(false);
    vendormo.distributorqu.controller.refresh(false);
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
 except
  compds.active:= false;
  application.handleexception();
 end;
end;

procedure tmainmo.openproject(const afilename: filenamety);
begin
// globaloptions.filename:= afilename;
 projectstat.filename:= afilename;
 try
  projectstat.readstat();
  fhasproject:= true;
  fprojectfile:= afilename;
  fprojectname:= filenamebase(afilename);
  setcurrentdirmse(filedir(fprojectfile));
  flastprojectfile:= fprojectfile;
  fmodified:= false;
  updateprojectmacros(projectoptions.projectmacronames,
                                         projectoptions.projectmacrovalues);
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
 vendormo.manufacturerqu.active:= true;
 vendormo.distributorqu.active:= true;
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
 bo1: boolean;

begin
 result:= '';
 stockcompdetailqu.controller.checkrefresh(); //make pending refresh
 bo1:= not sc_componentkind.isnull and 
                      compkindqu.indexlocal[0].find([sc_componentkind],bm1);
 componentmacroitems[cmn_value]^.value:= sc_value.asmsestring;
 componentmacroitems[cmn_value1]^.value:= sc_value1.asmsestring;
 componentmacroitems[cmn_value2]^.value:= sc_value2.asmsestring;
 if footprintqu.indexlocal[0].find([sc_footprint],bm2) then begin
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
 componentmacroitems[cmn_distributor]^.value:= 
                                     sc_distributorname.asmsestring;
 componentmacroitems[cmn_description]^.value:= 
                                     scd_description.asmsestring;
 componentmacroitems[cmn_parameter1]^.value:= scd_parameter1.asmsestring;
 componentmacroitems[cmn_parameter2]^.value:= scd_parameter2.asmsestring;
 componentmacroitems[cmn_parameter3]^.value:= scd_parameter3.asmsestring;
 componentmacroitems[cmn_parameter4]^.value:= scd_parameter4.asmsestring;

 if bo1 then begin
  if footprintqu.indexlocal[0].find(
            [compkindqu.currentbmasid[k_footprint,bm1]],[],bm2) then begin
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
  updatemacro(bm1,k_manufacturername,cmn_manufacturer,cmn_k_manufacturer);
  updatemacro(bm1,k_distributorname,cmn_distributor,cmn_k_distributor);
  updatemacro(bm1,k_description,cmn_description,cmn_k_description);
  updatemacro(bm1,k_parameter1,cmn_parameter1,cmn_k_parameter1);
  updatemacro(bm1,k_parameter2,cmn_parameter2,cmn_k_parameter2);
  updatemacro(bm1,k_parameter3,cmn_parameter3,cmn_k_parameter3);
  updatemacro(bm1,k_parameter4,cmn_parameter4,cmn_k_parameter4);
 end
 else begin
  componentmacroitems[cmn_k_footprint]^.value:= '';
  componentmacroitems[cmn_k_footprintident]^.value:= '';
  componentmacroitems[cmn_k_footprintdescription]^.value:= '';
  componentmacroitems[cmn_k_manufacturer]^.value:= '';
  componentmacroitems[cmn_k_distributor]^.value:= '';
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
   openproject(fprojectfile);
   statechanged();
  end;
 end;
end;

procedure tmainmo.newprojectev(const sender: TObject);
begin
 if closeproject() then begin
  fprojectfile:= '';
  fhasproject:= true;
  statechanged();
  projectsettingsact.execute(true); //do not check enabled
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

function tmainmo.execpy(const ascript: msestring;
               const params: array of msestring;
               const last: boolean): boolean;
var
 i1: int32;
begin
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
                       const alayer: layerty; const alast: boolean): boolean;
var
 dir1: filenamety;
 d1,n1,s1: filenamety;
begin
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
 result:= execpy('plotfile',
      [aboard,tosysfilepath(dir1),mainmodule.fileformatcodes[aformat],
                                          mainmodule.layercodes[alayer]],alast);
 s1:= filenamebase(aboard)+'-'+mainmodule.layercodes[alayer]+'.'+
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

function tmainmo.createzipfile(const aarchivename: filenamety;
          const basedir: filenamety; const afiles: array of filenamety;
          const alast : boolean): boolean;
var
 i1: int32;
 ar1: msestringarty;
 base1,s1: filenamety;
begin
 result:= false;
 ar1:= nil; //compiler warning
 setlength(ar1,1+2*length(afiles));
 ar1[0]:= tosysfilepath(filepath(aarchivename));
 base1:= filepath(basedir);
 for i1:= 0 to high(afiles) do begin
  ar1[i1*2+1]:= tosysfilepath(filepath(afiles[i1]));
  s1:= relativepath(afiles[i1],base1);
  if msestartsstr('..',s1) then begin
   fpythonconsole.writeln(
     'Zip error: File destination not in archive: "'+s1+'"');
   exit;
  end;
  ar1[i1*2+2]:= s1;
 end;
 execpy('createzip',ar1,alast); //zipfile,zipdir,{file}
 result:= true;
end;

function tmainmo.getlayer(const aname: msestring;
                                   out akind: layerty): boolean;
var
 pk1: layerty;
begin
 result:= false;
 akind:= layerty(-1);
 for pk1:= low(layerty) to high(layerty) do begin
  if aname = mainmodule.layernames[pk1] then begin
   akind:= pk1;
   result:= true;
   exit;
  end;
 end;
 errormessage('Ivalid plotkind "'+aname+'"');
end;

procedure tmainmo.createprodfiles();
var
 i1{,i2}: int32;
 board1,boardname1,plotdir1: filenamety;
 info1: pprodplotinfoty;
 ar1{,ar2}: filenamearty;
 s1,s2,s3: msestring;
 la1,la2: layerty;
begin
 if not getboardfile(board1) then begin
  exit;
 end;
 info1:= globaloptions.prodplotdefinebyname(projectoptions.plotstack);
 if info1 = nil then begin
  errormessage('Plotstack "'+projectoptions.plotstack+'"'+lineend+
               'is invalid');
  exit;
 end;
 beginpy('Create Plots');
 try
  boardname1:= filenamebase(board1);
  with info1^ do begin
   plotdir1:= tosysfilepath(filepath(
                                    expandprojectmacros(productiondir),fk_dir));
   setlength(ar1,length(layernames));
   for i1:= 0 to high(layernames) do begin
    ar1[i1]:= plotfiles[i1];
    if not getlayer(layernames[i1],la2) then begin
     break;
    end;
    if not plotfile(board1,plotdir1,ar1[i1],
                           fileformatty(plotformats[i1]),la2,
          (i1 = high(plotfiles)) and (length(drillfiles) = 0)
                                and not createproductionzipfile) then begin
     break;
    end;
   end;
   setlength(ar1,length(ar1)+length(drillfiles));
   for i1:= 0 to high(drillfiles) do begin
    s1:= drillfiles[i1]+'.drl';
    ar1[i1+length(plotfiles)]:= s1;
    if not getlayer(layeranames[i1],la1) or
                          not getlayer(layerbnames[i1],la2) then begin
     break;
    end;
    if not drillfile(board1,filepath(plotdir1,s1),dfk_excellon,
                                      la1,la2,nonplated[i1],ff_gerber, //dummy
           (i1 = high(drillfiles)) and not createproductionzipfile) then begin
     break;
    end;
   end;
   if createproductionzipfile then begin
    createzipfile(filepath(plotdir1,
         expandprojectmacros(productionzipfilename)),plotdir1,ar1,true);
   end;
  end;
 finally
  endpy();
 end;
end;

procedure tmainmo.prodfilesev(const sender: TObject);
begin
 createprodfiles();
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
  viewerproc.parameter:= afile;
  viewerproc.cancontinue:= cancontinue;
  viewerproc.active:= true;
 end;
end;

procedure tmainmo.ps2pdf(const source: msestring; const dest: msestring);
begin
 if globaloptions.ps2pdf = '' then begin
  errormessage('ps2pdf program not defined in global settings.');
 end
 else begin
  createdirpath(filedir(filepath(dest)));
  ps2pdfproc.filename:= globaloptions.ps2pdf;
  ps2pdfproc.parameter:= quotefilename([source,dest]);
  ps2pdfproc.active:= true;
  ps2pdfproc.waitforprocess();
 end;
end;

procedure tmainmo.createdocuset();
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
 info1: pdocuinfoty;
 rep: tdocure;
 i1: int32;
 error1: boolean;
 boardfile1,s1: filenamety;
 pk1,pk2: layerty;
 b1: boolean;
 pac1: reppageformclassty;
 pa1: treppageform;
 la1: layoutflagsty;
begin
 info1:= globaloptions.docudefinebyname(projectoptions.docuset);
 if info1 = nil then begin
  errormessage('Docuset "'+projectoptions.docuset+'"'+lineend+
               'is invalid');
  exit;
 end;
 rep:= nil;
 error1:= false;
 tmpfileindex:= 0;
 tmpf:= intermediatefilename(msegettempdir()+'msekicadbom');
 createdirpath(tmpf);
 beginpy('Create Docu');
 try
  rep:= tdocure.create(nil);
  rep.clear(); //remove defaultpage
  for i1:= 0 to high(info1^.pages) do begin
   pac1:= nil;
   pa1:= nil;
   case info1^.pages[i1].pagekind of
    dpk_title: begin
     pa1:= ttitlereppa.create(ttitlepage(info1^.pages[i1]));
    end;
    dpk_layerplot: begin
     inctempfile();
     if not getboardfile(boardfile1) then begin
      error1:= true;
      break;
     end;
     with tlayerplotpage(info1^.pages[i1]) do begin
      if not getlayer(layername,pk1) then begin
       error1:= true;
       break;
      end;
      s1:= tmpfile;
      if not plotfile(boardfile1,tmpf,s1,ff_postscript,pk1,false) then begin
       error1:= true;
       break;
      end;
      pac1:= tdocupsreppa;
     end;
    end;
    dpk_drillmap: begin
     inctempfile();
     if not getboardfile(boardfile1) then begin
      error1:= true;
      break;
     end;
     with tdrillmappage(info1^.pages[i1]) do begin
      if not getlayer(layeraname,pk1) or 
                 not getlayer(layerbname,pk2) then begin
       error1:= true;
       break;
      end;
      s1:= tmpfile+'.'+mainmodule.fileformatexts[ff_postscript];
      if not drillfile(boardfile1,{tmpf+'/'+}s1,dfk_map,
                              pk1,pk2,nonplated,ff_postscript,false) then begin
       error1:= true;
       break;
      end;
      pac1:= tdocupsreppa;
     end;
    end;
    dpk_schematic: begin
     with tschematicplotpage(info1^.pages[i1]) do begin
      pac1:= tdocupsreppa;
      s1:= expandprojectmacros(psfile);
     {
      with tdocupsreppa(rep.add(tdocupsreppa.create(nil))) do begin
       ps.psfile:= psfile;
      end;
     }
     end;
    end;
    dpk_partlist: begin
     pac1:= tpartlistreppa;
    end;
    dpk_bom: begin
     pac1:= tbomreppa;
     bommo.bomds.active:= true;
    end;
   end;
   if (pac1 <> nil) and (pa1 = nil) then begin
    pa1:= tdocupsreppa(pac1.create(nil));
   end;
   if pa1 <> nil then begin
    if pa1 is tdocupsreppa then begin
     with tdocupsreppa(pa1) do begin
      ps.psfile:= s1;
      la1:= ps.layout;
      with info1^.pages[i1] do begin
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
    rep.add(pa1);
   end;
  end;
  if not error1 then begin
   inctempfile();
   tmpfile:= tmpfile+'.ps';
   rep.render(psprinter,ttextstream.create(tmpfile,fm_create));
   b1:= false;
   if info1^.psfile <> '' then begin
    b1:= true;
    s1:= expandprojectmacros(info1^.psfile);
    createdirpath(filedir(filepath(s1)));
    copyfile(tmpfile,s1);
    tmpfile:= s1;
   end;
   if info1^.pdffile <> '' then begin
    ps2pdf(tmpfile,expandprojectmacros(info1^.pdffile));
   end;
   showpsfile(tmpfile,b1);
  end;
 finally
  deletedir(tmpf);
  endpy();
  rep.destroy();
  bommo.bomds.active:= false;
 end;
end;

procedure tmainmo.docusetev(const sender: TObject);
begin
 createdocuset();
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
 fhostname:= 'localhost';
 fdatabasename:= 'stock';
 fpsviewer:= 'kpdf';
 fps2pdf:= 'ps2pdf';
end;

destructor tglobaloptions.destroy();
var
 i1: int32;
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
  docupagesetlength(fdocudefines[i1].pages,0);
 end;
 fdocudefines:= avalue;
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
var
 count1,count2: int32;
 i1,i2: int32;
 s1: msestring;
 kind1: docupagekindty;
 page1: tdocupage;
 ar1: docuinfoarty;
begin
 ar1:= nil; //compiler warning
 inherited;
 if reader.beginlist('prodplotstack') then begin
  count1:= 0;
  while reader.beginlist('item'+inttostrmse(count1)) do begin
   additem(fprodplotdefines,typeinfo(fprodplotdefines),count1);
   with fprodplotdefines[count1-1] do begin
    readinfoheader(reader,h);
    productiondir:= reader.readmsestring('productiondir','');
    createproductionzipfile:= reader.readboolean('createproductionzip',false);
    productionzipfilename:= reader.readmsestring('productionzipfile','');
    productionzipdir:= reader.readmsestring('productionzipdir','');
    layernames:= reader.readarray('layernames',msestringarty(nil));
    plotfiles:= reader.readarray('plotfiles',msestringarty(nil));
    plotformats:= reader.readarray('plotformats',integerarty(nil));
    layeranames:= reader.readarray('layeranames',msestringarty(nil));
    layerbnames:= reader.readarray('layerbnames',msestringarty(nil));
    nonplated:= reader.readarray('nonplated',booleanarty(nil));
    drillfiles:= reader.readarray('drillfiles',msestringarty(nil));
    for i1:= 0 to high(plotformats) do begin
     i2:= plotformats[i1];
     if (i2 < 0) or (i2 > ord(high(fileformatty))) then begin
      plotformats[i1]:= 0;
     end;
    end;
    i1:= high(layernames);
    if i1 > high(plotfiles) then begin
     i1:= high(plotfiles);
    end;
    if i1 > high(plotformats) then begin
     i1:= high(plotformats);
    end;
    inc(i1);
    setlength(layernames,i1);
    setlength(plotfiles,i1);
    setlength(plotformats,i1);

    i1:= high(layeranames);
    if i1 > high(layerbnames) then begin
     i1:= high(layerbnames);
    end;
    if i1 > high(nonplated) then begin
     i1:= high(nonplated);
    end;
    if i1 > high(drillfiles) then begin
     i1:= high(drillfiles);
    end;
    inc(i1);
    setlength(layeranames,i1);
    setlength(layerbnames,i1);
    setlength(nonplated,i1);
    setlength(drillfiles,i1);
   end;
   reader.endlist();
  end;
  reader.endlist();
  setlength(fprodplotdefines,count1);
  prodplotdefines:= fprodplotdefines; //build name array
 end;
 if reader.beginlist('docustack') then begin
  count1:= 0;
  while reader.beginlist('item'+inttostrmse(count1)) do begin
   additem(ar1,typeinfo(ar1),count1);
   with ar1[count1-1] do begin
    readinfoheader(reader,h);
    docudir:= reader.readmsestring('docudir','');
    psfile:= reader.readmsestring('psfile','');
    pdffile:= reader.readmsestring('pdffile','');
    if reader.beginlist('pages') then begin
     count2:= 0;
     while reader.beginlist('item'+inttostrmse(count2)) do begin
      s1:= reader.readmsestring('kind','');
      for kind1:= high(kind1) downto low(kind1) do begin
       if s1 = docupageenums[kind1] then begin
        break;
       end;
      end;
      if (kind1 <> dpk_none) then begin
       additem(pointerarty(pages),docupageclasses[kind1].create);
       pages[high(pages)].readstat(reader,'');
      end;
      reader.endlist();
      inc(count2);
     end;
     reader.endlist();
    end;
    {
    titles:= reader.readarray('titles',msestringarty(nil));
    pagekinds:= reader.readarray('pagekinds',integerarty(nil));
    if reader.beginlist('layerplots') then begin
     count2:= 0;
     while reader.beginlist('item'+inttostrmse(count2)) do begin
      additem(layerplots,typeinfo(layerplots),count2);
      with layerplots[count2-1] do begin
       layername:= reader.readmsestring('layername','');
      end;
      reader.endlist();
     end;
     reader.endlist();
     setlength(layerplots,count2);
    end;
    if reader.beginlist('schematicplots') then begin
     count2:= 0;
     while reader.beginlist('item'+inttostrmse(count2)) do begin
      additem(schematicplots,typeinfo(schematicplots),count2);
      with schematicplots[count2-1] do begin
       psfile:= reader.readmsestring('psfile','');
      end;
      reader.endlist();
     end;
     reader.endlist();
     setlength(schematicplots,count2);
    end;
    }
   end;
   reader.endlist();
  end;
  reader.endlist();
  setlength(ar1,count1);
  docudefines:= ar1; //build name array
 end;
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
    writer.writearray('plotfiles',plotfiles);
    writer.writearray('plotformats',plotformats);
    writer.writearray('layeranames',layeranames);
    writer.writearray('layerbnames',layerbnames);
    writer.writearray('nonplated',nonplated);
    writer.writearray('drillfiles',drillfiles);
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
    writer.beginlist('pages');
    for i2:= 0 to high(pages) do begin
     writer.beginlist('item'+inttostrmse(i2));
     pages[i2].writestat(writer,'');
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

{ tdocupage }

constructor tdocupage.create();
begin
 //dummy
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

class function tlayerplotpage.getpagekind: docupagekindty;
begin
 result:= dpk_layerplot;
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

initialization
 globaloptions:= tglobaloptions.create();
 projectoptions:= tprojectoptions.create();
finalization
 projectoptions.free();
 globaloptions.free();
end
.
