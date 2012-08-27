{ MSEgui Copyright (c) 1999-2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msecairogdi;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msegraphics,msetypes,msestrings,mseguiglob,cairo,msebitmap
 {$IFDEF windows},windows,cairowin32{$ENDIF};

const
 radtodeg = 360/(2*pi);

procedure init;
procedure deinit; 

function cairogetgdifuncs: pgdifunctionaty;
//function cairogetgdinum: integer;
procedure cairoinitdefaultfont;
function cairogetdefaultfontnames: defaultfontnamesty;


implementation
uses
 mseguiintf,msegraphutils,msesysintf1,sysutils;
 
type
 shapety = (fs_copyarea,fs_rect,fs_ellipse,fs_arc,fs_polygon);

 gcflagty = (gcf_backgroundbrushvalid,
             gcf_colorbrushvalid,gcf_patternbrushvalid,gcf_rasterop,
             gcf_selectforegroundbrush,gcf_selectbackgroundbrush,
             gcf_foregroundpenvalid,
             gcf_selectforegroundpen,gcf_selectnullpen,gcf_selectnullbrush,
             gcf_ispatternpen,gcf_isopaquedashpen,
                          gcf_last = 31);
            //-> longword
 gcflagsty = set of gcflagty; 

 tsimplebitmap1 = class(tsimplebitmap);
 tcanvas1 = class(tcanvas);
 tfont1 = class(tfont);
         
const
 highresfontshift = 6;  //64
 highresfontfakt = 1 shl highresfontshift;
 highresfontmask = highresfontfakt - 1; 

 defaultfontname = 'Tahoma';
// defaultfontname = 'MS Sans Serif';
 defaultfontnames: defaultfontnamesty =
  //stf_default           stf_empty stf_unicode stf_menu stf_message stf_report
   (defaultfontname,          '',       '',         '',      '',      'Arial',
  //stf_proportional stf_fixed,
   defaultfontname,         'Courier New',
  //stf_helvetica stf_roman          stf_courier
    'Arial',     'Times New Roman', 'Courier New');

function cairogetdefaultfontnames: defaultfontnamesty;
begin
 result:= defaultfontnames;
end;

procedure gdi_createpixmap(var drawinfo: drawinfoty); //gdifunc
begin
 with drawinfo.createpixmap do begin
  pixmap:= gui_createpixmap(size,0,monochrome,copyfrom);
 end;
end;

procedure gdi_pixmaptoimage(var drawinfo: drawinfoty); //gdifunc
begin
 with drawinfo.pixmapimage do begin
  gui_pixmaptoimage(pixmap,image,drawinfo.gc.handle);
 end;
end;

procedure gdi_imagetopixmap(var drawinfo: drawinfoty); //gdifunc
begin
 with drawinfo.pixmapimage do begin
  error:= gui_imagetopixmap(image,pixmap,drawinfo.gc.handle);
 end;
end;

//function cairocreategc(paintdevice: paintdevicety; const akind: gckindty; 
//              var gc: gcty; const aprintername: msestring): guierrorty;
procedure gdi_creategc(var drawinfo: drawinfoty);
begin
 with drawinfo.creategc do begin
  gcpo^.gdifuncs:= gui_getgdifuncs;
  error:= gde_creategc;
  gcpo^.handle:= createcompatibledc(0);
  if gcpo^.handle <> 0 then begin
   drawinfo.cairosurface:= cairo_win32_surface_create(gcpo^.handle);
  end;
 end;
end;

procedure transformpoints(var drawinfo: drawinfoty; const aclose: boolean);
var
 po1: ppointty;
 po2: ppointty;
 int1: integer;
begin
 with drawinfo.points do begin
  int1:= count;
  if aclose then begin
   inc(int1);
  end;
  allocbuffer(drawinfo.buffer,int1*sizeof(pointty));
  po1:= points;
  po2:= drawinfo.buffer.buffer;
  int1:= count;
  with drawinfo.origin do begin
   while int1 > 0 do begin
    po2^.x:= po1^.x + x;
    po2^.y:= po1^.y + y;
    inc(po1);
    inc(po2);
    dec(int1);
   end;
  end;
  if aclose then begin
   move(drawinfo.buffer.buffer^,(pchar(drawinfo.buffer.buffer)+
              count*sizeof(pointty))^,sizeof(pointty));
  end;
 end;
end;

procedure adjustlineend(po: ppointty); //solve lineto lastpixel problem
var
 po1: ppoint;
 dx,dy,dist: integer;

begin
 po1:= ppoint(pchar(po)-sizeof(pointty));
 dx:= po^.x - po1^.x;
 dy:= po^.y - po1^.y;
 dist:= (abs(dx) + abs(dy)) div 2;
 if dx < 0 then begin
  if dx + dist <= 0 then begin
   dec(po^.x);
  end;
 end
 else begin
  if dx >= dist then begin
   inc(po^.x);
  end;
 end;
 if dy < 0 then begin
  if dy + dist <= 0 then begin
   dec(po^.y);
  end;
 end
 else begin
  if dy >= dist then begin
   inc(po^.y);
  end;
 end;
end;

procedure transformrect(var drawinfo: drawinfoty);
begin
 allocbuffer(drawinfo.buffer,sizeof(trect));
 with drawinfo,prect(buffer.buffer)^,rect do begin
  Left:= rect^.x + origin.x;
  right:= Left + rect^.cx;
  top:= rect^.y + origin.y;
  bottom:= top + rect^.cy;
 end;
end;

procedure offsetrect(var drawinfo: drawinfoty);
begin
 allocbuffer(drawinfo.buffer,sizeof(rectty));
 with drawinfo,prectty(buffer.buffer)^,rect do begin
  x:= rect^.x + origin.x;
  cx:= rect^.cx;
  y:= rect^.y + origin.y;
  cy:= rect^.cy;
 end;
end;

procedure transformellipseinfo(var drawinfo: drawinfoty; const fill: boolean);
var
 int1: integer;
begin
 allocbuffer(drawinfo.buffer,sizeof(trect));
 int1:= 1;
 if fill then begin
  int1:= 2;
 end;
 with drawinfo,prect(buffer.buffer)^,rect do begin
  Left:= rect^.x + origin.x - drawinfo.rect.rect^.cx div 2;
  right:= Left + rect^.cx+int1;
  top:= rect^.y + origin.y - drawinfo.rect.rect^.cy div 2;
  bottom:= top + rect^.cy+int1;
 end;
end;

{procedure updateopaquemode(var drawinfo: drawinfoty);
var
 rgbcolor: rgbtriplety;
begin
 with drawinfo do begin
  rgbcolor:= colortorgb(foregroundcol);
  cairo_set_source_rgb (cairocontext,rgbcolor.red,rgbcolor.green,rgbcolor.blue);
  if df_opaque in drawingflags then begin
   //setbkmode(handle,opaque);
   setbkcolor(handle,backgroundcol);
  end
  else begin
   setbkmode(handle,transparent);
  end;
 end;
end;}


function createregion: regionty; overload;
begin
{$ifdef mse_debuggdi}
 inc(regioncount);
{$endif}
 result:= createrectrgnindirect(trect(nullrect));
end;

{function createregion(var rect: rectty; const gc: gcty): regionty; overload;
var
 rect1: rectty;
begin
{$ifdef mse_debuggdi}
 inc(regioncount);
{$endif}
 if win32gcty(gc.platformdata).d.kind = gck_printer then begin
  rect1:= rect;
  recttowinrect(rect1);
  lptodp(gc.handle,
     {$ifdef FPC}lppoint(@{$endif}rect1{$ifdef FPC}){$endif},2);
  result:= createrectrgnindirect(trect(rect1));   
 end
 else begin
  recttowinrect(rect);
  result:= createrectrgnindirect(trect(rect));
  winrecttorect(rect);
 end;
end;}

procedure gdi_createemptyregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  dest:= createregion;
 end;
end;

procedure gdi_setcliporigin(var drawinfo: drawinfoty);
begin
// gdierror(gde_notimplemented,'setcliporigin');
end;

procedure gdi_createrectregion(var drawinfo: drawinfoty);
begin
end;

procedure gdi_createrectsregion(var drawinfo: drawinfoty);
begin
end;

procedure gdi_destroyregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  if source <> 0 then begin
{$ifdef mse_debuggdi}
   dec(regioncount);
{$endif}
   deleteobject(source);
  end;
 end;
end;

procedure gdi_regionisempty(var drawinfo: drawinfoty);
var
 rect1: trect;
begin
 with drawinfo.regionoperation do begin
  if getrgnbox(source,rect1) = nullregion then begin
   dest:= 1;
  end
  else begin
   dest:= 0;
  end;
 end;
end;

procedure gdi_regionclipbox(var drawinfo: drawinfoty);
begin
end;

procedure gdi_copyregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  if source = 0 then begin
   dest:= 0;
  end
  else begin
   dest:= createregion;
   combinergn(dest,source,0,rgn_copy);
  end;
 end;
end;

procedure gdi_moveregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  offsetrgn(source,rect.x,rect.y);
 end;
end;

procedure gdi_regsubrect(var drawinfo: drawinfoty);
begin
end;

procedure gdi_regsubregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  combinergn(dest,dest,source,rgn_diff);
 end;
end;

procedure gdi_regaddrect(var drawinfo: drawinfoty);
begin
end;

procedure gdi_regaddregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  combinergn(dest,dest,source,rgn_or);
 end;
end;

procedure gdi_regintersectrect(var drawinfo: drawinfoty);
begin
end;

procedure gdi_regintersectregion(var drawinfo: drawinfoty);
begin
 with drawinfo.regionoperation do begin
  combinergn(dest,dest,source,rgn_and);
 end;
end;


 
procedure gdi_destroygc(var drawinfo: drawinfoty);
begin
 with drawinfo.gc do begin
   deletedc(handle);
 end;
end;

function cairoimage(aimage: imagety; aformat:cairo_format_t): Pcairo_surface_t;
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

procedure gdi_changegc(var drawinfo: drawinfoty);
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
 cpattern: Pcairo_pattern_t;
begin
 ar1:= nil; //compiler warning
 with drawinfo,gcvalues^ do begin
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
   cairo_set_dash(cairocontext, pointer(dashesarty), ndash, 0);
  end;
  if (tcanvas(getcanvasclass.canvasclass).brush <> nil) and 
            ([gvm_brush,gvm_brushorigin] * mask <> []) then begin
   msebitmap.tbitmap(tcanvas(getcanvasclass.canvasclass).brush).savetoimage(image);
   if image.length>0 then begin 
    fsurface1:= cairoimage(image,CAIRO_FORMAT_A1);
    image.pixels:= nil;
    cpattern:= nil;
    cpattern:= cairo_pattern_create_for_surface(fsurface1);
    cairo_pattern_destroy(cpattern); 
    cpattern:= nil;
    cairo_surface_destroy(fsurface1);
    fsurface1:= nil;
   end;
  end;
  if (df_brush in gc.drawingflags) and (cpattern<>nil) then begin
   rect2:= makerect(tcanvas(getcanvasclass.canvasclass).brushorigin,tsimplebitmap(tcanvas(getcanvasclass.canvasclass).brush).size);
   cairo_matrix_init_scale(@fmatrix, rect2.cx, rect2.cy);
   cairo_pattern_set_matrix(cpattern, @fmatrix);
   cairo_pattern_set_extend (cpattern, CAIRO_EXTEND_REPEAT);
   cairo_set_source(cairocontext,cpattern);
   cairo_fill(cairocontext);
   image.pixels:= nil;
  end else begin
   if gvm_colorforeground in mask then begin
    rgbcolor:= colortorgb(acolorforeground);
    cairo_set_source_rgb (cairocontext,rgbcolor.red,rgbcolor.green,rgbcolor.blue);
   end;
  end;
  if gvm_font in mask then begin
   cairo_set_font_size (cairocontext, tcanvas(getcanvasclass.canvasclass).font.height);  
   fweight:= CAIRO_FONT_WEIGHT_NORMAL;
   fslant:= CAIRO_FONT_SLANT_NORMAL;
   if fs_bold in tcanvas(getcanvasclass.canvasclass).font.style then begin
    fweight:= CAIRO_FONT_WEIGHT_BOLD;
   end;
   if fs_italic in tcanvas(getcanvasclass.canvasclass).font.style then begin
    fslant:= CAIRO_FONT_SLANT_ITALIC;
   end;
   cairo_select_font_face (cairocontext, pchar(tcanvas(getcanvasclass.canvasclass).font.name),fslant,fweight);
   //if (fx<>1) or (fy<>1) then begin
   {if fcairo.dpix>fcairo.dpiy then begin
    cairo_get_font_matrix(cairocontext,@fontmatrix);
    cairo_matrix_scale(@fontmatrix, fx, fy);
    cairo_set_font_matrix(cairocontext,@fontmatrix);
   end;}
  end;
  if gvm_linewidth in mask then begin
   if tcanvas(getcanvasclass.canvasclass).linewidth = 0 then begin
    lwidth:= 0.3;
   end else begin
    lwidth:= tcanvas(getcanvasclass.canvasclass).linewidthmm;
   end;
   cairo_set_line_width (cairocontext, lwidth);
  end;
  if gvm_capstyle in mask then begin
   case lineinfo.capstyle of
    cs_round: cairo_set_line_cap(cairocontext,CAIRO_LINE_CAP_ROUND);
    cs_projecting: cairo_set_line_cap(cairocontext,CAIRO_LINE_CAP_SQUARE);
    else cairo_set_line_cap(cairocontext,CAIRO_LINE_CAP_BUTT)
   end;
  end;
  if gvm_joinstyle in mask then begin
   case lineinfo.joinstyle of
    js_round: cairo_set_line_join(cairocontext,CAIRO_LINE_JOIN_ROUND);
    js_bevel: cairo_set_line_join(cairocontext,CAIRO_LINE_JOIN_BEVEL);
    else cairo_set_line_join(cairocontext,CAIRO_LINE_JOIN_MITER);
   end;
  end;
  if gvm_clipregion in mask then begin
   cairo_save(cairocontext);
   if clipregion <> 0 then begin
    ar1:= gui_regiontorects(clipregion);
    for int1:= 0 to high(ar1) do begin
     pt1:= addpoint(ar1[int1].pos,gc.cliporigin);
     cairo_rectangle(cairocontext, pt1.x, pt1.y, ar1[int1].size.cx, ar1[int1].size.cy);
     cairo_fill(cairocontext);
     cairo_clip(cairocontext);
    end;
   end;
   cairo_restore (cairocontext)
  end;
 end;
end;

procedure gdi_getcanvasclass(var drawinfo: drawinfoty); //gdifunc
begin
 //dummy
end;

procedure gdi_endpaint(var drawinfo: drawinfoty); //gdifunc
begin
 //dummy
end;

procedure gdi_flush(var drawinfo: drawinfoty); //gdifunc
begin
 //dummy
end;

procedure gdi_movewindowrect(var drawinfo: drawinfoty); //gdifunc
begin
 with drawinfo.moverect do begin
  gui_movewindowrect(drawinfo.paintdevice,dist^,rect^);  
 end;
end;

procedure handlepoly(var drawinfo: drawinfoty; const points: ppointty; 
             const lastpoint: integer; const closed: boolean; const fill: boolean);
var
 int1: integer;
 startpoint: pointty;
begin
 startpoint.x:= points^.x;
 startpoint.y:= points^.y;
 cairo_move_to (drawinfo.cairocontext, startpoint.x,startpoint.y);
 for int1:= 1 to lastpoint do begin
  cairo_line_to (drawinfo.cairocontext, ppointaty(points)^[int1].x, ppointaty(points)^[int1].y);
 end;
 if closed then begin
  cairo_line_to (drawinfo.cairocontext, startpoint.x, startpoint.y);
 end;
 if fill then begin
  cairo_fill(drawinfo.cairocontext);
 end
 else begin
  cairo_stroke(drawinfo.cairocontext);
 end;
end;

procedure gdi_drawlines(var drawinfo: drawinfoty);
begin
 with drawinfo.points do begin
  handlepoly(drawinfo,points,count-1,closed,false);
 end;
end;

procedure gdi_drawlinesegments(var drawinfo: drawinfoty);
var
 int1: integer;
begin
 with drawinfo.points do begin
  for int1:= 0 to count div 2 - 1 do begin
   handlepoly(drawinfo,points,1,false,false);
   inc(points,2);
  end;
 end;
end;

procedure handleellipse(var drawinfo: drawinfoty; const rect: rectty; const fill: boolean);
begin
 with rect do begin
  cairo_arc (drawinfo.cairocontext, pos.x, pos.y, cx div 2, 0, 360);
  cairo_stroke(drawinfo.cairocontext);
 end;
 if fill then begin
  cairo_fill(drawinfo.cairocontext);
 end;
end;

procedure gdi_drawellipse(var drawinfo: drawinfoty);
begin
 handleellipse(drawinfo,drawinfo.rect.rect^,false);
end;

procedure getarcinfo(const info: drawinfoty; 
                    out xstart,ystart,xend,yend: integer);
var
 stopang: real;
begin
 with info,arc,rect^ do begin
  stopang:= (startang+extentang);
  xstart:= (round(cos(startang)*cx) div 2) + x + origin.x;
  ystart:= (round(-sin(startang)*cy) div 2) + y + origin.y;
  xend:= (round(cos(stopang)*cx) div 2) + x + origin.x;
  yend:= (round(-sin(stopang)*cy) div 2) + y + origin.y;
 end;
end;

procedure gdi_drawarc(var drawinfo: drawinfoty);
begin
 with drawinfo,drawinfo.arc,rect^ do begin
  cairo_new_path(cairocontext);
  if cy = cx then begin
   cairo_arc(cairocontext,x+origin.x,y+origin.y,cx div 2, startang*radtodeg, extentang*radtodeg);
  end
  else begin
   cairo_translate(cairocontext,pos.x,pos.y);
   cairo_scale(cairocontext,0,0.5);
   cairo_arc (cairocontext,x+origin.x,y+origin.y, cx div 2, startang*radtodeg, extentang*radtodeg);
  end;
  cairo_stroke(cairocontext);
 end;
end;

procedure cairopos(var drawinfo: drawinfoty; const apos: pointty);
begin
 cairo_move_to(drawinfo.cairocontext, apos.x, apos.y);
end;

procedure gdi_drawstring16(var drawinfo: drawinfoty);
var
 rea1,rea2: real;
 int1: integer;
 te: cairo_text_extents_t;
 str1: pchar;
 char1: msestring;
 xx,yy: real;
 str2: msestring;
begin
 with drawinfo,drawinfo.text16pos do begin
  cairopos(drawinfo,pos^);
  rea1:= tfont1(tcanvas(getcanvasclass.canvasclass).font).rotation;
  if rea1<>0 then begin
   cairo_rotate(cairocontext,-rea1);
  end;
  {if fcairo.printtextasgraphic then begin
   str2:= msestrlcopy(text,count);
   str1:= pchar(stringtoutf8(str2));
   cairo_text_path (fcairo.context, str1);
   cairo_fill(fcairo.context);
  end else begin}
   {if (fcairo.outputformat=cai_GDIPrinter) and (fcairo.dpix<>fcairo.dpiy) then begin
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
   end else begin}
    str2:= msestrlcopy(text,count);
    str1:= pchar(stringtoutf8(str2));
    //str1:= pchar(UTF8Encode(str2));
	   cairo_show_text(cairocontext, str1); 
	//end;
  //end;
  if rea1<>0 then begin
   cairo_rotate(cairocontext,(rea1));
  end;
 end;
end;

procedure gdi_fillrect(var drawinfo: drawinfoty);
var
 points1: array[0..3] of pointty;
begin
 with drawinfo.rect.rect^ do begin
  points1[0].x:= x;
  points1[0].y:= y;
  points1[1].x:= x+cx;
  points1[1].y:= y;
  points1[2].x:= x+cx;
  points1[2].y:= y+cy;
  points1[3].x:= x;
  points1[3].y:= y+cy;
  handlepoly(drawinfo,@points1,high(points1),true,true);
 end;
end;

procedure gdi_fillelipse(var drawinfo: drawinfoty);
begin
 handleellipse(drawinfo,drawinfo.rect.rect^,true);
end;

procedure gdi_fillarc(var drawinfo: drawinfoty);
begin
 with drawinfo,drawinfo.arc,rect^ do begin
  cairo_save(cairocontext);
  cairo_new_sub_path(cairocontext);
  if pieslice then begin
   cairopos(drawinfo,pos);
  end;
  if cy = cx then begin
   cairo_arc(cairocontext,x+origin.x,y+origin.y,cx div 2,startang*radtodeg,extentang*radtodeg);
  end
  else begin
   cairo_translate(cairocontext,pos.x,pos.y);
   cairo_scale(cairocontext,0,0.5);
   cairo_arc (cairocontext,x+origin.x,y+origin.y, cx div 2, startang*radtodeg, extentang*radtodeg);
  end;
  //cairo_close_path(fcairo.context);
  //cairo_clip(fcairo.context);
  cairo_fill(cairocontext);
  cairo_restore(cairocontext);
 end;
end;

procedure gdi_fillpolygon(var drawinfo: drawinfoty);
begin
 with drawinfo.points do begin
  handlepoly(drawinfo,points,count-1,true,true);
 end;
end;

procedure gdi_copyarea(var drawinfo: drawinfoty);
var
 cimage: Pcairo_surface_t; 
 image: imagety;
 maskbefore: tsimplebitmap;
 aresize: boolean;
 ax,ay: double;
 fcairoop: cairo_operator_t;
begin
 with drawinfo,copyarea do begin
  if not (df_canvasispixmap in tcanvas1(source).fdrawinfo.gc.drawingflags) then begin
   exit;
  end;
  if mask<>nil then begin
   maskbefore:= mask;
   mask.canvas.copyarea(maskbefore.canvas,sourcerect^,nullpoint,rop_nor);
  end;
  with tcanvas1(source).fdrawinfo do begin
   gdi_lock;
   gui_pixmaptoimage(paintdevice,image,gc.handle);
   gdi_unlock;
  end;
  if alignment * [al_stretchx,al_stretchy,al_fit] <> [] then begin
   ax:= 1;
   ay:= 1;
   if al_fit in alignment then begin
    ax:= destrect^.size.cx/image.size.cx;
    ay:= destrect^.size.cy/image.size.cy;
    if ax>ay then 
     ay:= ax
    else
     ax:= ay;
   end else if al_stretchx in alignment then begin
    ax:= destrect^.size.cx/image.size.cx;
    if al_stretchy in alignment then begin
     ay:= destrect^.size.cy/image.size.cy;
    end;
   end else if al_stretchy in alignment then begin
    ay:= destrect^.size.cy/image.size.cy;
    if al_stretchx in alignment then begin
     ax:= destrect^.size.cx/image.size.cx;
    end;
   end;
   aresize:= true;
  end else begin
   aresize:= false;
   ay:= 1;
   ax:= 1;
  end;
  cairo_save(cairocontext);
  cimage:= cairoimage(image,CAIRO_FORMAT_RGB24);
  if aresize then begin
   cairo_scale(cairocontext,ax,ay);
   cairo_set_source_surface (cairocontext, cimage, (destrect^.pos.x - sourcerect^.pos.x)/ax, (destrect^.pos.y - sourcerect^.pos.y)/ay);
   cairo_rectangle (cairocontext, destrect^.pos.x/ax, destrect^.pos.y/ay, destrect^.size.cx/ax, destrect^.size.cy/ay);
   cairo_fill (cairocontext);
  end else begin
   cairo_set_source_surface (cairocontext, cimage, destrect^.pos.x - sourcerect^.pos.x, destrect^.pos.y - sourcerect^.pos.y);
   cairo_rectangle (cairocontext, destrect^.pos.x, destrect^.pos.y, destrect^.size.cx, destrect^.size.cy);
   cairo_fill (cairocontext);
  end;
  cairo_surface_destroy(cimage);
  cimage:= nil;
  if mask<>nil then begin
   gdi_lock;
   gui_pixmaptoimage(mask.handle,image,mask.canvas.gchandle);
   gdi_unlock;
   if image.length>0 then begin 
    cimage:= cairoimage(image,CAIRO_FORMAT_RGB24);
    fcairoop:= cairo_get_operator(cairocontext);
    cairo_set_operator (cairocontext, CAIRO_OPERATOR_ADD);
    if aresize then begin
     cairo_rectangle (cairocontext, destrect^.pos.x/ax, destrect^.pos.y/ay, destrect^.size.cx/ax, destrect^.size.cy/ay);
     cairo_clip(cairocontext);
     cairo_set_source_surface (cairocontext, cimage, (destrect^.pos.x - sourcerect^.pos.x)/ax, (destrect^.pos.y - sourcerect^.pos.y)/ay);
    end else begin
     cairo_rectangle (cairocontext, destrect^.pos.x, destrect^.pos.y, destrect^.size.cx, destrect^.size.cy);
     cairo_clip(cairocontext);
     cairo_set_source_surface (cairocontext, cimage, destrect^.pos.x - sourcerect^.pos.x, destrect^.pos.y - sourcerect^.pos.y);
    end;
    cairo_paint (cairocontext);
    //gui_freeimagemem(image.pixels);
    //image.pixels:= nil;
    cairo_surface_destroy(cimage);
    cimage:= nil;
    cairo_set_operator (cairocontext, fcairoop);
   end;
  end;
  if aresize then begin
   cairo_scale(cairocontext,1/ax,1/ay);
  end;
  cairo_restore(cairocontext);
 end; 
end;

procedure gdi_getimage(var drawinfo: drawinfoty); //gdifunc
begin
 //dummy
end;

procedure gdi_fonthasglyph(var drawinfo: drawinfoty);
begin
 with drawinfo,fonthasglyph do begin
  hasglyph:= true;
 end;
end;

var
 defaultfontinfo: logfont;
type
 charsetinfoty = record
  name: string;
  code: integer;
 end;
 charsetinfoaty = array[0..18] of charsetinfoty;

const
 charsets: charsetinfoaty = (
  (name: 'ANSI'; code: 0),
  (name: 'DEFAULT'; code: 1),
  (name: 'SYMBOL'; code: 2),
  (name: 'SHIFTJIS'; code: $80),
  (name: 'HANGEUL'; code: 129),
  (name: 'GB2312'; code: 134),
  (name: 'CHINESEBIG5'; code: 136),
  (name: 'OEM'; code: 255),
  (name: 'JOHAB'; code: 130),
  (name: 'HEBREW'; code: 177),
  (name: 'ARABIC'; code: 178),
  (name: 'GREEK'; code: 161),
  (name: 'TURKISH'; code: 162),
  (name: 'VIETNAMESE'; code: 163),
  (name: 'THAI'; code: 222),
  (name: 'EASTEUROPE'; code: 238),
  (name: 'RUSSIAN'; code: 204),
  (name: 'MAC'; code: 77),
  (name: 'BALTIC'; code: 186));
  
type
 pboolean = ^boolean;

{$ifdef FPC}
function fontenumcallback(var _para1:ENUMLOGFONTEX;
       var _para2:NEWTEXTMETRICEX; _para3:longint; _para4:LPARAM):longint; stdcall;
{$else}
function fontenumcallback(var _para1:ENUMLOGFONTEX;
       var _para2:TNEWTEXTMETRICEXa; _para3:longint; _para4:LPARAM):longint; stdcall;
{$endif}
begin
 pboolean(_para4)^:= true;
 result:= 0;
end;


procedure cairoinitdefaultfont;
var
 dc1: hdc;
 bo1: boolean;
begin
 fillchar(defaultfontinfo,sizeof(defaultfontinfo),0);
 defaultfontinfo.lfHeight:= -11;
 bo1:= false;
 defaultfontinfo.lfFaceName:= defaultfontname;
 dc1:= getdc(0);
 {$ifdef FPC}
 enumfontfamiliesex(dc1,@defaultfontinfo,@fontenumcallback,ptruint(@bo1),0);
 {$else}
 enumfontfamiliesex(dc1,defaultfontinfo,@fontenumcallback,ptruint(@bo1),0);
 {$endif}
 if not bo1 then begin
  defaultfontinfo.lfFaceName:= 'MS Sans Serif';
 end;
 releasedc(0,dc1);
end;

procedure gdi_getfonthighres(var drawinfo: drawinfoty);
begin
 
end;

procedure gdi_getfont(var drawinfo: drawinfoty);
begin
 
end;

procedure gdi_freefontdata(var drawinfo: drawinfoty);
begin
end;

procedure gdi_gettext16width(var drawinfo: drawinfoty);
begin
end;

procedure gdi_getchar16widths(var drawinfo: drawinfoty);
begin
end;

procedure gdi_getfontmetrics(var drawinfo: drawinfoty);
begin
end;

procedure init;
begin
end;

procedure deinit;
begin
end;

const
 gdifunctions: gdifunctionaty = (
   {$ifdef FPC}@{$endif}gdi_creategc,
   {$ifdef FPC}@{$endif}gdi_destroygc,
   {$ifdef FPC}@{$endif}gdi_changegc,
   {$ifdef FPC}@{$endif}gdi_createpixmap,
   {$ifdef FPC}@{$endif}gdi_pixmaptoimage,
   {$ifdef FPC}@{$endif}gdi_imagetopixmap,
   {$ifdef FPC}@{$endif}gdi_getcanvasclass,
   {$ifdef FPC}@{$endif}gdi_endpaint,
   {$ifdef FPC}@{$endif}gdi_flush,
   {$ifdef FPC}@{$endif}gdi_movewindowrect,
   {$ifdef FPC}@{$endif}gdi_drawlines,
   {$ifdef FPC}@{$endif}gdi_drawlinesegments,
   {$ifdef FPC}@{$endif}gdi_drawellipse,
   {$ifdef FPC}@{$endif}gdi_drawarc,
   {$ifdef FPC}@{$endif}gdi_fillrect,
   {$ifdef FPC}@{$endif}gdi_fillelipse,
   {$ifdef FPC}@{$endif}gdi_fillarc,
   {$ifdef FPC}@{$endif}gdi_fillpolygon,
//   {$ifdef FPC}@{$endif}gdi_drawstring,
   {$ifdef FPC}@{$endif}gdi_drawstring16,
   {$ifdef FPC}@{$endif}gdi_setcliporigin,
   {$ifdef FPC}@{$endif}gdi_createemptyregion,
   {$ifdef FPC}@{$endif}gdi_createrectregion,
   {$ifdef FPC}@{$endif}gdi_createrectsregion,
   {$ifdef FPC}@{$endif}gdi_destroyregion,
   {$ifdef FPC}@{$endif}gdi_copyregion,
   {$ifdef FPC}@{$endif}gdi_moveregion,
   {$ifdef FPC}@{$endif}gdi_regionisempty,
   {$ifdef FPC}@{$endif}gdi_regionclipbox,
   {$ifdef FPC}@{$endif}gdi_regsubrect,
   {$ifdef FPC}@{$endif}gdi_regsubregion,
   {$ifdef FPC}@{$endif}gdi_regaddrect,
   {$ifdef FPC}@{$endif}gdi_regaddregion,
   {$ifdef FPC}@{$endif}gdi_regintersectrect,
   {$ifdef FPC}@{$endif}gdi_regintersectregion,
   {$ifdef FPC}@{$endif}gdi_copyarea,
   {$ifdef FPC}@{$endif}gdi_getimage,
   {$ifdef FPC}@{$endif}gdi_fonthasglyph,
   {$ifdef FPC}@{$endif}gdi_getfont,
   {$ifdef FPC}@{$endif}gdi_getfonthighres,
   {$ifdef FPC}@{$endif}gdi_freefontdata,
   {$ifdef FPC}@{$endif}gdi_gettext16width,
   {$ifdef FPC}@{$endif}gdi_getchar16widths,
   {$ifdef FPC}@{$endif}gdi_getfontmetrics
);

//var
// gdinumber: integer;

function cairogetgdifuncs: pgdifunctionaty;
begin
 result:= @gdifunctions;
end;
{
function cairogetgdinum: integer;
begin
 result:= gdinumber;
end;

initialization
 gdinumber:= registergdi(cairogetgdifuncs);
}
end.
