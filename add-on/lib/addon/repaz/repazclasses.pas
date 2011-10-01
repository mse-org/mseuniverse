{*********************************************************}
{                   Repaz Core Classes                    }
{             Core classes and interfaces                 }
{  Base idea from msereport written by :  Martin Schreiber}
{*********************************************************}
{            Copyright (c) 2008-2011 Sri Wahono           }
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
unit repazclasses;
{$ifdef FPC}{$mode objfpc}{$h+}{$GOTO ON}{$interfaces corba}{$endif}
interface
uses
 mseclasses,classes,msegui,msegraphics,msetypes,msewidgets,msegraphutils,
 msestream,msearrayprops,mseguiglob,repazdialog,repazlookupbuffers,
 msedrawtext,msestrings,msedb,db,mseobjectpicker,msestat,msestatfile,
 msepointer,mseevent,mselookupbuffer,mseformatstr,msqldb,repaztypes,
 mseglob,msesys,repazdatasources,typinfo,universalprinter,universalprintertype,msestockobjects,
 repazglob,repazpreviewform,msesqldb,repazchart,barcode,msearrayutils,
 variants,msebitmap,mseformatbmpicoread,mseformatjpgread,repazevaluator,mseforms,
 mseformatpngread,mseformatpngwrite,mseformatjpgwrite,msedock,repazdesign;
 
const
 frepazversion = '1.1.0'; //x.y.z = Major.Minor.Revision
 defaultreportactions = [ra_save,ra_print,ra_preview,ra_design,ra_showdialog];
 defaultreppixelpermm = (1/25.4)*72;
 defaultreppixelperinch = 72;
 defaultreppagewidth = 215.9; //mm
 defaultreppageheight = 279.4; //mm
 defaultrepfontsize = 10;
 defaultrepfontname = 'Tahoma';
 defaulttabsheight = 21; //pixel
 defaulttextmargin = 3; //pixel
 tabpickthreshold = 3;
 defpixelperchar = 7;
  
 defaultrepfontcolor = cl_black;
  
 defaultreportoptions = [];
 defaultborderwidth = 0;
 defaultbordercolor = cl_black;
 defaultbordercapstyle = cs_projecting;
 defaultborderlinestyle = ls_Solid;
 defaultborderinfo: borderty = 
   (linewidth: defaultborderwidth; 
    linecolor: defaultbordercolor;
    capstyle: defaultbordercapstyle;
    linestyle: defaultborderlinestyle);
 defaultfreportoptions = [fro_PrintOnBottomPage];
type
 TraReportTemplate = class;
 TraPage = class;
 TRepaz = class;

 ireport = interface(inullinterface)
  function getreport: TRepaz;
  procedure previewdestroyed(const avalue:boolean);
  procedure designdestroyed(const avalue:boolean);
 end;
 templatearty = array of TraReportTemplate;
 
//event declarations
 buildeventty = procedure(const sender: tobject;const acanvas: tcanvas) of object;
 synceventty = procedure() of object;
 reporteventty = procedure(const sender: TRepaz) of object;
 bandareaeventty = procedure(const sender: TraReportTemplate) of object;
 bandareapainteventty = procedure(const sender: TraReportTemplate;
                              const acanvas: tcanvas) of object;
 reportpageeventty = procedure(const sender: TraPage) of object;
 reportchangeunitty = procedure(const avalue: raunitty) of object;
 reportpagepainteventty = procedure(const sender: TraPage;
                              const acanvas: tcanvas) of object;
 beforebuildpageeventty = procedure(const sender: TraPage;
                                          var empty: boolean) of object; 
  
 TraTabulatorItem = class;
   
 TraTabulators = class;
 
 TraTabulatorItem = class(townedpersistent,idbeditinfo,ilbfieldinfo)
  private
   ftext: msestring;
   fvalue: variant;
   fbitmapstr: ansistring;
   fdatalink: tfielddatalink;
   fdatasourcestr,flookupbufferstr: string;
   flookupbuffer: tcustomlookupbuffer;
   flookupkeyfieldno: integer;
   flookupvaluefieldno: integer;
   flookupkind,fkeykind: lookupkindty;
   fformat: msestring;
   fcolor: colorty;
   frawfont: rawfontty;
   frawcharpos: integer;
   frawcharwidth: integer;
   fexpression: msestring;
   fleftmargin,frightmargin: real;
   fbold,fitalic,funderline,fstrikeout: boolean;
   fhalign: halignmentty;
   fvalign: valignmentty;
   ffontname: string;
   ffontsize: integer;
   ffontcolor: colorty;
   fbitmap: tmaskedbitmap;
   fellipse : textellipsety;
   ftextoptions: textoptionsty;
   falignment: alignmentsty;
   fborderleft: borderty;
   fborderright: borderty;
   fbordertop: borderty;
   fborderbottom: borderty;
   ffontstyle: fontstylesty;
   fmodul: integer;
   fbarcodetype: barcodety;
   fchecksum: boolean;
   fbarcoderotation: integer;
   fbarcodecolor: colorty;
   fbarcoderatio: double;

   function isstorefontname:boolean;
   procedure processvalue;virtual;
   function getdatasource1: string;
   function getdatafield: string;
   function getlookupbuffer: string;
               //idbeditinfo
   function getdataset(const aindex: integer): tdataset;
   procedure getfieldtypes(out apropertynames: stringarty;
                           out afieldtypes: fieldtypesarty);

  //ilbfieldinfo
   function getlbdatakind(const apropname: string): lookupkindty;
   function getlb: tcustomlookupbuffer;

   procedure setlookupbuffer(const avalue: string);
   procedure setdatafield(const avalue: string);
   procedure setdatasource(const avalue: string);
   procedure updatelinks;

   procedure setbordertopwidth(const avalue: real);
   procedure setbordertopcolor(const avalue: colorty);
   procedure setbordertopcapstyle(const avalue: capstylety);
   procedure setbordertoplinestyle(const avalue: linestylety);

   procedure setborderleftwidth(const avalue: real);
   procedure setborderleftcolor(const avalue: colorty);
   procedure setborderleftcapstyle(const avalue: capstylety);
   procedure setborderleftlinestyle(const avalue: linestylety);

   procedure setborderrightwidth(const avalue: real);
   procedure setborderrightcolor(const avalue: colorty);
   procedure setborderrightcapstyle(const avalue: capstylety);
   procedure setborderrightlinestyle(const avalue: linestylety);

   procedure setborderbottomwidth(const avalue: real);
   procedure setborderbottomcolor(const avalue: colorty);
   procedure setborderbottomcapstyle(const avalue: capstylety);
   procedure setborderbottomlinestyle(const avalue: linestylety);
   
   procedure setlookupkeyfieldno(const avalue: integer);
   procedure setlookupvaluefieldno(const avalue: integer);
   procedure setkeykind(const avalue: lookupkindty);
   procedure setlookupkind(const avalue: lookupkindty);
   procedure settext(const avalue: msestring);
   procedure setvalue(const avalue: variant);
   procedure setexpression(const avalue: msestring);
   procedure setformat(const avalue: msestring);
   procedure setcolor(avalue: colorty);
   procedure setfontname(avalue: string);
   procedure setfontsize(avalue: integer);
   procedure setfontcolor(avalue: colorty);
   procedure setpos(const avalue: real);
   procedure setwidth(const avalue: real);
   procedure setleftmargin(const avalue: real);
   procedure setrightmargin(const avalue: real);
   procedure setbold(const avalue: boolean);
   procedure setitalic(const avalue: boolean);
   procedure setunderline(const avalue: boolean);
   procedure setstrikeout(const avalue: boolean);
   procedure sethalign(const avalue: halignmentty);
   procedure setvalign(const avalue: valignmentty);
   procedure setbitmap(const Value: tmaskedbitmap);
  protected
   fpos,fwidth: real;
   procedure evalexpression(const aexpression: msestring);
   function getexpressionresult: variant;
   function istextstored: boolean;
   procedure dobeforenextrecord(const adatasource: tdatasource);virtual;
  public 
   constructor create(aowner: tobject); override;
   destructor destroy; override;
   procedure assign(source: TPersistent);override;
   procedure changed;
   property reallookupbuffer : tcustomlookupbuffer read flookupbuffer;
   property datalink: tfielddatalink read fdatalink write fdatalink;
   property BitmapString: ansistring read fbitmapstr write fbitmapstr;
   property Value: variant read fvalue write setvalue;
   property fontstyle: fontstylesty read ffontstyle write ffontstyle;
  published
   property DataSource: string read getdatasource1 write setdatasource;
   property Bitmap: tmaskedbitmap read fbitmap write setbitmap;
   property BitmapFieldAlignment: alignmentsty read falignment write falignment default [];
   property Expression: msestring read fexpression write setexpression;
   property Text: msestring read ftext write settext stored istextstored;
   property RAW_Font: rawfontty read frawfont write frawfont default rfNormal;
   property RAW_WidthInChar: integer read frawcharwidth write frawcharwidth;
   property RAW_PosInChar: integer read frawcharpos write frawcharpos;
   property Color: colorty read fcolor write setcolor default cl_transparent;
   property Font_Bold: boolean read fbold write setbold default false;
   property Font_Italic: boolean read fitalic write setitalic default false;
   property Font_UnderLine: boolean read funderline write setunderline default false;
   property Font_StrikeOut: boolean read fstrikeout write setstrikeout default false;
   property Font_Name: string read ffontname write setfontname stored isstorefontname;
   property Font_Size: integer read ffontsize write setfontsize default defaultrepfontsize;
   property Font_Color: colorty read ffontcolor write setfontcolor default defaultrepfontcolor;
   property Margin_Left: real read fleftmargin write setleftmargin; // default 0;
   property Margin_Right: real read frightmargin write setrightmargin; // default 0;
   property Alignment_Horizontal: halignmentty read fhalign write sethalign default ha_Left;
   property Alignment_Vertical: valignmentty read fvalign write setvalign default va_Center;
   property Position: real read fpos write setpos;
   property Width: real read fwidth write setwidth;
   property Ellipse: textellipsety read fellipse write fellipse;
   property TextOptions : textoptionsty read ftextoptions write ftextoptions;
   property DataField: string read getdatafield write setdatafield;
   property Lookup_Buffer: string read getlookupbuffer write setlookupbuffer;
   property Lookup_KeyFieldNo: integer read flookupkeyfieldno write setlookupkeyfieldno default 0;
   property Lookup_ValueFieldNo: integer read flookupvaluefieldno write setlookupvaluefieldno default 0;
   property Lookup_ValueType: lookupkindty read flookupkind write setlookupkind default lk_Text;
   property Lookup_KeyType: lookupkindty read fkeykind write setkeykind default lk_Text;
   property Format: msestring read fformat write setformat;
   property Barcode_Modul:integer read fmodul write fmodul;
   property Barcode_Type:barcodety read fbarcodetype write fbarcodetype default bcCodeNone;
   property Barcode_Checksum:boolean read fchecksum write fchecksum default false;
   property Barcode_Rotation:integer read fbarcoderotation write fbarcoderotation default 0;
   property Barcode_Color:colorty read fbarcodecolor write fbarcodecolor default cl_black;
   property Barcode_Ratio: double read fbarcoderatio write fbarcoderatio;
   
   property Border_Top_Width: real read fbordertop.linewidth write setbordertopwidth;
   property Border_Top_Color: colorty read fbordertop.linecolor write setbordertopcolor default defaultbordercolor;
   property Border_Top_CapStyle: capstylety read fbordertop.capstyle write setbordertopcapstyle default defaultbordercapstyle;
   property Border_Top_LineStyle: linestylety read fbordertop.linestyle write setbordertoplinestyle;

   property Border_Left_Width: real read fborderleft.linewidth write setborderleftwidth;
   property Border_Left_Color: colorty read fborderleft.linecolor write setborderleftcolor default defaultbordercolor;
   property Border_Left_CapStyle: capstylety read fborderleft.capstyle write setborderleftcapstyle default defaultbordercapstyle;
   property Border_Left_LineStyle: linestylety read fborderleft.linestyle write setborderleftlinestyle;

   property Border_Right_Width: real read fborderright.linewidth write setborderrightwidth;
   property Border_Right_Color: colorty read fborderright.linecolor write setborderrightcolor default defaultbordercolor;
   property Border_Right_CapStyle: capstylety read fborderright.capstyle write setborderrightcapstyle default defaultbordercapstyle;
   property Border_Right_LineStyle: linestylety read fborderright.linestyle write setborderrightlinestyle;

   property Border_Bottom_Width: real read fborderbottom.linewidth write setborderbottomwidth;
   property Border_Bottom_Color: colorty read fborderbottom.linecolor write setborderbottomcolor default defaultbordercolor;
   property Border_Bottom_CapStyle: capstylety read fborderbottom.capstyle write setborderbottomcapstyle default defaultbordercapstyle;
   property Border_Bottom_LineStyle: linestylety read fborderbottom.linestyle write setborderbottomlinestyle;
 end; 
  
 TraTabulatorItemSummary = class(TRaTabulatorItem)
  private
   fsummary: summarytypety;
   fsum: itemsumty;
   fvartype: TVarType;
   function getsumasinteger: integer;
   function getsumaslargeint: int64;
   function getsumasfloat: double;
   function getsumascurrency: currency;
   procedure initsum;
   function getsumcount: integer;
   procedure processvalue; override;
  protected
   procedure dobeforenextrecord(const adatasource: tdatasource);override;
  public
   constructor create(aowner: tobject); override;
   procedure resetsum(const skipcurrent: boolean);
   procedure assign(source: TPersistent);override;
   property sumcount: integer read getsumcount;
   property sumasinteger: integer read getsumasinteger;
   property sumaslargeint: int64 read getsumaslargeint;
   property sumasfloat: double read getsumasfloat;
   property sumascurrency: currency read getsumascurrency;
  published
   property SummaryType: summarytypety read fsummary write fsummary;
 end;
 
 tratabulatoritemclassty = class of TRaTabulatorItem;
 tratabulatoritemsummaryclassty = class of TRaTabulatorItemSummary;

 TraTabulators = class(townedpersistentarrayprop)
  private
   finfo: drawtextinfoty;
   freporttemplate: TraReportTemplate;
   fdatalink: tmsedatalink;
   fZebra_Color: colorty;
   fZebra_Start: integer;
   fZebra_Height: integer;
   fZebra_Step: integer;
   fZebra_Counter: integer;
   fZebra_Options: zebraoptionsty;
   frecordarea: recordareaty;
   fheight: real;
   yposition: integer;
   fbackcolor: colorty;
   fpixelperunit: real;
   frawlinebelow: integer;
   fdatasourcestr: string;

   function getpixelheight: integer;
   function getitems(const index: integer): TraTabulatorItem;
   procedure setitems(const index: integer; const avalue: TraTabulatorItem);
   function getdatasource: string;
   procedure setdatasource(const avalue: string);virtual;
   procedure processvalues(const acanvas: tcanvas; const adest: rectty;
     const aresetsum: boolean; const isbuilding:boolean);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
   class function getitemclass: tratabulatoritemclassty;
   procedure dochange(const aindex: integer); override;
   procedure initsums;
   procedure updatelinks;
   procedure init;virtual;
  public
   constructor create(const aowner: TraReportTemplate);reintroduce;virtual;
   destructor destroy; override;
   procedure assign(source: tpersistent); override;
   procedure setpixelperunit(const avalue: real);
   procedure dobeforenextrecord(const adatasource: tdatasource);virtual;
   procedure nextrecord;virtual;
   procedure paintextend(const acanvas: tcanvas; const adest: rectty;
     const isbuilding:boolean;const aleft:boolean;const aright:boolean;const atop:boolean;const abottom:boolean);
   procedure paint(const acanvas: tcanvas; const adest: rectty;
     const isbuilding:boolean;const aresetsum: boolean);
   function drawzebra(const acanvas: tcanvas; const adest: rectty):boolean;
   procedure drawlimittabs(const acanvas: tcanvas; const adest: rectty);
   procedure resetzebra;
   procedure initpage;
   function iseof: boolean;
   function recordcount: integer;
   procedure resetsums(const skipcurrent: boolean);
   property items[const index: integer]: TraTabulatorItem read getitems 
                       write setitems; default;
   property RecordArea: recordareaty read frecordarea write frecordarea;
   property Zebra_Counter: integer read fZebra_Counter write fZebra_Counter;
   property Zebra_Color: colorty read fZebra_Color write fZebra_Color default cl_ltgray;
   property Zebra_Start: integer read fZebra_Start write fZebra_Start default 0;
   property Zebra_Height: integer read fZebra_Height write fZebra_Height default 0;
   property Zebra_Step: integer read fZebra_Step write fZebra_Step default 2;
   property Zebra_Options: zebraoptionsty read fZebra_Options 
                                         write fZebra_Options default [];
   property DataSource: string read getdatasource write setdatasource;
   property datalink: tmsedatalink read fdatalink;
   property PixelPerUnit: real read fpixelperunit;
   property PixelHeight: integer read getpixelheight;
   property reporttemplate: TraReportTemplate read freporttemplate;
 published
   property BackColor: colorty read fbackcolor write fbackcolor default cl_transparent;
   property Height: real read fheight write fheight;
   property RAW_EmptyLinesBelow: integer read frawlinebelow write frawlinebelow default 0;
 end;
   
type                       

 TSummaryTabs = class(TraTabulators)
  protected
   function getitemssummary(const index: integer): TraTabulatorItemSummary;
   procedure setitemssummary(const index: integer; const avalue: TraTabulatorItemSummary);
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: TraReportTemplate); override;
   class function getitemclass: tratabulatoritemsummaryclassty;
   property items[const index: integer]: TraTabulatorItemSummary read getitemssummary 
                       write setitemssummary;
  published
   property DataSource;
  end;
  
 TNormalTabs = class(TraTabulators)
  public
   constructor create(const aowner: TraReportTemplate); override;
  published
   property DataSource;
   property Zebra_Color;
   property Zebra_Start;
   property Zebra_Height;
   property Zebra_Step;
   property Zebra_Options;
  end;

 TNormalTabsItem = class(tvirtualpersistent)
  protected
   ftabs: TNormalTabs;
  public
   constructor create(const aowner: TraReportTemplate);reintroduce;
   destructor destroy;
   procedure assign(source: tpersistent); override;
  published
   property Tabulators: TNormalTabs read ftabs write ftabs;
 end;

 TNormalTabsCol = class(tpersistentarrayprop)
  private
   fowner: TraReportTemplate;
   function getnormaltabsitems(index: integer): TNormalTabsItem;
   procedure setnormaltabsitems(index: integer; const value: TNormalTabsItem);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: TraReportTemplate);
   destructor destroy; override;
   procedure assign(source: tpersistent); override;
   procedure setpixelperunit(const avalue: real);
   function getheight: integer;
   procedure insert(const index: integer; const aitem: TNormalTabsItem); overload;
   property items[index: integer]: TNormalTabsItem read getnormaltabsitems write setnormaltabsitems; default;
   property BandHeight: integer read getheight;
 end;

 TSummaryTabsItem = class(tvirtualpersistent)
  protected
   ftabs: TSummaryTabs;
  public
   constructor create(const aowner: TraReportTemplate);reintroduce;
   destructor destroy;
   procedure assign(source: tpersistent); override;
  published
   property Tabulators: TSummaryTabs read ftabs write ftabs;
 end;

 TSummaryTabsCol = class(tpersistentarrayprop)
  private
   fowner: TraReportTemplate;
   function getsummarytabsitems(index: integer): TSummaryTabsItem;
   procedure setsummarytabsitems(index: integer; const value: TSummaryTabsItem);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: TraReportTemplate);
   destructor destroy; override;
   procedure setpixelperunit(const avalue: real);
   function getheight: integer;
   procedure insert(const index: integer; const aitem: TSummaryTabsItem); overload;
   property items[index: integer]: TSummaryTabsItem read getsummarytabsitems write setsummarytabsitems; default;
   property BandHeight: integer read getheight;
 end;
 
 TraReportTemplate = class(twidget,iobjectpicker)
  private
   freportpage: TraPage;
   freportheader: TNormalTabsCol;
   freportheader2: TNormalTabsCol;
   freportfooter: TSummaryTabsCol;
   fpageheader: TNormalTabsCol;
   fpagefooter: TNormalTabsCol;
   freportheaderheight: real;
   freportheader2height: real;
   freportfooterheight: real;
   fpageheaderheight: real;
   fpagefooterheight: real;
   freportheadershow: hreportshowty;
   freportheader2show: hreportshowty;
   freportfootershow: freportshowty;
   freportfooteroptions: freportoptionsty;
   fobjectpicker: tobjectpicker;
   fpixelperunit: real;
   fleft,ftop,fwidth,fheight: real;
   fbitmap: tmaskedbitmap;
   fpickkind, fpickarrayindex, fpicktabindex: integer;
  protected
   function getauthor: msestring;virtual;
   procedure setbitmap(const Value: tmaskedbitmap);
   procedure setparentwidget(const avalue: twidget); override;   
   procedure setcontentpixelperunit(const avalue: real);virtual;
   procedure setpixelperunit(const avalue: real);
   procedure setposleft(const avalue: real);
   procedure setpostop(const avalue: real);
   procedure setareawidth(const avalue: real);
   procedure setareaheight(const avalue: real);
   function getpixelperunit: real;
   procedure endbuild; virtual;
   procedure drawcontent(const canvas: tcanvas;const contentarea:rectty);virtual;
   procedure addcontentdatasets(var adatasets: datasetarty);virtual;
   procedure adddatasets(var adatasets: datasetarty);
   procedure doonpaint(const acanvas: tcanvas); override;
   procedure contentgetpickobjects(const sender: tobjectpicker; var objects: integerarty); virtual;
   procedure contentendpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                          const aoffset: pointty; const aobjects: integerarty); virtual;
      //iobjectpicker
   function getcursorshape(const sender: tobjectpicker; var shape: cursorshapety): boolean;
    //true if found
   procedure getpickobjects(const sender: tobjectpicker; var objects: integerarty); virtual;
   procedure beginpickmove(const sender: tobjectpicker);virtual;
   procedure endpickmove(const sender: tobjectpicker); virtual;
   procedure paintxorpic(const sender: tobjectpicker; const canvas: tcanvas);
   procedure pickthumbtrack(const sender: tobjectpicker);
   procedure cancelpickmove(const sender: tobjectpicker);
   procedure loaded; override;
   procedure sizechanged;override;
   procedure poschanged;override;
   procedure childmouseevent(const sender: twidget; var info: mouseeventinfoty);override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure paint(const canvas: tcanvas); override;
   function buildcontent(const acanvas: tcanvas;const contentarea:rectty;
    var islastpage:boolean):integer; virtual; //result last y print position
   procedure contentinit;virtual;
   procedure contentupdatelinks; virtual;
   procedure build(const acanvas: tcanvas);
   procedure updatelinks;
   function expressiondialog(const aexpression: msestring): msestring;   
   function reportheadervalue(indexrow: integer;indexcol:integer): variant;
   function reportfootervalue(indexrow: integer;indexcol:integer): variant;
   function pageheadervalue(indexrow: integer;indexcol:integer): variant;
   function pagefootervalue(indexrow: integer;indexcol:integer): variant;
   function recordnumber: integer;virtual;
   function masternumber: integer;virtual;
   function datanumber: integer;virtual;
   function pagenum: integer;
   property PixelPerUnit: real read getpixelperUnit write setpixelperunit;
   property reportpage: TraPage read freportpage write freportpage;
  published
   property Page_Header_RowValues: TNormalTabsCol read fpageheader write fpageheader;
   property Page_Header_Height: real read fpageheaderheight write fpageheaderheight;
   property Page_Footer_RowValues: TNormalTabsCol read fpagefooter write fpagefooter;
   property Page_Footer_Height: real read fpagefooterheight write fpagefooterheight;

   property Report_Header_RowValues: TNormalTabsCol read freportheader write freportheader;
   property Report_Header_Height: real read freportheaderheight write freportheaderheight;
   property Report_Header_Show: hreportshowty read freportheadershow write freportheadershow default hrs_FirstPageOnly;
   property Report_ExtraHeader_RowValues: TNormalTabsCol read freportheader2 write freportheader2;
   property Report_ExtraHeader_Height: real read freportheader2height write freportheader2height;
   property Report_ExtraHeader_Show: hreportshowty read freportheader2show write freportheader2show default hrs_FirstPageOnly;
   property Report_Footer_RowValues: TSummaryTabsCol read freportfooter write freportfooter;
   property Report_Footer_Height: real read freportfooterheight write freportfooterheight;
   property Report_Footer_Show: freportshowty read freportfootershow write freportfootershow default frs_LastPageOnly;
   property Report_Footer_Options: freportoptionsty read freportfooteroptions write freportfooteroptions default defaultfreportoptions;
   property Bitmap: tmaskedbitmap read fbitmap write setbitmap;
   property Author: msestring read getauthor;
   property Position_Left: real read fleft write setposleft;
   property Position_Top: real read ftop write setpostop;
   property Area_Width: real read fwidth write setareawidth;
   property Area_Height: real read fheight write setareaheight;
 end; 

 {$i repazsimplereporth.inc}
 {$i repazmultitablereporth.inc}
 {$i repazgroupreporth.inc}
 {$i repaztreereporth.inc}
 {$i repazchartreporth.inc}
 {$i repazletterreporth.inc}
 {$i repazmasterdetailreporth.inc}
 {$i repazlabelreporth.inc}
 
 TraPage = class(twidget)
  private
   ftemplate: templatearty;
   fpagewidth: real;
   fpageheight: real;
   fpixelperunit: real;
   fprintpage: boolean;
   fpagenum: integer;
   fpageorientation: rapageorientationty;
   fpapersize: pagesizety;
   fcansetpapersize: boolean;
   fprintorder: integer;
   funits: raunitty;
   factivetemplate: integer;
   freport: TRepaz;
   
   procedure setpageorientation(const avalue: rapageorientationty);
   procedure setpagewidth(const avalue: real);
   procedure setpageheight(const avalue: real);
   procedure setpapersize(const avalue: pagesizety);
   procedure updatepapersize;
   procedure updatepagesize(const avalue: real);
   procedure setunits(const avalue: raunitty);
   procedure setreport(const avalue: TRepaz);
   procedure setpixelperunit(const avalue: real);
   procedure setprintorder(const avalue: integer);
   procedure setprintpage(const avalue: boolean);
  protected
   procedure registerchildwidget(const child: twidget); override;
   procedure unregisterchildwidget(const child: twidget); override;
   procedure sizechanged; override;
   procedure loaded; override;

   procedure adddatasets(var adatasets: datasetarty);
   
   procedure build;
   function getreppage: TraPage;  
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;   
   procedure insertwidget(const awidget: twidget; const apos: pointty); override;
   procedure updatelinks;
   procedure newpage;
   procedure newpage(const apage: TraPage);
   function reportheadervalue(indexrow: integer;indexcol:integer): variant;
   function reportfootervalue(indexrow: integer;indexcol:integer): variant;
   function pageheadervalue(indexrow: integer;indexcol:integer): variant;
   function pagefootervalue(indexrow: integer;indexcol:integer): variant;
   function contentheadervalue(indexcol:integer): variant;
   function contentfootervalue(indexcol:integer): variant;
   function tableheadervalue(tableindex:integer; indexrow: integer; indexcol:integer): variant;
   function tablefootervalue(tableindex:integer;indexrow:integer;indexcol:integer): variant;
   function contentdatavalue(indexcol:integer): variant;
   function groupheadervalue(indexrow:integer; indexcol:integer): variant;
   function groupfootervalue(indexrow:integer; indexcol:integer): variant;
   function groupdatavalue(indexcol:integer): variant;
   function recordnumber: integer;
   function masternumber: integer;
   function datanumber: integer;
   function footertreekey: variant;
   function headertreekey: variant;
   function treefootervalue(indexrow: integer; indexcol:integer; indextree: integer=0): variant;
   function treefootervalue2(indexcol:integer; indextree: integer=0): variant;
   function lettervalue(indexrow: integer; indexcol:integer): variant;
   function groupnumber(aindex: integer): integer;
   property report: TRepaz read freport write setreport;
   property pagenum: integer read fpagenum write fpagenum; 
  published
   property PrintThisPage: boolean read fprintpage write setprintpage default true;   
   property PrintOrder: integer read fprintorder write setprintorder;
   property PaperSize: pagesizety read fpapersize write setpapersize nodefault;
   property PageOrientation: rapageorientationty read fpageorientation 
                write setpageorientation default rpo_Portrait;   
   property PageWidth: real read fpagewidth write setpagewidth;
   property PageHeight: real read fpageheight write setpageheight;
   property ReportUnit: raunitty read funits write setunits default Milimeter;
   property PixelPerUnit: real read fpixelperunit write setpixelperunit; //pixel per mm
 end;
  
  
