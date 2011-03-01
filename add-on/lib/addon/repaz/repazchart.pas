{*********************************************************}
{                      Repaz Chart                        }
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
unit repazchart;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseclasses,classes,msegui,msegraphics,msetypes,msewidgets,msegraphutils,msereal,mseconsts,
 msestream,msearrayprops,mseguiglob,msedrawtext,msestrings,msedb,db,repaztypes,repazconsts,
 msepointer,mseevent,mseformatstr,msqldb,mseglob,msesys,typinfo,msestockobjects,sysutils,
 msesqldb,variants,msebitmap,mseformatbmpicoread,mseformatjpgread,mseformatpngread,mseformatpngwrite,
 math,msesysutils;

const
 defaultfontnamechart= 'Arial';
 defaultfontsizechart= 10;
 defaultfontcolorchart = cl_black;
 maxcharttype = 2;
type
 chartty = (ctBar,ctLine,ctPie);
 
 TChartItems = class;
 TraCustomChart = class;
 TChartItem = class(townedpersistent)
  protected
   ftext: msestring;
   fvalue: variant;
   procedure setvalue(const avalue: variant);
  public 
   constructor create(aowner: tobject); override;
   destructor destroy; override;
   procedure assign(const avalue: TChartItem);
  published
   property Value: variant read fvalue write setvalue;
   property Text: msestring read ftext;
  published
 end; 

 TChartItemArty = array of TChartItem;
 
 TChartItems = class(townedpersistent)
  protected
   fformat: msestring;  
   fbold,fitalic,funderline,fstrikeout: boolean;
   fhalign: halignmentty;
   fvalign: valignmentty;
   ffontname: string;
   ffontsize: integer;
   ffontcolor: colorty;
   fbitmap: tmaskedbitmap;
   fellipse : textellipsety;
   ftextoptions: textoptionsty;
   procedure setfontname(avalue: string);
   procedure setfontsize(avalue: integer);
   procedure setfontcolor(avalue: colorty);
   procedure setbold(const avalue: boolean);
   procedure setitalic(const avalue: boolean);
   procedure setunderline(const avalue: boolean);
   procedure setstrikeout(const avalue: boolean);
   procedure sethalign(const avalue: halignmentty);
   procedure setvalign(const avalue: valignmentty);
   procedure setformat(const avalue: msestring);
   procedure setbitmap(const avalue: tmaskedbitmap);
   procedure setellipse(const avalue: textellipsety);
   procedure settextoptions(const avalue: textoptionsty);
   function isstorefontname:boolean;
  public
   constructor create(const aowner: TraCustomChart);reintroduce;virtual;
   destructor destroy; override;
   procedure assign(source: tpersistent);override;
   property Bitmap: tmaskedbitmap read fbitmap write setbitmap;
   property Font_Bold: boolean read fbold write setbold default false;
   property Font_Italic: boolean read fitalic write setitalic default false;
   property Font_UnderLine: boolean read funderline write setunderline default false;
   property Font_StrikeOut: boolean read fstrikeout write setstrikeout default false;
   property Font_Name: string read ffontname write setfontname stored isstorefontname;
   property Font_Size: integer read ffontsize write setfontsize default defaultfontsizechart;
   property Font_Color: colorty read ffontcolor write setfontcolor default defaultfontcolorchart;
   property Alignment_Horizontal: halignmentty read fhalign write sethalign default ha_Left;
   property Alignment_Vertical: valignmentty read fvalign write setvalign default va_Center;
   property Ellipse: textellipsety read fellipse write setellipse;
   property TextOptions : textoptionsty read ftextoptions write settextoptions;
   property Format: msestring read fformat write setformat;
 end;

 TChartAxis = class(TChartItems)
  published
   property Font_Bold;
   property Font_Italic;
   property Font_UnderLine;
   property Font_StrikeOut;
   property Font_Name;
   property Font_Size;
   property Font_Color;
   property Alignment_Horizontal;
   property Alignment_Vertical;
   property Ellipse;
   property TextOptions;
   property Format;
 end;
 
 TChartItemsX = class(TChartItems)
  private
   fitems: TChartItemArty;
  public
   constructor create(const aowner: TraCustomChart);override;
   destructor destroy; override;
   procedure setitemcount(const avalue: integer);
   procedure clearitems;
   property ChartItems: TChartItemArty read fitems write fitems;  
 end;
 
 TChartItemsY = class(TChartItemsX)
  protected
   fbackcolor: colorty;
   fline: chartlinety;
   ffillpattern: stockbitmapty;
   ffillcolor: colorty;
   flabellegend: msestring;
  public
   constructor create(const aowner: TraCustomChart);override;
   destructor destroy; override;
   procedure assign(source: tpersistent);override;
  published
   property BackColor: colorty read fbackcolor write fbackcolor;
   property LineColor: colorty read fline.linecolor write fline.linecolor;
   property LineCap: capstylety read fline.capstyle write fline.capstyle;
   property LineJoin: joinstylety read fline.joinstyle write fline.joinstyle;
   property LineStyle: linestylety read fline.linestyle write fline.linestyle;
   property LineWidth: real read fline.linewidth write fline.linewidth;
   property FillPattern: stockbitmapty read ffillpattern write ffillpattern;
   property FillColor: colorty read ffillcolor write ffillcolor;
   property LabelLegend: msestring read flabellegend write flabellegend;
   property Bitmap;
   property Font_Bold;
   property Font_Italic;
   property Font_UnderLine;
   property Font_StrikeOut;
   property Font_Name;
   property Font_Size;
   property Font_Color;
   property Alignment_Horizontal;
   property Alignment_Vertical;
   property Ellipse;
   property TextOptions;
   property Format;
 end;
 
 TChartYColItem = class(tvirtualpersistent)
  protected
   fchartitems: TChartItemsY;
  public
   constructor create(const aowner: TraCustomChart);reintroduce;
   destructor destroy;override;
   procedure assign(source: tpersistent);override;
  published
   property Values: TChartItemsY read fchartitems write fchartitems;
 end;

 TChartYCol = class(tpersistentarrayprop)
  private
   fowner: TraCustomChart;
   function getchartyitems(index: integer): TChartYColItem;
   procedure setchartyitems(index: integer; const value: TChartYColItem);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: TraCustomChart);
   destructor destroy; override;
   procedure insert(const index: integer; const aitem: TChartYColItem); overload;
   property items[index: integer]: TChartYColItem read getchartyitems write setchartyitems; default;
 end;

 TdbChartItemsX = class(TChartItemsX,idbeditinfo)
  protected
   fdatalink: tfielddatalink;
   function getdatafield: string;
               //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource;
   procedure getfieldtypes(out apropertynames: stringarty;
                           out afieldtypes: fieldtypesarty);
   procedure setdatafield(const avalue: string);
  public
   constructor create(const aowner: TraCustomChart);override;
   destructor destroy; override;
  published
   property DataField: string read getdatafield write setdatafield;
 end;

 TdbChartItemsY = class(TChartItemsY,idbeditinfo)
  protected
   fdatalink: tfielddatalink;
   function getdatafield: string;
               //idbeditinfo
   function getdatasource(const aindex: integer): tdatasource;
   procedure getfieldtypes(out apropertynames: stringarty;
                           out afieldtypes: fieldtypesarty);
   procedure setdatafield(const avalue: string);
  public
   constructor create(const aowner: TraCustomChart);override;
   destructor destroy; override;
   procedure assign(source: tpersistent);override;
  published
   property DataField: string read getdatafield write setdatafield;
 end;
 
 TdbChartYColItem = class(tvirtualpersistent)
  protected
   fchartitems: TdbChartItemsY;
  public
   constructor create(const aowner: TraCustomChart);reintroduce;
   destructor destroy;override;
   procedure assign(source: tpersistent);override;
  published
   property Values: TdbChartItemsY read fchartitems write fchartitems;
 end;

 TdbChartYCol = class(tpersistentarrayprop)
  private
   fowner: TraCustomChart;
   function getchartyitems(index: integer): TdbChartYColItem;
   procedure setchartyitems(index: integer; const value: TdbChartYColItem);
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create(const aowner: TraCustomChart);
   destructor destroy; override;
   procedure insert(const index: integer; const aitem: TdbChartYColItem); overload;
   property items[index: integer]: TdbChartYColItem read getchartyitems write setchartyitems; default;
 end;
 
 valueposty = (vpInside,vpOutside);
 legendposty = (lpTop,lpBottom,lpLeft,lpRight);
 percentvaluety = (pvShowPercent,pvShowPercentOnly);
 percentvaluesty = set of percentvaluety;
 
 TraCustomChart = class(townedpersistent)
  protected
   fcharttype: chartty;
   fchartx: TChartItemsX;
   fcharty: TChartYCol;
   fdepth: integer;
   fshadowcolor: colorty;
   fshowvalue: boolean;
   fshowlegend: boolean;
   fvaluepos: valueposty;
   flegendpos: legendposty;
   fxaxiscaption,fyaxiscaption,fchartcaption: msestring;
   fxaxis,fyaxis: TChartAxis;
   faxiscaption: TChartAxis;
   fcaptionstyle: TChartAxis;
   flegendsize: integer;
   flegendbackcolor: colorty;
   flegendlinecolor: colorty;
   fxasvalue: boolean;
   fscale: real;
   fshowpercentvalue: percentvaluesty;
   procedure setxasvalue(const avalue: boolean);virtual;
   function getchartcolor(aindex:integer): colorty;
   function getpattern(aindex:integer): tsimplebitmap;
  public
   constructor create(const aowner: tcomponent);reintroduce;virtual;
   destructor destroy; override;   
   procedure paintchart(const canvas: tcanvas;area:rectty);
   property ZoomScale: real read fscale write fscale;
   property ChartType: chartty read fcharttype write fcharttype;
   property Shadow_Depth: integer read fdepth write fdepth;
   property Shadow_Color: colorty read fshadowcolor write fshadowcolor default cl_gray;
   property ShowValue: boolean read fshowvalue write fshowvalue default true;
   property ShowPercentValue: percentvaluesty read fshowpercentvalue write fshowpercentvalue default [];
   property ValuePosition: valueposty read fvaluepos write fvaluepos default vpInside;
   property Legend_Show: boolean read fshowlegend write fshowlegend default true;
   property Legend_Position: legendposty read flegendpos write flegendpos default lpBottom;
   property Legend_Size: integer read flegendsize write flegendsize default 200;
   property Legend_BackColor: colorty read flegendbackcolor write flegendbackcolor default cl_white;
   property Legend_LineColor: colorty read flegendlinecolor write flegendlinecolor default cl_black;
   property ChartCaption: msestring read fchartcaption write fchartcaption;
   property ChartCaptionStyle: TChartAxis read fcaptionstyle write fcaptionstyle;
   property X_Value: TChartItemsX read fchartx write fchartx;
   property X_AxisCaption: msestring read fxaxiscaption write fxaxiscaption;
   property X_AxisLabel: TChartAxis read fxaxis write fxaxis;
   property X_LabelAsValue: boolean read fxasvalue write setxasvalue default false;
   property Y_AxisCaption: msestring read fyaxiscaption write fyaxiscaption;
   property Y_Values: TChartYCol read fcharty write fcharty;
   property Y_AxisLabel: TChartAxis read fyaxis write fyaxis;
   property AxisCaption: TChartAxis read faxiscaption write faxiscaption;
 end;

 TradbCustomChart = class(TraCustomChart)
  private
   fdbchartx: TdbChartItemsX;
   fdbcharty: TdbChartYCol;
  protected
   fchartdatasource: tdatasource;
   procedure setxasvalue(const avalue: boolean);override;
   procedure setchartdatasource(const avalue: tdatasource);
   function getchartdatasource: tdatasource;
   procedure rebuildchart;
  public
   constructor create(const aowner: tcomponent); override;
   destructor destroy; override;   
   property ChartDataSource: tdatasource read getchartdatasource write setchartdatasource;
   property X_ValueDB: TdbChartItemsX read fdbchartx write fdbchartx;
   property Y_ValuesDB: TdbChartYCol read fdbcharty write fdbcharty;   
 end;

 TraCustomChartWidget = class(TradbCustomChart)
  published
   property ChartDataSource;
   property ChartType;
   property Shadow_Depth;
   property Shadow_Color;
   property ShowValue;
   property ShowPercentValue;
   property ValuePosition;
   property Legend_Position;
   property Legend_Show;
   property Legend_BackColor;
   property Legend_LineColor;
   property Legend_Size;
   property X_ValueDB;
   property X_AxisCaption;
   property X_AxisLabel;
   property X_LabelAsValue;
   property Y_ValuesDB;   
   property Y_AxisCaption;
   property Y_AxisLabel;
   property AxisCaption;
   property ChartCaption;
   property ChartCaptionStyle;
 end;

 TRepazChart = class(tactionwidget)
  private
   fchart: TraCustomChartWidget;
  protected
   procedure dopaint(const canvas: tcanvas); override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   class function classskininfo: skininfoty; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
  published
   property Chart: TraCustomChartWidget read fchart write fchart;  
   property visible;
   property enabled;
   property left;
   property top;
   property width;
   property height;
   property optionswidget default defaultoptionswidgetmousewheel;
   property optionsskin;
   property bounds_x;
   property bounds_y;
   property bounds_cx;
   property bounds_cy;
   property bounds_cxmin;
   property bounds_cymin;
   property bounds_cxmax;
   property bounds_cymax;
   property color;
   property cursor;
   property frame;
   property face;
   property anchors;
   property taborder;
   property hint;
   property popupmenu;
   property onpopup;
   property onshowhint;
   property onenter;
   property onexit;
   property onfocus;
   property ondefocus;
   property onactivate;
   property ondeactivate;
 end;

