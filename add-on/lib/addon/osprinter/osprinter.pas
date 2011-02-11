{ MSEgui Copyright (c) 2007-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
{*********************************************************}
{ Original file is mseprinter.pas, msegdiprint.pas, and   }
{ msepostscriptprinter.pas                                }
{            Modified by : Sri Wahono '2008               }
{             Included package with Repaz                 }
{*********************************************************}
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{              http://www.msegui.org/osprinter            }
{                                                         }
{*********************************************************}
unit osprinter;
{$ifdef FPC}{$mode objfpc}{$h+}{$GOTO ON}{$endif}

interface
uses
 mseclasses,msegraphics,msegraphutils,msestrings,msedrawtext,
 mserichstring,classes,msetypes,msestat,msestatfile,mseglob,mseguiglob,
 msegui,pagesetupdlg,osprinterstype,sysutils,mseevent,msesysutils;
 
const
 defaultppmm = 10;
 defaultpagewidth = 210;  //A4 mm
 defaultpageheight = 297; //A4 mm
 defaultframe = 0; //mm
 defaultfontheight = 3.527; //*ppmm -> 10 point 
 
 // gcscale = 4096;
 printunit = 25.4/72;    //point
 mmtoprintscale = 1/printunit;
 nulllinewidth = 0.2*mmtoprintscale;
 // esc command index
 esc_max           = 25;
 esc_init          = 0;
 esc_normal        = 1;
 esc_courier       = 2;
 esc_roman         = 3;
 esc_condensed     = 4;
 esc_expanded      = 5;
 esc_doubleheight       = 6;
 esc_not_doubleheight   = 7;
 esc_bold          = 8;
 esc_not_bold      = 9;
 esc_italic        = 10;
 esc_not_italic    = 11;
 esc_underline     = 12;
 esc_not_underline = 13;
 esc_strike        = 14;
 esc_not_strike    = 15;
 esc_sub           = 16;
 esc_not_sub       = 17;
 esc_super         = 18;
 esc_not_super     = 19;
 esc_open_drawer   = 20;
 esc_cut_paper     = 21;
 esc_form_feed     = 22;
 esc_line_feed     = 23;
 esc_left_margin   = 24;
 esc_paper_width   = 25;
 
type
 trawprintercommand = (rpcEpson,rpcEpsonTMSeries,rpcIBM,rpcStarSPSeries);
 rawfontty = (rfNormal,rfCourier,rfRoman,rfCondensed,rfExpanded,rfDoubleHeight); 
 tcustomprinter = class;
 tcustomprintercanvas = class;
 tprintercanvas = class;
 printereventty = procedure(const sender: tcustomprinter) of object;
 exceptioneventty = procedure(const sender: tobject; var e: exception;
                                             var again: boolean) of object; 

 tprintertabulators = class(tcustomtabulators)
  published
  property defaultdist;
 end;
 colorspacety = (cos_gray,cos_rgb);
 pageorientationty = (pao_portrait,pao_landscape);

 tprinterdialog = class(tpagesetupdlgfo)
  protected
   procedure cprinters_onsetvalue(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
   procedure cpapers_onbeforedropdown(const sender: TObject);
   class function hasresource: boolean; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
 end;
 esclistty = array[0..esc_max] of string;
 draweractionty = (cdaNotOpen,cdaOpenBefore,cdaOpenAfter);
 tcustomprinter = class(tmsecomponent,istatfile)
  private
   fonpagestart: printereventty;
   fonpageend: printereventty;
   fpa_paperwidth,fpa_paperheight: real;
   fpa_width: real;
   fpa_height: real;
   fpa_marginleft: real;
   fpa_margintop: real;
   fpa_marginright: real;
   fpa_marginbottom: real;
   ftabulators: tprintertabulators;
   //   fppmm: real;
   fstatfile: tstatfile;
   fstatvarname: msestring;
   fpa_orientation: pageorientationty;
   ftitle: msestring;
   fprinters: printerarty;     //printers names list
   fpapers: stdpagearty;
   fprintername: string;
   frawmode: boolean;
   fesclist: esclistty;
   fprncommand: trawprintercommand;
   fejectpaper: boolean;
   fcontinuespage: boolean;
   fdraweraction: draweractionty;
   fcutpaper: boolean;
   fonerror: exceptioneventty;
   
   procedure setprncommand(acommandtype: trawprintercommand);
   procedure defineescapecode(esccommand: integer; escstring: string);
   procedure settabulators(const avalue: tprintertabulators);
   //   procedure setppmm(const avalue: real);
   procedure setpa_marginleft(const avalue: real);
   procedure setpa_margintop(const avalue: real);
   procedure setpa_marginright(const avalue: real);
   procedure setpa_marginbottom(const avalue: real);
   procedure setprintername(const avalue: string);
   procedure writepa_marginleft(writer: twriter);
   procedure writepa_margintop(writer: twriter);
   procedure writepa_marginright(writer: twriter);
   procedure writepa_marginbottom(writer: twriter);
   procedure readpa_marginleft(reader: treader);
   procedure readpa_margintop(reader: treader);
   procedure readpa_marginright(reader: treader);
   procedure readpa_marginbottom(reader: treader);   //   function getcolorspace: colorspacety;
   //   procedure setcolorspace(const avalue: colorspacety);
   procedure setstatfile(const avalue: tstatfile);
   procedure setpa_paperwidth(const avalue: real);
   procedure setpa_paperheight(const avalue: real);
   procedure pagesizechanged;
   procedure setpa_orientation(const avalue: pageorientationty);
   procedure setcanvas(const avalue: tprintercanvas);
   procedure setrawmode(const avalue: boolean);
   function getpaperindex(awidth: real; aheight: real): integer;
   function getprinterindex: integer;
   procedure checkvalidprinter(aprintername: string);
  protected
   fcanvas: tprintercanvas;
   fpsfilename: filenamety;
   procedure loaded; override;
   function getwindowsize: sizety;

   //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter);
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
   function getpapername: msestring;

   //icanvas   
   function getsize: sizety;
   function getpapers: stdpagearty;
   function getprinterpapers(aprintername: string): stdpagearty; virtual;
   function getprinters: printerarty; virtual;
   function getdefaultprinter: string; virtual;
   procedure unlinkcanvas; virtual;
 public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function handleexception(const e: exception;
                                          out again: boolean): boolean;
   procedure senddata(const text: string); virtual;
   procedure setrawfont(avalue: rawfontty);
   procedure newpage;
   procedure writeln(const avalue: msestring = '');
   procedure writelines(const alines: array of msestring);
   procedure writelines(const alines: msestringarty);
   function rawfontdata(const afont: rawfontty): string;
   procedure beginprint; virtual;
   procedure endprint; virtual;
   function showdialog: modalresultty;
   
   property canvas: tprintercanvas read fcanvas write setcanvas;
   property onpagestart: printereventty read fonpagestart write fonpagestart;
   property onpageend: printereventty read fonpageend write fonpageend;
   property onerror: exceptioneventty read fonerror write fonerror;
                        //call abort for quiet cancel
   property title: msestring read ftitle write ftitle; 
   property pa_width: real read fpa_width write fpa_width; 
   property pa_height: real read fpa_height write fpa_height;
   property pa_paperwidth: real read fpa_paperwidth write setpa_paperwidth; 
   property pa_paperheight: real read fpa_paperheight write setpa_paperheight;
   property pa_orientation: pageorientationty read fpa_orientation write setpa_orientation;
   property esclist: esclistty read fesclist;
   property pa_marginleft: real read fpa_marginleft write setpa_marginleft; //mm, default 10
   property pa_margintop: real read fpa_margintop write setpa_margintop;    //mm, default 10
   property pa_marginright: real read fpa_marginright write setpa_marginright;  //mm, default 10
   property pa_marginbottom: real read fpa_marginbottom write setpa_marginbottom; //mm, default 10
   property tabulators: tprintertabulators read ftabulators write settabulators;
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read fstatvarname write fstatvarname;
   property printers: printerarty read fprinters write fprinters;
   property papers: stdpagearty read fpapers;
   property printername: string read fprintername write setprintername;
   property printerpapername: msestring read getpapername;
   property printerindex: integer read getprinterindex;
   property rawmode: boolean read frawmode write setrawmode;
   property raw_printercode: trawprintercommand read fprncommand write setprncommand;
   property raw_ejectonfinish: boolean read fejectpaper write fejectpaper default false;
   property raw_continuespage: boolean read fcontinuespage write fcontinuespage default true;
   property raw_cutpaperonfinish: boolean read fcutpaper write fcutpaper;
   property raw_draweraction: draweractionty read fdraweraction write fdraweraction;
   property outputfilename: filenamety read fpsfilename write fpsfilename;
  end;

 tprinter = class(tcustomprinter)
  published
   property canvas;
   property onpagestart;
   property onpageend;
   property pa_paperwidth;
   property pa_paperheight;
   property pa_orientation;
   property pa_marginleft; //mm, default 10
   property pa_margintop;    //mm, default 10
   property pa_marginright;  //mm, default 10
   property pa_marginbottom; //mm, default 10
   property tabulators;
   property statfile;
   property statvarname;
   property printername;
   property printerpapername;
   property rawmode;
   property raw_printercode;
   property raw_ejectonfinish;
   property raw_continuespage;
   property raw_draweraction;
   property raw_cutpaperonfinish;
   property outputfilename;
 end;

 tprinterfont = class(tcanvasfont)
 end;
 
 printercanvasstatety = (pcs_matrixvalid,pcs_dryrun);
 printercanvasstatesty = set of printercanvasstatety;
 
 tcustomprintercanvas = class(tcanvas)
  private
   fheaderheight: integer;
   ffooterheight: integer;
   fpagenumber: integer;
   findentx: integer;
   findenty: integer;
   fprintorientation: pageorientationty;
   fpagechanging: integer;
   fpages: pagerangearty;
   fpagesstring: msestring;
   fpageskind: pageskindty;
   procedure setcolorspace(const avalue: colorspacety);
   function getliney: integer;
   procedure setprintorientation(const avalue: pageorientationty);
   procedure setliney(const avalue: integer);
   procedure setpages(const avalue: pagerangearty);
  protected
   fpstate: printercanvasstatesty;
   fgcoffsetx: real;
   fgcoffsety: real;
   fgcscale: real;
   foriginx,foriginy: real;
   fscale: real;
   foffset: pointty;
   fclientsize: sizety;
   fboundingbox: framety;
   ftitle: msestring;
   flinenumber: integer;
   fpagelinenumber: integer;
   fliney: integer;
   fprinter: tcustomprinter;
   fcolorspace: colorspacety;
   fpreamble: string;
   function createfont: tcanvasfont; override;
   procedure initprinting(const apreamble: string = '');
   procedure checkgcstate(state: canvasstatesty); override;
   procedure setppmm(avalue: real); override;
   function defaultcliprect: rectty; override;
   procedure updatescale; virtual;
   procedure updateframe;
   procedure beginpage; virtual;
   procedure endpage; virtual;
   procedure dotextout(const text: richstringty; const dest: rectty;
    const flags: textflagsty;
    const tabdist: real; afontcolorshadow: colorty);
   procedure textout(const text: richstringty; const dest: rectty;
    const flags: textflagsty;
    const tabdist: real); virtual; abstract;
       //tabdist < 0 -> lastx                 
   procedure begintextclip(const arect: rectty); virtual; abstract;
   procedure endtextclip; virtual; abstract;
   procedure checknextpage;
   procedure internalwriteln(const avalue: richstringty);
   procedure setpagesstring(const avalue: msestring);
   procedure internaldrawtext(var info); override;
   //info = drawtextinfoty
  public
   constructor create(const user: tcustomprinter; const intf: icanvas);
   destructor destroy;override;
   procedure initflags(const dest: tcanvas); override;
     
   // if cy of destrect = 0 and tf_ycentered in textflags -> place on baseline
   procedure drawtext(var info: drawtextinfoty); overload; virtual;
   procedure drawtext(const atext: richstringty;
    const adest: rectty; aflags: textflagsty = [];
    afont: tfont = nil; atabulators: ttabulators = nil); overload;
   procedure drawtext(const atext: richstringty;
    const adest,aclip: rectty; aflags: textflagsty = [];
    afont: tfont = nil; atabulators: ttabulators = nil); overload;
   procedure drawtext(const atext: msestring;
    const adest: rectty; aflags: textflagsty = [];
    afont: tfont = nil; atabulators: ttabulators = nil); overload;
   procedure writeln(const avalue: msestring = ''); overload;
   procedure writeln(const avalue: richstringty); overload;
   procedure writelines(const alines: array of msestring); overload;
   procedure writelines(const alines: msestringarty); overload;
   procedure writelines(const alines: richstringarty); overload;

   property indentx: integer read findentx write findentx;
    //pixels
   property indenty: integer read findenty write findenty;
    //pixels
   property headerheight: integer read fheaderheight write fheaderheight;
    //pixels
   property footerheight: integer read ffooterheight write ffooterheight;
   //pixels
   property linenumber: integer read flinenumber;
   property pagelinenumber: integer read fpagelinenumber;
   function remaininglines: integer;
   function liney1: integer; //no checknextpage call
   property liney: integer read getliney write setliney;
   function lineheight: integer; //pixels

   procedure nextpage;
   function active: boolean; 
    //checks pages
     
   property title: msestring read ftitle write ftitle;
   //used as print job lable
   property clientsize: sizety read fclientsize;
   property colorspace: colorspacety read fcolorspace write setcolorspace default cos_gray;
   property pagenumber: integer read fpagenumber;
   property pageskind: pageskindty read fpageskind write fpageskind; 
   //null based
   property pages: pagerangearty read fpages write setpages;
   //all if nil, null based
   property pagesstring: msestring read fpagesstring write setpagesstring;
   //one based, example: '1-5,7,9,11-13', all if ''

   property printorientation: pageorientationty read fprintorientation 
    write setprintorientation default pao_portrait;   
   //property printer : tcustomprinter read fprinter;

 end;

 tprintercanvas = class(tcustomprintercanvas)
  published
   property font;
   property printorientation;
   property colorspace;
   property title;
   property ppmm; //default 10
   //property printer;
 end;

function stringtopages(const avalue: widestring): pagerangearty;
//one based, example: '1-5,7,9,11-13'

implementation
uses
 msesysintf;
 
type
 tfont1 = class(tfont);
 tcanvas1 = class(tcanvas);
 
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

{ tcustomprinter }

constructor tcustomprinter.create(aowner: tcomponent);
begin
// fppmm:= defaultppmm;
 inherited;
 fpsfilename:='';
 fprintername:= '';
 fpa_paperwidth:= defaultpagewidth;
 fpa_paperheight:= defaultpageheight;
 fpa_width:= defaultpagewidth;
 fpa_height:= defaultpageheight;
 fpa_marginleft:= defaultframe;
 fpa_margintop:= defaultframe;
 fpa_marginright:= defaultframe;
 fpa_marginbottom:= defaultframe;
 ftabulators:= tprintertabulators.create;
 ftitle:='';
 fpapers:=nil;
 fprinters:=nil;
 if fcanvas<>nil then begin
  fcanvas.ppmm:= defaultppmm;
 end;
 fprinters:= getprinters;
 if fprintername='' then
  fprintername:= getdefaultprinter;
 setprncommand(rpcEpson);
 fcontinuespage:= true;
 fdraweraction:= cdaNotOpen;
 fcutpaper:= false;
end;

destructor tcustomprinter.destroy;
begin
 inherited;
 ftabulators.free;
 if not frawmode then begin
  unlinkcanvas;
 end;
 if fcanvas<>nil then fcanvas.free;
 fprinters:=nil;
 fpapers:=nil;
end;

procedure tcustomprinter.senddata(const text: string); 
begin
 //
end;

procedure tcustomprinter.loaded;
begin
 inherited;
 if not frawmode then begin
  pagesizechanged;
  fcanvas.updatescale;
 end;
end;

function tcustomprinter.getwindowsize: sizety;
var
 rea1: real;
begin
 if pa_width > pa_height then begin //quadratic for landscape/portrait switching
  rea1:= pa_width;
 end
 else begin
  rea1:= pa_height;
 end;
 result.cx:= round(rea1*fcanvas.ppmm);
 result.cy:= result.cx;
end;

procedure tcustomprinter.defineescapecode(esccommand: integer; escstring: string);
begin
  if esccommand > esc_max then exit;
  fesclist[esccommand] := escstring;
end;

procedure tcustomprinter.setprncommand(acommandtype: trawprintercommand);
begin
  fprncommand := acommandtype;
  
  case fprncommand of
    // epson's esc command list, taken from epson lx-300 user manual
    rpcEpson: 
    begin
      fesclist[esc_init]          := #27'@';
      fesclist[esc_courier]       := #27'k2';
      fesclist[esc_roman]         := #27'x1';
      fesclist[esc_normal]        := #27'k0';
      fesclist[esc_condensed]     := #15;
      fesclist[esc_expanded]      := #27'p';
      fesclist[esc_doubleheight]       := #27'w1';
      fesclist[esc_not_doubleheight]   := #27'w0';
      fesclist[esc_bold]          := #27#69;
      fesclist[esc_not_bold]      := #27#70;
      fesclist[esc_italic]        := #27'4';
      fesclist[esc_not_italic]    := #27'5';
      fesclist[esc_underline]     := #27#45#1;
      fesclist[esc_not_underline] := #27#45#48;
      fesclist[esc_strike]        := #27'g';        
      fesclist[esc_not_strike]    := #27'h';        
      fesclist[esc_sub]           := #27's1';
      fesclist[esc_not_sub]       := #27't';
      fesclist[esc_super]         := #27's0';
      fesclist[esc_not_super]     := #27't';
      fesclist[esc_open_drawer]   := #27+#112+#0+#100+#100;
      fesclist[esc_cut_paper]     := '';
      fesclist[esc_form_feed]     := #12;
      fesclist[esc_line_feed]     := #10;
      fesclist[esc_left_margin]   := #27'l';
      fesclist[esc_paper_width]   := #27'q';
      
    end;
    // ibm's esc command list, taken from: ibm 9068a passbook printer programming guide
    // note: printer must be set to proprinter emulation mode 
    rpcIBM:
    begin
      fesclist[esc_init]          := '';
      fesclist[esc_courier]       := #27#73#8;
      fesclist[esc_roman]         := #27#73#10;
      fesclist[esc_normal]        := #27#58;
      fesclist[esc_condensed]     := #27#15;
      fesclist[esc_expanded]      := #27#18;
      fesclist[esc_doubleheight]       := #27'w1';
      fesclist[esc_not_doubleheight]   := #27'w0';
      fesclist[esc_bold]          := #27'e';
      fesclist[esc_not_bold]      := #27'f';
      fesclist[esc_italic]        := #27'g';
      fesclist[esc_not_italic]    := #27'h';
      fesclist[esc_underline]     := #27'-1';
      fesclist[esc_not_underline] := #27'-0';
      fesclist[esc_strike]        := #27'_1';        
      fesclist[esc_not_strike]    := #27'_0';        
      fesclist[esc_sub]           := '';
      fesclist[esc_not_sub]       := '';
      fesclist[esc_super]         := '';
      fesclist[esc_not_super]     := '';
      fesclist[esc_open_drawer]   := #27+#112+#0+#100+#100;
      fesclist[esc_cut_paper]   := '';
      fesclist[esc_form_feed]   := #12;
      fesclist[esc_line_feed]     := #10;
      fesclist[esc_left_margin]   := '';
      fesclist[esc_paper_width]   := '';
    end;
    rpcEpsonTMSeries: 
    begin
      fesclist[esc_init]          := #27'@';
      fesclist[esc_courier]       := #27+'!'+#0;
      fesclist[esc_roman]         := #27+'!'+#1;
      fesclist[esc_normal]        := #27+'!'+#1+#27+'!'+#0;
      fesclist[esc_condensed]     := #27+'!'+#1;
      fesclist[esc_expanded]      := #27+'!'+#17;
      fesclist[esc_doubleheight]       := #27+'!'+#32;
      fesclist[esc_not_doubleheight]   := #27+'!'+#0;
      fesclist[esc_bold]          := #27+'!'+#8;
      fesclist[esc_not_bold]      := #27+'!'+#0;
      fesclist[esc_italic]        := '';
      fesclist[esc_not_italic]    := #27'5';
      fesclist[esc_underline]     := #27'-1';
      fesclist[esc_not_underline] := #27'-0';
      fesclist[esc_strike]        := #27+'g'+#1;        
      fesclist[esc_not_strike]    := #27+'g'+#0;        
      fesclist[esc_sub]           := '';
      fesclist[esc_not_sub]       := '';
      fesclist[esc_super]         := '';
      fesclist[esc_not_super]     := '';
      fesclist[esc_open_drawer]   := #27+#112+#0+#100+#100;
      fesclist[esc_cut_paper]     := #27+'m'+#27+#64;
      fesclist[esc_form_feed]     := #12;
      fesclist[esc_line_feed]     := #10;
      fesclist[esc_left_margin]   := '';
      fesclist[esc_paper_width]   := '';
    end;
    rpcStarSPSeries: 
    begin
      fesclist[esc_init]          := #27'@';
      fesclist[esc_courier]       := '';
      fesclist[esc_roman]         := '';
      fesclist[esc_normal]        := #27+'!'+#0;
      fesclist[esc_condensed]     := '';
      fesclist[esc_expanded]      := #27+'!'+#17;
      fesclist[esc_doubleheight]       := '';
      fesclist[esc_not_doubleheight]   := '';
      fesclist[esc_bold]          := '';
      fesclist[esc_not_bold]      := '';
      fesclist[esc_italic]        := #27'4';
      fesclist[esc_not_italic]    := #27'5';
      fesclist[esc_underline]     := #27'-1';
      fesclist[esc_not_underline] := #27'-0';
      fesclist[esc_strike]        := #27+'g'+#1;        
      fesclist[esc_not_strike]    := #27+'g'+#0;        
      fesclist[esc_sub]           := '';
      fesclist[esc_not_sub]       := '';
      fesclist[esc_super]         := '';
      fesclist[esc_not_super]     := '';
      fesclist[esc_open_drawer]   := #27+#112+#0+#100+#100;
      fesclist[esc_cut_paper]     := #27+'m'+#27+#64;
      fesclist[esc_form_feed]     := #12;
      fesclist[esc_line_feed]     := #10;
      fesclist[esc_left_margin]   := '';
      fesclist[esc_paper_width]   := '';
    end;
  end;
end;

procedure tcustomprinter.settabulators(const avalue: tprintertabulators);
begin
 ftabulators.assign(avalue);
end;

procedure tcustomprinter.pagesizechanged;
begin
 if fpa_orientation=pao_portrait then begin
  fpa_width:= fpa_paperwidth;
  fpa_height:= fpa_paperheight;
 end else begin
  fpa_height:= fpa_paperwidth;
  fpa_width:= fpa_paperheight;
 end;
 if not (csloading in componentstate) then begin
  sendchangeevent;
  if not frawmode then begin
   fcanvas.updateframe;
  end;
 end;
end;

procedure tcustomprinter.checkvalidprinter(aprintername: string);
var
 int1: integer;
 valid: boolean;
begin
 valid:= false;
 for int1:=0 to length(fprinters)-1 do begin
  if lowercase(aprintername)=lowercase(fprinters[int1].printername) then begin
   valid:= true;
   fprintername:= fprinters[int1].printername;
   break;
  end;
 end;
 if not valid then begin
  fprinters:= getprinters;
  if length(fprinters)>0 then begin
   fprintername:= fprinters[0].printername;
  end else begin
   if (csloading in componentstate) then begin
    fprintername:='';
   end else begin
    raise exception.create('Printer not found, please install printer correctly!');
   end;
  end;
 end;
end;

procedure tcustomprinter.setprintername(const avalue: string);
begin
 //if fprintername<>avalue then begin
  if avalue<>'' then begin
   checkvalidprinter(avalue);
   fpapers:= getprinterpapers(fprintername);
  end;
 //end;
end;

function tcustomprinter.getpaperindex(awidth: real; aheight: real): integer;
var
 int1,fprintercount: integer;
begin
 fprintercount:= length(fpapers);
 if fprintercount=0 then begin
  result:=-1;
  exit;
 end;
 result:= fprintercount-1;
 for int1:=0 to length(fpapers)-1 do begin
  if (fpapers[int1].width=awidth) and (fpapers[int1].height=aheight) then begin
   result:= int1;
   break;
  end;
 end;
 if result=fprintercount-1 then begin
  fpapers[result].width:= awidth;
  fpapers[result].height:= aheight;
 end;
end;

procedure tcustomprinter.setpa_paperwidth(const avalue: real);
begin
 fpa_paperwidth:= avalue;
 pagesizechanged;
end;

procedure tcustomprinter.setpa_paperheight(const avalue: real);
begin
 fpa_paperheight:= avalue;
 pagesizechanged;
end;

procedure tcustomprinter.setpa_orientation(const avalue: pageorientationty);
begin
 fpa_orientation:= avalue;
 pagesizechanged;
end;

procedure tcustomprinter.setpa_marginleft(const avalue: real);
begin
 fpa_marginleft:= avalue;
 if not frawmode then begin
  fcanvas.updateframe;
 end;
end;

procedure tcustomprinter.setpa_margintop(const avalue: real);
begin
 fpa_margintop:= avalue;
 if not frawmode then begin
  fcanvas.updateframe;
 end;
end;

procedure tcustomprinter.setpa_marginright(const avalue: real);
begin
 fpa_marginright:= avalue;
 if not frawmode then begin
  fcanvas.updateframe;
 end;
end;

procedure tcustomprinter.setpa_marginbottom(const avalue: real);
begin
 fpa_marginbottom:= avalue;
 if not frawmode then begin
  fcanvas.updateframe;
 end;
end;

procedure tcustomprinter.writepa_marginleft(writer: twriter);
begin
 writer.writefloat(fpa_marginleft);
end;

procedure tcustomprinter.writepa_margintop(writer: twriter);
begin
 writer.writefloat(fpa_margintop);
end;

procedure tcustomprinter.writepa_marginright(writer: twriter);
begin
 writer.writefloat(fpa_marginright);
end;

procedure tcustomprinter.writepa_marginbottom(writer: twriter);
begin
 writer.writefloat(fpa_marginbottom);
end;

procedure tcustomprinter.readpa_marginleft(reader: treader);
begin
 fpa_marginleft:= reader.readfloat;
end;

procedure tcustomprinter.readpa_margintop(reader: treader);
begin
 fpa_margintop:= reader.readfloat;
end;

procedure tcustomprinter.readpa_marginright(reader: treader);
begin
 fpa_marginright:= reader.readfloat;
end;

procedure tcustomprinter.readpa_marginbottom(reader: treader);
begin
 fpa_marginbottom:= reader.readfloat;
end;

procedure tcustomprinter.dostatread(const reader: tstatreader);
begin
 with reader do begin
  setrawmode(readboolean('rawmode',frawmode));
  setprncommand(trawprintercommand(readinteger('printercode',ord(fprncommand))));
  fejectpaper:= readboolean('ejectonfinished',fejectpaper);
  fcutpaper:= readboolean('cutpaperonfinished',fcutpaper);
  fcontinuespage:= readboolean('continuespage',fcontinuespage);
  printername:= readstring('printername',fprintername);
  fpa_paperwidth:= readreal('paperwidth',fpa_paperwidth);
  fpa_paperheight:= readreal('paperheight',fpa_paperheight);
  fpa_orientation:= pageorientationty(readinteger('orientation',
             ord(fpa_orientation),0,ord(high(pageorientationty))));
  if not frawmode then begin
   pagesizechanged;
  end;
  fpa_marginleft:= readreal('marginleft',fpa_marginleft);
  fpa_margintop:= readreal('margintop',fpa_margintop);
  fpa_marginright:= readreal('marginright',fpa_marginright);
  fpa_marginbottom:= readreal('marginbottom',fpa_marginbottom);
  if not frawmode then begin
   fcanvas.colorspace:= colorspacety(readinteger('colorspace',
                           ord(fcanvas.colorspace),0,ord(high(colorspacety))));
  end;
  fdraweraction:= draweractionty(readinteger('draweraction',ord(fdraweraction)));
 end;
end;

procedure tcustomprinter.dostatwrite(const writer: tstatwriter);
begin
 with writer do begin
  writeboolean('rawmode',frawmode);
  writeinteger('printercode',ord(fprncommand));
  writeboolean('ejectonfinished',fejectpaper);
  writeboolean('cutpaperonfinished',fcutpaper);
  writeboolean('continuespage',fcontinuespage);
  writestring('printername',fprintername);
  writereal('paperwidth',fpa_paperwidth);
  writereal('paperheight',fpa_paperheight);
  writeinteger('orientation',ord(fpa_orientation));
  writereal('marginleft',fpa_marginleft);
  writereal('margintop',fpa_margintop);
  writereal('marginright',fpa_marginright);
  writereal('marginbottom',fpa_marginbottom);
  writeinteger('colorspace',ord(fcanvas.colorspace));
  writeinteger('draweraction',ord(fdraweraction));
 end;
end;

procedure tcustomprinter.statreading;
begin
 //dummy
end;

procedure tcustomprinter.statread;
begin
 //dummy
end;

function tcustomprinter.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

function tcustomprinter.getpapername: msestring;
var
 int1: integer;
begin
 int1:= getpaperindex(fpa_paperwidth,fpa_paperheight);
 if int1=-1 then
  result:= 'Custom'
 else
  result:= fpapers[int1].name;
end;

procedure tcustomprinter.setstatfile(const avalue: tstatfile);
begin
 setstatfilevar(istatfile(self),avalue,fstatfile);
end;

procedure tcustomprinter.setcanvas(const avalue: tprintercanvas);
begin
 fcanvas.assign(avalue);
end;

procedure tcustomprinter.setrawmode(const avalue: boolean);
begin
  if avalue<>frawmode then begin
    frawmode := avalue;
    if frawmode then begin
     {if fcanvas<>nil then begin
      fcanvas.free;
     end;}
    end;
  end;
end;

function tcustomprinter.getsize: sizety;
begin
 result:= fcanvas.fdrawinfo.gc.paintdevicesize;
end;

function tcustomprinter.getpapers: stdpagearty;
begin
 if fprintername='' then begin
  fprintername:= getdefaultprinter;
 end;
 if fprintername<>'' then begin
  fpapers:=getprinterpapers(fprintername);
 end;
end;

function tcustomprinter.getprinterpapers(aprintername: string): stdpagearty; 
begin
 //
end;

function tcustomprinter.getprinters: printerarty;
begin
 //
end;

procedure tcustomprinter.unlinkcanvas;
begin
 //dummy
end;

function tcustomprinter.handleexception(const e: exception;
                                          out again: boolean): boolean;
var
 e1: exception;
begin
 result:= true;
 again:= false;
 if canevent(tmethod(fonerror)) then begin
  e1:= e;
  application.lock;
  try
   fonerror(self,e1,again);
  finally
   application.unlock;
  end;
  result:= not again and (e1 = e);
  if not result and not again and (e1 <> nil) then begin
   raise e1;
  end;
 end;
end;

function tcustomprinter.getdefaultprinter: string;
begin
 //dummy
end;

procedure tcustomprinter.beginprint;
begin
 if ftitle='' then ftitle:='Repaz Printing';
end;

procedure tcustomprinter.endprint;
begin
 //dummy
end;

procedure tcustomprinter.setrawfont(avalue: rawfontty);
begin
 if frawmode then begin
  case avalue of
   rfNormal : senddata(fesclist[esc_normal]);
   rfCourier: senddata(fesclist[esc_courier]);
   rfCondensed:  senddata(fesclist[esc_condensed]);
   rfExpanded: senddata(fesclist[esc_expanded]);
   rfDoubleHeight: senddata(fesclist[esc_doubleheight]);
  end;
 end;
end;

procedure tcustomprinter.newpage;
begin
 if frawmode then begin
  senddata(fesclist[esc_form_feed]);
 end else begin
  fcanvas.nextpage;
 end;
end;

procedure tcustomprinter.writeln(const avalue: msestring = '');
begin
 if frawmode then begin
  {$IFDEF DEBUG_POSPRINTER}
  debugwriteln(avalue);
  {$ENDIF}
  senddata(avalue + fesclist[esc_line_feed]);
 end else begin
  fcanvas.writeln(avalue);
 end;
end;

procedure tcustomprinter.writelines(const alines: array of msestring);
var
 int1: integer;
begin
 if frawmode then begin
  for int1:= 0 to high(alines) do begin
   {$IFDEF DEBUG_POSPRINTER}
   debugwriteln(alines[int1]);
   {$ENDIF}
   senddata(alines[int1] + fesclist[esc_line_feed]);
  end;
 end else begin
  fcanvas.writelines(alines);
 end;
end;

procedure tcustomprinter.writelines(const alines: msestringarty);
var
 int1: integer;
begin
 if frawmode then begin
  for int1:= 0 to high(alines) do begin
   {$IFDEF DEBUG_POSPRINTER}
   debugwriteln(alines[int1]);
   {$ENDIF}
   senddata(alines[int1] + fesclist[esc_line_feed]);
  end;
 end else begin
  fcanvas.writelines(alines);
 end;
end;

function tcustomprinter.rawfontdata(const afont: rawfontty): string;
begin
 case afont of
  rfNormal : result:= fesclist[esc_normal];
  rfCourier: result:= fesclist[esc_courier];
  rfCondensed:  result:= fesclist[esc_condensed];
  rfExpanded: result:= fesclist[esc_expanded];
  rfDoubleHeight: result:= fesclist[esc_doubleheight];
 end;
end;

function tcustomprinter.showdialog: modalresultty;
var
 int1,prcount: integer;
 dia: tprinterdialog;
begin
 dia:= tprinterdialog.create(self);
 fprinters:= getprinters;
 dia.fprinters:= fprinters;
 prcount:=length(fprinters)-1;
 if prcount>=0 then begin
  for int1:=0 to prcount do begin
   dia.cprinters.dropdown.cols.addrow([fprinters[int1].printername]);
  end;
  dia.cprinters.value:=fprintername;
  dia.cprinters.dropdown.itemindex:=printerindex;
  dia.cinfo.clear;
  dia.cinfo.appendrow(['Driver Name',fprinters[printerindex].drivername]);
  dia.cinfo.appendrow(['Location',fprinters[printerindex].location]);
  dia.cinfo.appendrow(['Port Name',fprinters[printerindex].port]);
  dia.cinfo.appendrow(['Description',fprinters[printerindex].description]);
  dia.cinfo.appendrow(['Server Name',fprinters[printerindex].servername]);
  dia.cinfo.appendrow(['Share Name',fprinters[printerindex].sharename]);
  dia.cinfo.appendrow(['Default Printer',booltostr(fprinters[printerindex].isdefault,true)]);
 end;
 fpapers:=getprinterpapers(fprintername);
 prcount:=length(fpapers)-1;
 dia.cpaperwidth.value:=fpa_paperwidth;
 dia.cpaperheight.value:=fpa_paperheight;
 if prcount>=0 then begin
  for int1:=0 to prcount do begin
   dia.cpapers.dropdown.cols.addrow([fpapers[int1].name]);
  end;
  dia.cpapers.dropdown.itemindex:= getpaperindex(fpa_paperwidth,fpa_paperheight);
 end;
 
 dia.fpapers:= fpapers;
 dia.cleft.value:= fpa_marginleft;
 dia.cright.value:= fpa_marginright;
 dia.ctop.value:= fpa_margintop;
 dia.cbottom.value:= fpa_marginbottom;
 if not frawmode then begin
  if fpa_orientation=pao_portrait then begin
   dia.cportrait.value:=true;
   dia.clandscape.value:=false;
  end else begin
   dia.cportrait.value:=false;
   dia.clandscape.value:=true;
  end;
  if canvas.pagesstring='' then begin
   dia.callpages.value:=true;
   dia.crangepage.value:=false;
   dia.crangestring.value:='';
  end else begin
   dia.callpages.value:=false;
   dia.crangepage.value:=true;
   dia.crangestring.value:=canvas.pagesstring;
  end;
  dia.ttabpage2.invisible:= true;
 end else begin
  dia.cportrait.value:=false;
  dia.clandscape.value:=false;
  dia.cportrait.enabled:=false;
  dia.clandscape.enabled:=false;
  dia.callpages.enabled:=false;
  dia.crangepage.enabled:=false;
  dia.crangestring.value:='';
  dia.crangestring.enabled:=false;
  dia.ttabpage2.invisible:= false;
 end;
 dia.listprintercode.dropdown.itemindex:= ord(fprncommand);
 dia.boolejectonfinished.value:= fejectpaper;
 dia.boolcontpage.value:= fcontinuespage;
 dia.boolrawmode.value:= frawmode;
 if fdraweraction=cdaNotOpen then begin
  dia.cdnotopen.value:= true;
 end else if fdraweraction=cdaOpenBefore then begin
  dia.cdopenbefore.value:= true;
 end else if fdraweraction=cdaOpenAfter then begin
  dia.cdopenafter.value:= true;
 end;
 dia.boolcutpaper.value:= fcutpaper;
 result:= mr_cancel;
 dia.wdpi.value:= round(canvas.ppmm*2.54*10);
 if dia.show(true)=mr_ok then begin
  result:= mr_ok;
  fprintername:= dia.cprinters.value;
  fpa_paperwidth:= dia.cpaperwidth.value;
  fpa_paperheight:= dia.cpaperheight.value;
  fpa_marginleft:= dia.cleft.value;
  fpa_marginright:= dia.cright.value;
  fpa_margintop:= dia.ctop.value;
  fpa_marginbottom:= dia.cbottom.value;
  setrawmode(dia.boolrawmode.value);
  setprncommand(trawprintercommand(dia.listprintercode.dropdown.itemindex));
  fejectpaper:= dia.boolejectonfinished.value;
  fcontinuespage:= dia.boolcontpage.value;
  if dia.cdnotopen.value then begin
   fdraweraction:= cdaNotOpen;
  end else if dia.cdopenbefore.value then begin
   fdraweraction:= cdaOpenBefore;
  end else if dia.cdopenafter.value then begin
   fdraweraction:= cdaOpenAfter;
  end;
  fcutpaper:= dia.boolcutpaper.value;
  if not frawmode then begin
   canvas.ppmm:= (dia.wdpi.value/2.54)/10;
   if dia.cportrait.value then begin
    fpa_orientation:= pao_portrait;
    canvas.printorientation:= pao_portrait;
   end else begin
    fpa_orientation:= pao_landscape;
    canvas.printorientation:= pao_landscape;
   end;
   pagesizechanged;
   if dia.callpages.value then begin
    canvas.pagesstring:='';
   end else begin
    canvas.pagesstring:=dia.crangestring.value;
   end;
  end;
 end;  
 freeandnil(dia);
end;

function tcustomprinter.getprinterindex: integer;
var
 int1: integer;
begin
 if fprintername='' then fprintername:= getdefaultprinter;
 if length(fprinters)=0 then fprinters:=getprinters;
 result:=-1;
 for int1:=0 to length(fprinters)-1 do begin  
  //if comparetext(fprintername,fprinters[int1].printername)=0 then begin
  if lowercase(fprintername)=lowercase(fprinters[int1].printername) then begin
   result:=int1;
   break;
  end;
 end;
 if (result=-1) and (length(fprinters)>0) then begin
  result:=0;
  fprintername:= fprinters[result].printername;
  setprintername(fprintername);
 end;
end;

{ tcustomprintercanvas }

constructor tcustomprintercanvas.create(const user: tcustomprinter; 
                                                       const intf: icanvas);
begin
 fprinter:= user;
 inherited create(user,intf);
 fstate:= fstate+[cs_highresdevice,cs_internaldrawtext];
end;

destructor tcustomprintercanvas.destroy;
begin
 inherited;
end;

procedure tcustomprintercanvas.initflags(const dest: tcanvas);
begin
 inherited;
 include(tcanvas1(dest).fdrawinfo.gc.drawingflags,df_highresfont);
end;

function tcustomprintercanvas.createfont: tcanvasfont;
begin
 result:= tprinterfont.create(self);
end;

procedure tcustomprintercanvas.initprinting(const apreamble: string = '');
begin
 fpreamble:= apreamble;
 fpagenumber:= 0;
 fpagelinenumber:= 0;
 fliney:= 0;
 reset;
end;

function tcustomprintercanvas.defaultcliprect: rectty;
begin
 result.pos:= nullpoint;
 result.size:= fdrawinfo.gc.paintdevicesize;
 with result do begin
  if cx > cy then begin 
      //quadratic because of cliprectinit with later orientation switch
   cy:= cx;
  end
  else begin
   cx:= cy;             
  end;
 end;  
end;

procedure tcustomprintercanvas.updatescale;
begin
 if not (csloading in fprinter.componentstate) then begin
  exclude(fstate,cs_origin);
  exclude(fpstate,pcs_matrixvalid);
  with fprinter do begin
//   self.ppmm:= fppmm;
   fgcscale:= mmtoprintscale/ppmm; //map to printerunits

   if fprintorientation = pao_landscape then begin
    fdrawinfo.gc.paintdevicesize.cx:= round(fpa_height * ppmm);
    fdrawinfo.gc.paintdevicesize.cy:= round(fpa_width * ppmm);
    fgcoffsetx:= mmtoprintscale * fpa_marginleft;
    fgcoffsety:= - fpa_margintop*mmtoprintscale;
   end
   else begin
    fdrawinfo.gc.paintdevicesize.cx:= round(fpa_width * ppmm);
    fdrawinfo.gc.paintdevicesize.cy:= round(fpa_height * ppmm);
    fgcoffsetx:= mmtoprintscale * fpa_marginleft;
    fgcoffsety:= (fpa_height-fpa_margintop)*mmtoprintscale;
   end;
   
   if fprintorientation = pao_landscape then begin
    fboundingbox.left:= round(fpa_margintop*mmtoprintscale);
    fboundingbox.bottom:= round(fpa_marginleft*mmtoprintscale);
    fboundingbox.right:= round((fdrawinfo.gc.paintdevicesize.cy/ppmm-fpa_marginbottom)*mmtoprintscale);
    fboundingbox.top:= round((fdrawinfo.gc.paintdevicesize.cx/ppmm-fpa_marginright)*mmtoprintscale);
   end
   else begin
    fboundingbox.left:= round(fpa_marginleft*mmtoprintscale);
    fboundingbox.bottom:= round(fpa_marginbottom*mmtoprintscale);
    fboundingbox.right:= round((fdrawinfo.gc.paintdevicesize.cx/ppmm-fpa_marginright)*mmtoprintscale);
    fboundingbox.top:= round((fdrawinfo.gc.paintdevicesize.cy/ppmm-fpa_margintop)*mmtoprintscale);
   end;
   fclientsize.cx:= fdrawinfo.gc.paintdevicesize.cx - round((fpa_marginleft+fpa_marginright)*ppmm);
   fclientsize.cy:= fdrawinfo.gc.paintdevicesize.cy - round((fpa_margintop+fpa_marginbottom)*ppmm);
  end;
  with fdrawinfo.gc.paintdevicesize do begin
   if cx > cy then begin 
       //quadratic because of cliprectinit with later orientation switch
    cy:= cx;
   end
   else begin
    cx:= cy;             
   end;
  end;  
 end;
end;

procedure tcustomprintercanvas.checkgcstate(state: canvasstatesty);
begin
 if not (cs_origin in fstate) then begin
//  with fprinter do begin
   foriginx:= fgcoffsetx + mmtoprintscale * (origin.x/ppmm);
   foriginy:= fgcoffsety - mmtoprintscale * (origin.y/ppmm);
//  end;
 end;
 inherited;
end;

procedure tcustomprintercanvas.updateframe;
begin
 updatescale;
end;

procedure tcustomprintercanvas.beginpage;
begin
 fpagelinenumber:= 0;
 fliney:= 0;
 with fprinter do begin
  if canevent(tmethod(fonpagestart)) then begin
   fonpagestart(fprinter);
  end;
 end;
end;

procedure tcustomprintercanvas.endpage;
begin
 checkgcstate([cs_gc]); //could be an empty page
 with fprinter do begin
  if canevent(tmethod(fonpageend)) then begin
   fonpageend(fprinter);
  end;
 end;
end;

procedure tcustomprintercanvas.dotextout(const text: richstringty;
               const dest: rectty; const flags: textflagsty;
               const tabdist: real; afontcolorshadow: colorty);
var
 col1: colorty;
begin
 if tf_grayed in flags then begin
  afontcolorshadow:= cl_white;
 end;
 col1:= fdrawinfo.acolorforeground;
 if afontcolorshadow <> cl_none then begin
  fdrawinfo.acolorforeground:= afontcolorshadow;
  checkgcstate([cs_acolorforeground]);
  textout(text,moverect(dest,makepoint(1,1)),flags,tabdist);
  if tf_grayed in flags then begin
   fdrawinfo.acolorforeground:= cl_dkgray;
  end
  else begin
   fdrawinfo.acolorforeground:= col1;
  end;
  checkgcstate([cs_acolorforeground]);
 end;
 textout(text,dest,flags,tabdist);
 if tf_grayed in flags then begin
  fdrawinfo.acolorforeground:= col1;
  checkgcstate([cs_acolorforeground]);
 end;
end;

procedure tcustomprintercanvas.drawtext(var info: drawtextinfoty);
var
 acolorshadow: colorty;
 tab1: tcustomtabulators;
 ar1: richstringarty;
 int1,int2,int3,int4,int5,int6: integer;
 rea1: real;
 flags1,flags2: textflagsty;
 rstr1: richstringty;
 layoutinfo: layoutinfoty;
 rect1,rect2: rectty;
 backup: msestring;
 lihi: integer;
label
 endlab;
begin
 if cs_inactive in fstate then exit;
 save;
 layouttext(self,info,layoutinfo);
 if pcs_dryrun in fpstate then begin
  goto endlab;
 end;
 ar1:= nil; //compiler warning
 with fdrawinfo do begin
  afonthandle1:= tfont1(font).gethandle;
  with {fvaluepo^.}font do begin
   acolorforeground:= color;
   acolorbackground:= colorbackground;
   acolorshadow:= shadow_color;
  end;
  checkgcstate([cs_font,cs_acolorforeground,cs_acolorbackground]);
 end;
 with info do begin
  if tf_clipi in flags then begin
   begintextclip(dest);
  end
  else begin
   if tf_clipo in flags then begin
    begintextclip(clip);
   end;
  end;
  backup:= text.text;
  try
   with layoutinfo do begin
    if tf_softhyphen in flags then begin
     for int1:= 0 to high(lineinfos) do begin
      with lineinfos[int1] do begin
       for int2:= 0 to high(tabchars) do begin
        if text.text[tabchars[int2]] = c_softhyphen then begin
         text.text[tabchars[int2]]:= #0; //will be removed in printing routine
        end;
       end;
      end;
     end;
    end;
    text.text:= replacechar(text.text,c_softhyphen,'-');
    if high(lineinfos) > 0 then begin
     rect1:= dest;
     flags1:= flags;
     flags2:= flags1 - [tf_xcentered,tf_right,tf_xjustify];
     lihi:= font.lineheight;
     int1:= 0;
//     int2:= lihi;
     if reversed then begin
      lihi:= - lihi;
      int1:= lihi;
//      int2:= 0;
     end;
     if xyswapped then begin
      rect1.cx:= font.lineheight;
      if tf_ycentered in flags then begin
       rect1.x:= dest.x + (dest.cx - length(lineinfos) * lihi) div 2 + int1;
      end
      else begin
       if tf_bottom in flags then begin
        if reversed then begin
         rect1.x:= dest.x - high(lineinfos) * lihi;
        end
        else begin
         rect1.x:= dest.x + dest.cx - length(lineinfos) * lihi;
        end;
       end;
      end;
     end
     else begin
      rect1.cy:= font.lineheight;
      if tf_ycentered in flags then begin
       rect1.y:= dest.y + (dest.cy - length(lineinfos) * lihi) div 2 + int1;
      end
      else begin
       if tf_bottom in flags then begin
        if reversed then begin
         rect1.y:= dest.y - high(lineinfos) * lihi;
        end
        else begin
         rect1.y:= dest.y + dest.cy - length(lineinfos) * lihi;
        end;
       end;
      end;
     end;
     for int1:= 0 to high(lineinfos) do begin
      with lineinfos[int1] do begin
       if (tf_xjustify in flags) and (high(justifychars) >= 0) and 
                   (int1 < high(lineinfos)) then begin
        rstr1:= richcopy(text,liindex,justifychars[0]-liindex);
        dotextout(rstr1,rect1,flags2,0,acolorshadow); //first word
        rea1:= (dest.cx - liwidth + getstringwidth(' ') * length(justifychars)) /
                         length(justifychars); //gap width
        rect2:= rect1;        //x justify text
        if xyswapped then begin
         rect2.cy:= 0;                                    
         int3:= dest.y;
        end
        else begin
         rect2.cx:= 0;                                    
         int3:= dest.x;
        end;
        for int2:= liindex - 1 to justifychars[0] - 2 do begin
         inc(int3,charwidths[int2]);            //end of first word
        end;
        for int2:= 0 to high(justifychars) - 1 do begin
         int5:= 0;
         for int4:= justifychars[int2] to justifychars[int2+1] - 2 do begin
          inc(int5,charwidths[int4]); //width of actual word
         end;
         int6:= round(int3 + (int2 + 1) * rea1 + int5 div 2);
         if xyswapped then begin
          rect2.y:= int6;
         end
         else begin
          rect2.x:= int6;
         end;
         int3:= int3 + int5;
         rstr1:= richcopy(text,justifychars[int2]+1,justifychars[int2+1] - 
                                                         justifychars[int2] - 1);
         dotextout(rstr1,rect2,flags2 + [tf_xcentered],0,acolorshadow);
        end;
        rstr1:= richcopy(text,justifychars[high(justifychars)]+1,
                           liindex+licount-justifychars[high(justifychars)]-1);
        dotextout(rstr1,rect1,flags2+[tf_right],0,acolorshadow); //last word
       end
       else begin
        rstr1:= richcopy(text,liindex,licount);
        dotextout(rstr1,rect1,flags1,0,acolorshadow);
       end;
       if xyswapped then begin
        inc(rect1.x,lihi);
       end
       else begin
        inc(rect1.y,lihi);
       end;
      end;
     end;
    end
    else begin //single line
     if countchars(text.text,c_tab) = 0 then begin
      dotextout(text,dest,flags,0,acolorshadow);
     end
     else begin
      if tabulators = nil then begin
       tab1:= fprinter.ftabulators;
      end
      else begin
       tab1:= tabulators;
      end;
      if tab1.count = 0 then begin
       if tab1.defaultdist = 0 then begin      //has no tabs
        replacechar(text.text,c_tab,' ');
        dotextout(text,dest,flags,0,acolorshadow);
       end
       else begin
        ar1:= splitrichstring(text,c_tab);
        dotextout(ar1[0],dest,flags,0,acolorshadow);
        rea1:= tab1.defaultdist*mmtoprintscale;
        for int1:= 1 to high(ar1) do begin     
         dotextout(ar1[int1],dest,flags,rea1,acolorshadow);
        end;
       end;
      end
      else begin
       ar1:= splitrichstring(text,c_tab);
       dotextout(ar1[0],dest,flags,0,acolorshadow);
       for int1:= 1 to high(ar1) do begin     
        if int1 > tab1.count then begin
         rstr1.text:= ' ';
         rstr1.format:= nil;
         rstr1:= richconcat(rstr1,ar1[int1]);
         for int2:= int1+1 to high(ar1) do begin
          rstr1:= richconcat(rstr1,' ');
          rstr1:= richconcat(rstr1,ar1[int2]);
         end;
         dotextout(rstr1,dest,flags-[tf_right,tf_xcentered],-1,acolorshadow); 
                        //print rest of string
         break;
        end;
        flags1:= flags - [tf_xcentered,tf_right];
        with tab1[int1-1] do begin
         case kind of
          tak_right,tak_decimal: flags1:= flags1 + [tf_right];
          tak_centered: flags1:= flags1 + [tf_xcentered];
         end;
         if kind = tak_decimal then begin
          int2:= msestrrscan(ar1[int1].text,widechar(decimalseparator));
          if int2 > 0 then begin
           dotextout(richcopy(ar1[int1],1,int2-1),
                   makerect(round(pos*ppmm),dest.y,0,
                     dest.cy),flags1,0,acolorshadow); //int
           dotextout(richcopy(ar1[int1],int2,bigint),makerect(0,dest.y,0,
                     dest.cy),flags1-[tf_right],-1,acolorshadow); //frac
          end
          else begin
           dotextout(ar1[int1],makerect(round(pos*ppmm),dest.y,0,
                     dest.cy),flags1,0,acolorshadow); //no frac
          end;
         end
         else begin
          dotextout(ar1[int1],makerect(round(pos*ppmm),dest.y,0,dest.cy),flags1,
                      0,acolorshadow);
         end;
        end;
       end;
      end;
     end;
    end;
   end;       //with layoutinfo
  finally
   text.text:= backup;
   if flags * [tf_clipi,tf_clipo] <> [] then begin
    endtextclip;
   end;
  end;
 end;
endlab:
 restore;
end;

procedure tcustomprintercanvas.drawtext(const atext: richstringty;
                   const adest: rectty; aflags: textflagsty = [];
                   afont: tfont = nil; atabulators: ttabulators = nil);
var
 info: drawtextinfoty;
begin
 fillchar(info,sizeof(info),0);
 with info do begin
  text:= atext;
  dest:= adest;
  flags:= aflags;
  font:= afont;
  tabulators:= atabulators;
 end;
 drawtext(info);
end;

procedure tcustomprintercanvas.drawtext(const atext: richstringty;
                   const adest,aclip: rectty; aflags: textflagsty = [];
                   afont: tfont = nil; atabulators: ttabulators = nil);
var
 info: drawtextinfoty;
begin
 fillchar(info,sizeof(info),0);
 with info do begin
  text:= atext;
  dest:= adest;
  clip:= aclip;
  flags:= aflags;
  font:= afont;
  tabulators:= atabulators;
 end;
 drawtext(info);
end;

procedure tcustomprintercanvas.drawtext(const atext: msestring;
                   const adest: rectty; aflags: textflagsty = [];
                   afont: tfont = nil; atabulators: ttabulators = nil);
var
 info: drawtextinfoty;
begin
 fillchar(info,sizeof(info),0);
 with info do begin
  text.text:= atext;
  dest:= adest;
  flags:= aflags;
  font:= afont;
  tabulators:= atabulators;
 end;
 drawtext(info);
end;

procedure tcustomprintercanvas.checknextpage;
begin
 if fpagechanging = 0 then begin
  if remaininglines <= 0 then begin
   inc(fpagechanging);
   try
    nextpage;
   finally
    dec(fpagechanging);
   end;
  end;
 end;
end;

procedure tcustomprintercanvas.writeln(const avalue: msestring = '');
var
 rstr1: richstringty;
begin
 rstr1.format:= nil;
 rstr1.text:= avalue;
 writeln(rstr1);
end;

procedure tcustomprintercanvas.internalwriteln(const avalue: richstringty);
begin
 checknextpage;
 if avalue.text <> '' then begin
  drawtext(avalue,makerect(findentx,fliney + fheaderheight + findenty,0,0));
 end;
 inc(fpagelinenumber);
 inc(flinenumber);
 fliney:= fliney + lineheight;
end;

procedure tcustomprintercanvas.writeln(const avalue: richstringty);
var
 ar1: richstringarty;
 int1: integer;
begin
 ar1:= breakrichlines(avalue);
 for int1:= 0 to high(ar1) do begin
  internalwriteln(ar1[int1]);
 end;
end;

procedure tcustomprintercanvas.writelines(const alines: array of msestring);
var
 int1: integer;
 rstr1: richstringty;
begin
 rstr1.format:= nil;
 for int1:= 0 to high(alines) do begin
  rstr1.text:= alines[int1];
  internalwriteln(rstr1);
 end;
end;

procedure tcustomprintercanvas.writelines(const alines: msestringarty);
var
 int1: integer;
 rstr1: richstringty;
begin
 rstr1.format:= nil;
 for int1:= 0 to high(alines) do begin
  rstr1.text:= alines[int1];
  internalwriteln(rstr1);
 end;
end;

procedure tcustomprintercanvas.writelines(const alines: richstringarty);
var
 int1: integer;
begin
 for int1:= 0 to high(alines) do begin
  internalwriteln(alines[int1]);
 end;
end;

function tcustomprintercanvas.lineheight: integer;
begin
 result:= font.height;
 if result = 0 then begin
  result:= round(defaultfontheight*ppmm);
 end;
 result:= result + font.extraspace;
end;

function tcustomprintercanvas.remaininglines: integer;
begin
 checkgcstate([cs_gc]); //init all values
 result:= (fclientsize.cy - fheaderheight - ffooterheight - fliney - findenty -
                            origin.y) div lineheight;
end;

procedure tcustomprintercanvas.nextpage;
begin
 endpage;
 inc(fpagenumber);
 beginpage;
end;

procedure tcustomprintercanvas.setcolorspace(const avalue: colorspacety);
begin
 if fcolorspace <> avalue then begin
  fcolorspace:= avalue;
  exclude(fstate,cs_acolorforeground);
//  valueschanged([cs_color,cs_colorbackground]);
 end;
end;

function tcustomprintercanvas.active: boolean;
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
 if result then begin
  result:= (fpageskind = pk_all) or ((fpageskind = pk_even) xor odd(fpagenumber));
 end;
end;

function tcustomprintercanvas.liney1: integer;
begin
 result:= fliney + fheaderheight;
end;

function tcustomprintercanvas.getliney: integer;
begin
 checknextpage;
 result:= liney1;
end;

procedure tcustomprintercanvas.setliney(const avalue: integer);
begin
 checknextpage;
 fliney:= avalue - fheaderheight;
end;

procedure tcustomprintercanvas.setprintorientation(
                                             const avalue: pageorientationty);
begin
 if avalue <> fprintorientation then begin
  fprintorientation:= avalue;
  updatescale;
 end;
end;

procedure tcustomprintercanvas.setppmm(avalue: real);
begin
 inherited;
 fprinter.ftabulators.ppmm:= avalue;
 updatescale;
end;

procedure tcustomprintercanvas.setpages(const avalue: pagerangearty);
begin
 fpages:= copy(avalue);
end;

procedure tcustomprintercanvas.setpagesstring(const avalue: msestring);
begin
 pages:= stringtopages(avalue);
 fpagesstring:= avalue;
end;

procedure tcustomprintercanvas.internaldrawtext(var info);
begin
 drawtext(drawtextinfoty(info));
end;

{ tprinterdialog }
constructor tprinterdialog.create(aowner: tcomponent);
begin
 inherited;
 cprinters.onsetvalue:=@cprinters_onsetvalue;
 cpapers.onbeforedropdown:=@cpapers_onbeforedropdown;
end;

destructor tprinterdialog.destroy;
begin
 inherited;
end;

class function tprinterdialog.hasresource: boolean;
begin
 result:= false;
end;

procedure tprinterdialog.cprinters_onsetvalue(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
var
 int1: integer;
begin
 for int1:=0 to cprinters.dropdown.cols.rowcount-1 do begin
  if lowercase(avalue)=lowercase(cprinters.dropdown.cols[0][int1]) then begin
   accept:= true;
   break;
  end;
 end;
 tcustomprinter(self.owner).printername:= avalue; 
 cinfo.clear;
 cinfo.appendrow(['Driver Name',fprinters[int1].drivername]);
 cinfo.appendrow(['Location',fprinters[int1].location]);
 cinfo.appendrow(['Port Name',fprinters[int1].port]);
 cinfo.appendrow(['Description',fprinters[int1].description]);
 cinfo.appendrow(['Server Name',fprinters[int1].servername]);
 cinfo.appendrow(['Share Name',fprinters[int1].sharename]);
 cinfo.appendrow(['Default Printer',booltostr(fprinters[int1].isdefault,true)]);
end;

procedure tprinterdialog.cpapers_onbeforedropdown(const sender: TObject);
var
 prcount,int1: integer;
begin
 tcustomprinter(self.owner).printername:= cprinters.value;
 fpapers:= tcustomprinter(self.owner).papers;
 prcount:=length(fpapers)-1;
 cpapers.dropdown.cols.clear;
 if prcount>=0 then begin
  for int1:=0 to prcount do begin
   cpapers.dropdown.cols.addrow([fpapers[int1].name]);
  end;
  cpapers.dropdown.itemindex:= 0;
 end;
end;

end.
