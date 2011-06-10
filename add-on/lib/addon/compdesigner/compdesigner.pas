{ MSEgui Copyright (c) 2007-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
{*********************************************************}
{                     CompDesigner                        }
{                                                         }
{            Originally file is taken from MSEide         }
{                and modified to tmsecomponent            }
{                   by : Sri Wahono '2008                 }
{             Included package with Repaz                 }
{*********************************************************}
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{              http://www.msegui.org/repaz                }
{                                                         }
{*********************************************************}

unit compdesigner;
{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 classes,msegui,mseevent,msegraphutils,msegraphics,mseclasses,msemenus,typinfo,
 msestrings,msewidgets,mseglob,compdesignintf,msetoolbar,mseact,msegrids,msewidgetgrid,
 msedataedits,mselistbrowser,msedatanodes,mselist,msetypes,mseguiglob,
 mseedit,mseforms,msedatalist,msedropdownlist,mseeditglob,msedrag,mseobjecttext;

type
 areaty = (ar_none,ar_component,ar_componentmove,ar_selectrect,ht_topleft,
             ht_top,ht_topright,ht_right,
             ht_bottomright,ht_bottom,ht_bottomleft,ht_left);
 markerty = (mt_topleft,mt_topright,mt_bottomright,mt_bottomleft);

const
 bmpfiledialogstatname = 'bmpfile.sta';
 firsthandle = ht_topleft;
 lasthandle = ht_left;
 defaultgridsizex = 8;
 defaultgridsizey = 8;
 handlesize = 5;
 componentsize = 24;
 complabelleftmargin = 2;
 complabelrightmargin = 2 + handlesize div 2;
 movethreshold = 3;

type

 objinfoarty = array of objinfoty;
 
 designselectedinfoty = record
  selectedinfo: selectedinfoty;
  rect: rectty;
  nohandles: boolean;
  handles: array[firsthandle..lasthandle] of rectty;
  markers: array[markerty] of rectty;
 end;

 pdesignselectedinfoty = ^designselectedinfoty;

 tcomponentdesigner = class;

 tradesignselections = class(tdesignerselections)
  private
   fowner: tcomponentdesigner;
   finfovalid: boolean;
   fmovingchecked: boolean;
   fcandelete: boolean;
   procedure paint(const canvas: tcanvas);
   procedure beforepaintmoving;
   procedure paintmoving(const canvas: tcanvas; const pos: pointty);
   function move(const dist: pointty): boolean;
                  //false if nothing is moved
   procedure resize(const dist: pointty);
   procedure deletenames(acomp: tcomponent);
   procedure deletecomponents;
   function getareainfo(const pos: pointty; out index: integer): areaty;
   function getcandelete: boolean;
   procedure updateinfos;
  protected
   function getrecordsize: integer; override;
   procedure externalcomponentchanged(const acomponent: tobject);
   procedure removeforeign; //removes form and components in other modules
   property candelete: boolean read getcandelete;
  public
   constructor create(owner: tcomponentdesigner);
   function remove(const ainstance: tcomponent): integer; override;
   procedure change; override;
   procedure dochanged; override;
   procedure componentschanged;
   function itempo(const index: integer): pdesignselectedinfoty;
 end;
 
 selectmodety = (sm_select,sm_add,sm_flip,sm_remove);
 
 tobjectinspector = class;
 tcomponentdesigner = class(twidget)
  private
   fpickpos: pointty;
   fmousepos: pointty;
   fpickwidget: twidget;
   fsizerect,factsizerect: rectty;
   fxorpicoffset: pointty;
   fxorpicactive: boolean;
   fxorpicshowed: boolean;
   factarea: areaty;
   factcompindex: integer;
   fselecting: integer;
   fselections: tradesignselections;
   fgridsizex: integer;
   fgridsizey: integer;
   fsnaptogrid: boolean;
   fshowgrid: boolean;
   fdelobjs: objinfoarty;
   fclipinitcomps: boolean;
   finitcompsoffset: pointty;
   fuseinitcompsoffset: boolean;
   fcompsoffsetused: boolean;
   fselectwidget: twidget;
   fmoveonfirstclick: boolean;
   fonresize,fonchange: notifyeventty;
   fonmouseevent: mouseeventty;
   fcomponents: tcomponents;
   frootcomp: tcomponent;
   fpopupmenu: tpopupmenu;
   fcopyproperty: tpersistent;
   fmodified: boolean;

   procedure setpopupmenu(const Value: tpopupmenu);
   procedure drawgrid(const canvas: tcanvas);
   procedure hidexorpic(const canvas: tcanvas);
   procedure showxorpic(const canvas: tcanvas);
   procedure paintxorpic(const canvas: tcanvas);
   procedure checkdelobjs(const aitem: tcomponent);

   procedure doaddcomponent(component: tcomponent);
   procedure placecomponent(const component: tcomponent;
                        const apos: pointty; aparent: tcomponent = nil);
   procedure addchildsname(acomp: tcomponent; isopen: boolean);
   procedure doinitcomponent(component: tcomponent; parent: tcomponent; isopen: boolean);
   function createcurrentcomponent(const componentclass: tcomponentclass): tcomponent;

   procedure setshowgrid(const avalue: boolean);
   procedure setgridsizex(const avalue: integer);
   procedure setgridsizey(const avalue: integer);
   procedure adjustchildcomponentpos(var apos: pointty);
   procedure readjustchildcomponentpos(var apos: pointty);
   procedure findcomponentclass(Reader: TReader; const aClassName: string;
                   var ComponentClass: TComponentClass);
   procedure createcomponent(Reader: TReader; ComponentClass: TComponentClass;
                   var Component: TComponent);
   procedure readstringproperty(Sender:TObject; const Instance: TPersistent;
    PropInfo: PPropInfo; var Content:string);
   procedure onreferencename(Reader: TReader; var aName: string);
   function pastefromobjecttext(const aobjecttext: string; 
         aowner,aparent: tcomponent): integer;
   function pastefromclipboard(aowner,aparent: tcomponent): integer;
   function getobjecttext: string;
   procedure copytoclipboard;
  protected
   function getcomponentnamelist(const acomponentclass: tcomponentclass;
                            const includeinherited: boolean): msestringarty;
   function getcomponentlist(const acomponentclass: tcomponentclass): componentarty;
   function compplacementrect: rectty;
   function getcomponentrect(const component: tcomponent): rectty;
   function componentatpos(const apos: pointty): tcomponent;
   function getcomponentname(aclassname: string) : string;
   procedure childmouseevent(const sender: twidget;
                              var info: mouseeventinfoty); override;
   procedure dokeyup(var info: keyeventinfoty); override;
   procedure dobeforepaint(const canvas: tcanvas);override;
   procedure doafterpaint(const canvas: tcanvas);override;
   function dosnaptogrid(const apos: pointty): pointty;
   function snaptogriddelta(const apos: pointty): pointty;
   procedure clearselection;
   procedure setrootpos(const component: tcomponent; const apos: pointty);
   procedure beginselect;
   procedure endselect;
   procedure deletecomponent(const component: tcomponent);
   procedure selectcomponent(const component: tcomponent; mode: selectmodety = sm_select);
   function getcomponentarty: componentarty;
   procedure sizechanged; override;
   procedure poschanged; override;
   procedure mouseevent(var info: mouseeventinfoty); override;
  public
   fobjectinspector: tobjectinspector;
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure doundelete;
   procedure dodelete;
   procedure dopaste(const usemousepos: boolean);
   procedure docopy(const noclear: boolean);
   procedure dobringfront;
   procedure dosendback;
   procedure docut;
   procedure savetofile(afilename: filenamety);
   procedure loadfromfile(afilename: filenamety);
   function componentlist: stringarty;
   function selectioncount: integer;
   procedure componentmodified(const acomponent: tobject);
   property modified: boolean read fmodified;
   procedure clearcomponents;
  published
   property popupmenu: tpopupmenu read fpopupmenu write setpopupmenu;
   property snaptogrid: boolean read fsnaptogrid write fsnaptogrid default true;
   property moveonfirstclick: boolean read fmoveonfirstclick write fmoveonfirstclick default true;
   property showgrid: boolean read fshowgrid write setshowgrid default true;
   property gridsizex: integer read fgridsizex write setgridsizex 
                                     default defaultgridsizex;
   property gridsizey: integer read fgridsizey write setgridsizey
                                     default defaultgridsizey;
   property onresize: notifyeventty read fonresize write fonresize;
   property onchange: notifyeventty read fonchange write fonchange;
   property onmouseevent: mouseeventty read fonmouseevent write fonmouseevent;
   property anchors;
   property bounds_x;
   property bounds_y;
   property bounds_cx;
   property bounds_cy;
   property visible;
   property enabled;
   property frame;
   property face;
   property optionswidget default defaultoptionswidgetmousewheel;
   property left;
   property top;
   property width;
   property height;
   property color;
   property optionsskin;
 end;

 tcomponentpallete = class(tcustomtoolbar)
  protected
   procedure loaded; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure updatebuttons;
   procedure componentpalettebuttonchanged(const sender: TObject;
   const button: ttoolbutton);
  published
   property firstbutton;
   property options;
   property statfile;
   property statvarname;
   property onbuttonchanged;
   property drag;   
 end;

//object inspector

 tcomponenteditor = class(tnullinterfacedobject,icomponentdesigner)
  protected
   fcomponent: tcomponent;
   fstate: componenteditorstatesty;
   fdesigner: tcomponentdesigner;
  public
   constructor create(const adesigner: tcomponentdesigner; acomponent: tcomponent); virtual;
   function state: componenteditorstatesty;
   procedure edit; virtual;
 end;

 componenteditorclassty = class of tcomponenteditor;

 timagelistedit = class(tcomponenteditor)
  public
   constructor create(const adesigner: tcomponentdesigner; acomponent: tcomponent); override;
   procedure edit; override;
 end;

 componenteditorinfoty = record
  componentclass: componentclassty;
  componenteditorclass: componenteditorclassty;
 end;
 pcomponenteditorinfoty = ^componenteditorinfoty;

 tcomponenteditors = class(trecordlist)
  protected
   procedure add(componentclass: componentclassty; componenteditorclass: componenteditorclassty);
  public
   constructor create;
   function geteditorclass(const component: componentclassty): componenteditorclassty;
 end;

 tpropertyitem = class;

 tpropeditor = class;
 propeditorarty = array of tpropeditor;

 propinstancety = record
  instance: tobject;
  propinfo: ppropinfo;
 end;
 propinstancearty = array of propinstancety;
 ppropinstancearty = ^propinstancearty;

 iobjectinspector = interface(inullinterface)
  procedure propertymodified(const sender: tpropeditor);
  function getproperties(const objects: objectarty;
                          const acomponent: tcomponent): propeditorarty;
 end;

 propertystatety = (ps_expanded,ps_subproperties,ps_volatile,
                   ps_refresh, //needs refresh by modified
                   ps_valuelist,ps_dialog,ps_sortlist,ps_owned,
                   ps_noadditems,ps_nodeleteitems,
                   ps_isordprop,ps_modified,ps_candefault,ps_component,ps_subprop,
                   ps_selected,ps_canselect,ps_refreshall,
                   ps_local,  //do not display foreign components
                   ps_link);  //do not display selected components
 propertystatesty = set of propertystatety;

 iremotepropeditor = interface(inullinterface)
  function getordvalue(const index: integer = 0): integer;
  procedure setordvalue(const value: cardinal); overload;
  procedure setordvalue(const index: integer; const value: cardinal); overload;
  procedure setbitvalue(const value: boolean; const bitindex: integer);
  function getint64value(const index: integer = 0): int64;
  procedure setint64value(const value: int64); overload;
  procedure setint64value(const index: integer; const value: int64); overload;
  function getfloatvalue(const index: integer = 0): extended;
  procedure setfloatvalue(const value: extended);
  function getcurrencyvalue(const index: integer = 0): currency;
  procedure setcurrencyvalue(const value: currency);
  function getstringvalue(const index: integer = 0): string;
  procedure setstringvalue(const value: string);
  function getmsestringvalue(const index: integer = 0): msestring;
  procedure setmsestringvalue(const value: msestring);
  function getpointervalue(const index: integer = 0): pointer;
  procedure setpointervalue(const value: pointer); overload;
  procedure setpointervalue(const index: integer; const value: pointer); overload;
  function getparenteditor: tpropeditor;
  function getselected: boolean;
  procedure setselected(const avalue: boolean);
  property selected: boolean read getselected write setselected;
  function getselectedpropinstances: objectarty;
 end;

 tpropeditor = class(tnullinterfacedobject)
  private
   function getexpanded: boolean;
   procedure setexpanded(const Value: boolean);
   function getcount: integer;
   function getselected: boolean;
   procedure setselected(const avalue: boolean);
  protected
   fsortlevel: integer;
   ftypeinfo: ptypeinfo;
   fstate: propertystatesty;
   fparenteditor: tpropeditor;
   fname: msestring;
   fdesigner: tcomponentdesigner;
   fcomponent: tcomponent;
   fobjectinspector: iobjectinspector;
   fprops: propinstancearty;
   fremote: iremotepropeditor;
   procedure properror;

   function instance(const index: integer = 0): tobject;
   function typedata: ptypedata;

   function getordvalue(const index: integer = 0): integer;
   procedure setordvalue(const value: cardinal); overload;
   procedure setordvalue(const index: integer; const value: cardinal); overload;
   function getint64value(const index: integer = 0): int64;
   procedure setint64value(const value: int64); overload;
   procedure setint64value(const index: integer; const value: int64); overload;
   procedure setbitvalue(const value: boolean; const bitindex: integer);
   function getfloatvalue(const index: integer = 0): extended;
   procedure setfloatvalue(const value: extended);
   function getcurrencyvalue(const index: integer = 0): currency;
   procedure setcurrencyvalue(const value: currency);
   function getstringvalue(const index: integer = 0): string;
   procedure setstringvalue(const value: string);
   function getmsestringvalue(const index: integer = 0): msestring;
   procedure setmsestringvalue(const value: msestring);
   function getpointervalue(const index: integer = 0): pointer;
   procedure setpointervalue(const value: pointer); overload;
   procedure setpointervalue(const index: integer; const value: pointer); overload;
   
   function decodemsestring(const avalue: msestring): msestring;
   function encodemsestring(const avalue: msestring): msestring;
   function getparenteditor: tpropeditor;
   function queryselectedpropinstances: objectarty;

   procedure modified; virtual;
   function getdefaultstate: propertystatesty; virtual;
  public
   constructor create(const adesigner: tcomponentdesigner;
        const acomponent: tcomponent;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypeinfo: ptypeinfo); virtual;
   destructor destroy; override;
   procedure setremote(intf: iremotepropeditor);
   procedure updatedefaultvalue; virtual;
   function canrevert: boolean; virtual;
   procedure copyproperty(const asource: tobject); virtual;

   function propertyname: msestring; virtual;
   function name: msestring; virtual;
   function allequal: boolean; virtual;
   function subproperties: propeditorarty; virtual;
   function props: propinstancearty;
   function rootprops: propinstancearty;
   function propowner: componentarty;
             //value of classproperty

   procedure setvalue(const value: msestring); virtual;
   function getvalue: msestring; virtual;
   function getvalues: msestringarty; virtual;
   property state: propertystatesty read fstate;
   function sortlevel: integer;
   procedure dragbegin(var accept: boolean); virtual;
   procedure dragover(const sender: tpropeditor; var accept: boolean); virtual;
   procedure dragdrop(const sender: tpropeditor); virtual;
   procedure dopopup(var amenu: tpopupmenu;  const atransientfor: twidget;
                var mouseinfo: mouseeventinfoty); virtual;
   procedure edit; virtual;
   property count: integer read getcount;
   property expanded: boolean read getexpanded write setexpanded;
   property selected: boolean read getselected write setselected;
   property component: tcomponent read fcomponent;
  end;

 propeditorclassty = class of tpropeditor;

 tstringpropeditor = class(tpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function allequal: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;

 trefreshstringpropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
 end;
 
 tnamepropeditor = class(tstringpropeditor)
  procedure setvalue(const value: msestring); override;
 end;
 
 tfontnamepropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;

 tmsestringpropeditor = class(tpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   procedure edit; override;
   function allequal: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;

 tordinalpropeditor = class(tpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function allequal: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;

 tcharpropeditor = class(tordinalpropeditor)
  public
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;
 
 twidecharpropeditor = class(tordinalpropeditor)
  public
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;
 
 tbooleanpropeditor = class(tordinalpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
   function getvalues: msestringarty; override;
 end;
 
 tvolatilebooleanpropeditor = class(tbooleanpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
 end;

 trealpropeditor = class(tpropeditor)
  public
   function allequal: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;
 
 trealtypropeditor = class(tpropeditor)
  public
   function allequal: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;

 tcurrencypropeditor = class(tpropeditor)
  public
   function allequal: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;
 
 tdatetimepropeditor = class(tpropeditor)
  public
   function allequal: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
 end;

 tenumpropeditor = class(tordinalpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function gettypeinfo: ptypeinfo; virtual;
  public
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
   function getvalues: msestringarty; override;
 end;

 tcolorpropeditor = class(tenumpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   procedure edit; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
   function getvalues: msestringarty; override;
 end;

 tclasspropeditor = class(tpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function checkfreeoptionalclass: boolean;
  public
   function getvalue: msestring; override;
   function subproperties: propeditorarty; override;
 end;

 toptionalclasspropeditor = class(tclasspropeditor)
  protected
   function getniltext: string; virtual;
   function getinstance: tpersistent; virtual;
   function getdefaultstate: propertystatesty; override;
   procedure deleteinstance;
  public
   function canrevert: boolean; override;
   procedure setvalue(const avalue: msestring); override;
   function getvalue: msestring; override;
   procedure edit; override;
 end;

 ppersistent = ^tpersistent;
 tparentclasspropeditor = class(toptionalclasspropeditor)
  protected
   function getniltext: string; override;
   function getinstancepo(acomponent: tobject): ppersistent; virtual; abstract;
   function getinstance: tpersistent; override;
  public
   function subproperties: propeditorarty; override;
   procedure edit; override;
 end;

 tparentfontpropeditor = class(tparentclasspropeditor)
  protected
   function getinstancepo(acomponent: tobject): ppersistent; override;
 end;

 tcomponentpropeditor = class(tclasspropeditor)
  protected
   function issubcomponent(const index: integer = 0): boolean;
   function getdefaultstate: propertystatesty; override;
   procedure checkcomponent(const avalue: tcomponent); virtual;
   function filtercomponent(const acomponent: tcomponent): boolean; virtual;
  public
   function allequal: boolean; override;
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
   function getvalues: msestringarty; override;
 end;

 tsisterwidgetpropeditor = class(tcomponentpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;
  
 tchildwidgetpropeditor = class(tcomponentpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;
 
 tlocalcomponentpropeditor = class(tcomponentpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
 end;

 tlocallinkcomponentpropeditor = class(tcomponentpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
 end;
  
 tsetpropeditor = class;
 tsetelementeditor = class(tpropeditor)
  protected
//   fparent: tsetpropeditor;
   findex: integer;
   function getdefaultstate: propertystatesty; override;
  public
   constructor create(const adesigner: tcomponentdesigner;
        const acomponent: tcomponent;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypeinfo: ptypeinfo;
            const aparent: tsetpropeditor; const aindex: integer);
                             reintroduce; virtual;  
   procedure updatedefaultvalue; override;
   function canrevert: boolean; override;
   function allequal: boolean; override;
   function propertyname: msestring; override;
   function name: msestring; override;
   function getvalue: msestring; override;
   function getvalues: msestringarty; override;
   procedure setvalue(const value: msestring); override;
 end;

 tsetpropeditor = class(tordinalpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
   function subproperties: propeditorarty; override;
 end;

 tdialogclasspropeditor = class(tclasspropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
 end;

 tbitmappropeditor = class(tdialogclasspropeditor)
  public
   procedure edit; override;
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
 end;

 tstringspropeditor = class(tdialogclasspropeditor)
  protected
   procedure closequery(const sender: tcustommseform;
                       var amodalresult: modalresultty);
  public
   procedure edit; override;
   function getvalue: msestring; override;
 end;

 ttextstringspropeditor = class(tdialogclasspropeditor)
  protected
   fmodalresult: modalresultty;
   forigtext: msestringarty;
   procedure closequery(const sender: tcustommseform;
                       var amodalresult: modalresultty);
   procedure doafterclosequery(var amodalresult: modalresultty); virtual;                    
   function getsyntaxindex: integer; virtual;
   function gettestbutton: boolean; virtual;
   function getutf8: boolean; virtual;
   function getcaption: msestring; virtual;
   procedure updateline(var aline: ansistring); virtual;
   function ismsestring: boolean; virtual;
  public
   procedure edit; override;
   procedure setvalue(const avalue: msestring); override;
   function getvalue: msestring; override;
 end;

 listeditformkindty = (lfk_none,lfk_msestring,lfk_real,lfk_integer);
 
 tdatalistpropeditor = class(tdialogclasspropeditor)
  protected
   formkind: listeditformkindty;
   procedure closequery(const sender: tcustommseform;
                       var amodalresult: modalresultty);
   procedure checkformkind;
  public
   procedure edit; override;
   function getvalue: msestring; override;
 end;
 
 tmsestringdatalistpropeditor = class(tdialogclasspropeditor)
   procedure edit; override;
   function getvalue: msestring; override;
  protected
   procedure closequery(const sender: tcustommseform;
                       var amodalresult: modalresultty);
 end;

 tdoublemsestringdatalistpropeditor = class(tdialogclasspropeditor)
   procedure edit; override;
   function getvalue: msestring; override;
  protected
   procedure closequery(const sender: tcustommseform;
                       var amodalresult: modalresultty);
 end;

const
 propmaxarraycount = 100;

type

 tarraypropeditor = class;

 tarrayelementeditor = class(tpropeditor,iremotepropeditor)
  private
   feditor: tpropeditor;
  protected
   findex: integer;
   procedure doinsert(const sender: tobject);
   procedure doappend(const sender: tobject);
   procedure dodelete(const sender: tobject);
   procedure docopy(const sender: tobject);
   procedure dopaste(const sender: tobject);

   function getordvalue(const index: integer = 0): integer;
   procedure setordvalue(const value: cardinal); overload;
   procedure setordvalue(const index: integer; const value: cardinal); overload;
   procedure setbitvalue(const value: boolean; const bitindex: integer);
   function getfloatvalue(const index: integer = 0): extended;
   procedure setfloatvalue(const value: extended);
   function getstringvalue(const index: integer = 0): string;
   procedure setstringvalue(const value: string);
   function getmsestringvalue(const index: integer = 0): msestring;
   procedure setmsestringvalue(const value: msestring);
   function getselectedpropinstances: objectarty; virtual;

   function getdefaultstate: propertystatesty; override;
  public
   constructor create(aindex: integer; aparenteditor: tarraypropeditor;
            aeditorclass: propeditorclassty;
            const adesigner: tcomponentdesigner;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypinfo: ptypeinfo); reintroduce;
                                                         virtual;
   destructor destroy; override;
   function canrevert: boolean; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
   function getvalues: msestringarty; override;
   procedure edit; override;
   function name: msestring; override;
   function subproperties: propeditorarty; override;
   procedure dragbegin(var accept: boolean); override;
   procedure dragover(const sender: tpropeditor; var accept: boolean); override;
   procedure dragdrop(const sender: tpropeditor); override;
   procedure dopopup(var amenu: tpopupmenu; const atransientfor: twidget;
                          var mouseinfo: mouseeventinfoty); override;
 end;

 elementeditorclassty = class of tarrayelementeditor;
 elementeditorarty = array of tarrayelementeditor;
  
 tarraypropeditor = class(tclasspropeditor)
  private
   fsubprops: elementeditorarty;
   procedure doappend(const sender: tobject);
  protected
   function getdefaultstate: propertystatesty; override;
   function geteditorclass: propeditorclassty; virtual;
   function getelementeditorclass: elementeditorclassty; virtual;
   procedure itemmoved(const source,dest: integer); virtual;
  public
   procedure move(const curindex,newindex: integer); virtual;
   function allequal: boolean; override;
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
   function subproperties: propeditorarty; override;
   function name: msestring; override;
   procedure dopopup(var amenu: tpopupmenu; const atransientfor: twidget;
                          var mouseinfo: mouseeventinfoty); override;
 end;
 
  tconstelementeditor = class(tarrayelementeditor)
  protected
   fvalue: msestring;
  public
   constructor create(const avalue: msestring;
            aindex: integer; aparenteditor: tarraypropeditor;
            aeditorclass: propeditorclassty;
            const adesigner: tcomponentdesigner;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypinfo: ptypeinfo); reintroduce;
   procedure dragdrop(const sender: tpropeditor); override;
   function getvalue: msestring; override;
 end;

 tconstarraypropeditor = class(tarraypropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function allequal: boolean; override;
   function getvalue: msestring; override;
   function name: msestring; override;
   procedure setvalue(const value: msestring); override;
 end;

 tcollectionpropeditor = class;
 
 tcollectionitemeditor = class(tpropeditor,iremotepropeditor)
  private
   findex: integer;
   feditor: tpropeditor;
  protected
   function getdefaultstate: propertystatesty; override;
   function getordvalue(const index: integer = 0): integer;
   procedure setordvalue(const value: cardinal); overload;
   procedure setordvalue(const index: integer; const value: cardinal); overload;
   procedure doinsert(const sender: tobject);
   procedure doappend(const sender: tobject);
   procedure dodelete(const sender: tobject);
   function getselectedpropinstances: objectarty;
  public
   constructor create(aindex: integer; aparenteditor: tcollectionpropeditor;
            aeditorclass: propeditorclassty;
            const adesigner: tcomponentdesigner;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypinfo: ptypeinfo); reintroduce;
   destructor destroy; override;
   procedure setvalue(const value: msestring); override;
   function getvalue: msestring; override;
   function getvalues: msestringarty; override;
   procedure edit; override;
   function subproperties: propeditorarty; override;
   function name: msestring; override;
   
   procedure dragbegin(var accept: boolean); override;
   procedure dragover(const sender: tpropeditor; var accept: boolean); override;
   procedure dragdrop(const sender: tpropeditor); override;
   procedure dopopup(var amenu: tpopupmenu; const atransientfor: twidget;
                          var mouseinfo: mouseeventinfoty); override;
 end;
 
 collectionitemeditorclassty = class of tcollectionitemeditor;
  
 tcollectionpropeditor = class(tclasspropeditor)
  private
   procedure doappend(const sender: tobject);
  protected
   function getdefaultstate: propertystatesty; override;
   procedure itemmoved(const source,dest: integer); virtual;
  public
   function name: msestring; override;
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
   function subproperties: propeditorarty; override;
   procedure dopopup(var amenu: tpopupmenu; const atransientfor: twidget;
                          var mouseinfo: mouseeventinfoty); override;
 end;
 
 tpersistentarraypropeditor = class(tarraypropeditor)
  protected
   function geteditorclass: propeditorclassty; override;
 end;

 toptionalpersistentarraypropeditor = class(tpersistentarraypropeditor)
  protected
   function getniltext: string; virtual;
   function getinstance: tpersistent; virtual;
   function getdefaultstate: propertystatesty; override;
  public
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
   procedure edit; override;
 end;

 tclasselementeditor = class(tclasspropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalue: msestring; override;
 end;

 tintegerarraypropeditor = class(tarraypropeditor)
  protected
   function geteditorclass: propeditorclassty; override;
 end;

 tsetarrayelementeditor = class(tarrayelementeditor)
  public
   constructor create(aindex: integer; aparenteditor: tarraypropeditor;
            aeditorclass: propeditorclassty;
            const adesigner: tcomponentdesigner;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypinfo: ptypeinfo); override;
 end;

 tsetarraypropeditor = class(tarraypropeditor)
  protected
   function getelementeditorclass: elementeditorclassty; override;
   function geteditorclass: propeditorclassty; override;
 end;

 tcolorarraypropeditor = class(tarraypropeditor)
  protected
   function geteditorclass: propeditorclassty; override;
 end;

 tstringarraypropeditor = class(tarraypropeditor)
  protected
   function geteditorclass: propeditorclassty; override;
 end;
   
 tmsestringarraypropeditor = class(tarraypropeditor)
  protected
   function geteditorclass: propeditorclassty; override;
 end;
 
 trealarraypropeditor = class(tarraypropeditor)
  protected
   function geteditorclass: propeditorclassty; override;
 end;
 
 trecordpropeditor = class(tpropeditor)
  private
   fsubproperties: propeditorarty;
//   fname: string;
  protected
   function getdefaultstate: propertystatesty; override;
  public
   constructor create(const adesigner: tcomponentdesigner;
            const acomponent: tcomponent;
            const aobjectinspector: iobjectinspector; const aname: string;
            const subprops: propeditorarty); reintroduce;
   destructor destroy; override;
   function allequal: boolean; override;
//   function name: msestring; override;
   function subproperties: propeditorarty; override;
   function getvalue: msestring; override;
 end;

 propeditorinfoty = record
  propertytype: ptypeinfo;
  propertyownerclass: tclass;
  propertyname: string;
  editorclass: propeditorclassty;
  editorclasslevel: integer;
 end;
 ppropeditorinfoty = ^propeditorinfoty;

 tpropeditors = class(tdynamicdatalist)
  private
   function getitems(const index: integer): ppropeditorinfoty;
  protected
   procedure freedata(var data); override;
   procedure copyinstance(var data); override;
   procedure add(apropertytype: ptypeinfo;
     apropertyownerclass: tclass; const apropertyname: string;
       aeditorclass: propeditorclassty);
  public
   constructor create; override;
   function geteditorclass(apropertytype: ptypeinfo;
     apropertyownerclass: tclass; apropertyname: string): propeditorclassty;
   property items[const index: integer]: ppropeditorinfoty read getitems; default;
 end;

 tdatetimeformatdisppropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function getvalues: msestringarty; override;
 end;

 tdatetimeformateditpropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function getvalues: msestringarty; override;
 end;

 trealformatdisppropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function getvalues: msestringarty; override;
 end;

 trealformateditpropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
   function getvalues: msestringarty; override;
 end;

//property editor
 tproppathinfo = class(ttreelistedititem)
  private
   fname: msestring;
   procedure doexpand(const aitem: tpropertyitem);
  public
   constructor create(const aprop: tpropertyitem);
   procedure save(const aprops: ttreeitemeditlist);
   procedure restore(const aprops: ttreeitemeditlist);
 end;

 compinfoty = record
  instance: tcomponent;
  proppathinfo: tproppathinfo;
  actprop: msestringarty;
 end;
 pcompinfoty = ^compinfoty;

 tcomponentinfos = class(torderedrecordlist)
  protected
   procedure compare(const l,r; var result: integer);
   function getcompareproc: compareprocty; override;
   procedure finalizerecord(var item); override;
  public
   constructor create;
   function find(const ainstance: tcomponent): integer;
   function deleteitem(const ainstance: tcomponent): integer;
   function getitem(ainstance: tcomponent): pcompinfoty;
   function add(const aitem: compinfoty): integer;
 end;

 tobjectinspector = class(tcustomwidgetgrid,iobjectinspector)
  private
   props: ttreeitemedit;
   values: tmbdropdownitemedit;
   fcompdesigner: tcomponentdesigner;
   factcomp: tcomponent;
   flastcomp: tcomponent;
   factcomps: componentarty;
   fcomponentinfos: tcomponentinfos;
   fchanging: integer;
   frereadprops: boolean;
   fsinglecomp: boolean;
   fshowmethodproperty: boolean;
   procedure loaded;override;
   procedure sizechanged; override;
   procedure setdesign(const avalue: tcomponentdesigner);
   procedure propscreatenode(const sender: tcustomitemlist;
     var node: ttreelistedititem);
   procedure valuescreatenode(const sender: tcustomitemlist;
     var node: tlistedititem);
   procedure propnotification(const sender: tlistitem; var action: nodeactionty);
   function editorstoprops(const editors: propeditorarty): treelistitemarty;
   function reviseproperties(const aprops: propeditorarty): propeditorarty;
   procedure callrereadprops;
   function restoreactprop(const acomponent: tcomponent;
          acol: integer; exact: boolean = false): boolean;
   procedure readprops(const comp: componentarty); 
   procedure readprops(const comp: tcomponent); 
   function findvalueeditor(const editor: tpropeditor): integer;
   procedure updatedefaultstate(const aindex: integer);
   procedure valuesbeforedropdown(const sender: TObject);
   procedure valuesbuttonaction(const sender: tobject; 
              var action: buttonactionty; const buttonindex: Integer);
   procedure valueskeydown(const sender: twidget;
                var info: keyeventinfoty);
   procedure valuesonmouseevent(const sender: twidget; 
              var info: mouseeventinfoty);
   procedure valuessetvalue(const sender: TObject;
    var avalue: msestring; var accept: Boolean);
   procedure valueupdaterowvalue(const sender: tobject;
    const aindex: integer; const aitem: tlistitem);
   procedure propsonpopup(const sender: tobject;
                  var amenu: tpopupmenu; var mouseinfo: mouseeventinfoty);
   procedure propsoncheckrowmove(const curindex: Integer;
        const newindex: Integer; var accept: Boolean);
   procedure propupdaterowvalue(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
   procedure befdrawcell(const sender: tcol;
               const canvas: tcanvas; var cellinfo: cellinfoty;
               var processed: Boolean);
   procedure selchanged(const sender: tdatacol);
   procedure clearselectedprops(const aprop: tpropertyitem);
   procedure gridcellevent(const sender: tobject;
    var info: celleventinfoty);
   procedure gridrowsdatachanged(const sender: tcustomgrid;
    const acell: gridcoordty; const count: integer);
   procedure saveproppath;
   procedure clear;
   function candragsource(const apos: pointty; var arow: integer): boolean;
   function candragdest(const apos: pointty; var arow: integer): boolean;
   procedure gridondragbegin(const sender: tobject; const apos: pointty;
             var dragobject: tdragobject; var processed: boolean);
   procedure gridondragover(const sender: tobject; const apos: pointty;
            var dragobject: tdragobject; var accept: boolean; var processed: boolean);
   procedure gridondragdrop(const sender: tobject; const apos: pointty;
                var dragobject: tdragobject; var processed: boolean);
   procedure updateskin(const recursive: boolean = false);override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   //iobjectinspector
   function getproperties(const objects: objectarty;
                          const acomponent: tcomponent): propeditorarty;
   procedure propertymodified(const sender: tpropeditor);
   procedure updatecomponentname;
   procedure selectedcompchanged;
   procedure SelectionChanged(const ASelection: tradesignselections);
   procedure ItemDeleted(const aitem: tcomponent);
  published
   property designer: tcomponentdesigner read fcompdesigner write setdesign;
   property showmethods: boolean read fshowmethodproperty write fshowmethodproperty default true;
   property fixrows;
 end;

 tpropertyitem = class(ttreelistedititem)
  private
   function getexpanded: boolean;
   procedure setexpanded(const Value: boolean);
  protected
   feditor: tpropeditor;
   procedure updatestate;
   procedure updatesubpropertypath;
   function finditembyname(const aname: msestring): tpropertyitem;
  public
   destructor destroy; override;
   property expanded: boolean read getexpanded write setexpanded;
   function rootpath: msestring;
 end;

function textpropertyfont: tfont; 
function propeditors: tpropeditors;
procedure regpropeditor(propertytype: ptypeinfo;
  propertyownerclass: tclass; const propertyname: string;
  editorclass: propeditorclassty);
function componenteditors: tcomponenteditors;
procedure regcomponenteditor(componentclass: componentclassty;
                  componenteditorclass: componenteditorclassty);
var
 fontaliasnames: msestringarty;
 
implementation
uses
 msekeyboard,msepointer,msebits,sysutils,
 msestockobjects,msedrawtext,mseshapes,msedatamodules,
 mseactions,msestream,msesys,
 mseformatstr,msearrayprops,msebitmap,
 msefiledialog,mseimagelisteditor,msereal,msehash,
 msestringlisteditor,msedoublestringlisteditor,msereallisteditor,
 mseintegerlisteditor,
 msecolordialog,msememodialog,msetexteditor,
 msegraphicstream,msesysutils,
 mseformatbmpicoread{$ifdef FPC},mseformatjpgread,mseformatpngread,
 mseformatpnmread,mseformattgaread,mseformatxpmread{$endif},msestat,msestatfile,msefileutils;

const
 ado_rereadprops = 1;  //asyncevent codes
 ado_updatecomponentname = 2;
 selectcolor = cl_ltred;
 falsename = 'False';
 truename = 'True';

type
 tcomponent1 = class(tcomponent);
 twidget1 = class(twidget);
 twidgetcol1 = class(twidgetcol);
 tpersistentarrayprop1 = class(tpersistentarrayprop);
 twriter1= class(twriter);

 defaultenumerationty = (null);
 defaultsetty = set of defaultenumerationty;
 defaultmethodty = procedure of object;

 titemlist1 = class(tcustomitemlist);
 tpropeditor1 = class(tpropeditor);
 propertyitemarty = array of tpropertyitem;

 tpropertyvalue = class(tlistedititem)
  protected
   feditor: tpropeditor;
  public
   procedure updatestate;
 end;
 ppropertyvalue = ^tpropertyvalue;

var
 fpropeditors: tpropeditors;
 ftextpropertyfont: tfont;
 acomponenteditors: tcomponenteditors;
 
Function  GetOrdProp1(Instance: TObject; PropInfo : PPropInfo) : Longint;
begin
 result:= getordprop(instance,propinfo);
end;

function propeditors: tpropeditors;
begin
 if fpropeditors = nil then begin
  fpropeditors:= tpropeditors.create;
 end;
 result:= fpropeditors;
end;

function textpropertyfont: tfont;
begin
 if ftextpropertyfont = nil then begin
  ftextpropertyfont:= tfont.create;
 end;
 result:= ftextpropertyfont;
end;

procedure regpropeditor(propertytype: ptypeinfo;
  propertyownerclass: tclass; const propertyname: string;
  editorclass: propeditorclassty);
begin
 propeditors.add(propertytype,propertyownerclass,propertyname,editorclass);
end;

function settostrings(const value: tintegerset; const typeinfo: ptypeinfo): msestringarty;
var
 int1,int2: integer;
begin
 setlength(result,32);
 int2:= 0;
 for int1:= 0 to 31 do begin
  if cardinal(value) and bits[int1] <> 0 then begin
   result[int2]:= getenumname(typeinfo,int1);
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;

function stringstoset(const value: stringarty; const typeinfo: ptypeinfo): tintegerset;
var
 ar1: array[0..31] of boolean;
 int1,int2: integer;
 typedata: ptypedata;
 enumtype: ptypeinfo;
begin
 fillchar(ar1,sizeof(ar1),0);
 typedata:= gettypedata(typeinfo);
 enumtype:= typedata^.comptype{$ifndef FPC}^{$endif};
 for int1:= 0 to high(value) do begin
  int2:= getenumvalue(enumtype,value[int1]);
  if (int2 < 0) then begin
   raise exception.Create('Invalid set item: '''+value[int1]+'''');
  end;
  ar1[int2]:= true;
 end;
 result:= [];
 for int1:= 0 to gettypedata(enumtype)^.MaxValue do begin
  if ar1[int1] then begin
   result:= tintegerset(cardinal(result) or bits[int1]);
  end;
 end;
end;

function comparepropeditor(const l,r): integer;
begin
 result:= tpropeditor(l).sortlevel - tpropeditor(r).sortlevel;
 if result = 0 then begin
  result:= msestringicomp(tpropeditor(l).name,tpropeditor(r).name);
 end;
end;

function compcompname(const l,r): integer;
begin
 result:= ord(msestring(l)[1])-ord(msestring(r)[1]);
 if result = 0 then begin
  result:= countchars(msestring(l),msechar('.')) -
                countchars(msestring(r),msechar('.'));
  if result = 0 then begin
   result:= msestringicomp(msestring(l),msestring(r));
  end;
 end;
end;

{ tcomponentdesigner }

function tcomponentdesigner.getcomponentnamelist(const acomponentclass: tcomponentclass;
                            const includeinherited: boolean): msestringarty;
var
 int2: integer;
 comp1: tcomponent;
 acount: integer;
begin
 result:= nil;
 acount:= 0;
 for int2:= 0 to fcomponents.count - 1 do begin
  comp1:= fcomponents.next^.instance;
  if comp1.InheritsFrom(acomponentclass) then begin
     additem(result,comp1.name,acount);
  end;
 end;
 setlength(result,acount);
 sortarray(result,{$ifdef FPC}@{$endif}compcompname);
end;

function tcomponentdesigner.getcomponentlist(const acomponentclass: tcomponentclass): componentarty;
var
 int1,int2: integer;
 comp1: tcomponent;
begin
 setlength(result,fcomponents.count);
 int2:= 0;
 for int1:= 0 to high(result) do begin
  comp1:= fcomponents.next^.instance;
  if comp1.InheritsFrom(acomponentclass) then begin
   result[int2]:= comp1;
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;
  
function tcomponentdesigner.compplacementrect: rectty;
begin
 result:= clientwidgetrect;
 addpoint1(result.pos,clientpos);
end;

function tcomponentdesigner.getcomponentrect(const component: tcomponent): rectty;
begin
 result.pos:= getcomponentpos(component);
 result.cx:= componentsize + complabelleftmargin + 
                 self.getcanvas.getstringwidth(component.name) +
                  complabelrightmargin;
 result.cy:= componentsize;
end;

function tcomponentdesigner.componentatpos(const apos: pointty): tcomponent;

var
 toplevel: boolean;
                                       
 function checkcomponent(const component: tcomponent; const pos: pointty): tcomponent;
 var
  int1: integer;
  po1: pointty;
  bo1: boolean;
 begin
  result:= nil;
  bo1:= (component is twidget);
  if bo1 and not toplevel then begin
   po1:= subpoint(pos,twidget(component).pos);
  end
  else begin
   po1:= pos;
  end;
  if toplevel and bo1 and 
              not (cssubcomponent in component.componentstyle) then begin
   toplevel:= false;
   for int1:= component.componentcount - 1 downto 0 do begin
    result:= checkcomponent(component.components[int1],po1);
    if result <> nil then begin
     exit;
    end;
   end;
  end;
  if not bo1 then begin
   if pointinrect(pos,getcomponentrect(component)) then begin
    result:= component;
   end;
  end;
 end;
 
begin
 toplevel:= true;
 result:= checkcomponent(self,apos);
 if result = self then begin
  result:= nil;
 end;
end;

{ tradesignselections }

constructor tradesignselections.create(owner: tcomponentdesigner);
begin
 fowner:= owner;
 finfovalid:= false;
 inherited create;
end;

procedure tradesignselections.updateinfos;
var
 marker: markerty;
 int1: integer;
 pos1,pos2: pointty;
begin
 if not finfovalid then begin
  fcandelete:= count > 0;
  for int1:= 0 to count - 1 do begin
   with itempo(int1)^,selectedinfo do begin
    if (instance is twidget) and (fowner <> nil) then begin
     nohandles:= ws1_nodesignhandles in twidget1(instance).fwidgetstate1;
     fcandelete:= fcandelete and not (ws1_nodesigndelete in twidget1(instance).fwidgetstate1);
     if twidget1(instance).parentwidget<>fowner then begin
      rect:= twidget1(instance).widgetrect;
      pos1:= fowner.screenpos;
      pos2:= twidget1(instance).screenpos;
      rect.pos:= subpoint(twidget1(instance).screenpos,fowner.screenpos);
     end else begin
      rect:= twidget1(instance).widgetrect;
     end;
    end
    else begin
     nohandles:= false;
     if instance is tcomponent then begin
      rect:= fowner.getcomponentrect(tcomponent(instance));
     end
     else begin
      rect:= nullrect;
     end;
    end;
    with rect do begin
     centerrect(pos,handlesize,handles[ht_topleft]);
     centerrect(makepoint(x+cx div 2,y),handlesize,handles[ht_top]);
     centerrect(makepoint(x+cx-1,y),handlesize,handles[ht_topright]);
     centerrect(makepoint(x+cx-1,y+cy div 2),handlesize,handles[ht_right]);
     centerrect(makepoint(x+cx-1,y+cy-1),handlesize,handles[ht_bottomright]);
     centerrect(makepoint(x+cx div 2,y+cy-1),handlesize,handles[ht_bottom]);
     centerrect(makepoint(x,y+cy-1),handlesize,handles[ht_bottomleft]);
     centerrect(makepoint(x,y+cy div 2),handlesize,handles[ht_left]);

     for marker:= low(marker) to high(marker) do begin
      markers[marker].cx:= handlesize;
      markers[marker].cy:= handlesize;
     end;
     markers[mt_topleft].pos:= pos;
     markers[mt_topright].x:= x + cx - handlesize;
     markers[mt_topright].y:= y;
     markers[mt_bottomright].x:= x + cx - handlesize;
     markers[mt_bottomright].y:= y + cy - handlesize;
     markers[mt_bottomleft].x:= x;
     markers[mt_bottomleft].y:= y + cy - handlesize;
    end;
   end;
  end;
 end;
 finfovalid:= true;
end;

procedure tradesignselections.beforepaintmoving;
begin
 if not fmovingchecked then begin
  removeforeign;
  fmovingchecked:= true;
 end;
 updateinfos;
end;

procedure tradesignselections.paintmoving(const canvas: tcanvas;
                 const pos: pointty);
var
 int1: integer;
 po1: pdesignselectedinfoty;
begin
 beforepaintmoving;
 with canvas do begin
  save;
  move(pos);
  rasterop:= rop_xor;
  for int1:= 0 to count-1 do begin
   po1:= itempo(int1);
   drawframe(itempo(int1)^.rect,-2,cl_white);
  end;
  restore;
 end;
end;

procedure tradesignselections.paint(const canvas: tcanvas);
var
 int1: integer;
 handle: areaty;
 marker: markerty;
begin
 updateinfos;
 with canvas do begin
  if count > 1 then begin
   for int1:= 0 to count - 1 do begin
    with itempo(int1)^,selectedinfo do begin
     if not nohandles then begin
      for marker:= low(markerty) to high(markerty) do begin
       fillrect(markers[marker],cl_dkgray);
      end;
     end;
    end;
   end;
  end
  else begin
   for int1:= 0 to count - 1 do begin
    with itempo(int1)^,selectedinfo do begin
     if not nohandles then begin
      for handle:= firsthandle to lasthandle do begin
       fillrect(handles[handle],cl_black);
      end;
     end;
    end;
   end;
  end;
 end;
end;

function tradesignselections.move(const dist: pointty): boolean;
var
 int1: integer;
 widget1: twidget;
 comp1: tcomponent;
 rect1,rect2: rectty;
 pt1: pointty;
begin
 result:= false;
 if (dist.x <> 0) or (dist.y <> 0) then begin
  for int1:= 0 to count - 1 do begin
   with itempo(int1)^,selectedinfo do begin
    if (fowner <> nil) and (instance is twidget) then begin
     if not nohandles then begin
      widget1:= twidget(instance).parentwidget;
      while widget1 <> nil do begin
       if (widget1 <> fowner) and (indexof(widget1) >= 0) then begin
        break;  //moved by parent
       end;
       widget1:= widget1.parentwidget;
      end;
      if widget1 = nil then begin
       with twidget(instance) do begin
        pos:= addpoint(pos,dist);
        result:= true;
       end;
      end;
     end;
    end
    else begin
     comp1:= tcomponent(instance).owner;
     while comp1 <> nil do begin
      if (comp1 is twidget) and (indexof(comp1) >= 0) then begin 
       break; //moved by owner
      end;
      comp1:= comp1.owner;
     end;
     if comp1 = nil then begin
      rect1:= fowner.getcomponentrect(tcomponent(instance)); //dirubah
      fowner.invalidaterect(rect1);
      pt1:= rect1.pos;
      addpoint1(rect1.pos,dist);
      rect2:= fowner.compplacementrect;
      shiftinrect(rect1,rect2);
      setcomponentpos(tcomponent(instance),
                addpoint(getcomponentpos(tcomponent(instance)),
                subpoint(rect1.pos,pt1)));
      fowner.invalidaterect(rect1);
      result:= true;
     end;
    end;
   end;
  end;
  componentschanged;
 end;
end;

procedure tradesignselections.resize(const dist: pointty);
var
 int1: integer;
begin
 if (dist.x <> 0) or (dist.y <> 0) then begin
  for int1:= 0 to count - 1 do begin
   with itempo(int1)^,selectedinfo do begin
    if instance is twidget then begin
     with twidget(instance) do begin
      if not nohandles then begin
       size:= sizety(addpoint(pointty(size),dist));
      end;
     end;
    end;
   end;
  end;
  componentschanged;
 end;
end;

procedure tradesignselections.change;
begin
 finfovalid:= false;
 fmovingchecked:= false;
 inherited;
end;

procedure tradesignselections.dochanged;
begin
 inherited;
 fowner.invalidate;
end;

procedure tradesignselections.componentschanged;
begin
 change;
end;

procedure tradesignselections.externalcomponentchanged(const acomponent: tobject);
begin
 finfovalid:= false;
 if count > 0 then begin
  fowner.invalidate;
 end;
end;

function tradesignselections.getareainfo(const pos: pointty;
                out index: integer): areaty;
var
 handle: areaty;
 int1: integer;
begin
 updateinfos;
 result:= ar_none;
 index:= -1;
 if count = 1 then begin
  with itempo(0)^,selectedinfo do begin
   if not nohandles then begin
    if instance is tcomponent then begin
     if instance is twidget then begin
      for handle:= firsthandle to lasthandle do begin
       if pointinrect(pos,handles[handle]) then begin
        result:= handle;
        index:= 0;
        exit;
       end;
      end;
     end;
     if pointinrect(pos,rect) then begin
      result:= ar_component;
      index:= 0;
      exit;
     end;
    end;
   end;
  end;
 end
 else begin
  for int1:= 0 to count - 1 do begin
   with itempo(int1)^,selectedinfo do begin
    if not nohandles then begin
     if pointinrect(pos,rect) and (instance is tcomponent) then begin
      result:= ar_component;
      index:= int1;
      break;
     end;
    end;
   end;
  end;
 end;
end;

procedure tradesignselections.deletenames(acomp: tcomponent);
var
 int1: integer;
begin
 fowner.fcomponents.delete(cardinal(acomp));
 if acomp.componentcount>0 then begin
  for int1:=0 to acomp.componentcount-1 do begin
   deletenames(acomp.components[int1]);
  end;
 end;
end;

procedure tradesignselections.deletecomponents;
var
 int1,int2,int3: integer;
 comp1: tcomponent;
begin
 int2:= count;
 beginupdate;
 for int1:= count-1 downto 0 do begin
  comp1:= items[int1];
  if comp1<>nil then begin
   deletenames(comp1);
   freeandnil(comp1);
  end;
  delete(int1);
 end;
 endupdate;
end;

function tradesignselections.getrecordsize: integer;
begin
 result:= sizeof(designselectedinfoty);
end;

function tradesignselections.itempo(
  const index: integer): pdesignselectedinfoty;
begin
 result:= pdesignselectedinfoty(getitempo(index));
end;

function tradesignselections.remove(
  const ainstance: tcomponent): integer;
begin
 if ainstance = fowner.fpickwidget then begin
  fowner.fpickwidget:= nil;
 end;
 result:= inherited remove(ainstance);
end;

procedure tradesignselections.removeforeign; 
    //removes form and components in other modules
var
 int1: integer;
 co1: tcomponent;
begin
 beginupdate;
 for int1:= count - 1 downto 0 do begin
  co1:= items[int1];
 end;
 endupdate;
end;

function tradesignselections.getcandelete: boolean;
begin
 updateinfos;
 result:= fcandelete;
end;

{ tcomponentdesigner }

constructor tcomponentdesigner.create(aowner: tcomponent);
begin
 inherited;
 createframe;
 frame.colorclient:=cl_white;
 frame.framewidth:=0;
 frame.colorframe:=cl_black;
 optionswidget:= defaultoptionswidgetmousewheel;
 fshowgrid:= true;
 fsnaptogrid:= true;
 fmoveonfirstclick:=true;
 fgridsizex:= defaultgridsizex;
 fgridsizey:= defaultgridsizey;
 fselections:= tradesignselections.create(self);
 fcomponents:= tcomponents.create;
 frootcomp:= tcomponent.create(nil);
 fmodified:= false;
end;

destructor tcomponentdesigner.destroy;
begin
 inherited;
 fselections.free;
 fcomponents.free;
 freeandnil(frootcomp);
end;

function tcomponentdesigner.getcomponentarty: componentarty;
var
 int1 : integer;
begin
 setlength(result,fselections.count);
 for int1:=0 to fselections.count-1 do begin
  result[int1]:= fselections[int1];
 end;
end;

procedure tcomponentdesigner.poschanged;
begin
 inherited;
end;

procedure tcomponentdesigner.sizechanged;
begin
 inherited;
 if canevent(tmethod(fonresize)) then begin
  fonresize(self);
 end;
end;

procedure tcomponentdesigner.mouseevent(var info: mouseeventinfoty);
begin
 if canevent(tmethod(fonmouseevent)) then begin
  fonmouseevent(self,info);
 end;
 inherited;
end;

procedure tcomponentdesigner.paintxorpic(const canvas: tcanvas);
begin
 if fxorpicactive then begin
  canvas.save;
  canvas.intersectcliprect(paintrect);
  case factarea of
   firsthandle..lasthandle: begin
    with canvas do begin
     save;
     rasterop:= rop_xor;
     drawframe(factsizerect,-2,cl_white);
     restore;
    end;
   end;
   ar_componentmove: begin
    fselections.paintmoving(canvas,fxorpicoffset);
   end;
   ar_selectrect: begin
    with canvas do begin
     drawxorframe(fpickpos,fxorpicoffset,1,stockobjects.bitmaps[stb_block3]);
    end;
   end;
  end;
  canvas.restore;
 end;
end;

procedure tcomponentdesigner.hidexorpic(const canvas: tcanvas);
begin
 if fxorpicshowed then begin
  paintxorpic(canvas);
  fxorpicshowed:= false;
 end;
end;

procedure tcomponentdesigner.showxorpic(const canvas: tcanvas);
begin
 if not fxorpicshowed then begin
  paintxorpic(canvas);
  fxorpicshowed:= true;
 end;
end;

procedure tcomponentdesigner.dobeforepaint(const canvas: tcanvas);
begin
 hidexorpic(canvas);
 inherited;
end;

procedure tcomponentdesigner.adjustchildcomponentpos(var apos: pointty);
begin
 subpoint1(apos,clientpos);
 addpoint1(apos,clientpos);
end;

procedure tcomponentdesigner.readjustchildcomponentpos(var apos: pointty);
begin
 addpoint1(apos,clientpos);
 subpoint1(apos,clientpos);
end;

procedure tcomponentdesigner.doafterpaint(const canvas: tcanvas);

 procedure drawcomponent(const component: tcomponent);
 var
  rect1: rectty;
  int1: integer;
  pt1: pointty;
 begin
  if (not (component is twidget)) and 
           not (cssubcomponent in component.componentstyle) then begin
   rect1:= getcomponentrect(component);
   rect1.cx:= rect1.cx - complabelrightmargin;
   drawtext(canvas,component.name,rect1,[tf_ycentered,tf_right],
                      stockobjects.fonts[stf_default]);
   rect1.cx:= rect1.cy;
   registeredcomponents.drawcomponenticon(component,canvas,rect1);
  end;
  if (component is twidget) and 
                      not (cssubcomponent in component.componentstyle) then begin
   pt1:= twidget(component).pos;
    adjustchildcomponentpos(pt1);
   canvas.move(pt1);
   for int1:= 0 to componentcount - 1 do begin
    drawcomponent(components[int1]);        //components of submodule
   end;
   canvas.remove(pt1);
  end;
 end;
 
var
 int1: integer;
 rect1: rectty;
begin
 inherited;
 canvas.intersectcliprect(paintrect);
 for int1:= 0 to self.componentcount - 1 do begin
  drawcomponent(components[int1]);
 end;
 drawgrid(canvas);
 fselections.paint(canvas);
 showxorpic(canvas);
end;

procedure tcomponentdesigner.doaddcomponent(component: tcomponent);
var
 comp1: tcomponent;
begin
 comp1:= component.owner;
 if (comp1 <> nil) then begin
  comp1.removecomponent(component);
 end;
 if component.ComponentState * [csancestor,csinline] <> [] then begin
  tcomponent1(component).getchildren({$ifdef FPC}@{$endif}doaddcomponent,component);
  if comp1 <> nil then begin
   tcomponent1(component).getchildren({$ifdef FPC}@{$endif}doaddcomponent,comp1);
  end;
 end
 else begin
  tcomponent1(component).getchildren({$ifdef FPC}@{$endif}doaddcomponent,comp1);
 end;
end;

procedure tcomponentdesigner.placecomponent(const component: tcomponent;
                        const apos: pointty; aparent: tcomponent = nil);
var
 po1: pointty;
 rea1: real;
 str1,str2: string;
 int1,int2: integer;
 ar1: componentarty;
 bo1: boolean;
 comp1: tcomponent;
begin
  try
   rea1:= 1.0;
   if component is tmsecomponent then begin
    tmsecomponent(component).initnewcomponent(1.0);
   end;
   if (component is twidget) then begin
    if aparent <> nil then begin
     po1:= subpoint(dosnaptogrid(apos),clientpos);
     if aparent=self then begin
      twidget(aparent).insertwidget(twidget(component),
       translatewidgetpoint(po1,self,twidget(aparent)));
     end else begin
      twidget(aparent).insertwidget(twidget(component),po1);
     end;
     twidget(component).initnewwidget(rea1);
     doinitcomponent(component,aparent,false);
    end;
   end
   else begin
    po1:= subpoint(dosnaptogrid(apos),clientpos);
    setrootpos(component,po1);
    tcomponent(self).insertcomponent(component);
    doinitcomponent(component,aparent,false);
   end;
   tcomponent1(component).loaded;
  except
   deletecomponent(component);
   raise;
  end;
  selectcomponent(component);
end;

procedure tcomponentdesigner.doinitcomponent(component: tcomponent; parent: tcomponent; isopen: boolean);
var
 rect1: rectty;
 pt1: pointty;
begin
 doaddcomponent(component);
 if (component is twidget) and (parent is twidget) then begin
  with twidget(component) do begin
   if fuseinitcompsoffset then begin
    pt1:= finitcompsoffset;
    subpoint1(finitcompsoffset,pos);
    fcompsoffsetused:= true;
    fuseinitcompsoffset:= false;
   end
   else begin 
    if fcompsoffsetused then begin
     pt1:= addpoint(pos,finitcompsoffset);
    end
    else begin
     pt1:= addpoint(pos,twidget(parent).clientrect.pos);
    end;
   end;
  end;
  addchildsname(component,isopen);
  tcomponent1(component).setdesigning(true);
  twidget(parent).insertwidget(twidget(component),pt1);
  twidget(component).initnewwidget(1.0);
  if fclipinitcomps then begin
   rect1:= twidget(component).widgetrect;
   shiftinrect(rect1,twidget(component).parentwidget.clientwidgetrect);
   twidget(component).widgetrect:= rect1;
  end;
  tcomponent1(component).loaded;
 end else begin
  addchildsname(component,isopen);
  self.insertcomponent(component);
  tcomponent1(component).setdesigning(true);
 end;
end;

procedure tcomponentdesigner.addchildsname(acomp: tcomponent; isopen: boolean);
var
 int1: integer;
begin
 if acomp is twidget then begin
  with twidget(acomp) do begin
   if not isopen then begin
    acomp.name:= getcomponentname(classname);
   end;
   fcomponents.add(acomp);
   if widgetcount>0 then begin
    for int1:=0 to widgetcount-1 do begin
     addchildsname(tcomponent(widgets[int1]),isopen);
    end;
   end;
  end;
 end else begin
  with acomp do begin
   if not isopen then begin
    name:= getcomponentname(classname);
   end;
   fcomponents.add(acomp);
   if componentcount>0 then begin
    for int1:=0 to componentcount-1 do begin
     addchildsname(components[int1],isopen);
    end;
   end;
  end;  
 end;
end;

procedure tcomponentdesigner.docopy(const noclear: boolean);
var
 int1: integer;
 widget1: twidget;
begin
 fselections.remove(self);
 copytoclipboard;
 if not noclear then begin
  widget1:= nil;
  if (fselections.count > 0) and (fselections[0] is twidget) then begin
   widget1:= twidget(fselections[0]).parentofcontainer;
   for int1:= 1 to fselections.count - 1 do begin
    if not (fselections[int1] is twidget) or 
      (twidget(fselections[int1]).parentofcontainer <> widget1) then begin
     widget1:= nil; //no common parent
     break;
    end;
   end;
  end;
  if widget1<>self then
   selectcomponent(widget1);
 end;
end;

procedure tcomponentdesigner.dobringfront;
var
 int1: integer;
begin
 if fselections.count > 0 then begin
  for int1:=0 to fselections.count-1 do begin
   with fselections.itempo(int1)^,selectedinfo do begin
    if instance is twidget then begin
     twidget(instance).bringtofront;
    end;
   end;
  end;
 end;
end;

procedure tcomponentdesigner.dosendback;
var
 int1: integer;
begin
 if fselections.count > 0 then begin
  for int1:=0 to fselections.count-1 do begin
   with fselections.itempo(int1)^,selectedinfo do begin
    if instance is twidget then begin
     twidget(instance).sendtoback;
    end;
   end;
  end;
  invalidate;
 end;
end;

procedure tcomponentdesigner.docut;
begin
 docopy(true);
 dodelete;
end;

procedure tcomponentdesigner.findcomponentclass(Reader: TReader; const aClassName: string;
        var ComponentClass: TComponentClass);
var
 int1: integer;
begin
 with registeredcomponents do begin
  for int1:= 0 to count - 1 do begin
   with itempo(int1)^ do begin
    if aclassname=classtyp.classname then begin
      ComponentClass:= classtyp;
      exit;
    end;
   end;
  end;
 end;
end;

procedure tcomponentdesigner.createcomponent(Reader: TReader; ComponentClass: TComponentClass;
                   var Component: TComponent);
begin
 //
end;

procedure tcomponentdesigner.readstringproperty(Sender:TObject; const Instance: TPersistent;
    PropInfo: PPropInfo; var Content:string);
begin
 //showmessage(content);
end;

procedure tcomponentdesigner.onreferencename(Reader: TReader; var aName: string);
begin
 //showmessage(aname);
end;

function tcomponentdesigner.pastefromobjecttext(const aobjecttext: string; 
         aowner,aparent: tcomponent): integer;
                  //returns count of added components
var
 binstream: tmemorystream;
 textstream: ttextstream;
 int1: integer;
 countbefore: integer;
 reader: treader;
 comp1,comp2: tcomponent;
 listend: tvaluetype;
 
begin
 if aobjecttext = '' then begin
  result:= 0;
  exit;
 end; 
 countbefore:= fselections.count;
 try
  textstream:= ttextstream.Create;
  comp1:= tcomponent.create(nil);
  tcomponent1(comp1).SetDesigning(true{$ifndef FPC},false{$endif});
  lockfindglobalcomponent;
  try
   listend:= vanull;
   textstream.writeln('object comp1: tcomponent');
   textstream.writestr(aobjecttext);
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
      reader.onfindcomponentclass:= 
                           {$ifdef FPC}@{$endif}findcomponentclass;
      begingloballoading;
      reader.readrootcomponent(comp1);
      for int1:= 0 to comp1.componentcount - 1 do begin
       comp2:= comp1.components[int1];
       if comp2.getparentcomponent = nil then begin
        fselections.add(comp2);
       end;
      end;
      for int1:= comp1.componentcount - 1 downto 0 do begin
       comp2:= comp1.components[int1]; 
       if comp2.getparentcomponent = nil then begin
        doinitcomponent(comp2,aparent,false);
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
   comp1.Free;
  end;
 except
  for int1:= countbefore to fselections.count - 1 do begin
   fselections.items[int1].Free;
  end;
  fselections.count:= countbefore;
 end;
 result:= fselections.count - countbefore;
end;

function tcomponentdesigner.getobjecttext: string;
var
 binstream: tmemorystream;
 textstream: ttextstream;
 int1: integer;
 component: tcomponent;
 writer: twriter;
begin
 result:= '';
 with fselections do begin
  if count > 0 then begin
   binstream:= tmemorystream.Create;
   textstream:= ttextstream.Create;
   try
    for int1:= 0 to count -1 do begin
     component:= items[int1];
     if not isembedded(component) then begin
      writer:= twriter.Create(binstream,4096);
      try
       writer.Root:= component.Owner;
       writer.writecomponent(component);
      finally
       writer.free;
      end;
     end;
    end;
    binstream.Position:= 0;
    while binstream.Position < binstream.Size do begin
     objectbinarytotextmse(binstream,textstream);
    end;
    textstream.Position:= 0;
    result:= textstream.readdatastring;
   finally
    binstream.Free;
    textstream.Free;
   end;
  end;
 end;
end;

procedure tcomponentdesigner.copytoclipboard;
begin
 msewidgets.copytoclipboard(getobjecttext);
end;

function tcomponentdesigner.pastefromclipboard(aowner,aparent: tcomponent): integer;
                  //returns count of added components
var
 str1: msestring;
begin
 result:= 0;
 if msewidgets.pastefromclipboard(str1) then begin
  result:= pastefromobjecttext(str1,aowner,aparent);
 end;
end;

procedure tcomponentdesigner.dopaste(const usemousepos: boolean);
var
 widget1: twidget;
begin
 try
  fclipinitcomps:= not usemousepos;
  with fselections do begin
   if count = 1 then begin
    widget1:= twidget(items[0]);
    if (widget1 is twidget) then begin
     fuseinitcompsoffset:= usemousepos;
     fcompsoffsetused:= false;
     if usemousepos then begin
      finitcompsoffset:= subpoint(dosnaptogrid(fmousepos),widget1.clientpos);
     end;
     clear;
     pastefromclipboard(self,widget1);
    end;
   end else if count=0 then begin
    fuseinitcompsoffset:= usemousepos;
    fcompsoffsetused:= false;
    if usemousepos then begin
     finitcompsoffset:= dosnaptogrid(fmousepos); 
    end;
    pastefromclipboard(self,self);
    finitcompsoffset:= makepoint(0,0);
   end;
  end;
 finally
  fclipinitcomps:= false;
 end;
end;

procedure tcomponentdesigner.doundelete;
var
 int1: integer;
begin
 if fdelobjs <> nil then begin
  with fselections do begin
   clear;
   for int1:= 0 to high(fdelobjs) do begin
    with fdelobjs[int1] do begin
     pastefromobjecttext(objtext,owner,parent);
    end;
   end;
   for int1:= count-1 downto 0 do begin
    if isembedded(items[int1]) then begin
     delete(int1);
    end;
   end;
  end;
  fdelobjs:= nil;
 end;
end;

procedure tcomponentdesigner.dodelete;
var
 int1: integer;
begin
 with fselections do begin  
  for int1:= 0 to count - 1 do begin
   with items[int1] do begin
    if componentstate * [csancestor,csinline] = [csancestor] then begin
     showmessage('Inherited component "'+name+
                     '" can not be deleted.','ERROR');
     exit;
    end;             
   end;
  end;
  removeforeign;
  fdelobjs:= fselections.getobjinfoar;
  deletecomponents;
 end;
end;

procedure tcomponentdesigner.savetofile(afilename: filenamety);
var
 binstream: tmemorystream;
 textstream: tmsefilestream;
 int1: integer;
 component: tcomponent;
 writer: twriter;
begin
 if afilename='' then exit;
 binstream:= tmemorystream.Create;
 textstream:= tmsefilestream.create(afilename,fm_create);
 try
  for int1:= 0 to widgetcount -1 do begin
   component:= widgets[int1];
   writer:= twriter.Create(binstream,4096);
   try
    writer.root:= component.Owner;
    writer.writecomponent(component);
   finally
    writer.free;
   end;
  end;
  for int1:= 0 to componentcount -1 do begin
   component:= components[int1];
   writer:= twriter.Create(binstream,4096);
   try
    writer.root:= component.Owner;
    writer.writecomponent(component);
   finally
    writer.free;
   end;
  end;
  binstream.Position:= 0;
  while binstream.Position < binstream.Size do begin
   objectbinarytotextmse(binstream,textstream);
  end;
 finally
  fmodified:= false;
  binstream.Free;
  textstream.Free;
 end;
end;

procedure tcomponentdesigner.loadfromfile(afilename: filenamety);
var
 binstream: tmemorystream;
 textstream,stream1: ttextstream;
 int1: integer;
 reader: treader;
 comp2: tcomponent; 
 listend: tvaluetype;
begin
 if afilename='' then exit;
 try
  for int1:=self.widgetcount-1 downto 0 do begin
   self.widgets[int1].destroy;
  end;
  textstream:= ttextstream.Create;
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
      reader.oncreatecomponent:= {$ifdef FPC}@{$endif}createcomponent;
      reader.onreadstringproperty:= {$ifdef FPC}@{$endif}readstringproperty;
      reader.onreferencename:= {$ifdef FPC}@{$endif}onreferencename;
      try
       reader.readrootcomponent(frootcomp);
      except
       on e: exception do begin
        e.message:= 'Error : ' +e.message;
        getcanvas.drawstring(e.message,makepoint(0,0));
        raise;
       end;
      end;
      fselections.clear;
      fcomponents.clear;
      for int1:= frootcomp.componentcount - 1 downto 0 do begin
       comp2:= frootcomp.components[int1]; 
       if comp2.getparentcomponent = nil then begin
        doinitcomponent(comp2,self,true);
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

function tcomponentdesigner.componentlist: stringarty;
begin
 result:= fcomponents.getlistnames;
end;

function tcomponentdesigner.selectioncount:integer;
begin
 result:= fselections.count;
end;

procedure tcomponentdesigner.clearcomponents;
begin
 fcomponents.clear;
end;

procedure tcomponentdesigner.componentmodified(const acomponent: tobject);
begin
 fselections.externalcomponentchanged(acomponent);
 postcomponentevent(tcomponentevent.create(acomponent,1,false));
 fmodified:= true;
 if canevent(tmethod(fonchange)) then begin
  fonchange(self);
 end;
end;

procedure tcomponentdesigner.dokeyup(var info: keyeventinfoty); 

var
 po1: pointty;
 mouseinfo: mouseeventinfoty;
begin
 inherited;
 with info do begin
  if shiftstate * keyshiftstatesmask = [] then begin
   include(eventstate,es_processed);
   case key of
    key_menu: begin
     if (fpopupmenu <> nil) then begin
      fillchar(mouseinfo,sizeof(mouseinfo),0);
      with mouseinfo do begin
       with application.caret do begin
        if active then begin
         mouseinfo.pos:= pos;
         mouseinfo.pos.y:= mouseinfo.pos.y + height;
        end
        else begin
         mouseinfo.pos:= rectcenter(clippedpaintrect);
        end;
       end;
       button:= mb_none;
      end;
      fpopupmenu.show(self,mouseinfo);
      include(eventstate,es_child);
      include(eventstate,es_processed);
      exit;
     end;     
    end;
    key_escape: begin
     if factarea <> ar_none then begin
      hidexorpic(getcanvas(org_widget));
      fxorpicactive:= false;
      factarea:= ar_none;
     end
     else begin      
      if (fselections.count > 1) then begin
       fselections.clear;
       invalidate;
      end;
     end;
    end;
    key_delete: begin
     if fselections.candelete then begin
      dodelete;
     end;
    end;
    else begin
     exclude(eventstate,es_processed);
    end;
   end;
  end
  else begin
   if (shiftstate = [ss_ctrl]) or (shiftstate = [ss_shift]) then begin
    include(eventstate,es_processed);
    po1:= nullpoint;
    case key of
     key_right: po1.x:= 1;
     key_up: po1.y:= -1;
     key_left: po1.x:= -1;
     key_down: po1.y:= 1;
     else exclude(eventstate,es_processed);
    end;
    if (es_processed in eventstate) then begin
     if shiftstate = [ss_ctrl] then begin
      fselections.move(po1);
      if fselections.count > 0 then begin
       fselections.updateinfos;
      end;
     end
     else begin
      fselections.resize(po1);
      if fselections.count > 0 then begin
       fselections.updateinfos;
      end;
     end;
     invalidate;
    end;
   end;
  end;
  if not (es_processed in eventstate) then begin
   if issysshortcut(sho_copy,info) then begin
    docopy(false);
    include(eventstate,es_processed);
   end
   else begin
    if issysshortcut(sho_cut,info) then begin
     docut;
     include(eventstate,es_processed);
    end
    else begin
     if issysshortcut(sho_paste,info) then begin
      dopaste(false);
      include(eventstate,es_processed);
     end;
    end;
   end;
  end;
 end;
end;

procedure tcomponentdesigner.childmouseevent(const sender: twidget;
                              var info: mouseeventinfoty);
 function griddelta: pointty;
 begin
  if sender=self then begin
   result:= snaptogriddelta(subpoint(info.pos,fpickpos));
  end else begin
   result:= snaptogriddelta(subpoint(subpoint(application.mouse.pos,self.screenpos),fpickpos));
  end;
 end;

 procedure updatesizerect;
 var
  pos1: pointty;
 begin
  pos1:= griddelta;
  with fsizerect,pos1 do begin
   case factarea of
    ht_topleft,ht_left,ht_bottomleft: begin
     if x > size.cx then begin
      x:= size.cx
     end;
     factsizerect.pos.x:= pos.x + x;
     factsizerect.size.cx:= size.cx - x
    end;
    ht_topright,ht_right,ht_bottomright: begin
     if x < -size.cx then begin
      x:= -size.cx;
     end;
     factsizerect.size.cx:= size.cx + x
    end;
   end;
   case factarea of
    ht_topleft,ht_top,ht_topright: begin
     if y > size.cy then begin
      y:= size.cy
     end;
     factsizerect.pos.y:= pos.y + y;
     factsizerect.size.cy:= size.cy - y;
    end;
    ht_bottomleft,ht_bottom,ht_bottomright: begin
     if y < -size.cy then begin
      y:= -size.cy;
     end;
     factsizerect.size.cy:= size.cy + y;
    end;
   end;
  end;
 end;

 procedure updatecursorshape(area: areaty);
 var
  shape: cursorshapety;
 begin
  case area of
   ht_topleft: shape:= cr_topleftcorner;
   ht_bottomright: shape:= cr_bottomrightcorner;
   ht_topright: shape:= cr_toprightcorner;
   ht_bottomleft: shape:= cr_bottomleftcorner;
   ht_top,ht_bottom: shape:= cr_sizever;
   ht_left,ht_right: shape:= cr_sizehor;
   else shape:= cr_arrow;
  end;
  application.widgetcursorshape:= shape;
 end;


var
 component: tcomponent;
 int1: integer;
 bo1: boolean;
 posbefore: pointty;
 widget1: twidget;
 rect1,rect2: rectty;
 selectmode: selectmodety;
 area1: areaty;
 isinpaintrect: boolean;
 ss1: shiftstatesty;
 po1: pdesignselectedinfoty;
 pos2: pointty; 
 info2: mouseeventinfoty;
begin
 if csdesigning in componentstate then exit;
 if not (ws_focused in widgetstate) then setfocus;
 if canevent(tmethod(fonmouseevent)) then begin
  info2:= info;
  info2.pos:=translatewidgetpoint(info.pos,sender,self);
  fonmouseevent(self,info2);
 end;
 with info do begin
  ss1:= shiftstate * shiftstatesmask;
  isinpaintrect:= pointinrect(pos,paintrect);
  posbefore:= pos;
  if eventkind in [ek_buttonpress,ek_buttonrelease] then begin
   fmousepos:= pos;
  end;
  component:= nil;
  if not (es_processed in eventstate) then begin
   bo1:= false;
   if (eventkind = ek_buttonpress) and (button = mb_left) then begin
    if sender=self then begin
     fpickpos:= pos;
    end else begin
     fpickpos:= subpoint(application.mouse.pos,self.screenpos);
    end;
    if (ss1 = [ss_left]) or (ss1 = [ss_left,ss_ctrl]) or 
                (ss1 = [ss_left,ss_ctrl,ss_shift]) or
                (ss1 = [ss_left,ss_double]) then begin
     if sender=self then
      factarea:= fselections.getareainfo(pos,factcompindex)
     else
      factarea:= fselections.getareainfo(subpoint(application.mouse.pos,self.screenpos),factcompindex);
     if factcompindex >= 0 then begin
      fsizerect:= fselections.itempo(factcompindex)^.rect;
      factsizerect:= fsizerect;
     end;
     if (factarea in [ar_component,ar_none]) and 
                                     not (ss_shift in ss1) then begin
      if isinpaintrect then begin
       component:= componentatpos(pos);
       if (component = nil) then begin
         component:= sender.widgetatpos(pos);
       end;
      end;
      if component <> nil then begin
       if (factcompindex < 0) or (component <> fselections[factcompindex]) then begin
        factarea:= ar_none;
       end;
       bo1:= true;
       if ss_ctrl in ss1 then begin
        if component<>self then begin
         selectcomponent(component,sm_flip);
        end;
       end
       else begin
        if (component<>self) and (fselections.indexof(component) < 0) then begin
         selectcomponent(component,sm_select);
         if fmoveonfirstclick then begin
          factarea:= ar_component;
         end;
        end;
        if (component=self) and (fselections.count > 0) then begin
         clearselection;
        end;
        if ss_double in shiftstate then begin
         include(eventstate,es_processed);
         factarea:= ar_none;
         if fobjectinspector<>nil then begin
          fobjectinspector.invalidate;
         end;
        end;
       end;
      end
      else begin
       factarea:= ar_none;
      end;
     end
     else begin
      include(eventstate,es_processed);
     end;
    end
   end;
   if (eventkind = ek_buttonrelease) and (button = mb_right) and
           not (es_processed in eventstate) then begin
    if (fpopupmenu <> nil) then begin
     info2:= info;
     info2.pos:=translatewidgetpoint(info.pos,sender,self);
     fpopupmenu.show(self,info2);
     include(eventstate,es_child);
     include(eventstate,es_processed);
     exit;
    end;
   end;
   if not (es_processed in eventstate) then begin
    if sender=self then
     area1:= fselections.getareainfo(pos,int1)
    else
     area1:= fselections.getareainfo(subpoint(application.mouse.pos,self.screenpos),int1);
    if ((area1 < firsthandle) or (area1 > lasthandle)) and
       ((factarea < firsthandle) or (factarea > lasthandle)) 
       and (eventkind = ek_buttonpress) and 
       (button = mb_left) and (ss1 = [ss_left]) and 
       not ((area1 = ar_component) and 
           not(fselections[int1] is twidget)) and 
       (factarea <> ar_componentmove) then begin
     inherited;
    end;
    pos:= posbefore;
    if bo1 then begin
     if not (es_processed in eventstate) then begin
      updatecursorshape(factarea);
     end
     else begin
      factarea:= ar_none;
     end;
    end;
   end;
   if not (es_processed in eventstate) then begin
    if (eventkind = ek_buttonpress) and (button = mb_left) then begin
     if ss1 = [ss_left] then begin
      if isinpaintrect then begin
       with registeredcomponents do begin
        if selectedclass <> nil then begin
         component:= createcurrentcomponent(selectedclass);
         if component <> nil then begin
          placecomponent(component,pos,sender);
         end;
         selectedclass:= nil;
        end;
       end;
      end;
     end
     else begin
      if (ss1 = [ss_left,ss_shift]) and isinpaintrect then begin
       factarea:= ar_selectrect;
       fxorpicoffset:= pos;
       fpickwidget:= sender; //widgetatpos(pos); //tanda tanya
      end;
     end;
    end;
    if (eventkind = ek_buttonrelease) and (button = mb_left) then begin
     hidexorpic(getcanvas(org_widget)); //mungkin ini
     fxorpicactive:= false;
     case factarea of
      firsthandle..lasthandle: begin
       if (factcompindex >= 0) and (factcompindex < fselections.count) then begin
        component:= tcomponent(fselections.itempo(factcompindex)^.selectedinfo.instance);
        if (component is twidget) then begin
         with twidget(component) do begin
          if parentwidget=self then begin
           widgetrect:= factsizerect;
          end else begin
           factsizerect.pos:= subpoint(factsizerect.pos,subpoint(parentwidget.screenpos,self.screenpos));
           widgetrect:= factsizerect;
          end;
         end;
         fselections.componentschanged;
        end;
       end;
       invalidate;
      end;
      ar_componentmove: begin
       if fselections.move(griddelta) then begin
        invalidate; //redraw handles
       end;
      end;
      ar_selectrect: begin
       if fpickwidget <> nil then begin
        rect1.pos:= fpickpos;
        if sender=self then begin
         rect1.cx:= pos.x - fpickpos.x;
         rect1.cy:= pos.y - fpickpos.y;
        end else begin
         pos2:= addpoint(pos,subpoint(application.mouse.pos,self.screenpos));
         rect1.cx:= pos2.x - fpickpos.x;
         rect1.cy:= pos2.y - fpickpos.y;
        end;
        if (rect1.cx < 0) or (rect1.cy < 0) then begin
         selectmode:= sm_remove;
        end
        else begin
         selectmode:= sm_add;
        end;
        beginselect;
        try
         if (selectmode = sm_add) and (fselections.count = 1) then begin
          fselections.clear;
         end;
         for int1:= 0 to sender.componentcount - 1 do begin
          component:= sender.Components[int1];
          if (not (component is twidget)) then begin
           if rectinrect(getcomponentrect(component),rect1) then begin
            selectcomponent(component,selectmode);
           end;
          end;
         end;
         for int1:= 0 to fpickwidget.widgetcount -1 do begin
          widget1:= fpickwidget[int1];
          if fpickwidget=self then begin
           rect2:= widget1.widgetrect;
           if rectinrect(rect2,rect1) then begin
            selectcomponent(widget1,selectmode);
           end;
          end else begin
           rect2:= widget1.widgetrect;
           rect2.pos:= addpoint(rect2.pos,subpoint(fpickwidget.screenpos,self.screenpos));
           if rectinrect(rect2,rect1) then begin
            selectcomponent(widget1,selectmode);
           end;
           end;           
         end;
        finally
         endselect;
        end;
       end;
      end;
     end;
     fpickwidget:= nil;
     factarea:= ar_none;
     factcompindex:= -1;
     releasemouse;
    end;
 
    if not (es_processed in eventstate) then begin
     if (eventkind = ek_mousemove) then begin
      hidexorpic(getcanvas(org_widget));
      bo1:= true;
      case factarea of
       firsthandle..lasthandle: begin
        updatesizerect;
        include(eventstate,es_processed);
       end;
       ar_component: begin
        if distance(fpickpos,pos) > movethreshold then begin
         fxorpicoffset:= griddelta;
         factarea:= ar_componentmove;
        end
        else begin
         bo1:= false;
        end;
       end;
       ar_componentmove: begin
        fxorpicoffset:= griddelta;
       end;
       ar_selectrect: begin
        if sender=self then begin
         fxorpicoffset:= pos;
        end else begin
         fxorpicoffset:= subpoint(application.mouse.pos,self.screenpos);
        end;
       end;
       else begin
        bo1:= false;
        if sender=self then
         updatecursorshape(fselections.getareainfo(pos,int1))
        else
         updatecursorshape(fselections.getareainfo(subpoint(application.mouse.pos,self.screenpos),int1));
       end;
      end;
      if bo1 then begin
       fxorpicactive:= true;
       if factarea <> ar_component then begin
        fselections.beforepaintmoving; //resets canvas
       end;
       showxorpic(getcanvas(org_widget));
      end;
     end;
    end;
   end;
  end;
 end;
end;

function tcomponentdesigner.getcomponentname(aclassname: string) : string;
var
 int1,int2: integer;
 name1: string;
begin
 if fcomponents.count=0 then begin
  result:= aclassname + '1';
 end else begin
  int2:= 1;
  name1:=aclassname + inttostr(int2);
  while fcomponents.getcomponent(name1)<>nil do begin
   inc(int2);
   name1:=aclassname + inttostr(int2);
  end;
  result:= name1;
 end;
end;

function tcomponentdesigner.createcurrentcomponent(const componentclass: tcomponentclass): tcomponent;
begin
 result:= tcomponent(componentclass.newinstance);
 try
  tcomponent1(result).setdesigning(true);
  result.create(nil);
 except
  result.Free;
  raise;
 end;
end;

function tcomponentdesigner.snaptogriddelta(const apos: pointty): pointty;
begin
 if fsnaptogrid then begin
  result.x:= roundint(apos.x,fgridsizex);
  result.y:= roundint(apos.y,fgridsizey);
 end
 else begin
  result:= apos;
 end;
end;

procedure tcomponentdesigner.clearselection;
var
 int1: integer;
begin
 with fselections do begin
  if count>0 then begin
   int1:= count;
   while int1>0 do begin
    remove(fselections[int1-1]);
    dec(int1);
   end;
  end;
 end;
end;

function tcomponentdesigner.dosnaptogrid(const apos: pointty): pointty;
begin
 if fsnaptogrid then begin
  result:= snaptogriddelta(subpoint(apos,clientpos));
  addpoint1(result,clientpos);
 end
 else begin
  result:= apos;
 end;
end;

procedure tcomponentdesigner.setpopupmenu(const Value: tpopupmenu);
begin
 setlinkedvar(value,tmsecomponent(fpopupmenu));
end;

procedure tcomponentdesigner.drawgrid(const canvas: tcanvas);
var
 po1: pointty;
 rect1,rect2: rectty;
 endy: integer;
 offset: pointty;
 points1: pointarty;
 int1,gridcx,gridcy: integer;
begin
 if fshowgrid then begin
  rect2:= paintrect; //tempat grid
  msegraphutils.intersectrect(canvas.clipbox,rect2,rect1);
  offset:= clientpos;
  gridcx:= gridsizex;
  gridcy:= gridsizey;
  with rect1 do begin
   po1.x:= ((x - offset.x) div gridcx) * gridcx + offset.x;
   po1.y:= ((y - offset.y) div gridcy) * gridcy + offset.y;
   endy:= y + cy;
  end;
  setlength(points1, rect1.cx div gridcx + 1);
  for int1:= 0 to high(points1) do begin
   points1[int1].x:= po1.x;
   inc(po1.x,gridcx);
  end;
  while po1.y < endy do begin
   for int1:= 0 to high(points1) do begin
    points1[int1].y:= po1.y;
   end;
   canvas.drawpoints(points1,cl_ltblue);
   inc(po1.y,gridcy);
  end;
 end;
end;

procedure tcomponentdesigner.deletecomponent(const component: tcomponent);
begin
 selectcomponent(component);
 if fobjectinspector<>nil then begin
  fobjectinspector.itemdeleted(component);
 end;
 dodelete;
end;

procedure tcomponentdesigner.selectcomponent(const component: tcomponent;
                       mode: selectmodety = sm_select);
var
 int1: integer;
begin
 if mode = sm_remove then begin
  fselections.remove(component);
 end
 else begin
  if mode = sm_select then begin
   fselections.clear;
  end;
  if fselections.indexof(component) < 0 then begin
   fselections.add(component);
  end
  else begin
   if mode = sm_flip then begin
    fselections.remove(component);
   end;
  end;
  if fobjectinspector<>nil then begin
   fobjectinspector.SelectionChanged(fselections);
  end;
 end;
end;

procedure tcomponentdesigner.setrootpos(const component: tcomponent;
  const apos: pointty);
begin
 setcomponentpos(component,apos);
end;

procedure tcomponentdesigner.beginselect;
begin
 inc(fselecting);
 fselections.beginupdate;
end;

procedure tcomponentdesigner.endselect;
begin
 dec(fselecting);
 fselections.endupdate;
end;

procedure tcomponentdesigner.checkdelobjs(const aitem: tcomponent);
var
 int1: integer;
begin
 for int1:= 0 to high(fdelobjs) do begin
  with fdelobjs[int1] do begin
   if (owner = aitem) or (parent = aitem) then begin
    owner:= nil;
    parent:= nil;
    objtext:= '';
   end;
  end;
 end;
end;

procedure tcomponentdesigner.setshowgrid(const avalue: boolean);
begin
 if fshowgrid <> avalue then begin
  fshowgrid:= avalue;
  invalidate;
 end;
end;

procedure tcomponentdesigner.setgridsizex(const avalue: integer);
begin
 if fgridsizex <> avalue then begin
  fgridsizex:= avalue;
  invalidate;
 end;
end;

procedure tcomponentdesigner.setgridsizey(const avalue: integer);
begin
 if fgridsizey <> avalue then begin
  fgridsizey:= avalue;
  invalidate;
 end;
end;

{ tcomponentpallete }

constructor tcomponentpallete.create(aowner: tcomponent);
begin
 inherited;
 updatebuttons;
end;

destructor tcomponentpallete.destroy;
begin
 inherited;
end;

procedure tcomponentpallete.updatebuttons;
var
 int1 : integer;
begin
 beginupdate;
 try
  buttons.count:= 0;
  for int1:= 0 to registeredcomponents.count - 1 do begin
   with registeredcomponents.itempo(int1)^ do begin
    with buttons.add do begin
     options:= [mao_checkbox,mao_radiobutton];
     imagelist:= registeredcomponents.imagelist;
     imagenr:= icon;
     hint:= classtyp.classname;
     tag:= integer(classtyp);
    end;
   end;
  end;
 finally
  endupdate;
 end; 
end;

procedure tcomponentpallete.loaded;
begin
 inherited;
 onbuttonchanged:={$ifdef FPC}@{$endif}componentpalettebuttonchanged;
end;

procedure tcomponentpallete.componentpalettebuttonchanged(const sender: TObject;
  const button: ttoolbutton);
begin
 if not application.terminated then begin
  with registeredcomponents do begin
   if tclass(button.tag) = selectedclass then begin
    selectedclass:= nil;
   end;
   //if as_checked in button.state then begin
    selectedclass:= tcomponentclass(button.tag);
   //end;
  end;
 end;
end;

{ tpropertyvalue }

procedure tpropertyvalue.updatestate;
begin
 with feditor do begin
  if allequal then begin
   caption:= removelinebreaks(getvalue);
  end
  else begin
   caption:= '';
  end;
 end;
end;

{ tproppathinfo }

constructor tproppathinfo.create(const aprop: tpropertyitem);
var
 int1: integer;
begin
 inherited create;
 if aprop <> nil then begin
  fname:= aprop.feditor.name;
  if aprop.expanded then begin
   for int1:= 0 to aprop.fcount - 1 do begin
    add(ttreelistedititem(
     tproppathinfo.create(tpropertyitem(aprop[int1]))));
   end;
  end;
 end;
end;

procedure tproppathinfo.save(const aprops: ttreeitemeditlist);
var
 int1: integer;
begin
 clear;
 for int1:= 0 to aprops.count - 1 do begin
  self.add(ttreelistedititem(
        tproppathinfo.create(tpropertyitem(aprops[int1]))));
 end;
end;

procedure tproppathinfo.doexpand(const aitem: tpropertyitem);
var
 int1,int2: integer;
 item1: tpropertyitem;
begin
 if aitem.feditor <> nil then begin
  aitem.expanded:= true; //else root item
 end;
 for int1:= 0 to fcount - 1 do begin
  with tproppathinfo(fitems[int1]) do begin
   if fcount > 0 then begin
    for int2:= 0 to aitem.count - 1 do begin
     item1:= tpropertyitem(aitem[int2]);
     if item1.feditor.name = fname then begin
      doexpand(item1);
     end;
    end;
   end;
  end;
 end;
end;

procedure tproppathinfo.restore(const aprops: ttreeitemeditlist);
var
 item1: tpropertyitem;
begin
 item1:= tpropertyitem.create;
 try
  item1.assign(aprops);
  doexpand(item1);
 finally
  item1.Free;
 end;
end;

{ tcomponentinfos }

constructor tcomponentinfos.create;
begin
 inherited create(sizeof(compinfoty),[rels_needsfinalize]);
end;

procedure tcomponentinfos.compare(const l,r; var result: integer);
begin
 result:= pchar(compinfoty(l).instance) - pchar(compinfoty(r).instance);
end;

function tcomponentinfos.getcompareproc: compareprocty;
begin
 result:= {$ifdef FPC}@{$endif}compare;
end;

procedure tcomponentinfos.finalizerecord(var item);
begin
 finalize(compinfoty(item));
 with compinfoty(item) do begin
  proppathinfo.free;
 end;
end;

function tcomponentinfos.find(const ainstance: tcomponent): integer;
var
 info: compinfoty;
begin
 info.instance:= ainstance;
 result:= indexof(info);
end;

function tcomponentinfos.deleteitem(const ainstance: tcomponent): integer;
begin
 result:= find(ainstance);
 delete(result);
end;

function tcomponentinfos.add(const aitem: compinfoty): integer;
begin
 result:= inherited add(aitem);
end;

function tcomponentinfos.getitem(ainstance: tcomponent): pcompinfoty;
var
 int1: integer;
 info: compinfoty;
begin
 int1:= find(ainstance);
 if int1 < 0 then begin
  fillchar(info,sizeof(info),0);
  info.instance:= ainstance;
  info.proppathinfo:= tproppathinfo.create(nil);
  int1:= add(info);
 end;
 result:= getitempo(int1);
end;

{ tpropertyitem }

destructor tpropertyitem.destroy;
begin
 inherited;
 if (feditor <> nil) and not (ps_owned in feditor.state) then begin
  feditor.free;
 end;
end;

function tpropertyitem.getexpanded: boolean;
begin
 result:= ps_expanded in feditor.state;
end;

procedure tpropertyitem.setexpanded(const Value: boolean);
begin
 inherited expanded:= value;
 if value <> getexpanded then begin
  feditor.expanded:= value;
  updatestate;
 end;
end;

procedure tpropertyitem.updatestate;
var
 state2: propertystatesty;
begin
 with feditor do begin
  caption:= Name;
  state2:= state;
  if ps_subproperties in state2 then begin
   if ps_expanded in state2 then begin
    fimagenr:= 1;
   end
   else begin
    fimagenr:= 2;
   end;
  end
  else begin
   fimagenr:= -1;
  end;
 end;
end;

procedure tpropertyitem.updatesubpropertypath;
begin
 //dummy
end;

function tpropertyitem.finditembyname(const aname: msestring): tpropertyitem;
var
 int1: integer;
 item1: tpropertyitem;
begin
 result:= nil;
 for int1:= 0 to fcount-1 do begin
  item1:= tpropertyitem(fitems[int1]);
  if item1.feditor.name = aname then begin
   result:= item1;
   break;
  end;
 end;
end;

function tpropertyitem.rootpath: msestring;

var
 prop1: tpropertyitem;
begin
 prop1:= self;
 while prop1 <> nil do begin
  if (prop1.feditor is tarrayelementeditor) or 
              (prop1.feditor is tcollectionitemeditor) then begin
   result:= '[]'+result;
  end
  else begin
   if prop1.feditor is trecordpropeditor then begin
    result:= '.'+prop1.feditor.propertyname+'_'+copy(result,2,bigint);
   end
   else begin
    result:= '.'+prop1.feditor.propertyname+result;
   end;
  end;
  prop1:= tpropertyitem(prop1.parent);
 end;
 result:= copy(result,2,bigint);
end;

{ tobjectinspector }

constructor tobjectinspector.create(aowner: tcomponent);
begin
 inherited create(aowner);
 foptionsgrid:=[og_colsizing,og_colmoving,og_focuscellonenter,og_colchangeontabkey,og_noresetselect];
 foptionswidget:= [ow_mousefocus,ow_tabfocus,ow_arrowfocus,ow_focusbackonesc,ow_mousewheel,ow_destroywidgets,ow_fontglyphheight,ow_autoscale];
 fshowmethodproperty:= true;
 fcomponentinfos:= tcomponentinfos.create;
 if not (csdesigning in componentstate) then begin
  props:= ttreeitemedit.create(self);
  values:= tmbdropdownitemedit.create(self);
  props.optionsedit:= [oe_readonly,oe_undoonesc,oe_closequery,oe_checkmrcancel,oe_exitoncursor,oe_resetselectonexit,oe_locate,oe_savestate];
  props.optionsskin:= [osk_noskin];
  props.options:= [teo_treecolnavig,teo_keyrowmoving];
  props.optionswidget:= [ow_mousefocus,ow_tabfocus,ow_arrowfocus,ow_arrowfocusin,ow_arrowfocusout,ow_destroywidgets,ow_fontglyphheight,ow_autoscale];
  values.optionsedit:= [oe_undoonesc,oe_closequery,oe_checkmrcancel,oe_exitoncursor,oe_forcereturncheckvalue,oe_eatreturn,oe_resetselectonexit,oe_autoselect,oe_autoselectonfirstclick,oe_autopopupmenu,oe_savestate];
  values.optionswidget:= [ow_mousefocus,ow_tabfocus,ow_arrowfocus,ow_arrowfocusin,ow_arrowfocusout,ow_destroywidgets,ow_fontglyphheight];
  values.dropdown.options:= [deo_autodropdown,deo_keydropdown,deo_cliphint];
  values.frame.buttons.count:= 2;
  values.frame.buttons[0].imagenr:= 14;
  values.frame.buttons[1].imagenr:= 17;
  values.frame.buttons[0].color:= cl_background;
  values.frame.buttons[1].color:= cl_background;
  values.frame.levelo:= 0;
  values.onbeforedropdown:= {$ifdef FPC}@{$endif}valuesbeforedropdown;
  values.onbuttonaction:= {$ifdef FPC}@{$endif}valuesbuttonaction;
  values.onkeydown:= {$ifdef FPC}@{$endif}valueskeydown;
  values.onclientmouseevent:= {$ifdef FPC}@{$endif}valuesonmouseevent;
  values.onsetvalue:= {$ifdef FPC}@{$endif}valuessetvalue;
  values.onupdaterowvalues:= {$ifdef FPC}@{$endif}valueupdaterowvalue;
  props.oncheckrowmove:= {$ifdef FPC}@{$endif}propsoncheckrowmove;
  props.onupdaterowvalues:= {$ifdef FPC}@{$endif}propupdaterowvalue;
  props.onpopup:= {$ifdef FPC}@{$endif}propsonpopup;
  datacols.count:=2;
  datacols[0].options:= [co_readonly,co_drawfocus,co_mouseselect,co_keyselect,co_multiselect,co_proportional,co_savestate,co_rowfont,co_rowcolor,co_zebracolor];
  datacols[1].options:= [co_fill,co_savestate,co_rowfont,co_zebracolor];
  twidgetcol1(datacols.cols[0]).setwidget(props);
  twidgetcol1(datacols.cols[1]).setwidget(values);
  props.itemlist.oncreateitem:= {$ifdef FPC}@{$endif}propscreatenode;
  props.itemlist.onitemnotification:= {$ifdef FPC}@{$endif}propnotification;
  values.itemlist.oncreateitem:= {$ifdef FPC}@{$endif}valuescreatenode;
  datacols[0].onbeforedrawcell:= {$ifdef FPC}@{$endif}befdrawcell;
  datacols[0].onselectionchanged:= {$ifdef FPC}@{$endif}selchanged;
  oncellevent:= {$ifdef FPC}@{$endif}gridcellevent;
  onrowsdatachanged:= {$ifdef FPC}@{$endif}gridrowsdatachanged;
  drag.onbeforedragbegin:= {$ifdef FPC}@{$endif}gridondragbegin;
  drag.onbeforedragdrop:= {$ifdef FPC}@{$endif}gridondragdrop;
  drag.onbeforedragover:= {$ifdef FPC}@{$endif}gridondragover;
 end;
end;

destructor tobjectinspector.destroy;
begin
 inherited;
 fcomponentinfos.Free;
end;

procedure tobjectinspector.valuesbuttonaction(const sender: tobject; 
              var action: buttonactionty; const buttonindex: Integer);
begin
 with titemedit(sender) do begin
  if action = ba_click then begin
   case buttonindex of
    1: begin
     tpropertyvalue(item).feditor.edit;
    end;
   end;
  end;
 end;
end;

procedure tobjectinspector.valueskeydown(const sender: twidget;
                var info: keyeventinfoty);
begin
 if isenterkey(nil,info.key) and (info.shiftstate = []) and
                            not values.edited then begin
  with tpropertyvalue(values.item),feditor do begin
   if ps_dialog in state then begin
    include(info.eventstate,es_processed);
    edit;
   end;
  end;
 end;
end;

procedure tobjectinspector.valuesonmouseevent(const sender: twidget; 
              var info: mouseeventinfoty);
begin
 if sender.isdblclick(info) then begin
  with tpropertyitem(props.item) do begin
  end;
 end;
end;

procedure tobjectinspector.valuessetvalue(const sender: TObject;
  var avalue: msestring; var accept: Boolean);
var int1: integer;
begin
 try
  tpropertyvalue(titemedit(sender).item).feditor.setvalue(avalue);
  if fcompdesigner<>nil then fcompdesigner.selectcomponent(factcomp);
 except
  values.editor.undo;
  raise;
 end;
 avalue:= tpropertyvalue(titemedit(sender).item).feditor.getvalue;
end;

procedure tobjectinspector.valueupdaterowvalue(const sender: tobject;
  const aindex: integer; const aitem: tlistitem);
begin
 if (aitem <> nil) and (tpropertyvalue(aitem).feditor <> nil) then begin
  with tpropertyvalue(aitem).feditor do begin
   if (aindex = values.activerow) or allequal then begin
    aitem.caption:= removelinebreaks(getvalue);
   end
   else begin
    aitem.caption:= '';
   end;
  end;
 end;
end;

procedure tobjectinspector.valuesbeforedropdown(const sender: TObject);
begin
 with tdropdownitemedit(sender) do begin
  dropdown.cols.clear;
  with tpropertyvalue(item).feditor do begin
   if ps_sortlist in state then begin
    dropdown.options:= dropdown.options + [deo_sorted];
   end
   else begin
    dropdown.options:= dropdown.options - [deo_sorted];
   end;
   dropdown.cols[0].asarray:= getvalues;
  end;
 end;
end;

procedure tobjectinspector.propsonpopup(const sender: tobject;
               var amenu: tpopupmenu; var mouseinfo: mouseeventinfoty);
begin
 tpropertyitem(props.item).feditor.dopopup(amenu,props,mouseinfo);
end;

procedure tobjectinspector.propsoncheckrowmove(const curindex: Integer;
        const newindex: Integer; var accept: Boolean);
var
 editor1: tpropeditor;
 bo1: boolean;
begin
 //simulate dragevent
 editor1:= tpropertyitem(props[curindex]).feditor;
 editor1.dragbegin(bo1);
 if bo1 then begin
  with tpropertyitem(props[newindex]).feditor do begin
   bo1:= false;
   dragover(editor1,bo1);
   if bo1 then begin
    dragdrop(editor1);
    row:= newindex;
   end;
  end;
 end;
end;

procedure tobjectinspector.propupdaterowvalue(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
begin
 updatedefaultstate(aindex);
end;

procedure tobjectinspector.befdrawcell(const sender: tcol;
               const canvas: tcanvas; var cellinfo: cellinfoty;
               var processed: Boolean);
var
 editor1: tpropeditor;
begin
exit;
 editor1:= tpropertyitem(cellinfo.datapo^).feditor;
 if (editor1 <> nil) and editor1.selected then begin
  cellinfo.color:= selectcolor;
 end;
end;

procedure tobjectinspector.selchanged(const sender: tdatacol);
var
 ar1: integerarty;
 int1: integer;
begin
 sender.grid.beginupdate;
 ar1:= sender.selectedcells;
 clearselectedprops(nil);
 if props.item <> nil then begin
  for int1:= 0 to high(ar1) do begin
   tpropertyitem(props[ar1[int1]]).feditor.selected:= true;
  end;
  clearselectedprops(tpropertyitem(props.item));
  for int1:= 0 to high(ar1) do begin
   if not tpropertyitem(props[ar1[int1]]).feditor.selected then begin
    sender.selected[ar1[int1]]:= false;
   end;
  end;
 end;
 sender.grid.endupdate;
end;

procedure tobjectinspector.clearselectedprops(const aprop: tpropertyitem);
               //clears designer selction of all nodes which are no siblings
 procedure doclear(const prop: tpropertyitem);
 var
  int1: integer;
 begin
  if (aprop = nil) or (prop.parent <> aprop.parent) then begin
   prop.feditor.selected:= false;
  end;
  for int1:= 0 to prop.count-1 do begin
   doclear(tpropertyitem(prop[int1]));
  end;
 end;
var
 int1: integer; 
begin
 for int1:= 0 to rowhigh do begin
  if props[int1].parent = nil then begin
   doclear(tpropertyitem(props[int1]));
  end;
 end;
 datacols[0].invalidate;
end;

procedure tobjectinspector.gridcellevent(const sender: tobject;
  var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  values.itemlist.beginupdate;
  try
   with tpropertyvalue(values.item) do begin
    if ps_valuelist in feditor.state then begin
     values.dropdown.options:= values.dropdown.options - [deo_disabled];
    end
    else begin
     values.dropdown.options:= values.dropdown.options + [deo_disabled];
    end;
    values.frame.buttons[1].visible:= ps_dialog in feditor.state;
   end;
  finally
   values.itemlist.decupdate;
  end;
 end;
end;

procedure tobjectinspector.gridrowsdatachanged(const sender: tcustomgrid;
  const acell: gridcoordty; const count: integer);
var
 int1: integer;
begin
 props.itemlist.beginupdate;
 values.itemlist.beginupdate;
 try
  for int1:= acell.row to acell.row + count - 1 do begin
   tpropertyitem(props.itemlist[int1]).updatestate;
   tpropertyvalue(values.itemlist[int1]).feditor:=
           tpropertyitem(props.itemlist[int1]).feditor;
   tpropertyvalue(values.itemlist[int1]).updatestate;
  end;
 finally
  props.itemlist.endupdate;
  values.itemlist.endupdate;
 end;
end;

procedure tobjectinspector.saveproppath;
var
 po1: pcompinfoty;
begin
 if (factcomp <> nil) and (props.itemlist.count > 0) then begin
  po1:= fcomponentinfos.getitem(factcomp);
  po1^.proppathinfo.save(props.itemlist);
  if props.item <> nil then begin
   po1^.actprop:= props.item.rootcaptions;
  end;
  flastcomp:= factcomp;
 end;
end;

procedure tobjectinspector.clear;
begin
 saveproppath;
 values.itemlist.clear;
 frereadprops:= false;
end;

function tobjectinspector.candragsource(const apos: pointty; var arow: integer): boolean;
var
 widget1: twidget;
 cell: gridcoordty;
begin
 widget1:= editwidgetatpos(apos,cell);
 arow:= cell.row;
 if (widget1 = props) and (not values.edited or values.checkvalue) then begin
  result:= props.candragsource(translateclientpoint(apos,self,widget1));
 end
 else begin
  result:= false;
 end;
end;

function tobjectinspector.candragdest(const apos: pointty; var arow: integer): boolean;
var
 widget1: twidget;
 cell: gridcoordty;
begin
 widget1:= editwidgetatpos(apos,cell);
 arow:= cell.row;
 result:= widget1 = props;
end;

procedure tobjectinspector.gridondragbegin(const sender: tobject;
  const apos: pointty; var dragobject: tdragobject; var processed: boolean);
var
 arow: integer;
 bo1: boolean;
begin
 if candragsource(apos,arow) then begin
  bo1:= false;
  tpropertyitem(props[arow]).feditor.dragbegin(bo1);
  if bo1 then begin
   tobjectdragobject.create(sender,dragobject,nullpoint,
          tpropertyitem(props[arow]).feditor);
  end;
 end;
end;

procedure tobjectinspector.gridondragdrop(const sender: tobject;
  const apos: pointty; var dragobject: tdragobject; var processed: boolean);
var
 arow: integer;
begin
 if candragdest(apos,arow) then begin
  tpropertyitem(props[arow]).feditor.dragdrop(
     tpropeditor(tobjectdragobject(dragobject).data));
  row:= arow;
 end;
end;

procedure tobjectinspector.updateskin(const recursive: boolean = false);
begin
 if values<>nil then begin
  values.updateskin;
 end;
 inherited;
end;

procedure tobjectinspector.gridondragover(const sender: tobject;
               const apos: pointty; var dragobject: tdragobject;
               var accept: boolean; var processed: boolean);
var
 arow: integer;
begin
 if candragdest(apos,arow) then begin
  tpropertyitem(props[arow]).feditor.dragover(
     tpropeditor(tobjectdragobject(dragobject).data),accept);
 end;
end;

procedure tobjectinspector.sizechanged;
begin
 inherited;
 if not (csdesigning in componentstate) then begin
  datacols.cols[0].width:= innerclientrect.cx div 2;
  datacols.cols[1].width:= innerclientrect.cx div 2;
 end;
end;

procedure tobjectinspector.loaded;
begin
 inherited;
 if not (csdesigning in componentstate) then begin
  clear;
 end;
end;

procedure tobjectinspector.setdesign(const avalue: tcomponentdesigner);
begin
 if avalue<>fcompdesigner then begin
  if avalue<>nil then begin
   fcompdesigner:= avalue;
   fcompdesigner.fobjectinspector:= self;
  end else begin
   fcompdesigner.fobjectinspector:= nil;   
   fcompdesigner:= avalue;
  end;
 end;
end;

procedure tobjectinspector.propscreatenode(const sender: tcustomitemlist;
  var node: ttreelistedititem);
begin
 node:= tpropertyitem.create(sender);
end;

procedure tobjectinspector.valuescreatenode(
  const sender: tcustomitemlist; var node: tlistedititem);
begin
 node:= tpropertyvalue.create(sender);
end;

procedure tobjectinspector.propnotification(const sender: tlistitem;
  var action: nodeactionty);
begin
 with tpropertyitem(sender) do begin
  case action of
   na_expand: begin
    feditor.expanded:= true;
    if count = 0 then begin
     add(editorstoprops(feditor.subproperties));
    end;
   end;
   na_collapse: begin
    feditor.expanded:= false;
   end;
  end;
 end;
end;

function tobjectinspector.editorstoprops(const editors: propeditorarty): treelistitemarty;
var
 int1: integer;
begin
 setlength(result,length(editors));
 for int1:= 0 to high(result) do begin
  result[int1]:= tpropertyitem.create;
  with tpropertyitem(result[int1]) do begin
   feditor:= editors[int1];
   feditor.expanded:= false;
   fcaption:= feditor.name{.fprops[0].propinfo^.Name};
   if ps_subproperties in feditor.state then begin
    state:= state + [ns_subitems];
   end;
  end;
 end;
end;

function tobjectinspector.reviseproperties(
                const aprops: propeditorarty): propeditorarty;
var
 int1,int2,int3,int4: integer;
 str1: msestring;
 edar1: propeditorarty;
 acomponent: tcomponent;
begin
 result:= aprops;
 if length(result) > 0 then begin
  int2:= 0;
  int3:= 1;
  for int1:= 1 to high(result) do begin
   if result[int1].name = result[int2].name then begin
    result[int1].free;   //remove duplicates
   end
   else begin
    result[int3]:= result[int1];
    inc(int3);
    int2:= int1;
   end;
  end;
  setlength(result,int3);
  with tpropeditor1(result[0]) do begin
   acomponent:= fcomponent;
  end;
  int1:= 0;
  while int1 <= high(result) do begin
   str1:= result[int1].name;
   //int2:= msestrscan(str1,msechar('_'));
   int2:= findchar(str1,msechar('_'));
   if int2 > 0 then begin
    int3:= int1+1;
    while (int3 <= high(result)) and
     (msestrlcomp(pmsechar(str1),pmsechar(result[int3].name),int2) = 0) do begin
     inc(int3);
    end;
    setlength(edar1,int3-int1);
    move(result[int1],edar1[0],length(edar1) * sizeof(edar1[0]));
    inc(int2);
    for int4:= 0 to high(edar1) do begin
     tpropeditor1(edar1[int4]).fname:=
          copy(tpropeditor1(edar1[int4]).fname,int2,bigint);
    end;
    fillchar(result[int1],length(edar1)*sizeof(result[0]),0);
    result[int1]:= trecordpropeditor.create(fcompdesigner,acomponent,
         iobjectinspector(self),copy(str1,1,int2-2),reviseproperties(edar1));
    int1:= int3;
   end
   else begin
    inc(int1);
   end;
  end;
  int2:= 0;
  for int1:= 0 to high(result) do begin
   if result[int1] <> nil then begin
    result[int2]:= result[int1];
    inc(int2);
   end;
  end;
  setlength(result,int2);
 end;
end;

procedure tobjectinspector.callrereadprops;
begin
 if not frereadprops and (fchanging = 0) then begin
  asyncevent(ado_rereadprops);
  frereadprops:= true;
 end;
end;

function tobjectinspector.restoreactprop(const acomponent: tcomponent;
                   acol: integer; exact: boolean = false): boolean;
var
 po1: pcompinfoty;
 int1: integer;
 item1,item2,item3: tpropertyitem;
begin
 result:= false;
 if acomponent <> nil then begin
  po1:= fcomponentinfos.getitempo(fcomponentinfos.find(acomponent));
  if (po1 <> nil) and (high(po1^.actprop) >= 0) then begin
   item1:= tpropertyitem.create;
   try
    item1.assign(props.itemlist);
    item2:= item1;
    result:= true;
    item3:= item2;  //compiler warning
    for int1:= 0 to high(po1^.actprop) do begin
     item3:= item2;
     item2:= item2.finditembyname(po1^.actprop[int1]);
     if item2 = nil then begin
      result:= not exact;
      break;
     end;
    end;
    if result then begin
     if item2 = nil then begin
      item2:= item3;
     end;
     focuscell(makegridcoord(acol,item2.findex));
    end;
   finally
    item1.Free;
   end;
  end;
 end;
end;

procedure tobjectinspector.readprops(const comp: componentarty);
var
 po1: pcompinfoty;
 acol: integer;
 int1: integer;
begin
 invalidate;
 try
  canclose(nil); //save pending edits
 except
  on e: exception do begin
   rowcount:= 0;
   raise;
  end;
 end;
 acol:= col;
 if acol < 0 then begin
  acol:= 1;
 end;
 rowcount:=0;
 if high(comp) >= 0 then begin
  props.itemlist.Assign(listitemarty(editorstoprops(getproperties(objectarty(comp),comp[0]))));
  po1:= fcomponentinfos.getitempo(fcomponentinfos.find(comp[0]));
  if (po1 = nil) and (flastcomp <> nil) then begin
   po1:= fcomponentinfos.getitempo(fcomponentinfos.find(flastcomp));
  end;
  if po1 <> nil then begin
   po1^.proppathinfo.restore(props.itemlist);
  end;
  if not restoreactprop(flastcomp,acol,true) then begin
   restoreactprop(comp[0],acol);
  end;
  for int1:= 0 to rowhigh do begin
   updatedefaultstate(int1);
  end;
 end;
end;

procedure tobjectinspector.readprops(const comp: tcomponent);
var
 ar1: componentarty;
begin
 setlength(ar1,1);
 ar1[0]:= comp;
 readprops(ar1);
end;

function tobjectinspector.findvalueeditor(const editor: tpropeditor): integer;
var
 int1: integer;
 po1: ppropertyvalue;
begin
 result:= -1;
 po1:= ppropertyvalue(titemlist1(values.itemlist).fdatapo);
 for int1:= 0 to values.itemlist.count - 1 do begin
  if po1^.feditor = editor then begin
   result:= int1;
   break;
  end;
  inc(po1);
 end;
end;

procedure tobjectinspector.updatedefaultstate(const aindex: integer);
type
 fontmarkty = (modified,iscomponent,issubproperty);
 fontmarksty = set of fontmarkty;
var
 mark: fontmarksty;
const 
 marktable: array[0..7] of integer = (
                     //issubbroperty iscomponent modified
             -1,     //         0            0        0
              0,     //         0            0        1
              3,     //         0            1        0
             -1,     //         0            1        1 invalid
              2,     //         1            0        0
              1,     //         1            0        1
              2,     //         1            1        0
             -1      //         1            1        1 invalid
               );
begin
 with tpropertyvalue(values[aindex]) do begin
  if feditor <> nil then begin
   mark:= [];
   if ps_modified in feditor.state then begin
    include(mark,modified);
   end;
   if ps_component in feditor.state then begin
    include(mark,iscomponent);
   end;
   if ps_subprop in feditor.state then begin
    include(mark,issubproperty);
   end;
   rowfontstate[aindex]:= marktable[
      {$ifdef FPC}cardinal{$else}byte{$endif}(mark)];
   if feditor.sortlevel > 0 then begin
    rowcolorstate[aindex]:= 0;
   end
   else begin
    rowcolorstate[aindex]:= -1;
   end;
  end;
 end;
end;

function tobjectinspector.getproperties(const objects: objectarty;
                  const acomponent: tcomponent): propeditorarty;
type
 propinfopoararty = array of propinfopoarty;
var
 ar1: propinfopoararty;
 master: integer;

 function isok(const index: integer; var indexes: integerarty): boolean;

  function check(info: ppropinfo; ar: propinfopoarty; var foundindex: integer): boolean;
  var
   int1: integer;
   kind: ttypekind;
   typedata: ptypedata;
  begin
   result:= false;
   kind:= info^.proptype^.Kind;
   typedata:= gettypedata(info^.proptype{$ifndef FPC}^{$endif});
   for int1:= 0 to high(ar) do begin
    if (ar[int1]^.proptype^.Kind = kind) and (info^.Name = ar[int1]^.Name) then begin
     if not ((kind = tkset) and
      (typedata^.comptype <>
       gettypedata(ar[int1]^.proptype{$ifndef FPC}^{$endif})^.CompType) or
      (kind = tkenumeration) and
       (typedata^.basetype <>
        gettypedata(ar[int1]^.proptype{$ifndef FPC}^{$endif})^.basetype)) then begin
      foundindex:= int1;
      result:= true;
      break;
     end;
    end;
   end;
  end;

 var
  int1: integer;
 begin                 //isok
  result:= true;
  for int1:= 0 to high(ar1) do begin
   if int1 <> master then begin
    result:= check(ar1[master][index],ar1[int1],indexes[int1]);
    if not result then begin
     break;
    end;
   end
   else begin
    indexes[int1]:= index;
   end;
  end;
 end;                //isok

var
 ar2: propinfopoararty;
 int1,int2,int3: integer;
 propar: propinstancearty;
 intar: integerarty;
 tmpprop: propinfopoarty;
begin
 result:= nil;
 if (acomponent <> nil) and (high(objects) >= 0) then begin
  setlength(ar1,length(objects));
  for int1:= 0 to high(ar1) do begin
   ar1[int1]:= getpropinfoar(objects[int1]);
   if not fshowmethodproperty then begin
    int3:= 0;
    tmpprop:=nil;
    for int2:= 0 to high(ar1[int1]) do begin
     if ar1[int1][int2]^.proptype^.kind<>tkmethod then begin
      setlength(tmpprop,int3+1);
      tmpprop[int3]:= ar1[int1][int2];
      inc(int3);     
     end;
    end;
    ar1[int1]:=tmpprop;
   end;
  end;
  if high(objects) > 0 then begin
   master:= 0;
   int2:= high(ar1[0]);
   for int1:= 1 to high(ar1) do begin
    if high(ar1[int1]) < int2 then begin
     master:= int1;
     int2:= high(ar1[int1]);
    end;
   end;
   inc(int2);
   setlength(ar2,length(ar1));
   for int1:= 0 to high(ar1) do begin
    setlength(ar2[int1],int2);
   end;
   int2:= 0;
   setlength(intar,length(ar1));
   for int1:= 0 to high(ar1[master]) do begin
    if isok(int1,intar) then begin
     for int3:= 0 to high(ar1) do begin
      ar2[int3][int2]:= ar1[int3][intar[int3]];
     end;
     inc(int2);
    end;
   end;
   for int3:= 0 to high(ar1) do begin
    setlength(ar2[int3],int2);
   end;
  end
  else begin
   ar2:= ar1;
   int2:= length(ar2[0]);
  end;
  setlength(result,int2);
  setlength(propar,length(objects));
  for int1:= 0 to high(propar) do begin
   propar[int1].instance:= objects[int1];
  end;
  for int1:= 0 to int2 - 1 do begin
   for int3:= 0 to high(propar) do begin
    propar[int3].propinfo:= ar2[int3][int1];
   end;
   result[int1]:= propeditors.geteditorclass(
      ar2[0][int1]^.proptype{$ifndef FPC}^{$endif},
      objects[0].ClassType,ar2[0][int1]^.Name).create(
              fcompdesigner,acomponent,iobjectinspector(self),
              propar,ar2[0][int1]^.proptype{$ifndef FPC}^{$endif});
  end;
  sortarray(pointerarty(result),{$ifdef FPC}@{$endif}comparepropeditor);
  result:= reviseproperties(result);
 end;
end;

procedure tobjectinspector.propertymodified(const sender: tpropeditor);

 procedure compmodified;
 var
  int1: integer;
  props1: propinstancearty;
  comps: componentarty;
 begin
  props1:= nil; //compiler warning
  inc(fchanging);
  try
   comps:= sender.propowner;
   if length(comps) > 0 then begin
    for int1:= 0 to high(comps) do begin
     fcompdesigner.componentmodified(comps[int1]);
    end;
   end
   else begin
    props1:= sender.rootprops;
    for int1:= 0 to high(props1) do begin
     fcompdesigner.componentmodified(props1[int1].instance);
    end;
   end;
  finally
   dec(fchanging);
  end;
 end;
 
 var
 po1,po2: tpropertyvalue;
 int1,int2,int3: integer;
 bo1: boolean;

begin
 if ps_volatile in sender.state then begin
  callrereadprops;
  compmodified;
 end
 else begin
//  designer.begincomponentmodify;
//  try
  if (props.item <> nil) and (tpropertyvalue(values.item).feditor = sender) then begin
   po1:= tpropertyvalue(values.item);
  end
  else begin
   int1:= findvalueeditor(sender);
   if int1 >= 0 then begin
    po1:= tpropertyvalue(values.itemlist[int1]);
   end
   else begin
    po1:= nil;
   end;
  end;
  if po1 <> nil then begin
   po1.updatestate;
   bo1:= (ps_refreshall in sender.state);
   for int1:= 0 to rowcount - 1 do begin
    po2:= tpropertyvalue(values[int1]);
    if (po2 <> po1) and (bo1 or (ps_refresh in po2.feditor.state)) then begin
     with tpropertyitem(props[int1]) do begin
      if feditor <> nil then begin
       feditor.updatedefaultvalue;
      end;
     end;
     po2.updatestate;
     updatedefaultstate(int1);
     int3:= props[int1].treelevel;
     for int2:= int1 + 1 to rowcount - 1 do begin
      if props[int2].treelevel <= int3 then begin
       break;
      end
      else begin
       tpropertyvalue(values[int2]).updatestate;
      end;
     end;
    end;
   end;
  end;
  compmodified;
 end;
end;

procedure tobjectinspector.updatecomponentname;
begin
 if fsinglecomp then begin
  fixrows[-2].captions[0].caption:= factcomp.name + ' (' + factcomp.classname + ')';
 end
 else begin
  fixrows[-2].captions[0].caption:= '';
 end;
end;

procedure tobjectinspector.SelectionChanged(const ASelection: tradesignselections);
begin
 saveproppath;
 with aselection do begin
  if count > 0 then begin
   factcomp:= items[0];
  end
  else begin
   factcomp:= nil;
  end;
  factcomps:= getarray;
  if count = 1 then begin
   fsinglecomp:= true;
   readprops(factcomp);
  end
  else begin
   fsinglecomp:= false;
   readprops(factcomps);
  end;
  updatecomponentname;
  inc(fchanging);
  try
   selectedcompchanged;
  finally
   dec(fchanging);
  end;
 end;
end;

procedure tobjectinspector.ItemDeleted(const aitem: tcomponent);
begin
 if factcomp = aitem then begin
  clear;
 end;
 if flastcomp = aitem then begin
  flastcomp:= nil;
 end;
 fcomponentinfos.deleteitem(aitem);
end;

procedure tobjectinspector.selectedcompchanged;
begin
 if fchanging = 0 then begin
  designer.selectcomponent(factcomp);
 end;
end;

{ tpropeditors }

constructor tpropeditors.create;
begin
 inherited;
 fsize:= sizeof(propeditorinfoty);
end;

procedure tpropeditors.add(apropertytype: ptypeinfo;
  apropertyownerclass: tclass; const apropertyname: string;
  aeditorclass: propeditorclassty);
var
 info: propeditorinfoty;
 class1: tclass;

begin
 with info do begin
  propertytype:= apropertytype;
  propertyownerclass:= apropertyownerclass;
  propertyname:= uppercase(apropertyname);
  editorclass:= aeditorclass;
  class1:= aeditorclass;
  editorclasslevel:= 0;
  while (class1 <> tpropeditor) do begin
   class1:= class1.ClassParent;
   inc(editorclasslevel);
  end;
 end;
 adddata(info);
end;

procedure tpropeditors.freedata(var data);
begin
 propeditorinfoty(data).propertyname:= '';
 inherited;
end;

procedure tpropeditors.copyinstance(var data);
begin
 reallocstring(propeditorinfoty(data).propertyname);
end;

function tpropeditors.getitems(
  const index: integer): ppropeditorinfoty;
begin
 result:= ppropeditorinfoty(getitempo(index));
end;

function tpropeditors.geteditorclass(apropertytype: ptypeinfo;
               apropertyownerclass: tclass;
               apropertyname: string): propeditorclassty;
               
               //todo: optimize
var
 int1: integer;
 po1: ppropeditorinfoty;
 kind: ttypekind;
 class1: tclass;
 po2: ptypeinfo;
 int2: integer;
 namelevel,propertyownerclasslevel,typeclasslevel,propeditorlevel: integer;
 anamelevel,apropertyownerclasslevel,atypeclasslevel: integer;

 procedure savelevel;
 begin
  namelevel:= anamelevel;
  propertyownerclasslevel:= apropertyownerclasslevel;
  typeclasslevel:= atypeclasslevel;
  propeditorlevel:= po1^.editorclasslevel;
  result:= po1^.editorclass;
 end;

begin
 apropertyname:= uppercase(apropertyname);
 result:= tpropeditor;
 po1:= ppropeditorinfoty(fdatapo);
 kind:= apropertytype^.Kind;
 namelevel:= 1;
 propertyownerclasslevel:= bigint;
 typeclasslevel:= bigint;
 propeditorlevel:= 0;

 for int1:= 0 to count - 1 do begin
  if kind = po1^.propertytype^.Kind then begin
   if (po1^.propertyownerclass <> nil) then begin
    class1:= apropertyownerclass;
    int2:= 0;
    while (class1 <> nil) and (class1 <> po1^.propertyownerclass) do begin
     class1:= class1.ClassParent;
     inc(int2)
    end;
    if class1 <> nil then begin
     apropertyownerclasslevel:= int2;
    end
    else begin
     apropertyownerclasslevel:= bigint + 1;
    end;
   end
   else begin
    apropertyownerclasslevel:= bigint - 1;
   end;

   if po1^.propertyname = '' then begin
    anamelevel:= 1;
   end
   else begin
    if po1^.propertyname = apropertyname then begin
     anamelevel:= 3;
    end
    else begin
     anamelevel:= 0;
    end;
   end;

   if kind = tkclass then begin
    {$ifdef FPC}
    po2:= gettypedata(apropertytype)^.classtype.classinfo;
    {$else}
    po2:= apropertytype;
    {$endif}
    int2:= 0;
    while (po2 <> nil) and (po2 <> po1^.propertytype) do begin
     inc(int2);
     {$ifdef FPC}
     po2:= gettypedata(po2)^.parentinfo;
     {$else}
     po2:= ptypeinfo(gettypedata(po2)^.parentinfo);
     if po2 <> nil then begin
      po2:= pptypeinfo(po2)^;
     end;
     {$endif}
    end;
    if (po2 <> nil) then begin
     atypeclasslevel:= int2
    end
    else begin
     atypeclasslevel:= bigint + 1;
    end;
   end
   else begin
    if (po1^.propertytype = apropertytype) {$ifdef FPC}
         or (po1^.propertytype^.name = apropertytype^.name) {$endif} then begin
     atypeclasslevel:= 0;
    end
    else begin
     atypeclasslevel:= 1;
    end;
   end;

   if kind = tkclass then begin
    if (typeclasslevel > atypeclasslevel) and (anamelevel = 1) and 
               (apropertyownerclasslevel = bigint-1) then begin
     savelevel;
    end
    else begin
     if typeclasslevel >= atypeclasslevel then begin
      if (propertyownerclasslevel > apropertyownerclasslevel) and 
              (anamelevel = 1) then begin
       savelevel;
      end
      else begin
       if propertyownerclasslevel >= apropertyownerclasslevel then begin
        if namelevel < anamelevel then begin
         savelevel;
        end
        else begin
         if (namelevel = anamelevel) and
          (propeditorlevel <= po1^.editorclasslevel) then begin
          savelevel;
         end;
        end;
       end;
      end;
     end;
    end;
   end
   else begin
    if (propertyownerclasslevel > apropertyownerclasslevel) and  (anamelevel = 1) then begin
     savelevel;
    end
    else begin
     if propertyownerclasslevel >= apropertyownerclasslevel then begin
      if namelevel < anamelevel then begin
       savelevel;
      end
      else begin
       if namelevel = anamelevel then begin
        if typeclasslevel > atypeclasslevel then begin
         savelevel;
        end
        else begin
         if (typeclasslevel = atypeclasslevel) and
          (propeditorlevel <= po1^.editorclasslevel) then begin
          savelevel;
         end;
        end;
       end;
      end;
     end;
    end;
   end;
  end;
  inc(po1);
 end;
end;

{ tpropeditor }

constructor tpropeditor.create(const adesigner: tcomponentdesigner;
            const acomponent: tcomponent;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypeinfo: ptypeinfo);
begin
 fcomponent:= acomponent;
 fdesigner:= adesigner;
 ftypeinfo:= atypeinfo;
 fobjectinspector:= aobjectinspector;
 if aprops <> nil then begin
  fprops:= copy(aprops); //!!!! crash whithout copy, why ?
 //reallocarray(fprops,sizeof(props[0]));
  fname:= fprops[0].propinfo^.Name;
 end;
 fstate:= getdefaultstate;
 updatedefaultvalue;
 //fcopyindex:= -1;
end;

destructor tpropeditor.destroy;
begin
 pointer(fdesigner):= nil;
 pointer(fobjectinspector):= nil;
 pointer(fremote):= nil;
end;

procedure tpropeditor.setremote(intf: iremotepropeditor);
begin
 fremote:= intf;
 if fremote <> nil then begin
  fparenteditor:= fremote.getparenteditor;
  if (fparenteditor <> nil) and  (ps_subprop in fparenteditor.fstate) then begin
   include(fstate,ps_subprop);
  end;
 end;
end;

function tpropeditor.canrevert: boolean;
begin
 result:= (ftypeinfo <> nil) and (fremote = nil) and 
  (csancestor in component.componentstate) and (fprops[0].instance = component);
end;

procedure tpropeditor.copyproperty(const asource: tobject);
begin 
 case ftypeinfo^.kind of
  tkInteger,tkChar,tkEnumeration,tkSet,tkWChar,
                         {$ifdef FPC}tkBool,{$endif}tkClass: begin
   setordvalue(getordprop(asource,fprops[0].propinfo));
  end;
  tkFloat: begin
   setfloatvalue(getfloatprop(asource,fprops[0].propinfo));
  end;
  {$ifdef FPC}tkSString,tkAString,{$endif}tkLString: begin
   setstringvalue(getstrprop(asource,fprops[0].propinfo));
  end;
  tkWString: begin
   setmsestringvalue(getwidestrprop(asource,fprops[0].propinfo));
  end;
  tkInt64{$ifdef FPC},tkQWord{$endif}: begin
   setint64value(getint64prop(asource,fprops[0].propinfo));
  end;
 end;
end;

function tpropeditor.getvalue: msestring;
begin
 result:= 'Unknown';
end;

procedure tpropeditor.setvalue(const value: msestring);
begin
 //dummy
end;

function tpropeditor.name: msestring;
begin
 result:= fname;
end;

function tpropeditor.allequal: boolean;
begin
 result:= high(fprops) = 0;
end;

function tpropeditor.props: propinstancearty;
begin
 result:= fprops;
end;

function tpropeditor.rootprops: propinstancearty;
var
 ed1: tpropeditor;
begin
 result:= nil;
 ed1:= getparenteditor;
 if ed1 <> nil then begin
  result:= ed1.rootprops;
 end;
 if result = nil then begin
  result:= fprops;
 end;
end;

function tpropeditor.propowner: componentarty;
var
 ed1: tpropeditor;
 int1: integer;
begin
 result:= nil;
 ed1:= getparenteditor;
 while ed1 <> nil do begin
  if (ed1 is tcomponentpropeditor) and not 
               tcomponentpropeditor(ed1).issubcomponent then begin
   setlength(result,count);
   for int1:= 0 to high(result) do begin
    result[int1]:= tcomponent(ed1.getordvalue);
   end;
   break;
  end;
  ed1:= ed1.getparenteditor;
 end;
end;

function tpropeditor.instance(const index: integer = 0): tobject;
begin
 result:= fprops[index].instance;
end;

function tpropeditor.typedata: ptypedata;
begin
 result:= gettypedata(ftypeinfo);
end;

function tpropeditor.queryselectedpropinstances: objectarty;
var
 editor1: tpropeditor;
begin
 result:= nil;
 editor1:= fparenteditor;
 while editor1 <> nil do begin
  if (editor1.fremote <> nil) and (editor1.fremote.selected) then begin
   result:= editor1.fremote.getselectedpropinstances;
   break;
  end;
  if editor1 is tclasspropeditor then begin
   break;
  end;
  editor1:= editor1.fparenteditor;
 end;  
 if result <> nil then begin
  include(fstate,ps_refreshall);
 end;
end;

function tpropeditor.getordvalue(const index: integer): integer;

begin
 if fremote <> nil then begin
  result:= fremote.getordvalue(index);
 end
 else begin
  with fprops[index] do begin
   result:= GetOrdProp(instance,propinfo);
  end;
 end;
end;

procedure tpropeditor.setordvalue(const value: cardinal);
var
 int1: integer;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setordvalue(value);
 end
 else begin
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
     setordprop(instance, propinfo, value);
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
    setordprop(ar1[int1],fprops[0].propinfo,value);
   end;
  end;
  updatedefaultvalue;
  modified;
 end;
end;

procedure tpropeditor.setordvalue(const index: integer; const value: cardinal);
begin
 if fremote <> nil then begin
  fremote.setordvalue(index,value);
 end
 else begin
  with fprops[index] do begin
   setordprop(instance, propinfo, value);
  end;
  updatedefaultvalue;
  modified;
 end;
end;

function tpropeditor.getint64value(const index: integer): int64;

begin
 if fremote <> nil then begin
  result:= fremote.getint64value(index);
 end
 else begin
  with fprops[index] do begin
   result:= GetOrdProp(instance,propinfo);
  end;
 end;
end;

procedure tpropeditor.setint64value(const value: int64);
var
 int1: integer;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setint64value(value);
 end
 else begin
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
     setint64prop(instance, propinfo, value);
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
    setint64prop(ar1[int1],fprops[0].propinfo,value);
   end;
  end;
  updatedefaultvalue;
  modified;
 end;
end;

procedure tpropeditor.setint64value(const index: integer; const value: int64);
begin
 if fremote <> nil then begin
  fremote.setint64value(index,value);
 end
 else begin
  with fprops[index] do begin
   setint64prop(instance, propinfo, value);
  end;
  updatedefaultvalue;
  modified;
 end;
end;

procedure tpropeditor.setbitvalue(const value: boolean; const bitindex: integer);
var
 int1: integer;
 wo1: cardinal;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setbitvalue(value,bitindex);
 end
 else begin
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
     wo1:= getordprop(instance,propinfo);
     updatebit(wo1,bitindex,value);
     setordprop(instance,propinfo,wo1);
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
    wo1:= getordprop(ar1[int1],fprops[0].propinfo);
    updatebit(wo1,bitindex,value);
    setordprop(ar1[int1],fprops[0].propinfo,wo1);
   end;
  end;
  fparenteditor.updatedefaultvalue;
  updatedefaultvalue;
  modified;
 end;
end;

function tpropeditor.getfloatvalue(const index: integer): extended;
begin
 if fremote <> nil then begin
  result:= fremote.getfloatvalue(index);
 end
 else begin
  with fprops[index] do begin
   result:= GetfloatProp(instance,propinfo);
  end;
 end;
end;

procedure tpropeditor.setfloatvalue(const value: extended);
var
 int1: integer;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setfloatvalue(value);
 end
 else begin
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
     SetfloatProp(Instance, PropInfo, Value);
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
    setfloatprop(ar1[int1],fprops[0].propinfo,value);
   end;
  end;
  modified;
 end;
end;

function tpropeditor.getcurrencyvalue(const index: integer = 0): currency;
begin
 if fremote <> nil then begin
  result:= fremote.getcurrencyvalue(index);
 end
 else begin
  with fprops[index] do begin
   result:= getfloatprop(instance,propinfo);
  end;
 end;
end;

procedure tpropeditor.setcurrencyvalue(const value: currency);
var
 int1: integer;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setcurrencyvalue(value);
 end
 else begin
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
     setfloatprop(instance, propinfo, value);
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
    setfloatprop(ar1[int1],fprops[0].propinfo,value);
   end;
  end;
  modified;
 end;
end;

function tpropeditor.getstringvalue(const index: integer): string;
begin
 if fremote <> nil then begin
  result:= fremote.getstringvalue(index);
 end
 else begin
  with fprops[index] do begin
   result:= decodemsestring(GetstrProp(instance,propinfo));
  end;
 end;
end;

procedure tpropeditor.setstringvalue(const value: string);
var
 int1: integer;
 str1: string;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setstringvalue(value);
 end
 else begin
  str1:= encodemsestring(value);
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
     SetstrProp(Instance, PropInfo, str1);
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
    SetstrProp(ar1[int1], fprops[0].propinfo, str1);
   end;
  end;
  modified;
 end;
end;

function tpropeditor.decodemsestring(const avalue: msestring): msestring;
var
 int1: integer;
 po1: pmsechar;
 mstr1: msestring;
begin
 setlength(result,length(avalue) * 10); //max size
 if length(avalue) > 0 then begin
  po1:= pointer(result);
  for int1:= 1 to length(avalue) do begin
   case avalue[int1] of
    c_tab: begin po1^:= '#'; inc(po1); po1^:= 't'; end;
    c_linefeed: begin po1^:= '#'; inc(po1); po1^:= 'n'; end;
    c_return: begin po1^:= '#'; inc(po1); po1^:= 'r'; end;
    '#': begin po1^:= '#'; inc(po1); po1^:= '#'; end;
    else begin
     if avalue[int1] < widechar(32) then begin
      mstr1:= '#'+inttostr(ord(avalue[int1]));
      if (avalue[int1+1] >= '0') and (avalue[int1+1] <= '9') or 
                     (avalue[int1+1] = ' ') then begin
       mstr1:= mstr1 + ' ';
      end;
      move(mstr1[1],po1^,length(mstr1)*sizeof(widechar));
      inc(po1,length(mstr1)-1);
     end
     else begin
      po1^:= avalue[int1];
     end;
    end;
   end;
   inc(po1)
  end;
  setlength(result,po1-pmsechar(pointer(result)));
 end;
end;

function tpropeditor.encodemsestring(const avalue: msestring): msestring;
var
 int1: integer;
 po1: pmsechar;
 int2: integer;
begin
 setlength(result,length(avalue)); //max
 if length(result) > 0 then begin
  po1:= pointer(result);
  int1:= 1;
  while int1 <= length(avalue) do begin
   if (avalue[int1] = '#') and (int1 < length(avalue)+1) then begin
    case avalue[int1+1] of
     '#': po1^:= '#';
     't': po1^:= c_tab;
     'n': po1^:= c_linefeed;
     'r': po1^:= c_return;
     '0'..'9': begin
      int2:= int1+2;
      while (avalue[int2] >= '0') and (avalue[int2] <= '9') do begin
       inc(int2);
      end;
      po1^:= widechar(strtoint(copy(avalue,int1+1,int2-int1-1)));
      if avalue[int2] = ' ' then begin
       inc(int2);
      end;
      int1:= int2-2;
     end;
     else begin po1^:= '#'; dec(int1); end;
    end;
    inc(int1,2);
   end
   else begin
    po1^:= avalue[int1];
    inc(int1);
   end;
   inc(po1);
  end;
  setlength(result,po1 - pmsechar(pointer(result)));
 end;
end;

function tpropeditor.getmsestringvalue(
  const index: integer): msestring;

begin
 if fremote <> nil then begin
  result:= fremote.getmsestringvalue(index);
 end
 else begin
  with fprops[index] do begin
   result:= decodemsestring(GetwidestrProp(instance,propinfo));     
  end;
 end;
end;

procedure tpropeditor.setmsestringvalue(const value: msestring);
var
 mstr1: msestring;
 int1: integer;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setmsestringvalue(value);
 end
 else begin
  mstr1:= encodemsestring(value);
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
     setwidestrprop(instance,propinfo,mstr1);  
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
    setwidestrprop(ar1[int1],fprops[0].propinfo,mstr1);  
   end;
  end;    
  modified;
 end;
end;

function tpropeditor.getpointervalue(const index: integer): pointer;

begin
 if fremote <> nil then begin
  result:= fremote.getpointervalue(index);
 end
 else begin
  with fprops[index] do begin
{$ifdef CPU64}
   result:= pointer(Getint64Prop(instance,propinfo));
{$else}
   result:= pointer(GetOrdProp(instance,propinfo));
{$endif}
  end;
 end;
end;

procedure tpropeditor.setpointervalue(const value: pointer);
var
 int1: integer;
 ar1: objectarty;
begin
 if fremote <> nil then begin
  fremote.setpointervalue(value);
 end
 else begin
  ar1:= queryselectedpropinstances;
  if ar1 = nil then begin
   for int1:= 0 to high(fprops) do begin
    with fprops[int1] do begin
{$ifdef CPU64}
     setint64prop(instance, propinfo, ptrint(value));
{$else}
     setordprop(instance, propinfo, ptrint(value));
{$endif}
    end;
   end;
  end
  else begin
   for int1:= 0 to high(ar1) do begin
{$ifdef CPU64}
    setint64prop(ar1[int1],fprops[0].propinfo,ptrint(value));
{$else}
    setordprop(ar1[int1],fprops[0].propinfo,ptrint(value));
{$endif}
   end;
  end;
  updatedefaultvalue;
  modified;
 end;
end;

procedure tpropeditor.setpointervalue(const index: integer; const value: pointer);
begin
 if fremote <> nil then begin
  fremote.setpointervalue(index,value);
 end
 else begin
  with fprops[index] do begin
{$ifdef CPU64}
   setint64prop(instance, propinfo, ptrint(value));
{$else}
   setordprop(instance, propinfo, ptrint(value));
{$endif}
  end;
  updatedefaultvalue;
  modified;
 end;
end;

function tpropeditor.getparenteditor: tpropeditor;
begin
 if fremote <> nil then begin
  result:= fremote.getparenteditor;
 end
 else begin
  result:= fparenteditor;
 end;
end;

function tpropeditor.sortlevel: integer;
begin
 result:= fsortlevel;
end;

function tpropeditor.getexpanded: boolean;
begin
 result:= ps_expanded in fstate;
end;

function tpropeditor.getcount: integer;
begin
 result:= length(fprops);
end;

procedure tpropeditor.setexpanded(const Value: boolean);
begin
 if value then begin
  include(fstate,ps_expanded);
 end
 else begin
  exclude(fstate,ps_expanded);
 end;
end;

procedure tpropeditor.modified;
begin
 fobjectinspector.propertymodified(self);
 exclude(fstate,ps_refreshall);
end;

function tpropeditor.subproperties: propeditorarty;
begin
 result:= nil;
end;

procedure tpropeditor.edit;
begin
 //dummy
end;

function tpropeditor.getvalues: msestringarty;
begin
 result:= nil;
end;

procedure tpropeditor.properror;
begin
 raise exception.Create('Wrong property value');
end;

function tpropeditor.getdefaultstate: propertystatesty;
begin
 result:= [];
 if (fparenteditor <> nil) and (ps_subprop in fparenteditor.fstate) then begin
  include(result,ps_subprop);
 end;
end;

procedure tpropeditor.dragbegin(var accept: boolean);
begin
 //dummy
end;

procedure tpropeditor.dragover(const sender: tpropeditor; var accept: boolean);
begin
 //dummy
end;

procedure tpropeditor.dragdrop(const sender: tpropeditor);
begin
 //dummy
end;

procedure tpropeditor.dopopup(var amenu: tpopupmenu; 
          const atransientfor: twidget; var mouseinfo: mouseeventinfoty);
begin
 //dummy
end;

procedure tpropeditor.updatedefaultvalue;
begin
 if (fstate * [ps_isordprop,ps_candefault] = [ps_isordprop,ps_candefault]) and 
        (getordvalue <> fprops[0].propinfo^.default) then begin
  include(fstate,ps_modified);
 end
 else begin
  exclude(fstate,ps_modified);
 end;
end;

function tpropeditor.propertyname: msestring;
begin
 result:= fname;
end;

function tpropeditor.getselected: boolean;
begin
 result:= ps_selected in fstate;
end;

procedure tpropeditor.setselected(const avalue: boolean);
begin
 if avalue and (ps_canselect in fstate) then begin
  include(fstate,ps_selected);
 end
 else begin
  exclude(fstate,ps_selected);
 end;
end;

{ tordinalpropeditor }

function tordinalpropeditor.allequal: boolean;
var
 int1: integer;
 int2: integer;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  int2:= getordvalue;
  for int1:= 1 to high(fprops) do begin
   if int2 <> getordvalue(int1) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

function tordinalpropeditor.getvalue: msestring;
begin
 result:= inttostr(getordvalue);
end;

procedure tordinalpropeditor.setvalue(const value: msestring);
begin
 setordvalue(strtointvalue(value));
end;

function tordinalpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_isordprop,ps_candefault];
end;

{ tcharpropeditor }

procedure tcharpropeditor.setvalue(const value: msestring);
var
 str1: string;
begin
 str1:= encodemsestring(value);
 if str1 = '' then begin
  setordvalue(0);
 end
 else begin
  setordvalue(ord(str1[1]));
 end;
end;

function tcharpropeditor.getvalue: msestring;
var
 int1: integer;
begin
 int1:= getordvalue;
 if int1 = 0 then begin
  result:= '';
 end
 else begin
  result:= decodemsestring(char(int1));
 end;
end;

{ twidecharpropeditor }

procedure twidecharpropeditor.setvalue(const value: msestring);
var
 str1: msestring;
begin
 str1:= encodemsestring(value);
 if str1 = '' then begin
  setordvalue(0);
 end
 else begin
  setordvalue(ord(str1[1]));
 end;
end;

function twidecharpropeditor.getvalue: msestring;
var
 int1: integer;
begin
 int1:= getordvalue;
 if int1 = 0 then begin
  result:= '';
 end
 else begin
  result:= decodemsestring(widechar(int1));
 end;
end;

{ tsetpropeditor }

function tsetpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate  + [ps_subproperties];
end;

function tsetpropeditor.getvalue: msestring;
begin
 {$ifdef FPC}
 result:= '['+concatstrings(settostrings(tintegerset(cardinal(getordvalue)),
      typedata^.comptype),',')+']';
 {$else}
 result:= '['+concatstrings(settostrings(tintegerset(cardinal(getordvalue)),
      typedata^.comptype^),',')+']';
 {$endif}
end;

procedure tsetpropeditor.setvalue(const value: msestring);
var
 str1: string;
 ar1: stringarty;
begin
 str1:= trim(value);
 if (length(str1) > 0) and (str1[1] = '[') then begin
  str1:= copy(str1,2,bigint);
 end;
 if (length(str1) > 0) and (str1[length(str1)] = ']') then begin
  setlength(str1,length(str1)-1);
 end;
 ar1:= nil;
 splitstring(str1,ar1,',',true);
 setordvalue(cardinal(stringstoset(ar1,ftypeinfo)));
end;

function tsetpropeditor.subproperties: propeditorarty;
var
 compty: ptypeinfo;
 int1: integer;
begin
 compty:= gettypedata(ftypeinfo)^.comptype{$ifndef FPC}^{$endif};
 setlength(result,gettypedata(compty)^.MaxValue+1);
 for int1:= 0 to high(result) do begin
  result[int1]:= tsetelementeditor.create(fdesigner,fcomponent,
                    fobjectinspector,fprops,compty,self,int1);
 end;
end;

{ tsetelementeditor }

constructor tsetelementeditor.create(const adesigner: tcomponentdesigner; 
      const acomponent: tcomponent; 
      const aobjectinspector: iobjectinspector; 
      const aprops: propinstancearty; atypeinfo: ptypeinfo; 
      const aparent: tsetpropeditor; const aindex: integer);
begin
 findex:= aindex;
 fparenteditor:= aparent;
 inherited create(adesigner,acomponent,aobjectinspector,aprops,atypeinfo);
 fremote:= aparent.fremote;
end;

function tsetelementeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_valuelist,ps_candefault];
end;

function tsetelementeditor.getvalue: msestring;
begin
 if findex in tintegerset(cardinal(getordvalue)) then begin
  result:= truename;
 end
 else begin
  result:= falsename;
 end;
end;

function tsetelementeditor.allequal: boolean;
var
 int1: integer;
 bo1: boolean;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  bo1:= findex in tintegerset(cardinal(getordvalue));
  for int1:= 1 to high(fprops) do begin
   if bo1 <> (findex in tintegerset(cardinal(getordvalue(int1)))) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

function tsetelementeditor.getvalues: msestringarty;
begin
 setlength(result,2);
 result[0]:= falsename;
 result[1]:= truename;
end;

function tsetelementeditor.name: msestring;
begin
 result:= getenumname(ftypeinfo,findex);
end;

procedure tsetelementeditor.setvalue(const value: msestring);
begin
 setbitvalue(value = truename,findex);
// fparenteditor.modified;
end;

procedure tsetelementeditor.updatedefaultvalue;
begin
 if (fparenteditor.getordvalue xor fparenteditor.fprops[0].propinfo^.default) and
            (1 shl findex) <> 0 then begin
  include(fstate,ps_modified);
 end
 else begin
  exclude(fstate,ps_modified);
 end;
end;

function tsetelementeditor.propertyname: msestring;
begin
 result:= name;
end;

function tsetelementeditor.canrevert: boolean;
begin
 result:= false;
end;

{ tclasspropeditor }

function tclasspropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_subproperties,ps_isordprop];
end;

function tclasspropeditor.checkfreeoptionalclass: boolean;
begin
 result:= askok('Do you wish to destroy ' + fname+' ('+ftypeinfo^.Name+
          ')?','CONFIRMATION');
end;

function tclasspropeditor.getvalue: msestring;

begin
// result:= '('+fprops[0].propinfo^.proptype^.name+')';
 result:= '<'+ftypeinfo^.name+'>';
end;

function tclasspropeditor.subproperties: propeditorarty;
var
 ar1: objectarty;
 int1: integer;
begin
 setlength(ar1,count);
 for int1:= 0 to high(fprops) do begin
  ar1[int1]:= tobject(getordvalue(int1));
 end;
 result:= fobjectinspector.getproperties(ar1,fcomponent);
 for int1:= 0 to high(result) do begin
  result[int1].fparenteditor:= self;
 end;
 if fstate * [ps_component,ps_subprop] <> [] then begin
  for int1:= 0 to high(result) do begin
   include(result[int1].fstate,ps_subprop);
  end;
 end;
end;

{ tcomponentpropeditor }

function tcomponentpropeditor.issubcomponent(const index: integer = 0): boolean;
var
 comp: tcomponent;
begin
 comp:= tcomponent(getordvalue(index));
 if comp = nil then begin
  result:= false;
 end
 else begin
  result:= cssubcomponent in comp.ComponentStyle;
 end;
end;

function tcomponentpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate;
 if not issubcomponent then begin
  result:= result + [ps_valuelist,ps_volatile,ps_component];
 end;
end;

function tcomponentpropeditor.allequal: boolean;
var
 ca1: cardinal;
 int1: integer;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  if issubcomponent then begin
   for int1:= 1 to high(fprops) do begin
    if not issubcomponent(int1) then begin
     result:= false;
     break;
    end;
   end;
  end
  else begin
   ca1:= getordvalue;
   for int1:= 1 to high(fprops) do begin
    if cardinal(getordvalue(int1)) <> ca1 then begin
     result:= false;
     break;
    end;
   end;
  end;
 end;
end;

function tcomponentpropeditor.getvalue: msestring;
var
 comp1: tcomponent;
begin
 if issubcomponent then begin
  result:= inherited getvalue;
 end
 else begin
  comp1:= tcomponent(getordvalue);
  if comp1 = nil then begin
   result:= '<nil>'
  end
  else begin
   result:= comp1.name; //fdesigner.getcomponentname(comp1);
  end;
  if result = '' then begin
   result:= ownernamepath(comp1);
  end;
 end;
end;

function tcomponentpropeditor.getvalues: msestringarty;
var
 co1: tcomponent;
 ar1: componentarty;
 int1,int2: integer;
begin
 ar1:= nil; //compiler warning
 if issubcomponent then begin
  result:= inherited getvalues;
 end
 else begin
  if ps_link in fstate then begin
   ar1:= fdesigner.getcomponentlist(tcomponentclass(typedata^.classtype));
   if ps_local in fstate then begin
    co1:= fcomponent.owner;
    for int1:= high(ar1) downto 0 do begin
     if ar1[int1].owner <> co1 then begin
      ar1[int1]:= nil;
     end;
    end;
   end;

   for int1:= 0 to high(ar1) do begin
    with fdesigner.fselections do begin
     for int2:= count - 1 downto 0 do begin
      if items[int2] = ar1[int1] then begin
       ar1[int1]:= nil; //remove selected components
       break;
      end;
     end;
    end;
   end;
   for int1:= 0 to high(ar1) do begin
    if ar1[int1] <> nil then begin
     additem(result,msestring(ar1[int1].name));
    end;
   end;
  end
  else begin
   result:= fdesigner.getcomponentnamelist(
                  tcomponentclass(typedata^.classtype),true);
  end;
 end;
end;

procedure tcomponentpropeditor.setvalue(const value: msestring);
var
 comp: tcomponent;
 int1,int2: integer;
begin
 if issubcomponent then begin
  inherited setvalue(value);
 end
 else begin
  if value = '' then begin
   comp:= nil;
  end
  else begin
   if value <> getvalue then begin
    int1:= pos('<',value);
    if int1 > 0 then begin
     comp:= fdesigner.fcomponents.getcomponent(copy(value,1,int1-1));
    end
    else begin
     comp:= fdesigner.fcomponents.getcomponent(value);
    end;
    if (comp = nil) or not comp.InheritsFrom(gettypedata(ftypeinfo)^.classtype) then begin
     properror;
    end;
    checkcomponent(comp);
   end
   else begin
    exit;
   end;
  end;
  setordvalue(cardinal(comp));
 end;
end;

procedure tcomponentpropeditor.checkcomponent(const avalue: tcomponent);
begin
 //dummy
end;

function tcomponentpropeditor.filtercomponent(
                               const acomponent: tcomponent): boolean;
begin
 result:= true;
end;

{ tsisterwidgetpropeditor }

function tsisterwidgetpropeditor.getvalues: msestringarty;
var
 ar1: componentarty;
 widget1: twidget;
 int1: integer;
begin
 ar1:= nil; //compiler warning
 if issubcomponent then begin
  result:= inherited getvalues;
 end
 else begin
  result:= nil;
  widget1:= twidget(fcomponent).parentwidget;
  if widget1 <> nil then begin
   ar1:= fdesigner.getcomponentlist(tcomponentclass(typedata^.classtype));
   for int1:= 0 to high(ar1) do begin
    if (twidget(ar1[int1]).parentwidget <> widget1) or 
                  (ar1[int1] = fcomponent) then begin
     ar1[int1]:= nil;
    end;
   end;
   for int1:= 0 to high(ar1) do begin
    if ar1[int1] <> nil then begin
     additem(result,msestring(ar1[int1].name));
    end;
   end;
  end;
 end;
end;

function tsisterwidgetpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_sortlist];
end;

{ tchildwidgetpropeditor }

function tchildwidgetpropeditor.getvalues: msestringarty;
var
 ar1: componentarty;
 widget1: twidget;
 int1: integer;
begin
 ar1:= nil; //compiler warning
 if issubcomponent then begin
  result:= inherited getvalues;
 end
 else begin
  result:= nil;
  widget1:= twidget(fcomponent);
  ar1:= fdesigner.getcomponentlist(tcomponentclass(typedata^.classtype));
  for int1:= 0 to high(ar1) do begin
   if (twidget(ar1[int1]).parentwidget <> widget1) then begin
    ar1[int1]:= nil;
   end;
  end;
  for int1:= 0 to high(ar1) do begin
   if ar1[int1] <> nil then begin
    additem(result,msestring(ar1[int1].name));
   end;
  end;
 end;
end;

function tchildwidgetpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_sortlist];
end;

{ tlocalcomponentpropeditor }

function tlocalcomponentpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_local];
end;

{ tlocallinkcomponentpropeditor }

function tlocallinkcomponentpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_local,ps_link];
end;

{ toptionalclasspropeditor }

function toptionalclasspropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_dialog,ps_volatile];
end;

procedure toptionalclasspropeditor.deleteinstance;
begin
 if checkfreeoptionalclass then begin
  setordvalue(0);
 end;
end;

procedure toptionalclasspropeditor.edit;
var
 obj1: tobject;
begin
 obj1:= getinstance;
 if obj1 = nil then begin
  setordvalue(1);
 end
 else begin
  deleteinstance;
 end;
end;

function toptionalclasspropeditor.getinstance: tpersistent;
begin
 result:= tpersistent(getordvalue);
end;

function toptionalclasspropeditor.getniltext: string;
begin
 result:= '<disabled>';
end;

procedure toptionalclasspropeditor.setvalue(const avalue: msestring);
begin
 if avalue = '' then begin
  deleteinstance;
 end
 else begin
  inherited;
 end;
end;

function toptionalclasspropeditor.getvalue: msestring;
begin
 if getinstance = nil then begin
  result:= getniltext;
 end
 else begin
  result:= inherited getvalue;
 end;
end;

function toptionalclasspropeditor.canrevert: boolean;
begin
 result:= false;
end;

{ tparentclasspropeditor }

procedure tparentclasspropeditor.edit;
var
 obj1: tobject;
 persist1,persist2: tpersistent;
 int1: integer;
begin
  obj1:= getinstance;
  if obj1 = nil then begin
   for int1:= 0 to count - 1 do begin
    persist1:= tpersistent(getordvalue(int1));
    setordvalue(int1,1);
    persist2:= tpersistent(getordvalue(int1));
    if (persist1 <> nil) and (persist2 <> nil) then begin
     persist2.Assign(persist1);
    end;
   end;
  end
  else begin
   if not checkfreeoptionalclass then begin
    exit;
   end;
   setordvalue(0);
  end;
//  modified;
end;

function tparentclasspropeditor.getinstance: tpersistent;
begin
 result:= getinstancepo(instance)^;
end;

function tparentclasspropeditor.getniltext: string;
begin
 result:= '<parent>';
end;

function tparentclasspropeditor.subproperties: propeditorarty;
begin
 if getinstance = nil then begin
  result:= nil;
 end
 else begin
  result:= inherited subproperties;
 end;
end;

{ tparentfontproperty }

function tparentfontpropeditor.getinstancepo(acomponent: tobject): ppersistent;
begin
 result:= ppersistent(parentfontclassty(typedata^.classtype).getinstancepo(acomponent));
end;

{ tstringpropeditor }

function tstringpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_isordprop];
end;

function tstringpropeditor.allequal: boolean;
var
 int1: integer;
 str1: string;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  str1:= getstringvalue;
  for int1:= 1 to high(fprops) do begin
   if str1 <> getstringvalue(int1) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

function tstringpropeditor.getvalue: msestring;
begin
 result:= getstringvalue(0);
end;

procedure tstringpropeditor.setvalue(const value: msestring);
begin
 setstringvalue(value);
end;

{ tmsestringpropeditor }

function tmsestringpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_isordprop,ps_dialog];
end;

function tmsestringpropeditor.allequal: boolean;
var
 int1: integer;
 str1: msestring;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  str1:= getmsestringvalue;
  for int1:= 0 to high(fprops) do begin
   if str1 <> getmsestringvalue(int1) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

function tmsestringpropeditor.getvalue: msestring;
begin
 result:= getmsestringvalue(0);
end;

procedure tmsestringpropeditor.setvalue(const value: msestring);
begin
 setmsestringvalue(value);
end;

procedure tmsestringpropeditor.edit;
var
 mstr1: msestring;
begin
 mstr1:= encodemsestring(getmsestringvalue(0));
 if memodialog(mstr1) = mr_ok then begin
  setmsestringvalue(decodemsestring(mstr1));
 end;
end;

{ tarraypropeditor }

function tarraypropeditor.allequal: boolean;
var
 int1: integer;
 int2: integer;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  int2:= tarrayprop(getordvalue).count;
  for int1:= 1 to high(fprops) do begin
   if int2 <> tarrayprop(getordvalue(int1)).count then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

function tarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= tpropeditor;
end;

function tarraypropeditor.getelementeditorclass: elementeditorclassty;
begin
 result:= tarrayelementeditor;
end;

function tarraypropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_subproperties,ps_volatile];
end;

function tarraypropeditor.getvalue: msestring;
begin
 result:= inttostr(tarrayprop(getordvalue).count);
end;

function tarraypropeditor.name: msestring;
begin
 result:= inherited name +'.count';
end;
{
procedure tarraypropeditor.setmincount(mincount: integer);
begin

end;
}
procedure tarraypropeditor.setvalue(const value: msestring);
var
 int1: integer;
 va: integer;
begin
 va:= strtoint(value);
 if va < 0 then begin
  va:= 0;
 end
 else begin
  if va > propmaxarraycount then begin
   va:= propmaxarraycount;
  end;
 end;
 int1:= tarrayprop(getordvalue).count;
 if ( int1 > va) and not askok('Do you wish to delete items '+inttostr(va) +
         ' to '+ inttostr(int1-1) + '?','CONFIRMATION') then begin
  exit;
 end;
 if not ((ps_noadditems in fstate) and (va > int1)) then begin
  for int1:= 0 to high(fprops) do begin
   tarrayprop(getordvalue(int1)).count:= va;
  end;
  modified;
 end;
end;

function tarraypropeditor.subproperties: propeditorarty;
var
 prop: tarrayprop;
 int1,int2: integer;
begin
 result:= inherited subproperties;
 int2:= 0;
 for int1:= 0 to high(result) do begin
  if result[int1].name = 'count' then begin
   result[int1].Free;
  end
  else begin
   result[int2]:= result[int1];
   inc(int2);
  end;
 end;
 setlength(result,int2);
 prop:= tarrayprop(getordvalue);
 if prop <> nil then begin
  setlength(fsubprops,prop.count);
  for int1:= 0 to high(fsubprops) do begin
   fsubprops[int1]:= getelementeditorclass.create(int1,self,geteditorclass,
          fdesigner,fobjectinspector,fprops,ftypeinfo);
  end;
  stackarray(pointerarty(fsubprops),pointerarty(result));
 end
 else begin
  setlength(result,0);
 end;
end;

procedure tarraypropeditor.itemmoved(const source,dest: integer);
begin
 modified;
end;

procedure tarraypropeditor.dopopup(var amenu: tpopupmenu;
               const atransientfor: twidget; var mouseinfo: mouseeventinfoty);
begin
 if not (ps_noadditems in fstate) then begin
  tpopupmenu.additems(amenu,atransientfor,mouseinfo,
     ['Append Item'],[],[],[{$ifdef FPC}@{$endif}doappend]);
 end;
 inherited;
end;

procedure tarraypropeditor.doappend(const sender: tobject);
begin
 with tarrayprop(getordvalue) do begin
  insertdefault(count);
 end;
 modified;
end;

procedure tarraypropeditor.move(const curindex: integer;
               const newindex: integer);
var
 int1: integer;
begin
 for int1:= 0 to high(fprops) do begin
  tarrayprop(getordvalue(int1)).move(curindex,newindex);
 end;
 itemmoved(curindex,newindex)
end;

{ tarrayelementeditor }

constructor tarrayelementeditor.create(aindex: integer;
            aparenteditor: tarraypropeditor; aeditorclass: propeditorclassty;
            const adesigner: tcomponentdesigner;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypinfo: ptypeinfo);
begin
 findex:= aindex;
 fparenteditor:= aparenteditor;
 feditor:= aeditorclass.create(adesigner,aparenteditor.fcomponent,aobjectinspector,aprops,atypinfo);
 feditor.setremote(iremotepropeditor(self));
 inherited create(adesigner,feditor.fcomponent,
         aobjectinspector,aprops,atypinfo);
end;

destructor tarrayelementeditor.destroy;
begin
 feditor.Free;
 inherited;
end;

function tarrayelementeditor.getordvalue(const index: integer = 0): integer;
begin
 with fprops[index] do begin
  result:= tintegerarrayprop(GetOrdProp1(instance,propinfo))[findex];
 end;
end;

procedure tarrayelementeditor.setordvalue(const value: cardinal);
var
 int1: integer;
begin
 for int1:= 0 to high(fprops) do begin
  with fprops[int1] do begin
   tintegerarrayprop(GetOrdProp1(instance,propinfo))[findex]:= value;
  end;
 end;
 modified;
end;

procedure tarrayelementeditor.setordvalue(const index: integer; 
                         const value: cardinal);
begin
 with fprops[index] do begin
  tintegerarrayprop(GetOrdProp1(instance,propinfo))[findex]:= value;
 end;
 modified;
end;

procedure tarrayelementeditor.setbitvalue(const value: boolean;
               const bitindex: integer);
var
 int1: integer;
 wo1: cardinal;
begin
 for int1:= 0 to high(fprops) do begin
  with fprops[int1] do begin
   wo1:= cardinal(tsetarrayprop(GetOrdProp1(instance,propinfo))[findex]);
   updatebit(wo1,bitindex,value);
   tsetarrayprop(GetOrdProp1(instance,propinfo))[findex]:= tintegerset(wo1);
  end;
 end;
 modified;
end;

function tarrayelementeditor.getfloatvalue(const index: integer = 0): extended;
begin
 with fprops[index] do begin
  result:= trealarrayprop(GetOrdProp1(instance,propinfo))[findex];
 end;
end;

procedure tarrayelementeditor.setfloatvalue(const value: extended);
var
 int1: integer;
begin
 for int1:= 0 to high(fprops) do begin
  with fprops[int1] do begin
   trealarrayprop(GetOrdProp1(instance,propinfo))[findex]:= value;
  end;
 end;
 modified;
end;

function tarrayelementeditor.getstringvalue(const index: integer = 0): string;
begin
 with fprops[index] do begin
  result:= tstringarrayprop(GetOrdProp1(instance,propinfo))[findex];
 end;
end;

procedure tarrayelementeditor.setstringvalue(const value: string);
var
 int1: integer;
begin
 for int1:= 0 to high(fprops) do begin
  with fprops[int1] do begin
   tstringarrayprop(GetOrdProp1(instance,propinfo))[findex]:= value;
  end;
 end;
 modified;
end;

function tarrayelementeditor.getmsestringvalue(const index: integer = 0): msestring;
begin
 with fprops[index] do begin
  result:= tmsestringarrayprop(GetOrdProp1(instance,propinfo))[findex];
 end;
end;

procedure tarrayelementeditor.setmsestringvalue(const value: msestring);
var
 int1: integer;
begin
 for int1:= 0 to high(fprops) do begin
  with fprops[int1] do begin
   tmsestringarrayprop(GetOrdProp1(instance,propinfo))[findex]:= value;
  end;
 end;
 modified;
end;

function tarrayelementeditor.name: msestring;
begin
 result:= 'Item ' + inttostr(findex);
end;

function tarrayelementeditor.subproperties: propeditorarty;
begin
 result:= feditor.subproperties;
end;

procedure tarrayelementeditor.dragbegin(var accept: boolean);
begin
 accept:= true;
end;

procedure tarrayelementeditor.dragdrop(const sender: tpropeditor);
begin
 if (sender is tarrayelementeditor) and
      (tarrayelementeditor(sender).fparenteditor = fparenteditor) then begin
  tarraypropeditor(fparenteditor).move(tarrayelementeditor(sender).findex,
                        findex);
 end;
end;

procedure tarrayelementeditor.dragover(const sender: tpropeditor;
  var accept: boolean);
begin
 accept:= (sender is tarrayelementeditor) and
      (tarrayelementeditor(sender).fparenteditor = fparenteditor);
end;

procedure tarrayelementeditor.dodelete(const sender: tobject);
begin
 if askyesno('Do you wish to delete '+getvalue+'?','CONFIRMATION') then begin
  tarrayprop(fparenteditor.getordvalue).delete(findex);
  fparenteditor.modified;
  if fdesigner<>nil then fdesigner.selectcomponent(fcomponent);
 end;
end;

procedure tarrayelementeditor.doinsert(const sender: tobject);
begin
 tarrayprop(fparenteditor.getordvalue).insertdefault(findex);
 fparenteditor.modified;
 if fdesigner<>nil then fdesigner.selectcomponent(fcomponent);
end;

procedure tarrayelementeditor.doappend(const sender: tobject);
begin
 tarrayprop(fparenteditor.getordvalue).insertdefault(findex+1);
 fparenteditor.modified;
 if fdesigner<>nil then fdesigner.selectcomponent(fcomponent);
end;

procedure tarrayelementeditor.docopy(const sender: tobject);
begin
 fdesigner.fcopyproperty:= tpersistentarrayprop(fparenteditor.getordvalue).items[findex];
end;

procedure tarrayelementeditor.dopaste(const sender: tobject);
begin
 if fdesigner.fcopyproperty<>nil then begin
  tpersistentarrayprop1(fparenteditor.getordvalue).checkindex(findex);
  tpersistent(tpersistentarrayprop(fparenteditor.getordvalue).items[findex]).assign(fdesigner.fcopyproperty);
  fparenteditor.modified;
  if fdesigner<>nil then fdesigner.selectcomponent(fcomponent);
 end;
end;

procedure tarrayelementeditor.dopopup(var amenu: tpopupmenu;
                const atransientfor: twidget; var mouseinfo: mouseeventinfoty);
begin
 if not (ps_noadditems in fparenteditor.fstate) then begin
  tpopupmenu.additems(amenu,atransientfor,mouseinfo,
     ['Insert Item','Append Item','Delete Item','Copy'],[],[],
     [{$ifdef FPC}@{$endif}doinsert,
     {$ifdef FPC}@{$endif}doappend,{$ifdef FPC}@{$endif}dodelete,{$ifdef FPC}@{$endif}docopy]);
  if fdesigner.fcopyproperty<>nil then begin
   tpopupmenu.additems(amenu,atransientfor,mouseinfo,
      ['Paste'],[],[],
      [{$ifdef FPC}@{$endif}dopaste]);
  end;
 end
 else begin
  if not (ps_nodeleteitems in fparenteditor.fstate) then begin
   tpopupmenu.additems(amenu,atransientfor,mouseinfo,
     ['Delete Item'],[],[],
     [{$ifdef FPC}@{$endif}dodelete]);
  end;
 end;
 inherited;
end;

{ tconstarraypropeditor }

function tconstarraypropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + 
         [ps_subproperties,ps_noadditems,ps_nodeleteitems{,ps_volatile}];
end;

function tconstarraypropeditor.getvalue: msestring;
begin
 result:= ''
end;

procedure tconstarraypropeditor.setvalue(const value: msestring);
begin
 //dummy
end;

function tconstarraypropeditor.name: msestring;
begin
 result:= fname;
end;

function tconstarraypropeditor.allequal: boolean;
begin
 result:= false;
end;

procedure tarrayelementeditor.edit;
begin
 feditor.edit;
end;

function tarrayelementeditor.getdefaultstate: propertystatesty;
begin
 result:= feditor.getdefaultstate{ + [ps_volatile]};
end;

function tarrayelementeditor.getvalue: msestring;
begin
 result:= feditor.getvalue;
end;

function tarrayelementeditor.getvalues: msestringarty;
begin
 result:= feditor.getvalues;
end;

procedure tarrayelementeditor.setvalue(const value: msestring);
begin
 feditor.setvalue(value);
end;

function tarrayelementeditor.canrevert: boolean;
begin
 result:= false;
end;

function tarrayelementeditor.getselectedpropinstances: objectarty;
var
 int1,int2: integer;
begin
 with tarraypropeditor(fparenteditor) do begin
  setlength(result,length(fsubprops));
  int2:= 0;
  for int1:= 0 to high(fsubprops) do begin
   if fsubprops[int1].selected then begin
    result[int2]:= tobject(fsubprops[int1].feditor.getordvalue);
    inc(int2);
   end;
  end;
  setlength(result,int2);
 end;
end;

{ tpersistentarraypropeditor }

function tpersistentarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= tclasselementeditor;
end;

{ toptionalpersistentarraypropeditor }

function toptionalpersistentarraypropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_dialog,ps_volatile];
end;

procedure toptionalpersistentarraypropeditor.edit;
var
 obj1: tobject;
begin
 obj1:= getinstance;
 if obj1 = nil then begin
  setordvalue(1);
 end
 else begin
  if not checkfreeoptionalclass then begin
   exit;
  end;
  setordvalue(0);
 end;
 modified;
end;

function toptionalpersistentarraypropeditor.getinstance: tpersistent;
begin
 result:= tpersistent(getordvalue);
end;

function toptionalpersistentarraypropeditor.getniltext: string;
begin
 result:= '<disabled>';
end;

function toptionalpersistentarraypropeditor.getvalue: msestring;
begin
 if getinstance = nil then begin
  result:= getniltext;
 end
 else begin
  result:= inherited getvalue;
 end;
end;

procedure toptionalpersistentarraypropeditor.setvalue(const value: msestring);
begin
 if getordvalue <> 0 then begin
  inherited;
 end;
end;

{ tintegerarraypropeditor }

function tintegerarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= tordinalpropeditor;
end;

{ tsetarrayelementeditor }

constructor tsetarrayelementeditor.create(aindex: integer;
               aparenteditor: tarraypropeditor;
               aeditorclass: propeditorclassty; const adesigner: tcomponentdesigner;
               const aobjectinspector: iobjectinspector;
               const aprops: propinstancearty; atypinfo: ptypeinfo);
begin
 inherited;
 feditor.ftypeinfo:= tsetarrayprop(aparenteditor.getordvalue).typeinfo;
end;

{ tsetarraypropeditor }

function tsetarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= tsetpropeditor;
end;

function tsetarraypropeditor.getelementeditorclass: elementeditorclassty;
begin
 result:= tsetarrayelementeditor;
end;

{ trealarraypropeditor}

function trealarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= trealtypropeditor;
end;

{ tcolorarraypropeditor }

function tcolorarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= tcolorpropeditor;
end;

{ tstringarraypropeditor }

function tstringarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= tstringpropeditor;
end;

{ tmsestringarraypropeditor }

function tmsestringarraypropeditor.geteditorclass: propeditorclassty;
begin
 result:= tmsestringpropeditor;
end;

{ tlclasselementdesigner }

function tclasselementeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_canselect];
end;

function tclasselementeditor.getvalue: msestring;
var
 obj1: tobject;
begin
 obj1:= tobject(getordvalue);
 if obj1 = nil then begin
  result:= '<nil>';
 end
 else begin
  result:= '<'+obj1.classtype.classname+'>';
 end;
end;

{ tcllectionitemdesigner }

constructor tcollectionitemeditor.create(aindex: integer; 
            aparenteditor: tcollectionpropeditor;
            aeditorclass: propeditorclassty;
            const adesigner: tcomponentdesigner;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypinfo: ptypeinfo);
var
 props1: propinstancearty;
 int1: integer;
begin
 setlength(props1,length(aprops));
 for int1:= 0 to high(props1) do begin
  props1[int1].propinfo:= aprops[int1].propinfo;
  props1[int1].instance:= 
     tcollection(aparenteditor.getordvalue(int1)).items[aindex];
 end;
 findex:= aindex;
 fparenteditor:= aparenteditor;
 feditor:= aeditorclass.create(adesigner,aparenteditor.fcomponent,aobjectinspector,props1,atypinfo);
 feditor.setremote(iremotepropeditor(self));
 inherited create(adesigner,feditor.fcomponent,
         aobjectinspector,aprops,atypinfo);
end;

destructor tcollectionitemeditor.destroy;
begin
 feditor.free;
 inherited;
end;

procedure tcollectionitemeditor.setvalue(const value: msestring);
begin
 feditor.setvalue(value);
end;

function tcollectionitemeditor.getvalue: msestring;
begin
 result:= feditor.getvalue;
end;

function tcollectionitemeditor.getvalues: msestringarty;
begin
 result:= feditor.getvalues;
end;

procedure tcollectionitemeditor.edit;
begin
 feditor.edit;
end;

function tcollectionitemeditor.subproperties: propeditorarty;
begin
 result:= feditor.subproperties;
end;

function tcollectionitemeditor.name: msestring;
begin
 result:= 'Item '+inttostr(findex);
end;

function tcollectionitemeditor.getordvalue(const index: integer = 0): integer;
begin
 result:= integer(tcollection(fparenteditor.getordvalue(index)).items[findex]);
end;

procedure tcollectionitemeditor.setordvalue(const value: cardinal);
begin
 //dummy
end;

procedure tcollectionitemeditor.setordvalue(const index: integer; 
                               const value: cardinal);
begin
 //dummy
end;

procedure tcollectionitemeditor.doinsert(const sender: tobject);
begin
 tcollection(fparenteditor.getordvalue).insert(findex);
 fparenteditor.modified;
end;

procedure tcollectionitemeditor.doappend(const sender: tobject);
begin
 tcollection(fparenteditor.getordvalue).insert(findex+1);
 fparenteditor.modified;
end;

procedure tcollectionitemeditor.dodelete(const sender: tobject);
begin
 tcollection(fparenteditor.getordvalue).delete(findex);
 fparenteditor.modified;
end;

function tcollectionitemeditor.getdefaultstate: propertystatesty;
begin
 result:= feditor.getdefaultstate;
end;

procedure tcollectionitemeditor.dragbegin(var accept: boolean);
begin
 accept:= true;
end;

procedure tcollectionitemeditor.dragover(const sender: tpropeditor; 
                                     var accept: boolean);
begin
 accept:= (sender is tcollectionitemeditor) and
      (tcollectionitemeditor(sender).fparenteditor = fparenteditor);
end;

procedure tcollectionitemeditor.dragdrop(const sender: tpropeditor);
var
 source: integer;
begin
 if (sender is tcollectionitemeditor) and
      (tcollectionitemeditor(sender).fparenteditor = fparenteditor) then begin
  source:= tcollectionitemeditor(sender).findex;
  tcollection(fparenteditor.getordvalue).items[source].index:= findex;
//  sender.modified;
//  modified;
  tcollectionpropeditor(fparenteditor).itemmoved(source,findex);
 end;
end;

procedure tcollectionitemeditor.dopopup(var amenu: tpopupmenu; const atransientfor: twidget;
                       var mouseinfo: mouseeventinfoty);
begin
 tpopupmenu.additems(amenu,atransientfor,mouseinfo,
    ['Insert Item','Append Item','Delete Item'],[],[],
    [{$ifdef FPC}@{$endif}doinsert,
    {$ifdef FPC}@{$endif}doappend,{$ifdef FPC}@{$endif}dodelete]);
 inherited;
end;

function tcollectionitemeditor.getselectedpropinstances: objectarty;
begin
 result:= nil;
end;

{ tcollectionpropeditor }

function tcollectionpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_subproperties,ps_volatile];
end;

function tcollectionpropeditor.name: msestring;
begin
 result:= inherited name +'.count';
end;

function tcollectionpropeditor.getvalue: msestring;
var
 col1: tcollection;
begin
 col1:= tcollection(getordvalue);
 if col1 <> nil then begin
  result:= inttostr(col1.count);
 end
 else begin
  result:= '<nil>';
 end;
end;

procedure tcollectionpropeditor.setvalue(const value: msestring);
var
 int1,int2: integer;
 va: integer;
 col1: tcollection;
begin
 col1:= tcollection(getordvalue);
 if col1 <> nil then begin
  va:= strtoint(value);
  if va < 0 then begin
   va:= 0;
  end
  else begin
   if va > propmaxarraycount then begin
    va:= propmaxarraycount;
   end;
  end;
  int1:= col1.count;
  if ( int1 > va) then begin
   if askok('Do you wish to delete items '+inttostr(va) +
          ' to '+ inttostr(int1-1) + '?','CONFIRMATION') then begin
    for int2:= int1 - 1 downto va do begin
     col1.items[int2].free;
    end;
   end
   else begin
    exit;
   end;
  end
  else begin
   for int1:= 0 to high(fprops) do begin
    with tcollection(getordvalue(int1)) do begin
     for int2:= count to va - 1 do begin
      add;
     end;
    end;
   end;
  end;
  modified;
 end;
end;

function tcollectionpropeditor.subproperties: propeditorarty;
var
 col1: tcollection;
 itemtypeinfo: ptypeinfo;
 edtype: propeditorclassty; 
 int1: integer;
begin
 col1:= tcollection(getordvalue);
 if col1 <> nil then begin
  setlength(result,col1.count);
  itemtypeinfo:= ptypeinfo(col1.itemclass.classinfo);
  edtype:= propeditors.geteditorclass(itemtypeinfo,fcomponent.classtype,fname);
  for int1:= 0 to high(result) do begin
   result[int1]:= tcollectionitemeditor.create(int1,self,edtype,fdesigner,
            fobjectinspector,fprops,itemtypeinfo);
  end;
 end
 else begin
  result:= nil;
 end;
end;

procedure tcollectionpropeditor.dopopup(var amenu: tpopupmenu;
               const atransientfor: twidget; var mouseinfo: mouseeventinfoty);
begin
 if not (ps_noadditems in fstate) then begin
  tpopupmenu.additems(amenu,atransientfor,mouseinfo,
     ['Append Item'],[],[],[{$ifdef FPC}@{$endif}doappend]);
 end;
 inherited;
end;

procedure tcollectionpropeditor.doappend(const sender: tobject);
begin
 with tcollection(getordvalue) do begin
  insert(count);
 end;
 modified;
end;

procedure tcollectionpropeditor.itemmoved(const source: integer;
               const dest: integer);
begin
 modified;
end;

{ tenumpropeditor }

function tenumpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_valuelist];
end;

function tenumpropeditor.getvalue: msestring;
begin
 result:= getenumname(gettypeinfo,getordvalue);
end;

procedure tenumpropeditor.setvalue(const value: msestring);
begin
 setordvalue(getenumvalue(gettypeinfo,value));
end;

function tenumpropeditor.getvalues: msestringarty;
var
 typedata1: ptypedata;
 atypeinfo: ptypeinfo;
begin
 atypeinfo:= gettypeinfo;
 typedata1:= gettypedata(atypeinfo);
 with typedata1^ do begin
  if minvalue < 0 then begin //for boolean
   setlength(result,2);
   result[0]:= getenumname(atypeinfo,0);
   result[1]:= getenumname(atypeinfo,1);
  end
  else begin
   result:= getenumnames(atypeinfo);
  end;
 end;
end;

function tenumpropeditor.gettypeinfo: ptypeinfo;
begin
 result:= ftypeinfo;
end;

{ tfontnamepropeditor }

function tfontnamepropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_valuelist,ps_sortlist];
end;

function tfontnamepropeditor.getvalues: msestringarty;
begin
 result:= getenumnames(typeinfo(stockfontty));
 stackarray(fontaliasnames,result);
end;

{ tbooleanpropeditor }

function tbooleanpropeditor.getdefaultstate: propertystatesty;
begin
 Result:= inherited getdefaultstate  + [ps_valuelist];
end;

procedure tbooleanpropeditor.setvalue(const value: msestring);
begin
 setordvalue(cardinal(uppercase(trim(value)) = uppercase(truename)));
end;

function tbooleanpropeditor.getvalue: msestring;
begin
 if getordvalue <> 0 then begin
  result:= truename;
 end
 else begin
  result:= falsename;
 end;
end;

function tbooleanpropeditor.getvalues: msestringarty;
begin
 setlength(result,2);
 result[0]:= falsename;
 result[1]:= truename;
end;

{ tdialogclasspropeditor }

function tdialogclasspropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_dialog,ps_volatile];
end;

{ tbitmappropeditor }

procedure tbitmappropeditor.edit;
var
 bmp,bmp1: tmaskedbitmap;
 int1: integer;
 dialog: tfiledialog;
 statfile1: tstatfile;
begin
 statfile1:= tstatfile.create(nil);
 dialog:= tfiledialog.create(nil);
 try
  statfile1.options:= [sfo_memory];
  statfile1.filename:= bmpfiledialogstatname;
  with dialog,controller do begin
   filterlist.asarraya:= graphicfilefilternames;
   filterlist.asarrayb:= graphicfilemasks;
   captionopen:= 'Open image file';
   statfile:= statfile1;
   statfile.readstat;
   filename:= filedir(filename);
   if execute = mr_ok then begin
    statfile.writestat;
    bmp:= tmaskedbitmap.create(false);
    try
     bmp.loadfromfile(filename,graphicfilefilterlabel(filterindex));
     for int1:= 0 to high(fprops) do begin
      bmp1:= tmaskedbitmap(getordvalue(int1));
      if bmp1 <> nil then begin
       bmp.alignment:= bmp1.alignment;
       bmp.colorbackground:= bmp1.colorbackground;
       bmp.colorforeground:= bmp1.colorforeground;
       bmp.transparency:= bmp1.transparency;
       bmp.transparentcolor:= bmp1.transparentcolor;
      end;
      setordvalue(int1,ptruint(bmp));
     end;
     modified;
    finally
     bmp.Free;
    end;
   end;
  end;
 finally
  dialog.free;
  statfile1.free;
 end;
end;

function tbitmappropeditor.getvalue: msestring;
begin
 with tmaskedbitmap(getordvalue) do begin
  if source <> nil then begin
   result:= source.name; //fdesigner.getcomponentname(source);
  end
  else begin
   if isempty then begin
    result:= '<empty>';
   end
   else begin
    result:= inherited getvalue;
   end;
  end;
 end;
end;

procedure tbitmappropeditor.setvalue(const value: msestring);
var
 int1: integer;
begin
 if value = '' then begin
  for int1:= 0 to high(fprops) do begin
   tmaskedbitmap(getordvalue(int1)).clear;
  end;
  modified;
 end;
end;

{ trealpropeditor }

function trealpropeditor.allequal: boolean;
var
 int1: integer;
 rea1: real;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  rea1:= getfloatvalue;
  for int1:= 1 to high(fprops) do begin
   if rea1 <> getfloatvalue(int1) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

procedure trealpropeditor.setvalue(const value: msestring);
begin
 setfloatvalue(strtoreal(value));
end;

function trealpropeditor.getvalue: msestring;
begin
 result:= realtostr(getfloatvalue);
end;

{ tcurrencypropeditor }

function tcurrencypropeditor.allequal: boolean;
var
 int1: integer;
 cu1: currency;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  cu1:= getcurrencyvalue;
  for int1:= 1 to high(fprops) do begin
   if cu1 <> getcurrencyvalue(int1) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

procedure tcurrencypropeditor.setvalue(const value: msestring);
begin
 setcurrencyvalue(strtoreal(value));
end;

function tcurrencypropeditor.getvalue: msestring;
begin
 result:= realtostr(getcurrencyvalue);
end;

{ trealtypropeditor }

function trealtypropeditor.allequal: boolean;
var
 int1: integer;
 rea1: real;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  rea1:= getfloatvalue;
  for int1:= 1 to high(fprops) do begin
   if rea1 <> getfloatvalue(int1) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

function trealtypropeditor.getvalue: msestring;
begin
 result:= realtytostr(getfloatvalue);
end;

procedure trealtypropeditor.setvalue(const value: msestring);
begin
 setfloatvalue(strtorealty(value));
end;

{ tdatetimepropeditor }

function tdatetimepropeditor.allequal: boolean;
var
 int1: integer;
 rea1: real;
begin
 result:= inherited allequal;
 if not result then begin
  result:= true;
  rea1:= getfloatvalue;
  for int1:= 1 to high(fprops) do begin
   if rea1 <> getfloatvalue(int1) then begin
    result:= false;
    break;
   end;
  end;
 end;
end;

function tdatetimepropeditor.getvalue: msestring;
begin
 result:= datetimetostring(getfloatvalue,'dddddd t');
end;

procedure tdatetimepropeditor.setvalue(const value: msestring);
begin
 setfloatvalue(stringtodatetime(value));
end;

 { tcolorpropeditorty}

function tcolorpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_dialog];
end;

procedure tcolorpropeditor.edit;
var
 col1: colorty;
begin
 col1:= getordvalue;
 if colordialog(col1) = mr_ok then begin
  setordvalue(col1);
 end;
end;

function tcolorpropeditor.getvalue: msestring;
begin
 result:= colortostring(getordvalue);
end;

function tcolorpropeditor.getvalues: msestringarty;
begin
 result:= getcolornames;
end;

procedure tcolorpropeditor.setvalue(const value: msestring);
begin
 setordvalue(stringtocolor(value));
end;

{ tstringspropeditor }

procedure tstringspropeditor.closequery(const sender: tcustommseform; var amodalresult: modalresultty);
var
 int1: integer;
begin
 if amodalresult = mr_ok then begin
  try
   with tstringlisteditor(sender),tstrings(getordvalue) do begin
    beginupdate;
    try
     clear;
     for int1:= 0 to grid.rowcount-1 do begin
      Add(valueedit[int1]);
     end;
    finally
     endupdate
    end;
   end;
   modified;
  except
   application.handleexception(nil);
   amodalresult:= mr_none;
  end;
 end;
end;

procedure tstringspropeditor.edit;
var
 editform: tstringlisteditor;
 int1: integer;
 strings: tstrings;
begin
 strings:= tstrings(getordvalue);
 editform:= tstringlisteditor.create({$ifdef FPC}@{$endif}closequery);
 try
  with editform do begin
   grid.rowcount:= strings.Count;
   for int1:= 0 to strings.Count - 1 do begin
    valueedit[int1]:= strings[int1];
   end;
   show(true,nil);
  end;
 finally
  editform.Free;
 end;
end;

function tstringspropeditor.getvalue: msestring;
begin
 if tstrings(getordvalue).count = 0 then begin
  result:= '<empty>';
 end
 else begin
  result:= inherited getvalue;
 end;
end;

{ ttextstringspropeditor }

procedure ttextstringspropeditor.closequery(const sender: tcustommseform; 
             var amodalresult: modalresultty);
var
 int1: integer;
 utf8: boolean;
 str1: ansistring;
begin
 fmodalresult:= amodalresult;
 forigtext:= nil;
 if (amodalresult = mr_ok) or (amodalresult = mr_canclose) then begin
  try
   with tmsetexteditorfo(sender) do begin
    forigtext:= textedit.datalist.asmsestringarray;
    if ismsestring then begin
     with tmsestringdatalist(getordvalue) do begin
      beginupdate;
      try
       clear;
       for int1:= 0 to grid.rowcount-1 do begin
        add(textedit[int1]);
       end;
      finally
       endupdate
      end;
     end;
    end
    else begin
     with tstrings(getordvalue) do begin
      utf8:= getutf8;
      beginupdate;
      try
       clear;
       for int1:= 0 to grid.rowcount-1 do begin
        if utf8 then begin
         str1:= stringtoutf8(textedit[int1]);
        end
        else begin
         str1:= textedit[int1];
        end;
        updateline(str1);
        add(str1);
       end;
      finally
       endupdate
      end;
     end;
    end;
   end;
   doafterclosequery(amodalresult);
  except
   application.handleexception(nil);
   amodalresult:= mr_none;
  end;
 end;
end;

procedure ttextstringspropeditor.edit;
var
 editform: tmsetexteditorfo;
 int1: integer;
 strings: tstrings;
 mstrings: tmsestringdatalist;
 utf8: boolean;
begin
 fmodalresult:= mr_cancel;
 editform:= tmsetexteditorfo.create({$ifdef FPC}@{$endif}closequery,
        msetexteditor.syntaxpainter,getsyntaxindex,gettestbutton);
 editform.textedit.createfont;
 editform.textedit.font.assign(textpropertyfont);
 utf8:= getutf8;
 try
  with editform do begin
   caption:= getcaption;
   if ismsestring then begin
    mstrings:= tmsestringdatalist(getordvalue);
    grid.rowcount:= mstrings.Count;
    for int1:= 0 to mstrings.Count - 1 do begin
     textedit[int1]:= mstrings[int1];
    end;
   end
   else begin
    strings:= tstrings(getordvalue);
    grid.rowcount:= strings.Count;
    for int1:= 0 to strings.Count - 1 do begin
     if utf8 then begin
      textedit[int1]:= utf8tostring(strings[int1]);
     end
     else begin
      textedit[int1]:= strings[int1];
     end;
    end;
   end;
   show(true,nil);
   modified;
  end;
 finally
  editform.Free;
 end;
end;

function ttextstringspropeditor.getvalue: msestring;
begin
 if ismsestring then begin
  if tmsestringdatalist(getordvalue).count = 0 then begin
   result:= '<empty>';
  end
  else begin
   result:= inherited getvalue;
  end;
 end
 else begin
  if tstrings(getordvalue).count = 0 then begin
   result:= '<empty>';
  end
  else begin
   result:= inherited getvalue;
  end;
 end;
end;

function ttextstringspropeditor.getsyntaxindex: integer;
begin
 result:= -1;
end;

procedure ttextstringspropeditor.doafterclosequery(var amodalresult: modalresultty);
begin
 //dummy
end;

function ttextstringspropeditor.gettestbutton: boolean;
begin
 result:= false;
end;

function ttextstringspropeditor.getutf8: boolean;
begin
 result:= false;
end;

procedure ttextstringspropeditor.setvalue(const avalue: msestring);
begin
 if (avalue = '') and askok('Do you wish to clear "'+fname+'"?') then begin
  if ismsestring then begin
   tmsestringdatalist(getordvalue).clear;
  end
  else begin
   tstrings(getordvalue).clear;
  end;
 end;
 inherited;
end;

function ttextstringspropeditor.getcaption: msestring;
begin
 result:= 'Textdesigner';
end;

procedure ttextstringspropeditor.updateline(var aline: ansistring);
begin
 //dummy
end;

function ttextstringspropeditor.ismsestring: boolean;
begin
 result:= false;
end;

{ tdatalistpropeditor }

procedure tdatalistpropeditor.checkformkind;
var
 datalist1: tdatalist;
begin
 formkind:= lfk_none;
 datalist1:= tdatalist(getordvalue);
 if datalist1 is tmsestringdatalist then begin
  formkind:= lfk_msestring;
 end
 else begin
  if datalist1 is trealdatalist then begin
   formkind:= lfk_real;
  end
  else begin
   if datalist1 is tintegerdatalist then begin
    formkind:= lfk_integer;
   end;
  end;
 end;
end;

procedure tdatalistpropeditor.edit;
var
 editform: tcustommseform;
begin
 checkformkind;
 case formkind of
  lfk_msestring: begin
   editform:= tstringlisteditor.create({$ifdef FPC}@{$endif}closequery);
  end;
  lfk_real: begin
   editform:= treallisteditor.create({$ifdef FPC}@{$endif}closequery);
  end;
  lfk_integer: begin
   editform:= tintegerlisteditor.create({$ifdef FPC}@{$endif}closequery);
  end;
  else begin
   editform:= nil;
  end;
 end;
 try
  if editform <> nil then begin
   case formkind of
    lfk_msestring: begin
     tstringlisteditor(editform).valueedit.datalist.assign(tmsestringdatalist(getordvalue));
    end;
    lfk_real: begin
     treallisteditor(editform).valueedit.griddata.assign(trealdatalist(getordvalue));
    end;
    lfk_integer: begin
     tintegerlisteditor(editform).valueedit.griddata.assign(tintegerdatalist(getordvalue));
    end;
   end;
   editform.show(true,nil);
  end;
 finally
  editform.Free;
 end;
end;

function tdatalistpropeditor.getvalue: msestring;
var
 datalist1: tdatalist;
begin
 datalist1:= tdatalist(getordvalue);
 if datalist1 = nil then begin
  result:= '<nil>';
 end
 else begin
  if datalist1.count = 0 then begin
   result:= '<empty>';
  end
  else begin
   result:= '<'+datalist1.classname+'>';
  end;
 end;
end;

procedure tdatalistpropeditor.closequery(const sender: tcustommseform;
               var amodalresult: modalresultty);
var
 datalist1: tdatalist;
 int1: integer;
begin
 if amodalresult = mr_ok then begin
  try
   for int1:= 0 to high (fprops) do begin
    datalist1:= tdatalist(getordvalue(int1));
    case formkind of
     lfk_msestring: begin
      tmsestringdatalist(datalist1).assign(
                   tstringlisteditor(sender).valueedit.datalist);
     end;
     lfk_real: begin
      trealdatalist(datalist1).assign(
                    treallisteditor(sender).valueedit.griddata);
     end;
     lfk_integer: begin
      tintegerdatalist(datalist1).assign(
                    tintegerlisteditor(sender).valueedit.griddata);
     end;
    end;
    modified;
   end;
  except
   application.handleexception(nil);
   amodalresult:= mr_none;
  end;
 end;
end;

{ tmsestringdatalistpropeditor }

procedure tmsestringdatalistpropeditor.closequery(const sender: tcustommseform;
                       var amodalresult: modalresultty);
var
 int1: integer;
begin
 if amodalresult = mr_ok then begin
  for int1:= 0 to high(fprops) do begin
   try
    tmsestringdatalist(getordvalue(int1)).assign(
                   tstringlisteditor(sender).valueedit.datalist);
    modified;
   except
    application.handleexception(nil);
    amodalresult:= mr_none;
   end;
  end;
 end;
end;

procedure tmsestringdatalistpropeditor.edit;
var
 editform: tstringlisteditor;
begin
 editform:= tstringlisteditor.create({$ifdef FPC}@{$endif}closequery);
 try
  with editform do begin
   valueedit.datalist.assign(tmsestringdatalist(getordvalue));
   show(true,nil);
  end;
 finally
  editform.Free;
 end;
end;

function tmsestringdatalistpropeditor.getvalue: msestring;
begin
 if tmsestringdatalist(getordvalue).count = 0 then begin
  result:= '<empty>';
 end
 else begin
  result:= inherited getvalue;
 end;
end;

{ tdoublemsestringdatalistpropeditor }

procedure tdoublemsestringdatalistpropeditor.closequery(
          const sender: tcustommseform; var amodalresult: modalresultty);
var
 list: tdoublemsestringdatalist;
begin
 if amodalresult = mr_ok then begin
  try
   with tdoublestringlisteditor(sender) do begin
    list:= tdoublemsestringdatalist.create;
    try
     list.assign(texta.griddata);
     list.assignb(textb.griddata);
     tdoublemsestringdatalist(getordvalue).assign(list);
     modified;
    finally
     list.Free;
    end;
   end;
  except
   application.handleexception(nil);
   amodalresult:= mr_none;
  end;
 end;
end;

procedure tdoublemsestringdatalistpropeditor.edit;
var
 editform: tdoublestringlisteditor;
begin
 editform:= tdoublestringlisteditor.create({$ifdef FPC}@{$endif}closequery);
 try
  with editform do begin
   texta.assigncol(tmsestringdatalist(getordvalue));
   tdoublemsestringdatalist(getordvalue).assigntob(textb.griddata);
   show(true,nil);
  end;
 finally
  editform.Free;
 end;
end;

function tdoublemsestringdatalistpropeditor.getvalue: msestring;
begin
 if tdoublemsestringdatalist(getordvalue).count = 0 then begin
  result:= '<empty>';
 end
 else begin
  result:= inherited getvalue;
 end;
end;

{ trecordpropeditor }

constructor trecordpropeditor.create(const adesigner: tcomponentdesigner;
  const acomponent: tcomponent;
  const aobjectinspector: iobjectinspector; const aname: string;
  const subprops: propeditorarty);
var
 int1: integer;
begin
 inherited create(adesigner,acomponent,aobjectinspector,nil,nil);
 fname:= aname;
 fsubproperties:= subprops;
 for int1:= 0 to high(fsubproperties) do begin
  with fsubproperties[int1] do begin
   include(fstate,ps_owned);
   fparenteditor:= self;
  end;
 end;
end;

function trecordpropeditor.allequal: boolean;
begin
 result:= true;
end;


destructor trecordpropeditor.destroy;
var
 int1: integer;
begin
 for int1:= 0 to high(fsubproperties) do begin
  fsubproperties[int1].Free;
 end;
 inherited;
end;

function trecordpropeditor.getdefaultstate: propertystatesty;
begin
 result:= [ps_subproperties];
end;

function trecordpropeditor.getvalue: msestring;
begin
 result:= '_';
end;

function trecordpropeditor.subproperties: propeditorarty;
begin
 result:= fsubproperties;
end;

{ tconstelementeditor }

constructor tconstelementeditor.create(const avalue: msestring; aindex: integer;
     aparenteditor: tarraypropeditor; aeditorclass: propeditorclassty; 
     const adesigner: tcomponentdesigner; const aobjectinspector: iobjectinspector; 
     const aprops: propinstancearty; atypinfo: ptypeinfo);
begin
 fvalue:= avalue;
 inherited create(aindex,aparenteditor,aeditorclass,adesigner,aobjectinspector,
                  aprops,atypinfo);
end;

function tconstelementeditor.getvalue: msestring;
begin
 result:= fvalue;
end;

procedure tconstelementeditor.dragdrop(const sender: tpropeditor);
begin
 if (sender is tarrayelementeditor) and
      (tarrayelementeditor(sender).fparenteditor = fparenteditor) then begin
//  sender.modified;
//  modified;
  tarraypropeditor(fparenteditor).itemmoved(
          tarrayelementeditor(sender).findex,findex);
 end;
end;

{ tnamepropeditor }

procedure tnamepropeditor.setvalue(const value: msestring);
begin
 if not isvalidident(value) then begin
  raise exception.create('Invalid component name '''+value+'''.');
 end;
 inherited;
end;

{ trefreshstringpropeditor }

function trefreshstringpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_refresh];
end;

{ tvolatilebooleanpropeditor }

function tvolatilebooleanpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_volatile];
end;

{ tdatetimeformatdisppropeditor }

function tdatetimeformatdisppropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate;
 result:= result + [ps_valuelist];
end;

function tdatetimeformatdisppropeditor.getvalues: msestringarty;
begin
 setlength(result,18);
 result[0]:= 'c'; //shortdateformat + ? ? + shorttimeformat
 result[1]:= 'ddddd'; //shortdateformat
 result[2]:= 'dddddd'; //longdateformat
 result[3]:= 't'; //shorttimeformat
 result[4]:= 'tt'; //longtimeformat
 result[5]:= 'yyyy/mm/dd hh:nn:ss'; 
 result[6]:= 'yy/mm/dd h:n:s'; 
 result[7]:= 'mmmm dd, yyyy'; 
 result[8]:= 'mmmm dd, yyyy (ddd)'; //with day name
 result[9]:= 'dd/mm/yyyy hh:n:ss'; 
 result[10]:= 'dd/mm/yy'; 
 result[11]:= 'dd/mm/yy h:n:s'; 
 result[12]:= 'dd mmm yyyy'; 
 result[13]:= 'dd mmmm yyyy'; 
 result[14]:= 'dd mmmm yyyy (ddd)'; //with day name
 result[15]:= 'hh:nn:ss am/pm'; 
 result[16]:= 'hh:nn:ss a/p'; 
 result[17]:= 'h:n:s am/pm'; 
 result[18]:= 'h:n:s a/p'; 
end;

{ tdatetimeformateditpropeditor }

function tdatetimeformateditpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate;
 result:= result + [ps_valuelist];
end;

function tdatetimeformateditpropeditor.getvalues: msestringarty;
begin
 setlength(result,16);
 result[0]:= 'c'; //shortdateformat + ? ? + shorttimeformat
 result[1]:= 'ddddd'; //shortdateformat
 result[2]:= 't'; //shorttimeformat
 result[3]:= 'tt'; //longtimeformat
 result[4]:= 'yyyy/mm/dd hh:nn:ss'; 
 result[5]:= 'yy/mm/dd hh:nn:ss'; 
 result[6]:= 'yyyy/mm/dd'; 
 result[7]:= 'yy/mm/dd'; 
 result[8]:= 'dd/mm/yyyy hh:n:ss'; 
 result[9]:= 'dd/mm/yy hh:nn:s'; 
 result[10]:= 'dd/mm/yyyy'; 
 result[11]:= 'dd/mm/yy'; 
 result[12]:= 'hh:nn:ss am/pm'; 
 result[13]:= 'hh:nn:ss a/p'; 
 result[14]:= 'h:n:s am/pm'; 
 result[15]:= 'h:n:s a/p'; 
end;

{ trealformatdisppropeditor }

function trealformatdisppropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate;
 result:= result + [ps_valuelist];
end;

function trealformatdisppropeditor.getvalues: msestringarty;
begin
 setlength(result,8);
 result[0]:= '0'; 
 result[1]:= '0.00'; 
 result[2]:= '#.##'; 
 result[3]:= '#,##0.00'; 
 result[4]:= '#,##0.00;(#,##0.00)'; 
 result[5]:= '#,##0.00;;Zero'; 
 result[6]:= '0.000E+00'; 
 result[7]:= '#.###E-0'; 
end;

{ trealformateditpropeditor }

function trealformateditpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate;
 result:= result + [ps_valuelist];
end;

function trealformateditpropeditor.getvalues: msestringarty;
begin
 setlength(result,11);
 result[0]:= '0'; 
 result[1]:= '0,00'; 
 result[2]:= '##.0,##'; 
 result[3]:= '##.0,00'; 
 result[4]:= '0.0,00'; 
 result[5]:= '0.0,##'; 
 result[6]:= '0.00'; 
 result[7]:= '##,0.##'; 
 result[8]:= '##,0.00'; 
 result[9]:= '0,0.00'; 
 result[10]:= '0,0.##'; 
end;

{ component designer }

function componenteditors: tcomponenteditors;
begin
 if acomponenteditors = nil then begin
  acomponenteditors:= tcomponenteditors.create;
 end;
 result:= acomponenteditors;
end;

procedure regcomponenteditor(componentclass: componentclassty;
                  componenteditorclass: componenteditorclassty);
begin
 componenteditors.add(componentclass,componenteditorclass)
end;


{ tcomponenteditors }

procedure tcomponenteditors.add(componentclass: componentclassty;
  componenteditorclass: componenteditorclassty);
var
 info: componenteditorinfoty;
begin
 fillchar(info,sizeof(info),0);
 info.componentclass:= componentclass;
 info.componenteditorclass:= componenteditorclass;
 inherited add(info);
end;

constructor tcomponenteditors.create;
begin
 inherited create(sizeof(componentinfoty));
end;

function tcomponenteditors.geteditorclass(
  const component: componentclassty): componenteditorclassty;
var
 level: integer;
 int1: integer;
 int2: integer;
 po1: pcomponenteditorinfoty;
 class1: tclass;
begin
 result:= nil;
 level:= bigint;
 po1:= pcomponenteditorinfoty(fdata);
 for int1:= 0 to count - 1 do begin
  with po1^ do begin
   class1:= component;
   int2:= 0;
   while (class1 <> componentclass) and (class1 <> nil) do begin
    inc(int2);
    class1:= class1.ClassParent;
   end;
   if (class1 <> nil) and (int2 < level) then begin
    level:= int2;
    result:= componenteditorclass;
   end;
  end;
  inc(po1);
 end;
end;

{ tcomponenteditor }

constructor tcomponenteditor.create(const adesigner: tcomponentdesigner; acomponent: tcomponent);
begin
 fdesigner:= adesigner;
 fcomponent:= acomponent;
end;

function tcomponenteditor.state: componenteditorstatesty;
begin
 result:= fstate;
end;

procedure tcomponenteditor.edit;
begin
 //dummy
end;

{ timagelistedit }

constructor timagelistedit.create(const adesigner: tcomponentdesigner; acomponent: tcomponent);
begin
 inherited;
 fstate:= fstate + [cs_canedit];
end;

procedure timagelistedit.edit;
begin
 if editimagelist(timagelist(fcomponent)) = mr_ok then begin
  fdesigner.componentmodified(fcomponent);
 end;
end;

procedure init;
begin
 regpropeditor(typeinfo(integer),nil,'',tordinalpropeditor);
 regpropeditor(typeinfo(longint),nil,'',tordinalpropeditor);
 regpropeditor(typeinfo(cardinal),nil,'',tordinalpropeditor);
 regpropeditor(typeinfo(word),nil,'',tordinalpropeditor);
 regpropeditor(typeinfo(byte),nil,'',tordinalpropeditor);
 regpropeditor(typeinfo(currency),nil,'',tcurrencypropeditor);
 regpropeditor(typeinfo(real),nil,'',trealpropeditor);
 regpropeditor(typeinfo(double),nil,'',trealpropeditor);
 regpropeditor(typeinfo(realty),nil,'',trealtypropeditor);
 regpropeditor(typeinfo(tdatetime),nil,'',tdatetimepropeditor);
 regpropeditor(typeinfo(char),nil,'',tcharpropeditor);
 regpropeditor(typeinfo(widechar),nil,'',twidecharpropeditor);
 regpropeditor(typeinfo(defaultenumerationty),nil,'',tenumpropeditor);
 {$ifdef FPC}
 regpropeditor(typeinfo(boolean),nil,'',tbooleanpropeditor); //for fpc
 {$endif}
 regpropeditor(typeinfo(string),nil,'',tstringpropeditor);
 regpropeditor(typeinfo(string),tcomponent,'Name',tnamepropeditor);
 regpropeditor(typeinfo(msestring),nil,'',tmsestringpropeditor);
 regpropeditor(typeinfo(colorty),nil,'',tcolorpropeditor);
 regpropeditor({$ifdef FPC}tpersistent.classinfo{$else}typeinfo(tpersistent){$endif},
                   nil,'',tclasspropeditor);
 regpropeditor(tparentfont.classinfo,nil,'',tparentfontpropeditor);

 regpropeditor(tcomponent.classinfo,nil,'',tcomponentpropeditor);
 regpropeditor(typeinfo(defaultsetty),nil,'',tsetpropeditor);
 regpropeditor(tarrayprop.classinfo,nil,'',tarraypropeditor);
 regpropeditor(tpersistentarrayprop.classinfo,nil,'',
                               tpersistentarraypropeditor);
 regpropeditor(tintegerarrayprop.classinfo,nil,'',
                               tintegerarraypropeditor);
 regpropeditor(tsetarrayprop.classinfo,nil,'',
                               tsetarraypropeditor);
 regpropeditor(tcolorarrayprop.classinfo,nil,'',
                               tcolorarraypropeditor);
 regpropeditor(trealarrayprop.classinfo,nil,'',
                               trealarraypropeditor);
 regpropeditor(tstringarrayprop.classinfo,nil,'',
                               tstringarraypropeditor);
 regpropeditor(tmsestringarrayprop.classinfo,nil,'',
                               tmsestringarraypropeditor);
 regpropeditor(tmaskedbitmap.classinfo,nil,'',tbitmappropeditor);
 regpropeditor(tstrings.classinfo,nil,'',tstringspropeditor);
 regpropeditor(tdatalist.classinfo,nil,'',tdatalistpropeditor);
 regpropeditor(tmsestringdatalist.classinfo,nil,'',
                               tmsestringdatalistpropeditor);
 regpropeditor(tdoublemsestringdatalist.classinfo,nil,'',
                            tdoublemsestringdatalistpropeditor); 
 regcomponenteditor(tcomponent,tcomponenteditor);
 regcomponenteditor(timagelist,timagelistedit);
end;

initialization
 acomponenteditors:= tcomponenteditors.Create;
 init;
finalization
 freeandnil(acomponenteditors);
 freeandnil(fpropeditors); 
end.