implementation

{ TChartItem }

procedure TChartItem.setvalue(const avalue: variant);
begin
 if fvalue<>avalue then begin
  fvalue:= avalue;
  ftext:= vartoformattedtext(avalue,TChartItems(fowner).format);
 end; 
end;

constructor TChartItem.create(aowner: tobject);
begin
 inherited;
 ftext:= '';
 fvalue:= null;
 fowner:= TChartItems(aowner);
end;

destructor TChartItem.destroy;
begin
 inherited;
end; 

procedure TChartItem.assign(const avalue: TChartItem);
begin
 fvalue:= avalue.fvalue;
 ftext:= avalue.ftext;
end;

{ TChartItems }

constructor TChartItems.create(const aowner: TraCustomChart);
begin
 inherited;
 fformat:= '';  
 fbold:= false;
 fitalic:= false;
 funderline:= false;
 fstrikeout:= false;
 fhalign:= ha_Left;
 fvalign:= va_Center;
 ffontname:= defaultfontnamechart;
 ffontsize:= defaultfontsizechart;
 ffontcolor:= cl_black;
 fbitmap:= tmaskedbitmap.create(false);
 fellipse:= el_None;
 ftextoptions:= [];
 fowner:= aowner;
end;

destructor TChartItems.destroy;
begin
 inherited;
 fbitmap.free;
end;

procedure TChartItems.assign(source: tpersistent);
var
 tmpbmp: imagety;
begin
 if source is TChartItems then begin
  fformat:= TChartItems(source).fformat;  
  setbold(TChartItems(source).fbold);
  setitalic(TChartItems(source).fitalic);
  setunderline(TChartItems(source).funderline);
  setstrikeout(TChartItems(source).fstrikeout);
  setfontname(TChartItems(source).ffontname);
  setfontsize(TChartItems(source).ffontsize);
  setfontcolor(TChartItems(source).ffontcolor);
  fhalign:= TChartItems(source).fhalign;
  fvalign:= TChartItems(source).fvalign;
  TChartItems(source).fbitmap.savetoimage(tmpbmp);
  fbitmap.alignment:= TChartItems(source).fbitmap.alignment;
  fbitmap.loadfromimage(tmpbmp);
  fellipse:= TChartItems(source).fellipse;
  ftextoptions:= TChartItems(source).ftextoptions;
 end;
end;

procedure TChartItems.setfontname(avalue: string);
begin
 if avalue<>ffontname then begin
  ffontname:= avalue;
 end;
end;

procedure TChartItems.setfontsize(avalue: integer);
begin
 if avalue<>ffontsize then begin
  ffontsize:= avalue;
 end; 
end;

procedure TChartItems.setfontcolor(avalue: colorty);
begin
 if avalue<>ffontcolor then begin
  ffontcolor:= avalue;
 end; 
end;

procedure TChartItems.setbold(const avalue: boolean);
begin
 if avalue<>fbold then begin
  fbold:= avalue;
 end; 
end;

procedure TChartItems.setitalic(const avalue: boolean);
begin
 if avalue<>fitalic then begin
  fitalic:= avalue;
 end;  
end;