type 
 reportpagearty = array of TraPage;
 TRepazDesigner = class;
 TPreviewForm = class;
 TRepazDialog = class;
 
 TRepaz = class(tmsecomponent,istatfile,ireport)
  private
   funits: raunitty;
   fpixelperunit: real;
   freportactions: repactionsty;
   foptions: reportoptionsty;
   fversion: string;
   //event
   fonpagebeforebuild: beforebuildpageeventty;
   fonreportstart: reporteventty;
   fonbeforebuild: reporteventty;
   fonafterbuild: reporteventty;
   fonreportfinished: notifyeventty;
   fonafterprinting: notifyeventty;
   fonfirstpage: reportpageeventty;
   fonafterlastpage: reportpageeventty;
   fonprogress: notifyeventty;
   fonbuildfinish: reporteventty;
   foncreate: notifyeventty;
   fondestroy: notifyeventty;
   fondestroyed: notifyeventty;
   fonchangeunit: reportchangeunitty;
   
   fpagenum: integer;
   fcanceled,fprinted: boolean;
   fdialogtext: msestring;
   fdialogcaption,fpreviewcaption,fdesigncaption: msestring;
   fdatasets: datasetarty;
   ffilename: filenamety;
   freportowner: tcomponent;
   frootcomp: tcomponent;
   fprintdestination: printdestinationty;
   isreportfinished,fprinting: boolean;
   fstatfile: tstatfile;
   fstatvarname: msestring;
   factivepage: integer;

   fmetapages: tmetapages;
   frepazevaluator: trepazevaluator;
   fdatasourcesreport: trepazdatasources;
   flookupbufferreport: trepazlookupbuffers;
   fpreviewpanel,fdesignpanel: tdockpanel;

   fmetapagecount: integer;
   fmetatabobjectcount: integer;
   fmetarect1objectcount: integer;
   fmetarect2objectcount: integer;
   fmetabitmap1objectcount: integer;
   fmetabitmap2objectcount: integer;
   fpreviewdialog: TPreviewForm;
   fdesigndialog: trepazdesigner;
   dia: TRepazDialog;
   fpages: pagerangearty;
   fpreviewdestroyed,fdesigndestroyed,fwithdialog: boolean;

   procedure setprintdestination(const avalue: printdestinationty);
   procedure setunits(const avalue: raunitty);
   procedure setfilename(const avalue: filenamety);
   procedure setdatasources(const avalue: trepazdatasources);
   procedure setlookupbuffers(const avalue: trepazlookupbuffers);
   procedure setpreviewpanel(const avalue: tdockpanel);
   procedure setdesignpanel(const avalue: tdockpanel);
   function getevaluator: trepazevaluator;
   function getreppages(index: integer): TraPage;
   procedure setreppages(index: integer; const avalue: TraPage);
   function getfilename: filenamety;
   function getdatasources: trepazdatasources;
   function getlookupbuffers: trepazlookupbuffers;
   function exec: boolean;
   procedure repdisablecontrols;
   procedure repenablecontrols;
   function internalbuild: boolean;
   //for load component from file
   procedure findcomponentclass(Reader: TReader; const aClassName: string;
                   var ComponentClass: TComponentClass);
   procedure createcomponent(Reader: TReader; ComponentClass: TComponentClass;
                   var Component: TComponent);
   procedure readstringproperty(Sender:TObject; const Instance: TPersistent;
    PropInfo: PPropInfo; var Content:string);
   procedure onreferencename(Reader: TReader; var aName: string);
   //end of load component from file
   procedure setstatfile(const avalue: tstatfile);
  protected
   freppages: reportpagearty;
   procedure dopagebeforebuild(const sender: TraPage;
                                          var empty: boolean);
   procedure dofirstpage(const apage:TraPage); //virtual;
   procedure doafterlastpage(const apage:TraPage); //virtual;
   procedure doonreportfinished;
   
   procedure doprogress;
   
   procedure loadfromfile(afilename: filenamety; var isloaded: boolean);
   //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter);
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
   //ireport
   function getreport: TRepaz;
   procedure previewdestroyed(const avalue:boolean);
   procedure designdestroyed(const avalue:boolean);
   procedure setnewmetareportpage(const apage: TraPage);
   procedure createnewmetareport;
   procedure addtabtoreport(const ainfo: reptabinfoty);
   procedure addrect1toreport(const ainfo: reprectinfoty);
   procedure addrect2toreport(const ainfo: reprectinfoty);
   procedure addbitmaptoreport(const arect: rectty; const avalue: tmaskedbitmap);
   procedure addcharttoreport(const arect: rectty; const avalue: TraCustomChart);
   procedure addbitmap1toreport(const arect: rectty; avalue: tmaskedbitmap);
   procedure addbitmap2toreport(const arect: rectty; avalue: tmaskedbitmap);
   function getdatasourcereport(const aname: string): tdatasource;
   function getlookupbufferreport(const aname: string): tcustomlookupbuffer;
  public
   fuprinter: tuniversalprinter;
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure freepages;
   procedure newvariable(variablename:string;value:variant);
   function reportheadervalue(indexrow: integer;indexcol:integer): variant;
   function reportfootervalue(indexrow: integer;indexcol:integer): variant;
   function pageheadervalue(indexrow: integer;indexcol:integer): variant;
   function pagefootervalue(indexrow: integer;indexcol:integer): variant;
   function contentheadervalue(indexcol:integer): variant;
   function contentfootervalue(indexcol:integer): variant;
   function tableheadervalue(tableindex:integer; indexrow:integer; indexcol:integer): variant;
   function tablefootervalue(tableindex:integer; indexrow:integer; indexcol:integer): variant;
   function contentdatavalue(indexcol:integer): variant;
   function groupheadervalue(indexrow:integer; indexcol:integer): variant;
   function groupfootervalue(indexrow:integer; indexcol:integer): variant;
   function groupdatavalue(indexcol:integer): variant;
   function recordnumber: integer;
   function masternumber: integer;
   function datanumber: integer;
   function headertreekey: variant;
   function footertreekey: variant;
   function treefootervalue(indexrow: integer; indexcol:integer; indextree: integer=0): variant;
   function treefootervalue2(indexcol:integer; indextree: integer=0): variant;
   function lettervalue(indexrow: integer; indexcol:integer): variant;
   function groupnumber(aindex: integer): integer;
   procedure addpage(apage: TraPage);
   procedure assign(sender: tpersistent);override;
   function reportdesign: boolean;
   function reportexec: boolean;
   function reportexecute(const usedialog: boolean): boolean;
   function reportpreview: boolean;
   function reportprint(const withdialog: boolean): boolean;
   function reportposprint: boolean;
   function reportcsv: boolean;
   function reporthtml(const extfile: string): boolean;
   function reportpdf: boolean;
   function reportpng: boolean;
   function reportpostscript: boolean;
   procedure savemetapages;
   function reppagecount: integer;
   property reppages[index: integer]: TraPage read getreppages write setreppages; default;
   property pagenum: integer read fpagenum write fpagenum; 
                            //null-based
   property reportpages: reportpagearty read freppages write freppages;
   property reportunit: raunitty read funits write setunits;
   property PixelPerUnit: real read fpixelperunit write fpixelperunit;
   property reportowner: tcomponent read freportowner write freportowner;
   property printed : boolean read fprinted write fprinted;
   property printing : boolean read fprinting write fprinting;
   property universalprinter: tuniversalprinter read fuprinter;
  published
   property activepage: integer read factivepage write factivepage;
   property Version: string read fversion;
   property FileName: filenamety read getfilename write setfilename;
   property ReportAction: repactionsty read freportactions write freportactions{ default defaultreportactions};
   property Options: reportoptionsty read foptions write foptions default defaultreportoptions;
   property PrintDestination: printdestinationty read fprintdestination write setprintdestination;
   property DialogText: msestring read fdialogtext write fdialogtext;
   property DialogCaption: msestring read fdialogcaption write fdialogcaption;
   property DesignCaption: msestring read fdesigncaption write fdesigncaption;
   property PreviewCaption: msestring read fpreviewcaption write fpreviewcaption;
   property DataSources: trepazdatasources read getdatasources write setdatasources;
   property LookUpBuffers: trepazlookupbuffers read getlookupbuffers write setlookupbuffers;
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read fstatvarname write fstatvarname;
   property previewpanel: tdockpanel read fpreviewpanel write setpreviewpanel;
   property designpanel: tdockpanel read fdesignpanel write setdesignpanel;
   property onreportstart: reporteventty read fonreportstart write fonreportstart;
   property onbeforebuild: reporteventty read fonbeforebuild write fonbeforebuild;
   property onafterbuild: reporteventty read fonafterbuild write fonafterbuild;
   property onreportfinished: notifyeventty read fonreportfinished write fonreportfinished;
   property onafterprinting: notifyeventty read fonafterprinting write fonafterprinting;
   property onpagebeforebuild: beforebuildpageeventty read fonpagebeforebuild write fonpagebeforebuild;
   property onprogress: notifyeventty read fonprogress write fonprogress;
   property oncreate: notifyeventty read foncreate write foncreate;
   property ondestroy: notifyeventty read fondestroy write fondestroy;
   property ondestroyed: notifyeventty read fondestroyed write fondestroyed;
   property onfirstpage: reportpageeventty read fonfirstpage write fonfirstpage;
   property onafterlastpage: reportpageeventty read fonafterlastpage write fonafterlastpage;
   property onchangeunit: reportchangeunitty read fonchangeunit write fonchangeunit;
 end;

 TPreviewForm = class(trepazpreviewfo)
 private
  fintf: ireport;
  protected
   procedure reportprint(const sender: TObject);
   procedure reportpostscript(const sender: TObject);
   procedure reportcsv(const sender: TObject);
   procedure reportpdf(const sender: TObject);
   procedure reportpng(const sender: TObject);
   procedure reporthtml(const sender: TObject);
   procedure reportexcel(const sender: TObject);
   procedure reportopenoffice(const sender: TObject);
   procedure loaded; override;
   class function hasresource: boolean; override;
  public
   constructor create(aowner: tcomponent; intf:ireport); reintroduce;
   destructor destroy; override;
 end;
 
 TRepazDialog = class(trepazdialogfo)
 private
  fintf: ireport;
 protected
  procedure changesetting(const sender: TObject);
  procedure showdlgagain(const sender: TObject);
  procedure filenameentered(const sender: TObject);
  class function hasresource: boolean; override;
  procedure dialogloaded; override;
 public
  constructor create(aowner: tcomponent; intf:ireport); reintroduce;
  destructor destroy; override;
 end;
 
 TRepazDesigner = class(trepazdesignfo)
 private
  fintf: ireport;
 protected
  procedure updatedials; override;
  procedure newpage; override;
  procedure reportopen; override;
  procedure reportsave; override;
  procedure reportnew; override;
  procedure reportpreview; override;
  procedure reportsaveas; override;
  procedure report_onclose; override;
 public
  class function hasresource: boolean; override;
  constructor create(aowner: tcomponent; intf:ireport); reintroduce;
  destructor destroy; override;
  procedure showdesigner;
 end;  

implementation
uses
 msedatalist,sysutils,msefiledialog,msefileutils,frmevaldialog,msecommport,
 repazconsts,mseconsts,msegraphicstream,msesysutils,msedial;
type
 tcustomframe1 = class(tcustomframe);
 tcomponent1 = class(tcomponent);
 tmsecomponent1 = class(tmsecomponent);
 twindow1 = class(twindow);

function stringtopages(const avalue: widestring): pagerangearty;
var
 ar1,ar2: msestringarty;
 int1,int2: integer;
 ar3: pagerangearty;
begin
 ar1:= nil; //compiler warning
 ar2:= nil; //compiler warning
 if avalue = '' then begin
  result:= nil;
 end
 else begin
  try
   ar1:= splitstring(avalue,widechar(','));
   setlength(ar3,length(avalue)); //max
   int2:= 0;
   for int1:= high(ar1) downto 0 do begin
    ar2:= splitstring(ar1[int1],widechar('-'));
    if high(ar2) = 1 then begin
     ar3[int2].first:= strtoint(ar2[0]);
     ar3[int2].last:= strtoint(ar2[1]);
    end
    else begin
     if high(ar2) = 0 then begin
      ar3[int2].first:= strtoint(ar2[0]);
      ar3[int2].last:= ar3[int2].first;
     end
     else begin
      raise exception.create('');
     end;
    end;
    with ar3[int2] do begin
     if (first <= 0) or (last <= 0) or (last < first) then begin
      raise exception.create('');
     end;
     dec(first);
     dec(last);
    end;
    inc(int2);
   end;
  except
   raise exception.create('Invalid pages: '''+avalue+'''.'+lineend+
                          'Example: ''1-5,7,9,11-13''');
  end;
  setlength(ar3,int2);
  result:= ar3;
 end;
end;

function ispageprint(const fpages: pagerangearty; fpagenumber: integer): boolean;
var
 int1: integer;
begin
 result:= fpages = nil;
 if not result then begin
  for int1:= high(fpages) downto 0 do begin
   with fpages[int1] do begin
    if (fpagenumber >= first) and (fpagenumber <= last) then begin
     result:= true;
     break;
    end;
   end;
  end;
 end;
end;

{ TPreviewForm }

constructor TPreviewForm.create(aowner: tcomponent; intf:ireport);
begin
 fintf:= intf;
 inherited create(aowner);
end;

destructor TPreviewForm.destroy;
begin
 fintf.previewdestroyed(true);
 inherited;
end;

class function TPreviewForm.hasresource: boolean;
begin
 result:= false;
end;

procedure TPreviewForm.reportprint(const sender: TObject);
begin
 fintf.getreport.reportprint(true); 
end;

procedure TPreviewForm.reportpostscript(const sender: TObject);
begin
 fintf.getreport.reportpostscript; 
end;

procedure TPreviewForm.reportcsv(const sender: TObject);
begin
 fintf.getreport.reportcsv; 
end;

procedure TPreviewForm.reportpdf(const sender: TObject);
begin
 fintf.getreport.reportpdf; 
end;

procedure TPreviewForm.reportpng(const sender: TObject);
begin
 fintf.getreport.reportpng; 
end;

procedure TPreviewForm.reporthtml(const sender: TObject);
begin
 fintf.getreport.reporthtml('html'); 
end;

procedure TPreviewForm.reportexcel(const sender: TObject);
begin
 fintf.getreport.reporthtml('xls'); 
end;

procedure TPreviewForm.reportopenoffice(const sender: TObject);
begin
 fintf.getreport.reporthtml('ods'); 
end;

procedure TPreviewForm.loaded;
begin
 inherited;
 with tmainmenu1.menu.itembyname('mnurep') do begin
  itembyname('mnurepprint').onexecute:= @reportprint;
  itembyname('mnureppdf').onexecute:= @reportpdf;
  itembyname('mnureptext').onexecute:= @reportcsv;
  itembyname('mnureppostscript').onexecute:= @reportpostscript;
  itembyname('mnurephtml').onexecute:= @reporthtml;
  itembyname('mnurepexcel').onexecute:= @reportexcel;
  itembyname('mnurepopenoffice').onexecute:= @reportopenoffice;
  itembyname('mnureppng').onexecute:= @reportpng;
 end;
 ttoolbar2.buttons[1].onexecute:=@reportprint;
 ttoolbar2.buttons[2].onexecute:=@reportcsv;
 ttoolbar2.buttons[3].onexecute:=@reportpostscript;
 ttoolbar2.buttons[4].onexecute:=@reportpdf;
 ttoolbar2.buttons[5].onexecute:=@reporthtml;
 ttoolbar2.buttons[6].onexecute:=@reportexcel;
 ttoolbar2.buttons[7].onexecute:=@reportopenoffice;
end;

{ TRepazDialog }

constructor TRepazDialog.create(aowner: tcomponent; intf:ireport);
begin
 fintf:= intf;
 inherited create(aowner);
end;

destructor TRepazDialog.destroy;
begin
 inherited;
end;


procedure TRepazDialog.changesetting(const sender: TObject);
begin
 if cactions.dropdown.itemindex=0 then begin
  showmessage(uc(ord(rcsMsgprevnotconfig)));
 end else if cactions.dropdown.itemindex=1 then begin
  showmessage(uc(ord(rcsMsgprevnotconfig)));
 end else if cactions.dropdown.itemindex=2 then begin
  fintf.getreport.fuprinter.showdialog;
 end else if cactions.dropdown.itemindex=3 then begin
  showmessage(uc(ord(rcsMsgprevnotconfig)));
 end else if cactions.dropdown.itemindex=4 then begin
  showmessage(uc(ord(rcsMsgprevnotconfig)));
 end else if cactions.dropdown.itemindex=5 then begin
  showmessage(uc(ord(rcsMsgprevnotconfig)));
 end;
end;

procedure TRepazDialog.showdlgagain(const sender: TObject);
begin
 fintf.getreport.reportaction:= fintf.getreport.reportaction - [ra_showdialog];
end;

procedure TRepazDialog.filenameentered(const sender: TObject);
begin
 fintf.getreport.filename:= relativepath(wfilename.value); 
end;

procedure TRepazDialog.dialogloaded;
begin
 btnsetting.onexecute:=@changesetting;
 showagain.ondataentered:=@showdlgagain;
 wfilename.ondataentered:= @filenameentered;
 cactions.dropdown.itemindex:=ord(fintf.getreport.printdestination);
 cdescription.caption:= cactions.dropdown.cols[1].items[cactions.dropdown.itemindex];
end;

class function TRepazDialog.hasresource: boolean;
begin
 result:= false;
end;

{ TRepazDesigner }

constructor TRepazDesigner.create(aowner: tcomponent; intf:ireport);
begin
 fintf:= intf;
 inherited create(aowner);
 if fintf.getreport.designpanel<>nil then begin
  self.statfile:= nil;
 end; 
end;

destructor TRepazDesigner.destroy;
begin
 fintf.designdestroyed(true);
 inherited;
end;

class function TRepazDesigner.hasresource: boolean;
begin
 result:= false;
end;

procedure TRepazDesigner.showdesigner;
var
 tmpfilename: filenamety;
 bo1,bo2: boolean;
 int1: integer;
begin
 try
  tmpfilename:= '';
  fpixelperunit:= fintf.getreport.pixelperunit;
  cunit.dropdown.itemindex:= ord(fintf.getreport.reportunit);
  updatedials;
  if fintf.getreport.filename<>'' then begin
   bo1:= isrelativepath(fintf.getreport.filename);
   if bo1 then begin
    tmpfilename:= filepath(fintf.getreport.filename);
   end else begin 
    tmpfilename:= fintf.getreport.filename;
   end;
   bo2:= findfile(tmpfilename);
  end else begin
   bo2:= false;
  end;
  if not bo2 then begin
   if askyesno(uc(ord(rcsMsgReportFileNotFound)) + #13 + 
    uc(ord(rcsMsgCreateNewReport)),uc(ord(rcsCapConfirmation)),mr_ok) then begin
    if tmpfilename='' then begin
     tmpfilename:= getcurrentdir + 'repaz1.raz'; 
     fintf.getreport.filename:= '../repaz1.raz';
     frepfilename.value:= fintf.getreport.filename;
    end else begin
     fintf.getreport.filename:= tmpfilename;
     frepfilename.value:= fintf.getreport.filename;
    end;
    reportnew;
    if fintf.getreport.designpanel<>nil then begin
     activate;
    end else begin
     show(true);
    end;
   end;
  end else begin
   cpaper.clearcomponents;
   cpaper.loadfromfile(tmpfilename);
   factivepage:= '';
   frepfilename.value:= tmpfilename;
   for int1:=0 to cpaper.widgetcount-1 do begin
    TraPage(cpaper.widgets[int1]).report:= fintf.getreport;
    TraPage(cpaper.widgets[int1]).updatelinks;
    cpaper.widgets[int1].visible:= false;
    if TraPage(cpaper.widgets[int1]).printorder=0 then begin
     fintf.getreport.reportunit:= TraPage(cpaper.widgets[int1]).reportunit;
     fintf.getreport.pixelperunit:= TraPage(cpaper.widgets[int1]).pixelperunit;
     cunit.dropdown.itemindex:= ord(fintf.getreport.reportunit);
     factivepage:= cpaper.widgets[int1].name;
    end;
   end;
   showpages;
   ttoolbar1.buttons[2].enabled:= true;
   if fintf.getreport.designpanel<>nil then begin
    activate;
   end else begin
    show(true);
   end;
  end;
 except
 end;
end;
 
procedure TRepazDesigner.updatedials;
 procedure adjustticks(const adial: tcustomdialcontroller);
 begin
  with adial do begin
   if fintf.getreport.reportunit=Milimeter then begin
    ticks[0].intervalcount:= range/10.0;
    ticks[1].intervalcount:= range/5.0;
    ticks[2].intervalcount:= range/1.0;
    xdisp.format:= '0.0 mm';
    ydisp.format:= '0.0 mm';
   end else if fintf.getreport.reportunit=Inch then begin
    ticks[0].intervalcount:= range; ///16.0;
    ticks[1].intervalcount:= range*2.0;
    ticks[2].intervalcount:= range*16.0;
    xdisp.format:= '0.0 inch';
    ydisp.format:= '0.0 inch';
   end;
  end;
 end; 
begin
 if fintf.getreport=nil then exit;
 dialh.bounds_cx:= cpaper.bounds_cx;
 dialv.bounds_cy:= cpaper.bounds_cy;
 if dialh.bounds_cx > 0 then begin
  dialh.dial.range:= dialh.bounds_cx / fintf.getreport.pixelperunit;
 end;
 if dialv.bounds_cy > 0 then begin
  dialv.dial.range:= dialv.bounds_cy / fintf.getreport.pixelperunit;
 end;
 dialh.dial.start:= -cpaper.clientpos.x / fintf.getreport.pixelperunit;
 dialv.dial.start:= -cpaper.clientpos.y / fintf.getreport.pixelperunit;
 adjustticks(dialh.dial);
 adjustticks(dialv.dial);
end;

procedure TRepazDesigner.reportopen;
var
 xx: filenamety;
 int1: integer;
begin
 tfiledialog1.dialogkind:= fdk_open;
 if tfiledialog1.execute=mr_ok then begin
  xx:= tfiledialog1.controller.filename;
  cpaper.loadfromfile(xx);
  for int1:=0 to cpaper.widgetcount-1 do begin
   if cpaper.widgets[int1] is TraPage then begin
    TraPage(cpaper.widgets[int1]).freport:= fintf.getreport;
   end;
  end;
  frepfilename.value:= xx;
  ttoolbar1.buttons[2].enabled:= true;
 end;
end;

procedure TRepazDesigner.reportsave;
var
 ffilename: filenamety;
 bo1: boolean;
 tmpfilename: filenamety;
begin
 ffilename:= fintf.getreport.filename;
 if ffilename<>'' then begin
  bo1:= isrelativepath(ffilename);
  if bo1 then begin
   tmpfilename:= filepath(ffilename);
  end else begin 
   tmpfilename:= ffilename;
  end;
  cpaper.savetofile(tmpfilename);
  ttoolbar1.buttons[2].enabled:= false;
 end else begin
  tfiledialog1.controller.captionsave:= uc(ord(rcsCapsaverepdesign));
  tfiledialog1.dialogkind:= fdk_save;
  if tfiledialog1.execute=mr_ok then begin
   ffilename:= tfiledialog1.controller.filename;
   if ffilename<>'' then begin
    cpaper.savetofile(ffilename);
    fintf.getreport.filename:= ffilename;
    frepfilename.value:= ffilename;
    ttoolbar1.buttons[2].enabled:= false;
   end else begin
    showmessage(uc(ord(rcsMsgtyperepfn)));
   end;
  end; 
 end;
