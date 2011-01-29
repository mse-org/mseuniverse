{*********************************************************}
{                   Multi Table Report Template           }
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
 hmultitableshowty = (hmbs_FirstRowOnly,hmbs_EveryTopOfPage);
 fmultitableshowty = (fmbs_LastRowOnly,fmbs_EveryBottomOfPage);
 fmultitableoptionty = (fmbo_PrintOnBottomPage,fmbo_ResetEveryPage);
 fmultitableoptionsty = set of fmultitableoptionty;
 
const
 defaultfmultitableoptions = [fmbo_PrintOnBottomPage,fmbo_ResetEveryPage];

type
 TraTable = class(toptionalpersistent)
 private
  fheader: TNormalTabsCol;
  fdata: TNormalTabsCol;
  ffooter: TSummaryTabsCol;
  fheaderheight: real;
  ffooterheight: real;
  fheadershow: hmultitableshowty;
  ffootershow: fmultitableshowty;
  fowner: TraReportTemplate;
  ffooteroptions: fmultitableoptionsty;
  fdatanumber: integer;
  flastposy: integer;
  fprintifempty: boolean;
  ftableheight: real;
 public
  constructor create(const aowner: TraReportTemplate); reintroduce; overload;
  destructor destroy; override;
  procedure assign(source: tpersistent); override;
  procedure paint(const canvas: tcanvas;const area:rectty);
  function build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
  procedure adddatasets(var adatasets: datasetarty);
  procedure init;
  procedure updatelinks;
  property datanumber: integer read fdatanumber;
  property lastybuild: integer read flastposy write flastposy;
 published
  property PrintIfEmpty: boolean read fprintifempty write fprintifempty default true;
  property TableHeight: real read ftableheight write ftableheight;
  property Header_RowValues: TNormalTabsCol read fheader write fheader;
  property Header_Height: real read fheaderheight write fheaderheight;
  property Header_Show: hmultitableshowty read fheadershow write fheadershow default hmbs_EveryTopOfPage;
  property Footer_RowValues: TSummaryTabsCol read ffooter write ffooter;
  property Footer_Height: real read ffooterheight write ffooterheight;
  property Footer_Show: fmultitableshowty read ffootershow write ffootershow default fmbs_EveryBottomOfPage;
  property Footer_Options: fmultitableoptionsty read ffooteroptions write ffooteroptions default defaultfmultitableoptions;
  property Data_RowValues: TNormalTabsCol read fdata write fdata;
 end;   

 TMultiTableItem = class(tvirtualpersistent)
  protected
   ftable: TraTable;
  public
   constructor create(const aowner: TraReportTemplate);reintroduce;
   destructor destroy;
   procedure assign(source: tpersistent); override;
  published
   property Table: TraTable read ftable write ftable;
 end;

 TMultiTableCol = class(tpersistentarrayprop)
  private
   fowner: TraReportTemplate;
   function getmultitableitems(index: integer): TMultiTableItem;
   procedure setmultitableitems(index: integer; const value: TMultiTableItem);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: TraReportTemplate);
   destructor destroy; override;
   procedure setpixelperunit(const avalue: real);
   procedure insert(const index: integer; const aitem: TMultiTableItem); overload;
   property items[index: integer]: TMultiTableItem read getmultitableitems write setmultitableitems; default;
 end;

 TraMultiTableReport = class(TraReportTemplate)
  private
   fmultitable: TMultiTableCol;   
   ftableindex: integer;
   fpicktable: integer;
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
   function tableheadervalue(tableindex:integer;indexrow:integer;indexcol:integer): variant;
   function tablefootervalue(tableindex:integer;indexrow:integer;indexcol:integer): variant;
   function contentdatavalue(indexcol:integer): variant;
   function recordnumber: integer;override;
   function datanumber: integer;override;
   property tableindex: integer read ftableindex write ftableindex;
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
   property Report_MultiTable: TMultiTableCol read fmultitable write fmultitable;
 end;