procedure TChartItems.setunderline(const avalue: boolean);
begin
 if avalue<>funderline then begin
  funderline:= avalue;
 end;  
end;

procedure TChartItems.setstrikeout(const avalue: boolean);
begin
 if avalue<>fstrikeout then begin
  fstrikeout:= avalue;
 end;  
end;

procedure TChartItems.sethalign(const avalue: halignmentty);
begin
 if avalue<>fhalign then begin
  fhalign:= avalue;
 end;  
end;

procedure TChartItems.setvalign(const avalue: valignmentty);
begin
 if avalue<>fvalign then begin
  fvalign:= avalue;
 end;  
end;

procedure TChartItems.setformat(const avalue: msestring);
begin
 if avalue<>fformat then begin
  fformat:= avalue;
 end;  
end;

procedure TChartItems.setbitmap(const avalue: tmaskedbitmap);
begin
 if avalue<>fbitmap then begin
  fbitmap:= avalue;
 end;  
end;

procedure TChartItems.setellipse(const avalue: textellipsety);
begin
 if avalue<>fellipse then begin
  fellipse:= avalue;
 end;
end;
  
procedure TChartItems.settextoptions(const avalue: textoptionsty);
begin
 if avalue<>ftextoptions then begin
  ftextoptions:= avalue;
 end;  
end;

function TChartItems.isstorefontname:boolean;
begin
 result:= ffontname<>defaultfontnamechart; 
end;

{ TChartItemsX }

constructor TChartItemsX.create(const aowner: TraCustomChart);
begin
 inherited;
end;

destructor TChartItemsX.destroy;
begin
 inherited;
 clearitems;
end;

procedure TChartItemsX.setitemcount(const avalue: integer);
var
 int1: integer;
begin
 fitems:= nil; 
 setlength(fitems,avalue);
 for int1:=0 to avalue-1 do begin
  fitems[int1]:= TChartItem.create(self);
 end;
end;

procedure TChartItemsX.clearitems;
var
 int1: integer;
begin
 for int1:=high(fitems) downto 0 do begin
  fitems[int1].free;
 end; 
 fitems:= nil; 
end;
 
{ TChartItemsY }

constructor TChartItemsY.create(const aowner: TraCustomChart);
begin
 inherited;
 fbackcolor:= cl_white;
 fline.linecolor:= cl_black;
 fline.linewidth:= 0;
 fline.linestyle:= ls_solid;
 fline.capstyle:= cs_butt;
 ffillpattern:= stb_none;
 ffillcolor:= cl_ltgray;
 flabellegend:= '';
end;

destructor TChartItemsY.destroy;
begin
 inherited;
end; 

procedure TChartItemsY.assign(source: tpersistent);
begin
 if source is TChartItemsY then begin
  inherited;
  fbackcolor:= TChartItemsY(source).fbackcolor;
  fline:= TChartItemsY(source).fline;
  ffillpattern:= TChartItemsY(source).ffillpattern;
  ffillcolor:= TChartItemsY(source).ffillcolor; 
  flabellegend:= TChartItemsY(source).flabellegend; 
 end;
end;

{ TChartYColItem }

constructor TChartYColItem.create(const aowner: TraCustomChart);
begin
 inherited create;
 fchartitems:= TChartItemsY.create(aowner);
end;

destructor TChartYColItem.destroy;
begin
 inherited;
 //fchartitems.destroy;
end;

procedure TChartYColItem.assign(source: tpersistent);
begin
 if source is TChartYColItem then begin
  fchartitems.assign(TChartYColItem(source));
 end;
end;

{ TChartYCol }

function TChartYCol.getchartyitems(index: integer): TChartYColItem;
begin
 result:= TChartYColItem(getitems(index));
end;

procedure TChartYCol.setchartyitems(index: integer; const value: TChartYColItem);
begin
 TChartYColItem(getitems(index)).assign(value);
end;

procedure TChartYCol.createitem(const index: integer; var item: tpersistent);
begin
 item:= TChartYColItem.create(fowner);
end;

constructor TChartYCol.create(const aowner: TraCustomChart);
begin
 fowner:= aowner;
 inherited create(TChartYColItem);
end;

destructor TChartYCol.destroy;
var
 int1: integer;
begin
 for int1:=count-1 downto 0 do begin
  TChartYColItem(items[int1]).values.destroy;
 end;
 inherited;
end;

procedure TChartYCol.insert(const index: integer; const aitem: TChartYColItem);
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

{ TdbChartItemsX }

constructor TdbChartItemsX.create(const aowner: TraCustomChart);
begin
 inherited;
 fdatalink:= tfielddatalink.create; 
 fdatalink.dataSource:= TradbCustomChart(fowner).ChartDataSource;
end;

destructor TdbChartItemsX.destroy;
begin
 inherited;
 fdatalink.free;
end;

function TdbChartItemsX.getdatafield: string;
begin
 result:= fdatalink.fieldname; 
end;

function TdbChartItemsX.getdatasource(const aindex: integer): tdatasource;
begin
 result:= fdatalink.DataSource; 
end;

procedure TdbChartItemsX.getfieldtypes(out apropertynames: stringarty;
                        out afieldtypes: fieldtypesarty);
begin
 apropertynames:= nil;
 afieldtypes:= nil; 
end;

procedure TdbChartItemsX.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue; 
end;

{ TdbChartItemsY }

constructor TdbChartItemsY.create(const aowner: TraCustomChart);
begin
 inherited;
 fdatalink:= tfielddatalink.create; 
 fdatalink.dataSource:= TradbCustomChart(fowner).ChartDataSource;
end;

destructor TdbChartItemsY.destroy;
begin
 inherited;
 fdatalink.free;
end;

procedure TdbChartItemsY.assign(source: tpersistent);
begin
 if source is TdbChartItemsY then begin
  inherited;
  setdatafield(TdbChartItemsY(source).datafield);
 end;
end;

function TdbChartItemsY.getdatafield: string;
begin
 result:= fdatalink.fieldname; 
end;

function TdbChartItemsY.getdatasource(const aindex: integer): tdatasource;
begin
 result:= fdatalink.DataSource; 
end;

procedure TdbChartItemsY.getfieldtypes(out apropertynames: stringarty;
                        out afieldtypes: fieldtypesarty);
begin
 apropertynames:= nil;
 setlength(afieldtypes,1);
 afieldtypes[0]:= realfields + integerfields;
end;

procedure TdbChartItemsY.setdatafield(const avalue: string);
begin
 fdatalink.fieldname:= avalue; 
end;

{ TdbChartYColItem }

constructor TdbChartYColItem.create(const aowner: TraCustomChart);
begin
 inherited create;
 fchartitems:= TdbChartItemsY.create(aowner);
end;

destructor TdbChartYColItem.destroy;
begin
 inherited;
 fchartitems.free;
end;

procedure TdbChartYColItem.assign(source: tpersistent);
begin
 if source is TdbChartYColItem then begin
  fchartitems.assign(TdbChartYColItem(source).values);
 end;
end; 

{ TdbChartYCol }

function TdbChartYCol.getchartyitems(index: integer): TdbChartYColItem;
begin
 result:= TdbChartYColItem(getitems(index));
end;

procedure TdbChartYCol.setchartyitems(index: integer; const value: TdbChartYColItem);
begin
 TdbChartYColItem(getitems(index)).assign(value);
end;

procedure TdbChartYCol.createitem(const index: integer; var item: tpersistent);
begin
 item:= TdbChartYColItem.create(fowner);
end;

constructor TdbChartYCol.create(const aowner: TraCustomChart);
begin
 fowner:= aowner;
 inherited create(TdbChartYColItem);
end;

destructor TdbChartYCol.destroy;
begin
 inherited;
end;

procedure TdbChartYCol.insert(const index: integer; const aitem: TdbChartYColItem);
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
 
{ TraCustomChart }