end;

procedure TRepazDesigner.reportnew;
var
 int1: integer;
 fnewpage: TraPage;
begin
 for int1:=cpaper.widgetcount-1 downto 0 do begin
  cpaper.widgets[int1].free;
 end;
 fnewpage:= TraPage.create(nil);
 fnewpage.freport:= fintf.getreport;
 fnewpage.parentwidget:= cpaper;
 tcomponent1(fnewpage).setdesigning(true);
 cpaper.insertwidget(fnewpage,makepoint(0,0));
 fnewpage.name:= 'Page' + inttostr(cpaper.widgetcount);
 fnewpage.initnewwidget(1.0);
 fnewpage.visible:= true;
 factivepage:= fnewpage.name;
 frepfilename.value:= fintf.getreport.filename;
 showpages;
end;

procedure TRepazDesigner.reportpreview;
begin
 if not (csdesigning in fintf.getreport.componentstate) then begin
  fintf.getreport.reportpreview;
 end else begin
  tcomponent1(fintf.getreport).setdesigning(false);
  tcomponent1(fintf.getreport).loaded;
  fintf.getreport.reportpreview;
 end;
end;

procedure TRepazDesigner.reportsaveas;
var
 ffilename: filenamety;
 bo1: boolean;
 tmpfilename: filenamety;
begin
 ffilename:= fintf.getreport.filename;
 if ffilename<>'' then begin
  bo1:= isrelativepath(ffilename);
  if bo1 then begin
   tmpfilename:= filepath(ffilename);
  end else begin 
   tmpfilename:= ffilename;
  end;
  tfiledialog1.controller.filename:= tmpfilename;
 end;
 tfiledialog1.controller.captionsave:= uc(ord(rcsCapsaverepas));
 tfiledialog1.dialogkind:= fdk_save;
 if tfiledialog1.execute=mr_ok then begin
  ffilename:= tfiledialog1.controller.filename;
  if ffilename<>'' then begin
   cpaper.savetofile(ffilename);
   frepfilename.value:= ffilename;
   ttoolbar1.buttons[2].enabled:= false;
  end else begin
   showmessage(uc(ord(rcsMsgtyperepfn)));
  end;
 end; 
end;

procedure TRepazDesigner.newpage;
var
 int1: integer;
 fnewpage: TraPage;
 fwidth,fheight: integer;
begin
 for int1:=0 to cpaper.widgetcount-1 do begin
  cpaper.widgets[int1].visible:=false;
  fwidth:=cpaper.widgets[int1].width;
  fheight:=cpaper.widgets[int1].height;
 end;
 fnewpage:= TraPage.create(nil);
 fnewpage.report:= fintf.getreport;
 fnewpage.parentwidget:= cpaper;
 tcomponent1(fnewpage).setdesigning(true);
 fnewpage.height:= fheight;
 fnewpage.width:= fwidth;
 cpaper.insertwidget(fnewpage,makepoint(0,0));
 fnewpage.name:= 'Page' + inttostr(cpaper.widgetcount);
 factivepage:= fnewpage.name;
 fnewpage.initnewwidget(1.0);
 fnewpage.printorder:= cpaper.widgetcount-1;
 fnewpage.visible:= true;
 showpages;
end;

procedure TRepazDesigner.report_onclose;
begin
end;

{ TraTabulatorItem }

constructor TraTabulatorItem.create(aowner: tobject);
begin
 inherited;
 fmodul:= 1;
 fbarcoderatio:= 1.0;
 fbarcodetype:= bcCodeNone;
 fchecksum:= false;
 fbarcoderotation:= 0;
 fbarcodecolor:= cl_black;   
 ftext:= '';
 fvalue:= null;
 fbitmapstr:= '';
 falignment:= [];
 frawfont:= rfNormal;
 fexpression:= '';
 frawcharpos:= 0;
 frawcharwidth:= 5;
 fpos:= 0;
 fleftmargin:=0;
 frightmargin:=0;
 fwidth:= 90/TraTabulators(fowner).pixelperunit;
 fleftmargin:= defaulttextmargin/TraTabulators(fowner).pixelperunit;
 frightmargin:= fleftmargin;
 fbold:= false;
 fitalic:= false;
 funderline:= false;
 fstrikeout:= false;
 fhalign:= ha_Left;
 fvalign:= va_Center;
 ffontname:= defaultrepfontname;
 ffontsize:= defaultrepfontsize;
 ffontcolor:= defaultrepfontcolor;
 fcolor:= cl_transparent;
 fdatalink:= tfielddatalink.create; 
 fdatalink.dataSource:= TraTabulators(fowner).datalink.datasource;
 fbordertop:= defaultborderinfo;
 fborderleft:= defaultborderinfo;
 fborderright:= defaultborderinfo;
 fborderbottom:= defaultborderinfo;
 ffontname:= defaultrepfontname;
 ffontsize:= defaultrepfontsize;
 ffontcolor:= defaultrepfontcolor;
 fbitmap:= tmaskedbitmap.create(false);
 fellipse:= el_None;
 ftextoptions:= [];
end;

destructor TraTabulatorItem.destroy;
begin
 flookupbuffer:= nil;
 fdatalink.free;
 fbitmap.free;
 fbitmap:= nil;
 inherited;
end;

procedure TraTabulatorItem.changed;
begin
 TraTabulators(fowner).reporttemplate.invalidate; 
end;

procedure TraTabulatorItem.assign(source: TPersistent);
var
 tmpbmp: imagety;
begin
 if source is TraTabulatorItem then begin
  TraTabulatorItem(source).fbitmap.savetoimage(tmpbmp);
  fbitmap.alignment:= TraTabulatorItem(source).fbitmap.alignment;
  fbitmap.loadfromimage(tmpbmp);
  freeimage(tmpbmp);
  ftext:= TraTabulatorItem(source).ftext;
  fborderleft:= TraTabulatorItem(source).fborderleft;
  fborderright:= TraTabulatorItem(source).fborderright;
  fbordertop:= TraTabulatorItem(source).fbordertop;
  fborderbottom:= TraTabulatorItem(source).fborderbottom;
  flookupbuffer:= TraTabulatorItem(source).reallookupbuffer;
  flookupkeyfieldno:= TraTabulatorItem(source).lookup_keyfieldno;
  flookupvaluefieldno:= TraTabulatorItem(source).lookup_valuefieldno;
  flookupkind:= TraTabulatorItem(source).flookupkind;
  fkeykind:= TraTabulatorItem(source).fkeykind;
  fformat:= TraTabulatorItem(source).fformat;
  fcolor:= TraTabulatorItem(source).fcolor;
  frawfont:= TraTabulatorItem(source).frawfont;
  frawcharpos:= TraTabulatorItem(source).frawcharpos;
  frawcharwidth:= TraTabulatorItem(source).frawcharwidth;
  fexpression:= TraTabulatorItem(source).fexpression;
  fpos:= TraTabulatorItem(source).fpos;
  fleftmargin:= TraTabulatorItem(source).fleftmargin;
  frightmargin:= TraTabulatorItem(source).frightmargin;
  fwidth:= TraTabulatorItem(source).fwidth;
  ffontstyle:= TraTabulatorItem(source).fontstyle;
  ffontname:= TraTabulatorItem(source).font_name;
  ffontsize:= TraTabulatorItem(source).font_size;
  ffontcolor:= TraTabulatorItem(source).font_color;
  fhalign:= TraTabulatorItem(source).fhalign;
  fvalign:= TraTabulatorItem(source).fvalign;
  fellipse := TraTabulatorItem(source).fellipse ;
  ftextoptions:= TraTabulatorItem(source).ftextoptions;
  falignment:= TraTabulatorItem(source).falignment;
  setdatasource(TraTabulatorItem(source).datasource);
  fdatalink.fieldname:= TraTabulatorItem(source).datafield;
  flookupbufferstr:= TraTabulatorItem(source).lookup_buffer;
  fbold:= TraTabulatorItem(source).font_bold;
  fitalic:= TraTabulatorItem(source).font_italic;
  funderline:= TraTabulatorItem(source).font_underline;
  fstrikeout:= TraTabulatorItem(source).font_strikeout;
 end;
end;

procedure TraTabulatorItem.settext(const avalue: msestring);
begin
 if ftext<>avalue then begin
  ftext:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setvalue(const avalue: variant);
begin
 try
  //if fvalue<>avalue then begin
   fvalue:= avalue;
   ftext:= vartoformattedtext(avalue,fformat);
  //end;
 except
 end;  
end;

procedure TraTabulatorItem.setexpression(const avalue: msestring);
var
 xx: TComponentState;
begin
 xx:= TraTabulators(fowner).reporttemplate.reportpage.componentstate;
 if avalue<>fexpression then begin
  fexpression:= avalue;
  if fexpression<>'' then begin
   if xx*[{csloading,}csreading] = [] then begin
    evalexpression(fexpression);
    setvalue(getexpressionresult);
   end;
  end;
 end;
end;

procedure TraTabulatorItem.setpos(const avalue: real);
begin
 if avalue<>fpos then begin
  fpos:= avalue;
  if (avalue<>0) and (frawcharpos=0) then begin
   frawcharpos:= round(avalue/defpixelperchar);
  end;
  changed;
 end;
end;

procedure TraTabulatorItem.setwidth(const avalue: real);
begin
 if avalue<>fwidth then begin
  fwidth:= avalue;
  if (avalue<>0) and (frawcharwidth=0) then begin
   frawcharwidth:= round(avalue/defpixelperchar);
  end;
  changed;
 end;
end;

procedure TraTabulatorItem.setleftmargin(const avalue: real);
begin
 if avalue<>fleftmargin then begin
  fleftmargin:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setrightmargin(const avalue: real);
begin
 if avalue<>frightmargin then begin
  frightmargin:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setbold(const avalue: boolean);
begin
 if avalue<>fbold then begin
  fbold:= avalue;
  if avalue then
   ffontstyle:= ffontstyle + [fs_bold]
  else
   ffontstyle:= ffontstyle - [fs_bold];
  changed;
 end;
end;

procedure TraTabulatorItem.setitalic(const avalue: boolean);
begin
 if avalue<>fitalic then begin
  fitalic:= avalue;
  if avalue then
   ffontstyle:= ffontstyle + [fs_italic]
  else
   ffontstyle:= ffontstyle - [fs_italic];
  changed;
 end;
end;

procedure TraTabulatorItem.setunderline(const avalue: boolean);
begin
 if avalue<>funderline then begin
  funderline:= avalue;
  if avalue then
   ffontstyle:= ffontstyle + [fs_underline]
  else
   ffontstyle:= ffontstyle - [fs_underline];
  changed;
 end;
end;

procedure TraTabulatorItem.setstrikeout(const avalue: boolean);
begin
 if avalue<>fstrikeout then begin
  fstrikeout:= avalue;
  if avalue then
   ffontstyle:= ffontstyle + [fs_strikeout]
  else
   ffontstyle:= ffontstyle - [fs_strikeout];
  changed;
 end;
end;

procedure TraTabulatorItem.sethalign(const avalue: halignmentty);
begin
 if avalue<>fhalign then begin
  fhalign:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setvalign(const avalue: valignmentty);
begin
 if avalue<>fvalign then begin
  fvalign:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setbitmap(const Value: tmaskedbitmap);
var
 aimage: imagebufferinfoty;
begin
 if Value<>fbitmap then begin
  Value.savetoimagebuffer(aimage);
  fbitmap.loadfromimagebuffer(aimage);
 end;
end;

function TraTabulatorItem.getlookupbuffer: string;
begin
 result:= flookupbufferstr;
end;

function TraTabulatorItem.getdatasource1: string;
begin
 result:= fdatasourcestr;
end;

procedure TraTabulatorItem.setdatasource(const avalue: string);
var
 xx: TComponentState;
begin
 if (fdatasourcestr<>avalue) or (fdatalink.DataSource=nil) then begin
  fdatasourcestr:= avalue;
  xx:= TraTabulators(fowner).reporttemplate.reportpage.componentstate;
  if xx*[{csloading,}csreading] = [] then begin
   if avalue='' then begin
    fdatalink.DataSource:= nil;
   end else begin
    try
     fdatalink.DataSource:= TraTabulators(fowner).reporttemplate.reportpage.report.getdatasourcereport(avalue);
     //changed;
    except
     //raise;
    end;
   end;
  end;
 end;
end;

procedure TraTabulatorItem.updatelinks;
begin
 if (fdatalink.field=nil) and (fdatasourcestr<>'') and (fdatalink.fieldname<>'') then begin
  setdatasource(fdatasourcestr);
 end;
 setlookupbuffer(flookupbufferstr);
end;

function TraTabulatorItem.getdatafield: string;
begin
 result:= fdatalink.fieldname;
end;

procedure TraTabulatorItem.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue;
end;

function TraTabulatorItem.getdataset(const aindex: integer): tdataset;
begin
 result:= fdatalink.dataset;
end;

function TraTabulatorItem.isstorefontname:boolean;
begin
 result:= true;
 //result:= ffontname<>defaultrepfontname;
end;

procedure TraTabulatorItem.getfieldtypes(out apropertynames: stringarty;
               out afieldtypes: fieldtypesarty);
begin
 apropertynames:= nil;
 afieldtypes:= nil;
end;

function TraTabulatorItem.getlbdatakind(const apropname: string): lookupkindty;
begin
 if apropname = 'Lookup_KeyFieldNo' then begin
  result:= fkeykind;
 end
 else if apropname = 'Lookup_ValueFieldNo' then begin
  result:= flookupkind; 
 end;
end;

function TraTabulatorItem.getlb: tcustomlookupbuffer;
begin
 result:= flookupbuffer;
end;

procedure TraTabulatorItem.processvalue;
var
 ikey: integer;
 i64key: integer;
 skey: msestring;
 fbarcodebitmap: tmaskedbitmap;
 arect: rectty;
begin
 fbitmapstr:= '';
 fvalue:= null;
 if fexpression<>'' then begin
  evalexpression(fexpression);
  setvalue(getexpressionresult);
 end else begin
  if fdatalink.fieldactive then begin
   if flookupbuffer <> nil then begin
    try
    if fdatalink.islargeint then begin
     i64key:= fdatalink.field.aslargeint;
     case flookupkind of
      lk_text: begin
       setvalue(flookupbuffer.lookuptext(flookupkeyfieldno,
                    flookupvaluefieldno,i64key));
      end;
      lk_integer: begin
       setvalue(flookupbuffer.lookupinteger(flookupkeyfieldno,
                    flookupvaluefieldno,i64key));
      end;
      lk_int64: begin
       setvalue(flookupbuffer.lookupint64(flookupkeyfieldno,
                    flookupvaluefieldno,i64key));
      end;
      lk_float,lk_time,lk_date,lk_datetime: begin
       setvalue(flookupbuffer.lookupfloat(flookupkeyfieldno,
                    flookupvaluefieldno,i64key));
      end;
     end;
    end
    else begin
     if fdatalink.ismsestring then begin
      skey:= tmsestringfield(fdatalink.field).asmsestring;
      case flookupkind of
       lk_text: begin
        setvalue(flookupbuffer.lookuptext(flookupkeyfieldno,
                     flookupvaluefieldno,skey));
       end;
       lk_integer: begin
        setvalue(flookupbuffer.lookupinteger(flookupkeyfieldno,
                     flookupvaluefieldno,skey));
       end;
       lk_int64: begin
        setvalue(flookupbuffer.lookupint64(flookupkeyfieldno,
                     flookupvaluefieldno,skey));
       end;
       lk_float,lk_time,lk_date,lk_datetime: begin
        setvalue(flookupbuffer.lookupfloat(flookupkeyfieldno,
                     flookupvaluefieldno,skey));
       end;
      end;
     end
     else begin
      ikey:= fdatalink.field.asinteger;
      case flookupkind of
       lk_text: begin
        setvalue(flookupbuffer.lookuptext(flookupkeyfieldno,
                     flookupvaluefieldno,ikey));
       end;
       lk_integer: begin
        setvalue(flookupbuffer.lookupinteger(flookupkeyfieldno,
                     flookupvaluefieldno,ikey));
       end;
       lk_int64: begin
        setvalue(flookupbuffer.lookupint64(flookupkeyfieldno,
                     flookupvaluefieldno,ikey));
       end;
       lk_float,lk_time,lk_date,lk_datetime: begin
        setvalue(flookupbuffer.lookupfloat(flookupkeyfieldno,
                     flookupvaluefieldno,ikey));
       end;
      end;
     end;
    end;
    except
     on e: exception do begin
      e.message:= 'Error : ' +e.message;
      setvalue('');
      //raise;
     end;
    end;
   end else begin
    case fdatalink.field.datatype of 
     ftBlob,ftGraphic,ftFmtMemo,ftParadoxOle,
     ftDBaseOle,ftTypedBinary,ftCursor,ftOraBlob,ftOraClob : 
      begin
       fbitmapstr:= fdatalink.asstring;
      end;
      else begin
       fvalue:= fdatalink.asvariant;
       ftext:= fdatalink.msedisplaytext(fformat);
      end;
     end;
   end;
  end;
 end;
 if (fbarcodetype<>bcCodeNone) and (ftext<>'') then begin
  fbarcodebitmap:= tmaskedbitmap.create(false);
  fbarcodebitmap.alignment:= [al_xcentered];
  fbarcode.BarcodeType:= fbarcodetype;
  fbarcode.datastring:= Text;
  fbarcode.Checksum:= fchecksum;
  fbarcode.Ratio:= fbarcoderatio;
  fbarcode.modul:= fmodul;
  fbarcode.Rotation:= fbarcoderotation;
  arect:= makerect(round(fleftmargin*TraTabulators(self.fowner).pixelperunit),0,
    round((fwidth-fleftmargin-frightmargin)*TraTabulators(self.fowner).pixelperunit),
    TraTabulators(self.fowner).pixelheight);
  fbarcode.drawbarcode(arect,fbarcodebitmap);
  fbitmapstr:= fbarcodebitmap.writetostring('jpg',[]);
  ftext:= '';
  fvalue:= '';
  fbarcodebitmap.free;
 end;
end;

procedure TraTabulatorItem.setbordertopwidth(const avalue: real);
begin
 if fbordertop.linewidth<>avalue then begin
  fbordertop.linewidth:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setbordertopcolor(const avalue: colorty);
begin
 if fbordertop.linecolor<>avalue then begin
  fbordertop.linecolor:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setbordertopcapstyle(const avalue: capstylety);
begin
 if fbordertop.capstyle<>avalue then begin
  fbordertop.capstyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setbordertoplinestyle(const avalue: linestylety);
begin
 if avalue<>fbordertop.linestyle then begin
  fbordertop.linestyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderleftwidth(const avalue: real);
begin
 if fborderleft.linewidth<>avalue then begin
  fborderleft.linewidth:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderleftcolor(const avalue: colorty);
begin
 if fborderleft.linecolor<>avalue then begin
  fborderleft.linecolor:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderleftcapstyle(const avalue: capstylety);
begin
 if fborderleft.capstyle<>avalue then begin
  fborderleft.capstyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderleftlinestyle(const avalue: linestylety);
begin
 if avalue<>fborderleft.linestyle then begin
  fborderleft.linestyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderrightwidth(const avalue: real);
begin
 if fborderright.linewidth<>avalue then begin
  fborderright.linewidth:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderrightcolor(const avalue: colorty);
begin
 if fborderright.linecolor<>avalue then begin
  fborderright.linecolor:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderrightcapstyle(const avalue: capstylety);
begin
 if fborderright.capstyle<>avalue then begin
  fborderright.capstyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderrightlinestyle(const avalue: linestylety);
begin
 if fborderright.linestyle<>avalue then begin
  fborderright.linestyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderbottomwidth(const avalue: real);
begin
 if fborderbottom.linewidth<>avalue then begin
  fborderbottom.linewidth:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderbottomcolor(const avalue: colorty);
begin
 if fborderbottom.linecolor<>avalue then begin
  fborderbottom.linecolor:= avalue;
  changed;
 end;
end;
procedure TraTabulatorItem.setborderbottomcapstyle(const avalue: capstylety);
begin
 if fborderbottom.capstyle<>avalue then begin
  fborderbottom.capstyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setborderbottomlinestyle(const avalue: linestylety);
begin
 if fborderbottom.linestyle<>avalue then begin
  fborderbottom.linestyle:= avalue;
  changed;
 end;
end;

procedure TraTabulatorItem.setlookupbuffer(const avalue: string);
var
 xx: TComponentState;
begin
 if (avalue<>flookupbufferstr) or (flookupbuffer=nil) then begin
  flookupbufferstr:= avalue;
  xx:= TraTabulators(fowner).reporttemplate.reportpage.componentstate;
  if xx*[{csloading,}csreading] = [] then begin
   if avalue<>'' then begin
    flookupbuffer:= TraTabulators(fowner).reporttemplate.reportpage.report.getlookupbufferreport(avalue);
    changed;
   end else begin
    flookupbuffer:= nil;
   end;
  end;
 end;
end;

procedure TraTabulatorItem.setlookupkeyfieldno(const avalue: integer);
begin
 flookupkeyfieldno:= avalue;
 changed;
end;

procedure TraTabulatorItem.setlookupvaluefieldno(const avalue: integer);
begin
 flookupvaluefieldno:= avalue;
 changed;
end;

procedure TraTabulatorItem.setlookupkind(const avalue: lookupkindty);
begin
 flookupkind:= avalue;
 changed;
end;

procedure TraTabulatorItem.setkeykind(const avalue: lookupkindty);
begin
 fkeykind:= avalue;
 changed;
end;

procedure TraTabulatorItem.setformat(const avalue: msestring);
begin
 fformat:= avalue;
 changed;
end;

procedure TraTabulatorItem.setcolor(avalue: colorty);
begin
 if avalue = cl_invalid then begin
  avalue:= cl_none;
 end;
 if fcolor <> avalue then begin
  fcolor:= avalue;
  changed;
 end
end;

procedure TraTabulatorItem.setfontname(avalue: string);
begin
 if avalue = '' then begin
  avalue:= defaultrepfontname;
 end;
 if ffontname <> avalue then begin
  ffontname:= avalue;
  changed;
 end
end;

procedure TraTabulatorItem.setfontsize(avalue: integer);
begin
 if avalue <= 0 then begin
  avalue:= defaultrepfontsize;
 end;
 if ffontsize <> avalue then begin
  ffontsize:= avalue;
  changed;
 end
end;

procedure TraTabulatorItem.setfontcolor(avalue: colorty);
begin
 if avalue = cl_invalid then begin
  avalue:= defaultrepfontcolor;
 end;
 if ffontcolor <> avalue then begin
  ffontcolor:= avalue;
  changed;
 end
end;

procedure TraTabulatorItem.evalexpression(const aexpression: msestring);
begin
 try
  TraTabulators(fowner).reporttemplate.reportpage.report.frepazevaluator.expression:= aexpression;
 except
 end;
end;

function TraTabulatorItem.getexpressionresult: variant;
begin
 try
  with TraTabulators(fowner).reporttemplate.reportpage.report.frepazevaluator do begin
   evaluate;
   result:= evalresult;
  end;
 except
  //raise;
 end;
end;

function TraTabulatorItem.istextstored: boolean;
begin
 result:= (fdatalink.fieldname='') and (fexpression='');
end;

procedure TraTabulatorItem.dobeforenextrecord(const adatasource: tdatasource);
begin
 //
end;

{ TraTabulatorItemSummary }

constructor TraTabulatorItemSummary.create(aowner: tobject);
begin
 inherited;
 fsummary:= st_None;
end;

procedure TraTabulatorItemSummary.resetsum(const skipcurrent: boolean);
begin
 fillchar(fsum,sizeof(fsum),0);
 fsum.resetpending:= skipcurrent;
 fsum.reset:= true;
end;

procedure TraTabulatorItemSummary.assign(source: TPersistent);
begin
 if source is TraTabulatorItem then begin
  inherited;
  fsummary:= TraTabulatorItemSummary(source).fsummary;
 end;
end;

procedure TraTabulatorItemSummary.initsum;
begin
 fillchar(fsum,sizeof(fsum),0);
end;

procedure TraTabulatorItemSummary.dobeforenextrecord(const adatasource: tdatasource);
var
 expresult: variant;
begin
 fvartype:= varempty;
 if adatasource=nil then exit;
 if (fsummary<>st_None) and (lowercase(fdatasourcestr) = lowercase(adatasource.name)) then begin
  if fdatalink.field = nil then begin
  //if DataField='' then begin
   inc(fsum.count);
   if fexpression<>'' then begin
    evalexpression(fexpression);
    expresult:= getexpressionresult;
    with fsum do begin
     case vartype(expresult) of
      varsmallint,varinteger,varshortint,varbyte,varboolean :
       begin
        integervalue:= integervalue + integer(expresult);
        setvalue(integervalue);
        fvartype:= varinteger;
       end;
      varword,varlongword,varint64,varqword :
       begin
        largeintvalue:= largeintvalue + LargeInt(expresult);
        setvalue(largeintvalue);
        fvartype:= varint64;
       end;
      varsingle,vardouble,varvariant,vardecimal:
       begin
        floatvalue:= floatvalue + double(expresult);
        setvalue(floatvalue);
        fvartype:= vardouble;
       end;
      varcurrency :
       begin
        bcdvalue:= bcdvalue + currency(expresult);
        setvalue(bcdvalue);
        fvartype:= varcurrency;
       end;
     end;
    end;
   end;
  end else begin
   with fdatalink.field,fsum do begin
    if not isnull then begin
     inc(count);
     case datatype of
      ftinteger,ftword,ftsmallint,ftboolean: begin
       integervalue:= integervalue + asinteger;
       setvalue(integervalue);
      end;
      ftlargeint: begin
       largeintvalue:= largeintvalue + aslargeint;
       setvalue(largeintvalue);
      end;
      ftfloat,ftcurrency: begin
       floatvalue:= floatvalue + asfloat;
       setvalue(floatvalue);
      end;
      ftbcd: begin
       bcdvalue:= bcdvalue + ascurrency;
       setvalue(bcdvalue);
      end;
     end;
    end;
   end;
  end;
  if fsum.resetpending then begin
   initsum;
  end;
 end;
