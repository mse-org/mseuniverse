{ MSEgui Copyright (c) 1999-2011 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit msesdlgdi;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msegraphics,msetypes,msestrings,mseguiglob,sdl4msegui,msebitmap
 {$IFDEF windows},windows{$ENDIF},msesysutils;

const
 radtodeg = 360/(2*pi);

procedure init;
procedure deinit; 

function sdlgetgdifuncs: pgdifunctionaty;
//function sdlgetgdinum: integer;
procedure sdlinitdefaultfont;
function sdlgetdefaultfontnames: defaultfontnamesty;


implementation
uses
 mseguiintf,msegraphutils,msesysintf1,sysutils,msegenericgdi;
 
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
 defaultfontname = 'Tahoma';
// defaultfontname = 'MS Sans Serif';
 defaultfontnames: defaultfontnamesty =
  //stf_default           stf_empty stf_unicode stf_menu stf_message stf_report
   (defaultfontname,          '',       '',         '',      '',      'Arial',
  //stf_proportional stf_fixed,
   defaultfontname,         'Courier New',
  //stf_helvetica stf_roman          stf_courier
    'Arial',     'Times New Roman', 'Courier New');

function sdlgetdefaultfontnames: defaultfontnamesty;
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

procedure gdi_creategc(var drawinfo: drawinfoty);
var
 int1, int2, int3: integer;
 arenderer: ptruint;
 pinfo: PSDL_RendererInfo;
begin
 with drawinfo.creategc do begin
  gcpo^.gdifuncs:= gui_getgdifuncs;
  error:= gde_creategc;
  case kind of
   gck_pixmap: begin
    gcpo^.handle:= SDL_CreateSoftwareRenderer(paintdevice);
    error:= SDL_CheckErrorGDI('creategc');
   end;
   gck_screen: begin
    //choose the best renderer supported
    int3:= -1;
    arenderer:= SDL_CreateRenderer(paintdevice,int3,SDL_RENDERER_ACCELERATED);
    error:= gde_ok;
    if (arenderer=0) {or (SDL_GetError<>'')} then begin //wait for final release SDL 2
     SDL_DestroyRenderer(arenderer);
     int1:= SDL_GetNumRenderDrivers;
     for int2:= 1 to int1 do begin
      if SDL_GetRenderDriverInfo(int2,pinfo)=0 then begin
       debugwriteln(pinfo^.name+' w = '+inttostr(pinfo^.max_texture_width)+' h = '+inttostr(pinfo^.max_texture_width));
       arenderer:= SDL_CreateRenderer(paintdevice,int2,SDL_RENDERER_ACCELERATED);
       if (arenderer=0) {or (SDL_GetError<>'')} then begin
        error:= SDL_CheckErrorGDI('creategc');
        SDL_DestroyRenderer(arenderer);
       end else begin
        break;
       end;
      end;
     end;
    end;    
    gcpo^.handle:= arenderer;
   end;
  end;
 end;
end;

{procedure updateopaquemode(var drawinfo: drawinfoty);
var
 rgbcolor: rgbtriplety;
begin
 with drawinfo do begin
  rgbcolor:= colortorgb(foregroundcol);
  sdl_set_source_rgb (paintdevice,rgbcolor.red,rgbcolor.green,rgbcolor.blue);
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
 SDL_DestroyRenderer(drawinfo.gc.handle);
 SDL_CheckError('destroygc');
end;

procedure gdi_changegc(var drawinfo: drawinfoty);
var
 int1,int2,ndash: integer;
 rect1,rect2: rectty;
 ar1: rectarty;
 dashesarty: realarty;
 rgbcolor: rgbtriplety;
 //fslant: cairo_font_slant_t;
 //fweight: cairo_font_weight_t;
 pt1: pointty;
 //fmatrix,fontmatrix: cairo_matrix_t;
 //ffontextent: cairo_font_extents_t;
 height1,width1: integer;
 image: imagety;
 //fsurface1 : Pcairo_surface_t;
 lwidth: real;
 rect3: SDL_Rect;
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
   //cairo_set_dash(fcairo.context, pointer(dashesarty), ndash, 0);
  end;
  if (brush <> nil) and 
            ([gvm_brush,gvm_brushorigin] * mask <> []) then begin
   msebitmap.tbitmap(brush).savetoimage(image);
   if image.length>0 then begin 
    //fsurface1:= cairoimage(image,CAIRO_FORMAT_A1);
    image.pixels:= nil;
    //cpattern:= nil;
    //cpattern:= cairo_pattern_create_for_surface(fsurface1);
    //cairo_surface_destroy(fsurface1);
    //fsurface1:= nil;
   end;
  end;
  {if (df_brush in gc.drawingflags) and (cpattern<>nil) then begin
   rect2:= makerect(self.brushorigin,tsimplebitmap(self.brush).size);
   cairo_matrix_init_scale(@fmatrix, rect2.cx, rect2.cy);
   cairo_pattern_set_matrix(cpattern, @fmatrix);
   cairo_pattern_set_extend (cpattern, CAIRO_EXTEND_REPEAT);
   cairo_set_source(fcairo.context,cpattern);
   cairo_fill(fcairo.context);
   image.pixels:= nil;
  end else begin}
   if gvm_colorforeground in mask then begin
    rgbcolor:= colortorgb(acolorforeground);
    SDL_SetRenderDrawColor(gc.handle,rgbcolor.red,rgbcolor.green,rgbcolor.blue,0);
    SDL_CheckError('SetRenderDrawColor');
   end;
  //end;
  {if gvm_font in mask then begin
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
  end;}
  if gvm_clipregion in mask then begin
   //cairo_save(fcairo.context);
   if clipregion <> 0 then begin
    ar1:= gui_regiontorects(clipregion);
    for int1:= 0 to high(ar1) do begin
     pt1:= addpoint(ar1[int1].pos,gc.cliporigin);     
     rect3.x:= pt1.x;
     rect3.x:= pt1.y;
     rect3.w:= ar1[int1].size.cx;
     rect3.h:= ar1[int1].size.cy;
     SDL_SetClipRect(drawinfo.paintdevice,@rect3)
    end;
   end;
   //cairo_restore (fcairo.context)
  end;
 end;
end;

procedure gdi_getcanvasclass(var drawinfo: drawinfoty); //gdifunc
begin
 //dummy
end;

procedure gdi_endpaint(var drawinfo: drawinfoty); //gdifunc
begin
 //SDL_RenderPresent(drawinfo.gc.handle);
 //SDL_CheckError('endpaint');
end;

procedure gdi_flush(var drawinfo: drawinfoty); //gdifunc
begin
 SDL_RenderPresent(drawinfo.gc.handle);
 SDL_CheckError('flush');
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
 for int1:= 1 to lastpoint do begin
  SDL_RenderDrawLine(drawinfo.gc.handle,startpoint.x,startpoint.y,
    ppointaty(points)^[int1].x, ppointaty(points)^[int1].y);
  SDL_CheckError('SDL_RenderDrawLine');
  if (int1=lastpoint) and closed then begin
   SDL_RenderDrawLine(drawinfo.gc.handle,ppointaty(points)^[int1].x, ppointaty(points)^[int1].y,
     startpoint.x, startpoint.y);
  SDL_CheckError('SDL_RenderDrawLine');
  end;
 end;
 {if fill then begin
  cairo_fill(fcairo.context);
 end
 else begin
  cairo_stroke(fcairo.context);
 end;}
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
 SDL_CheckError('handleellipse');
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
 SDL_CheckError('drawarc');
end;

procedure gdi_drawstring16(var drawinfo: drawinfoty);
begin
 SDL_CheckError('drawstring16');
end;

procedure gdi_fillrect(var drawinfo: drawinfoty);
var
 rect1: SDL_Rect;
begin
 rect1.x:= drawinfo.rect.rect^.x;
 rect1.y:= drawinfo.rect.rect^.y;
 rect1.w:= drawinfo.rect.rect^.cx;
 rect1.h:= drawinfo.rect.rect^.cy;
 SDL_RenderFillRect(drawinfo.gc.handle,@rect1);
 SDL_CheckError('SDL_RenderFillRect');
end;

procedure gdi_fillelipse(var drawinfo: drawinfoty);
begin
 handleellipse(drawinfo,drawinfo.rect.rect^,true);
end;

procedure gdi_fillarc(var drawinfo: drawinfoty);
begin
 SDL_CheckError('fillarc');
end;

procedure gdi_fillpolygon(var drawinfo: drawinfoty);
begin
 with drawinfo.points do begin
  handlepoly(drawinfo,points,count-1,true,true);
 end;
end;

procedure gdi_copyarea(var drawinfo: drawinfoty);
var
 rect1,rect2,rect3: SDL_rect;
 maskbefore: tsimplebitmap;
 atexture: SDL_Texture;
 asurface: PSDL_Surface;
 w,h: integer;
begin
 with drawinfo,copyarea do begin
  if not (df_canvasispixmap in tcanvas1(source).fdrawinfo.gc.drawingflags) then begin
   exit;
  end;
  {if mask<>nil then begin
   maskbefore:= mask;
   mask.canvas.copyarea(maskbefore.canvas,sourcerect^,nullpoint,rop_nor);
  end;}
  rect1.x:= sourcerect^.x;
  rect1.y:= sourcerect^.y;
  rect1.w:= sourcerect^.cx;
  rect1.h:= sourcerect^.cy;
  rect2.x:= destrect^.x;
  rect2.y:= destrect^.y;
  rect2.w:= destrect^.cx;
  rect2.h:= destrect^.cy;
  w:= CSDL_Surface(tcanvas1(source).fdrawinfo.paintdevice)^.w;
  h:= CSDL_Surface(tcanvas1(source).fdrawinfo.paintdevice)^.h;
  rect3.x:= 0;
  rect3.y:= 0;
  rect3.w:= w;
  rect3.h:= h;
  SDL_unlockSurface(tcanvas1(source).fdrawinfo.paintdevice);
  asurface:= SDL_CreateRGBSurface(0,rect2.w,rect2.h,32,0,0,0,0);
  SDL_unlockSurface(asurface);
  SDL_UpperBlit(tcanvas1(source).fdrawinfo.paintdevice,@rect1, asurface, nil);
  SDL_SaveBMP_toFile(asurface,'c:\bb.bmp');
  atexture:= SDL_CreateTextureFromSurface(drawinfo.gc.handle,asurface);
  //SDL_CheckError('create texture');
  if SDL_RenderCopy(drawinfo.gc.handle, atexture, nil, @rect2)=0 then begin
   SDL_RenderPresent(drawinfo.gc.handle);
   SDL_CheckError('rendercopy');
  end;
  SDL_DestroyTexture(atexture);
  SDL_FreeSurface(asurface);

  {SDL_unlockSurface(tcanvas1(source).fdrawinfo.paintdevice);
  SDL_unlockSurface(drawinfo.paintdevice);
  SDL_UpperBlit(tcanvas1(source).fdrawinfo.paintdevice,@rect1, drawinfo.paintdevice, @rect2);
  SDL_SaveBMP_toFile(drawinfo.paintdevice,'c:\bb.bmp');
  SDL_RenderPresent(drawinfo.gc.handle);
  SDL_CheckError('rendercopy');}
 end;
 //SDL_CheckError('copyarea');
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


procedure sdlinitdefaultfont;
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
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_createemptyregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_createrectregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_createrectsregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_destroyregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_copyregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_moveregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regionisempty,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regionclipbox,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regsubrect,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regsubregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regaddrect,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regaddregion,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regintersectrect,
   {$ifdef FPC}@{$endif}msegenericgdi.gdi_regintersectregion,
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

function sdlgetgdifuncs: pgdifunctionaty;
begin
 result:= @gdifunctions;
end;
{
function sdlgetgdinum: integer;
begin
 result:= gdinumber;
end;

initialization
 gdinumber:= registergdi(sdlgetgdifuncs);
}
end.