constructor TraCustomChart.create(const aowner: tcomponent);
begin
 inherited create(tobject(aowner));
 fcharttype:= ctBar;
 fchartx:= TChartItemsX.create(self);
 fcharty:= TChartYCol.create(self);
 fdepth:= 0;
 fshadowcolor:= cl_gray;
 fshowvalue:= true;
 fshowlegend:= true;
 fvaluepos:= vpInside;
 flegendpos:= lpBottom;
 fxaxis:= TChartAxis.create(self);
 fxaxis.Alignment_Horizontal:= ha_Center;
 fxaxis.Font_Size:=8;
 fyaxis:= TChartAxis.create(self);
 fyaxis.Alignment_Horizontal:= ha_Center;
 fyaxis.Alignment_Vertical:= va_Center;
 fyaxis.Font_Size:=8;
 faxiscaption:= TChartAxis.create(self);
 faxiscaption.Alignment_Horizontal:= ha_Center;
 faxiscaption.Font_Size:=12;
 fcaptionstyle:= TChartAxis.create(self);
 fcaptionstyle.Alignment_Horizontal:= ha_Center;
 fcaptionstyle.Font_Size:=14;
 flegendsize:= 200;
 flegendbackcolor:= cl_white;
 flegendlinecolor:= cl_black;
 fxasvalue:= false;
 fshowpercentvalue:= [];
 fscale:= 1;
 fxaxiscaption:= 'Axis X';
 fyaxiscaption:= 'Axis Y';
 fchartcaption:= 'Chart Title';
end;

destructor TraCustomChart.destroy;
begin
 inherited;
 fchartx.destroy;
 fcharty.destroy;
 faxiscaption.destroy;
 fcaptionstyle.destroy;
 fxaxis.destroy;
 fyaxis.destroy;
end;

procedure TraCustomChart.setxasvalue(const avalue: boolean);
begin
 if fxasvalue<>avalue then begin
  fxasvalue:= avalue;
 end;
end;

function TraCustomChart.getchartcolor(aindex:integer): colorty;
begin
 case aindex of
  0:result:= rgbtocolor(255,182,148);
  1:result:= rgbtocolor(204,214,229);
  2:result:= rgbtocolor(82,211,165);
  3:result:= rgbtocolor(255,155,106);
  4:result:= rgbtocolor(108,150,202);
  5:result:= rgbtocolor(255,195,57);
  6:result:= rgbtocolor(111,160,222);
  7:result:= rgbtocolor(255,100,90);
  8:result:= rgbtocolor(155,216,154);
  9:result:= rgbtocolor(255,169,141);
  10:result:= rgbtocolor(191,185,218);
  11:result:= rgbtocolor(239,197,115);
  12:result:= rgbtocolor(142,210,219);
  13:result:= rgbtocolor(193,222,121);
  14:result:= rgbtocolor(49,190,220);
  15:result:= rgbtocolor(255,155,69);
  16:result:= rgbtocolor(0,179,220);
  17:result:= rgbtocolor(169,211,82);
  18:result:= rgbtocolor(172,219,151);
  19:result:= rgbtocolor(128,184,196);
  20:result:= rgbtocolor(225,229,124);
  21:result:= rgbtocolor(108,150,202);
 end;
end;

function TraCustomChart.getpattern(aindex:integer): tsimplebitmap;
begin
 case aindex of
  0:result:= stockobjects.bitmaps[stb_hatchup3];
  1:result:= stockobjects.bitmaps[stb_hatchup4];
  2:result:= stockobjects.bitmaps[stb_hatchup5];
  3:result:= stockobjects.bitmaps[stb_hatchdown3];
  4:result:= stockobjects.bitmaps[stb_hatchdown4];
  5:result:= stockobjects.bitmaps[stb_hatchdown5];
  6:result:= stockobjects.bitmaps[stb_dens10];
  7:result:= stockobjects.bitmaps[stb_dens25];
  8:result:= stockobjects.bitmaps[stb_dens50];
  9:result:= stockobjects.bitmaps[stb_dens75];
  10:result:= stockobjects.bitmaps[stb_dens90];
  11:result:= stockobjects.bitmaps[stb_crosshatch3];
  12:result:= stockobjects.bitmaps[stb_crosshatch4];
  13:result:= stockobjects.bitmaps[stb_crosshatch5];
  14:result:= stockobjects.bitmaps[stb_crosshatch6];
 end;
end;