end;

function TraTabulatorItemSummary.getsumasinteger: integer;
begin
 if fsum.resetpending and fsum.reset then begin
  result:= 0;
 end
 else begin
  result:= fsum.integervalue;
 end;
end;

function TraTabulatorItemSummary.getsumaslargeint: int64;
begin
 if fsum.resetpending and fsum.reset then begin
  result:= 0;
 end
 else begin
  result:= fsum.largeintvalue;
 end;
end;

function TraTabulatorItemSummary.getsumasfloat: double;
begin
 if fsum.resetpending and fsum.reset then begin
  result:= 0;
 end
 else begin
  result:= fsum.floatvalue;
 end;
end;

function TraTabulatorItemSummary.getsumascurrency: currency;
begin
 if fsum.resetpending and fsum.reset then begin
  result:= 0;
 end
 else begin
  result:= fsum.bcdvalue;
 end;
end;

function TraTabulatorItemSummary.getsumcount: integer;
begin
 if fsum.resetpending and fsum.reset or not fdatalink.active then begin
  result:= 0;
 end
 else begin
  result:= fsum.count;
 end;
end;

procedure TraTabulatorItemSummary.processvalue;
var
 int1: integer;
begin
 if (fsummary=st_Sum) or (fsummary=st_Count) or (fsummary=st_Average) then begin
  if fdatalink.fieldactive then begin
   if fsummary=st_Count then begin
    setvalue(sumcount);
   end else begin
    if fsummary=st_Average then begin
     int1:= sumcount;
     if int1 = 0 then begin
      setvalue(0);
     end else begin
      case fdatalink.field.datatype of 
       ftinteger,ftword,ftsmallint,ftboolean: begin
        setvalue(sumasinteger/int1);
       end;
       ftlargeint: begin
        setvalue(sumaslargeint/int1);
       end;
       ftfloat,ftcurrency: begin
        setvalue(sumasfloat/int1);
       end;
       ftbcd: begin
        setvalue(sumascurrency/int1);
       end;
      end;
     end;
    end else begin
     case fdatalink.field.datatype of 
      ftinteger,ftword,ftsmallint,ftboolean: begin
       setvalue(sumasinteger);
      end;
      ftlargeint: begin
       setvalue(sumaslargeint);
      end;
      ftfloat,ftcurrency: begin
       setvalue(sumasfloat);
      end;
      ftbcd: begin
       setvalue(sumascurrency);
      end;
     end;
    end;
   end;
  end else begin
   if fexpression<>'' then begin
    if fsummary=st_Count then begin
     setvalue(sumcount);
    end else begin
     if fsummary=st_Average then begin
      int1:= sumcount;
      if int1 = 0 then begin
       setvalue(0);
      end else begin
       case fvartype of 
        varinteger: begin
         setvalue(sumasinteger/int1);
        end;
        varint64: begin
         setvalue(sumaslargeint/int1);
        end;
        vardouble: begin
         setvalue(sumasfloat/int1);
        end;
        varcurrency: begin
         setvalue(sumascurrency/int1);
        end;
       end;
      end;
     end else begin
      case fvartype of 
       varinteger: begin
        setvalue(sumasinteger);
       end;
       varint64: begin
        setvalue(sumaslargeint);
       end;
       vardouble: begin
        setvalue(sumasfloat);
       end;
       varcurrency: begin
        setvalue(sumascurrency);
       end;
      end;
     end;
    end;
   end else begin
    setvalue(null);
   end;
  end;
 end else begin
  inherited processvalue;
 end;
end;

{ TraTabulators }

constructor TraTabulators.create(const aowner: TraReportTemplate);
begin
 fdatalink:= tmsedatalink.create;
 freporttemplate:= aowner;
 fpixelperunit:= freporttemplate.PixelPerUnit;
 fZebra_Step:= 2;
 fZebra_Color:= cl_ltgray;
 frecordarea:= ra_AllRecord;
 fheight:= defaulttabsheight/fpixelperunit;
 fbackcolor:= cl_transparent;
 frawlinebelow:= 0;
 inherited create(self,getitemclass);
end;

destructor TraTabulators.destroy;
begin
 fdatalink.free;
 inherited; 
end;

procedure TraTabulators.assign(source: tpersistent);
begin
 if source is TraTabulators then begin
  frecordarea:= TraTabulators(source).RecordArea;
  fZebra_Counter:= TraTabulators(source).Zebra_Counter;
  fZebra_Color:= TraTabulators(source).Zebra_Color;
  fZebra_Start:= TraTabulators(source).Zebra_Start;
  fZebra_Height:= TraTabulators(source).Zebra_Height;
  fZebra_Step:= TraTabulators(source).Zebra_Step;
  fZebra_Options:= TraTabulators(source).Zebra_Options; 
  setdatasource(TraTabulators(source).datasource);
  fpixelperunit:= TraTabulators(source).PixelPerUnit;
  freporttemplate:= TraTabulators(source).reporttemplate;
  fbackcolor:= TraTabulators(source).BackColor;
  fheight:= TraTabulators(source).Height;
  frawlinebelow:= TraTabulators(source).RAW_EmptyLinesBelow;
  inherited;
 end;
end;

class function TraTabulators.getitemclass: tratabulatoritemclassty;
begin
 result:= TraTabulatorItem;
end;

procedure TraTabulators.setpixelperunit(const avalue: real);
var
 int1: integer;
begin
 if fpixelperunit<>avalue then begin
  fheight:= (fheight*fpixelperunit)/avalue;
  for int1:=0 to count-1 do begin
   items[int1].Width:= (items[int1].Width*fpixelperunit)/avalue;
   items[int1].Position:= (items[int1].Position*fpixelperunit)/avalue;
   items[int1].Margin_Left:= (items[int1].Margin_Left*fpixelperunit)/avalue;
   items[int1].Margin_Right:= (items[int1].Margin_Right*fpixelperunit)/avalue;
   items[int1].Border_Top_Width:= (items[int1].Border_Top_Width*fpixelperunit)/avalue;
   items[int1].Border_Bottom_Width:= (items[int1].Border_Bottom_Width*fpixelperunit)/avalue;
   items[int1].Border_Left_Width:= (items[int1].Border_Left_Width*fpixelperunit)/avalue;
   items[int1].Border_Right_Width:= (items[int1].Border_Right_Width*fpixelperunit)/avalue;
  end;
  fpixelperunit:= avalue;
 end;
end;

function TraTabulators.getitems(const index: integer): TraTabulatorItem;
begin
 result:= TraTabulatorItem(inherited items[index]);
end;

procedure TraTabulators.setitems(const index: integer;
               const avalue: TraTabulatorItem);
begin
 getitems(index).assign(avalue);
end;

procedure TraTabulators.processvalues(const acanvas: tcanvas;const adest: rectty; 
   const aresetsum: boolean; const isbuilding:boolean);
var
 int1: integer;
 tmprect: rectty;
 linestart: pointty;
 lineend: pointty;
 reptabinfo: reptabinfoty;
 fbitmapfield: tmaskedbitmap;
 bmpstr: string;
 tmpfont: tfont;
 ftextflags: textflagsty;
 data: string;
begin
 tmpfont:= tfont.create;
 fbitmapfield:= tmaskedbitmap.create(false);
 //draw zebra or backcolor
 if count>0 then begin
  tmprect.cy:= adest.cy;
  tmprect.y:= adest.y;
  tmprect.x:= adest.x + round(items[0].Position*fpixelperunit);
  tmprect.cx:= round((items[count-1].Position+items[count-1].Width-items[0].Position)*fpixelperunit);
 end else begin
  tmprect:= adest;
 end;
 if isbuilding then begin
  if not drawzebra(acanvas,tmprect) then begin
   if (fbackcolor <> cl_none) and (fbackcolor <> cl_transparent) then begin    
    freporttemplate.reportpage.report.addrect1toreport(createrectinfo(tmprect,fbackcolor));
   end;
  end;
 end else begin
  acanvas.fillrect(tmprect,fbackcolor);  
 end;
 if count > 0 then begin
  //draw text, background cell and picture
  setlength(reptabinfo.tabs,count);
  for int1:= 0 to count - 1 do begin
   with items[int1] do begin
    //draw background cell
    if (Color<>cl_none) and (Color<>cl_transparent)then begin
     if isbuilding then begin
      freporttemplate.reportpage.report.addrect2toreport(createrectinfo(tmprect,Color));
     end else begin
      acanvas.fillrect(tmprect,Color);
     end;
    end;
    //draw picture
    if bitmap.hasimage then begin
     tmprect:= makerect(adest.x+round(Position*fpixelperunit),adest.y,
       round(Width*fpixelperunit),adest.cy);
     if isbuilding then begin
      freporttemplate.reportpage.report.addbitmap1toreport(tmprect,bitmap);
     end else begin
      bitmap.paint(acanvas,tmprect);
     end;
    end;
    finfo.text.text:= '';
    bmpstr:='';
    processvalue;
    finfo.text.text:= Text;
    bmpstr:= BitmapString;
    //draw picture from field
    if bmpstr<>'' then begin
     tmprect:= makerect(adest.x+round((Position+Margin_Left)*fpixelperunit),adest.y,
      round((Width-Margin_Right)*fpixelperunit),adest.cy);
     try
      fbitmapfield.clear;
      fbitmapfield.alignment:= BitmapFieldAlignment;
      fbitmapfield.loadfromstring(bmpstr);
      if isbuilding then begin
       freporttemplate.reportpage.report.addbitmap2toreport(tmprect,fbitmapfield);
      end else begin
       fbitmapfield.paint(acanvas,tmprect);
      end;
     except
      //
     end;
    end;
    finfo.font:= tmpfont;
    finfo.font.name:= font_name;
    finfo.font.color:= font_color;
    finfo.font.style:= fontstyle;
    finfo.font.height:= font_size;
    if finfo.text.text<>'' then begin
     ftextflags:= [];
     case Alignment_Horizontal of 
      ha_Center: begin
       ftextflags:= ftextflags + [tf_xcentered];
      end;
      ha_Right: begin   
       ftextflags:= ftextflags + [tf_right];
      end;
     end;
     case Alignment_Vertical of 
      va_Center: begin
       ftextflags:= ftextflags + [tf_ycentered];
      end;
      va_Bottom: begin   
       ftextflags:= ftextflags + [tf_bottom];
      end;
     end;
     if to_WordBreak in TextOptions then ftextflags:= ftextflags + [tf_wordbreak];
     if to_SoftHyphen in TextOptions then ftextflags:= ftextflags + [tf_softhyphen];
     if to_ConvertTabtoSpace in TextOptions then ftextflags:= ftextflags + [tf_tabtospace];
     if to_Vertical in TextOptions then ftextflags:= ftextflags + [tf_rotate90];
     if to_Flip in TextOptions then ftextflags:= ftextflags + [tf_rotate180];
     if Ellipse<>el_None then begin
      if Ellipse=el_Left then
       ftextflags:= ftextflags + [tf_ellipseleft]
      else
       ftextflags:= ftextflags + [tf_ellipseright];
     end;
     finfo.flags:= ftextflags;
     finfo.dest:= makerect(adest.x+round((Position+Margin_Left)*fpixelperunit),adest.y,
      round((Width-Margin_Right)*fpixelperunit),adest.cy);
     finfo.res:= finfo.dest;
     //draw text
     if isbuilding then begin
      reptabinfo.tabs[int1].text:= finfo.text.text;
      reptabinfo.tabs[int1].dest:= finfo.dest;
      reptabinfo.tabs[int1].flags:= finfo.flags;
      reptabinfo.tabs[int1].fontname:= finfo.font.name;
      reptabinfo.tabs[int1].fontsize:= finfo.font.height;
      reptabinfo.tabs[int1].fontcolor:= finfo.font.color;
      reptabinfo.tabs[int1].fontstyle:= finfo.font.style;
      reptabinfo.tabs[int1].rawfont:= RAW_Font;
      reptabinfo.tabs[int1].rawwidth:= RAW_WidthInChar;
      reptabinfo.tabs[int1].rawpos:= RAW_PosInChar;
     end else begin
      drawtext(acanvas,finfo);
     end;
    end else begin
     if isbuilding then begin
      reptabinfo.tabs[int1].text:= finfo.text.text;
      reptabinfo.tabs[int1].dest:= finfo.dest;
      reptabinfo.tabs[int1].flags:= finfo.flags;
      reptabinfo.tabs[int1].fontname:= finfo.font.name;
      reptabinfo.tabs[int1].fontsize:= finfo.font.height;
      reptabinfo.tabs[int1].fontcolor:= finfo.font.color;
      reptabinfo.tabs[int1].fontstyle:= finfo.font.style;
      reptabinfo.tabs[int1].rawfont:= RAW_Font;
      reptabinfo.tabs[int1].rawwidth:= RAW_WidthInChar;
      reptabinfo.tabs[int1].rawpos:= RAW_PosInChar;
     end;
    end;
    with fbordertop do begin
     if linewidth > 0 then begin
      linestart:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y);
      lineend:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y);
      if isbuilding then begin
       reptabinfo.tabs[int1].bordertop.linewidth:= linewidth;
       reptabinfo.tabs[int1].bordertop.linecolor:= linecolor;
       reptabinfo.tabs[int1].bordertop.capstyle:= capstyle;
       reptabinfo.tabs[int1].bordertop.linestyle:= linestyle;
       reptabinfo.tabs[int1].bordertop.startpoint:= linestart;
       reptabinfo.tabs[int1].bordertop.endpoint:= lineend;     
      end else begin
       acanvas.save;
       acanvas.linewidth:= round(linewidth*fpixelperunit);
       acanvas.capstyle:= capstyle;
       acanvas.dashes:= linestyles[linestyle];
       acanvas.drawline(linestart,lineend,linecolor);
       acanvas.restore;
      end;
     end;
    end;
    with fborderbottom do begin
     if linewidth > 0 then begin
      linestart:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y+round(fheight*fpixelperunit));
      lineend:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y+round(fheight*fpixelperunit));
      if isbuilding then begin
       reptabinfo.tabs[int1].borderbottom.linewidth:= linewidth;
       reptabinfo.tabs[int1].borderbottom.linecolor:= linecolor;
       reptabinfo.tabs[int1].borderbottom.capstyle:= capstyle;
       reptabinfo.tabs[int1].borderbottom.linestyle:= linestyle;
       reptabinfo.tabs[int1].borderbottom.startpoint:= linestart;
       reptabinfo.tabs[int1].borderbottom.endpoint:= lineend;     
      end else begin
       acanvas.save;
       acanvas.linewidth:= round(linewidth*fpixelperunit);
       acanvas.capstyle:= capstyle;
       acanvas.dashes:= linestyles[linestyle];
       acanvas.drawline(linestart,lineend,linecolor);
       acanvas.restore;
      end;
     end;
    end;
    with fborderleft do begin
     if linewidth > 0 then begin
      linestart:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y);
      lineend:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y+round(fheight*fpixelperunit));
      if isbuilding then begin
       reptabinfo.tabs[int1].borderleft.linewidth:= linewidth;
       reptabinfo.tabs[int1].borderleft.linecolor:= linecolor;
       reptabinfo.tabs[int1].borderleft.capstyle:= capstyle;
       reptabinfo.tabs[int1].borderleft.linestyle:= linestyle;
       reptabinfo.tabs[int1].borderleft.startpoint:= linestart;
       reptabinfo.tabs[int1].borderleft.endpoint:= lineend;     
      end else begin
       acanvas.save;
       acanvas.linewidth:= round(linewidth*fpixelperunit);
       acanvas.capstyle:= capstyle;
       acanvas.dashes:= linestyles[linestyle];
       acanvas.drawline(linestart,lineend,linecolor);
       acanvas.restore;
      end;
     end;
    end;
    with fborderright do begin
     if linewidth > 0 then begin
      linestart:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y);
      lineend:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y+round(fheight*fpixelperunit));
      if isbuilding then begin
       reptabinfo.tabs[int1].borderright.linewidth:= linewidth;
       reptabinfo.tabs[int1].borderright.linecolor:= linecolor;
       reptabinfo.tabs[int1].borderright.capstyle:= capstyle;
       reptabinfo.tabs[int1].borderright.linestyle:= linestyle;
       reptabinfo.tabs[int1].borderright.startpoint:= linestart;
       reptabinfo.tabs[int1].borderright.endpoint:= lineend;     
      end else begin
       acanvas.save;
       acanvas.linewidth:= round(linewidth*fpixelperunit);
       acanvas.capstyle:= capstyle;
       acanvas.dashes:= linestyles[linestyle];
       acanvas.drawline(linestart,lineend,linecolor);
       acanvas.restore;
      end;
     end;
    end;
   end;
  end;
  if isbuilding then begin
   reptabinfo.rawemptyrow:= frawlinebelow;
   freporttemplate.reportpage.report.addtabtoreport(reptabinfo);
  end;
 end;
 //reset summary if needed
 if aresetsum then begin
  if items[int1] is TraTabulatorItemSummary then begin
   with TraTabulatorItemSummary(items[int1]) do begin
    if fsummary<>st_None then begin
     fsum.resetpending:= true;
    end;
   end;
  end;
 end;
 fbitmapfield.free;
 tmpfont.free;
end;

procedure TraTabulators.paintextend(const acanvas: tcanvas; const adest: rectty;
  const isbuilding:boolean;const aleft:boolean;const aright:boolean;const atop:boolean;const abottom:boolean);
var
 int1: integer;
 tmprect: rectty;
 linestart: pointty;
 lineend: pointty;
 reptabinfo: reptabinfoty;
begin
 if count > 0 then begin
  //draw text, background cell and picture
  setlength(reptabinfo.tabs,count);
  for int1:= 0 to count - 1 do begin
   with items[int1] do begin
    //draw background cell
    if (Color<>cl_none) and (Color<>cl_transparent)then begin
     tmprect:= makerect(adest.x+round(Position*fpixelperunit),adest.y,
     round(Width*fpixelperunit),adest.cy);
     if isbuilding then begin
      freporttemplate.reportpage.report.addrect2toreport(createrectinfo(tmprect,Color));
     end else begin
      acanvas.fillrect(tmprect,Color);
     end;
    end;
    //draw picture
    if bitmap.hasimage then begin
     tmprect:= makerect(adest.x+round(Position*fpixelperunit),adest.y,
       round(Width*fpixelperunit),adest.cy);
     if isbuilding then begin
      freporttemplate.reportpage.report.addbitmap1toreport(tmprect,bitmap);
     end else begin
      bitmap.paint(acanvas,tmprect);
     end;
    end;
    if isbuilding then begin
     reptabinfo.tabs[int1].text:= '';
     reptabinfo.tabs[int1].dest:= nullrect;
     reptabinfo.tabs[int1].flags:= [];
     reptabinfo.tabs[int1].fontname:= '';
     reptabinfo.tabs[int1].fontsize:= 0;
     reptabinfo.tabs[int1].fontcolor:= cl_transparent;
     reptabinfo.tabs[int1].fontstyle:= [];
     reptabinfo.tabs[int1].rawfont:= RAW_Font;
     reptabinfo.tabs[int1].rawwidth:= RAW_WidthInChar;
     reptabinfo.tabs[int1].rawpos:= RAW_PosInChar;
    end;
    if atop then begin
     with fbordertop do begin
      if linewidth > 0 then begin
       linestart:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y);
       lineend:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y);
       if isbuilding then begin
        reptabinfo.tabs[int1].bordertop.linewidth:= linewidth;
        reptabinfo.tabs[int1].bordertop.linecolor:= linecolor;
        reptabinfo.tabs[int1].bordertop.capstyle:= capstyle;
        reptabinfo.tabs[int1].bordertop.linestyle:= linestyle;
        reptabinfo.tabs[int1].bordertop.startpoint:= linestart;
        reptabinfo.tabs[int1].bordertop.endpoint:= lineend;     
       end else begin
        acanvas.save;
        acanvas.linewidth:= round(linewidth*fpixelperunit);
        acanvas.capstyle:= capstyle;
        acanvas.dashes:= linestyles[linestyle];
        acanvas.drawline(linestart,lineend,linecolor);
        acanvas.restore;
       end;
      end;
     end;
    end;
    if abottom then begin
     with fborderbottom do begin
      if linewidth > 0 then begin
       linestart:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y+round(fheight*fpixelperunit));
       lineend:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y+round(fheight*fpixelperunit));
       if isbuilding then begin
        reptabinfo.tabs[int1].borderbottom.linewidth:= linewidth;
        reptabinfo.tabs[int1].borderbottom.linecolor:= linecolor;
        reptabinfo.tabs[int1].borderbottom.capstyle:= capstyle;
        reptabinfo.tabs[int1].borderbottom.linestyle:= linestyle;
        reptabinfo.tabs[int1].borderbottom.startpoint:= linestart;
        reptabinfo.tabs[int1].borderbottom.endpoint:= lineend;     
       end else begin
        acanvas.save;
        acanvas.linewidth:= round(linewidth*fpixelperunit);
        acanvas.capstyle:= capstyle;
        acanvas.dashes:= linestyles[linestyle];
        acanvas.drawline(linestart,lineend,linecolor);
        acanvas.restore;
       end;
      end;
     end;
    end;
    if aleft then begin
     with fborderleft do begin
      if linewidth > 0 then begin
       linestart:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y);
       lineend:= makepoint(adest.x+round(items[int1].position*fpixelperunit),adest.y+adest.cy);
       if isbuilding then begin
        reptabinfo.tabs[int1].borderleft.linewidth:= linewidth;
        reptabinfo.tabs[int1].borderleft.linecolor:= linecolor;
        reptabinfo.tabs[int1].borderleft.capstyle:= capstyle;
        reptabinfo.tabs[int1].borderleft.linestyle:= linestyle;
        reptabinfo.tabs[int1].borderleft.startpoint:= linestart;
        reptabinfo.tabs[int1].borderleft.endpoint:= lineend;     
       end else begin
        acanvas.save;
        acanvas.linewidth:= round(linewidth*fpixelperunit);
        acanvas.capstyle:= capstyle;
        acanvas.dashes:= linestyles[linestyle];
        acanvas.drawline(linestart,lineend,linecolor);
        acanvas.restore;
       end;
      end;
     end;
    end;
    if aright then begin
     with fborderright do begin
      if linewidth > 0 then begin
       linestart:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y);
       lineend:= makepoint(adest.x+round((items[int1].position+items[int1].width)*fpixelperunit),adest.y+adest.cy);
       if isbuilding then begin
        reptabinfo.tabs[int1].borderright.linewidth:= linewidth;
        reptabinfo.tabs[int1].borderright.linecolor:= linecolor;
        reptabinfo.tabs[int1].borderright.capstyle:= capstyle;
        reptabinfo.tabs[int1].borderright.linestyle:= linestyle;
        reptabinfo.tabs[int1].borderright.startpoint:= linestart;
        reptabinfo.tabs[int1].borderright.endpoint:= lineend;     
       end else begin
        acanvas.save;
        acanvas.linewidth:= round(linewidth*fpixelperunit);
        acanvas.capstyle:= capstyle;
        acanvas.dashes:= linestyles[linestyle];
        acanvas.drawline(linestart,lineend,linecolor);
        acanvas.restore;
       end;
      end;
     end;
    end;
   end;
  end;
  if isbuilding then begin
   reptabinfo.rawemptyrow:= frawlinebelow;
   freporttemplate.reportpage.report.addtabtoreport(reptabinfo);
  end;
 end;
end;

procedure TraTabulators.paint(const acanvas: tcanvas; const adest: rectty;
  const isbuilding:boolean;const aresetsum: boolean);
begin
 processvalues(acanvas,adest,aresetsum,isbuilding);
 if not isbuilding then begin
  drawlimittabs(acanvas,adest);
 end;
end;

function TraTabulators.getpixelheight: integer;
begin
 result:= round(fheight*fpixelperunit);
end;

procedure TraTabulators.dochange(const aindex: integer);
begin
 inherited;
end;

procedure TraTabulators.createitem(const index: integer;
                  var item: tpersistent);
begin
 item:= TraTabulatorItem.create(self);
 if index>0 then begin
  TraTabulatorItem(item).position:= self.items[index-1].position+self.items[index-1].width;
 end;
end;

procedure TraTabulators.resetsums(const skipcurrent: boolean);
var
 int1: integer;
begin
 for int1:= 0 to high(fitems) do begin
  if fitems[int1] is TraTabulatorItemSummary then begin
   TraTabulatorItemSummary(fitems[int1]).resetsum(skipcurrent);
  end;
 end;
end;

procedure TraTabulators.initsums;
var
 int1: integer;
begin
 for int1:= 0 to high(fitems) do begin
  if fitems[int1] is TraTabulatorItemSummary then begin
   TraTabulatorItemSummary(fitems[int1]).initsum;
  end;
 end;
end;

procedure TraTabulators.updatelinks;
var
 int1: integer;
begin
 setdatasource(fdatasourcestr);
 for int1:= 0 to count - 1 do begin
  items[int1].updatelinks;
 end;
end;

function TraTabulators.drawzebra(const acanvas: tcanvas; const adest: rectty):boolean;
var
 ainfo: reprectinfoty;
 bo1: boolean;
 int1: integer;
begin
 bo1:= false;
 if (fZebra_Height > 0) and (fZebra_Step > 0) then begin
  inc(fZebra_Counter);
  int1:= (fZebra_Counter - fZebra_Start) mod fZebra_Step;
  if int1 < 0 then begin
   if int1  < fZebra_Height - fZebra_Step then begin
    bo1:= true;
   end;
  end
  else begin
   if int1 < fZebra_Height then begin
    bo1:= true;
   end;
  end;
 end;
 result:= bo1;
 if bo1 then begin
  ainfo.rectarea:= adest;
  ainfo.color:= fZebra_Color;
  freporttemplate.reportpage.report.addrect1toreport(ainfo);
 end;
end;

