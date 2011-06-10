{*********************************************************}
{                Tree Report Template                     }
{*********************************************************}
{            Copyright (c) 2011 Sri Wahono                }
{*********************************************************}
{ License Agreement:                                      }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the Repaz libraries and packages are }
{ distributed under the Library GNU General Public        }
{ License with the following  modification:               }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library.                          }
{                                                         }
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{                http://www.msegui.org/repaz              }
{                                                         }
{*********************************************************}
const
 defaulttreegap = 21;
type

 treeheaderty = record
  keystr: msestring;
  keynum: int64;
  parentstr: msestring;
  parentnum: int64;
  indextree: integer;
 end;
 treeheaderarty= array of treeheaderty;
  
 summarytabsarty = array of TSummaryTabs;
 
 TraTreeBand = class;
 
 TraTreeTabulators = class(TraTabulators,idbeditinfo)
  private
   fkeyfieldlink: tfielddatalink;
   fparentfieldlink: tfielddatalink;
   ftreeheader: treeheaderarty;
   findextree: integer;
   fprintifnochild: boolean;
   
   function getkeyfield: string;
   procedure setkeyfield(const avalue: string);
   function getparentfield: string;
   procedure setparentfield(const avalue: string);
   procedure setdatasource(const avalue: string);override;
   //idbeditinfo
   function getdataset(const aindex: integer): tdataset; overload;
   procedure getfieldtypes(out apropertynames: stringarty;
                           out afieldtypes: fieldtypesarty);
  protected
   procedure init;override;
  public
   constructor create(const aowner: TraReportTemplate); override;
   destructor destroy; override;
   procedure assign(source: tpersistent);override;
   procedure dobeforenextrecord(const adatasource: tdatasource);override;
   procedure nextrecord;override;
   procedure checklevel;
   property keyfieldlink: tfielddatalink read fkeyfieldlink;
   property parentfieldlink: tfielddatalink read fparentfieldlink;
   property treeheader: treeheaderarty read ftreeheader write ftreeheader;
   property indextree: integer read findextree write findextree;
  published
   property Tree_KeyField: string read getkeyfield write setkeyfield;
   property Tree_ParentField: string read getparentfield write setparentfield;
   property PrintIfNoChild: boolean read fprintifnochild write fprintifnochild;
   property DataSource;
   property Zebra_Color;
   property Zebra_Start;
   property Zebra_Height;
   property Zebra_Step;
   property Zebra_Options;
 end;
 
 TraTreeBand = class(tvirtualpersistent,idbeditinfo,idbparaminfo)
  private
   fowner: TraReportTemplate;
   fheader: TraTreeTabulators;
   fdata: TNormalTabs;
   fheaderdetail: TNormalTabs;
   ffooter,ffooter2: TSummaryTabs;
   ftreegap: real;
   ftreecol: integer;
   ffooterarty: summarytabsarty;
   fkeyheader: string;
   fparamname: string;
   fprintdetail: boolean;
   
  protected
   //idbeditinfo
   function getdataset(const aindex: integer): tdataset; overload;
   procedure getfieldtypes(out apropertynames: stringarty;
                           out afieldtypes: fieldtypesarty);
   //idbparaminfo
   function getdestdataset: tsqlquery;
  public
   constructor create(const aowner: TraReportTemplate); reintroduce;
   destructor destroy; override;
   procedure assign(source: tpersistent);override;
   property footerarty: summarytabsarty read ffooterarty write ffooterarty;
  published
   property TreeColIndex: integer read ftreecol write ftreecol;
   property TreeGap: real read ftreegap write ftreegap;
   property MasterHeader: TraTreeTabulators read fheader write fheader;
   property MasterFooter: TSummaryTabs read ffooter write ffooter;
   property Footer: TSummaryTabs read ffooter2 write ffooter2;
   property Detail: TNormalTabs read fdata write fdata;
   property PrintDetail: boolean read fprintdetail write fprintdetail;
   property HeaderDetail: TNormalTabs read fheaderdetail write fheaderdetail;
   property KeyFieldHeader: string read fkeyheader write fkeyheader;
   property DetailParams: string read fparamname write fparamname;
 end;   
 
 TraTreeContent = class(tpersistentarrayprop)
  private
   fowner: TraReportTemplate;
   fisfinishdata,isdrawheader: boolean;
   fpreviewing: boolean;
   fmodfooter: integer;
   treepos,delta: real;
   fdatanumber: integer;
   factivefooterkey: variant;
   factiveheaderkey: variant;
   
   function gettreeitems(index: integer): TraTreeBand;
   procedure settreeitems(index: integer; const value: TraTreeBand);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
   procedure adddatasets(var adatasets: datasetarty);
   procedure init(aindex:integer);
  public
   constructor create(const aowner: TraReportTemplate);
   destructor destroy; override;
   property datanumber: integer read fdatanumber;
   procedure createfooter(const aindex:integer);
   procedure paint(const aindex:integer; var posy:integer; const canvas: tcanvas;const area:rectty);
   function build(const aindex:integer; var posy: integer; const canvas: tcanvas;
    const area:rectty; var islastpage: boolean):integer;
   procedure insert(const index: integer; const aitem: TraTreeBand); overload;
   property items[index: integer]: TraTreeBand read gettreeitems write settreeitems; default;
   property activefooterkey: variant read factivefooterkey;
   property activeheaderkey: variant read factiveheaderkey;
 end;   

 TraTreeReport = class(TraReportTemplate)
  private
   fcontent: TraTreeContent;
   findexbuild,posy: integer;
   fcontinuetree: boolean;
   
  protected
   function getauthor:msestring;override;
   procedure endbuild; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure drawcontent(const canvas: tcanvas;const contentarea:rectty);override;
   function buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;override;
   procedure addcontentdatasets(var adatasets: datasetarty);override;
   procedure contentinit; override;
   procedure contentupdatelinks; override;
   procedure setcontentpixelperunit(const avalue: real);override;
   function treeheadervalue(indexrow: integer; indexcol:integer): variant;
   function treefootervalue(indexrow: integer; indexcol:integer; indextree: integer=0): variant;
   function treefootervalue2(indexcol:integer; indextree: integer=0): variant;
   function treedatavalue(indexcol:integer): variant;
   function recordnumber: integer;override;
   function datanumber: integer;override;
   function treenumber: integer;
   function footertreekey: variant;
   function headertreekey: variant;
   property indexbuild: integer read findexbuild write findexbuild;
   property continuetree: boolean read fcontinuetree write fcontinuetree;
   procedure contentgetpickobjects(const sender: tobjectpicker; var objects: integerarty); override;
   procedure contentendpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                          const aoffset: pointty; const aobjects: integerarty); override;
  published
   property Page_Header_RowValues;
   property Page_Header_Height;
   property Page_Footer_RowValues;
   property Page_Footer_Height;
   property Report_Header_RowValues;
   property Report_Header_Height;
   property Report_Header_Show;
   property Report_Footer_RowValues;
   property Report_Footer_Height;
   property Report_Footer_Show;
   property Report_Footer_Options;
   property Report_Tree: TraTreeContent read fcontent write fcontent;
 end;