procedure TraCustomChart.paintchart(const canvas: tcanvas;area:rectty);
 function createflag(avalue: TChartItems): textflagsty;
 begin
  result:= [];
  case avalue.Alignment_Horizontal of 
   ha_Center: begin
    result:= result + [tf_xcentered];
   end;
   ha_Right: begin   
    result:= result + [tf_right];
   end;
  end;
  case avalue.Alignment_Vertical of 
   va_Center: begin
    result:= result + [tf_ycentered];
   end;
   va_Bottom: begin   
    result:= result + [tf_bottom];
   end;
  end;
 end;

 function createstyle(avalue: TChartItems): fontstylesty;
 begin
  result:= [];
  if avalue.font_bold then result:= result + [fs_bold];
  if avalue.font_italic then result:= result + [fs_italic];
  if avalue.font_underline then result:= result + [fs_underline];
  if avalue.font_strikeout then result:= result + [fs_strikeout];
 end;
 
 procedure rotaterect(var arect: rectty);
 var
  int1: integer;
 begin
  with arect do begin
   x:= x+((cx-cy) div 2);
   y:= y-((cx-cy) div 2);
   int1:= cx;
   cx:= cy;
   cy:= int1;
  end;
 end;
 
 procedure hcenterrect(var rect1: rectty; const rect2: rectty);
 begin
  rect1.x:= rect2.x + ((rect2.cx-rect1.cx) div 2);
 end;
 
 procedure getposfromcircle(apoint: pointty; angle:float; radius: float;
   avaluepos: valueposty; var atextrect: rectty);
 var
  angle1,angle2,rad1: float;
  cos1,sin1: float;
 begin
  if avaluepos=vpInside then begin
   rad1:= radius/4;
  end else begin
   rad1:= radius/2;
  end;
  if angle<=0.5*pi then begin
   angle1:= angle;
   sincos(angle1,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.y:= apoint.y -round(rad1*sin1)-(atextrect.cy div 2)
   else
    atextrect.y:= apoint.y -round(rad1*sin1)-atextrect.cy;
   angle2:= 0.5*pi-angle1;
   sincos(angle2,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.x:= apoint.x+round(rad1*sin1)-(atextrect.cx div 2)
   else
    atextrect.x:= apoint.x+round(rad1*sin1);
  end else if angle<=pi then begin
   angle1:= pi-angle;
   sincos(angle1,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.y:= apoint.y-round(rad1*sin1)-(atextrect.cy div 2)
   else
    atextrect.y:= apoint.y-round(rad1*sin1)-atextrect.cy;
   angle2:= 0.5*pi-angle1;
   sincos(angle2,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.x:= apoint.x-round(rad1*sin1)-(atextrect.cx div 2)
   else
    atextrect.x:= apoint.x-round(rad1*sin1)-atextrect.cx;
  end else if angle<=1.5*pi then begin
   angle1:= angle-pi;
   sincos(angle1,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.y:= apoint.y+round(rad1*sin1)-(atextrect.cy div 2)
   else
    atextrect.y:= apoint.y+round(rad1*sin1);
   angle2:= 0.5*pi-angle1;
   sincos(angle2,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.x:= apoint.x-round(rad1*sin1)-(atextrect.cx div 2)
   else
    atextrect.x:= apoint.x-round(rad1*sin1)-atextrect.cx;
  end else if angle<=2*pi then begin
   angle1:= 2*pi-angle;
   sincos(angle1,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.y:= apoint.y+round(rad1*sin1)-(atextrect.cy div 2)
   else
    atextrect.y:= apoint.y+round(rad1*sin1);
   angle2:= 0.5*pi-angle1;
   sincos(angle2,sin1,cos1);
   if avaluepos=vpInside then
    atextrect.x:= apoint.x+round(rad1*sin1)-(atextrect.cx div 2)
   else
    atextrect.x:= apoint.x+round(rad1*sin1);
  end;
 end;
 
var
 rcount,int1,int2,chartwidth,chartheight,barwidth,gapmajor,gapminor,xaxislabel,
 yaxislabel,barheight,county,deltax,deltay,linemajor,lineminor,haxiscaption,
 posy,posx,maxx,int3,int4,startx,starty,colpie,rowpie,sizepie,deltapiex,deltapiey: integer;
 tmprect,tmprect2,tmprect3: rectty;
 xflags,yflags: textflagsty; 
 max,min,ydeltavalue,xdeltavalue,curvalue: double;
 ypercent,xpercent,rea1,rea2: real;
 fchartarea: rectty;
 flines: array of pointty;
 point1: pointty;
 fpies: array of rectty;
 toty: array of double;
 tmplabel: msestring;
 tmplegendsize: integer;
 fpoly: pointarty;
const
 maxytick = 10;
begin
 rcount:= length(fchartx.chartitems)-1;
 if rcount<=0 then exit;
 county:= fcharty.count;
 if county=0 then exit;
 chartwidth:= area.cx;
 chartheight:= area.cy;
 gapmajor:= 12;
 gapminor:= 6;
 linemajor:= 4;
 lineminor:= 2;
 area.y:= area.y+10;
 area.cy:= area.cy-20;
 area.x:= area.x+10;
 area.cx:= area.cx-20;
 //draw caption
 if fchartcaption<>'' then begin
  canvas.save;
  xflags:= createflag(fcaptionstyle);
  canvas.font.color:= fcaptionstyle.font_color;
  if fscale<>1 then
   canvas.font.height:= round(fcaptionstyle.font_size * fscale)
  else
   canvas.font.height:= fcaptionstyle.font_size;
  canvas.font.name:= fcaptionstyle.font_name;
  canvas.font.style:= createstyle(fcaptionstyle);
  if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
  int2:= textrect(canvas,fchartcaption,area,xflags,nil,nil).cy;
  drawtext(canvas,fchartcaption,
    makerect(area.x,area.y,area.cx,int2),
    xflags,nil,nil);
  area.y:= area.y+int2+20;
  area.cy:= area.cy-int2-20;
  canvas.restore;
 end;
 //draw legend
 if fscale<>1 then
  tmplegendsize:= round(flegendsize*fscale)
 else
  tmplegendsize:= flegendsize;
 if fshowlegend and (tmplegendsize>0) then begin
  if flegendpos=lpLeft then begin
   fchartarea.x:= tmplegendsize;
   fchartarea.cx:= area.cx-tmplegendsize;
   fchartarea.y:= area.y;
   fchartarea.cy:= area.cy;
   tmprect.x:= area.x;
   tmprect.y:= area.y;
   tmprect.cx:= tmplegendsize-4;
   tmprect.cy:= area.cy;
  end else if flegendpos=lpRight then begin
   fchartarea.x:= area.x;
   fchartarea.cx:= area.cx-tmplegendsize;
   fchartarea.y:= area.y;
   fchartarea.cy:= area.cy;
   tmprect.x:= area.x+area.cx-tmplegendsize-4;
   tmprect.y:= area.y;
   tmprect.cx:= tmplegendsize-4;
   tmprect.cy:= area.cy;
  end else if flegendpos=lpTop then begin
   fchartarea.x:= area.x;
   fchartarea.cx:= area.cx;
   fchartarea.y:= area.y+tmplegendsize;
   fchartarea.cy:= area.cy-tmplegendsize;
   tmprect.x:= area.x;
   tmprect.y:= area.y;
   tmprect.cy:= tmplegendsize-4;
   tmprect.cx:= area.cx;
  end else if flegendpos=lpBottom then begin
   fchartarea.x:= area.x;
   fchartarea.cx:= area.cx;
   fchartarea.y:= area.y;
   fchartarea.cy:= area.cy-tmplegendsize;
   tmprect.x:= area.x;
   tmprect.y:= area.y+area.cy-tmplegendsize+2;
   tmprect.cx:= area.cx;
   tmprect.cy:= tmplegendsize-2;
  end;
  canvas.save;
  if fdepth>0 then begin
   canvas.fillrect(makerect(tmprect.x+fdepth,
   tmprect.y-fdepth,tmprect.cx,tmprect.cy),fshadowcolor);
  end;
  canvas.fillrect(tmprect,flegendbackcolor);
  canvas.drawframe(tmprect,1,flegendlinecolor);
  canvas.restore;
  posy:=2;
  posx:=2;
  maxx:=0;
  for int1:=0 to county-1 do begin
   canvas.save;
   canvas.font.color:= fcharty[int1].values.font_color;
   if fscale<>1 then
    canvas.font.height:= round(fcharty[int1].values.font_size * fscale)
   else
    canvas.font.height:= fcharty[int1].values.font_size;
   canvas.font.name:= fcharty[int1].values.font_name;
   canvas.font.style:= createstyle(fcharty[int1].values);
   if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
   canvas.linewidthmm:= fcharty[int1].values.linewidth;
   canvas.dashes:= linestyles[fcharty[int1].values.linestyle];
   canvas.joinstyle:= fcharty[int1].values.linejoin;
   canvas.capstyle:= fcharty[int1].values.linecap;
   yflags:= createflag(fcharty[int1].values);
   tmprect2:= textrect(canvas,fcharty[int1].values.labellegend,tmprect,yflags,nil,nil);
   if posy+tmprect2.cy<=tmprect.cy then begin
    tmprect2.x:= tmprect.x+posx+18;
    tmprect2.y:= tmprect.y+posy;
    tmprect3.cx:= 15;
    tmprect3.x:= tmprect.x+posx;
    tmprect3.y:= tmprect2.y;
    tmprect3.cy:= tmprect2.cy;
    if tmprect2.x+tmprect2.cx>tmprect.x+tmprect.cx then begin
     canvas.restore;
     break;
    end;
   end else begin
    if posx+maxx<=tmprect.cx then begin
     posx:= posx+ maxx+6;
     posy:= 2;
     tmprect2.x:= tmprect.x+posx+18;
     tmprect2.y:= tmprect.y+posy;
     tmprect3.cx:= 15;
     tmprect3.x:= tmprect.x+posx;
     tmprect3.y:= tmprect2.y;
     tmprect3.cy:= tmprect2.cy;
    end else begin
     canvas.restore;
     break;
    end;
   end;
   if fcharttype=ctBar then begin
    if fdepth>0 then begin
     canvas.fillrect(makerect(tmprect3.x+fdepth,
     tmprect3.y-fdepth,tmprect3.cx,tmprect3.cy),fshadowcolor);
    end;
    canvas.fillrect(tmprect3,fcharty[int1].values.backcolor);
    if fcharty[int1].values.fillpattern <> stb_none then begin
     canvas.brush:= stockobjects.bitmaps[fcharty[int1].values.fillpattern];
     canvas.color:= fcharty[int1].values.fillcolor;
     canvas.fillrect(tmprect3,cl_brushcanvas);
    end;
    canvas.drawrect(tmprect3,fcharty[int1].values.linecolor);
   end else if fcharttype=ctPie then begin
    canvas.fillrect(tmprect3,cl_white);
    canvas.drawrect(tmprect3,fcharty[int1].values.linecolor);
   end else if fcharttype=ctLine then begin
    int2:= tmprect3.y+(tmprect3.cy div 2);
    canvas.drawline(makepoint(tmprect3.x,int2),makepoint(tmprect3.x+tmprect3.cx,int2),
      fcharty[int1].values.linecolor);
   end;
   drawtext(canvas,fcharty[int1].values.labellegend,tmprect2,yflags,nil,nil);
   posy:= posy + tmprect3.cy+4;
   if (tmprect3.cx+tmprect2.cx)>maxx then begin
    maxx:= tmprect3.cx+tmprect2.cx;
   end;
   canvas.restore;
  end;
 end;
 //end draw legend
 //get min and max values y
 setlength(toty,county);
 for int1:=0 to county-1 do begin
  toty[int1]:=0;
 end;
 max:= 0;
 min:= 0;
 for int2:=0 to fcharty.count-1 do begin
  for int1:=0 to rcount do begin
   if fcharty[int2].values.chartitems[int1].value=null then
    curvalue:= 0
   else
    curvalue:= double(fcharty[int2].values.chartitems[int1].value);
   toty[int2]:= toty[int2]+curvalue;
   if curvalue>max then begin
    max:= curvalue;
   end;
   if curvalue<min then begin
    min:= curvalue;
   end;
  end;
 end;
 ydeltavalue:= max-min;

 if fxasvalue then begin
  max:= 0;
  min:= 0;
  for int1:=0 to rcount do begin
   if fchartx.chartitems[int1].value=null then
    curvalue:= 0
   else
    curvalue:= double(fchartx.chartitems[int1].value);
   if curvalue>max then begin
    max:= curvalue;
   end;
   if curvalue<min then begin
    min:= curvalue;
   end;
  end;
  xdeltavalue:= max-min;
 end else begin
  xdeltavalue:= 0;
 end;
 
 //get height axis label
 if fcharttype=ctPie then begin
  xaxislabel:=0;
  yaxislabel:=0;
 end else begin
  canvas.save;
  xflags:= createflag(fxaxis);
  canvas.font.color:= fxaxis.font_color;
  if fscale<>1 then
   canvas.font.height:= round(fxaxis.font_size * fscale)
  else
   canvas.font.height:= fxaxis.font_size;
  canvas.font.name:= fxaxis.font_name;
  canvas.font.style:= createstyle(fxaxis);
  if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
  xaxislabel:= textrect(canvas,'XX',area,xflags,nil,nil).cy;
  canvas.restore;
  canvas.save;
  xflags:= createflag(fyaxis);
  canvas.font.color:= fyaxis.font_color;
  if fscale<>1 then
   canvas.font.height:= round(fyaxis.font_size * fscale)
  else
   canvas.font.height:= fyaxis.font_size;
  canvas.font.name:= fyaxis.font_name;
  canvas.font.style:= createstyle(fyaxis);
  if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
  yaxislabel:= 0;
  for int1:=1 to maxytick do begin
   int2:= textrect(canvas,realtytostr((int1/maxytick)*ydeltavalue,fyaxis.format),area,xflags,nil,nil).cx;
   if int2>yaxislabel then yaxislabel:= int2;
  end;
  yaxislabel:= yaxislabel+3;
  canvas.restore;
  fchartarea.x:= fchartarea.x+yaxislabel;
  fchartarea.cx:= fchartarea.cx-yaxislabel;
  fchartarea.cy:= fchartarea.cy-xaxislabel;
 end;
 fchartarea.x:= fchartarea.x+linemajor;
 fchartarea.cx:= fchartarea.cx-linemajor-20;
 fchartarea.cy:= fchartarea.cy-linemajor;
 //get height axis caption
 if fcharttype<>ctPie then begin
  canvas.save;
  xflags:= createflag(faxiscaption);
  canvas.font.color:= faxiscaption.font_color;
  if fscale<>1 then
   canvas.font.height:= round(faxiscaption.font_size * fscale)
  else
   canvas.font.height:= faxiscaption.font_size;
  canvas.font.name:= faxiscaption.font_name;
  canvas.font.style:= createstyle(faxiscaption);
  if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
  haxiscaption:= textrect(canvas,'XX',area,xflags,nil,nil).cy;
  if fyaxiscaption<>'' then begin
   fchartarea.x:= fchartarea.x+haxiscaption;
   fchartarea.cx:= fchartarea.cx-haxiscaption;
   tmprect:= makerect(fchartarea.x-yaxislabel-haxiscaption-linemajor,fchartarea.y,haxiscaption,fchartarea.cy);
   tmprect2:= textrect(canvas,fyaxiscaption,fchartarea,xflags,nil,nil);
   centerinrect(tmprect2,tmprect);
   rotaterect(tmprect2);
   canvas.drawstring(fyaxiscaption,
     makepoint(tmprect2.x+tmprect2.cx-3,tmprect2.y+tmprect2.cy),nil,false,0.5*pi);
  end;
  if fxaxiscaption<>'' then begin
   fchartarea.cy:= fchartarea.cy-haxiscaption;
   drawtext(canvas,fxaxiscaption,
     makerect(fchartarea.x,fchartarea.y+fchartarea.cy+xaxislabel,
       fchartarea.cx,haxiscaption),xflags,nil,nil);
  end;
  canvas.restore;
 end;
 //draw shadow axis
 if (fcharttype<>ctPie) and (fdepth>0) then begin
  setlength(fpoly,5);
  with fchartarea do begin
   fpoly[0].x:= x-linemajor;
   fpoly[0].y:= y+cy;
   fpoly[1].x:= x+cx+linemajor;
   fpoly[1].y:= y+cy;
   fpoly[2].x:= fpoly[1].x+fdepth;
   fpoly[2].y:= fpoly[1].y-fdepth;
   fpoly[3].x:= fpoly[0].x+fdepth;
   fpoly[3].y:= fpoly[0].y-fdepth;
   fpoly[4].x:= fpoly[0].x;
   fpoly[4].y:= fpoly[0].y;
  end;
  //canvas.save;
  canvas.fillpolygon(fpoly,fshadowcolor,cl_none);
  with fchartarea do begin
   fpoly[0].x:= x;
   fpoly[0].y:= y-linemajor;
   fpoly[1].x:= x;
   fpoly[1].y:= y+cy+linemajor;
   fpoly[2].x:= fpoly[1].x+fdepth;
   fpoly[2].y:= fpoly[1].y-fdepth;
   fpoly[3].x:= fpoly[0].x+fdepth;
   fpoly[3].y:= fpoly[0].y-fdepth;
   fpoly[4].x:= fpoly[0].x;
   fpoly[4].y:= fpoly[0].y;
  end;
  canvas.fillpolygon(fpoly,fshadowcolor,cl_none);
  //canvas.restore;
 end; 
 if fcharttype=ctBar then begin
  setlength(flines,4);
  if fxasvalue then begin
   barwidth:= 6;
  end else begin
   barwidth:= round(((fchartarea.cx-((rcount+1)*(gapmajor+((county-1)*gapminor))))/
    (rcount+1))/county);
  end;
 end else if fcharttype=ctLine then begin
  setlength(flines,rcount+1);
 end else if fcharttype=ctPie then begin
  setlength(fpies,county);
  rea1:= sqrt(county);
  if rea1-floor(rea1)>0 then begin
   if fchartarea.cx>fchartarea.cy then begin
    colpie:= floor(rea1)+1;
    if colpie<county then
     rowpie:= floor(rea1)
    else
     rowpie:= 1;
   end else begin
    rowpie:= floor(rea1)+1;
    if rowpie<county then
     colpie:= floor(rea1)
    else
     colpie:= 1;
   end;
  end else begin
   colpie:= floor(rea1);
   rowpie:= colpie;
  end;
  int1:= fchartarea.cx div colpie;
  int2:= fchartarea.cy div rowpie;
  if int1<int2 then begin
   sizepie:= int1;
   deltapiey:= int2-int1;
   deltapiex:= 0;
  end else begin
   sizepie:= int2;
   deltapiex:= int1-int2;
   deltapiey:= 0;
  end;
  startx:= (fchartarea.cx-((sizepie+deltapiex)*colpie)) div 2; //start x
  starty:= (fchartarea.cy-((sizepie+deltapiey)*rowpie)) div 2; //start y
  int1:=0;
  int2:=0;
  int4:= 0;
  while int1<county do begin
   fpies[int1].x:= fchartarea.x+startx+(int2*(sizepie+deltapiex));
   fpies[int1].y:= fchartarea.y+starty+(int4*(sizepie+deltapiey));
   if deltapiex>0 then
    fpies[int1].x:= fpies[int1].x+(deltapiex div 2);
   if deltapiey>0 then
    fpies[int1].y:= fpies[int1].y+(deltapiey div 2);
   fpies[int1].cx:= sizepie;
   fpies[int1].cy:= sizepie;
   int1:= int1+1;
   if int2+1<colpie then begin
    int2:= int2+1;
   end else begin
    int2:= 0;
    int4:= int4+1;
   end;
  end;
  int4:= 0;
  if fshowvalue and (fvaluepos=vpOutside) then begin
   for int1:=0 to fcharty.count-1 do begin
    canvas.save;
    yflags:= createflag(fcharty[int1].values);
    canvas.font.color:= fcharty[int1].values.font_color;
    if fscale<>1 then
     canvas.font.height:= round(fcharty[int1].values.font_size * fscale)
    else
     canvas.font.height:= fcharty[int1].values.font_size;
    canvas.font.name:= fcharty[int1].values.font_name;
    canvas.font.style:= createstyle(fcharty[int1].values);
    if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
    for int2:=0 to high(fcharty[int1].values.chartitems) do begin     
     if pvShowPercent in fshowpercentvalue then begin
      if pvShowPercentOnly in fshowpercentvalue then
       tmplabel:= realtytostr((double(fcharty[int1].values.chartitems[int2].value)/toty[int1])*100,'0.0%')
      else
       tmplabel:= fcharty[int1].values.chartitems[int2].text+ ' (' +
        realtytostr((double(fcharty[int1].values.chartitems[int2].value)/toty[int1])*100,'0.0%')+')';
     end else begin
      tmplabel:= fcharty[int1].values.chartitems[int2].text; 
     end;
     int3:= textrect(canvas,tmplabel,area,xflags,nil,nil).cx;
     if int3>int4 then int4:= int3;
    end;
    canvas.restore;
   end;
   for int1:=0 to high(fpies) do begin
    with fpies[int1] do begin
     x:= x+int4;
     cx:= cx-(int4*2);
     y:= y+int4;
     cy:= cy-(int4*2);
    end;
   end;
  end;
 end;
 if ydeltavalue=0 then 
  ypercent:= 1
 else
  ypercent:= fchartarea.cy/ydeltavalue;
 if fxasvalue then begin
  if xdeltavalue=0 then 
   xpercent:= 1
  else
   xpercent:= fchartarea.cx/xdeltavalue;
 end else begin
  xpercent:= 1;
 end;
 deltax:= round(fchartarea.cx/(rcount+1));
 deltay:= round(fchartarea.cy/maxytick);
 if fcharttype<>ctPie then begin
  canvas.save;
  xflags:= createflag(fxaxis);
  canvas.font.color:= fxaxis.font_color;
  if fscale<>1 then
   canvas.font.height:= round(fxaxis.font_size * fscale)
  else
   canvas.font.height:= fxaxis.font_size;
  canvas.font.name:= fxaxis.font_name;
  canvas.font.style:= createstyle(fxaxis);
  if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
 //line major and label x
  if fxasvalue then begin
   for int1:=0 to rcount do begin
    int2:= round(fchartx.chartitems[int1].value*xpercent);
    canvas.drawline(makepoint(fchartarea.x+int2,fchartarea.y+fchartarea.cy),
      makepoint(fchartarea.x+int2,fchartarea.y+fchartarea.cy+linemajor),cl_black);
    tmprect:= textrect(canvas,fchartx.chartitems[int1].text,area,xflags,nil,nil);
    tmprect.x:= fchartarea.x+int2-(tmprect.cx div 2);
    tmprect.y:= fchartarea.y+fchartarea.cy+linemajor;
    drawtext(canvas,fchartx.chartitems[int1].text,tmprect,xflags,nil,nil);
   end;  
  end else begin
   for int1:=0 to rcount do begin
    canvas.drawline(makepoint(fchartarea.x+((int1+1)*deltax),fchartarea.y+fchartarea.cy),
      makepoint(fchartarea.x+((int1+1)*deltax),fchartarea.y+fchartarea.cy+linemajor),cl_black);
    tmprect:= makerect(fchartarea.x+(int1*deltax),
      fchartarea.y+fchartarea.cy+linemajor,deltax,xaxislabel);
    drawtext(canvas,fchartx.chartitems[int1].text,tmprect,xflags,nil,nil);
   end;
  end;
  canvas.restore;
  canvas.save;
  xflags:= createflag(fyaxis);
  canvas.font.color:= fyaxis.font_color;
  if fscale<>1 then
   canvas.font.height:= round(fyaxis.font_size * fscale)
  else
   canvas.font.height:= fyaxis.font_size;
  canvas.font.name:= fyaxis.font_name;
  canvas.font.style:= createstyle(fyaxis);
  if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
  //line major y
  for int1:=1 to maxytick do begin
   canvas.drawline(makepoint(fchartarea.x-linemajor,fchartarea.y+fchartarea.cy-(int1*deltay)),
     makepoint(fchartarea.x,fchartarea.y+fchartarea.cy-(int1*deltay)),cl_black);  
  end;
  //draw label y
  for int1:=1 to maxytick do begin
   tmprect:= makerect(fchartarea.x-yaxislabel-3,
     fchartarea.y+fchartarea.cy-(int1*deltay),yaxislabel,deltay);
   drawtext(canvas,realtytostr((int1/maxytick)*ydeltavalue,fyaxis.format),tmprect,xflags,nil,nil);
  end;
  canvas.restore;
 end;
 //draw y
 for int2:=0 to fcharty.count-1 do begin
  yflags:= createflag(fcharty[int2].values);
  canvas.save;
  canvas.font.color:= fcharty[int2].values.font_color;
  if fscale<>1 then
   canvas.font.height:= round(fcharty[int2].values.font_size * fscale)
  else
   canvas.font.height:= fcharty[int2].values.font_size;
  canvas.font.name:= fcharty[int2].values.font_name;
  canvas.font.style:= createstyle(fcharty[int2].values);
  if fdepth>0 then canvas.font.shadow_color:= fshadowcolor;
  canvas.linewidthmm:= fcharty[int2].values.linewidth;
  canvas.dashes:= linestyles[fcharty[int2].values.linestyle];
  canvas.joinstyle:= fcharty[int2].values.linejoin;
  canvas.capstyle:= fcharty[int2].values.linecap;
  rea2:= 0;
  int3:= 0;
  int4:= 0;
  if (fcharttype=ctPie) and (fdepth>0) then begin
   with fpies[int2] do begin
    tmprect.x:= x+(cx div 2)+fdepth;
    tmprect.y:= y+(cy div 2)-fdepth;
    tmprect.cx:= cx;
    tmprect.cy:= cy;
   end;
   canvas.fillarcpieslice(tmprect,0,2*pi,fshadowcolor,cl_none);
  end;
  for int1:=0 to rcount do begin
   if fshowvalue then begin
    if pvShowPercent in fshowpercentvalue then begin
     if pvShowPercentOnly in fshowpercentvalue then
      tmplabel:= realtytostr((double(fcharty[int2].values.chartitems[int1].value)/toty[int2])*100,'0.0%')
     else
      tmplabel:= fcharty[int2].values.chartitems[int1].text+ ' (' +
       realtytostr((double(fcharty[int2].values.chartitems[int1].value)/toty[int2])*100,'0.0%')+')';
    end else begin
     tmplabel:= fcharty[int2].values.chartitems[int1].text; 
    end;
   end else begin
    tmplabel:='';
   end;
   if fcharttype=ctBar then begin
    barheight:= round(fcharty[int2].values.chartitems[int1].value*ypercent);
    if fxasvalue then begin
     int3:= round(fchartx.chartitems[int1].value*xpercent);
     tmprect:= makerect(fchartarea.x+int3-3,
       fchartarea.y+fchartarea.cy-barheight,
       barwidth,barheight);
    end else begin
     tmprect:= makerect(fchartarea.x+(int1*deltax)+round(gapmajor/2)+int2*(barwidth+gapminor),
       fchartarea.y+fchartarea.cy-barheight,
       barwidth,barheight);
    end;
    if fdepth>0 then begin
     canvas.fillrect(makerect(tmprect.x+fdepth,
     tmprect.y-fdepth,tmprect.cx,tmprect.cy),fshadowcolor);
    end;
    canvas.fillrect(tmprect,fcharty[int2].values.backcolor);
    if fcharty[int2].values.fillpattern <> stb_none then begin
     canvas.brush:= stockobjects.bitmaps[fcharty[int2].values.fillpattern];
     canvas.color:= fcharty[int2].values.fillcolor;
     canvas.fillrect(tmprect,cl_brushcanvas);
    end;
    flines[0].x:= tmprect.x;
    flines[0].y:= tmprect.y+tmprect.cy;
    flines[1].x:= tmprect.x;
    flines[1].y:= tmprect.y;
    flines[2].x:= tmprect.x+tmprect.cx;
    flines[2].y:= tmprect.y;
    flines[3].x:= tmprect.x+tmprect.cx;
    flines[3].y:= tmprect.y+tmprect.cy;
    canvas.drawlines(flines,false,fcharty[int2].values.linecolor);
    if fshowvalue then begin
     tmprect2:= textrect(canvas,tmplabel,area,xflags,nil,nil);
     if fvaluepos=vpInside then begin
      centerinrect(tmprect2,tmprect);
      rotaterect(tmprect2);
      if tmprect2.y<tmprect.y then begin
       tmprect2.y:= tmprect.y-tmprect2.cy;
      end else begin
       canvas.fillrect(tmprect2,cl_white);
      end;
      canvas.drawstring(tmplabel,makepoint(tmprect2.x+tmprect2.cx-3,tmprect2.y+
        tmprect2.cy),nil,false,0.5*pi);
     end else begin
      hcenterrect(tmprect2,tmprect);
      tmprect2.y:= tmprect.y-tmprect2.cy;
      drawtext(canvas,tmplabel,tmprect2,xflags,nil,nil);
     end;
    end;
   end else if fcharttype=ctLine then begin    
    if fxasvalue then begin
     flines[int1].x:= fchartarea.x+round(fchartx.chartitems[int1].value*xpercent);
     flines[int1].y:= fchartarea.y+fchartarea.cy-round(fcharty[int2].values.chartitems[int1].value*ypercent);
    end else begin
     flines[int1].x:= fchartarea.x+deltax*(int1+1);
     flines[int1].y:= fchartarea.y+fchartarea.cy-round(fcharty[int2].values.chartitems[int1].value*ypercent);
    end;
    if fshowvalue then begin
     tmprect2:= textrect(canvas,tmplabel,area,xflags,nil,nil);
     tmprect2.x:= flines[int1].x-(tmprect2.cx div 2);
     tmprect2.y:= flines[int1].y-tmprect2.cy;
     drawtext(canvas,tmplabel,tmprect2,xflags,nil,nil);
    end;
   end else if fcharttype=ctPie then begin
    with fpies[int2] do begin
     tmprect.x:= x+(cx div 2);
     tmprect.y:= y+(cy div 2);
     tmprect.cx:= cx;
     tmprect.cy:= cy;
    end;
    rea1:= (fcharty[int2].values.chartitems[int1].value/toty[int2])*2*pi;
    if fcharty[int2].values.fillpattern <> stb_none then begin
     canvas.fillarcpieslice(tmprect,rea2,rea1,cl_white,cl_none);
     canvas.brush:= getpattern(int4);
     canvas.color:= getchartcolor(int3);
     canvas.fillarcpieslice(tmprect,rea2,rea1,cl_brushcanvas,fcharty[int2].values.linecolor);
    end else begin
     canvas.fillarcpieslice(tmprect,rea2,rea1,getchartcolor(int3),fcharty[int2].values.linecolor);
    end;
    if int3+1<21 then
     inc(int3)
    else
     int3:=0;
    if int4+1<14 then
     inc(int4)
    else
     int4:=0;
    if fshowvalue then begin
     tmprect2:= textrect(canvas,tmplabel,area,xflags,nil,nil);
     getposfromcircle(tmprect.pos,rea2+(rea1/2),tmprect.cx,fvaluepos,tmprect2);
     if fvaluepos=vpInside then begin
      canvas.fillrect(tmprect2,cl_white);
     end;
     drawtext(canvas,tmplabel,tmprect2,xflags,nil,nil);
    end;
    rea2:= rea2+rea1;
   end;
  end;
  if fcharttype=ctLine then begin
   if fxasvalue then begin
    for int3:= 0 to high(flines)-1 do begin
     for int4:= int3+1 to high(flines) do begin
      if flines[int4].x<flines[int3].x then begin
       point1.x:= flines[int3].x;
       point1.y:= flines[int3].y;
       flines[int3].x:= flines[int4].x;
       flines[int3].y:= flines[int4].y;
       flines[int4].x:= point1.x;
       flines[int4].y:= point1.y;
      end;
     end;
    end;
    canvas.drawlines(flines,false,fcharty[int2].values.linecolor);
   end else begin
    canvas.drawlines(flines,false,fcharty[int2].values.linecolor);
   end;
  end;
  if (fcharttype=ctPie) then begin
   with fpies[int2] do begin
    tmprect.x:= x+(cx div 2);
    tmprect.y:= y+(cy div 2);
    tmprect.cx:= cx;
    tmprect.cy:= cy;
   end;
   canvas.linewidthmm:= fcharty[int2].values.linewidth+1;
   canvas.drawarc(tmprect,0,2*pi,fcharty[int2].values.linecolor);
  end;
  canvas.restore;
  //draw axis
  if fcharttype<>ctPie then begin
   canvas.save;
   canvas.linewidthmm:=1;
   canvas.drawline(makepoint(fchartarea.x-linemajor,fchartarea.y+fchartarea.cy),
    makepoint(fchartarea.x+fchartarea.cx+linemajor,fchartarea.y+fchartarea.cy),cl_black);
   canvas.drawline(makepoint(fchartarea.x,fchartarea.y-linemajor),
    makepoint(fchartarea.x,fchartarea.y+fchartarea.cy+linemajor),cl_black);
   canvas.restore;
  end;
 end;
end;

{ TradbCustomChart }

constructor TradbCustomChart.create(const aowner: tcomponent);
begin
 inherited;
 fdbchartx:= TdbChartItemsX.create(self);
 fdbcharty:= TdbChartYCol.create(self);
 fcharttype:= ctBar;
end;

destructor TradbCustomChart.destroy;
begin
 inherited;
 fdbchartx.destroy;
 fdbcharty.destroy;
end;

procedure TradbCustomChart.setchartdatasource(const avalue: tdatasource);
var
 int1: integer;
begin
 if avalue<>fchartdatasource then begin
  fchartdatasource:= avalue;
  for int1:=0 to fdbcharty.count-1 do begin
   fdbcharty[int1].values.fdatalink.datasource:= avalue;
  end;
  fdbchartx.fdatalink.datasource:= avalue;
 end;
end;

procedure TradbCustomChart.setxasvalue(const avalue: boolean);
begin
 if fxasvalue<>avalue then begin
  if avalue and fdbchartx.fdatalink.active then begin
   if not (fdbchartx.fdatalink.field.datatype in [ftsmallint,ftinteger,ftword,ftlargeint,
    ftbcd,ftfloat,ftcurrency]) then begin
    showmessage(uc(ord(rcsFieldmustnumber)));
   end;
  end else begin
    fxasvalue:= avalue;
  end;
 end;
end;

function TradbCustomChart.getchartdatasource: tdatasource;
begin
 result:= fchartdatasource;
end;

procedure TradbCustomChart.rebuildchart;

 procedure clearchartdata;
 var
  int1: integer;
 begin
  fchartx.clearitems;
  for int1:=0 to fcharty.count-1 do begin
   fcharty[int1].values.clearitems;
  end;
 end;
 
var
 rcount,int1,int2: integer;
 curvalue: variant;
 bo1: boolean;
begin
 if fchartdatasource=nil then begin
  clearchartdata;
  exit;
 end else begin
  if fdbchartx.fdatalink.fieldname='' then begin
   clearchartdata;
   exit;
  end;
  for int1:=0 to fcharty.count-1 do begin
   if fdbcharty[int1].values.fdatalink.fieldname='' then begin
    clearchartdata;
    exit;
   end;
  end;
 end;
 if fchartdatasource.dataset.active then begin
  rcount:= fchartdatasource.dataset.recordcount;
  bo1:= true;
  if (rcount=length(fchartx.chartitems)) then begin
   bo1:= false;
  end;
  for int1:=0 to fcharty.count-1 do begin
   if rcount=length(fcharty[int1].values.chartitems) then begin
    bo1:= false;
   end;
  end;
  if bo1 then begin
   clearchartdata;
   fchartx.assign(fdbchartx);
   fchartx.setitemcount(rcount);
   fcharty.count:= fdbcharty.count;
   for int1:=0 to fcharty.count-1 do begin
    fcharty[int1].values.assign(fdbcharty[int1].values);
    fcharty[int1].values.setitemcount(rcount);
   end;
   with fchartdatasource.dataset do begin
    first;
    int2:= 0;
    while not eof do begin
     if fdbchartx.fdatalink.active then begin
      curvalue:= fdbchartx.fdatalink.asvariant;
      if curvalue=null then
       curvalue:= 0;
      fchartx.chartitems[int2].value:= curvalue;
     end;
     for int1:=0 to fcharty.count-1 do begin
      if fdbcharty[int1].values.fdatalink.active then begin
       curvalue:= fdbcharty[int1].values.fdatalink.asvariant;
       if curvalue=null then
        curvalue:= 0;
       fcharty[int1].values.chartitems[int2].value:= curvalue;
      end;
     end;
     inc(int2);
     next;
    end;
   end;
  end else begin
   fchartx.assign(fdbchartx);
   for int1:=0 to fcharty.count-1 do begin
    fcharty[int1].values.assign(fdbcharty[int1].values);
   end;
  end;
 end;
end;

{ TRepazChart }

constructor TRepazChart.create(aowner: tcomponent);
begin
 inherited;
 optionswidget:= defaultoptionswidgetmousewheel;
 fchart:= TraCustomChartWidget.create(self);
end;

destructor TRepazChart.destroy;
begin
 inherited;
 fchart.free;
end;

class function TRepazChart.classskininfo: skininfoty;
begin
 result:= inherited classskininfo;
 result.objectkind:= sok_groupbox;
end;

procedure TRepazChart.dopaint(const canvas: tcanvas);
begin
 inherited;
 fchart.rebuildchart;
 fchart.paintchart(canvas,innerclientrect);
end;

procedure TRepazChart.clientmouseevent(var info: mouseeventinfoty);
var
 int1: integer;
begin
 inherited;
 if csdesigning in componentstate then exit;
 if isdblclick(info) then begin
  int1:= ord(fchart.charttype);
  if int1+1<=maxcharttype then inc(int1) else int1:=0;
  fchart.charttype:= chartty(int1);
  invalidate;
 end;
end;

end.