procedure TraTabulators.init;
begin
 if fdatalink.DataSource=nil then begin
  setdatasource(fdatasourcestr);
 end;
 initsums;
 fZebra_Counter:= 0;
 if fdatalink.active then begin
  try
   if (frecordarea=ra_AllRecord) or (frecordarea=ra_FirstRecord) then begin
    fdatalink.dataset.first;
   end else if (frecordarea=ra_LastRecord) then begin
    fdatalink.dataset.last;
   end;
  finally
  end;
 end; 
end;

procedure TraTabulators.initpage;
begin
 if (zo_ResetOnPageStart in fZebra_Options) then begin
  fZebra_Counter:= 0;
 end;
end;

procedure TraTabulators.resetzebra;
begin
 fZebra_Counter:= 0;
end;

procedure TraTabulators.dobeforenextrecord(const adatasource: tdatasource);
var
 int1: integer;
begin
 for int1:= 0 to high(fitems) do begin
  TraTabulatorItem(fitems[int1]).dobeforenextrecord(adatasource);
 end;
end;

procedure TraTabulators.nextrecord;
begin
 try
  dobeforenextrecord(fdatalink.DataSource);
  if fdatalink.active then begin
   fdatalink.dataset.next;
  end;
 finally
 end;
end;

procedure TraTabulators.drawlimittabs(const acanvas: tcanvas; const adest: rectty);
var
 ar1: segmentarty;
 int1: integer;
begin
 if count=0 then exit;
 setlength(ar1,count*2);
 for int1:= 0 to count-1 do begin
  with ar1[(int1*2)] do begin
   a.x:= round(items[int1].Position*fpixelperunit)+adest.x;
   a.y:= adest.y;
   b.x:= a.x;
   b.y:= adest.y+pixelheight;
  end;
  with ar1[(int1*2)+1] do begin
   a.x:= ar1[int1*2].a.x+round(items[int1].Width*fpixelperunit)+adest.x;
   a.y:= adest.y;
   b.x:= a.x;
   b.y:= adest.y+pixelheight;
  end;
 end;
 acanvas.save;
 acanvas.dashes:= #2#2;
 acanvas.drawlinesegments(ar1,cl_red);
 acanvas.dashes:= '';
 acanvas.restore;
end;

procedure TraTabulators.setdatasource(const avalue: string);
var
 int1: integer;
 tmpdatasource: tdatasource;
 xx: TComponentState;
begin
 xx:= freporttemplate.reportpage.componentstate;
 if (fdatasourcestr<>avalue) or (fdatalink.datasource=nil) then begin
  fdatasourcestr:= avalue;
  if xx*[{csloading,}csreading] = [] then begin
   if (avalue <> '') then begin
    tmpdatasource:= freporttemplate.reportpage.report.getdatasourcereport(avalue);
    if tmpdatasource<>nil then begin
     fdatalink.DataSource:= tmpdatasource;
     if csdesigning in xx then begin
      for int1:= 0 to count - 1 do begin
       if items[int1].datasource='' then begin
        items[int1].fdatasourcestr:= avalue;
        items[int1].fdatalink.datasource:= tmpdatasource;
       end;
      end;
     end;
    end;
   end;
  end;
 end;
end;

function TraTabulators.getdatasource: string;
begin
 result:= fdatasourcestr;
end;

function TraTabulators.iseof: boolean;
begin
 result:= false;
 if fdatalink.active then begin
  result:= fdatalink.eof;
 end else begin
  result:= true;
 end;
end;

function TraTabulators.recordcount: integer;
begin
 result:= -1;
 if fdatalink.active then begin
  result:= fdatalink.dataset.recordcount;
 end; 
end;

{ TSummaryTabs }

constructor TSummaryTabs.create(const aowner: TraReportTemplate);
begin
 inherited;
end;

class function TSummaryTabs.getitemclass: tratabulatoritemsummaryclassty;
begin
 result:= TraTabulatorItemSummary;
end;

procedure TSummaryTabs.createitem(const index: integer;
                  var item: tpersistent);
begin
 item:= TraTabulatorItemSummary.create(self);
end;

function TSummaryTabs.getitemssummary(const index: integer): TraTabulatorItemSummary;
begin
 result:= TraTabulatorItemSummary(inherited items[index]);
end;

procedure TSummaryTabs.setitemssummary(const index: integer;
               const avalue: TraTabulatorItemSummary);
begin
 inherited items[index]:= avalue;
end;

{ TNormalTabs }

constructor TNormalTabs.create(const aowner: TraReportTemplate);
begin
 inherited;
end;

{ TraReportTemplate }

constructor TraReportTemplate.create(aowner: tcomponent);
begin
 inherited;
 if aowner is TraPage then begin
  freportpage:= TraPage(aowner);
  fpixelperunit:= freportpage.PixelPerUnit;
 end else begin
  fpixelperunit:= defaultreppixelpermm;
 end;
 freportheader:= TNormalTabsCol.create(self);
 freportheader2:= TNormalTabsCol.create(self);
 freportfooter:= TSummaryTabsCol.create(self);
 fpageheader:= TNormalTabsCol.create(self);
 fpagefooter:= TNormalTabsCol.create(self);
 freportheaderheight:= defaulttabsheight/fpixelperunit;
 freportheader2height:= defaulttabsheight/fpixelperunit;
 freportfooterheight:= defaulttabsheight/fpixelperunit;
 fpageheaderheight:= defaulttabsheight/fpixelperunit;
 fpagefooterheight:= defaulttabsheight/fpixelperunit;
 freportheadershow:= hrs_FirstPageOnly;
 freportheader2show:= hrs_FirstPageOnly;
 freportfootershow:= frs_LastPageOnly;
 freportfooteroptions:= defaultfreportoptions;
 fbitmap:= tmaskedbitmap.create(false);
 fobjectpicker:= tobjectpicker.create(iobjectpicker(self),org_widget);
 fpickkind:= -1;
 fpickarrayindex:= -1;
end;

destructor TraReportTemplate.destroy;
begin
 freportheader.free;
 freportheader2.free;
 freportfooter.free;
 fpageheader.free;
 fpagefooter.free;
 fobjectpicker.free;
 fbitmap.free;
 inherited;
end;

procedure TraReportTemplate.loaded;
begin
 inherited;
 {if (csdesigning in componentstate) and (fobjectpicker = nil) then begin
  fobjectpicker:= tobjectpicker.create(iobjectpicker(self));
  fpickkind:= -1;
  fpickarrayindex:= -1;
 end;}
end;

procedure TraReportTemplate.sizechanged;
begin
 inherited;
 //if (csdesigning in componentstate) then begin
  fwidth:= self.width/fpixelperunit;
  fheight:= self.height/fpixelperunit;
 //end;
end;

procedure TraReportTemplate.poschanged;
begin
 inherited;
 //if (csdesigning in componentstate) then begin
  fleft:= self.left/fpixelperunit;
  ftop:= self.top/fpixelperunit;
 //end;
end;

function TraReportTemplate.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;

procedure TraReportTemplate.setbitmap(const Value: tmaskedbitmap);
begin
 if Value<>fbitmap then begin
  fbitmap.assign(Value);
 end;
end;

procedure TraReportTemplate.setparentwidget(const avalue: twidget);
begin
 if avalue is TraPage then begin
  freportpage:= TraPage(avalue);
  setpixelperunit(freportpage.PixelPerUnit);
 end;
 inherited;
end;

procedure TraReportTemplate.setcontentpixelperunit(const avalue: real);
begin
 //to set actual pixel per unit in content report as unit that is used
end;

procedure TraReportTemplate.setpixelperunit(const avalue: real);
begin
 if avalue <> fpixelperunit then begin
  fpageheaderheight:= (fpageheaderheight*fpixelperunit)/avalue;
  fpagefooterheight:= (fpagefooterheight*fpixelperunit)/avalue;
  freportheaderheight:= (freportheaderheight*fpixelperunit)/avalue;
  freportheader2height:= (freportheader2height*fpixelperunit)/avalue;
  freportfooterheight:= (freportfooterheight*fpixelperunit)/avalue;
  fleft:= (fleft*fpixelperunit)/avalue;
  ftop:= (ftop*fpixelperunit)/avalue;
  fwidth:= (fwidth*fpixelperunit)/avalue;
  fheight:= (fheight*fpixelperunit)/avalue;
  fpageheader.setpixelperunit(avalue);
  freportheader.setpixelperunit(avalue);
  freportheader2.setpixelperunit(avalue);
  freportfooter.setpixelperunit(avalue);
  fpagefooter.setpixelperunit(avalue);
  setcontentpixelperunit(avalue); //content
  fpixelperunit:= avalue;
 end;
end;

procedure TraReportTemplate.setposleft(const avalue: real);
begin
 if avalue<>fleft then begin
  fleft:= avalue;
  self.left:= round(avalue*fpixelperunit);
 end;
end;

procedure TraReportTemplate.setpostop(const avalue: real);
begin
 if avalue<>ftop then begin
  ftop:= avalue;
  self.top:= round(avalue*fpixelperunit);
 end;
end;
procedure TraReportTemplate.setareawidth(const avalue: real);
begin
 if avalue<>fwidth then begin
  fwidth:= avalue;
  self.width:= round(avalue*fpixelperunit);
 end;
end;
procedure TraReportTemplate.setareaheight(const avalue: real);
begin
 if avalue<>fheight then begin
  fheight:= avalue;
  self.height:= round(avalue*fpixelperunit);
 end;
end;

function TraReportTemplate.getpixelperunit: real;
begin
 if freportpage<>nil then
  result:= freportpage.PixelPerUnit
 else
  result:= defaultreppixelpermm;
end;

function TraReportTemplate.buildcontent(const acanvas: tcanvas;const contentarea:rectty;
 var islastpage: boolean):integer;
begin
 //result last position of report footer and will ignored by inherited class
 if fpagefooter.count>0 then begin
  result:= fwidgetrect.cy-round(fpagefooterheight*fpixelperunit)-round(freportfooterheight*fpixelperunit);
 end else begin
  result:= fwidgetrect.cy-round(freportfooterheight*fpixelperunit);
 end;
end;

procedure TraReportTemplate.contentinit;
begin
 //
end;

procedure TraReportTemplate.contentupdatelinks;
begin
 //
end;

procedure TraReportTemplate.updatelinks;
var
 int1: integer;
begin
 for int1:=0 to freportheader.count-1 do begin
  freportheader.items[int1].tabulators.updatelinks;
 end;
 for int1:=0 to freportheader2.count-1 do begin
  freportheader2.items[int1].tabulators.updatelinks;
 end;
 for int1:=0 to freportfooter.count-1 do begin
  freportfooter.items[int1].tabulators.updatelinks;
 end;
 if (fpageheader.count>0) then begin
  for int1:=0 to fpageheader.count-1 do begin
   fpageheader.items[int1].tabulators.updatelinks;
  end;
 end;
 if (fpagefooter.count>0) then begin
  for int1:=0 to fpagefooter.count-1 do begin
   fpagefooter.items[int1].tabulators.updatelinks;
  end;
 end;
 contentupdatelinks;
end;

procedure TraReportTemplate.build(const acanvas: tcanvas);
var
 int1: integer;
 posy,hband: integer;
 islastpage,areset: boolean;
 contentarea: rectty;
begin
 islastpage:= false;
 //init summary for report footer
 for int1:=0 to freportfooter.count-1 do begin
  freportfooter.items[int1].tabulators.init;
 end;
 contentinit;
 while not islastpage do begin
  posy:=0;
  freportpage.newpage;
  if fbitmap<>nil then begin
   freportpage.report.addbitmaptoreport(fwidgetrect,fbitmap);
  end; 
  if (fpageheader.count>0) then begin
   posy:= 0;
   hband:= 0;
   for int1:=0 to fpageheader.count-1 do begin
    with fpageheader.items[int1] do begin
     inc(hband,tabulators.pixelheight);
     if hband<=round(fpageheaderheight*fpixelperunit) then begin
      tabulators.init;
      tabulators.paint(acanvas,makerect(fwidgetrect.x,
      fwidgetrect.y+posy,fwidgetrect.cx,tabulators.pixelheight),true,false);
     end else begin
      break;
     end;
     inc(posy,tabulators.pixelheight);
    end;
   end;
  end;
  if (freportheader.count>0) and 
   ((freportheadershow=hrs_EveryPage) or 
   ((freportheadershow=hrs_FirstPageOnly) and (freportpage.pagenum=1))) then begin
   if fpageheader.count>0 then begin
    posy:= round(fpageheaderheight*fpixelperunit);
   end else begin
    posy:= 0;
   end;
   hband:= 0;
   for int1:=0 to freportheader.count-1 do begin
    with freportheader.items[int1] do begin
     inc(hband,tabulators.pixelheight);
     if hband<=round(freportheaderheight*fpixelperunit) then begin
      tabulators.init;
      tabulators.paint(acanvas,makerect(fwidgetrect.x,
      fwidgetrect.y+posy,fwidgetrect.cx,tabulators.pixelheight),true,false);
     end else begin
      break;
     end;
     inc(posy,tabulators.pixelheight);
    end;
   end;
  end;
  if (freportheader2.count>0) and 
   ((freportheader2show=hrs_EveryPage) or 
   ((freportheader2show=hrs_FirstPageOnly) and (freportpage.pagenum=1))) then begin
   hband:= 0;
   for int1:=0 to freportheader2.count-1 do begin
    with freportheader2.items[int1] do begin
     inc(hband,tabulators.pixelheight);
     if hband<=round(freportheader2height*fpixelperunit) then begin
      tabulators.init;
      tabulators.paint(acanvas,makerect(fwidgetrect.x,
      fwidgetrect.y+posy,fwidgetrect.cx,tabulators.pixelheight),true,false);
     end else begin
      break;
     end;
     inc(posy,tabulators.pixelheight);
    end;
   end;
  end;
  contentarea.y:= fwidgetrect.y;
  contentarea.x:= fwidgetrect.x;
  contentarea.cx:= fwidgetrect.cx;
  contentarea.cy:= fwidgetrect.cy;
  if fpageheader.count>0 then begin
   contentarea.y:= contentarea.y + round(fpageheaderheight*fpixelperunit);
   contentarea.cy:= contentarea.cy - round(fpageheaderheight*fpixelperunit);
  end;
  if (freportheader.count>0) and 
   ((freportheadershow=hrs_EveryPage) or 
   ((freportheadershow=hrs_FirstPageOnly) and (freportpage.pagenum=1))) then begin
   contentarea.y:= contentarea.y + round(freportheaderheight*fpixelperunit);
   contentarea.cy:= contentarea.cy - round(freportheaderheight*fpixelperunit);
  end;
  if (freportheader2.count>0) and 
   ((freportheader2show=hrs_EveryPage) or 
   ((freportheader2show=hrs_FirstPageOnly) and (freportpage.pagenum=1))) then begin
   contentarea.y:= contentarea.y + round(freportheader2height*fpixelperunit);
   contentarea.cy:= contentarea.cy - round(freportheader2height*fpixelperunit);
  end;
  if fpagefooter.count>0 then begin
   contentarea.cy:= contentarea.cy - round(fpagefooterheight*fpixelperunit);
  end;
  posy:= buildcontent(acanvas,contentarea,islastpage);
  if (freportfooter.count>0) and 
   ((freportfootershow=frs_EveryPage) or 
   ((freportfootershow=frs_LastPageOnly) and islastpage)) then begin
   if fro_PrintOnBottomPage in freportfooteroptions then begin
    if fpagefooter.count>0 then begin
     posy:= fwidgetrect.y+fwidgetrect.cy-round(fpagefooterheight*fpixelperunit)-round(freportfooterheight*fpixelperunit);
    end else begin
     posy:= fwidgetrect.y+fwidgetrect.cy-round(freportfooterheight*fpixelperunit);
    end;
   end;
   if fro_ResetEveryPage in freportfooteroptions then begin
    areset:= true;
   end else begin
    areset:= false;
   end;
   hband:= 0;
   for int1:=0 to freportfooter.count-1 do begin
    with freportfooter.items[int1] do begin
     inc(hband,tabulators.pixelheight);
     if hband<=round(freportfooterheight*fpixelperunit) then begin
      tabulators.paint(acanvas,makerect(fwidgetrect.x,
      posy,fwidgetrect.cx,tabulators.pixelheight),true,areset);
     end else begin
      break;
     end;
     inc(posy,tabulators.pixelheight);
    end;
   end;
  end;
  if (fpagefooter.count>0) then begin
   posy:= fwidgetrect.cy-round(fpagefooterheight*fpixelperunit);
   hband:= 0;
   for int1:=0 to fpagefooter.count-1 do begin
    with fpagefooter.items[int1] do begin
     inc(hband,tabulators.pixelheight);
     if hband<=round(fpagefooterheight*fpixelperunit) then begin
      tabulators.init;
      tabulators.paint(acanvas,makerect(fwidgetrect.x,
      fwidgetrect.y+posy,fwidgetrect.cx,tabulators.pixelheight),true,false);
     end else begin
      break;
     end;
     inc(posy,tabulators.pixelheight);
    end;
   end;
  end;
 end;
 endbuild;
end;

procedure TraReportTemplate.doonpaint(const acanvas: tcanvas);
begin
 //
end;

procedure TraReportTemplate.endbuild;
begin
 //
end;

procedure TraReportTemplate.drawcontent(const canvas: tcanvas;const contentarea:rectty);
begin
 //
end;

procedure TraReportTemplate.paint(const canvas: tcanvas);
var
 int1: integer;
 posy,hband: integer;
 contentarea: rectty;
begin
 inherited;
 if componentstate*[csloading,csreading]<>[] then exit;
 posy:=0;
 if fbitmap<>nil then begin
  fbitmap.paint(canvas,makerect(0,0,fwidgetrect.cx,fwidgetrect.cy));
 end;
 if (fpageheader.count>0) then begin
  posy:= 0;
  hband:= 0;
  for int1:=0 to fpageheader.count-1 do begin
   with fpageheader.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(fpageheaderheight*fpixelperunit)) then begin
     tabulators.yposition:= posy;
     tabulators.paint(canvas,makerect(0,posy,fwidgetrect.cx,tabulators.pixelheight),false,false);
    end else begin
     break;
    end;
    inc(posy,tabulators.pixelheight);
   end;
  end;
 end;
 if (freportheader.count>0) then begin
  if fpageheader.count>0 then begin
   posy:= round(fpageheaderheight*fpixelperunit);
  end else begin
   posy:= 0;
  end;
  hband:= 0;
  for int1:=0 to freportheader.count-1 do begin
   with freportheader.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(freportheaderheight*fpixelperunit)) then begin
     tabulators.yposition:= posy;
     tabulators.paint(canvas,makerect(0,posy,fwidgetrect.cx,tabulators.pixelheight),false,false);
    end else begin
     break;
    end;
    inc(posy,tabulators.pixelheight);
   end;
  end;
 end;
 if (freportheader2.count>0) then begin
  hband:= 0;
  for int1:=0 to freportheader2.count-1 do begin
   with freportheader2.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(freportheader2height*fpixelperunit)) then begin
     tabulators.yposition:= posy;
     tabulators.paint(canvas,makerect(0,posy,fwidgetrect.cx,tabulators.pixelheight),false,false);
    end else begin
     break;
    end;
    inc(posy,tabulators.pixelheight);
   end;
  end;
 end;
 contentarea.y:= 0;
 contentarea.x:= 0;
 contentarea.cx:= fwidgetrect.cx;
 contentarea.cy:= fwidgetrect.cy;
 if fpageheader.count>0 then begin
  contentarea.y:= contentarea.y + round(fpageheaderheight*fpixelperunit);
  contentarea.cy:= contentarea.cy - round(fpageheaderheight*fpixelperunit);
 end;
 if freportheader.count>0 then begin
  contentarea.y:= contentarea.y + round(freportheaderheight*fpixelperunit);
  contentarea.cy:= contentarea.cy - round(freportheaderheight*fpixelperunit);
 end;
 if freportheader2.count>0 then begin
  contentarea.y:= contentarea.y + round(freportheader2height*fpixelperunit);
  contentarea.cy:= contentarea.cy - round(freportheader2height*fpixelperunit);
 end;
 if freportfooter.count>0 then begin
  contentarea.cy:= contentarea.cy - round(freportfooterheight*fpixelperunit);
 end;
 if fpagefooter.count>0 then begin
  contentarea.cy:= contentarea.cy - round(fpagefooterheight*fpixelperunit);
 end;
 drawcontent(canvas,contentarea);
 if (freportfooter.count>0) then begin
  if fpagefooter.count>0 then begin
   posy:= fwidgetrect.cy-round(fpagefooterheight*fpixelperunit)-round(freportfooterheight*fpixelperunit);
  end else begin
   posy:= fwidgetrect.cy-round(freportfooterheight*fpixelperunit);
  end;
  hband:= 0;
  for int1:=0 to freportfooter.count-1 do begin
   with freportfooter.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(freportfooterheight*fpixelperunit)) then begin
     tabulators.yposition:= posy;
     tabulators.paint(canvas,makerect(0,posy,fwidgetrect.cx,tabulators.pixelheight),false,false);
    end else begin
     break;
    end;
    inc(posy,tabulators.pixelheight);
   end;
  end;
 end;
 if (fpagefooter.count>0) then begin
  posy:= fwidgetrect.cy-round(fpagefooterheight*fpixelperunit);
  hband:= 0;
  for int1:=0 to fpagefooter.count-1 do begin
   with fpagefooter.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(fpagefooterheight*fpixelperunit)) then begin
     tabulators.yposition:= posy;
     tabulators.paint(canvas,makerect(0,posy,fwidgetrect.cx,tabulators.pixelheight),false,false);
    end else begin
     break;
    end;
    inc(posy,tabulators.pixelheight);
   end;
  end;
 end;
end;

function TraReportTemplate.expressiondialog(const aexpression: msestring): msestring;   
var
 dialog: trepazevaldialog;
begin
 try
  dialog:= trepazevaldialog.create(nil);
  dialog.evaluator:= freportpage.report.getevaluator;
  dialog.expression:= aexpression;
  if dialog.execute then begin
   result:= dialog.expression;
  end else begin
   result:= aexpression;
  end;
 finally
  dialog.free;
 end;
end;

function TraReportTemplate.reportheadervalue(indexrow: integer; indexcol:integer): variant;
begin
 if (indexrow>=0) and (indexrow<=freportheader.count-1) then begin
  if (indexcol>=0) and (indexcol<=freportheader.items[indexrow].tabulators.count-1) then begin
   result:= freportheader.items[indexrow].tabulators.items[indexcol].value;
  end;
 end;
end;

function TraReportTemplate.reportfootervalue(indexrow: integer; indexcol:integer): variant;
begin
 if (indexrow>=0) and (indexrow<=freportfooter.count-1) then begin
  if (indexcol>=0) and (indexcol<=freportfooter.items[indexrow].tabulators.count-1) then begin
   result:= freportfooter.items[indexrow].tabulators.items[indexcol].value;
  end;
 end;
end;

function TraReportTemplate.pageheadervalue(indexrow: integer; indexcol:integer): variant;
begin
 if (indexrow>=0) and (indexrow<=fpageheader.count-1) then begin
  if (indexcol>=0) and (indexcol<=fpageheader.items[indexrow].tabulators.count-1) then begin
   result:= fpageheader.items[indexrow].tabulators.items[indexcol].value;
  end;
 end;
end;

function TraReportTemplate.pagefootervalue(indexrow: integer; indexcol:integer): variant;
begin
 if (indexrow>=0) and (indexrow<=fpagefooter.count-1) then begin
  if (indexcol>=0) and (indexcol<=fpagefooter.items[indexrow].tabulators.count-1) then begin
   result:= fpagefooter.items[indexrow].tabulators.items[indexcol].value;
  end;
 end;
end;

function TraReportTemplate.recordnumber: integer;
begin
 //
end;

function TraReportTemplate.masternumber: integer;
begin
 //
end;

function TraReportTemplate.datanumber: integer;
begin
 //
end;

procedure TraReportTemplate.addcontentdatasets(var adatasets: datasetarty);
begin
 //
end;

procedure TraReportTemplate.adddatasets(var adatasets: datasetarty);
var
 int1: integer;
begin
 if (fpageheader.count>0) then begin
  for int1:=0 to fpageheader.count-1 do begin
   if fpageheader.items[int1].tabulators.fdatalink.dataset <> nil then begin
    adduniqueitem(pointerarty(adatasets),fpageheader.items[int1].tabulators.fdatalink.dataset);
   end;
  end;
 end;
 if (fpagefooter.count>0) then begin
  for int1:=0 to fpagefooter.count-1 do begin
   if fpagefooter.items[int1].tabulators.fdatalink.dataset <> nil then begin
    adduniqueitem(pointerarty(adatasets),fpagefooter.items[int1].tabulators.fdatalink.dataset);
   end;
  end;
 end;
 if (freportheader.count>0) then begin
  for int1:=0 to freportheader.count-1 do begin
   if freportheader.items[int1].tabulators.fdatalink.dataset <> nil then begin
    adduniqueitem(pointerarty(adatasets),freportheader.items[int1].tabulators.fdatalink.dataset);
   end;
  end;
 end;
 if (freportheader2.count>0) then begin
  for int1:=0 to freportheader2.count-1 do begin
   if freportheader2.items[int1].tabulators.fdatalink.dataset <> nil then begin
    adduniqueitem(pointerarty(adatasets),freportheader2.items[int1].tabulators.fdatalink.dataset);
   end;
  end;
 end;
 if (freportfooter.count>0) then begin
  for int1:=0 to freportfooter.count-1 do begin
   if freportfooter.items[int1].tabulators.fdatalink.dataset <> nil then begin
    adduniqueitem(pointerarty(adatasets),freportfooter.items[int1].tabulators.fdatalink.dataset);
   end;
  end;
 end;
 addcontentdatasets(adatasets);
end;

function TraReportTemplate.pagenum: integer;
begin
 result:= freportpage.pagenum;
end;

procedure TraReportTemplate.contentgetpickobjects(const sender: tobjectpicker; var objects: integerarty);
begin
 //
end;
                                  
procedure TraReportTemplate.contentendpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                       const aoffset: pointty; const aobjects: integerarty);
begin
 //
