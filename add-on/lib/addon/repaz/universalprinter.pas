{*********************************************************}
{                  Universal Printer                      }
{             Copyright : Sri Wahono '2011                }
{             Included package with Repaz                 }
{*********************************************************}
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{              http://www.msegui.org/repaz                }
{                                                         }
{*********************************************************}
unit universalprinter;

{$ifdef FPC}{$mode objfpc}{$goto on}{$h+}{$endif}

interface

uses
 msegui,mseclasses,sysutils,classes,msegraphics,mseguiglob,msegraphutils,msestream,msestrings,msetypes,
 msedrawtext,mserichstring,cairo,universalprintertype,msefileutils,msebitmap,pagesetupdlg,msewidgets
 {$IFDEF windows},windows,gdiapi,cairowin32{$ENDIF},mseglob,msestat,msestatfile,msesysintf
 {$IFDEF LINUX},cupsapi{$ENDIF},msecommport;

const
 mmtoinch = 1/25.4;
type
 outputtypety = (cai_PDF,cai_SVG,cai_GDI,cai_GDIPrinter,cai_CUPS,cai_PostScript,cai_PNG);

 tuniversalprintercanvas = class;
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

 tuniversalprinter = class(tmsecomponent,icanvas,istatfile)
  private
   fsurface : Pcairo_surface_t;
   fcanvas: tuniversalprintercanvas;
   foutputformat : outputtypety;
   fprinters: printerarty;     //printers names list
   fprintername: string;
   fstatfile: tstatfile;
   fstatvarname: msestring;
   ftitle: msestring;
   fpapers: stdpagearty;
   fantialias: boolean;
   frawmode: boolean;
   fesclist: esclistty;
   fdefaultprinter: string;
   fprncommand: trawprintercommand;
   flinesperpage: integer;
   ftextasgraphic: boolean;
   fcontinuespage: boolean;
   fdraweraction: draweractionty;
   fdrawermode: drawermodety;
   fserialport: commnrty;
   fcutpaper: boolean;
   fppinchx: integer;
   fppinchy: integer;
   forientation: pageorientationty;
   fpa_paperwidth,fpa_paperheight: real;
   fwidth: real;
   fdraw: Pcairo_t;
   fheight: real;
   fpa_marginleft: real;
   fpa_margintop: real;
   fpa_marginright: real;
   fpa_marginbottom: real;
   fscalex,fscaley: real;
   fpagestring: msestring;
   fcopies: integer;
   cmatrix: cairo_matrix_t;
   fcommport: tcommport;
   {$IFDEF WINDOWS}
   fgcprinter: ptruint;
   fprinterhandle: dword;
   {$ENDIF}
   {$IFDEF LINUX}
   //cups
   fcupsoptions: pcups_option_t;
   fcupsprinters: pcups_dest_t;    //printers available
   fcupsppd: pppd_file_t;
   fcupshttp: phttp_t;         //server connection
   fcupsnumopts: integer;
   libstatus: boolean;
   fdefprinter: string;
   frawstream: tmsefilestream;
   procedure docupsconnect;
   function getcupsrequest(aname: pcups_dest_t) : pipp_t;
   function getattributestring(aprinter: pcups_dest_t; aname: pchar; const defaultvalue : string): string;
  function printfile(afilename: string): longint;
   {$ENDIF}   
   procedure setprncommand(acommandtype: trawprintercommand);
   procedure defineescapecode(esccommand: integer; escstring: string);
   function getcanvas: tuniversalprintercanvas;
   procedure setwidth(const avalue: real);
   procedure setheight(const avalue: real);
   procedure setorientation(const avalue: pageorientationty);
   procedure setmarginleft(const avalue: real);
   procedure setmargintop(const avalue: real);
   procedure setmarginright(const avalue: real);
   procedure setmarginbottom(const avalue: real);
   procedure setprintername(const avalue: string);
   procedure writemarginleft(writer: twriter);
   procedure writemargintop(writer: twriter);
   procedure writemarginright(writer: twriter);
   procedure writemarginbottom(writer: twriter);
   procedure readmarginleft(reader: treader);
   procedure readmargintop(reader: treader);
   procedure readmarginright(reader: treader);
   procedure readmarginbottom(reader: treader);
   procedure setstatfile(const avalue: tstatfile);
   procedure setpaperwidth(const avalue: real);
   procedure setpaperheight(const avalue: real);
   //icanvas
   procedure gcneeded(const sender: tcanvas);
   function getmonochrome: boolean;
   function getsize: sizety;
   procedure setrawmode(const avalue: boolean);
   function getpaperindex(awidth: real; aheight: real): integer;
   function getprinterpapers(aprintername: string): stdpagearty;
   function getprinters: printerarty;
   function getdefaultprinter: string;
   function getprinterindex: integer;
   procedure checkvalidprinter(aprintername: string);
   //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter);
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
   function getpapername: msestring;
  public
   ffilename: filenamety;
   fsize: sizety;
   constructor create(aowner: tcomponent);  override;
   destructor destroy; override;
   procedure beginrender;
   procedure endrender;
   procedure senddata(const text: string);
   procedure setrawfont(avalue: rawfontty);
   procedure setcanvas(const avalue: tuniversalprintercanvas);
   property canvas: tuniversalprintercanvas read getcanvas;
   {$IFDEF WINDOWS}
   property gdiprinterdc: ptruint read fgcprinter write fgcprinter;
   property gdiprinterhandle: dword read fprinterhandle write fprinterhandle;
   {$ENDIF}
   function showdialog: modalresultty;
   procedure writeln(const avalue: msestring = '');
   procedure writelines(const alines: array of msestring);
   procedure writelines(const alines: msestringarty);
   function rawfontdata(const afont: rawfontty): string;
   property esclist: esclistty read fesclist;
   procedure pagesizechanged;
   procedure newpage;
   procedure endpage;
   property dpix: integer read fppinchx write fppinchx;
   property dpiy: integer read fppinchy write fppinchy;
   property context: Pcairo_t read fdraw;
  published
   property printtextasgraphic: boolean read ftextasgraphic write ftextasgraphic;
   property antialias: boolean read fantialias write fantialias;
   property copies: integer read fcopies write fcopies;
   property outputfilename: filenamety read ffilename write ffilename;
   property pagesstring: msestring read fpagestring write fpagestring;
   property title: msestring read ftitle write ftitle; 
   property page_width: real read fwidth write fwidth; 
   property page_height: real read fheight write fheight;
   property page_paperwidth: real read fpa_paperwidth write setpaperwidth; 
   property page_paperheight: real read fpa_paperheight write setpaperheight;
   property page_orientation: pageorientationty read forientation write setorientation;
   property page_marginleft: real read fpa_marginleft write setmarginleft; //mm, default 10
   property page_margintop: real read fpa_margintop write setmargintop;    //mm, default 10
   property page_marginright: real read fpa_marginright write setmarginright;  //mm, default 10
   property page_marginbottom: real read fpa_marginbottom write setmarginbottom; //mm, default 10
   property outputformat: outputtypety read foutputformat write foutputformat;
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read fstatvarname write fstatvarname;
   property printers: printerarty read fprinters write fprinters;
   property papers: stdpagearty read fpapers;
   property printername: string read fprintername write setprintername;
   property printerpapername: msestring read getpapername;
   property printerindex: integer read getprinterindex;
   property rawmode: boolean read frawmode write setrawmode;
   property raw_printercode: trawprintercommand read fprncommand write setprncommand;
   property raw_continuespage: boolean read fcontinuespage write fcontinuespage default true;
   property raw_cutpaperonfinish: boolean read fcutpaper write fcutpaper;
   property raw_linesperpage: integer read flinesperpage write flinesperpage;
   property raw_draweraction: draweractionty read fdraweraction write fdraweraction;
   property raw_drawermode: drawermodety read fdrawermode write fdrawermode;
   property raw_serialport: commnrty read fserialport write fserialport;
   property scalex: real read fscalex write fscalex;
   property scaley: real read fscaley write fscaley;
 end;

 tuniversalprintercanvas = class(tcanvas)
  protected
   fcairo: tuniversalprinter;
   cpattern: Pcairo_pattern_t;
   fpagenum: integer;
   fx,fy: real;
   procedure gcdestroyed(const sender: tcanvas); override;
   procedure reset; override;
   function cairoimage(aimage: imagety; destrect: rectty; aformat:cairo_format_t): Pcairo_surface_t;
   function getgdifuncs: pgdifunctionaty; override;
   procedure initgcstate; override;
   procedure initgcvalues; override;
   procedure finalizegcstate; override;  
   procedure gsposcairo(const apos: pointty);
   procedure cairopos(const apos: pointty);
   procedure cairo_drawstring16;
   procedure cairo_destroygc;
   procedure cairo_changegc;
   procedure handlepoly(const points: ppointty; 
             const lastpoint: integer; const closed: boolean; const fill: boolean);
   procedure handleellipse(const rect: rectty; const fill: boolean);
   procedure cairo_drawlines;
   procedure cairo_drawlinesegments;
   procedure cairo_drawarc;   
   procedure cairo_fillpolygon;
   procedure cairo_fillarc;
   procedure cairo_fillrect;
   procedure cairo_copyarea;
  public
   constructor create(const user: tuniversalprinter; const intf: icanvas);
   destructor destroy;
   property pagenumber: integer read fpagenum write fpagenum;
   procedure beginpage;
   procedure endpage;
   procedure nextpage;
 end;
 
implementation

uses
 msesys,msedatalist,mseformatstr,msefont,msesysutils,
 mseguiintf,msebits,msereal;
type
 cairogcdty = record
  canvas: tuniversalprintercanvas;
 end;
 cairogcty = record
  case integer of
   0: (d: cairogcdty);
   1: (_bufferspace: gcpty;);
 end;
 pboolean = ^boolean;

 tsimplebitmap1 = class(tsimplebitmap); 
 tcanvas1 = class(tcanvas);
 tfont1 = class(tfont);
 
const
 radtodeg = 360/(2*pi);
var
 gdifuncs: pgdifunctionaty;
 gdifunctions: gdifunctionaty;

procedure checkprinterror(const aresult: integer; const atext: string = '');
begin
 if aresult <= 0 then begin
  syserror(syelasterror,atext);
 end;
end;

procedure gdi_setcliporigin(var drawinfo: drawinfoty);
begin
// gdierror(gde_notimplemented);
end;

procedure gdi_destroygc(var drawinfo: drawinfoty);
begin
 try
  cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_destroygc;
 except //trap for stream write errors
 end;
end;
 
procedure gdi_changegc(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_changegc;
end;

procedure gdi_drawlines(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawlines;
end;

procedure gdi_drawlinesegments(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawlinesegments;
end;

procedure gdi_drawellipse(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.handleellipse(
                        drawinfo.rect.rect^,false);
end;

procedure gdi_drawarc(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawarc;
end;

procedure gdi_fillrect(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_fillrect;
end;

procedure gdi_fillelipse(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.handleellipse(
                        drawinfo.rect.rect^,true);
end;

procedure gdi_fillarc(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_fillarc;
end;

procedure gdi_fillpolygon(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_fillpolygon;
end;

procedure gdi_drawstring16(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawstring16;
end;

procedure gdi_copyarea(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_copyarea;
end;
      
{ tuniversalprintercanvas }

constructor tuniversalprintercanvas.create(const user: tuniversalprinter; const intf: icanvas);
begin
 inherited create(user,intf);
 fcairo:= user;
 fpagenum:= 0;
end;

destructor tuniversalprintercanvas.destroy;
begin
 if cpattern<>nil then begin
  cairo_pattern_destroy(cpattern); 
  cpattern:= nil;
 end;
 inherited;
end;

procedure tuniversalprintercanvas.reset;
begin
 inherited;
 restore(1);
 save;
 clipregion:= 0;
 origin:= nullpoint;
end;

function tuniversalprintercanvas.cairoimage(aimage: imagety; destrect: rectty; aformat:cairo_format_t): Pcairo_surface_t;
var
 sourcerowstep: integer;
 rowshiftleft,rowshiftright: byte;
 int1,int2,stridewidth,rowbytes: integer;
 po1: prgbtriplety;
 po2: pbyte;
 adata: pbyte;
 acolor: rgbtriplety;
begin
 if aimage.monochrome then begin
  result:= nil;
  stridewidth:= cairo_format_stride_for_width(aformat,aimage.size.cx);
  int1:= aimage.size.cy*stridewidth;
  adata:= pbyte(gui_allocimagemem(int1));
  system.move(aimage.pixels^,adata^,int1);
  {po2:= pointer(adata);
  for int2:= 0 to aimage.length-1 do begin
   po1:= @aimage.pixels^[int2];
   po2^:= po1^.blue;
   inc(po2);
   po2^:= po1^.green;
   inc(po2);
   po2^:= po1^.red;
   inc(po2);
   po2^:= po1^.res;
   inc(po2);
  end;}
  result:= cairo_image_surface_create_for_data(pbyte(adata),aformat,aimage.size.cx,aimage.size.cy,stridewidth);
 end else begin
  result:= nil;
  stridewidth:= cairo_format_stride_for_width(aformat,aimage.size.cx);
  int1:= aimage.size.cy*stridewidth;
  adata:= pbyte(gui_allocimagemem(int1));
  po2:= pointer(adata);
  for int2:= 0 to aimage.length-1 do begin
   po1:= @aimage.pixels^[int2];
   po2^:= po1^.blue;
   inc(po2);
   po2^:= po1^.green;
   inc(po2);
   po2^:= po1^.red;
   inc(po2);
   po2^:= po1^.res;
   inc(po2);
  end;
  result:= cairo_image_surface_create_for_data(pbyte(adata),aformat,aimage.size.cx,aimage.size.cy,stridewidth);
 end; 
end;

function tuniversalprintercanvas.getgdifuncs: pgdifunctionaty;
begin
 result:= @gdifunctions;
end;

procedure tuniversalprintercanvas.initgcstate;
begin
 inherited;
 with cairogcty(fdrawinfo.gc.platformdata).d do begin
  canvas:= self;
 end;
 case fcairo.outputformat of
 cai_PDF:
  begin
   cairo_pdf_surface_set_size(fcairo.fsurface,fcairo.page_width*self.ppmm,fcairo.page_height*self.ppmm);
  end;
 cai_PostScript,cai_CUPS:
  begin
   cairo_ps_surface_set_size(fcairo.fsurface,fcairo.page_width*self.ppmm,fcairo.page_height*self.ppmm);
  end;
 end;
 //beginpage;
end;

procedure tuniversalprintercanvas.initgcvalues;
begin
 inherited;
end;

procedure tuniversalprintercanvas.finalizegcstate;
begin
 inherited;
end;

procedure tuniversalprintercanvas.cairopos(const apos: pointty);
begin
 if not (cs_origin in fstate) then begin
  checkgcstate([cs_origin]);
 end;
 cairo_move_to(fcairo.fdraw, apos.x, apos.y);
end;

procedure tuniversalprintercanvas.gsposcairo(const apos: pointty);
begin
 cairo_move_to(fcairo.context, apos.x, apos.y);
end;

procedure tuniversalprintercanvas.cairo_destroygc;
begin
end;

procedure tuniversalprintercanvas.cairo_changegc;
var
 int1,int2,ndash: integer;
 rect1,rect2: rectty;
 ar1: rectarty;
 dashesarty: realarty;
 rgbcolor: rgbtriplety;
 fslant: cairo_font_slant_t;
 fweight: cairo_font_weight_t;
 pt1: pointty;
 fmatrix,fontmatrix: cairo_matrix_t;
 ffontextent: cairo_font_extents_t;
 height1,width1: integer;
 image: imagety;
 fsurface1 : Pcairo_surface_t;
 lwidth: real;
begin
 ar1:= nil; //compiler warning
 with fdrawinfo,gcvalues^ do begin
  if gvm_dashes in mask then begin
   int2:= length(lineinfo.dashes);
   if (int2 > 0) and (lineinfo.dashes[int2] = #0) then begin
    dec(int2);
   end;
   if int2>0 then begin
    setlength(dashesarty,int2);
    for int1:= 0 to int2-1 do begin
     dashesarty[int1]:= byte(lineinfo.dashes[int1]);
    end;
    ndash:= sizeof(dashesarty);
   end else begin
    setlength(dashesarty,1);
    dashesarty[0]:= 0.0;
    ndash:= 0;
   end;
   cairo_set_dash(fcairo.context, pointer(dashesarty), ndash, 0);
  end;
  if (self.brush <> nil) and 
            ([gvm_brush,gvm_brushorigin] * mask <> []) then begin
   msebitmap.tbitmap(self.brush).savetoimage(image);
   if image.length>0 then begin 
    fsurface1:= cairoimage(image,rect1,CAIRO_FORMAT_A1);
    image.pixels:= nil;
    cpattern:= nil;
    cpattern:= cairo_pattern_create_for_surface(fsurface1);
    cairo_surface_destroy(fsurface1);
    fsurface1:= nil;
   end;
  end;
  if (df_brush in gc.drawingflags) and (cpattern<>nil) then begin
   rect2:= makerect(self.brushorigin,tsimplebitmap(self.brush).size);
   cairo_matrix_init_scale(@fmatrix, rect2.cx, rect2.cy);
   cairo_pattern_set_matrix(cpattern, @fmatrix);
   cairo_pattern_set_extend (cpattern, CAIRO_EXTEND_REPEAT);
   cairo_set_source(fcairo.context,cpattern);
   cairo_fill(fcairo.context);
   image.pixels:= nil;
  end else begin
   if gvm_colorforeground in mask then begin
    rgbcolor:= colortorgb(acolorforeground);
    cairo_set_source_rgb (fcairo.context,rgbcolor.red,rgbcolor.green,rgbcolor.blue);
   end;
  end;
  if gvm_font in mask then begin
   cairo_set_font_size (fcairo.context, self.font.height);  
   fweight:= CAIRO_FONT_WEIGHT_NORMAL;
   fslant:= CAIRO_FONT_SLANT_NORMAL;
   if fs_bold in self.font.style then begin
    fweight:= CAIRO_FONT_WEIGHT_BOLD;
   end;
   if fs_italic in self.font.style then begin
    fslant:= CAIRO_FONT_SLANT_ITALIC;
   end;
   cairo_select_font_face (fcairo.context, pchar(self.font.name),fslant,fweight);
   //if (fx<>1) or (fy<>1) then begin
   if fcairo.dpix>fcairo.dpiy then begin
    cairo_get_font_matrix(fcairo.context,@fontmatrix);
    cairo_matrix_scale(@fontmatrix, fx, fy);
    cairo_set_font_matrix(fcairo.context,@fontmatrix);
   end;
  end;
  if gvm_linewidth in mask then begin
   if self.linewidth = 0 then begin
    lwidth:= 0.3;
   end else begin
    lwidth:= self.linewidthmm;
   end;
   cairo_set_line_width (fcairo.context, lwidth);
  end;
  if gvm_capstyle in mask then begin
   case lineinfo.capstyle of
    cs_round: cairo_set_line_cap(fcairo.context,CAIRO_LINE_CAP_ROUND);
    cs_projecting: cairo_set_line_cap(fcairo.context,CAIRO_LINE_CAP_SQUARE);
    else cairo_set_line_cap(fcairo.context,CAIRO_LINE_CAP_BUTT)
   end;
  end;
  if gvm_joinstyle in mask then begin
   case lineinfo.joinstyle of
    js_round: cairo_set_line_join(fcairo.context,CAIRO_LINE_JOIN_ROUND);
    js_bevel: cairo_set_line_join(fcairo.context,CAIRO_LINE_JOIN_BEVEL);
    else cairo_set_line_join(fcairo.context,CAIRO_LINE_JOIN_MITER);
   end;
  end;
  if gvm_clipregion in mask then begin
   cairo_save(fcairo.context);
   if clipregion <> 0 then begin
    ar1:= gui_regiontorects(clipregion);
    for int1:= 0 to high(ar1) do begin
     pt1:= addpoint(ar1[int1].pos,gc.cliporigin);
     cairo_rectangle(fcairo.context, pt1.x, pt1.y, ar1[int1].size.cx, ar1[int1].size.cy);
     cairo_fill(fcairo.context);
     cairo_clip(fcairo.context);
    end;
   end;
   cairo_restore (fcairo.context)
  end;
 end;
end;

function stringtoutf8rtl(const value: pmsechar; const count: integer): utf8string; overload;
var
 int1: integer;
 po1: pchar;
 wo1,wo2: word;
begin
 setlength(result,length(value)*3); //max
 po1:= pchar(pointer(result));
 for int1:= count-1 downto 0 do begin
  wo1:= word(value[int1]);
  wo2:= wo1 and $ff80;
  if wo2 = 0 then begin
   po1^:= char(wo1);
   inc(po1);
  end
  else begin
   wo2:= wo2 and $f800;
   if wo2 = 0 then begin
    po1^:= char((wo1 shr 6) or $c0);
    inc(po1);
    po1^:= char(wo1 and $3f or $80);
    inc(po1);
   end
   else begin
    po1^:= char((wo1 shr 12) or $e0);
    inc(po1);
    po1^:= char((wo1 shr 6) and $3f or $80);
    inc(po1);
    po1^:= char(wo1 and $3f or $80);
    inc(po1);
   end;
  end;
 end;
 setlength(result,po1-pchar(pointer(result)));
end;

function stringtoutf8rtl(const value: msestring): utf8string;
begin
 result:= stringtoutf8rtl(pmsechar(value),length(value));
end;

procedure tuniversalprintercanvas.cairo_drawstring16;
var
 rea1,rea2: real;
 int1: integer;
 te: cairo_text_extents_t;
 str1: pchar;
 char1: msestring;
 xx,yy: real;
 str2: msestring;
begin
 if active then begin
  with fdrawinfo.text16pos do begin
   cairopos(pos^);
   rea1:= tfont1(self.font).rotation;
   if rea1<>0 then begin
    cairo_rotate(fcairo.context,-rea1);
   end;
   if fcairo.printtextasgraphic then begin
    str2:= msestrlcopy(text,count);
    str1:= pchar(stringtoutf8(str2));
    //str1:= pchar(UTF8Encode(str2));
    cairo_text_path (fcairo.context, str1);
    cairo_fill(fcairo.context);
   end else begin
    if (fcairo.outputformat=cai_GDIPrinter) and (fcairo.dpix<>fcairo.dpiy) then begin
     xx:= pos^.x;
     yy:= pos^.y;
     str2:= msestrlcopy(text,count);
     for int1:=1 to length(str2) do begin
      char1:= copy(str2,int1,1);
      str1:= pchar(stringtoutf8(char1));
      cairo_text_extents(fcairo.context, str1, @te);
      cairo_show_text(fcairo.context, str1);
      if fcairo.dpix>fcairo.dpiy then begin
       rea2:= te.x_advance*(fcairo.dpix/fcairo.dpiy);
      end else begin
       rea2:= te.x_advance;
      end;
      xx:= xx+ rea2;
      cairo_move_to(fcairo.context,xx,yy);
     end;
    end else begin
     str2:= msestrlcopy(text,count);
     str1:= pchar(stringtoutf8(str2));
     //str1:= pchar(UTF8Encode(str2));
		   cairo_show_text(fcairo.context, str1); 
		  end;
   end;
   if rea1<>0 then begin
    cairo_rotate(fcairo.context,(rea1));
   end;
  end;
 end;
end;

procedure tuniversalprintercanvas.cairo_drawarc;
begin
 with fdrawinfo.arc,rect^ do begin
  cairo_new_path(fcairo.context);
  if cy = cx then begin
   cairo_arc(fcairo.context,x+origin.x,y+origin.y,cx div 2, startang*radtodeg, extentang*radtodeg);
  end
  else begin
   cairo_translate(fcairo.context,pos.x,pos.y);
   cairo_scale(fcairo.context,0,0.5);
   cairo_arc (fcairo.context,x+origin.x,y+origin.y, cx div 2, startang*radtodeg, extentang*radtodeg);
  end;
  cairo_stroke(fcairo.context);
 end;
end;

procedure tuniversalprintercanvas.cairo_fillarc;
begin
 with fdrawinfo.arc,rect^ do begin
  cairo_save(fcairo.context);
  cairo_new_sub_path(fcairo.context);
  if pieslice then begin
   cairopos(pos);
  end;
  if cy = cx then begin
   cairo_arc(fcairo.context,x+origin.x,y+origin.y,cx div 2,startang*radtodeg,extentang*radtodeg);
  end
  else begin
   cairo_translate(fcairo.context,pos.x,pos.y);
   cairo_scale(fcairo.context,0,0.5);
   cairo_arc (fcairo.context,x+origin.x,y+origin.y, cx div 2, startang*radtodeg, extentang*radtodeg);
  end;
  //cairo_close_path(fcairo.context);
  //cairo_clip(fcairo.context);
  cairo_fill(fcairo.context);
  cairo_restore(fcairo.context);
 end;
end;

procedure tuniversalprintercanvas.handlepoly(const points: ppointty; 
             const lastpoint: integer; const closed: boolean; const fill: boolean);
var
 int1: integer;
 startpoint: pointty;
begin
 if active then begin
  startpoint.x:= points^.x;
  startpoint.y:= points^.y;
  cairo_move_to (fcairo.context, startpoint.x,startpoint.y);
  for int1:= 1 to lastpoint do begin
   cairo_line_to (fcairo.context, ppointaty(points)^[int1].x, ppointaty(points)^[int1].y);
  end;
  if closed then begin
   cairo_line_to (fcairo.context, startpoint.x, startpoint.y);
  end;
  if fill then begin
   cairo_fill(fcairo.context);
  end
  else begin
   cairo_stroke(fcairo.context);
  end;
 end;
end;

procedure tuniversalprintercanvas.handleellipse(const rect: rectty; const fill: boolean);
begin
 with rect do begin
  cairo_arc (fcairo.context, pos.x, pos.y, cx div 2, 0, 360);
  cairo_stroke(fcairo.context);
 end;
 if fill then begin
  cairo_fill(fcairo.context);
 end;
end;

procedure tuniversalprintercanvas.cairo_drawlines;
begin
 with fdrawinfo.points do begin
  handlepoly(points,count-1,closed,false);
 end;
end;

procedure tuniversalprintercanvas.cairo_drawlinesegments;
var
 int1: integer;
begin
 with fdrawinfo.points do begin
  for int1:= 0 to count div 2 - 1 do begin
   handlepoly(points,1,false,false);
   inc(points,2);
  end;
 end;
end;

procedure tuniversalprintercanvas.cairo_fillpolygon;
begin
 with fdrawinfo.points do begin
  handlepoly(points,count-1,true,true);
 end;
end;

procedure tuniversalprintercanvas.cairo_fillrect;
var
 points1: array[0..3] of pointty;
begin
 with fdrawinfo.rect.rect^ do begin
  points1[0].x:= x;
  points1[0].y:= y;
  points1[1].x:= x+cx;
  points1[1].y:= y;
  points1[2].x:= x+cx;
  points1[2].y:= y+cy;
  points1[3].x:= x;
  points1[3].y:= y+cy;
  handlepoly(@points1,high(points1),true,true);
 end;
end;

procedure tuniversalprintercanvas.cairo_copyarea;
var
 cimage: Pcairo_surface_t; 
 image: imagety;
 maskbefore: tsimplebitmap;
 aresize: boolean;
 ax,ay: double;
 fcairoop: cairo_operator_t;
begin
 with fdrawinfo,copyarea do begin
  if not (df_canvasispixmap in tcanvas1(source).fdrawinfo.gc.drawingflags) then begin
   exit;
  end;
  {if mask<>nil then begin
   maskbefore:= mask;
   mask.canvas.copyarea(maskbefore.canvas,sourcerect^,nullpoint,rop_nor);
  end;}
  with tcanvas1(source).fdrawinfo do begin
   gdi_lock;
   gui_pixmaptoimage(paintdevice,image,gc.handle);
   gdi_unlock;
  end;
  if (destrect^.size.cx<>image.size.cx) or (destrect^.size.cy<>image.size.cy) then begin
   ax:= destrect^.size.cx/image.size.cx;
   ay:= destrect^.size.cy/image.size.cy;
   aresize:= true;
  end else begin
   aresize:= false;
   ay:= 1;
   ax:= 1;
  end;
  cairo_save(fcairo.context);
  cimage:= cairoimage(image,destrect^,CAIRO_FORMAT_RGB24);
  if aresize then begin
   cairo_scale(fcairo.context,ax,ay);
   cairo_set_source_surface(fcairo.context, cimage, destrect^.pos.x/ax, destrect^.pos.y/ay);
  end else begin
   cairo_set_source_surface(fcairo.context, cimage, destrect^.pos.x, destrect^.pos.y);
  end;
  cairo_paint(fcairo.context);
  //gui_freeimagemem(image.pixels);
  //image.pixels:= nil;
  cairo_surface_destroy(cimage);
  cimage:= nil;
  if aresize then begin
   cairo_scale(fcairo.context,1/ax,1/ay);
  end;
  cairo_restore(fcairo.context);
  if mask<>nil then begin
   gdi_lock;
   gui_pixmaptoimage(mask.handle,image,mask.canvas.gchandle);
   gdi_unlock;
   if image.length>0 then begin 
    cairo_save(fcairo.context);
    if (destrect^.size.cx<>image.size.cx) or (destrect^.size.cy<>image.size.cy) then begin
     ax:= destrect^.size.cx/image.size.cx;
     ay:= destrect^.size.cy/image.size.cy;
     aresize:= true;
    end else begin
     aresize:= false;
     ay:= 1;
     ax:= 1;
    end;
    cimage:= cairoimage(image,sourcerect^,CAIRO_FORMAT_RGB24);
    if aresize then begin
     cairo_scale(fcairo.context,ax,ay);
     cairo_rectangle(fcairo.context,destrect^.x/ax,destrect^.y/ay,destrect^.cx*ax,destrect^.cy*ay);
     cairo_clip(fcairo.context);
     cairo_set_operator (fcairo.context, CAIRO_OPERATOR_ADD);
     cairo_set_source_surface(fcairo.context,cimage,destrect^.x/ax,destrect^.y/ay);
    end else begin
     cairo_rectangle(fcairo.context,destrect^.x,destrect^.y,destrect^.cx,destrect^.cy);
     fcairoop:= cairo_get_operator(fcairo.context);
     cairo_clip(fcairo.context);
     cairo_set_operator (fcairo.context, CAIRO_OPERATOR_ADD);
     cairo_set_source_surface(fcairo.context,cimage,destrect^.x,destrect^.y);
    end;
    cairo_paint(fcairo.context);
    //gui_freeimagemem(image.pixels);
    //image.pixels:= nil;
    cairo_surface_destroy(cimage);
    cimage:= nil;
    cairo_set_operator (fcairo.context, fcairoop);
    if aresize then begin
     cairo_scale(fcairo.context,1/ax,1/ay);
    end;
    cairo_restore(fcairo.context);
   end;
  end;
 end; 
end;

procedure tuniversalprintercanvas.endpage;
begin
 if not fcairo.rawmode then begin
  cairo_show_page(fcairo.context);
 end;
 case fcairo.outputformat of
  cai_GDIPrinter:
   begin
    {$IFDEF WINDOWS}
    if fcairo.rawmode then begin
     if not fcairo.raw_continuespage then begin
      //endpageprinter(fcairo.gdiprinterhandle);
      fcairo.senddata(fcairo.esclist[esc_form_feed]);   
     end;
    end else begin
     windows.endpage(fcairo.gdiprinterdc);
    end;
    {$ENDIF}
   end;
  cai_PNG:
   begin
    cairo_surface_write_to_png(fcairo.fsurface,pchar(tosysfilepath(fcairo.outputfilename)+inttostr(fpagenum)));
   end;
 end;
end;

procedure tuniversalprintercanvas.beginpage;
begin
 inc(fpagenum);
 case fcairo.outputformat of
  cai_GDIPrinter:
   begin
    {$IFDEF WINDOWS}
    if not fcairo.rawmode then begin
     windows.startpage(fcairo.gdiprinterdc);
    end;
    {$ENDIF}
   end;
 end;
 initgcvalues;
 if not fcairo.rawmode then begin
  gsposcairo(makepoint(0,0));
 end;
 if fcairo.dpix=fcairo.dpiy then begin
  fy:= 1;
  fx:= 1;
 end else if fcairo.dpix>fcairo.dpiy then begin
  fx:= fcairo.dpiy/fcairo.dpix;
  fy:= 1;
 end else begin
  fx:= fcairo.dpiy/fcairo.dpix;
  fy:= 1;
 end;
end;

procedure tuniversalprintercanvas.nextpage;
begin
 endpage;
 beginpage;
end;

procedure tuniversalprintercanvas.gcdestroyed(const sender: tcanvas);
begin
 inherited;
end;

{ tuniversalprinter }

constructor tuniversalprinter.create(aowner: tcomponent);
begin
 inherited;
 flinesperpage:= 16;
 ftextasgraphic:= false;
 fantialias:= true;
 fcanvas:= tuniversalprintercanvas.create(self,icanvas(self));
 ffilename:='outputfile.pdf';
 forientation:= pao_portrait;
 fscalex:= 1;
 fscaley:= 1;
 fcopies:= 1;
 fpagestring:= '';
 foutputformat:= cai_pdf;
 {$IFDEF LINUX}
 fcupsprinters:=nil;
 fcupshttp    :=nil;
 fcupsppd     :=nil;
 fcupsoptions :=nil;
 fcupsnumopts :=0;
 libstatus:= cupslibinstalled;
 {$ENDIF}
end;

destructor tuniversalprinter.destroy;
var
 int1: integer;
begin
 {$IFDEF LINUX}
 fcupsprinters:=nil;
 fcupshttp    :=nil;
 fcupsppd     :=nil;
 fcupsoptions :=nil;
 FinalizeCups;
 {$ENDIF}
 if not frawmode then begin
  if fsurface<>nil then begin
   //cairo_surface_finish(fsurface);
   fsurface:= nil;
   cairo_surface_destroy(fsurface);
   fsurface:= nil;
  end;
  if fdraw<>nil then begin
   fdraw:= nil;
   cairo_destroy(fdraw);
  end;
 end;
 if fdrawermode=cdmSerial then begin
  fcommport:= nil;
 end;
 fcanvas.unlink;   
 fcanvas.destroy;
 inherited;
end;

{$IFDEF LINUX}
function tuniversalprinter.printfile(afilename: string): longint;
var
 aprintername : string;
begin
 result:=-1;
 if not libstatus then exit;
 afilename:=expandfilename(afilename);
 if length(printers)>0 then begin
  aprintername:= printername;
  result:= cupsprintfile(pchar(aprintername),pchar(afilename),
   pchar(self.title),fcupsnumopts,fcupsoptions);
 end;
end;

procedure tuniversalprinter.docupsconnect;
begin
 if not assigned(fcupshttp) then begin
  if not libstatus then exit;
  fcupshttp:=httpconnect(cupsserver(),ippport());
  if not assigned(fcupshttp) then
   showmessage('Unable to contact server!');
 end;
end;

function tuniversalprinter.getcupsrequest(aname: pcups_dest_t) : pipp_t;
var
 request   : pipp_t;
 language  : pcups_lang_t;
 uri       : array[0..http_max_uri] of char;
begin
 result:=nil;
 if not libstatus then exit;
 if aname=nil then exit;
 if assigned(aname) then begin
  docupsconnect;
  request:=ippnew();
  request^.request.op.operation_id := ipp_get_printer_attributes;
  request^.request.op.request_id   := 1;
  language:=cupslangdefault;

  ippaddstring(request, ipp_tag_operation, ipp_tag_charset,
           'attributes-charset', '', cupslangencoding(language));

  ippaddstring(request, ipp_tag_operation, ipp_tag_language,
           'attributes-natural-language', '', language^.language);

  uri:=format('ipp://localhost/printers/%s',[aname^.name]);
  ippaddstring(request,ipp_tag_operation,ipp_tag_uri,'printer-uri','',uri);

  result:=cupsdorequest(fcupshttp, request, '/');
  if assigned(result) then begin
   if (result^.request.status.status_code>ipp_ok_conflict) then begin
    ippdelete(result);
    result:=nil;
   end;
  end;
 end else begin
  showmessage(format('"%s" is not a valid printer.',[aname]));
 end;
end;

function tuniversalprinter.getattributestring(aprinter: pcups_dest_t; aname: pchar;
  const defaultvalue : string): string;
var
 reponse: pipp_t;
 attribute: pipp_attribute_t;
begin
 result:=defaultvalue;
 if not libstatus then exit;
 try
  reponse:=getcupsrequest(aprinter);
 except
 end;
 if assigned(reponse) then begin
  try
   attribute:=ippfindattribute(reponse,aname, ipp_tag_zero);
   if assigned(attribute) then begin
    result:=attribute^.values[0]._string.text;
   end else begin
    showmessage('Failed to get attribute aname="' + aname + '"');
   end;
  finally
   ippdelete(reponse);
  end;
 end;
end;
{$ENDIF}

function tuniversalprinter.showdialog: modalresultty;
var
 int1,prcount: integer;
 dia: tprinterdialog;
begin
 dia:= tprinterdialog.create(self);
 if length(fprinters)=0 then fprinters:= getprinters;
 dia.fprinters:= fprinters;
 prcount:=length(fprinters)-1;
 if prcount>=0 then begin
  for int1:=0 to prcount do begin
   dia.cprinters.dropdown.cols.addrow([fprinters[int1].printername]);
  end;
  dia.cprinters.value:= fprintername;
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
 dia.fpapers:= fpapers;
 prcount:=length(fpapers)-1;
 dia.cpaperwidth.value:=fwidth;
 dia.cpaperheight.value:=fheight;
 if prcount>=0 then begin
  for int1:=0 to prcount do begin
   dia.cpapers.dropdown.cols.addrow([fpapers[int1].name]);
  end;
  dia.cpapers.dropdown.itemindex:= getpaperindex(fpa_paperwidth,fpa_paperheight);
 end;
 
 dia.cleft.value:= fpa_marginleft;
 dia.cright.value:= fpa_marginright;
 dia.ctop.value:= fpa_margintop;
 dia.cbottom.value:= fpa_marginbottom;
 if forientation=pao_portrait then begin
  dia.cportrait.value:=true;
  dia.clandscape.value:=false;
 end else begin
  dia.cportrait.value:=false;
  dia.clandscape.value:=true;
 end;
 if fpagestring='' then begin
  dia.callpages.value:=true;
  dia.crangepage.value:=false;
  dia.crangestring.value:='';
 end else begin
  dia.callpages.value:=false;
  dia.crangepage.value:=true;
  dia.crangestring.value:=fpagestring;
 end;
 dia.listprintercode.dropdown.itemindex:= ord(fprncommand);
 dia.boolcontpage.value:= fcontinuespage;
 dia.boolrawmode.value:= frawmode;
 if fdraweraction=cdaNotOpen then begin
  dia.cdnotopen.value:= true;
 end else if fdraweraction=cdaOpenBefore then begin
  dia.cdopenbefore.value:= true;
 end else if fdraweraction=cdaOpenAfter then begin
  dia.cdopenafter.value:= true;
 end;
 if fdrawermode=cdmPrinter then begin
  dia.wrj45.value:= true;
 end else if fdrawermode=cdmSerial then begin
  dia.wrs232.value:= true;
 end;
 dia.boolcutpaper.value:= fcutpaper;
 result:= mr_cancel;
 dia.wdpix.value:= fscalex;
 dia.wdpiy.value:= fscaley;
 dia.edcopies.value:= fcopies;
 dia.wtextasgraph.value:= ftextasgraphic;
 dia.wantialias.value:= fantialias;
 dia.wlinesperpage.value:= flinesperpage;
 if dia.show(true)=mr_ok then begin
  fscalex:= dia.wdpix.value;
  fscaley:= dia.wdpiy.value;
  result:= mr_ok;
  fprintername:= dia.cprinters.value;
  fpa_marginleft:= dia.cleft.value;
  fpa_marginright:= dia.cright.value;
  fpa_margintop:= dia.ctop.value;
  fpa_marginbottom:= dia.cbottom.value;
  pagesizechanged;
  setrawmode(dia.boolrawmode.value);
  setprncommand(trawprintercommand(dia.listprintercode.dropdown.itemindex));
  fcontinuespage:= dia.boolcontpage.value;
  fcopies:= round(dia.edcopies.value);
  flinesperpage:= dia.wlinesperpage.value;
  if dia.cdnotopen.value then begin
   fdraweraction:= cdaNotOpen;
  end else if dia.cdopenbefore.value then begin
   fdraweraction:= cdaOpenBefore;
  end else if dia.cdopenafter.value then begin
   fdraweraction:= cdaOpenAfter;
  end;
  if dia.wrj45.value then begin
   fdrawermode:= cdmPrinter;
  end else if dia.wrs232.value then begin
   fdrawermode:= cdmSerial;
  end;
  fcutpaper:= dia.boolcutpaper.value;
  if dia.cportrait.value then begin
   forientation:= pao_portrait;
   fpa_paperwidth:= dia.cpaperwidth.value;
   fpa_paperheight:= dia.cpaperheight.value;
  end else begin
   forientation:= pao_landscape;
   fpa_paperheight:= dia.cpaperwidth.value;
   fpa_paperwidth:= dia.cpaperheight.value;
  end;
  ftextasgraphic:= dia.wtextasgraph.value;
  fantialias:= dia.wantialias.value;
  pagesizechanged;
  if dia.callpages.value then begin
   fpagestring:='';
  end else begin
   fpagestring:=dia.crangestring.value;
  end;
 end;  
 freeandnil(dia);
end;

procedure tuniversalprinter.pagesizechanged;
begin
 if forientation=pao_portrait then begin
  fwidth:= fpa_paperwidth;
  fheight:= fpa_paperheight;
  if not frawmode then begin
   fcanvas.fdrawinfo.gc.paintdevicesize.cx:= round(fwidth);
   fcanvas.fdrawinfo.gc.paintdevicesize.cy:= round(fheight);
  end;
 end else begin
  fheight:= fpa_paperwidth;
  fwidth:= fpa_paperheight;
  if not frawmode then begin
   fcanvas.fdrawinfo.gc.paintdevicesize.cx:= round(fheight);
   fcanvas.fdrawinfo.gc.paintdevicesize.cy:= round(fwidth);
  end;
 end;
 if not (csloading in componentstate) then begin
  sendchangeevent;
 end;
end;

procedure tuniversalprinter.newpage;
begin
 fcanvas.beginpage;
end;

procedure tuniversalprinter.endpage;
begin
 fcanvas.endpage;
end;

function tuniversalprinter.getprinters: printerarty;
var
 flags: dword;
 needed: dword;
 level: dword;
 infobuffer: pchar;
 infoptr: pchar;
 printercount: dword;
 counter: longint;
 i,num: integer;
 {$IFDEF LINUX}
 p : pcups_dest_t;
 {$ENDIF}
begin
 result:= nil;
 {$IFDEF WINDOWS}
 flags:= 2 or 4;
 needed:= 0;
 level:= 2;

 enumprinters(flags,nil,level,nil,0,needed,printercount);
 if needed > 0 then begin
  getmem(infobuffer,needed);
  fillchar(infobuffer^,needed,0);

  enumprinters(flags,nil,level,infobuffer,needed,needed,printercount);
  infoptr:= infobuffer;
  setlength(result, printercount);

  for counter:= 0 to high(result) do begin
   result[counter].printername:= strpas(pprinter_info_2(infoptr)^.pprintername);
   result[counter].drivername:= strpas(pprinter_info_2(infoptr)^.pdrivername);
   result[counter].location:= strpas(pprinter_info_2(infoptr)^.plocation);
   result[counter].port:= strpas(pprinter_info_2(infoptr)^.pportname);
   result[counter].description:= strpas(pprinter_info_2(infoptr)^.pcomment);
   result[counter].isdefault:= (fdefaultprinter = strpas(pprinter_info_2(infoptr)^.pprintername));
   result[counter].servername:= strpas(pprinter_info_2(infoptr)^.pservername);
   result[counter].sharename:= strpas(pprinter_info_2(infoptr)^.psharename);
   inc(infoptr,sizeof(printer_info_2));
  end;
  freemem(infobuffer);
 end;
 {$ELSE}
 if not libstatus then exit;

 num:=cupsgetdests(@fcupsprinters);
 setlength(result,num);
 for i:=0 to num-1 do begin
  p:=nil;
  p:=@fcupsprinters[i];
  if assigned(p) then begin
   result[i].printername:=p^.name;
   result[i].location:= GetAttributeString(p,'printer-location','');
   result[i].description:= GetAttributeString(p,'printer-info','');
   result[i].servername:= cupsServer()+':'+IntToStr(ippPort());  
   if p^.is_default<>0 then begin
    fdefprinter:= p^.name;
    result[i].isdefault:= true;
   end else begin
    result[i].isdefault:= false;
   end;
  end;
 end;
 {$ENDIF}
end;

procedure tuniversalprinter.setwidth(const avalue: real);
begin
 if avalue<>fwidth then begin
  fwidth:= avalue;
 end;
 if forientation=pao_portrait then
  fsize.cx:= round(fwidth)
 else
  fsize.cy:= round(fwidth);
end;

procedure tuniversalprinter.setheight(const avalue: real);
begin
 if avalue<>fheight then begin
  fheight:= avalue;
 end;
 if forientation=pao_portrait then
  fsize.cy:= round(fheight)
 else
  fsize.cx:= round(fheight);
end;

procedure tuniversalprinter.setorientation(const avalue: pageorientationty);
begin
 if avalue<>forientation then begin
  forientation:= avalue;
  pagesizechanged;
 end;
end;

function tuniversalprinter.getcanvas: tuniversalprintercanvas;
begin
 result:= fcanvas;
end;

procedure tuniversalprinter.beginrender;
var
 str1: string;
 {$IFDEF WINDOWS}
 info: tdocinfow;
 docinfo: tdocinfo1;
 pdev,pdevorig: pdevicemode;
 hDevMode: THandle;
 fformname: Array[0..31] of byte;
 {$ENDIF}
 dwret,devmodesize: integer;  
 bo1: boolean;
 fpaperindex: integer;
begin
 if fdrawermode=cdmSerial then begin
  if fcommport=nil then begin
   fcommport:= tcommport.create(self);
   fcommport.port:= fserialport;
  end;
  if not fcommport.active then begin
   fcommport.active:= true;
  end;
 end;
 if ftitle='' then ftitle:='Repaz Printing';
 fsurface:= nil;
 fdraw:= nil;
 with tuniversalprintercanvas(fcanvas) do begin
  pagenumber:= 0;
  case foutputformat of
  cai_PDF:
   begin
    str1:= tosysfilepath(ffilename);
    ftextasgraphic:= false;
    fantialias:= true;
    fsurface:= cairo_pdf_surface_create(pchar(str1),fwidth*fcanvas.ppmm,fheight*fcanvas.ppmm);
    fdraw:= cairo_create(fsurface);
    fppinchx := 72;
    fppinchy := 72;
   end;
  cai_PostScript:
   begin
    ftextasgraphic:= false;
    fantialias:= true;
    str1:= tosysfilepath(ffilename);
    fsurface:= cairo_ps_surface_create(pchar(str1),fwidth*fcanvas.ppmm,fheight*fcanvas.ppmm);
    fdraw:= cairo_create(fsurface);
    fppinchx := 72;
    fppinchy := 72;
   end;
  cai_SVG:
   begin
    ftextasgraphic:= false;
    fantialias:= true;
    str1:= tosysfilepath(ffilename);
    fsurface:= cairo_svg_surface_create(pchar(str1),fwidth*fcanvas.ppmm,fheight*fcanvas.ppmm);
    fdraw:= cairo_create(fsurface);
    fppinchx := 72;
    fppinchy := 72;
   end;
  cai_PNG:
   begin
    ftextasgraphic:= false;
    fantialias:= true;
    str1:= tosysfilepath(ffilename);
    fsurface:= cairo_image_surface_create (CAIRO_FORMAT_RGB24, round(fwidth), round(fheight));
    fdraw:= cairo_create(fsurface);
    fppinchx := 72;
    fppinchy := 72;
   end;
  cai_GDIPrinter:
   begin
    {$IFDEF WINDOWS}
    checkprinterror(integer(openprinter(pchar(fprintername), fprinterhandle, nil)),'Can''t open printer!');
    if fprinterhandle=0 then begin
     exit;
    end;
    if not rawmode then begin
     devmodesize := DocumentProperties(0,fprinterhandle,pchar(fprintername),nil,nil, 0);
     hDevMode := GlobalAlloc(GHND, devmodesize); 
     pdev := GlobalLock(hDevMode);
     dwret := DocumentProperties(0,fprinterhandle,pchar(fprintername),pdev,nil,DM_OUT_BUFFER);
     if forientation=pao_portrait then begin
      pdev^.dmOrientation:= DMORIENT_PORTRAIT;
     end else begin
      pdev^.dmOrientation:= DMORIENT_LANDSCAPE;
     end;
     fpaperindex:= getpaperindex(fpa_paperwidth,fpa_paperheight);
     pdev^.dmFormName := pbyte(fpapers[fpaperindex].name);
     pdev^.dmFields := DM_ORIENTATION or DM_FORMNAME;
     dwret := DocumentProperties(0,fprinterhandle,pchar(fprintername),pdev, 
      pdev, DM_IN_BUFFER or DM_OUT_BUFFER);
     bo1 := (dwret=idok);
     fgcprinter:= createdc('WINSPOOL',pansichar(fprintername),nil,pdev);
     GlobalUnlock(hDevMode); 
     GlobalFree(hDevMode); 
     setmapmode(fgcprinter, MM_TEXT);
     fillchar(info,sizeof(info),0);
     info.cbsize:= sizeof(info);
     info.lpszdocname:= pwidechar(self.title);
     checkprinterror(startdocw(fgcprinter,@info),'can not start print job for "'+self.title+'".');
     fsurface:= cairo_win32_printing_surface_create(fgcprinter);
     fdraw:= cairo_create(fsurface);
     fppinchx := GetDeviceCaps(fgcprinter, LOGPIXELSX);
     fppinchy := GetDeviceCaps(fgcprinter, LOGPIXELSY);
     if forientation=pao_portrait then begin
      cairo_scale(fdraw,(fppinchx/72)*fscalex,(fppinchy/72)*fscaley);
     end else if forientation=pao_landscape then begin
      cairo_scale(fdraw,(fppinchx/72)*fscalex,(fppinchy/72)*fscaley);
     end;
    end else begin
     with docinfo do
     begin
       pdocname := pchar(string(self.title));
       poutputfile := nil;
       pdatatype := pchar('raw');
     end;
     checkprinterror(startdocprinter(fprinterhandle, 1, @docinfo),'Can''t open printer!');
     senddata(esclist[esc_init]);
     if not fcontinuespage then begin
      senddata(esclist[esc_linesperpage]+chr(flinesperpage));
     end;
    end;
    if raw_draweraction=cdaOpenBefore then begin
     if fdrawermode=cdmSerial then begin
      fcommport.thread.writestring(esclist[esc_open_drawer]);
     end else if fdrawermode=cdmPrinter then begin
      senddata(esclist[esc_open_drawer]);
     end;
    end;
    {$ENDIF}
   end;
  cai_CUPS:
   begin
    {$IFDEF LINUX}
    ftextasgraphic:= false;
    fantialias:= true;
    if not rawmode then begin
     ffilename:= sys_gettempdir+'tmpcups.ps';
     str1:= tosysfilepath(ffilename);
     fsurface:= cairo_ps_surface_create(pchar(str1),fwidth*fcanvas.ppmm,fheight*fcanvas.ppmm);
     if forientation=pao_landscape then begin
      cairo_rotate(fdraw,90*radtodeg);
     end;
     fdraw:= cairo_create(fsurface);
     fppinchx := 72;
     fppinchy := 72;
     if not ((fscalex=1) and (fscaley=1)) then begin
      cairo_scale(fdraw,fscalex,fscaley);
     end;
    end else begin
     ffilename:= tosysfilepath(sys_gettempdir+'tmpcups.raw');
     frawstream:= nil;
     frawstream:= tmsefilestream.create(ffilename,fm_create);
     senddata(esclist[esc_init]);
     if not fcontinuespage then begin
      senddata(esclist[esc_linesperpage]+chr(flinesperpage));
     end;
    end;
    if raw_draweraction=cdaOpenBefore then begin
     if fdrawmode=cdmSerial then begin
      fcommport.thread.writestring(esclist[esc_open_drawer]);
     end else if fdrawmode=cdmPrinter then begin
      senddata(esclist[esc_open_drawer]);
     end;
    end;
    {$ENDIF}
   end;
  end;
  if not frawmode then begin
   if not fantialias then begin
    cairo_set_antialias(fdraw,CAIRO_ANTIALIAS_NONE);
   end;
  end;
 end;
end;

procedure tuniversalprinter.endrender;
begin
 case foutputformat of
 cai_GDIPrinter:
  begin
   {$IFDEF WINDOWS}
   //cairo_font_options_destroy (cfont_options);
   if not frawmode then begin
    cairo_destroy(fdraw);
    cairo_surface_destroy(fsurface);
   end;
   if raw_cutpaperonfinish then begin
    senddata(esclist[esc_cut_paper]);
   end;
   if raw_draweraction=cdaOpenAfter then begin
    if fdrawermode=cdmSerial then begin
     fcommport.thread.writestring(esclist[esc_open_drawer]);
    end else if fdrawermode=cdmPrinter then begin
     senddata(esclist[esc_open_drawer]);
    end;
   end;
   if not frawmode then begin
    windows.enddoc(gdiprinterdc);
   end;
   deletedc(gdiprinterdc);
   closeprinter(fprinterhandle);
   fprinterhandle:= 0;
   {$ENDIF}
  end;
 cai_CUPS:
  begin
   {$IFDEF LINUX}
   if not frawmode then begin
    cairo_destroy(fdraw);
    cairo_surface_destroy(fsurface);
   end;
   if raw_cutpaperonfinish then begin
    senddata(esclist[esc_cut_paper]);
   end;
   if raw_draweraction=cdaOpenAfter then begin
    if fdrawmode=cdmSerial then begin
     fcommport.thread.writestring(esclist[esc_open_drawer]);
    end else if fdrawmode=cdmPrinter then begin
     senddata(esclist[esc_open_drawer]);
    end;
   end;
   //if (frawstream<>nil) and (frawstream.size>0) then begin
    printfile(ffilename);
   //end;
   {$ENDIF}
  end;
 else
  begin
   cairo_destroy(fdraw);
   cairo_surface_destroy(fsurface);
  end;
 end;
end;

procedure tuniversalprinter.gcneeded(const sender: tcanvas);
var
 gc1: gcty;
begin
 if not (sender is tuniversalprintercanvas) then begin
  guierror(gue_invalidcanvas);
 end;
 with tuniversalprintercanvas(sender) do begin
  fillchar(gc1,sizeof(gc1),0);
  gc1.handle:= invalidgchandle;
  gc1.drawingflags:= [df_highresfont];
  gc1.paintdevicesize:= makesize(round(fwidth),round(fheight));
  linktopaintdevice(ptrint(self),gc1,nullpoint);
 end;
end;

function tuniversalprinter.getmonochrome: boolean;
begin
 result:= false;
end;

function tuniversalprinter.getsize: sizety;
begin
 if not frawmode then begin
  result:= fcanvas.fdrawinfo.gc.paintdevicesize;
 end;
end;

procedure tuniversalprinter.setprncommand(acommandtype: trawprintercommand);
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
     fesclist[esc_linesperpage]  := #27#67;     
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
     fesclist[esc_linesperpage]  := #27#67;
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
     fesclist[esc_linesperpage]  := #27#67;
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
     fesclist[esc_linesperpage]  := #27#67;
   end;
 end;
end;

procedure tuniversalprinter.defineescapecode(esccommand: integer; escstring: string);
begin
  if esccommand > esc_max then exit;
  fesclist[esccommand] := escstring;
end;

procedure tuniversalprinter.setmarginleft(const avalue: real);
begin
 fpa_marginleft:= avalue;
end;

procedure tuniversalprinter.setmargintop(const avalue: real);
begin
 fpa_margintop:= avalue;
end;

procedure tuniversalprinter.setmarginright(const avalue: real);
begin
 fpa_marginright:= avalue;
end;

procedure tuniversalprinter.setmarginbottom(const avalue: real);
begin
 fpa_marginbottom:= avalue;
end;

procedure tuniversalprinter.writemarginleft(writer: twriter);
begin
 writer.writefloat(fpa_marginleft);
end;

procedure tuniversalprinter.writemargintop(writer: twriter);
begin
 writer.writefloat(fpa_margintop);
end;

procedure tuniversalprinter.writemarginright(writer: twriter);
begin
 writer.writefloat(fpa_marginright);
end;

procedure tuniversalprinter.writemarginbottom(writer: twriter);
begin
 writer.writefloat(fpa_marginbottom);
end;

procedure tuniversalprinter.readmarginleft(reader: treader);
begin
 fpa_marginleft:= reader.readfloat;
end;

procedure tuniversalprinter.readmargintop(reader: treader);
begin
 fpa_margintop:= reader.readfloat;
end;

procedure tuniversalprinter.readmarginright(reader: treader);
begin
 fpa_marginright:= reader.readfloat;
end;

procedure tuniversalprinter.readmarginbottom(reader: treader);
begin
 fpa_marginbottom:= reader.readfloat;
end;

procedure tuniversalprinter.dostatread(const reader: tstatreader);
begin
 with reader do begin
  setrawmode(readboolean('rawmode',frawmode));
  setprncommand(trawprintercommand(readinteger('printercode',ord(fprncommand))));
  fcutpaper:= readboolean('cutpaperonfinished',fcutpaper);
  fcontinuespage:= readboolean('continuespage',fcontinuespage);
  printername:= readstring('printername',fprintername);
  fpa_paperwidth:= readreal('paperwidth',fpa_paperwidth);
  fpa_paperheight:= readreal('paperheight',fpa_paperheight);
  flinesperpage:= readinteger('linesperpage',flinesperpage);
  forientation:= pageorientationty(readinteger('orientation',
             ord(forientation),0,ord(high(pageorientationty))));
  if not frawmode then begin
   pagesizechanged;
  end;
  fpa_marginleft:= readreal('marginleft',fpa_marginleft);
  fpa_margintop:= readreal('margintop',fpa_margintop);
  fpa_marginright:= readreal('marginright',fpa_marginright);
  fpa_marginbottom:= readreal('marginbottom',fpa_marginbottom);
  fdraweraction:= draweractionty(readinteger('draweraction',ord(fdraweraction)));
  fdrawermode:= drawermodety(readinteger('drawmode',ord(fdrawermode)));
  fserialport:= commnrty(readinteger('drawport',ord(fserialport)));
 end;
end;

procedure tuniversalprinter.dostatwrite(const writer: tstatwriter);
begin
 with writer do begin
  writeboolean('rawmode',frawmode);
  writeinteger('printercode',ord(fprncommand));
  writeboolean('cutpaperonfinished',fcutpaper);
  writeboolean('continuespage',fcontinuespage);
  writestring('printername',fprintername);
  writereal('paperwidth',fpa_paperwidth);
  writereal('paperheight',fpa_paperheight);
  writeinteger('linesperpage',flinesperpage);
  writeinteger('orientation',ord(forientation));
  writereal('marginleft',fpa_marginleft);
  writereal('margintop',fpa_margintop);
  writereal('marginright',fpa_marginright);
  writereal('marginbottom',fpa_marginbottom);
  writeinteger('draweraction',ord(fdraweraction));
  writeinteger('drawermode',ord(fdrawermode));
  writeinteger('drawport',ord(fserialport));
 end;
end;

procedure tuniversalprinter.statreading;
begin
 //dummy
end;

procedure tuniversalprinter.statread;
begin
 //dummy
end;

function tuniversalprinter.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

function tuniversalprinter.getpapername: msestring;
var
 int1: integer;
begin
 int1:= getpaperindex(fpa_paperwidth,fpa_paperheight);
 if int1=-1 then
  result:= 'Custom'
 else
  result:= fpapers[int1].name;
end;

procedure tuniversalprinter.setstatfile(const avalue: tstatfile);
begin
 setstatfilevar(istatfile(self),avalue,fstatfile);
end;

procedure tuniversalprinter.setprintername(const avalue: string);
begin
 if avalue<>'' then begin
  checkvalidprinter(avalue);
  fpapers:= getprinterpapers(fprintername);
 end;
end;

procedure tuniversalprinter.setpaperwidth(const avalue: real);
begin
 fpa_paperwidth:= avalue;
 pagesizechanged;
end;

procedure tuniversalprinter.setpaperheight(const avalue: real);
begin
 fpa_paperheight:= avalue;
 pagesizechanged;
end;

procedure tuniversalprinter.setrawmode(const avalue: boolean);
begin
 if avalue<>frawmode then begin
   frawmode := avalue;
   if frawmode then begin
    if fcanvas<>nil then begin
     fcanvas.unlink;
    end;
   end;
 end;
end;

function tuniversalprinter.getpaperindex(awidth: real; aheight: real): integer;
var
 int1,fprintercount: integer;
 twidth: real; theight: real;
begin
 fprintercount:= length(fpapers);
 if fprintercount=0 then begin
  result:=-1;
  exit;
 end;
 result:= fprintercount-1;
 if forientation=pao_portrait then begin
  twidth:= awidth;
  theight:= aheight; 
 end else begin
  theight:= awidth;
  twidth:= aheight; 
 end;
 for int1:=0 to length(fpapers)-1 do begin
  if (round(fpapers[int1].width)=round(twidth)) and (round(fpapers[int1].height)=round(theight)) then begin
   result:= int1;
   break;
  end;
 end;
 if result=fprintercount-1 then begin
  if (twidth=0) or (theight=0) then begin
   result:= 0;
  end else begin
   fpapers[result].width:= twidth;
   fpapers[result].height:= theight;
  end;
 end;
end;

function tuniversalprinter.getprinterpapers(aprintername: string): stdpagearty; 
var 
 int1     : integer;
 typeloop,suportedpapers,namecount,ppapersizecount: integer;
 papersize : pointarty;
 papername : pchar;
 {$IFDEF LINUX}
 reponse   : pipp_t;
 attribute : pipp_attribute_t;
 i         : integer;
 p         : pcups_dest_t;
 ppr       : pppd_size_t;
 fn        : string;
 supportedpapers: integer;
 {$ENDIF} 
begin
 int1:= printerindex;
 result:=nil;
 papersize:=nil;
 if int1=-1 then begin
  printername:= getdefaultprinter;
  int1:= printerindex;
  if int1=-1 then exit;
 end;
 {$IFDEF WINDOWS}
 suportedpapers:=devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
 dc_papers,nil,nil);
 if suportedpapers<0 then exit;
 setlength(result,suportedpapers+1);
 setlength(papersize,suportedpapers);
 //papersize names
 namecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
 dc_papernames, nil, nil);
 if namecount <> 0 then begin
  getmem(papername,64*namecount);
  namecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
  dc_papernames, pchar(@papername[0]), nil)
 end;
 //papersize dimensions
 ppapersizecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
 dc_papersize, nil, nil);
 if ppapersizecount <> 0 then begin
  ppapersizecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
  dc_papersize, @papersize[0], nil);
 end;
 for typeloop := 0 to suportedpapers-1 do begin
  if namecount > 0 then begin
   result[typeloop].name:= strpas(papername+typeloop*64);
  end else begin
   result[typeloop].name := 'custom (' + realtostr(result[typeloop].width) +
   ' x ' + realtostr(result[typeloop].height) + 'mm'; 
  end;
  if ppapersizecount > 0 then begin
   result[typeloop].width := (papersize[typeloop].x / 10);;
   result[typeloop].height := (papersize[typeloop].y / 10);
  end;
  result[typeloop].paperindex := typeloop;
 end;
 result[suportedpapers].name:='Custom Paper';
 result[suportedpapers].width:=0;
 result[suportedpapers].height:=0;
 result[suportedpapers].paperindex:=suportedpapers;
 freemem(papername);
 papersize:=nil;
 {$ENDIF}
 {$IFDEF LINUX}
 if assigned(fcupsppd) then begin
  ppdclose(fcupsppd);
 end;
 fcupsppd:=nil;
 fn:=cupsgetppd(pchar(aprintername));
 fcupsppd:=ppdopenfile(pchar(fn));

 p:=nil;
 p:=@fcupsprinters[int1];
 reponse:=getcupsrequest(p);
 if not assigned(reponse) then begin
  showmessage('Get enum attribute string no reponse');
 end else begin
  try
   attribute:=ippfindattribute(reponse, 'media-supported', ipp_tag_zero);
   if assigned(attribute) then begin
    setlength(result,attribute^.num_values+1);
    supportedpapers:= attribute^.num_values;
    for i:=0 to supportedpapers-1 do begin
     if attribute^.value_tag=ipp_tag_integer then
      result[i].name:= inttostr(pipp_value_t(@attribute^.values)[i].ainteger)
     else
      result[i].name:= pipp_value_t(@attribute^.values)[i]._string.text;
     ppr:= nil;
     ppr:= ppdpagesize(fcupsppd,pchar(result[i].name));
     if assigned(ppr) then begin
      result[i].width := (ppr^.width/72)*25.4;
      result[i].height := (ppr^.length/72)*25.4;
      result[i].paperindex := i;
     end else begin
      result[i].width := 210;
      result[i].height := 297;
      result[i].paperindex := i;
     end;    
    end;
    result[supportedpapers].name:='Custom Paper';
    result[supportedpapers].width:=0;
    result[supportedpapers].height:=0;
    result[supportedpapers].paperindex:=supportedpapers;
   end else begin
    showmessage('Attribute not found!');
   end;
  finally
   ippdelete(reponse);
  end;
 end;
 {$ENDIF}
end;

function tuniversalprinter.getdefaultprinter: string;
const
 maxlen = 2048;
var
 int1: integer;
 aresult: boolean;
begin
 {$IFDEF LINUX}
 if not libstatus then exit;
 result:= fdefprinter;
 {$ENDIF}
 {$IFDEF WINDOWS}
 int1:= maxlen;
 setlength(result,int1);
 aresult:= getdefaultprintera(pchar(result),@int1);
 setlength(result,int1-1);
 fdefaultprinter:= result;
 {$ENDIF}
end;

function tuniversalprinter.getprinterindex: integer;
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

procedure tuniversalprinter.checkvalidprinter(aprintername: string);
var
 int1: integer;
 valid: boolean;
begin
 if length(fprinters)=0 then begin
  fprinters:= getprinters;
 end;
 valid:= false;
 for int1:=0 to length(fprinters)-1 do begin
  if lowercase(aprintername)=lowercase(fprinters[int1].printername) then begin
   valid:= true;
   fprintername:= fprinters[int1].printername;
   break;
  end;
 end;
 if not valid then begin
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

procedure tuniversalprinter.senddata(const text: string);
var
 aresult: dword;
begin
 {$IFDEF WINDOWS}
 if fprinterhandle<>0 then begin
  writeprinter(fprinterhandle, pointer(text), length(text), aresult);
 end;
 {$ENDIF}
 {$IFDEF LINUX}
 frawstream.writedatastring(text);
 {$ENDIF}
end;

procedure tuniversalprinter.setrawfont(avalue: rawfontty);
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

procedure tuniversalprinter.setcanvas(const avalue: tuniversalprintercanvas);
begin
 fcanvas.assign(avalue);
end;

procedure tuniversalprinter.writeln(const avalue: msestring = '');
begin
 if frawmode then begin
  {$IFDEF DEBUG_POSPRINTER}
  debugwriteln(avalue);
  {$ENDIF}
  senddata(avalue + fesclist[esc_line_feed]);
 end;
end;

procedure tuniversalprinter.writelines(const alines: array of msestring);
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
 end;
end;

procedure tuniversalprinter.writelines(const alines: msestringarty);
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
 end;
end;

function tuniversalprinter.rawfontdata(const afont: rawfontty): string;
begin
 case afont of
  rfNormal : result:= fesclist[esc_normal];
  rfCourier: result:= fesclist[esc_courier];
  rfCondensed:  result:= fesclist[esc_condensed];
  rfExpanded: result:= fesclist[esc_expanded];
  rfDoubleHeight: result:= fesclist[esc_doubleheight];
 end;
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
 tuniversalprinter(self.owner).printername:= avalue; 
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
 tuniversalprinter(self.owner).printername:= cprinters.value;
 fpapers:= tuniversalprinter(self.owner).papers;
 prcount:=length(fpapers)-1;
 cpapers.dropdown.cols.clear;
 if prcount>=0 then begin
  for int1:=0 to prcount do begin
   cpapers.dropdown.cols.addrow([fpapers[int1].name]);
  end;
  cpapers.dropdown.itemindex:= 0;
 end;
end;

initialization
 gdifuncs:= gui_getgdifuncs;
 gdifunctions:= gdifuncs^; //default
 gdifunctions[gdf_destroygc]:= {$ifdef FPC}@{$endif}gdi_destroygc;
 gdifunctions[gdf_changegc]:= {$ifdef FPC}@{$endif}gdi_changegc;
 gdifunctions[gdf_drawlines]:= {$ifdef FPC}@{$endif}gdi_drawlines;
 gdifunctions[gdf_drawlinesegments]:= {$ifdef FPC}@{$endif}gdi_drawlinesegments;
 gdifunctions[gdf_drawellipse]:= {$ifdef FPC}@{$endif}gdi_drawellipse;
 gdifunctions[gdf_drawarc]:= {$ifdef FPC}@{$endif}gdi_drawarc;
 gdifunctions[gdf_fillrect]:= {$ifdef FPC}@{$endif}gdi_fillrect;
 gdifunctions[gdf_fillelipse]:= {$ifdef FPC}@{$endif}gdi_fillelipse;
 gdifunctions[gdf_fillarc]:= {$ifdef FPC}@{$endif}gdi_fillarc;
 gdifunctions[gdf_fillpolygon]:= {$ifdef FPC}@{$endif}gdi_fillpolygon;
 gdifunctions[gdf_drawstring16]:= {$ifdef FPC}@{$endif}gdi_drawstring16;
 gdifunctions[gdf_setcliporigin]:= {$ifdef FPC}@{$endif}gdi_setcliporigin;
 gdifunctions[gdf_copyarea]:= {$ifdef FPC}@{$endif}gdi_copyarea;
 {$IFDEF WINDOWS}
 initgdiprint;
 {$ENDIF}

end.
