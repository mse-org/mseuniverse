{*********************************************************}
{                      MSE Cairo                          }
{             Copyright : Sri Wahono '2011                }
{             Included package with Repaz                 }
{*********************************************************}
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{              http://www.msegui.org/repaz                }
{                                                         }
{*********************************************************}
unit msecairo;

{$ifdef FPC}{$mode objfpc}{$goto on}{$h+}{$endif}

interface

uses
 msegraphics,mseguiglob,mseclasses,classes,msegraphutils,msestream,msestrings,msetypes,
 msedrawtext,mserichstring,cairo,msefileutils,msebitmap;

type

 tmsecairocanvas = class;

 tmsecairo = class(tnullinterfacedpersistent,icanvas)
  private
   fsurface : Pcairo_surface_t;
   fcanvas: tmsecairocanvas;
   forientation: integer; //0=portrait, 1=landscape
   function getcanvas: tmsecairocanvas;
   procedure setwidth(const avalue: real);
   procedure setheight(const avalue: real);
   procedure setorientation(const avalue: integer);
   //icanvas
   procedure gcneeded(const sender: tcanvas);
   function getmonochrome: boolean;
   function getsize: sizety;
  public
   ffilename: filenamety;
   fsize: sizety;
   fwidth,fheight: real;   
   constructor create; override;
   destructor destroy; override;
   procedure beginrender;
   procedure endrender;
   property canvas: tmsecairocanvas read getcanvas;
  published
   property outputfilename: filenamety read ffilename write ffilename;
   property width: real read fwidth write setwidth;
   property height: real read fheight write setheight;
   property orientation: integer read forientation write setorientation;
 end;

 tmsecairocanvas = class(tcanvas)
  protected
   fdraw: Pcairo_t;
   fcairo: tmsecairo;
   cpattern: Pcairo_pattern_t;
   procedure gcdestroyed(const sender: tcanvas); override;
   procedure reset; override;
   function createpattern(const sourcerect,destrect: rectty; 
                   const acolorbackground,acolorforeground: colorty;
                   const acanvas: tcanvas): Pcairo_pattern_t;
   function getgdifuncs: pgdifunctionaty; override;
   procedure initgcstate; override;
   procedure initgcvalues; override;
   procedure finalizegcstate; override;  
   procedure gsposcairo(const apos: pointty);
   procedure cairopos(const apos: pointty);
   procedure cairo_drawstring16;
   procedure cairo_drawarc;
   procedure cairo_destroygc;
   procedure cairo_changegc;
   procedure handlepoly(const points: ppointty; 
             const lastpoint: integer; const closed: boolean; const fill: boolean);
   procedure handleellipse(const rect: rectty; const fill: boolean);
   procedure cairo_drawlines;
   procedure cairo_drawlinesegments;
   
   procedure cairo_fillpolygon;
   procedure cairo_fillarc;
   procedure cairo_fillrect;
   procedure cairo_copyarea;
  public
   constructor create(const user: tmsecairo; const intf: icanvas);
   procedure beginpage;
   procedure endpage;
   procedure nextpage;
 end;


implementation

uses
 msegui,msesys,sysutils,msedatalist,mseformatstr,
 mseguiintf,msebits,msereal;
type
 pdfgcdty = record
  canvas: tmsecairocanvas;
 end;
 cairogcty = record
  case integer of
   0: (d: pdfgcdty);
   1: (_bufferspace: gcpty;);
 end;

 tsimplebitmap1 = class(tsimplebitmap); 
 tcanvas1 = class(tcanvas);
 tfont1 = class(tfont);
 
const
 radtodeg = 360/(2*pi);
var
 gdifuncs: pgdifunctionaty;

procedure gui_destroygc(var drawinfo: drawinfoty);
begin
 try
  cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_destroygc;
 except //trap for stream write errors
 end;
end;
 
procedure gui_changegc(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_changegc;
end;

procedure gui_drawlines(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawlines;
end;

procedure gui_drawlinesegments(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawlinesegments;
end;

procedure gui_drawellipse(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.handleellipse(
                        drawinfo.rect.rect^,false);
end;

procedure gui_drawarc(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawarc;
end;

procedure gui_fillrect(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_fillrect;
end;

procedure gui_fillelipse(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.handleellipse(
                        drawinfo.rect.rect^,true);
end;

procedure gui_fillarc(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_fillarc;
end;

procedure gui_fillpolygon(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_fillpolygon;
end;

procedure gui_drawstring16(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_drawstring16;
end;

procedure gui_setcliporigin(var drawinfo: drawinfoty);
begin
// gdierror(gde_notimplemented);
end;

procedure gui_createemptyregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_createemptyregion](drawinfo);
end;

procedure gui_createrectregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_createrectregion](drawinfo);
end;

procedure gui_createrectsregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_createrectsregion](drawinfo);
end;

procedure gui_destroyregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_destroyregion](drawinfo);
end;

procedure gui_copyarea(var drawinfo: drawinfoty);
begin
 cairogcty(drawinfo.gc.platformdata).d.canvas.cairo_copyarea;
end;

procedure gui_copyregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_copyregion](drawinfo);
end;

procedure gui_moveregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_moveregion](drawinfo);
end;

procedure gui_regionisempty(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regionisempty](drawinfo);
end;

procedure gui_regionclipbox(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regionclipbox](drawinfo);
end;

procedure gui_regsubrect(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regsubrect](drawinfo);
end;

procedure gui_regsubregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regsubregion](drawinfo);
end;

procedure gui_regaddrect(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regaddrect](drawinfo);
end;

procedure gui_regaddregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regaddregion](drawinfo);
end;

procedure gui_regintersectrect(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regintersectrect](drawinfo);
end;

procedure gui_regintersectregion(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_regintersectregion](drawinfo);
end;
      
procedure gui_fonthasglyph(var drawinfo: drawinfoty);
begin
 gdifuncs^[gdi_fonthasglyph](drawinfo);
end;

const
 gdifunctions: gdifunctionaty = (
   {$ifdef FPC}@{$endif}gui_destroygc,
   {$ifdef FPC}@{$endif}gui_changegc,
   {$ifdef FPC}@{$endif}gui_drawlines,
   {$ifdef FPC}@{$endif}gui_drawlinesegments,
   {$ifdef FPC}@{$endif}gui_drawellipse,
   {$ifdef FPC}@{$endif}gui_drawarc,
   {$ifdef FPC}@{$endif}gui_fillrect,
   {$ifdef FPC}@{$endif}gui_fillelipse,
   {$ifdef FPC}@{$endif}gui_fillarc,
   {$ifdef FPC}@{$endif}gui_fillpolygon,
//   {$ifdef FPC}@{$endif}gui_drawstring,
   {$ifdef FPC}@{$endif}gui_drawstring16,
   {$ifdef FPC}@{$endif}gui_setcliporigin,
   {$ifdef FPC}@{$endif}gui_createemptyregion,
   {$ifdef FPC}@{$endif}gui_createrectregion,
   {$ifdef FPC}@{$endif}gui_createrectsregion,
   {$ifdef FPC}@{$endif}gui_destroyregion,
   {$ifdef FPC}@{$endif}gui_copyregion,
   {$ifdef FPC}@{$endif}gui_moveregion,
   {$ifdef FPC}@{$endif}gui_regionisempty,
   {$ifdef FPC}@{$endif}gui_regionclipbox,
   {$ifdef FPC}@{$endif}gui_regsubrect,
   {$ifdef FPC}@{$endif}gui_regsubregion,
   {$ifdef FPC}@{$endif}gui_regaddrect,
   {$ifdef FPC}@{$endif}gui_regaddregion,
   {$ifdef FPC}@{$endif}gui_regintersectrect,
   {$ifdef FPC}@{$endif}gui_regintersectregion,
   {$ifdef FPC}@{$endif}gui_copyarea,
   {$ifdef FPC}@{$endif}gui_fonthasglyph
 );

function cairoimage(aimage: imagety): Pcairo_surface_t;
var
 int1,stridewidth: integer;
 po1: pointer;
 adata: pbyte;
begin
 int1:= aimage.size.cx*aimage.size.cy*4;
 getmem(adata,int1);
 po1:= pointer(aimage.pixels);
 move(po1^,adata^,int1);
 stridewidth:= cairo_format_stride_for_width(CAIRO_FORMAT_RGB24,aimage.size.cx);
 result:= cairo_image_surface_create_for_data(adata,CAIRO_FORMAT_RGB24,aimage.size.cx,aimage.size.cy,stridewidth);
end;

{ tmsecairocanvas }

constructor tmsecairocanvas.create(const user: tmsecairo; const intf: icanvas);
begin
 inherited create(user,intf);
 fcairo:= user;
 //fstate:= fstate+[cs_highresdevice];
end;

procedure tmsecairocanvas.reset;
begin
 inherited;
 restore(1);
 save;
 clipregion:= 0;
 origin:= nullpoint;
end;

function tmsecairocanvas.getgdifuncs: pgdifunctionaty;
begin
 result:= @gdifunctions;
end;

procedure tmsecairocanvas.initgcstate;
begin
 inherited;
 with cairogcty(fdrawinfo.gc.platformdata).d do begin
  canvas:= self;
 end;
 if fcairo.orientation=0 then begin
  cairo_pdf_surface_set_size(fcairo.fsurface,fcairo.width*self.ppmm,fcairo.height*self.ppmm);
 end else begin
  cairo_pdf_surface_set_size(fcairo.fsurface,fcairo.height*self.ppmm,fcairo.width*self.ppmm);
 end;
 beginpage;
end;

procedure tmsecairocanvas.initgcvalues;
begin
 inherited;
end;

procedure tmsecairocanvas.finalizegcstate;
begin
 inherited;
end;

procedure tmsecairocanvas.cairopos(const apos: pointty);
begin
 if not (cs_origin in fstate) then begin
  checkgcstate([cs_origin]);
 end;
 cairo_move_to(fdraw, apos.x, apos.y);
end;

procedure tmsecairocanvas.gsposcairo(const apos: pointty);
begin
 cairo_move_to(fdraw, apos.x, apos.y);
end;

procedure tmsecairocanvas.cairo_destroygc;
begin
end;

function tmsecairocanvas.createpattern(const sourcerect,destrect: rectty; 
                   const acolorbackground,acolorforeground: colorty;
                   const acanvas: tcanvas): Pcairo_pattern_t;
var
 image: imagety;
 fsurface1 : Pcairo_surface_t;
 rgbcolor: rgbtriplety;
 cmatrix: cairo_matrix_t;
 fpattern: Pcairo_pattern_t;
begin
 gdi_lock;
 if gui_pixmaptoimage(acanvas.paintdevice,image,acanvas.gchandle) = gde_ok then begin 
  fsurface1:= cairoimage(image);
  gui_freeimagemem(image.pixels);
  fpattern:= cairo_pattern_create_for_surface(fsurface1);
 end else begin
  fpattern:= nil;
 end;
 gdi_unlock;
 cairo_save(fdraw); 
 if acanvas.monochrome then begin
  if acolorbackground <> cl_transparent then begin
   rgbcolor:= colortorgb(acolorbackground);
   cairo_set_source_rgb (fdraw,rgbcolor.red,rgbcolor.green,rgbcolor.blue);
   cairo_rectangle(fdraw,sourcerect.x,sourcerect.y,sourcerect.cx,sourcerect.cy);
   cairo_fill(fdraw);
  end;
  rgbcolor:= colortorgb(acolorforeground);
  cairo_set_source_rgb (fdraw,rgbcolor.red,rgbcolor.green,rgbcolor.blue);
 end;
 {with destrect do begin
  cairo_translate(fdraw, x{*fgcscale+foriginx}, (y+cy){*fgcscale});
  cairo_scale(fdraw, cx{*fgcscale}, cy{*fgcscale});
 end;
 cairo_matrix_init_scale(@cmatrix, destrect.cx, destrect.cy);
 cairo_pattern_set_matrix(fpattern, @cmatrix);}
 cairo_restore(fdraw);
 result:= fpattern;
end;

procedure tmsecairocanvas.cairo_changegc;
var
 int1,int2,ndash: integer;
 rect1,rect2: rectty;
 ar1: rectarty;
 dashesarty: realarty;
 rgbcolor: rgbtriplety;
 fslant: cairo_font_slant_t;
 fweight: cairo_font_weight_t;
 pt1: pointty;
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
   cairo_set_dash(fdraw, pointer(dashesarty), ndash, 0);
  end;
  if (self.brush <> nil) and 
            ([gvm_brush,gvm_brushorigin] * mask <> []) then begin
   rect1:= makerect(nullpoint,tsimplebitmap(self.brush).size);
   rect2:= makerect(self.brushorigin,tsimplebitmap(self.brush).size);   
   cpattern:= createpattern(rect1,rect2,acolorbackground,acolorforeground,tbitmap(self.brush).canvas);
  end;
  if df_brush in gc.drawingflags then begin
   cairo_set_source(fdraw, cpattern);   
   cairo_rectangle(fdraw,rect2.x,rect2.y,rect2.cx,rect2.cy);
   cairo_fill(fdraw);
  end
  else begin
   if gvm_colorforeground in mask then begin
    rgbcolor:= colortorgb(acolorforeground);
    cairo_set_source_rgb (fdraw,rgbcolor.red,rgbcolor.green,rgbcolor.blue);
   end;
  end;
  if gvm_font in mask then begin
   cairo_set_font_size (fdraw, self.font.height);  
   fweight:= CAIRO_FONT_WEIGHT_NORMAL;
   fslant:= CAIRO_FONT_SLANT_NORMAL;
   if fs_bold in self.font.style then begin
    fweight:= CAIRO_FONT_WEIGHT_BOLD;
   end;
   if fs_italic in self.font.style then begin
    fslant:= CAIRO_FONT_SLANT_ITALIC;
   end;
   cairo_select_font_face (fdraw, pchar(self.font.name),fslant,fweight);
  end;
  if gvm_linewidth in mask then begin
   cairo_set_line_width (fdraw, self.linewidth);
  end;
  if gvm_capstyle in mask then begin
   case lineinfo.capstyle of
    cs_round: cairo_set_line_cap(fdraw,CAIRO_LINE_CAP_ROUND);
    cs_projecting: cairo_set_line_cap(fdraw,CAIRO_LINE_CAP_SQUARE);
    else cairo_set_line_cap(fdraw,CAIRO_LINE_CAP_BUTT)
   end;
  end;
  if gvm_joinstyle in mask then begin
   case lineinfo.joinstyle of
    js_round: cairo_set_line_join(fdraw,CAIRO_LINE_JOIN_ROUND);
    js_bevel: cairo_set_line_join(fdraw,CAIRO_LINE_JOIN_BEVEL);
    else cairo_set_line_join(fdraw,CAIRO_LINE_JOIN_MITER);
   end;
  end;
  if gvm_clipregion in mask then begin
   cairo_save(fdraw);
   if clipregion <> 0 then begin
    ar1:= gui_regiontorects(clipregion);
    for int1:= 0 to high(ar1) do begin
     pt1:= addpoint(ar1[int1].pos,gc.cliporigin);
     cairo_rectangle(fdraw, pt1.x, pt1.y, ar1[int1].size.cx, ar1[int1].size.cy);
     cairo_fill(fdraw);
     cairo_clip(fdraw);
    end;
   end;
   cairo_restore (fdraw)
  end;
 end;
end;

procedure tmsecairocanvas.cairo_drawstring16;
var
 str1: msestring;
 rea1: real;
begin
 if active then begin
  with fdrawinfo.text16pos do begin
   cairopos(pos^);
   str1:= copy(text,1,count);
   rea1:= tfont1(self.font).rotation;
   if rea1<>0 then begin
    cairo_rotate(fdraw,-rea1);
   end;
   cairo_show_text (fdraw, pchar(stringtolatin1(str1)));
   if rea1<>0 then begin
    cairo_rotate(fdraw,(rea1));
   end;
  end;
 end;
end;

procedure tmsecairocanvas.cairo_drawarc;
begin
 with fdrawinfo.arc,rect^ do begin
  cairo_arc (fdraw, pos.x, pos.y, cx div 2, startang*radtodeg, extentang*radtodeg);
  cairo_stroke(fdraw);
 end;
end;

procedure tmsecairocanvas.cairo_fillarc;
begin
 with fdrawinfo.arc,rect^ do begin
  cairo_new_path(fdraw);
  cairo_arc (fdraw, pos.x, pos.y, cx div 2, startang*radtodeg, extentang*radtodeg);
  cairo_close_path(fdraw);
  cairo_stroke(fdraw);
  cairo_fill(fdraw);
 end;
end;

procedure tmsecairocanvas.handlepoly(const points: ppointty; 
             const lastpoint: integer; const closed: boolean; const fill: boolean);
var
 int1: integer;
 startpoint: pointty;
begin
 if active then begin
  startpoint.x:= points^.x;
  startpoint.y:= points^.y;
  cairo_move_to (fdraw, startpoint.x,startpoint.y);
  for int1:= 1 to lastpoint do begin
   cairo_line_to (fdraw, ppointaty(points)^[int1].x, ppointaty(points)^[int1].y);
  end;
  if closed then begin
   cairo_line_to (fdraw, startpoint.x, startpoint.y);
  end;
  if fill then begin
   cairo_fill(fdraw);
  end
  else begin
   cairo_stroke(fdraw);
  end;
 end;
end;

procedure tmsecairocanvas.handleellipse(const rect: rectty; const fill: boolean);
begin
 with rect do begin
  cairo_arc (fdraw, pos.x, pos.y, cx div 2, 0, 360);
  cairo_stroke(fdraw);
 end;
 if fill then begin
  cairo_fill(fdraw);
 end;
end;

procedure tmsecairocanvas.cairo_drawlines;
begin
 with fdrawinfo.points do begin
  handlepoly(points,count-1,closed,false);
 end;
end;

procedure tmsecairocanvas.cairo_drawlinesegments;
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

procedure tmsecairocanvas.cairo_fillpolygon;
begin
 with fdrawinfo.points do begin
  handlepoly(points,count-1,true,true);
 end;
end;

procedure tmsecairocanvas.cairo_fillrect;
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

procedure tmsecairocanvas.cairo_copyarea;
var
 mono: boolean;
 cimage: Pcairo_surface_t;
 
var 
 masked: boolean;
 maskcopy: boolean;
 maskbefore: tsimplebitmap;
 image: imagety;
label
 endlab; 
begin
 with fdrawinfo,copyarea do begin
  if not (df_canvasispixmap in tcanvas1(source).fdrawinfo.gc.drawingflags) then begin
   exit;
  end;
  mono:= source.monochrome;
  subpoint1(destrect^.pos,origin); 
  maskcopy:= mono and (mask <> nil) and mask.monochrome and
             ((acolorforeground = cl_transparent) or
              (acolorbackground = cl_transparent));
  maskbefore:= mask; //compiler warning
  if maskcopy then begin
   mask:= tsimplebitmap.create(true);
   mask.size:= sourcerect^.size;
   mask.canvas.copyarea(maskbefore.canvas,sourcerect^,nullpoint);
   if acolorbackground = cl_transparent then begin
    mask.canvas.copyarea(source,sourcerect^,nullpoint,rop_and);
   end;
   if acolorforeground = cl_transparent then begin
    mask.canvas.copyarea(source,sourcerect^,nullpoint,rop_notand);
   end;
  end;
  try
   masked:= (mask <> nil) and (mask.monochrome);
   if masked then begin
    gdi_lock;
    cpattern:= createpattern(sourcerect^,destrect^,acolorbackground,acolorforeground,source);
    gdi_unlock;
    exit;
   end
   else begin
    with tcanvas1(source).fdrawinfo do begin
     gdi_lock;
     if gui_pixmaptoimage(paintdevice,image,gc.handle) <> gde_ok then begin
      goto endlab;
     end;
     gdi_unlock;
    end;
    cimage:= cairoimage(image);
    gui_freeimagemem(image.pixels);    
    cairo_save(fdraw);
    cairo_set_source_surface(fdraw, cimage, destrect^.pos.x, destrect^.pos.y);
    cairo_paint(fdraw);
    cairo_surface_destroy(cimage);
    cairo_restore(fdraw);
   end;
   exit;
endlab:
   gdi_unlock;
  finally
   addpoint1(destrect^.pos,origin); //map to origin
   if maskcopy then begin
    mask.free;
    mask:= maskbefore;
   end;
  end;
 end; 
end;

procedure tmsecairocanvas.endpage;
begin
 inherited;
 if active then begin
  cairo_show_page(fdraw);
 end;
end;

procedure tmsecairocanvas.beginpage;
begin
 initgcvalues; //init state on every page, necessary for gv
 gsposcairo(makepoint(0,0));
 inherited;
end;

procedure tmsecairocanvas.nextpage;
begin
 endpage;
 beginpage;
end;

procedure tmsecairocanvas.gcdestroyed(const sender: tcanvas);
begin
 inherited;
end;

{ tmsecairocanvas }

constructor tmsecairo.create;
begin
 inherited;
 fcanvas:= tmsecairocanvas.create(self,icanvas(self));
 ffilename:='pdfoutput.pdf';
 forientation:= 0;
end;

destructor tmsecairo.destroy;
begin
 inherited;
 freeandnil(fcanvas);
end;

procedure tmsecairo.setwidth(const avalue: real);
begin
 if avalue<>fwidth then begin
  fwidth:= avalue;
 end;
 if forientation=0 then
  fsize.cx:= round(fwidth)
 else
  fsize.cy:= round(fwidth);
end;

procedure tmsecairo.setheight(const avalue: real);
begin
 if avalue<>fheight then begin
  fheight:= avalue;
 end;
 if forientation=0 then
  fsize.cy:= round(fheight)
 else
  fsize.cx:= round(fheight);
end;

procedure tmsecairo.setorientation(const avalue: integer);
begin
 if avalue<>forientation then begin
  forientation:= avalue;
 end;
 if forientation=0 then begin
  fsize.cx:= round(fwidth);
  fsize.cy:= round(fheight);
 end else begin
  fsize.cx:= round(fheight);
  fsize.cy:= round(fwidth);
 end;
end;

function tmsecairo.getcanvas: tmsecairocanvas;
begin
 result:= fcanvas;
end;

procedure tmsecairo.beginrender;
var
 str1: string;
begin
 with tmsecairocanvas(fcanvas) do begin
  str1:= tosysfilepath(ffilename);
  if forientation=0 then begin
   fsurface:= cairo_pdf_surface_create(pchar(str1),fwidth*fcanvas.ppmm,fheight*fcanvas.ppmm);
  end else begin
   fsurface:= cairo_pdf_surface_create(pchar(str1),fheight*fcanvas.ppmm,fwidth*fcanvas.ppmm);
  end;
  fdraw:= cairo_create(fsurface);
  tmsecairocanvas(fcanvas).beginpage;
 end;
end;

procedure tmsecairo.endrender;
begin
 cairo_destroy(fcanvas.fdraw);
 cairo_surface_destroy(fsurface);
end;

procedure tmsecairo.gcneeded(const sender: tcanvas);
var
 gc1: gcty;
begin
 if not (sender is tmsecairocanvas) then begin
  guierror(gue_invalidcanvas);
 end;
 with tmsecairocanvas(sender) do begin
  fillchar(gc1,sizeof(gc1),0);
  gc1.handle:= invalidgchandle;
  gc1.drawingflags:= [df_highresfont];
  gc1.paintdevicesize:= makesize(round(fwidth),round(fheight));
  linktopaintdevice(ptrint(self),gc1,{getwindowsize,}nullpoint);
 end;
end;

function tmsecairo.getmonochrome: boolean;
begin
 result:= false;
end;

function tmsecairo.getsize: sizety;
begin
 result:= fsize;
end;

initialization
 gdifuncs:= gui_getgdifuncs;
end.