end;

function TraReportTemplate.getcursorshape(const sender: tobjectpicker; var shape: cursorshapety): boolean;
var
 ar1: integerarty;
begin
 getpickobjects(sender,ar1);
 if length(ar1)>0 then begin
  if fpickkind=-1 then begin
   result:= false;
  end else begin
   shape:= cr_sizehor;
   result:= true;
  end;
 end else begin
  result:= false;
 end;
end;

procedure TraReportTemplate.getpickobjects(const sender: tobjectpicker;var objects: integerarty);
var
 int1,int2,int3,int4: integer;
 arect: rectty;
begin
 fpickkind:= -1;
 fpickarrayindex:= -1;
 arect:= sender.pickrect;
 if fframe <> nil then begin
  int3:= arect.x - frame.framei_left;
 end
 else begin
  int3:= arect.x;
 end;
 if (fpageheader.count>0) then begin
  for int1:=0 to fpageheader.count-1 do begin
   with fpageheader.items[int1] do begin
    for int2:=0 to tabulators.count-1 do begin
     if (sender.pos.y>=tabulators.yposition) and (sender.pos.y<=tabulators.yposition+tabulators.pixelheight) then begin
      int4:= round(tabulators.items[int2].Position*fpixelperunit);
      int4:= abs(int3 - int4);
      if int4 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 0;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
 if (freportheader.count>0) then begin
  for int1:=0 to freportheader.count-1 do begin
   with freportheader.items[int1] do begin
    for int2:=0 to tabulators.count-1 do begin
     if (sender.pos.y>=tabulators.yposition) and (sender.pos.y<=tabulators.yposition+tabulators.pixelheight) then begin
      int4:= round(tabulators.items[int2].Position*fpixelperunit);
      int4:= abs(int3 - int4);
      if int4 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 1;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
 contentgetpickobjects(sender,objects);
 if (freportfooter.count>0) then begin
  for int1:=0 to freportfooter.count-1 do begin
   with freportfooter.items[int1] do begin
    for int2:=0 to tabulators.count-1 do begin
     if (sender.pos.y>=tabulators.yposition) and (sender.pos.y<=tabulators.yposition+tabulators.pixelheight) then begin
      int4:= abs(int3 - round(tabulators.items[int2].Position*fpixelperunit));
      if int4 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 3;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
 if (fpagefooter.count>0) then begin
  for int1:=0 to fpagefooter.count-1 do begin
   with fpagefooter.items[int1] do begin
    for int2:=0 to tabulators.count-1 do begin
     if (sender.pos.y>=tabulators.yposition) and (sender.pos.y<=tabulators.yposition+tabulators.pixelheight) then begin
      int4:= abs(int3 - round(tabulators.items[int2].Position*fpixelperunit));
      if int4 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 2;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure TraReportTemplate.beginpickmove(const sender: tobjectpicker);
begin
 //
end;

procedure TraReportTemplate.endpickmove(const sender: tobjectpicker);
begin
 if sender.currentobjects=nil then exit;
 case fpickkind of
  0: begin
      with fpageheader[fpickarrayindex].tabulators do begin
       items[sender.currentobjects[0]].position:= items[sender.currentobjects[0]].position+(sender.pickoffset.x/fpixelperunit);
       if sender.currentobjects[0]>=1 then begin
        items[sender.currentobjects[0]-1].width:= items[sender.currentobjects[0]-1].width+(sender.pickoffset.x/fpixelperunit);
       end;
      end;
     end;
  1: begin
      with freportheader[fpickarrayindex].tabulators do begin
       items[sender.currentobjects[0]].position:= items[sender.currentobjects[0]].position+(sender.pickoffset.x/fpixelperunit);
       if sender.currentobjects[0]>=1 then begin
        items[sender.currentobjects[0]-1].width:= items[sender.currentobjects[0]-1].width+(sender.pickoffset.x/fpixelperunit);
       end;
      end;
     end;
  2: begin
      with fpagefooter[fpickarrayindex].tabulators do begin
       items[sender.currentobjects[0]].position:= items[sender.currentobjects[0]].position+(sender.pickoffset.x/fpixelperunit);
       if sender.currentobjects[0]>=1 then begin
        items[sender.currentobjects[0]-1].width:= items[sender.currentobjects[0]-1].width+(sender.pickoffset.x/fpixelperunit);
       end;
      end;
     end;
  3: begin
      with freportfooter[fpickarrayindex].tabulators do begin
       items[sender.currentobjects[0]].position:= items[sender.currentobjects[0]].position+(sender.pickoffset.x/fpixelperunit);
       if sender.currentobjects[0]>=1 then begin
        items[sender.currentobjects[0]-1].width:= items[sender.currentobjects[0]-1].width+(sender.pickoffset.x/fpixelperunit);
       end;
      end;
     end;
 end;
 contentendpickmove(sender.pickpos,sender.shiftstate,sender.pickoffset,sender.currentobjects);
 fpickkind:= -1;
 fpickarrayindex:= -1;
 designchanged;
end;

procedure TraReportTemplate.paintxorpic(const sender: tobjectpicker; const canvas: tcanvas);
begin
end;

procedure TraReportTemplate.pickthumbtrack(const sender: tobjectpicker);
begin
end;

procedure TraReportTemplate.cancelpickmove(const sender: tobjectpicker);
begin
end;

procedure TraReportTemplate.childmouseevent(const sender: twidget; var info: mouseeventinfoty);
begin
 if fobjectpicker <> nil then begin
  fobjectpicker.mouseevent(info);
 end;
 inherited;
end;

procedure TraReportTemplate.clientmouseevent(var info: mouseeventinfoty);
begin
 if fobjectpicker <> nil then begin
  fobjectpicker.mouseevent(info);
 end;
 inherited;
end;
{ TraPage }

constructor TraPage.create(aowner: tcomponent);
begin
 factivetemplate:= -1;
 fprintorder:=0;
 fcansetpapersize:= true;
 fprintpage:= true;
 inherited;
 //freport:= TRepaz(aowner);
 //freport:= TRepaz.create(self);
 fwidgetstate1:= fwidgetstate1 + [ws1_nodesignhandles,ws1_nodesigndelete];
 optionswidget:= defaultoptionswidget;
 fpagewidth:= defaultreppagewidth;
 fpageheight:= defaultreppageheight; 
 funits:= Milimeter;
 fpixelperunit:= defaultreppixelpermm;
 width:= round(defaultreppagewidth*defaultreppixelpermm);
 height:= round(defaultreppageheight*defaultreppixelpermm);
 fpageorientation:= rpo_Portrait;
 color:= cl_white;
end;

destructor TraPage.destroy;
begin 
 inherited;
end;

procedure TraPage.newpage(const apage: TraPage);
begin
 inc(fpagenum);
 inc(freport.fpagenum);
 if fpagenum=1 then freport.dofirstpage(apage);
 freport.setnewmetareportpage(apage);
end;

