{*********************************************************}
{                Grouping Report Template                 }
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

type

 TGroupItem = class(tvirtualpersistent,idbeditinfo)
  protected
   fdatalink: tmsedatalink;
   fgrouplink: tfielddatalink;
   fgroupnum: int64;
   fgroupstring: msestring;
   flastgroupnum: int64;
   flastgroupstring: msestring;
   fheaderindex,ffooterindex: integer;
   fgroupnumber: integer;
   function getgroupfield: string;
   procedure setgroupfield(const avalue: string);
   //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource; overload;
   procedure getfieldtypes(out apropertynames: stringarty;
                           out afieldtypes: fieldtypesarty);
  public
   constructor create(const aowner: TraTabulators);reintroduce;
   destructor destroy;override;
   procedure assign(source: tpersistent);override;
   function isgroupchanged: boolean;
   property grouplink: tfielddatalink read fgrouplink;
   property datalink: tmsedatalink read fdatalink;
   property groupnumber: integer read fgroupnumber write fgroupnumber;
  published
   property GroupField: string read getgroupfield write setgroupfield;
   property GroupHeaderIndex: integer read fheaderindex write fheaderindex;
   property GroupFooterIndex: integer read ffooterindex write ffooterindex;
 end;

 TGroupCol = class(tpersistentarrayprop)
  private
   fowner: TraTabulators;
   function getgroupitems(index: integer): TGroupItem;
   procedure setgroupitems(index: integer; const value: TGroupItem);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: TraTabulators);
   destructor destroy; override;
   procedure insert(const index: integer; const aitem: TGroupItem); overload;
   property items[index: integer]: TGroupItem read getgroupitems write setgroupitems; default;
 end;

 TraGroupTabulators = class(TraTabulators)
  private
   fgroupcols: TgroupCol;
   procedure setdatasource(const avalue: string);override;
  protected
   procedure init;override;
  public
   constructor create(const aowner: TraReportTemplate); override;
   destructor destroy; override;
   procedure dobeforenextrecord(const adatasource: tdatasource);override;
   procedure nextrecord;override;
   procedure prevrecord;
  published
   property GroupFields: TgroupCol read fgroupcols write fgroupcols;
   property DataSource;
   property Zebra_Color;
   property Zebra_Start;
   property Zebra_Height;
   property Zebra_Step;
   property Zebra_Options;
 end;
 
 TraGroupContent = class(toptionalpersistent)
 private
  fowner: TraReportTemplate;
  fheader: TNormalTabsCol;
  fdata: TraGroupTabulators;
  ffooter: TSummaryTabsCol;
  fdataheader: TNormalTabs;
  fmodfooter,minchanged: integer;
  fdatanumber: integer;
 public
  constructor create(const aowner: TraReportTemplate); reintroduce; overload;
  destructor destroy; override;
  procedure paint(const canvas: tcanvas;const area:rectty);
  function build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
  procedure adddatasets(var adatasets: datasetarty);
  procedure init;
  procedure updatelinks;
  function groupnumber(aindex: integer): integer;
  property datanumber: integer read fdatanumber;
 published
  property GroupHeader: TNormalTabsCol read fheader write fheader;
  property GroupFooter: TSummaryTabsCol read ffooter write ffooter;
  property GroupData_Data: TraGroupTabulators read fdata write fdata;
  property GroupData_DataHeader: TNormalTabs read fdataheader write fdataheader;
 end;   

 TraGroupReport = class(TraReportTemplate)
  private
   fcontent: TraGroupContent;   
  protected
   function getauthor:msestring;override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure drawcontent(const canvas: tcanvas;const contentarea:rectty);override;
   function buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;override;
   procedure addcontentdatasets(var adatasets: datasetarty);override;
   procedure contentinit; override;
   procedure contentupdatelinks; override;
   procedure setcontentpixelperunit(const avalue: real);override;
   function groupheadervalue(indexrow: integer; indexcol:integer): variant;
   function groupfootervalue(indexrow: integer; indexcol:integer): variant;
   function groupdatavalue(indexcol:integer): variant;
   function recordnumber: integer;override;
   function datanumber: integer;override;
   function groupnumber(aindex: integer): integer;
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
   property Report_Content: TraGroupContent read fcontent write fcontent;
 end;