function TraPage.reportheadervalue(indexrow: integer; indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  result:= ftemplate[factivetemplate].reportheadervalue(indexrow,indexcol);
 end;
end;

function TraPage.reportfootervalue(indexrow: integer; indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  result:= ftemplate[factivetemplate].reportfootervalue(indexrow,indexcol);
 end;
end;

function TraPage.pageheadervalue(indexrow: integer; indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  result:= ftemplate[factivetemplate].pageheadervalue(indexrow,indexcol);
 end;
end;

function TraPage.pagefootervalue(indexrow: integer; indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  result:= ftemplate[factivetemplate].pagefootervalue(indexrow,indexcol);
 end;
end;

function TraPage.contentheadervalue(indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraSimpleReport then begin
   result:= TraSimpleReport(ftemplate[factivetemplate]).contentheadervalue(indexcol);
  end; 
 end;
end;

function TraPage.contentfootervalue(indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraSimpleReport then begin
   result:= TraSimpleReport(ftemplate[factivetemplate]).contentfootervalue(indexcol);
  end; 
 end;
end;

function TraPage.tableheadervalue(tableindex:integer;indexrow:integer;indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraMultiTableReport then begin
   result:= TraMultiTableReport(ftemplate[factivetemplate]).tableheadervalue(tableindex,indexrow,indexcol);
  end; 
 end;
end;

function TraPage.tablefootervalue(tableindex:integer;indexrow:integer;indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraMultiTableReport then begin
   result:= TraMultiTableReport(ftemplate[factivetemplate]).tablefootervalue(tableindex,indexrow,indexcol);
  end; 
 end;
end;

function TraPage.contentdatavalue(indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraSimpleReport then begin
   result:= TraSimpleReport(ftemplate[factivetemplate]).contentdatavalue(indexcol);
  end; 
 end;
end;

function TraPage.groupheadervalue(indexrow:integer; indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraGroupReport then begin
   result:= TraGroupReport(ftemplate[factivetemplate]).groupheadervalue(indexrow,indexcol);
  end; 
 end;
end;

function TraPage.groupfootervalue(indexrow:integer; indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraGroupReport then begin
   result:= TraGroupReport(ftemplate[factivetemplate]).groupfootervalue(indexrow,indexcol);
  end; 
 end;
end;

function TraPage.groupdatavalue(indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraGroupReport then begin
   result:= TraGroupReport(ftemplate[factivetemplate]).groupdatavalue(indexcol);
  end; 
 end;
end;

function TraPage.recordnumber: integer;
begin
 if factivetemplate>=0 then begin
  result:= ftemplate[factivetemplate].recordnumber;
 end;
end;

function TraPage.masternumber: integer;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraMasterDetailReport then begin
   result:= ftemplate[factivetemplate].masternumber;
  end;
 end;
end;

function TraPage.datanumber: integer;
begin
 if factivetemplate>=0 then begin
  result:= ftemplate[factivetemplate].datanumber;
 end;
end;

function TraPage.footertreekey: variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraTreeReport then begin
   result:= TraTreeReport(ftemplate[factivetemplate]).footertreekey;
  end; 
 end;
end;

function TraPage.headertreekey: variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraTreeReport then begin
   result:= TraTreeReport(ftemplate[factivetemplate]).headertreekey;
  end; 
 end;
end;

function TraPage.treefootervalue(indexrow: integer; indexcol:integer; indextree: integer=0): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraTreeReport then begin
   result:= TraTreeReport(ftemplate[factivetemplate]).treefootervalue(indexrow,indexcol,indextree);
  end; 
 end;
end;

function TraPage.treefootervalue2(indexcol:integer; indextree: integer=0): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraTreeReport then begin
   result:= TraTreeReport(ftemplate[factivetemplate]).treefootervalue2(indexcol,indextree);
  end; 
 end;
end;

function TraPage.lettervalue(indexrow: integer; indexcol:integer): variant;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraLetterReport then begin
   result:= TraLetterReport(ftemplate[factivetemplate]).lettervalue(indexrow,indexcol);
  end; 
 end;
end;

function TraPage.groupnumber(aindex: integer): integer;
begin
 if factivetemplate>=0 then begin
  if ftemplate[factivetemplate] is TraGroupReport then begin
   result:= TraGroupReport(ftemplate[factivetemplate]).groupnumber(aindex);
  end; 
 end;
end;

procedure TraPage.newpage;
begin
 newpage(self);
end;

procedure TraPage.registerchildwidget(const child: twidget);
begin
 inherited;
 if child is TraReportTemplate then begin
  TraReportTemplate(child).reportpage:= self;
  additem(pointerarty(ftemplate),child);
 end;
end;

procedure TraPage.unregisterchildwidget(const child: twidget);
begin
 removeitem(pointerarty(ftemplate),child);
 inherited;
end;

procedure TraPage.build;
var
 int1: integer; 
begin
 updatepagesize(fpixelperunit);
 for int1:= 0 to high(ftemplate) do begin
  factivetemplate:= int1;
  ftemplate[int1].build(self.getcanvas);
 end;
end;

procedure TraPage.updatelinks;
var
 int1: integer; 
begin
 for int1:= 0 to high(ftemplate) do begin
  ftemplate[int1].updatelinks;
 end;
end;

procedure TraPage.adddatasets(var adatasets: datasetarty);
var
 int1: integer;
begin
 for int1:= 0 to high(ftemplate) do begin
  ftemplate[int1].adddatasets(adatasets);
 end;
end;

procedure TraPage.setpageorientation(const avalue: rapageorientationty);
begin
 fpageorientation:= avalue;
 if not (csReading in componentstate) then begin
  updatepagesize(fpixelperunit);
 end;
end;

procedure TraPage.updatepapersize;
var
 int1: pagesizety;
 width1,height1: real;
begin
 fpapersize:= Custom;
 if funits=Inch then begin
  width1:= fpagewidth*25.4;
  height1:= fpageheight*25.4;
 end else begin
  width1:= fpagewidth;
  height1:= fpageheight;
 end;
 for int1:=Letter to Custom do begin
  if (abs(width1-pagesizes[int1].width)<=1) and 
   (abs(height1-pagesizes[int1].height)<=1) then begin
   fpapersize:= int1;
   break;
  end;
 end;
end;

procedure TraPage.setpagewidth(const avalue: real);
begin
 fpagewidth:= avalue;
 if not (csReading in componentstate) then begin
  if fcansetpapersize then begin
   updatepapersize;
  end;
  updatepagesize(fpixelperunit);
 end;
end;

procedure TraPage.setpageheight(const avalue: real);
begin
 fpageheight:= avalue;
 if not (csReading in componentstate) then begin
  if fcansetpapersize then begin
   updatepapersize;
  end;
  updatepagesize(fpixelperunit);
 end;
end;

procedure TraPage.setpapersize(const avalue: pagesizety);
begin
 fpapersize:= avalue;
 if (fpapersize<>Custom) and not (csloading in componentstate) then begin
  fcansetpapersize:= false;
  if funits=Milimeter then begin
   setpagewidth(pagesizes[fpapersize].width);
   setpageheight(pagesizes[fpapersize].height);
  end else begin
   setpagewidth(pagesizes[fpapersize].width/25.4);
   setpageheight(pagesizes[fpapersize].height/25.4);
  end;
  fcansetpapersize:= true;
 end;
end;

procedure TraPage.updatepagesize(const avalue: real);
begin
 fpagewidth:= fpagewidth/(avalue/fpixelperunit);
 fpageheight:= fpageheight/(avalue/fpixelperunit);
 if fpageorientation=rpo_Portrait then begin
  self.width:= round(fpagewidth*avalue);
  self.height:= round(fpageheight*avalue);
 end else begin
  self.width:= round(fpageheight*avalue);
  self.height:= round(fpagewidth*avalue);
 end;
end;

procedure TraPage.setunits(const avalue: raunitty);
var
 int1: integer;
begin
 if funits<>avalue then begin
  funits:= avalue;
  if not (csloading in componentstate) then begin
   if avalue=Milimeter then
    setpixelperunit(defaultreppixelpermm)
   else if avalue=Inch then
    setpixelperunit(defaultreppixelperinch);
   for int1:=0 to parentwidget.widgetcount-1 do begin
    if parentwidget.widgets[int1] is TraPage then begin
     if TraPage(parentwidget.widgets[int1]).reportunit<>avalue then begin
      TraPage(parentwidget.widgets[int1]).reportunit:= avalue;
     end;
    end;
   end;
  end;
  if freport<>nil then begin
   freport.reportunit:= avalue;
  end;
 end;
end;

procedure TraPage.setreport(const avalue: TRepaz);
begin
 if avalue<>freport then begin
  freport:= avalue;
  //setlinkedvar(avalue,tmsecomponent(freport));
 end;
end;

procedure TraPage.setpixelperunit(const avalue: real);
var
 int1: integer;
begin
 if avalue <> fpixelperunit then begin
  if not (csloading in componentstate) then begin
   updatepagesize(avalue);
  end;
  fpixelperunit:= avalue;
  for int1:= 0 to high(ftemplate) do begin
   ftemplate[int1].setpixelperunit(fpixelperunit);
  end;
  if freport<>nil then begin
   freport.pixelperunit:= avalue;
  end;
 end;
end;

procedure TraPage.setprintorder(const avalue: integer);
var
 widget1: twidget;
 int1: integer;
 tmppage: TraPage;
begin
 if avalue<>fprintorder then begin
  if not (csloading in componentstate) then begin
   widget1:= self.parentwidget;
   if widget1<>nil then begin
    for int1:=0 to widget1.widgetcount-1 do begin
     tmppage:= TraPage(widget1.widgets[int1]);
     if (tmppage<>self) and (tmppage.printorder=avalue) then begin
      tmppage.fprintorder:= fprintorder;
      break;
     end;
    end;
   end;
  end;
  fprintorder:= avalue;
 end;
end;

procedure TraPage.setprintpage(const avalue: boolean);
begin
 if avalue<>fprintpage then begin
  fprintpage:= avalue;
 end;
end;

procedure TraPage.insertwidget(const awidget: twidget;
               const apos: pointty);
begin
 inherited;
end;

procedure TraPage.sizechanged;
begin
 if parentwidget<>nil then begin
  parentwidget.size:= size;
 end;
 inherited;
end;

procedure TraPage.loaded;
begin
 inherited;
 updatepagesize(fpixelperunit);
 updatepapersize;
end;

function TraPage.getreppage: TraPage;
begin
 result:= self;
end;

 {TRepaz}
 
constructor TRepaz.create(aowner: tcomponent);
begin
 inherited;
 fpreviewdestroyed:= false;
 fdesigndestroyed:= false;
 fprinting:= false;
 fprinted:= false;
 factivepage:= -1;
 fversion:= frepazversion;
 funits:= Milimeter;
 fpixelperunit:= defaultreppixelpermm;
 freportactions:= defaultreportactions;
 foptions:= defaultreportoptions;
 freportowner:= aowner;
 fdialogtext:= 'Processing report...';
 fdialogcaption:= 'Repaz Dialog';
 fdesigncaption:= 'Repaz Designer';
 fpreviewcaption:= 'Repaz Preview';
 fprintdestination:= pd_Preview;
 freppages:=nil;
 isreportfinished:= false;
 fuprinter:= tuniversalprinter.create(self);
 frepazevaluator:= trepazevaluator.createfromreport(self);
 fpages:= nil;
 dia:= TRepazDialog.create(self,ireport(self));
 fdesigndialog:= trepazdesigner.create(nil,ireport(self));
 fpreviewdialog:= TPreviewForm.create(nil,ireport(self));
 if canevent(tmethod(foncreate)) then begin
  foncreate(self);
 end;
end;

destructor TRepaz.destroy;
var
 bo1: boolean;
begin
 if not fpreviewdestroyed then begin
  fpreviewdialog.free;
  fpreviewdialog:= nil;
 end;
 dia.free;
 if not fdesigndestroyed then begin
  fdesigndialog.free;
  fdesigndialog:= nil;
 end;
 clearmetapages(fmetapages);
 bo1:= csdesigning in componentstate;
 if not bo1 then begin
  freeandnil(frootcomp);
 end;
 fpages:= nil;
 if not bo1 and candestroyevent(tmethod(fondestroyed)) then begin
  fondestroyed(self);
 end;
 inherited;
end;

procedure TRepaz.freepages;
var
 int1: integer;
begin
 for int1:=0 to high(freppages) do begin
  freppages[int1].free;
 end;
 freppages:= nil;
 frootcomp.free;
 frootcomp:= nil;
end;

procedure TRepaz.newvariable(variablename:string;value:variant);
begin
 frepazevaluator.newvariable(variablename,value);
end;

function TRepaz.reportheadervalue(indexrow: integer;indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].reportheadervalue(indexrow,indexcol);
 end;
end;

function TRepaz.reportfootervalue(indexrow: integer;indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].reportfootervalue(indexrow,indexcol);
 end;
end;

function TRepaz.pageheadervalue(indexrow: integer;indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].pageheadervalue(indexrow,indexcol);
 end;
end;

function TRepaz.pagefootervalue(indexrow: integer;indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].pagefootervalue(indexrow,indexcol);
 end;
end;

function TRepaz.contentheadervalue(indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].contentheadervalue(indexcol);
 end;
end;

function TRepaz.contentfootervalue(indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].contentfootervalue(indexcol);
 end;
end;

function TRepaz.tableheadervalue(tableindex:integer; indexrow:integer; indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].tableheadervalue(tableindex,indexrow,indexcol);
 end;
end;

function TRepaz.tablefootervalue(tableindex:integer; indexrow:integer; indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].tablefootervalue(tableindex,indexrow,indexcol);
 end;
end;

function TRepaz.contentdatavalue(indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].contentdatavalue(indexcol);
 end;
end;

function TRepaz.groupheadervalue(indexrow:integer; indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].groupheadervalue(indexrow,indexcol);
 end;
end;

function TRepaz.groupfootervalue(indexrow:integer; indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].groupfootervalue(indexrow,indexcol);
 end;
end;

function TRepaz.groupdatavalue(indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].groupdatavalue(indexcol);
 end;
end;

function TRepaz.recordnumber: integer;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].recordnumber;
 end else begin
  result:= -1;
 end;
end;

function TRepaz.masternumber: integer;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].masternumber;
 end else begin
  result:= -1;
 end;
end;

function TRepaz.datanumber: integer;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].datanumber;
 end else begin
  result:= -1;
 end;
end;

function TRepaz.footertreekey: variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].footertreekey;
 end else begin
  result:= '';
 end;
end;

function TRepaz.treefootervalue(indexrow: integer; indexcol:integer; indextree: integer=0): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].treefootervalue(indexrow,indexcol,indextree);
 end else begin
  result:= '';
 end;
end;

function TRepaz.treefootervalue2(indexcol:integer; indextree: integer=0): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].treefootervalue2(indexcol,indextree);
 end else begin
  result:= '';
 end;
end;

function TRepaz.lettervalue(indexrow: integer; indexcol:integer): variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].lettervalue(indexrow,indexcol);
 end else begin
  result:= '';
 end;
end;

function TRepaz.headertreekey: variant;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].headertreekey;
 end else begin
  result:= '';
 end;
end;

function TRepaz.groupnumber(aindex: integer): integer;
begin
 if factivepage>=0 then begin
  result:= freppages[factivepage].groupnumber(aindex);
 end else begin
  result:= -1;
 end;
end;

procedure TRepaz.assign(sender: tpersistent);
begin
 //if sender is TRepaz then begin
  self.foptions:= TRepaz(sender).foptions;
  self.freportactions:= TRepaz(sender).freportactions;
  self.reportunit:= TRepaz(sender).funits;
  self.pixelperunit:= TRepaz(sender).pixelperunit;
  self.freppages:= nil;
  self.freppages:= TRepaz(sender).freppages;
  self.reportowner:= TRepaz(sender).reportowner;
  self.datasources:= TRepaz(sender).datasources;
  self.lookupbuffers:= TRepaz(sender).lookupbuffers;
 {end else begin
  inherited;
 end;}
end;

function TRepaz.getevaluator: trepazevaluator;
begin
 result:= frepazevaluator;
end;

function TRepaz.reportdesign: boolean;
begin
 if ra_design in freportactions then begin
  try
   fdesigndialog.visible:= true;
   fdesigndialog.freportunit:= self.reportunit;
   fdesigndialog.caption:= fdesigncaption;
   if fdesignpanel<>nil then begin
    fdesigndialog.anchors:= [];
    fdesigndialog.parentwidget:= fdesignpanel;
   end;
   fdesigndialog.showdesigner; 
   isreportfinished:= false;
   result:= true;
  finally
  end; 
 end else begin
  showmessage(uc(ord(rcsMsgdesignnotactive)));
  result:= false;
 end;
end;

function TRepaz.reportpreview: boolean;
begin
 if ra_preview in freportactions then begin
  fprintdestination:= pd_Preview;
  if not isreportfinished then begin
   result:= reportexec;
  end;
  if isreportfinished then begin
   try
    fpreviewdialog.caption:= fpreviewcaption;
    fpreviewdialog.tpreview1.metapages:= fmetapages;
    fpreviewdialog.callpage.value:= length(fmetapages);
    if fmetapages<>nil then begin
     fpreviewdialog.tpreview1.width:= fmetapages[0].pagewidth;
     fpreviewdialog.tpreview1.height:= fmetapages[0].pageheight;
    end;
    fpreviewdialog.tpreview1.visible:=true;
    if fpreviewpanel=nil then begin
     fpreviewdialog.show(true);
    end else begin
     fpreviewdialog.anchors:= [];
     fpreviewdialog.parentwidget:= fpreviewpanel;
     fpreviewdialog.visible:= true;
     fpreviewdialog.activate;
    end;
    result:= true;
   finally
    isreportfinished:= true;
   end; 
  end;
 end else begin
  result:= false;
  showmessage(uc(ord(rcsMsgpreviewnotactive)));
 end;
end;

function TRepaz.reportprint(const withdialog: boolean): boolean;
var
 int1,int2: integer;
 bo1: boolean;
begin
 {$IFDEF DEMO_VERSION}
  result:= false;
  showmessage(uc(ord(rcsMsgprintnotactive)));
 {$ELSE}
 fwithdialog:= withdialog;
 if ra_print in freportactions then begin
  fprintdestination:= pd_Printer;
  if not isreportfinished then begin
   result:= reportexec;
  end;
  if isreportfinished then begin
   if length(fmetapages)>=1 then begin
    {$IFDEF WINDOWS}
    fuprinter.outputformat:= cai_GDIPrinter;
    {$ENDIF}
    {$IFDEF LINUX}
    fuprinter.outputformat:= cai_CUPS;
    {$ENDIF}
    if not fuprinter.rawmode then begin
     fuprinter.canvas.ppmm:= fpixelperunit;
    end;
    bo1:= true;
    if withdialog then begin
     bo1:=fuprinter.showdialog=mr_ok;
    end;
    if bo1 then begin
     fpages:= stringtopages(fuprinter.pagesstring);
     fuprinter.title:= removefileext(msefileutils.filename(ffilename));
     if not fuprinter.rawmode then begin
      fuprinter.beginrender;
      for int1:=0 to length(fmetapages)-1 do begin
       if ispageprint(fpages,int1) then begin
        for int2:=1 to fuprinter.copies do begin
         fuprinter.newpage;
         printmetapages(fuprinter.canvas,fmetapages,int1);
         fuprinter.endpage;
        end;
       end;
      end;
      fuprinter.endrender;
      fprinted:= true;
      result:= true;
      if canevent(tmethod(fonafterprinting)) then begin
       fonafterprinting(self);
      end;
     end else begin
      result:= reportposprint;
      fprinted:= true;
     end;
    end;
   end;
  end;
 end else begin
  result:= false;
  showmessage(uc(ord(rcsMsgprintnotactive)));
 end;
 {$ENDIF}
end;

function TRepaz.reportposprint: boolean;
 function rawalign(atext:msestring; const arawwidth:integer; const aflags:textflagsty):msestringarty;
 var
  int1,int2,int3: integer;
  text1: msestring;
 begin
  setlength(result,1);
  if tf_wordbreak in aflags then begin
   int3:= 0;
   while atext<>'' do begin
    if int3=high(result)+1 then begin
     setlength(result,int3+1);
    end;
    text1:= trimleft(copy(atext,1,arawwidth));
    if length(text1)<arawwidth then begin
     if tf_xcentered in aflags then begin
      int1:= (arawwidth-length(text1)) div 2;
      result[int3]:= stringfromchar(' ',int1)+text1+stringfromchar(' ',int1);
      int1:= arawwidth-((int1*2)+length(atext));
      if int1>0 then result[0]:= result[0] + stringfromchar(' ',int1);
     end else if tf_right in aflags then begin
      int1:= arawwidth-length(text1);
      result[int3]:= stringfromchar(' ',int1)+text1;
     end else begin
      int1:= arawwidth-length(text1);
      result[int3]:= text1+stringfromchar(' ',int1);
     end;
    end else begin
     result[int3]:= copy(text1,1,arawwidth);
    end;
    int2:= length(text1)+1;
    atext:= trimleft(copy(atext,int2,length(atext)-int2+1));
    inc(int3);
   end;
  end else begin
   if length(atext)<arawwidth then begin
    if tf_xcentered in aflags then begin
     int1:= (arawwidth-length(atext)) div 2;
     result[0]:= stringfromchar(' ',int1)+atext+stringfromchar(' ',int1);
     int1:= arawwidth-((int1*2)+length(atext));
     if int1>0 then result[0]:= result[0] + stringfromchar(' ',int1);
    end else if tf_right in aflags then begin
     int1:= arawwidth-length(atext);
     result[0]:= stringfromchar(' ',int1)+atext;
    end else begin
     int1:= arawwidth-length(atext);
     result[0]:= atext+stringfromchar(' ',int1);
    end;
   end else begin
    result[0]:= copy(atext,1,arawwidth);
   end;
  end;
 end;
 
 procedure printformattedtext(var adesttext:msestring;const atext: msestring;afontstyle:fontstylesty);
 begin
  //open formatting style
  if (fs_bold in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_bold];
  end;
  if (fs_italic in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_italic];
  end;
  if (fs_underline in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_underline];
  end;
  if (fs_strikeout in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_strike];
  end;
  //draw text
  adesttext:= adesttext + atext;
  //close format style
  if (fs_bold in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_not_bold];
  end;
  if (fs_italic in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_not_italic];
  end;
  if (fs_underline in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_not_underline];
  end;
  if (fs_strikeout in afontstyle) then begin
   adesttext:= adesttext + fuprinter.esclist[esc_not_strike];
  end; 
 end;
 
var
 int1,int2,int3,int4,int5,int6: integer;
 textline,splittext: msestringarty;
 columnwidth,columnpos: integer;
 ftext,fborderbottom,fbordertop,emptyspace,oldemptyspace: msestring;
 realborderbottom,realbordertop: boolean;
begin
 {$IFDEF DEMO_VERSION}
  result:= false;
  showmessage(uc(ord(rcsMsgprintnotactive)));
 {$ELSE}
 if length(fmetapages)>=1 then begin
  fuprinter.title:= removefileext(msefileutils.filename(ffilename));
  fuprinter.beginrender;
  for int1:=0 to length(fmetapages)-1 do begin
   if ispageprint(fpages,int1) then begin
    for int6:=1 to fuprinter.copies do begin
     fuprinter.newpage;
     for int2:=0 to length(fmetapages[int1].tabobjects)-1 do begin
      textline:= nil;
      setlength(textline,1);
      textline[0]:= '';
      fborderbottom:= '';
      fbordertop:= '';
      realborderbottom:= false;
      realbordertop:= false;
      emptyspace:= '';
      oldemptyspace:= '';
      for int3:=0 to length(fmetapages[int1].tabobjects[int2].tabs)-1 do begin
       with fmetapages[int1].tabobjects[int2].tabs[int3] do begin
        columnwidth:= rawwidth;
        if rawpos=0 then begin
         columnpos:= rawpos;
        end else begin
         if int3=0 then begin
          columnpos:= rawpos;
         end else begin
          columnpos:= rawpos - fmetapages[int1].tabobjects[int2].tabs[int3-1].rawpos -
            fmetapages[int1].tabobjects[int2].tabs[int3-1].rawwidth;
         end;
        end;
        //set column pos
        if columnpos>0 then begin
         fbordertop:= fbordertop + fuprinter.rawfontdata(rawfont) + stringfromchar(' ',columnpos);
         fborderbottom:= fborderbottom + fuprinter.rawfontdata(rawfont) + stringfromchar(' ',columnpos);
         for int4:=0 to high(textline) do begin
          textline[int4]:= textline[int4] + fuprinter.rawfontdata(rawfont) + stringfromchar(' ',columnpos);
         end;
         emptyspace:= emptyspace + fuprinter.rawfontdata(rawfont) + stringfromchar(' ',columnpos);
        end;
        if borderleft.linewidth>0 then begin
         inc(columnwidth,1);
         fbordertop:= fbordertop + fuprinter.rawfontdata(rawfont) + stringfromchar('-',columnwidth);
        end else begin
         fbordertop:= fbordertop + fuprinter.rawfontdata(rawfont) + stringfromchar('-',columnwidth);
        end;
        if borderright.linewidth>0 then begin
         inc(columnwidth,1);
        end;
        if bordertop.linewidth>0 then begin
         realbordertop:= true;
        end;
        ftext:= text;
        if ftext='' then begin
         for int4:=0 to high(textline) do begin
          textline[int4]:= textline[int4] + fuprinter.rawfontdata(rawfont);
          emptyspace:= emptyspace + fuprinter.rawfontdata(rawfont);
          if borderleft.linewidth>0 then begin
           textline[int4]:= textline[int4] + '|';
           emptyspace:= emptyspace + '|';
          end;
          textline[int4]:= textline[int4] + stringfromchar(' ',rawwidth);
          emptyspace:= emptyspace + stringfromchar(' ',rawwidth);
          if borderright.linewidth>0 then begin
           textline[int4]:= textline[int4] + '|';
           emptyspace:= emptyspace + '|';
          end;
         end;
        end else begin
         splittext:= rawalign(ftext,rawwidth,flags);
         for int5:=0 to high(splittext) do begin
          if int5=high(textline)+1 then begin
           setlength(textline,int5+1);
           textline[int5]:= oldemptyspace;
          end;
          textline[int5]:= textline[int5] + fuprinter.rawfontdata(rawfont);
          emptyspace:= emptyspace + fuprinter.rawfontdata(rawfont);
          if borderleft.linewidth>0 then begin
           textline[int5]:= textline[int5] + '|';
           emptyspace:= emptyspace + '|';
          end;
          //print text
          printformattedtext(textline[int5],splittext[int5],fontstyle);
          emptyspace:= emptyspace + stringfromchar(' ',length(splittext[int5])+1);
          if borderright.linewidth>0 then begin
           textline[int5]:= textline[int5] + '|';
           emptyspace:= emptyspace + '|';
          end;        
         end;
         if high(splittext)<high(textline) then begin
          for int5:=high(splittext)+1 to high(textline) do begin
           if borderleft.linewidth>0 then begin
            textline[int5]:= textline[int5] + '|';
           end;
           printformattedtext(textline[int5],stringfromchar(' ',rawwidth),fontstyle);
           if borderright.linewidth>0 then begin
            textline[int5]:= textline[int5] + '|';
           end;
          end;
         end;
        end;
        if borderbottom.linewidth>0 then begin
         realborderbottom:= true;
         fborderbottom:= fborderbottom + fuprinter.rawfontdata(rawfont) + stringfromchar('-',columnwidth);
        end else begin
         fborderbottom:= fborderbottom + fuprinter.rawfontdata(rawfont) + stringfromchar(' ',columnwidth);
        end;      
       end;
       oldemptyspace:= emptyspace;
       emptyspace:= '';
      end;
      if realbordertop then begin
       fuprinter.writeln(fbordertop);
      end;
      if high(textline)>=0 then begin
       fuprinter.writelines(textline);
      end;
      if realborderbottom then begin
       fuprinter.writeln(fborderbottom);
      end;
      int3:= fmetapages[int1].tabobjects[int2].rawemptyrow;
      if int3>0 then begin
       for int4:=1 to int3 do begin
        fuprinter.writeln('');
       end;
      end;
     end;
     fuprinter.endpage;
    end;
   end;
  end;
  fprinted:= true;
  result:= true;
  fuprinter.endrender;
  if canevent(tmethod(fonafterprinting)) then begin
   fonafterprinting(self);
  end;
 end;
 {$ENDIF}
end;

function TRepaz.reportcsv: boolean;
var
 int1,int2,int3: integer;
 textline: msestringarty;
 tfiledialog1: tfiledialog;
 xx: filenamety;
 stream: ttextdatastream;
begin
 {$IFDEF DEMO_VERSION}
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 {$ELSE}
 if ra_save in freportactions then begin
  fprintdestination:= pd_Text;
  if not isreportfinished then begin
   result:= reportexec;
  end;
  if isreportfinished then begin
   tfiledialog1:= tfiledialog.create(nil);
   tfiledialog1.dialogkind:= fdk_save;
   tfiledialog1.controller.defaultext:= 'csv';
   with tfiledialog1.controller do begin
    captionsave:=uc(ord(rcsCapsave2text));
    filterlist.add(uc(ord(rcsLbltext)),'*.csv');
    filterlist.add(uc(ord(rcsLblallfiles)),'*.*');
   end;
   if tfiledialog1.execute=mr_ok then begin
    xx:= tfiledialog1.controller.filename;
    if xx='' then begin
     showmessage(uc(ord(rcsMsgtypepsfn)));
     tfiledialog1.free;
     exit;
    end;
    stream:= ttextdatastream.create(xx,fm_create);
    stream.separator:= c_tab;
    stream.quotechar:= '"';
   end else begin
    tfiledialog1.free;
    exit;
   end;
   tfiledialog1.free;
   if length(fmetapages)>=1 then begin
    for int1:=0 to length(fmetapages)-1 do begin
     for int2:=0 to length(fmetapages[int1].tabobjects)-1 do begin
      textline:= nil;
      setlength(textline,length(fmetapages[int1].tabobjects[int2].tabs));
      for int3:=0 to length(fmetapages[int1].tabobjects[int2].tabs)-1 do begin
       textline[int3]:= fmetapages[int1].tabobjects[int2].tabs[int3].text;
      end;
      stream.writerecord(textline);
     end;
    end;
    stream.Free;
    fprinted:= true;
    result:= true;
    if canevent(tmethod(fonafterprinting)) then begin
     fonafterprinting(self);
    end;
   end;
  end;
 end else begin
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 end;
 {$ENDIF}
end;

function TRepaz.reporthtml(const extfile: string): boolean;
var
 int1,int2,int3: integer;
 tfiledialog1: tfiledialog;
 xx: filenamety;
 stream: ttextstream;
 aextfile,str1,str2: string;
 rgb1: rgbtriplety;
begin
 {$IFDEF DEMO_VERSION}
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 {$ELSE}
 if ra_save in freportactions then begin
  aextfile:= lowercase(extfile);
  if aextfile='html' then
   fprintdestination:= pd_HTML
  else if aextfile='xls' then
   fprintdestination:= pd_Excel
  else if aextfile='ods' then
   fprintdestination:= pd_OpenOffice;
  if not isreportfinished then begin
   result:= reportexec;
  end;
  if isreportfinished then begin
   tfiledialog1:= tfiledialog.create(nil);
   tfiledialog1.dialogkind:= fdk_save;
   tfiledialog1.controller.defaultext:= extfile;
   with tfiledialog1.controller do begin
    if aextfile='html' then begin
     captionsave:=uc(ord(rcsCapsave2html));
     filterlist.add(uc(ord(rcsLblhtml)),'*.html');
    end else if aextfile='xls' then begin
     captionsave:=uc(ord(rcsCapsave2excel));
     filterlist.add(uc(ord(rcsLblexcel)),'*.xls');
    end else if aextfile='ods' then begin
     captionsave:=uc(ord(rcsCapsave2openoffice));
     filterlist.add(uc(ord(rcsLblopenoffice)),'*.ods');
    end;
    filterlist.add(uc(ord(rcsLblallfiles)),'*.*');
   end;
   if tfiledialog1.execute=mr_ok then begin
    xx:= tfiledialog1.controller.filename;
    if xx='' then begin
     showmessage(uc(ord(rcsMsgtypepsfn)));
     tfiledialog1.free;
     exit;
    end;
    stream:= ttextstream.create(xx,fm_create);
   end else begin
    tfiledialog1.free;
    exit;
   end;
   tfiledialog1.free;
   stream.writeln('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
   stream.writeln('<html>');
   stream.writeln('<head>');
   stream.writeln('	<title>'+fdialogcaption+'</title>');
   stream.writeln(' <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />');
   stream.writeln('	<meta name=description" content=""Repaz export" />');
   stream.writeln('	<meta name="author" content="Sri Wahono">');
   stream.writeln('</head>');
   stream.writeln('<body>');
   if length(fmetapages)>=1 then begin
    for int1:=0 to length(fmetapages)-1 do begin
     for int2:=0 to length(fmetapages[int1].tabobjects)-1 do begin
      stream.writeln('<TABLE CELLPADDING=1 CELLSPACING=0>');
      stream.writeln('<TR>');      
      for int3:=0 to length(fmetapages[int1].tabobjects[int2].tabs)-1 do begin
       with fmetapages[int1].tabobjects[int2].tabs[int3] do begin
        stream.write('<TD WIDTH='+inttostr(dest.cx));
        if tf_ycentered in flags then
         str1:= 'CENTER'
        else if tf_bottom in flags then
         str1:= 'BOTTOM'
        else
         str1:= 'TOP';
        stream.write(' VALIGN='+str1);
        str1:= '';
        with borderleft do begin
         if linewidth>0 then begin
          str1:= str1+'border-left-width: 1px;';
         end else begin
          str1:= str1+'border-left-width: 0px;';
         end;
         case linestyle of
          ls_Solid: str1:= str1+'border-left-style:solid;';
          ls_Dash: str1:= str1+'border-left-style:dashed;';
          ls_Dot: str1:= str1+'border-left-style:dotted;';
          ls_Dash_Dot,ls_Dash_Dot_Dot: str1:= str1+'border-left-style:groove;';
         end;
         rgb1:= colortorgb(linecolor);         
         str1:= str1+'border-left-color:rgb('+inttostr(rgb1.red)+','+inttostr(rgb1.green)+','+inttostr(rgb1.blue)+');';
        end;
        with bordertop do begin
         if linewidth>0 then begin
          str1:= str1+'border-top-width: 1px;';
         end else begin
          str1:= str1+'border-top-width: 0px;';
         end;
         case linestyle of
          ls_Solid: str1:= str1+'border-top-style:solid;';
          ls_Dash: str1:= str1+'border-top-style:dashed;';
          ls_Dot: str1:= str1+'border-top-style:dotted;';
          ls_Dash_Dot,ls_Dash_Dot_Dot: str1:= str1+'border-top-style:groove;';
         end;
         rgb1:= colortorgb(linecolor);         
         str1:= str1+'border-top-color:rgb('+inttostr(rgb1.red)+','+inttostr(rgb1.green)+','+inttostr(rgb1.blue)+');';
        end;
        with borderright do begin
         if linewidth>0 then begin
          str1:= str1+'border-right-width: 1px;';
         end else begin
          str1:= str1+'border-right-width: 0px;';
         end;
         case linestyle of
          ls_Solid: str1:= str1+'border-right-style:solid;';
          ls_Dash: str1:= str1+'border-right-style:dashed;';
          ls_Dot: str1:= str1+'border-right-style:dotted;';
          ls_Dash_Dot,ls_Dash_Dot_Dot: str1:= str1+'border-right-style:groove;';
         end;
         rgb1:= colortorgb(linecolor);         
         str1:= str1+'border-right-color:rgb('+inttostr(rgb1.red)+','+inttostr(rgb1.green)+','+inttostr(rgb1.blue)+');';
        end;
        with borderbottom do begin
         if linewidth>0 then begin
          str1:= str1+'border-bottom-width: 1px;';
         end else begin
          str1:= str1+'border-bottom-width: 0px;';
         end;
         case linestyle of
          ls_Solid: str1:= str1+'border-bottom-style:solid;';
          ls_Dash: str1:= str1+'border-bottom-style:dashed;';
          ls_Dot: str1:= str1+'border-bottom-style:dotted;';
          ls_Dash_Dot,ls_Dash_Dot_Dot: str1:= str1+'border-bottom-style:groove;';
         end;
         rgb1:= colortorgb(linecolor);         
         str1:= str1+'border-bottom-color:rgb('+inttostr(rgb1.red)+','+inttostr(rgb1.green)+','+inttostr(rgb1.blue)+');';
        end;
        if str1<>'' then begin
         stream.write(' STYLE="'+str1+'"');
        end;
        if tf_xcentered in flags then
         str1:= 'CENTER'
        else if tf_right in flags then
         str1:= 'RIGHT'
        else
         str1:= 'LEFT';        
        stream.write('<P ALIGN='+str1+'>');
        rgb1:= colortorgb(fontcolor);         
        str1:= '<font style="font-size:'+inttostr(fontsize)+'pt; font-family:'+fontname+'" color=rgb('+inttostr(rgb1.red)+','+inttostr(rgb1.green)+','+inttostr(rgb1.blue)+')>';
        str2:= '</font>';
        if fs_bold in fontstyle then begin
         str1:= str1+'<B>';
         str2:= str2+'</B>';
        end;
        if fs_italic in fontstyle then begin
         str1:= str1+'<I>';
         str2:= str1+'</I>';
        end;
        if fs_underline in fontstyle then begin
         str1:= str1+'<U>';
         str2:= str1+'</U>';
        end;
        stream.write(str1);
        stream.write(text);
        stream.write(str2);
        stream.write('</P>');
        stream.write('</TD>');
       end;
      end;
      stream.writeln('</TR>');
      stream.writeln('</TABLE>');
     end;
    end;
    fprinted:= true;
    result:= true;
    if canevent(tmethod(fonafterprinting)) then begin
     fonafterprinting(self);
    end;
   end;
   stream.writeln('</body>');
   stream.writeln('</html>');
   stream.Free;
  end;
 end else begin
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 end;
 {$ENDIF}
end;

function TRepaz.reportpdf: boolean;
var
 int1: integer;
 tfiledialog1: tfiledialog;
 xx: filenamety;
begin
 {$IFDEF DEMO_VERSION}
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 {$ELSE}
 if ra_save in freportactions then begin
  fprintdestination:= pd_PDF;
  if not isreportfinished then begin
   result:= reportexec;
  end;
  if isreportfinished then begin
   tfiledialog1:= tfiledialog.create(nil);
   tfiledialog1.dialogkind:= fdk_save;
   tfiledialog1.controller.defaultext:= 'pdf';
   with tfiledialog1.controller do begin
    captionsave:=uc(ord(rcsCapsave2pdf));
    filterlist.add(uc(ord(rcsLblpdf)),'*.pdf');
    filterlist.add(uc(ord(rcsLblallfiles)),'*.*');
   end;
   if tfiledialog1.execute=mr_ok then begin
    xx:= tfiledialog1.controller.filename;
    if xx='' then begin
     showmessage(uc(ord(rcsMsgtypepsfn)));
     tfiledialog1.free;
     exit;
    end;
    fuprinter.outputfilename:= xx;
   end else begin
    tfiledialog1.free;
    exit;
   end;
   tfiledialog1.free;
   fuprinter.canvas.ppmm:= fpixelperunit;
   fuprinter.page_paperheight:= freppages[0].pageheight;
   fuprinter.page_paperwidth:= freppages[0].pagewidth;
   fuprinter.page_orientation:= pageorientationty(ord(freppages[0].PageOrientation));
   fuprinter.outputformat:= cai_PDF;
   if length(fmetapages)>=1 then begin
    fuprinter.beginrender;
    for int1:=0 to length(fmetapages)-1 do begin
     fuprinter.newpage;
     printmetapages(fuprinter.canvas,fmetapages,int1);
     fuprinter.endpage;
    end;
    result:= true;
    fuprinter.endrender;
   end;
  end;
 end else begin
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 end;
 {$ENDIF}
end;

function TRepaz.reportpng: boolean;
var
 int1: integer;
 tfiledialog1: tfiledialog;
 xx: filenamety;
begin
 {$IFDEF DEMO_VERSION}
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 {$ELSE}
 if ra_save in freportactions then begin
  fprintdestination:= pd_PNG;
  if not isreportfinished then begin
   result:= reportexec;
  end;
  if isreportfinished then begin
   tfiledialog1:= tfiledialog.create(nil);
   tfiledialog1.dialogkind:= fdk_save;
   tfiledialog1.controller.defaultext:= 'png';
   with tfiledialog1.controller do begin
    captionsave:=uc(ord(rcsCapsave2png));
    filterlist.add(uc(ord(rcsLblpng)),'*.png');
    filterlist.add(uc(ord(rcsLblallfiles)),'*.*');
   end;
   if tfiledialog1.execute=mr_ok then begin
    xx:= tfiledialog1.controller.filename;
    if xx='' then begin
     showmessage(uc(ord(rcsMsgtypepsfn)));
     tfiledialog1.free;
     exit;
    end;
    fuprinter.outputfilename:= xx;
   end else begin
    tfiledialog1.free;
    exit;
   end;
   tfiledialog1.free;
   fuprinter.canvas.ppmm:= fpixelperunit;
   fuprinter.page_paperheight:= freppages[0].pageheight;
   fuprinter.page_paperwidth:= freppages[0].pagewidth;
   fuprinter.page_orientation:= pageorientationty(ord(freppages[0].PageOrientation));
   fuprinter.outputformat:= cai_PNG;
   if length(fmetapages)>=1 then begin
    fuprinter.beginrender;
    for int1:=0 to length(fmetapages)-1 do begin
     fuprinter.newpage;
     printmetapages(fuprinter.canvas,fmetapages,int1);
     fuprinter.endpage;
    end;
    result:= true;
    fuprinter.endrender;
   end;
  end;
 end else begin
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 end;
 {$ENDIF}
end;

function TRepaz.reportpostscript: boolean;
var
 int1: integer;
 tfiledialog1: tfiledialog;
 xx: filenamety;
begin
 {$IFDEF DEMO_VERSION}
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 {$ELSE}
 if ra_save in freportactions then begin
  fprintdestination:= pd_PostScript;
  if not isreportfinished then begin
   result:= reportexec;
  end;
  if isreportfinished then begin
   tfiledialog1:= tfiledialog.create(nil);
   tfiledialog1.dialogkind:= fdk_save;
   tfiledialog1.controller.defaultext:= 'ps';
   with tfiledialog1.controller do begin
    captionsave:=uc(ord(rcsCapsave2ps));
    filterlist.add(uc(ord(rcsLblpostscript)),'*.ps');
    filterlist.add(uc(ord(rcsLblallfiles)),'*.*');
   end;
   if tfiledialog1.execute=mr_ok then begin
    xx:= tfiledialog1.controller.filename;
    if xx='' then begin
     showmessage(uc(ord(rcsMsgtypepsfn)));
     tfiledialog1.free;
     result:= false;
     exit;
    end;
    fuprinter.outputfilename:= xx;
   end else begin
    tfiledialog1.free;
    exit;
   end;
   tfiledialog1.free;
   fuprinter.outputformat:= cai_PostScript;
   fuprinter.canvas.ppmm:= fpixelperunit;
   fuprinter.page_paperheight:= freppages[0].pageheight;
   fuprinter.page_paperwidth:= freppages[0].pagewidth;
   fuprinter.page_orientation:= pageorientationty(ord(freppages[0].PageOrientation));
   fuprinter.page_marginleft:=0;
   fuprinter.page_marginright:=0;
   fuprinter.page_margintop:=0;
   fuprinter.page_marginbottom:=0;
   if length(fmetapages)>=1 then begin
    fuprinter.beginrender;
    for int1:=0 to length(fmetapages)-1 do begin
     fuprinter.newpage;
     printmetapages(fuprinter.canvas,fmetapages,int1);
     fuprinter.endpage;
    end;
    result:= true;
    fuprinter.endrender;
   end;
  end;
 end else begin
  result:= false;
  showmessage(uc(ord(rcsMsgsavefilenotactive)));
 end;
 {$ENDIF}
end;

function TRepaz.reportexecute(const usedialog: boolean): boolean;
begin
 if usedialog then begin
  if ra_showdialog in freportactions then begin
   try
    dia.cactions.dropdown.itemindex:= ord(fprintdestination);
    if isrelativepath(ffilename) then begin
     dia.wfilename.value:= filepath(ffilename);
    end else begin
     dia.wfilename.value:= ffilename;
    end;
    if dia.show(true)=mr_ok then begin
     printdestination:= printdestinationty(dia.cactions.dropdown.itemindex);
     if printdestination=pd_Design then begin
      result:= reportdesign;
     end else begin
      result:= reportexec;
     end;
    end;
   finally
    //dia.free;
    //dia:= nil;
   end; 
  end else begin
   result:= reportexec;
  end;
 end else begin
  result:= reportexec;
 end;
end;

function TRepaz.reportexec: boolean;
var
 bo1: boolean;
 tmpfilename: filenamety;
begin
 if fprintdestination=pd_Preview then begin
  if not (ra_preview in freportactions) then begin
   result:= false;
   showmessage(uc(ord(rcsMsgpreviewnotactive)));
   exit;
  end; 
 end else if fprintdestination=pd_Design then begin
  if not (ra_design in freportactions) then begin
   result:= false;
   showmessage(uc(ord(rcsMsgdesignnotactive)));
   exit;
  end; 
 end else if fprintdestination=pd_Printer then begin
  if not (ra_print in freportactions) then begin
   result:= false;
   showmessage(uc(ord(rcsMsgprintnotactive)));
   exit;
  end; 
 end else if ((fprintdestination=pd_PostScript) 
   or (fprintdestination=pd_PDF)
   or (fprintdestination=pd_HTML)
   or (fprintdestination=pd_Excel)
   or (fprintdestination=pd_OpenOffice)
   or (fprintdestination=pd_PNG))
   then begin
  if not (ra_save in freportactions) then begin
   result:= false;
   showmessage(uc(ord(rcsMsgsavefilenotactive)));
   exit;
  end; 
  end; 
 isreportfinished:= false;
 bo1:= isrelativepath(ffilename);
 if bo1 then begin
  tmpfilename:= filepath(ffilename);
 end else begin 
  tmpfilename:= ffilename;
 end;
 bo1:= false;
 loadfromfile(tmpfilename,bo1);
 if not bo1 then begin
  result:= false;
  showmessage(uc(ord(rcsMsgreportnotopen)));
  exit;
 end;
 createnewmetareport;
 result:= internalbuild;
end;

procedure TRepaz.savemetapages;
begin
 showmessage('Not yet created!');
end;

procedure TRepaz.setprintdestination(const avalue: printdestinationty);
begin
 if avalue<>fprintdestination then begin
  fprintdestination:= avalue;
 end;
end;

procedure TRepaz.setunits(const avalue: raunitty);
begin
 if avalue<>funits then begin
  funits:=avalue;
  if canevent(tmethod(fonchangeunit)) then begin
   try
    fonchangeunit(avalue);
   finally
   end;
  end;
 end;
end;

procedure TRepaz.setfilename(const avalue: filenamety);
begin
 if avalue<>ffilename then begin
  ffilename:=avalue;
  isreportfinished:= false;
 end;
end;

procedure TRepaz.setdatasources(const avalue: trepazdatasources);
begin
 if avalue<>fdatasourcesreport then begin
  setlinkedvar(avalue,tmsecomponent(fdatasourcesreport));
  setlinkedvar(avalue,tmsecomponent(frepazevaluator.fevaldatasource));
 end;
end;

procedure TRepaz.setlookupbuffers(const avalue: trepazlookupbuffers);
begin
 if flookupbufferreport<>avalue then begin
  setlinkedvar(avalue,tmsecomponent(flookupbufferreport));
 end;
end;

procedure TRepaz.setpreviewpanel(const avalue: tdockpanel);
begin
 if avalue<>fpreviewpanel then begin
  setlinkedvar(avalue,fpreviewpanel);
  //fpreviewpanel:= avalue;
 end;
end;

procedure TRepaz.setdesignpanel(const avalue: tdockpanel);
begin
 if avalue<>fdesignpanel then begin
  setlinkedvar(avalue,fdesignpanel);
  //fdesignpanel:= avalue;
 end;
end;

procedure TRepaz.addpage(apage: TraPage);
begin
 apage.report:=self;
 apage.updatelinks;
 apage.visible:=false;
 if apage.printthispage then begin
  additem(pointerarty(freppages),apage);
 end;
end;

procedure TRepaz.repdisablecontrols;
var
 int1: integer;
begin
 for int1:= 0 to high(fdatasets) do begin
  with fdatasets[int1] do begin
   if not (reo_nodisablecontrols in foptions) then begin
    disablecontrols;
   end;
  end;
 end;
end;

procedure TRepaz.repenablecontrols;
var
 int1: integer;
begin
 for int1:= 0 to high(fdatasets) do begin
  with fdatasets[int1] do begin
   if not (reo_nodisablecontrols in foptions) then begin
    enablecontrols;
  end;
 end;
end;
end;

function TRepaz.exec: boolean;
 
 procedure dofinish(const islast: boolean);
 begin
  try
   doonreportfinished;
   try
    if canevent(tmethod(fonreportfinished)) then begin
     fonreportfinished(self);
    end;
    if canevent(tmethod(fonbuildfinish)) then begin
     fonbuildfinish(self);
    end;
   finally
    //
   end; 
   factivepage:= -1;
   repenablecontrols;
   fdatasets:= nil;
  finally
   fprinting:= false;
  end;
 end;

var               
 int1,int2,maxpage: integer;
 isexists: boolean;
begin
 fprinting:= true;
 for int1:= 0 to high(freppages) do begin
  freppages[int1].adddatasets(fdatasets);
 end;
 repdisablecontrols;
 try
  fpagenum:= 0;
  try
   if canevent(tmethod(fonreportstart)) then begin
    try
     fonreportstart(self);
    finally
    end;
   end;
  except
   dofinish(true);
   raise;
  end;
  try
   if canevent(tmethod(fonbeforebuild)) then begin
    try
     fonbeforebuild(self);
    finally
    end;
   end;
   doprogress;
   int2:=0;
   maxpage:=0;
   for int1:= 0 to high(freppages) do begin
    if freppages[int1].printorder>maxpage then begin
     maxpage:= freppages[int1].printorder;
    end;
   end;
   while int2<=maxpage do begin
    isexists:= false;
    for int1:= 0 to high(freppages) do begin
     if freppages[int1].printorder=int2 then begin
      factivepage:= int1;
      freppages[int1].build;
      inc(int2);
      isexists:= true;
      break;
     end;
    end;
    if not isexists then inc(int2);
   end;
   doafterlastpage(freppages[int2-1]);
  finally
   dofinish(true);
  end;
  if canevent(tmethod(fonafterbuild)) then begin
   try
    fonafterbuild(self);
   finally
   end;
  end;
 finally
 end;
end;

procedure TRepaz.findcomponentclass(Reader: TReader; const aClassName: string;
        var ComponentClass: TComponentClass);
var
 lname: string;
begin
 if componentclass = nil then begin
  lname:= lowercase(aClassName);
  if lname='trapage' then componentclass:= TraPage
  else if lname='trasimplereport' then componentclass:= TraSimpleReport
  else showmessage(uc(ord(rcsMsgclassnotfound)) + aClassName + '!');
 end;
end;

procedure TRepaz.createcomponent(Reader: TReader; ComponentClass: TComponentClass;
                   var Component: TComponent);
begin
 //
end;

procedure TRepaz.readstringproperty(Sender:TObject; const Instance: TPersistent;
    PropInfo: PPropInfo; var Content:string);
begin
 //
end;

procedure TRepaz.onreferencename(Reader: TReader; var aName: string);
begin
 //
end;

function TRepaz.internalbuild: boolean;
begin
 fcanceled:= false;
 application.beginwait;
 try
  result:= exec;
 finally
  application.endwait;
  //checkmemoryneeded; //for check how much memory that is used by metapages
 end;
end;

function TRepaz.getreppages(index: integer): TraPage;
begin
 checkarrayindex(freppages,index);
 result:= freppages[index];
end;

procedure TRepaz.setreppages(index: integer;
               const avalue: TraPage);
begin
 checkarrayindex(freppages,index);
 freppages[index].assign(avalue);
end;

function TRepaz.reppagecount: integer;
begin
 result:= length(freppages);
end;

function TRepaz.getdatasources: trepazdatasources;
begin
 result:= fdatasourcesreport;
end;

function TRepaz.getlookupbuffers: trepazlookupbuffers;
begin
 result:= flookupbufferreport;
end;

function TRepaz.getfilename: filenamety;
begin
 result:= ffilename;
end;

procedure TRepaz.loadfromfile(afilename: filenamety; var isloaded: boolean);
var
 binstream: tmemorystream;
 textstream,stream1: ttextstream;
 int1: integer;
 reader: treader;
 comp2: tcomponent; 
 listend: tvaluetype;
begin
 isloaded:=false;
 if afilename='' then begin
  exit;
 end;
 try
  textstream:= ttextstream.Create;
  freepages;
  frootcomp:= tcomponent.create(nil);
  tcomponent1(frootcomp).SetDesigning(true{$ifndef FPC},false{$endif});
  lockfindglobalcomponent;
  try
   listend:= vanull;
   textstream.writeln('object frootcomp: tcomponent');
   stream1:= ttextstream.create(afilename,fm_read);
   textstream.copyfrom(stream1,stream1.size);
   stream1.free;
   textstream.writeln('end');
   textstream.Position:= 0;
   binstream:= tmemorystream.Create;
   try
    while textstream.position < textstream.Size do begin
     binstream.Position:= 0;
     objecttexttobinary(textstream,binstream);
     binstream.Write(listend,sizeof(listend));
     binstream.Position:= 0;
     reader:= treader.create(binstream,4096);
     try
      begingloballoading;
      reader.onfindcomponentclass:= {$ifdef FPC}@{$endif}findcomponentclass;
      {reader.oncreatecomponent:= {$ifdef FPC}@{$endif}createcomponent;
      reader.onreadstringproperty:= {$ifdef FPC}@{$endif}readstringproperty;
      reader.onreferencename:= {$ifdef FPC}@{$endif}onreferencename;}
      reader.readrootcomponent(frootcomp);
      tcomponent1(frootcomp).SetDesigning(false{$ifndef FPC},false{$endif});
      for int1:= frootcomp.componentcount - 1 downto 0 do begin
       comp2:= frootcomp.components[int1]; 
       if comp2.getparentcomponent = nil then begin
        addpage(TraPage(comp2));
        isloaded:=true;
       end;
      end;
      notifygloballoading;
     finally
      endgloballoading;
      reader.Free;
     end;
    end;
   finally
    binstream.Free;
   end;
  finally
   unlockfindglobalcomponent;
   textstream.Free;
  end;
 except
  on e: exception do begin
   e.message:= 'Error : ' +e.message;
   raise;
  end;
 end;
end;

procedure TRepaz.dostatread(const reader: tstatreader);
begin
 with reader do begin
  fuprinter.printtextasgraphic:= readboolean('OSPrinter_PrintTextAsGraphic',fuprinter.printtextasgraphic);
  fuprinter.antialias:= readboolean('OSPrinter_AntiAlias',fuprinter.antialias);
  fuprinter.rawmode:= readboolean('OSPrinter_RawMode',fuprinter.rawmode);
  fuprinter.raw_printercode:= trawprintercommand(readinteger('OSPrinter_PrinterCode',ord(fuprinter.raw_printercode)));
  fuprinter.raw_continuespage:= readboolean('OSPrinter_ContinuesPage',fuprinter.raw_continuespage);
  fuprinter.printername:= readstring('OSPrinter_PrinterName',fuprinter.printername);
  fuprinter.page_paperwidth:= readreal('OSPrinter_PaperWidth',fuprinter.page_paperwidth);
  fuprinter.page_paperheight:= readreal('OSPrinter_PaperHeight',fuprinter.page_paperheight);
  fuprinter.page_orientation:= pageorientationty(readinteger('OSPrinter_Orientation',
             ord(fuprinter.page_orientation),0,ord(high(pageorientationty))));
  fuprinter.page_marginleft:= readreal('OSPrinter_MarginLeft',fuprinter.page_marginleft);
  fuprinter.page_margintop:= readreal('OSPrinter_Margintop',fuprinter.page_margintop);
  fuprinter.page_marginright:= readreal('OSPrinter_MarginRight',fuprinter.page_marginright);
  fuprinter.page_marginbottom:= readreal('OSPrinter_MarginBottom',fuprinter.page_marginbottom);
  fuprinter.raw_cutpaperonfinish:= readboolean('OSPrinter_CutPaperOnFinish',fuprinter.raw_cutpaperonfinish);
  fuprinter.raw_draweraction:= draweractionty(readinteger('OSPrinter_DrawerAction',ord(fuprinter.raw_draweraction)));
  fuprinter.raw_drawermode:= drawermodety(readinteger('OSPrinter_DrawerMode',ord(fuprinter.raw_drawermode)));
  fuprinter.raw_serialport:= commnrty(readinteger('OSPrinter_SerialPort',ord(fuprinter.raw_serialport)));
  fprintdestination:= printdestinationty(readinteger('PrintDestination',ord(fprintdestination)));
  ffilename:= readstring('Report_FileName',ffilename);
  fuprinter.raw_linesperpage:= readinteger('OSPrinter_LinesPerPage',fuprinter.raw_linesperpage);
 end;
end;

procedure TRepaz.dostatwrite(const writer: tstatwriter);
begin
 with writer do begin
  writeboolean('OSPrinter_PrintTextAsGraphic',fuprinter.printtextasgraphic);
  writeboolean('OSPrinter_AntiAlias',fuprinter.antialias);
  writeboolean('OSPrinter_RawMode',fuprinter.rawmode);
  writeinteger('OSPrinter_PrinterCode',ord(fuprinter.raw_printercode));
  writeboolean('OSPrinter_ContinuesPage',fuprinter.raw_continuespage);
  writestring('OSPrinter_PrinterName',fuprinter.printername);
  writereal('OSPrinter_PaperWidth',fuprinter.page_paperwidth);
  writereal('OSPrinter_PaperHeight',fuprinter.page_paperheight);
  writeinteger('OSPrinter_Orientation',ord(fuprinter.page_orientation));
  writereal('OSPrinter_MarginLeft',fuprinter.page_marginleft);
  writereal('OSPrinter_MarginTop',fuprinter.page_margintop);
  writereal('OSPrinter_MarginRight',fuprinter.page_marginright);
  writereal('OSPrinter_MarginBottom',fuprinter.page_marginbottom);
  writeboolean('OSPrinter_CutPaperOnFinish',fuprinter.raw_cutpaperonfinish);
  writeinteger('OSPrinter_DrawerAction',ord(fuprinter.raw_draweraction));
  writeinteger('OSPrinter_DrawerMode',ord(fuprinter.raw_drawermode));
  writeinteger('OSPrinter_SerialPort',ord(fuprinter.raw_serialport));
  writeinteger('PrintDestination',ord(fprintdestination));
  writestring('Report_FileName',ffilename);
  writeinteger('OSPrinter_LinesPerPage',fuprinter.raw_linesperpage);
 end;
end;

procedure TRepaz.statreading;
begin
 //dummy
end;

procedure TRepaz.statread;
begin
 //dummy
end;

function TRepaz.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

function TRepaz.getreport: TRepaz;
begin
 result:= self;
end;

procedure TRepaz.previewdestroyed(const avalue:boolean);
begin
 fpreviewdestroyed:= avalue;
end;

procedure TRepaz.designdestroyed(const avalue:boolean);
begin
 fdesigndestroyed:= avalue;
 //fdesigndialog:= nil;
end;

procedure TRepaz.setnewmetareportpage(const apage: TraPage);
begin
 inc(fmetapagecount);
 setlength(fmetapages,fmetapagecount);
 fmetapages[fmetapagecount-1].pagewidth:= apage.width;
 fmetapages[fmetapagecount-1].pageheight:= apage.height;
 fmetatabobjectcount:=0;
 fmetarect1objectcount:= 0;
 fmetarect2objectcount:= 0;
 fmetabitmap1objectcount:= 0;
 fmetabitmap2objectcount:= 0;
end;

procedure TRepaz.createnewmetareport;
begin
 clearmetapages(fmetapages);
 fmetapagecount:= 0;
 fmetatabobjectcount:= 0;
 fmetarect1objectcount:= 0;
 fmetarect2objectcount:= 0;
 fmetabitmap1objectcount:= 0;
 fmetabitmap2objectcount:= 0;
end;

procedure TRepaz.addtabtoreport(const ainfo: reptabinfoty);
begin
 setlength(fmetapages[fmetapagecount-1].tabobjects,fmetatabobjectcount+1);
 fmetapages[fmetapagecount-1].tabobjects[fmetatabobjectcount]:= ainfo;
 inc(fmetatabobjectcount);
end;

procedure TRepaz.addrect1toreport(const ainfo: reprectinfoty);
begin
 setlength(fmetapages[fmetapagecount-1].rect1objects,fmetarect1objectcount+1);
 fmetapages[fmetapagecount-1].rect1objects[fmetarect1objectcount]:= ainfo;
 inc(fmetarect1objectcount);
end;

procedure TRepaz.addrect2toreport(const ainfo: reprectinfoty);
begin
 setlength(fmetapages[fmetapagecount-1].rect2objects,fmetarect2objectcount+1);
 fmetapages[fmetapagecount-1].rect2objects[fmetarect2objectcount]:= ainfo;
 inc(fmetarect2objectcount);
end;

procedure TRepaz.addbitmaptoreport(const arect: rectty; const avalue: tmaskedbitmap);
begin
 avalue.savetoimagebuffer(fmetapages[fmetapagecount-1].bitmap);
 fmetapages[fmetapagecount-1].bitmapalignment:= avalue.alignment;
 fmetapages[fmetapagecount-1].bitmaprect:= arect;
end;

procedure TRepaz.addcharttoreport(const arect: rectty; const avalue: TraCustomChart);
begin
 fmetapages[fmetapagecount-1].chartobjects:= avalue;
 fmetapages[fmetapagecount-1].chartrect:= arect;
end;

procedure TRepaz.addbitmap1toreport(const arect: rectty; avalue: tmaskedbitmap);
begin
 setlength(fmetapages[fmetapagecount-1].bitmap1objects,fmetabitmap1objectcount+1);
 avalue.savetoimagebuffer(fmetapages[fmetapagecount-1].bitmap1objects[fmetabitmap1objectcount].bitmap);
 fmetapages[fmetapagecount-1].bitmap1objects[fmetabitmap1objectcount].bitmapalignment:= avalue.alignment;
 fmetapages[fmetapagecount-1].bitmap1objects[fmetabitmap1objectcount].rectarea:= arect;
 inc(fmetabitmap1objectcount);
end;

procedure TRepaz.addbitmap2toreport(const arect: rectty; avalue: tmaskedbitmap);
begin
 setlength(fmetapages[fmetapagecount-1].bitmap2objects,fmetabitmap2objectcount+1);
 avalue.savetoimagebuffer(fmetapages[fmetapagecount-1].bitmap2objects[fmetabitmap2objectcount].bitmap);
 fmetapages[fmetapagecount-1].bitmap2objects[fmetabitmap2objectcount].bitmapalignment:= avalue.alignment;
 fmetapages[fmetapagecount-1].bitmap2objects[fmetabitmap2objectcount].rectarea:= arect;
 inc(fmetabitmap2objectcount);
end;

function TRepaz.getdatasourcereport(const aname: string): tdatasource;
begin
 if fdatasourcesreport<>nil then begin
  try
   result:= fdatasourcesreport.getdatasource(aname);
  except
   //result:= nil;
   raise;
  end;
 end else begin
  result:= nil;
 end;
end;

function TRepaz.getlookupbufferreport(const aname: string): tcustomlookupbuffer;
var
 int1: integer;
begin
 result:= nil;
 if flookupbufferreport<>nil then begin
  with flookupbufferreport do begin
   for int1:=0 to count-1 do begin
    if lowercase(aname)=lowercase(lookupbuffer[int1].lookupbuffer.name) then begin
     result:= lookupbuffer[int1].lookupbuffer;
     exit;
    end;
   end;
  end;
 end;
end;

procedure TRepaz.setstatfile(const avalue: tstatfile);
begin
 setstatfilevar(istatfile(self),avalue,fstatfile);
end;

procedure TRepaz.doprogress;
begin
 if canevent(tmethod(fonprogress)) then begin
  try
   fonprogress(self);
  finally
  end;
 end;  
end;

procedure TRepaz.doonreportfinished;
begin
 isreportfinished:= true;
 if fprintdestination=pd_Preview then begin
  reportpreview;
 end else if fprintdestination=pd_Design then begin
  reportdesign;
 end else if fprintdestination=pd_Printer then begin
  reportprint(fwithdialog);
 end else if fprintdestination=pd_PostScript then begin
  reportpostscript;
 end else if fprintdestination=pd_PDF then begin
  reportpdf;
 end else if fprintdestination=pd_text then begin
  reportcsv;
 end else if fprintdestination=pd_HTML then begin
  reporthtml('html');
 end else if fprintdestination=pd_Excel then begin
  reporthtml('xls');
 end else if fprintdestination=pd_OpenOffice then begin
  reporthtml('ods');
 end else if fprintdestination=pd_PNG then begin
  reportpng;
 end;
end;

procedure TRepaz.dopagebeforebuild(const sender: TraPage;
               var empty: boolean);
begin
 if canevent(tmethod(fonpagebeforebuild)) then begin
  try
   fonpagebeforebuild(sender,empty);
  finally
  end;
 end;
end;

procedure TRepaz.dofirstpage(const apage:TraPage);
begin
 if canevent(tmethod(fonfirstpage)) then begin
  try
   fonfirstpage(apage);
  finally
  end;
 end;
end;

procedure TRepaz.doafterlastpage(const apage:TraPage);
begin
 if canevent(tmethod(fonafterlastpage)) then begin
  try
   fonafterlastpage(apage);
  finally
  end;
 end;
end;

{ TNormalTabsCol }

constructor TNormalTabsCol.create(const aowner: TraReportTemplate);
begin
 fowner:= aowner;
 inherited create(TNormalTabsItem);
end;

destructor TNormalTabsCol.destroy;
var
 int1: integer;
begin
 for int1:=count-1 downto 0 do begin
  TNormalTabsItem(items[int1]).ftabs.free;
 end;
 inherited;
end;

procedure TNormalTabsCol.assign(source: tpersistent);
begin
 inherited;
end;

procedure TNormalTabsCol.setpixelperunit(const avalue: real);
var
 int1: integer;
begin
 if count>0 then begin
  for int1:=0 to count-1 do begin
   items[int1].tabulators.setpixelperunit(avalue);
  end;
 end;
end;

function TNormalTabsCol.getheight: integer;
var
 int1: integer;
begin
 result:=0;
 for int1:=0 to count-1 do begin
  result:= result + TNormalTabsItem(items[int1]).tabulators.pixelheight;
 end;
end;

procedure TNormalTabsCol.insert(const index: integer; const aitem: TNormalTabsItem);
var
 int1: integer;
begin
 int1:= index;
 if index > count then begin
  int1:= count;
 end;
 beginupdate;
 try
  insertempty(int1);
  fitems[int1]:= aitem;
 finally
  endupdate;
 end;
end;

function TNormalTabsCol.getnormaltabsitems(index: integer): TNormalTabsItem;
begin
 result:= TNormalTabsItem(getitems(index));
end;

procedure TNormalTabsCol.setnormaltabsitems(index: integer; const Value: TNormalTabsItem);
begin
 TNormalTabsItem(getitems(index)).assign(value);
end;

procedure TNormalTabsCol.createitem(const index: integer; var item: tpersistent);
begin
 item:= TNormalTabsItem.create(fowner);
end;

{ TNormalTabsItem }

constructor TNormalTabsItem.create(const aowner: TraReportTemplate);
begin
 inherited create;
 ftabs:= TNormalTabs.create(aowner);
 ftabs.recordarea:= ra_CurrentRecord;
end;

destructor TNormalTabsItem.destroy;
begin
 ftabs.free;
end;

procedure TNormalTabsItem.assign(source: tpersistent);
begin
 if source is TNormalTabsItem then begin
  ftabs.assign(TNormalTabsItem(source).tabulators);
 end;
end;

{ TSummaryTabsCol }

constructor TSummaryTabsCol.create(const aowner: TraReportTemplate);
begin
 fowner:= aowner;
 inherited create(TSummaryTabsItem);
end;

destructor TSummaryTabsCol.destroy;
var
 int1: integer;
begin
 for int1:=count-1 downto 0 do begin
  TSummaryTabsItem(items[int1]).ftabs.free;
 end;
 inherited;
end;

procedure TSummaryTabsCol.setpixelperunit(const avalue: real);
var
 int1: integer;
begin
 if count>0 then begin
  for int1:=0 to count-1 do begin
   items[int1].tabulators.setpixelperunit(avalue);
  end;
 end;
end;

function TSummaryTabsCol.getheight: integer;
var
 int1: integer;
begin
 result:=0;
 for int1:=0 to count-1 do begin
  result:= result + TSummaryTabsItem(items[int1]).tabulators.pixelheight;
 end;
end;

procedure TSummaryTabsCol.insert(const index: integer; const aitem: TSummaryTabsItem);
var
 int1: integer;
begin
 int1:= index;
 if index > count then begin
  int1:= count;
 end;
 beginupdate;
 try
  insertempty(int1);
  fitems[int1]:= aitem;
 finally
  endupdate;
 end;
end;

function TSummaryTabsCol.getsummarytabsitems(index: integer): TSummaryTabsItem;
begin
 result:= TSummaryTabsItem(getitems(index));
end;

procedure TSummaryTabsCol.setsummarytabsitems(index: integer; const Value: TSummaryTabsItem);
begin
 TSummaryTabsItem(getitems(index)).assign(value);
end;

procedure TSummaryTabsCol.createitem(const index: integer; var item: tpersistent);
begin
 item:= TSummaryTabsItem.create(fowner);
end;

{ TSummaryTabsItem }

constructor TSummaryTabsItem.create(const aowner: TraReportTemplate);
begin
 inherited create;
 ftabs:= TSummaryTabs.create(aowner);
 ftabs.recordarea:= ra_CurrentRecord;
end;

destructor TSummaryTabsItem.destroy;
begin
 ftabs.free;
 ftabs:= nil;
end;

procedure TSummaryTabsItem.assign(source: tpersistent);
begin
 if (source is TSummaryTabsItem) or (source is TNormalTabsItem) then begin
  ftabs.assign(TSummaryTabsItem(source).tabulators);
 end;
end;

{$i repazsimplereport.inc}
{$i repazmultitablereport.inc}
{$i repazgroupreport.inc}
{$i repaztreereport.inc}
{$i repazchartreport.inc}
{$i repazletterreport.inc}
{$i repazmasterdetailreport.inc}
{$i repazlabelreport.inc}

end.
