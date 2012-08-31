{ MSEgui Copyright (c) 1999-2012 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit mseguiintf;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 {windows,messages,}mseapplication,msetypes,msegraphutils,
 mseevent,msepointer,mseguiglob,msegraphics,
 msethread,mseformatstr,{msesysintf,}msestrings,msesystypes,msewinglob,
 sdl4msegui,msesdlgdi,dateutils;

type
 syseventty = SDL_Event;
   
const
// pixel0 = $000000;
// pixel1 = $ffffff;
 pixel0 = $ffffff;   //select colorbackground
 pixel1 = $000000;   //select colorforeground

{$ifdef FPC}
{$include ../mseguiintf.inc}
{$else}
{$include mseguiintf.inc}
{$endif}

//function getapplicationwindow: winidty;
procedure recttowinrect(const rect: rectty); overload;
procedure recttowinrect(po: prectty; count: integer); overload;
procedure winrecttorect(const rect: rectty); overload;
procedure winrecttorect(po: prectty; count: integer); overload;
//function mrect(aleft,atop,aright,abottom: integer): trect;

implementation
//todo: 19.10.03 rasterops for textout
uses
 sysutils,mselist,msekeyboard,msebits,msearrayutils,msesysutils,msegui,
 msesysintf1,msedynload;

type

 trayinfoty = record
 end; 
 win32windowdty = record
  trayinfo: trayinfoty;
  istaskbar: boolean;
 end;
 win32windowty = record
  case integer of
   0: (d: win32windowdty;);
   1: (_bufferspace: windowpty;);
 end;

 wndextrainfoty = record
  flags: longword;
  stylebackup: longword;
//  l,t,r,b: integer;
 end;
{$ifndef FPC}
 winbool = bool;
{$endif}

const
 MAPVK_VK_TO_VSC = 0;
 flagsoffs =       0*sizeof(integer); //for setwindowlong
 stylebackupoffs = 1*sizeof(integer);
// loffs =           2*sizeof(integer);
// toffs =           3*sizeof(integer);
// roffs =           4*sizeof(integer);
// boffs =           5*sizeof(integer);
 
 widgetclassname = 'msetoplevelwidget';
 childwidgetclassname = 'msechildwidget';
 wndextrabytes = sizeof(wndextrainfoty);
  
 mouseidletime = 100; //milliseconds
 {
  cursorshapety = (cr_default,cr_none,cr_arrow,cr_cross,cr_wait,cr_ibeam,
             cr_sizever,cr_sizehor,cr_sizebdiag,cr_sizefdiag,cr_sizeall,
             cr_splitv,cr_splith,cr_pointinghand,cr_forbidden,
             cr_topleftcorner,cr_bottomleftcorner,
             cr_bottomrightcorner,cr_toprightcorner,
             cr_res0,cr_res1,cr_res2,cr_res3,cr_res4,cr_res5,cr_res6,cr_res7,
             cr_user);
  }
 {$ifdef FPC}
  IDC_ARROW = pchar(32512);
  IDC_IBEAM = pchar(32513);
  IDC_WAIT = pchar(32514);
  IDC_CROSS = pchar(32515);
  IDC_UPARROW = pchar(32516);
  IDC_SIZE = pchar(32640);
  IDC_ICON = pchar(32641);
  IDC_SIZENWSE = pchar(32642);
  IDC_SIZENESW = pchar(32643);
  IDC_SIZEWE = pchar(32644);
  IDC_SIZENS = pchar(32645);
  IDC_SIZEALL = pchar(32646);
  IDC_NO = pchar(32648);
  IDC_HAND = pchar(32649);
  IDC_APPSTARTING = pchar(32650);
  IDC_HELP = pchar(32651);

  VK_LWIN = 91;
  VK_RWIN = 92;
 {$endif}

  VK_OEM_PLUS = $BB;    // '+' any country
  VK_OEM_COMMA = $BC;   // ',' any country
  VK_OEM_MINUS = $BD;   // '-' any country
  VK_OEM_PERIOD = $BE;  // '.' any coun {$endif}

 standardcursors: array[cursorshapety] of pchar{makeintresource} =
                     (idc_arrow,idc_arrow,idc_arrow,idc_arrow,
                     idc_cross,idc_wait,idc_ibeam,
                     idc_sizens,idc_sizewe,idc_sizenesw,idc_sizenwse,idc_sizeall,
                     idc_arrow,idc_arrow,idc_hand,idc_no,
                     idc_arrow, //cr_drag
                     idc_sizenwse,idc_sizenesw,
                     idc_sizenwse,idc_sizenesw,
                     idc_arrow,idc_arrow,idc_arrow,idc_arrow,
                     idc_arrow,idc_arrow,idc_arrow,idc_arrow,
                     idc_arrow);
{                                       //        |not dest and source
 rasteropty = (  rop_clear,   rop_and,    rop_andnot, rop_copy,
          //          |not source and dest
                 rop_notand,  rop_nop,    rop_xor,    rop_or,
                 rop_nor,     rop_notxor, rop_not,    rop_ornot,
                 rop_notcopy, rop_notor,  rop_nand,   rop_set);

  source   1 1 0 0
  dest     1 0 1 0
  result   x x x x     code = result + 1
  copy     1 1 0 0 + 1 = 13
  and      1 0 0 0 + 1 = 9
  }


 //col0: tagrgbquad = (rgbblue: $ff; rgbgreen: $ff; rgbred: $ff; rgbreserved: $00);
 //col1: tagrgbquad = (rgbblue: 0; rgbgreen: 0; rgbred: 0; rgbreserved: $00);
// col0: tagrgbquad = (rgbblue: 0; rgbgreen: 0; rgbred: 0);
// col1: tagrgbquad = (rgbblue: $ff; rgbgreen: $ff; rgbred: $ff);

 MONITOR_DEFAULTTONULL = 0;
 MONITOR_DEFAULTTOPRIMARY = 1;
 MONITOR_DEFAULTTONEAREST = 2;
 SM_XVIRTUALSCREEN = 76;
 SM_YVIRTUALSCREEN = 77;
 SM_CXVIRTUALSCREEN = 78;
 SM_CYVIRTUALSCREEN = 79;
 
type
 hmonitor = thandle;
 {tMONITORINFO = record
  cbSize: DWORD ;
  rcMonitor: tRECT  ;
  rcWork: tRECT;
  dwFlags: DWORD;
 end;
 pmonitorinfo = ^tmonitorinfo;}
 
{$ifdef FPC}
type
  TKeyboardState = array[0..255] of Byte;
{$else}
function GetCharacterPlacementW(DC: HDC; p2: PWideChar; p3, p4: Integer;
  var p5: TGCPResultsw; p6: DWORD): DWORD; stdcall;
    external gdi32 name 'GetCharacterPlacementW';

{$endif}

var
 canshutdown: integer;
 //widgetclass: atom;
 //childwidgetclass: atom;
 applicationwindow: winidty;
 desktopwindow: winidty;
 eventlist: tobjectqueue;
 timer: integer;
 mouseidletimer: longword;
 mainthread: longword;
 mousewindow: winidty;
 lastfocuswindow: winidty;
 groupleaderwindow: winidty;
 mousecursor: ptruint;
 keystate: tkeyboardstate;
 charbuffer: msestring;
 shiftstate: shiftstatesty;

 cursors: array[cursorshapety] of longword;

type
 tapplication1 = class(tguiapplication);
 tsimplebitmap1 = class(tsimplebitmap);
 tcanvas1 = class(tcanvas);

 {monochromebitmapinfoty = packed record
  bmiheader: tbitmapinfoheader;
  bmicolors: array[0..1] of trgbquad;
 end;}

 {bitmapinfoty = packed record
  bmiheader: bitmapinfoheader;
  col0: longword;
  col1: longword;
 end;}
 
{$ifdef FPC}
{function GetNextWindow(winidty: winidty; uCmd: UINT): winidty; stdcall;
             external user32 name 'GetWindow';
function winScrollWindowEx(winidty: winidty; dx, dy: Integer;
             prcScroll, prcClip: PRect;
             hrgnUpdate: HRGN; prcUpdate: PRect; flags: UINT): BOOL; stdcall;
             external user32 name 'ScrollWindowEx';

function PeekMessage(var lpMsg: TMsg; winidty: winidty;
  wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall;
             external user32 name 'PeekMessageA';
function TranslateMessage(const lpMsg: TMsg): BOOL; stdcall;
             external user32 name 'TranslateMessage';
function DispatchMessage(const lpMsg: TMsg): Longint; stdcall;
             external user32 name 'DispatchMessageA';}
{$endif}

{function GetMonitorInfo(hmomitor: hmonitor; lpmu: pmonitorinfo): BOOL; stdcall;
             external user32 name 'GetMonitorInfoA';
function MonitorFromWindow(winidty: winidty; dwFlags: DWORD): HMONITOR; stdcall;
             external user32 name 'MonitorFromWindow';}

//type
{$ifndef FPC}
 //POINT = tpoint;
 //RECT = trect;
 {$endif}
 {HIMC = DWORD;
 tagCOMPOSITIONFORM = record
  dwStyle: DWORD;
  ptCurrentPos: POINT;
  rcArea: RECT;
 end;
 COMPOSITIONFORM = tagCOMPOSITIONFORM;
 PCOMPOSITIONFORM = ^COMPOSITIONFORM;
 NPCOMPOSITIONFORM = ^COMPOSITIONFORM;
 LPCOMPOSITIONFORM = ^COMPOSITIONFORM;}

const
// bit field for IMC_SETCOMPOSITIONWINDOW, IMC_SETCANDIDATEWINDOW
      CFS_DEFAULT                     = $0000;
      CFS_RECT                        = $0001;
      CFS_POINT                       = $0002;
      CFS_FORCE_POSITION              = $0020;
      CFS_CANDIDATEPOS                = $0040;
      CFS_EXCLUDE                     = $0080;
      
var
 hasimm32: boolean;
 {ImmGetContext: function(_winidty: winidty): HIMC; stdcall;
 ImmReleaseContext: function(_winidty: winidty; _himc: HIMC): BOOL; stdcall;
 ImmSetCompositionWindow: function(_himc: HIMC; 
                          lpCompForm: LPCOMPOSITIONFORM): BOOL; stdcall;}
             
{function getapplicationwindow: winidty;
begin
 result:= applicationwindow;
end;}

{$ifndef FPC}
type
      _NOTIFYICONDATAA = record
          cbSize: DWORD;
          Wnd: winidty;
          uID: UINT;
          uFlags: UINT;
          uCallbackMessage: UINT;
          hIcon: HICON;
          szTip: array [0..63] of Char;
     end;
     _NOTIFYICONDATA = _NOTIFYICONDATAA;

     _NOTIFYICONDATAW = record
         cbSize: DWORD;
         Wnd: winidty;
         uID: UINT;
         uFlags: UINT;
         uCallbackMessage: UINT;
         hIcon: HICON;
         szTip: array [0..63] of Word;
     end;
     TNotifyIconDataA = _NOTIFYICONDATAA;
     TNotifyIconDataW = _NOTIFYICONDATAW;
     TNotifyIconData = TNotifyIconDataA;
     NOTIFYICONDATAA = _NOTIFYICONDATAA;
     NOTIFYICONDATAW = _NOTIFYICONDATAW;
     NOTIFYICONDATA = NOTIFYICONDATAA;
     PNotifyIconDataA = ^TNotifyIconDataA;
     PNotifyIconDataW = ^TNotifyIconDataW;
     PNotifyIconData = PNotifyIconDataA;
     
function Shell_NotifyIconA(dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL;
                 external 'shell32.dll' name 'Shell_NotifyIconA';
function Shell_NotifyIconW(dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL;
                 external 'shell32.dll' name 'Shell_NotifyIconW';
{$endif}
{
var
 Shell_NotifyIconA: function (dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL;
 Shell_NotifyIconW: function (dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL;
 
 shellinterfaceerror: guierrorty = gue_noshelllib;
 shellinterfacechecked: boolean;
 
function checkshellinterface: guierrorty;
var
 bo1: boolean;
begin
 if (shellinterfaceerror <> gue_ok) and not shellinterfacechecked then begin
  shellinterfacechecked:= true;
  if iswin95 then begin
   bo1:= checkprocaddresses(['shell32.dll'],
    ['Shell_NotifyIconA'
    ],
    [@Shell_NotifyIconA
    ]);
  end
  else begin
   bo1:= checkprocaddresses(['shell32.dll'],
    ['Shell_NotifyIconW'
    ],
    [@Shell_NotifyIconW
    ]);
  end;
  if bo1 then begin
   shellinterfaceerror:= gue_ok;
  end;
 end;
 result:= shellinterfaceerror;
end;
}

{procedure useproc; //no "not used" message
begin
 if (childwidgetclass = 0) and (desktopwindow = 0) then begin
 end;
end;}

function checkshellinterface: guierrorty;
begin
 result:= gue_ok;
end;

{function mrect(aleft,atop,aright,abottom: integer): trect;
begin
 with result do begin
  left:= aleft;
  top:= atop;
  right:= aright;
  bottom:= abottom;
 end;
end;}

function gui_sethighrestimer(const avalue: boolean): guierrorty;
begin
 result:= gue_ok;
end;

function gui_grouphideminimizedwindows: boolean;
begin
 result:= true;
end;

function gui_setimefocus(var awindow: windowty): guierrorty;
begin
 result:= gue_ok;
end;

function gui_unsetimefocus(var awindow: windowty): guierrorty;
begin
 result:= gue_ok;
end;

function gui_regiontorects(const aregion: regionty): rectarty;
var
 int1: integer;
 //po1: prgndata;
 //po2: prect;
begin
 result:= nil;
 {if aregion <> 0 then begin
  int1:= getregiondata(aregion,0,nil);
  getmem(po1,int1);
  if getregiondata(aregion,int1,po1) <> 0 then begin
   setlength(result,po1^.rdh.ncount);
   po2:= @po1^.buffer;
   for int1:= 0 to high(result) do begin
    with result[int1],po2^ do begin
     x:= left;
     y:= top;
     cx:= right - left;
     cy:= bottom - top;
    end;
    inc(po2);
   end;
  end;
  freemem(po1);
 end;}
end;

function gui_getdefaultfontnames: defaultfontnamesty;
begin
 result:= sdlgetdefaultfontnames;
end;

function gui_canstackunder: boolean;
begin
 result:= true;
end;

procedure gui_cancelshutdown;
begin
 if canshutdown <> 0 then begin
  tapplication1(application).exitloop;
 end;
 canshutdown:= 0;
end;

function gui_copytoclipboard(const value: msestring): guierrorty;
         //todo: copy msechars to clipboard, win95?
begin
 result:= gue_clipboard;
 SDL_SetClipboardText(pchar(value));
 result:= gue_ok;
end;

function gui_canpastefromclipboard: boolean;
begin
 result:= SDL_HasClipboardText;
end;

function gui_pastefromclipboard(out value: msestring): guierrorty;
var               //todo: get msechars from clipboard, win95?
 data: thandle;
 po1: pointer;
 str1: string;
begin
 value:= SDL_GetClipboardText;
 result:= gue_ok;
end;

function gui_getwindowsize(id: winidty): windowsizety;
var
 flag: SDL_WindowFlags;
begin
 flag:= SDL_GetWindowFlags(id);
 if SDL_WINDOW_FULLSCREEN in flag then
  result:= wsi_fullscreen
 else if SDL_WINDOW_MAXIMIZED in flag then
  result:= wsi_maximized
 else if SDL_WINDOW_MINIMIZED in flag then
  result:= wsi_minimized
 else
  result:= wsi_normal;
end;

function gui_getwindowdesktop(const id: winidty): integer;
begin
 result:= 0; //todo
end;

function iswindowvisible(id: winidty): boolean;
var
 aflag: SDL_WindowFlags;
begin
 aflag:= SDL_GetWindowFlags(id);
 result:= not (SDL_WINDOW_HIDDEN in aflag);
end;

function gui_windowvisible(id: winidty): boolean;
begin
 result:= iswindowvisible(id);
end;

function gui_setwindowstate(id: winidty; size: windowsizety;
                            visible: boolean): guierrorty;
begin
 result:= gue_ok;
 SDL_ShowWindow(id);
end;

function gui_getpointerpos: pointty;
var
 x,y: integer;
begin
 SDL_GetMouseState(x,y);
 result.x:= x;
 result.y:= y;
end;

function gui_setpointerpos(const pos: pointty): guierrorty;
begin
 SDL_WarpMouseInWindow(mousewindow,pos.x,pos.y);
 result:= gue_ok;
end;

function gui_movepointer(const dist: pointty): guierrorty;
var
 x,y: integer;
begin
 result:= gue_mousepos;
 SDL_GetMouseState(x,y);
 SDL_WarpMouseInWindow(mousewindow,x+dist.x,y+dist.y);
 result:= gue_ok;
end;

function gui_grabpointer(id: winidty): guierrorty;
begin
 {setcapture(id);
 if getcapture = id then begin}
  result:= gue_ok;
 {end
 else begin
  result:= gue_capturemouse;
 end;}
end;

function gui_ungrabpointer: guierrorty;
begin
 //releasecapture;
 result:= gue_ok;
end;

function gui_createpixmap(const size: sizety; winid: winidty = 0;
                          monochrome: boolean = false;
                          copyfrom: pixmapty = 0): pixmapty;
             //copyfrom does not work if selected in dc!
begin
 //create SDL surface
 result:= SDL_CreateRGBSurface(0,size.cx,size.cy,32,0,0,0,0);
 debugwriteln('createpixmap');
end;

function gui_createbitmapfromdata(const size: sizety; datapo: pbyte;
             msbitfirst: boolean = false; dwordaligned: boolean = false;
             bottomup: boolean = false): pixmapty;
var
 po1,po2: pbyte;
 bytesperline: integer;
 int1,int2,int3: integer;
begin
 result:= SDL_CreateRGBSurfaceFrom(datapo,size.cx,size.cy,32,0,0,0,0,0);
 debugwriteln('createpixmapfromdata');
end;

function gui_freepixmap(pixmap: pixmapty): gdierrorty;
begin
 debugwriteln('freepixmap');
 SDL_FreeSurface(pixmap);
 result:= gde_ok;
end;

function gui_getpixmapinfo(var info: pixmapinfoty): gdierrorty;
begin
 result:= gde_ok;
end;

procedure transformimageformat(const image: imagety; inverse: boolean = true);
var
 po1: pbyte;
 int1: integer;
begin
 {$ifdef FPC}{$checkpointer off}{$endif}
 if image.monochrome then begin
  po1:= pointer(image.pixels);
  if inverse then begin
   for int1:= 0 to image.length*4-1 do begin
    po1^:= not bitreverse[po1^];
    inc(po1);
   end;
  end
  else begin
   for int1:= 0 to image.length*4-1 do begin
    po1^:= bitreverse[po1^];
    inc(po1);
   end;
  end;
 end;
 {$ifdef FPC}{$checkpointer default}{$endif}
 {
 else begin
  for int1:= 0 to high(image.pixels) do begin
   swaprgb1(image.pixels[int1]);
  end;
 end;
 }
end;

var 
 imagememalloc: integer;
 
function gui_allocimagemem(length: integer): plongwordaty;
begin
 if length = 0 then begin
  result:= nil;
 end
 else begin
  getmem(result,length * sizeof(longword));
 end;
end;

procedure gui_freeimagemem(data: plongwordaty);
begin
 freemem(data);
end;

function gui_pixmaptoimage(pixmap: pixmapty; out image: imagety; gchandle: longword): gdierrorty;
{var
 info: pixmapinfoty;
 bitmapinfo: monochromebitmapinfoty;
 dc: hdc;
 int1: integer;
 bmp1: hbitmap;}

begin
 result:= gde_ok;
{ if gchandle <> 0 then begin
  bmp1:= createcompatiblebitmap(gchandle,0,0);
  selectobject(gchandle,bmp1);
 end
 else begin
  bmp1:= 0; //compiler warning
 end;
 info.handle:= pixmap;
 result:= gui_getpixmapinfo(info);
 if result = gde_ok then begin
  image.size:= info.size;
  result:= gde_image;
  image.pixels:= nil;
  if info.depth = 1 then begin
   image.length:= ((info.size.cx + 31) div 32) * info.size.cy;
   initbitmapinfo(true,false,info.size,bitmapinfo);
   image.monochrome:= true;
  end
  else begin
   image.monochrome:= false;
   initbitmapinfo(false,false,info.size,bitmapinfo);
   image.length:= info.size.cx * info.size.cy;
  end;
  image.pixels:= gui_allocimagemem(image.length);
         //getdibits does not work with normal heap
  dc:= getdc(0);
  int1:= getdibits(dc,pixmap,0,info.size.cy,image.pixels,
                 pbitmapinfo(@bitmapinfo)^,dib_rgb_colors);
  releasedc(0,dc);
  if int1 <> 0 then begin
   transformimageformat(image);
   result:= gde_ok;
  end;
 end;
 if gchandle <> 0 then begin
  selectobject(gchandle,pixmap);
  deleteobject(bmp1);
 end;}
end;

function gui_imagetopixmap(const image: imagety; out pixmap: pixmapty;
                           gchandle: longword): gdierrorty;
begin
 result:= gde_pixmap;
 pixmap:= SDL_CreateRGBSurfaceFrom(image.pixels,image.size.cx,image.size.cy,32,0,0,0,0,0);
 if pixmap <> 0 then begin
  result:= gde_ok;
 end;
end;

function gui_setwindowfocus(id: winidty): guierrorty;
begin
 SDL_ShowWindow(id);
 result:= gue_ok;
end;

function gui_setappfocus(id: winidty): guierrorty;
begin
 SDL_ShowWindow(id);
end;

function gui_minimizeapplication: guierrorty;
begin
 result:= gue_ok;
 SDL_MinimizeWindow(applicationwindow);
end;

const
 curwidth = 32;
 curheight = 32;
 curlength = ((curwidth+15) div 16)*2*curheight;
 curdragxor: array[0..curlength-1] of byte =
 (
      $00,$00,$00,$00,
      $40,$00,$00,$00,
      $60,$00,$00,$00,
      $70,$00,$00,$00,
      $78,$00,$00,$00,
      $7c,$00,$00,$00,
      $7e,$00,$00,$00,
      $7f,$00,$00,$00,
      $7f,$80,$00,$00,
      $7f,$80,$00,$00,
      $7f,$00,$00,$00,
      $7e,$00,$00,$00,
      $6e,$00,$00,$00,
      $46,$00,$00,$00,
      $06,$Fc,$00,$00,
      $03,$7c,$00,$00,
      $03,$7c,$00,$00,
      $05,$bc,$00,$00,
      $05,$bc,$00,$00,
      $06,$7c,$00,$00,
      $07,$Fc,$00,$00,
      $07,$Fc,$00,$00,
      $07,$Fc,$00,$00,
      $07,$Fc,$00,$00,
      $07,$Fc,$00,$00,
      $00,$00,$00,$00,
      $00,$00,$00,$00,
      $00,$00,$00,$00,
      $00,$00,$00,$00,
      $00,$00,$00,$00,
      $00,$00,$00,$00,
      $00,$00,$00,$00);
 curdragand: array[0..curlength-1] of byte =
  (
      $3f,$ff,$ff,$ff,
      $1f,$ff,$ff,$ff,
      $0f,$ff,$ff,$ff,
      $07,$ff,$ff,$ff,
      $03,$ff,$ff,$ff,
      $01,$ff,$ff,$ff,
      $00,$ff,$ff,$ff,
      $00,$7f,$ff,$ff,
      $00,$3f,$ff,$ff,
      $00,$1f,$ff,$ff,
      $00,$0f,$ff,$ff,
      $00,$ff,$ff,$ff,
      $00,$ff,$ff,$ff,
      $10,$01,$ff,$ff,
      $30,$01,$ff,$ff,
      $70,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $f0,$01,$ff,$ff,
      $ff,$ff,$ff,$ff,
      $ff,$ff,$ff,$ff,
      $ff,$ff,$ff,$ff,
      $ff,$ff,$ff,$ff,
      $ff,$ff,$ff,$ff,
      $ff,$ff,$ff,$ff
   );

function gui_setcursorshape(winid: winidty; shape: cursorshapety): guierrorty;
var
 cursor: SDL_Cursor;
begin
 {case shape of
  cr_none: begin
   cursor:= 0;
  end;
  cr_drag: begin
   if cursors[cr_drag] = 0 then begin
    cursors[cr_drag]:= createcursor(hinstance,0,0,curwidth,curheight,
                          @curdragand,@curdragxor);
   end;
   cursor:= cursors[cr_drag];
  end;
  else begin
   cursor:= windows.LoadCursor(0,standardcursors[shape]);
  end;
 end;}
 cursor:= SDL_CreateCursor(curdragxor,curdragand,32,32,0,0);
 
 SDL_SetCursor(cursor);
 mousecursor:= cursor;
 result:= gue_ok;
end;

procedure killtimer;
begin
 if timer <> 0 then begin
  SDL_RemoveTimer(timer);
  timer:= 0;
 end;
end;

function TimerProc(interval: UInt32; param: Pointer ): UInt32;
begin
 killtimer;
 eventlist.add(tmseevent.create(ek_timer));
end;

function gui_settimer(us: longword): guierrorty;
               //send et_timer event after delay or us (micro seconds)
begin
 killtimer;
 timer:= SDL_AddTimer(us div 1000, @timerproc, nil);
 if timer = 0 then begin
  result:= gue_timer;
 end
 else begin
  result:= gue_ok;
 end;
end;

procedure gui_beep;
begin
 //windows.MessageBeep($ffffffff);
end;

procedure winrecttorect(const rect: rectty); overload;
begin
 dec(pinteger(@rect.cx)^,rect.x);
 dec(pinteger(@rect.cy)^,rect.y);
end;

procedure winrecttorect(po: prectty; count: integer); overload;
begin
 while count > 0 do begin
  dec(po^.cx,po^.x);
  dec(po^.cy,po^.y);
  inc(po);
  dec(count);
 end;
end;

procedure recttowinrect(const rect: rectty); overload;
begin
 inc(pinteger(@rect.cx)^,rect.x);
 inc(pinteger(@rect.cy)^,rect.y);
end;

procedure recttowinrect(po: prectty; count: integer); overload;
begin
 while count > 0 do begin
  inc(po^.cx,po^.x);
  inc(po^.cy,po^.y);
  inc(po);
  dec(count);
 end;
end;
{
function gui_creategc(paintdevice: paintdevicety; const akind: gckindty; 
              var gc: gcty; const aprintername: msestring = ''): guierrorty;
begin
 result:= gdi32creategc(paintdevice,akind,gc,aprintername);
end;
}
function gui_flushgdi(const synchronize: boolean = false): guierrorty;
begin
 gui_hasevent; //dispachevents
 //gdiflush;
 result:= gue_ok;
end;

procedure windowdestroyed(id: winidty);
begin
 if mousewindow = id then begin
  mousewindow:= 0;
 end;
 if lastfocuswindow = id then begin
  lastfocuswindow:= 0;
 end;
 if groupleaderwindow = id then begin
  groupleaderwindow:= 0;
 end;
end;

type
 setwindowownerinfoty = record
  oldowner,newowner: winidty;
 end;
 psetwindowownerinfoty = ^setwindowownerinfoty;

{function setwindowowner(id: winidty; param: lparam): winbool; stdcall;

begin
 with psetwindowownerinfoty(ptruint(param))^ do begin
  if getwindowlong(id,gwl_winidtyparent) = oldowner then begin
   setwindowlong(id,gwl_winidtyparent,newowner);
  end;  
 end;
 result:= true;
end;}

function gui_destroywindow(var awindow: windowty): guierrorty;
begin
 SDL_DestroyWindow(awindow.id);
 result:= gue_ok;
 windowdestroyed(awindow.id);
end;

function gui_showwindow(id: winidty): guierrorty;
begin
 SDL_ShowWindow(id);
 result:= gue_ok;
end;

function gui_hidewindow(id: winidty): guierrorty;
begin
 SDL_HideWindow(id);
 result:= gue_ok;
end;

function gui_raisewindow(id: winidty): guierrorty;
begin
 SDL_RaiseWindow(id);
 result:= gue_ok;
end;

function gui_lowerwindow(id: winidty): guierrorty;
begin
 {windows.SetWindowPos(id,winidty_bottom,0,0,0,0,swp_noactivate or swp_nomove or
                          swp_noownerzorder or swp_nosize);}
 result:= gue_ok;
end;

function gui_stackunderwindow(id: winidty; predecessor: winidty): guierrorty;
begin
 predecessor:= id; //just try
 result:= gue_ok;
end;

function gui_stackoverwindow(id: winidty; predecessor: winidty): guierrorty;
begin
 predecessor:= id; //just try
 result:= gue_ok;
end;

function gui_getzorder(const ids: winidarty; out zorders: integerarty): guierrorty;
    //topevel -> highest, numbers must not be contiguous
var
 int1,foundcount: integer;
 id1: winidty;
begin
 setlength(zorders,length(ids));
 //need to fixed
 for int1:= 0 to high(ids) do begin
  zorders[int1]:= int1;
 end; 
 result:= gue_ok;
 {foundcount:= 0;
 id1:= gettopwindow(0);
 while (foundcount <= high(ids)) and (id1 <> 0) do begin
  for int1:= 0 to high(ids) do begin
   if ids[int1] = id1 then begin
    zorders[int1]:= -foundcount;
    inc(foundcount);
    break;
   end;
  end;
  id1:= getnextwindow(id1,gw_winidtynext);
 end;
 if foundcount - 1 = high(ids) then begin
  result:= gue_ok
 end
 else begin
  result:= gue_windownotfound;
 end;}
end;

function gui_setwindowcaption(id: winidty; const caption: msestring): guierrorty;
begin
 result:= gue_error;
 SDL_SetWindowTitle(id,pchar(stringtolatin1(caption)));
 if (id = groupleaderwindow) and (result = gue_ok) then begin
  SDL_SetWindowTitle(applicationwindow,PChar(caption));
  result:= gue_ok;
 end;
end;

function composeicon(const icon,mask: pixmapty): PSDL_Surface;
begin
 //need convert icon,mask to PSDL_Surface 
 //result:= nil;
end;

function gui_setwindowicon(id: winidty; const icon,mask: pixmapty): guierrorty;
var
 ico: PSDL_Surface;
begin
 result:= gue_error;
 if icon <> 0 then begin
  ico:= composeicon(icon,mask);
  if ico = 0 then begin
   exit;
  end;
 end;
 SDL_SetWindowIcon(id,ico);
 result:= gue_ok;
end;

function gui_setapplicationicon(const icon,mask: pixmapty): guierrorty;
begin
 result:= gui_setwindowicon(applicationwindow,icon,mask);
end;

type
 pidinfoty = record
  pids: procidarty;
  winid: winidty;
 end;
 ppidinfoty = ^pidinfoty;

{function checkproc(awinid: winidty; po: ptrint): bool; stdcall;
var
 pid: integer;
 int1: integer;
begin
 result:= true;
 if getwindowlong(awinid,gwl_style) and windows.ws_visible <> 0 then begin 
  getwindowthreadprocessid(awinid,@pid);
  with ppidinfoty(po)^ do begin
   for int1:= 0 to high(pids) do begin
    if pids[int1] = pid then begin
     result:= false;
     winid:= awinid;
     break;
    end;
   end;
  end;
 end;
end;}

function gui_pidtowinid(const pids: procidarty): winidty;
var
 info: pidinfoty;
begin
 info.pids:= pids;
 info.winid:= 0;
 //enumwindows(@checkproc,ptrint(@info));
 result:= info.winid;
end;

function gui_rgbtopixel(rgb: longword): pixelty;
begin
 result:= swaprgb(rgb);
end;

function gui_pixeltorgb(pixel: pixelty): longword;
begin
 result:= swaprgb(pixel);
end;

{function winmousekeyflagstoshiftstate(keys: longword): shiftstatesty;
begin
 result:= [];
 if keys and mk_control <> 0 then begin
  include(result,ss_ctrl);
 end;
 if keys and mk_lbutton <> 0 then begin
  include(result,ss_left);
 end;
 if keys and mk_mbutton <> 0 then begin
  include(result,ss_middle);
 end;
 if keys and mk_rbutton <> 0 then begin
  include(result,ss_right);
 end;
 if keys and mk_shift <> 0 then begin
  include(result,ss_shift);
 end;
 if getkeystate(vk_menu) < 0 then begin
  include(result,ss_alt);
 end;
end;}

function shiftstatetowinmousekeyflags(shiftstate: shiftstatesty): longword;
begin
 result:= 0;
 {if ss_ctrl in shiftstate then begin
  result:= result or mk_control;
 end;
 if ss_left in shiftstate then begin
  result:= result or mk_lbutton;
 end;
 if ss_middle in shiftstate then begin
  result:= result or mk_mbutton;
 end;
 if ss_right in shiftstate then begin
  result:= result or mk_rbutton;
 end;
 if ss_shift in shiftstate then begin
  result:= result or mk_shift;
 end;}
end;

function winmousepostopoint(pos: longword): pointty;
begin
 {result.x:= smallint(loword(pos));
 result.y:= smallint(hiword(pos));}
end;

function pointtowinmousepos(pos: pointty): longword;
begin
 //result:= word(pos.x) + (word(pos.y) shl 16);
end;

{function winkeytokey(key: longword; lparam: longword;
                                       var shift: shiftstatesty): keyty;
var
 second: boolean;
begin
 second:= true; //mapvirtualkey(key,mapvk_vk_to_vsc) <> (lparam shr 16) and $ff;

 case key of
  vk_back: result:= key_backspace;
  vk_tab: begin
   if ss_shift in shift then begin
    result:= key_backtab;
   end
   else begin
    result:= key_tab;
   end;
  end;
  vk_clear: result:= key_clear;
  vk_return: result:= key_return;
  vk_shift: begin
   result:= key_shift;
   if second then begin
    include(shiftstate,ss_second);
   end;
  end;
  vk_control: begin
   result:= key_control;
   if second then begin
    include(shiftstate,ss_second);
   end;
  end;
  vk_menu: begin
   result:= key_alt;
   if second then begin
    include(shiftstate,ss_second);
   end;
  end;
  vk_pause: result:= key_pause;
  vk_capital: result:= key_capslock;
  vk_escape: result:= key_escape;
  vk_space: result:= key_space;
  vk_prior: result:= key_pageup;
  vk_next: result:= key_pagedown;
  vk_end: result:= key_end;
  vk_home: result:= key_home;
  vk_left: result:= key_left;
  vk_up: result:= key_up;
  vk_right: result:= key_right;
  vk_down: result:= key_down;
 //  vk_select: result:= key_select;
  vk_execute: result:= key_sysreq;
  vk_snapshot: result:= key_print;
  vk_insert: result:= key_insert;
  vk_delete: result:= key_delete;
  vk_help: result:= key_help;
  longword('0')..longword('9'): result:= keyty(key);
  longword('A')..longword('Z'): result:= keyty(key);
  vk_lwin: result:= key_super;
  vk_rwin: begin
   result:= key_super;
   include(shiftstate,ss_second);
  end;
  vk_apps: result:= key_menu;
  vk_oem_plus: result:= key_plus;
  vk_oem_comma: result:= key_comma;
  vk_oem_minus: result:= key_minus;
  vk_oem_period: result:= key_period;
  vk_numpad0..vk_numpad9: begin
   result:= keyty(longword(key_0) + key - vk_numpad0);
   include(shiftstate,ss_second);
  end;
  vk_add: begin
   result:= key_plus;
   include(shiftstate,ss_second);
  end;
  vk_separator: begin
   result:= key_comma;
   include(shiftstate,ss_second);
  end;
  vk_subtract: begin
   result:= key_minus;
   include(shiftstate,ss_second);
  end;
  vk_decimal: begin
   result:= key_decimal;
   include(shiftstate,ss_second);
  end;
  vk_multiply: begin
   result:= key_asterisk;
   include(shiftstate,ss_second);
  end;
  vk_divide: begin
   result:= key_slash;
   include(shiftstate,ss_second);
  end;
  vk_f1..vk_f24: result:= keyty(longword(key_f1) + key - vk_f1);
  vk_numlock: result:= key_numlock;
  vk_scroll: result:= key_scrolllock;

  else begin
   result:= key_unknown;
  end;
 end;
end;}

{function winkeystatetoshiftstate(keystate: longword): shiftstatesty;
begin
 result:= [];
 if $20000000 and keystate <> 0 then begin
  include(result,ss_alt);
 end;
 if getkeystate(vk_shift) < 0 then begin
  include(result,ss_shift);
 end;
 if getkeystate(vk_control) < 0 then begin
  include(result,ss_ctrl);
 end;
 if getkeystate(vk_lbutton) < 0 then begin
  include(result,ss_left);
 end;
 if getkeystate(vk_mbutton) < 0 then begin
  include(result,ss_middle);
 end;
 if getkeystate(vk_rbutton) < 0 then begin
  include(result,ss_right);
 end;
end;

function wheelkeystatetoshiftstate(keystate: longword): shiftstatesty;
var
 wo1: word;
begin
 result:= [];
 wo1:= loword(keystate);
 if mk_control and wo1 <> 0 then begin
  include(result,ss_ctrl);
 end;
 if mk_lbutton and wo1 <> 0 then begin
  include(result,ss_left);
 end;
 if mk_mbutton and wo1 <> 0 then begin
  include(result,ss_middle);
 end;
 if mk_rbutton and wo1 <> 0 then begin
  include(result,ss_right);
 end;
 if mk_shift and wo1 <> 0 then begin
  include(result,ss_shift);
 end;
 if getkeystate(vk_menu) < 0 then begin
  include(result,ss_alt);
 end;
end;}

function windowvisible(handle: winidty): boolean;
//var
// rect1: trect;
begin
 //windows.getclientrect(handle,rect1);
 result:= iswindowvisible(handle); { and
  not ((rect1.Left = 0) and (rect1.Top = 0)
                              and (rect1.Bottom = 0) and (rect1.Right = 0)) and
      (gui_getwindowsize(handle) <> wsi_minimized);}
end;

//procedure checkmousewindow(window: winidty; const pos: pointty); forward;

{procedure mouseidleproc(awinidty: winidty; uMsg: longword; idEvent: longword;
          dwTime: longword); stdcall;
var
 po1: tpoint;
 win1: winidty;
begin
 windows.KillTimer(0,mouseidletimer);
 mouseidletimer:= 0;
 if mousewindow <> 0 then begin
  if windows.GetCursorPos(po1) then begin
   win1:= windowfrompoint(po1);
   if (win1 <> mousewindow) and (getparent(win1) <> mousewindow) then begin
    eventlist.add(twindowevent.create(ek_leavewindow,mousewindow));
   end
   else begin
    if windows.screentoclient(mousewindow,po1) then begin
     checkmousewindow(mousewindow,pointty(po1));
    end;
   end;
  end;
 end;
end;}

{procedure killmouseidletimer(restart: boolean = false);
begin
 if mouseidletimer <> 0 then begin
  windows.KillTimer(0,mouseidletimer);
 end;
 if restart then begin
  mouseidletimer:= windows.settimer(0,0,mouseidletime,@mouseidleproc);
 end
 else begin
  mouseidletimer:= 0;
 end;
end;}

{procedure checkmousewindow(window: winidty; const pos: pointty);
var
 rect1: trect;
begin
 killmouseidletimer(true);
 if (window <> 0) then begin
  windows.getclientrect(window,rect1);
  if (pos.x < 0) or (pos.x >= rect1.Right) or (pos.y < 0) or
            (pos.y > rect1.Bottom) then begin
   window:= 0;
  end
 end;
 if mousewindow <> window then begin
  if mousewindow <> 0 then begin
   eventlist.add(twindowevent.create(ek_leavewindow,mousewindow));
  end;
  if window <> 0 then begin
   eventlist.add(twindowevent.create(ek_enterwindow,window));
  end;
  mousewindow:= window;
 end
 else begin
  if mousecursor <> 0 then begin
   windows.SetCursor(mousecursor); //possible missed et_exitwindow
  end;
 end;
end;}

function gui_movewindowrect(id: winidty; const dist: pointty;
                                             const rect: rectty): guierrorty;
//var
// rect1,rect2: rectty;
begin
 //SDL_SetWindowPosition(id,rect.x+dist.x,rect.y+dist.y);
 SDL_UpdateWindowSurface(id);
 result:= gue_ok;
end;

function getclientrect(winid: winidty; windowrect: prectty = nil): rectty;
                     //screen origin
var
 x,y,w,h:integer;
begin
 SDL_GetWindowSize(winid,w,h);
 SDL_GetWindowPosition(winid,x,y);
 result.x:= x;
 result.y:= y;
 result.cx:= w;
 result.cy:= h;
end;

{procedure getwindowrectpa(id: winidty; out rect: rectty; out origin: pointty);
             //parent origin
var
// rect1: rectty;
 win1: winidty;
begin
 rect:= getclientrect(id);
 win1:= getancestor(id,ga_parent);
 if win1 <> 0 then begin
  origin:= getclientrect(win1).pos;
  subpoint1(rect.pos,origin);
 end
 else begin
  origin:= nullpoint;
 end;
end;}

function gui_getwindowrect(id: winidty; out rect: rectty): guierrorty;
            //screen origin
begin
 rect:= getclientrect(id);
 result:= gue_ok;
end;

function gui_getwindowpos(id: winidty; out pos: pointty): guierrorty;
var
 x,y : integer;
begin
 SDL_GetWindowPosition(id,x,y);
 pos.x:= x;
 pos.y:= y;
 result:= gue_ok;
end;

var
 configuredwindow: winidty;
 
procedure postconfigureevent(const id: winidty);
var
 rect1: rectty;
 pt1: pointty;
begin
 configuredwindow:= id;
 if gui_getwindowsize(id) <> wsi_minimized then begin
  gui_getwindowrect(id,rect1);
  eventlist.add(twindowrectevent.create(ek_configure,id,
                          rect1,pt1));
 end
 else begin
  eventlist.add(twindowevent.create(ek_hide,id));
 end;
end;

function gui_reposwindow(id: winidty; const rect: rectty): guierrorty;
var
 //rect1,rect2: trect;
 arect: rectty;
 frame: framety;
begin
 result:= gue_resizewindow;
 {if windows.getwindowrect(id,rect1) then begin
  if windows.GetclientRect(id,rect2) then begin
   getframe(rect1,rect2,frame);
   arect:= inflaterect(rect,frame);}
   //configuredwindow:= 0;
   //if windows.SetWindowPos(id,0,arect.x,arect.y,arect.cx,arect.cy,
   //             swp_nozorder or swp_noactivate) then begin
    SDL_SetWindowPosition(id,rect.x,rect.y);
    SDL_SetWindowSize(id,rect.cx,rect.cy);
    result:= gue_ok;
   //end;
  //end;
  if configuredwindow <> id then begin
   postconfigureevent(id);
  end;
 //end;
end;

function gui_getdecoratedwindowrect(id: winidty; out arect: rectty): guierrorty;
begin
 gui_getwindowrect(id,arect);
 result:= gue_ok;
end;

function gui_setdecoratedwindowrect(id: winidty; const rect: rectty; 
                                    out clientrect: rectty): guierrorty;
//var
// rect1: rectty;
begin
 result:= gue_resizewindow;
 gui_getwindowrect(id,clientrect);
 SDL_SetWindowPosition(id,rect.x,rect.y);
 result:= gue_ok;
end;

function gui_setembeddedwindowrect(id: winidty; const rect: rectty): guierrorty;
begin
 result:= gue_resizewindow;
 SDL_SetWindowPosition(id,rect.x,rect.y);
 result:= gue_ok;
end;

var
 mousewheelpos: integer;
 sizingwindow: winidty;
 eventlooping: integer;
 escapepressed: boolean;
 
{procedure gui_wakeup;
begin
 windows.postmessage(applicationwindow,wakeupmessage,0,0);
// windows.postthreadmessage(mainthread,wakeupmessage,0,0);
end;}

function gui_postevent(event: tmseevent): guierrorty;
//var
// int1: integer;
begin
 result:= gue_postevent;
 //SDL_PumpEvents;
 result:= gue_ok;
 {if windows.postmessage(applicationwindow,msemessage,longword(event),0) then begin
  result:= gue_ok;
 end
 else begin
  result:= gue_postevent;
 end;}
{
 if eventlooping > 0 then begin
  result:= gue_ok;
  eventlist.add(event); //threadmessages are lost while window sizing
 end
 else begin
  result:= gue_postevent;
  for int1:= 0 to 15 do begin
   if windows.postthreadmessage(mainthread,msemessage,longword(event),0) then begin
    result:= gue_ok;
    break;
   end;
   sys_threadschedyield;
  end;
 end;
 }
end;

function gui_escapepressed: boolean;
begin
 result:= escapepressed;
end;

procedure gui_resetescapepressed;
begin
 escapepressed:= false;
end;

{function WindowProc(awinidty: winidty; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

 function checkbutton(const amessage: UINT): mousebuttonty;
 begin
  result:= mb_none;
  case amessage of
   wm_lbuttondown,wm_lbuttonup: result:= mb_left;
   wm_mbuttondown,wm_mbuttonup: result:= mb_middle;
   wm_rbuttondown,wm_rbuttonup: result:= mb_right;
  end;
 end;
 
 procedure inittraycallback(const reposition: boolean; out cursorpos: pointty;
                            out shiftstate: uint);
 var
  rect1: rectty;
  pt1: pointty;
 begin
  shiftstate:= 0;
  if getkeystate(vk_control) < 0 then begin
   shiftstate:= shiftstate or mk_control;
  end;
  if getkeystate(vk_shift) < 0 then begin
   shiftstate:= shiftstate or mk_shift;
  end;
  if getkeystate(vk_lbutton) < 0 then begin
   shiftstate:= shiftstate or mk_lbutton;
  end;
  if getkeystate(vk_mbutton) < 0 then begin
   shiftstate:= shiftstate or mk_mbutton;
  end;
  if getkeystate(vk_rbutton) < 0 then begin
   shiftstate:= shiftstate or mk_rbutton;
  end;
  
  windows.getcursorpos(tpoint(pt1));
  gui_getwindowrect(awinidty,rect1);
  cursorpos.x:= rect1.cx div 2;
  cursorpos.y:= rect1.cy div 2;
  if reposition then begin
   gui_reposwindow(awinidty,makerect(pt1.x-cursorpos.x,pt1.y-cursorpos.y,
                                                           rect1.cx,rect1.cy));
//   setforegroundwindow(applicationwindow);
  end;
 end;

const
 wheelstep = 120;
var
 rect1,rect2,rect3: rectty;
 pt1{,pt2}: pointty;
 size1: sizety;
 button: mousebuttonty;
 key1: keyty;
 str1: string;
// int1: integer;
 bo1: boolean;
 sysevent: syseventty;
 shiftstate1: uint;
 imc: himc;
 imminfo: compositionform;
 
begin
 if application.ismainthread then begin
  sysevent.winidty:= awinidty;
  sysevent.umsg:= msg;
  sysevent.wparam:= wparam;
  sysevent.lparam:= lparam;
  sysevent.lresult:= 0;
  bo1:= false;
  tapplication1(application).sysevent(awinidty,sysevent,bo1);
  if bo1 then begin
   result:= sysevent.lresult;
   exit;
  end;
 end;
 result:= 1;
 case msg of
  msemessage: begin
   eventlist.add(tmseevent(wparam));
   exit;
  end;
  wakeupmessage: begin
   eventlist.add(nil);
   exit;
  end;
  timermessage: begin
   eventlist.add(tmseevent.create(ek_timer));
   exit;
  end;
  traycallbackmessage: begin
   case lparam and $ffff of
    wm_lbuttondown,wm_mbuttondown,wm_rbuttondown: begin
     inittraycallback(true,pt1,shiftstate1);
     windowproc(awinidty,lparam and $ffff,shiftstate1,pointtowinmousepos(pt1));
    end;
    wm_lbuttonup,wm_mbuttonup,wm_rbuttonup: begin
     inittraycallback(true,pt1,shiftstate1);
     windowproc(awinidty,lparam and $ffff,shiftstate1,pointtowinmousepos(pt1));
    end;
   end;
  end;     
  wm_ime_char: begin
   if iswin95 then begin
    str1:= char(wparam);
    if wparam and $ff00 <> 0 then begin
     str1:= char(wparam shr 8) + str1;
    end;
    charbuffer:= charbuffer + str1;    
   end
   else begin
    charbuffer:= charbuffer + ucs4tostring(wparam);
   end;
   eventlist.add(tkeyevent.create(awinidty,false,key_none,key_none,shiftstate,
                                    charbuffer,timestamp));
   charbuffer:= '';
  end;
  wm_close: begin
   if awinidty = applicationwindow then begin
    eventlist.add(tmseevent.create(ek_terminate));
   end
   else begin
    eventlist.add(twindowevent.create(ek_close,awinidty));
    result:= 0;
   end;
   exit;
  end;
  wm_queryendsession: begin
   canshutdown:= 1;
   eventlist.add(tmseevent.create(ek_terminate));
   tapplication1(application).eventloop;
   result:= canshutdown;
   exit;
  end;
  wm_destroy: begin
  {$ifdef mse_debugwindowfocus}
   debugwindow('wm_destroy ',awinidty);
  {$endif}
  {$ifdef mse_debugwindowdestroy}
   debugwindow('*wm_destroy ',awinidty);
  {$endif}
   windowdestroyed(awinidty);
   eventlist.add(twindowevent.create(ek_destroy,awinidty));
  end;
  wm_setfocus: begin
   if (awinidty = applicationwindow) and (lastfocuswindow <> 0) then begin
   {$ifdef mse_debugwindowfocus}
    debugwindow('wm_setfocus applicationwindow ',awinidty);
   {$endif}
    if windowvisible(lastfocuswindow) then begin
     setfocus(lastfocuswindow);
    end
    else begin
     if application.activewindow <> nil then begin
      setfocus(application.activewindow.winid);
     end
     else begin
      if application.mainwindow <> nil then begin
       setfocus(application.mainwindow.winid);
      end;
     end;
    end;
   end
   else begin
    if windowvisible(awinidty) then begin
    {$ifdef mse_debugwindowfocus}
     debugwindow('wm_setfocus ',awinidty);
    {$endif}
     lastfocuswindow:= awinidty;
     eventlist.add(twindowevent.create(ek_focusin,awinidty));
    end{$ifndef mse_debugwindowfocus};{$endif}
  {$ifdef mse_debugwindowfocus}
    else begin
     debugwindow('wm_setfocus invisible ',awinidty);
    end;
  {$endif}
   end;
  end;
  wm_killfocus: begin
  {$ifdef mse_debugwindowfocus}
   debugwindow('wm_killfocus ',awinidty);
  {$endif}
   eventlist.add(twindowevent.create(ek_focusout,awinidty));
  end;
  wm_paint: begin
   if getupdaterect(awinidty,trect(rect1),false) then begin
    winrecttorect(rect1);
    eventlist.add(twindowrectevent.create(ek_expose,awinidty,rect1,nullpoint));
//    exit;
   end;
  end;
  wm_entersizemove: begin
   sizingwindow:= awinidty;
  end;
  wm_exitsizemove: begin
   sizingwindow:= 0;
  end;
  wm_sizing: begin
   rect1:= rectty(prect(lparam)^);
   winrecttorect(rect1);
   rect2:= getclientrect(awinidty,@rect1);
   rect3:= rect2;
   application.checkwindowrect(awinidty,rect2);
   size1:= subsize(rect3.size,rect2.size);
   if (wparam = wmsz_topleft) or (wparam = wmsz_left) or
                           (wparam = wmsz_bottomleft) then begin
    inc(rect1.x,size1.cx);
   end;
   dec(rect1.cx,size1.cx);
   if (wparam = wmsz_topleft) or (wparam = wmsz_top) or
                           (wparam = wmsz_topright) then begin
    inc(rect1.y,size1.cy);
   end;
   dec(rect1.cy,size1.cy);
   recttowinrect(rect1);
   rect2:= rectty(prect(lparam)^);
   rectty(prect(lparam)^):= rect1;
   if not rectisequal(rect2,rectty(prect(lparam)^)) then begin
    exit;
   end;
  end;
  wm_move,wm_size: begin
   postconfigureevent(awinidty);
  end;
  wm_queryopen: begin
   eventlist.add(twindowevent.create(ek_show,awinidty));
  end;
  wm_windowposchanged: begin
   with pwindowpos(lparam)^ do begin
    if swp_hidewindow and flags <> 0 then begin
     eventlist.add(twindowevent.create(ek_hide,awinidty));
    end;
    if (swp_showwindow and flags <> 0) and (gui_getwindowsize(awinidty) <> wsi_minimized) then begin
     eventlist.add(twindowevent.create(ek_show,awinidty));
    end;
    if ((swp_nomove or swp_nosize) and flags <> (swp_nomove or swp_nosize)) and
            windowvisible(awinidty) then begin
     postconfigureevent(awinidty);
//     getwindowrectpa(awinidty,rect1,pt1); 
//     eventlist.add(twindowrectevent.create(ek_configure,awinidty,rect1,pt1));
     result:= 0;
     exit;
    end;
   end;
  end;
  wm_mousewheel: begin
   if mousewindow <> 0 then begin
    shiftstate:= wheelkeystatetoshiftstate(wparam);
    pt1:= winmousepostopoint(lparam);
    subpoint1(pt1,getclientrect(mousewindow).pos);
    inc(mousewheelpos,smallint(hiword(wparam)));
    while mousewheelpos >= wheelstep do begin
    eventlist.add(tmouseevent.create(mousewindow,false,mb_none,mw_up,pt1,
            winmousekeyflagstoshiftstate(wparam),timestamp));
     dec(mousewheelpos,wheelstep);
    end;
    while mousewheelpos <= -wheelstep do begin
     eventlist.add(tmouseevent.create(mousewindow,false,mb_none,mw_down,pt1,
            winmousekeyflagstoshiftstate(wparam),timestamp));
     inc(mousewheelpos,wheelstep);
    end;
    result:= 0;
    exit;
   end;
  end;
  wm_mousemove,
  wm_lbuttondown,wm_mbuttondown,wm_rbuttondown,
  wm_lbuttonup,wm_mbuttonup,wm_rbuttonup: begin
   pt1:= winmousepostopoint(lparam);
   checkmousewindow(awinidty,pt1);
   button:= checkbutton(msg);
   eventlist.add(tmouseevent.create(awinidty,
        (msg = wm_lbuttonup) or (msg = wm_mbuttonup) or (msg = wm_rbuttonup),
         button,mw_none,pt1,
           winmousekeyflagstoshiftstate(wparam),timestamp));
   result:= 0;
   exit;
  end;
  wm_keydown,wm_syskeydown: begin
   shiftstate:= winkeystatetoshiftstate(lparam);
   if lparam and $40000000 <> 0 then begin
    include(shiftstate,ss_repeat);
   end;
   key1:= winkeytokey(wparam,lparam,shiftstate);
   if key1 = key_escape then begin
    escapepressed:= true;
   end;
   eventlist.add(tkeyevent.create(awinidty,false,key1,key1,shiftstate,
                                    charbuffer,timestamp));
   charbuffer:= '';
  end;
  wm_keyup,wm_syskeyup: begin
   shiftstate:= winkeystatetoshiftstate(lparam);
   key1:= winkeytokey(wparam,lparam,shiftstate);
   if charbuffer <> '' then begin
    eventlist.add(tkeyevent.create(awinidty,false,key_none,key_none,shiftstate,
                                    charbuffer,timestamp));
    charbuffer:= '';
   end;
   eventlist.add(tkeyevent.create(awinidty,true,key1,key1,shiftstate,'',timestamp));
  end;
  wm_ime_startcomposition: begin
   if hasimm32 and (application.activewidget <> nil) and 
                            application.activewidget.hascaret then begin
    imc:= immgetcontext(awinidty);
    fillchar(imminfo,sizeof(imminfo),0);
    with imminfo,application do begin
     dwstyle:= cfs_point;
     ptcurrentpos.x:= caret.pos.x + caret.origin.x;
     ptcurrentpos.y:= caret.pos.y + caret.origin.y{ + caret.size.cy};
//     ptcurrentpos.x:= caret.pos.x + activewidget.rootpos.x;
//     ptcurrentpos.y:= activewidget.rootpos.y + activewidget.bounds_cy;
     immsetcompositionwindow(imc,@imminfo);
    end;
    immreleasecontext(awinidty,imc);
   end;
  end;
 end;
 if iswin95 then begin
  result:= defwindowproca(awinidty,msg,wparam,lparam);
 end
 else begin
  result:= defwindowprocw(awinidty,msg,wparam,lparam);
 end;
 if awinidty = sizingwindow then begin
  inc(eventlooping);
  try
   tapplication1(application).eventloop(true);
  finally
   dec(eventlooping);
  end;
 end;
end;}

{function childWindowProc(awinidty: winidty; Msg: UINT; wParam: WPARAM;
            lParam: LPARAM): LRESULT; stdcall;
var
 parent: winidty;
 pt1: pointty;
 rect1: trect;
 rect2: rectty;
begin
 parent:= getparent(awinidty);
 case msg of
  wm_destroy: begin
   windowdestroyed(awinidty);
   eventlist.add(twindowevent.create(ek_destroy,awinidty));
  end;
  wm_mousemove,
  wm_lbuttondown,wm_mbuttondown,wm_rbuttondown,
  wm_lbuttonup,wm_mbuttonup,wm_rbuttonup,
  wm_mousewheel: begin
   getwindowrect(awinidty,rect1);
   rect2:= getclientrect(parent);
   pt1.x:= rect1.left - rect2.x;
   pt1.y:= rect1.top - rect2.y;
   pt1:= addpoint(winmousepostopoint(lparam),pt1);
   result:= windowproc(parent,msg,wparam,pointtowinmousepos(pt1));
   exit;
  end;
 end;
 if iswin95 then begin
  result:= defwindowproca(awinidty,msg,wparam,lparam);
 end
 else begin
  result:= defwindowprocw(awinidty,msg,wparam,lparam);
 end;
end;}

procedure dispatchevents;
var
 str1: string;
 e: SDL_Event;
begin
 if eventlooping > 0 then begin
  exit;
 end;
 {while (SDL_PollEvent(@e)>0) do begin
  case e.type_ of
   SDL_QUITEV:  begin     
    break;
   end;
   SDL_WINDOWEVENT :begin
    if (e.win.event = sdlweMaximized) then begin
     debugwriteln('maximized');
    end;
   end;
   SDL_KEYDOWN :begin
    //if (e.win.event = sdlweMaximized) then begin
     debugwriteln('press key');
    //end;
   end;
   SDL_MOUSEMOTION: begin
    SDL_RenderDrawPoint(renderer,e.motion.y,e.motion.z);
    debugwriteln('mouse move :'+inttostr(e.motion.z)+' - '+inttostr(e.motion.y));
   end;
  end;
 end;

 while peekmessagew(msg,0,0,0,pm_remove) do begin
  with msg do begin
   case message of
    destroymessage: begin
     windows.destroywindow(msg.wparam);
    end;
    wm_keydown,wm_keyup,wm_syskeydown,wm_syskeyup: begin
     translatemessage(msg);
     while peekmessagew(msg1,msg.winidty,wm_char,wm_char,pm_remove) do begin
      charbuffer:= charbuffer + msechar(msg1.wparam);
     end;
     while peekmessagew(msg1,msg.winidty,wm_syschar,wm_syschar,pm_remove) do begin
      charbuffer:= charbuffer + msechar(msg1.wparam);
     end;
     dispatchmessagew(msg);
    end
    else begin
     dispatchmessagew(msg);
    end;
   end;
  end;
 end;}
end;

function gui_hasevent: boolean;
begin
 result:= SDL_HasEvents(SDL_FIRSTEVENT,SDL_USEREVENT);
end;

function gui_getevent: tmseevent;
var
 e: SDL_Event;
 rect1: rectty;
begin
 result:= nil;
 while true do begin
  if (SDL_PollEvent(@e)>0) then begin
   case e.type_ of
    SDL_QUITEV:  begin
     application.postevent(tmseevent.create(ek_terminate));
     //break;
    end;
    SDL_WINDOWEVENT :begin
     if (e.win.event = SDL_WINDOWEVENT_ENTER) then begin
      result:= twindowevent.create(ek_enterwindow,e.win.window);
     end else if (e.win.event = SDL_WINDOWEVENT_LEAVE) then begin
      result:= twindowevent.create(ek_leavewindow,e.win.window);
     end else if (e.win.event = SDL_WINDOWEVENT_CLOSE) then begin
      result:= twindowevent.create(ek_close,e.win.window);
     end else begin
      winrecttorect(rect1);
      eventlist.add(twindowrectevent.create(ek_expose,e.win.window,rect1,nullpoint));
     end;
     break;
    end;
    SDL_KEYDOWN :begin
     //if (e.win.event = sdlweMaximized) then begin
      debugwriteln('press key');
     //end;
    end;
    SDL_MOUSEMOTION: begin
     result:= tmouseevent.create(e.motion.window,false,mb_none,mw_none,
                makepoint(e.motion.z,e.motion.y),[], MilliSecondOf(time)*1000);
     //break;
    end;
   end;
  end;
 end;

//batas
{      result:= tmseevent(getclientpointer(xev.xclient));
  keypress: begin
    result:= tkeyevent.create(xwindow,false,key1,key2,
                                    shiftstate1,chars,time*1000);
   end;
  end;
  keyrelease: begin
   with xev.xkey do begin
    lasteventtime:= time;
    int1:= keycode;
    xlookupstring(@xev.xkey,nil,0,@akey,nil);
    shiftstate1:= [];
    key1:= xkeytokey(akey,shiftstate1);
    key2:= getkeynomod(xev.xkey);
    shiftstate1:= shiftstate1 + xtoshiftstate(state,key1,mb_none,true);
    if xpending(appdisp) > 0 then begin
     xpeekevent(appdisp,@xev);
     if (xev.xtype = keypress) and (time - lasteventtime < 10) and 
                                                   (keycode = int1) then begin
      repeatkey:= int1;
      repeatkeytime:= time;
      goto eventrestart;  //auto repeat key, don't send
     end;
    end;
    result:= tkeyevent.create(xwindow,true,key1,key2,shiftstate1,'',time*1000);
   end;
  end;
  buttonpress,buttonrelease: begin
   with xev.xbutton do begin
    lasteventtime:= time;
    button1:= xtomousebutton(button);
    shiftstate1:= xtoshiftstate(state,key_none,button1,xev.xtype=buttonrelease);
    if button = 4 then begin
     if xev.xtype = buttonpress then begin
      result:= tmouseevent.create(xwindow,false,mb_none,mw_up,
                makepoint(x,y),shiftstate1,time*1000);
     end;
    end
    else begin
     if button = 5 then begin
      if xev.xtype = buttonpress then begin
       result:= tmouseevent.create(xwindow,false,mb_none,mw_down,
                makepoint(x,y),shiftstate1,time*1000);
      end;
     end
     else begin
      result:= tmouseevent.create(xwindow,xtype = buttonrelease,button1,mw_none,
                makepoint(x,y),shiftstate1,time*1000);
     end;
    end;
   end;
  end;
  mappingnotify: begin
   xrefreshkeyboardmapping(@xev.xkeymap);
  end;
  mapnotify: begin
   with xev.xmap do begin
    result:= twindowevent.create(ek_show,xwindow);
    if application.findwindow(xwindow,window1) and 
             (wo_notaskbar in window1.options) then begin
     setnetatomarrayitem(xwindow,net_wm_state,net_wm_state_skip_taskbar);
    end;
   end;
  end;
  unmapnotify: begin
   with xev.xunmap do begin
    result:= twindowevent.create(ek_hide,xwindow);
   end;
  end;
  focusin,focusout: begin
   with xev.xfocus do begin
    if xtype = focusin then begin
     eventkind:= ek_focusin;
    end
    else begin
     eventkind:= ek_focusout;
    end;
    if mode <> notifypointer then begin
     result:= twindowevent.create(eventkind,window);
    end;
   end;
  end;
  expose: begin
   with xev.xexpose do begin
    result:= twindowrectevent.create(ek_expose,xwindow,
                          makerect(x,y,width,height),nullpoint);
   end;
  end;
  graphicsexpose: begin
   with xev.xgraphicsexpose do begin
    result:= twindowrectevent.create(ek_expose,drawable,
                          makerect(x,y,width,height),nullpoint);
   end;
  end;
  configurenotify: begin
   with xev.xconfigure do begin
    w:= xwindow;
    xsync(appdisp,false);
    if xchecktypedwindowevent(appdisp,w,destroynotify,@xev2) then begin
     result:= twindowevent.create(ek_destroy,xwindow);
    end
    else begin
     if not application.deinitializing and 
       (getwindowrect(w,rect1,pt1) = gue_ok) then begin
                         //there can be an Xerror?
     //gnome returns a different pos on window resizing than on window moving!
      result:= twindowrectevent.create(ek_configure,w,rect1,pt1);
     while xchecktypedwindowevent(appdisp,w,configurenotify,@xev) do begin
     end;
    end;
   end;
  end;
  destroynotify: begin
   with xev.xdestroywindow do begin
    result:= twindowevent.create(ek_destroy,xwindow);
   end;
  end;
 end;
}
end;

function createapphandle(out id: winidty): guierrorty;
var
 str1: string;
 //menu1: hmenu;
begin
 str1:= application.applicationname;
 {id:= windows.CreateWindow(widgetclassname,pchar(str1),
             WS_POPUP or WS_CAPTION or WS_CLIPSIBLINGS or 
             WS_SYSMENU or WS_MINIMIZEBOX,0,0,0,0,0,0,hinstance,nil);
 menu1:= getsystemmenu(id,false);
 deletemenu(menu1,sc_maximize,mf_bycommand);
 deletemenu(menu1,sc_size,mf_bycommand);
 deletemenu(menu1,sc_move,mf_bycommand);}
 id:= SDL_CreateWindow(pchar(str1),0,0,0,0,[SDL_WINDOW_MINIMIZED]);
 SDL_HideWindow(id);
 if id = 0 then begin
  result:= gue_createwindow;
 end
 else begin
  result:= gue_ok;
 end;
end;

function gui_settransientfor(var awindow: windowty; const transientfor: winidty): guierrorty;
begin
{ with awindow,win32windowty(platformdata).d do begin
  if not istaskbar then begin
   setwindowlong(id,gwl_winidtyparent,transientfor); //no taskbar widget if called!
// transientfor can be destroyed
  end;
 end;}
 result:= gue_ok;
end;

function gui_windowatpos(const pos: pointty): winidty;
begin
 //result:= windowfrompoint(tpoint(pos));
end;

function gui_setsizeconstraints(id: winidty; const min,max: sizety): guierrorty;
begin
 result:= gue_ok; //nothing to do on win32
end;

function gui_setwindowgroup(id: winidty; group: winidty): guierrorty;
begin
 result:= gue_ok;
end;

function gui_createwindow(const rect: rectty;
                             const options: internalwindowoptionsty;
                             var awindow: windowty): guierrorty;
var
 windowstyle,ca2: UInt32;
 windowstyleex: SDL_WindowFlags;
 rect1: rectty;
 classname: string;
 ownerwindow: winidty;
begin
 fillchar(awindow,sizeof(awindow),0);
 with awindow,options do begin
  ownerwindow:= applicationwindow;
  windowstyleex:= [SDL_WINDOW_SHOWN,SDL_WINDOW_RESIZABLE];
//  if wo_popup in options then begin
  if options * noframewindowtypes <> [] then begin
   //windowstyle:= ws_popup;
   windowstyleex:= windowstyleex + [SDL_WINDOW_BORDERLESS];
  end
  else begin
   if wo_message in options then begin
    //windowstyle:= ws_overlappedwindow;
    windowstyleex:= windowstyleex + [SDL_WINDOW_BORDERLESS];
   end
   else begin
    //windowstyle:= ws_overlappedwindow;
    if wo_taskbar in options then begin
     //istaskbar:= true;
     //windowstyleex:= windowstyleex or ws_ex_appwindow;
     SDL_HideWindow(applicationwindow);
     ownerwindow:= 0;
    end;
   end;
   if wo_embedded in options then begin
    //windowstyle:= ws_child;
   end;
  end;
  {if pos = wp_default then begin
   rect1.x:= integer(cw_usedefault);
   rect1.y:= integer(cw_usedefault);
   rect1.cx:= integer(cw_usedefault);
   rect1.cy:= integer(cw_usedefault);
  end
  else begin}
   rect1:= rect;
  //end;
  //windowstyle:= windowstyle or ws_clipchildren;
  if (transientfor <> 0) or (options * [wo_popup,wo_message,wo_notaskbar] <> []) then begin
   if transientfor <> 0 then begin
    ownerwindow:= transientfor;
   end;
   {id:= windows.CreateWindowex(windowstyleex,widgetclassname,nil,windowstyle,
         rect1.x,rect1.y,rect1.cx,rect1.cy,ownerwindow,0,hinstance,nil);}
   id:= SDL_CreateWindow(widgetclassname,rect1.x,rect1.y,rect1.cx,rect1.cy,windowstyleex);

   if transientfor = 0 then begin
    //setwindowpos(id,winidty_top,0,0,0,0,swp_noactivate or swp_nomove or 
    //                                        swp_nosize or swp_noownerzorder);
   end;
  end
  else begin
   if parent <> 0 then begin
    ca2:= parent;
    //windowstyle:= ws_child;
    classname:= childwidgetclassname;
   end
   else begin
    ca2:= ownerwindow;
    classname:= widgetclassname;
   end;
   {id:= windows.CreateWindowex(windowstyleex,pchar(classname),nil,
         windowstyle,rect1.x,rect1.y,rect1.cx,rect1.cy,ca2,0,hinstance,nil);}
    id:= SDL_CreateWindow(pchar(classname),rect1.x,rect1.y,rect1.cx,rect1.cy,windowstyleex);
   if setgroup and (groupleader = 0) or (wo_groupleader in options) then begin
    groupleaderwindow:= id;
   end;
  end;
  if id = 0 then begin
   result:= gue_createwindow;
  end
  else begin
   if not (pos = wp_default) and (parent = 0) then begin
    result:= gui_reposwindow(id,rect);
   end
   else begin
    result:= gue_ok;
   end;
  end;
  {if icon <> 0 then begin
   gui_setwindowicon(id,icon,iconmask);
   if (groupleaderwindow = id) then begin
    gui_setwindowicon(applicationwindow,icon,iconmask);
   end;
  end;}
 end;
end;

function gui_getparentwindow(const awindow: winidty): winidty;
begin
 result:= awindow;
// result:= getparent(awindow);
 //result:= getancestor(awindow,ga_parent);
end;

function gui_reparentwindow(const child: winidty; const parent: winidty;
                            const pos: pointty): guierrorty;
var
 rect1: rectty;
begin
 result:= gue_reparent;
 {if setparent(child,parent) <> 0 then begin
  if parent = 0 then begin
   result:= gui_getwindowrect(child,rect1);
   if result = gue_ok then begin
    rect1.pos:= pos;
    result:= gui_reposwindow(child,rect1);
   end;
  end
  else begin
   if setwindowpos(child,0,pos.x,pos.y,0,0,swp_nosize or swp_nozorder or
                               swp_noownerzorder or swp_noactivate) then begin
    result:= gue_ok;
   end;
  end;
 end;}
end;

type
 enumchildinfoty = record
  childlist: winidarty;
  count: integer;
  parent: winidty;
 end;
 penumchildinfoty = ^enumchildinfoty;

{function getchildren(child: winidty; data: lparam): winbool; stdcall;
begin
 with penumchildinfoty(data)^ do begin
  if gui_getparentwindow(child) = parent then begin
   additem(childlist,child,count);
  end;
 end;
 result:= true;
end;}

function gui_getchildren(const id: winidty; out children: winidarty): guierrorty;
var
 info: enumchildinfoty;
begin
 fillchar(info,sizeof(info),0);
 {with info do begin
  parent:= id;
  enumchildwindows(id,@getchildren,ptruint(@info));
  setlength(childlist,count);
  children:= childlist;
 end;}
 result:= gue_ok;
end;

function gui_setmainthread: guierrorty; //set mainthread to currentthread
begin
 mainthread:= getcurrentthreadid;
 result:= gue_ok;
end;

function gui_getscreenrect(const id: winidty): rectty; //0 -> virtual screen
var
// info: tmonitorinfo;
 arect: SDL_Rect;
begin
{ info.cbsize:= sizeof(info);
 if (id = 0) or not getmonitorinfo(monitorfromwindow(id,monitor_defaulttonearest),
                                                       @info) then begin
  result.x:= getsystemmetrics(sm_xvirtualscreen);
  result.y:= getsystemmetrics(sm_yvirtualscreen);
  result.cx:= getsystemmetrics(sm_cxvirtualscreen);
  result.cy:= getsystemmetrics(sm_cyvirtualscreen);
  if result.cx = 0 then begin
   result.cx:= getsystemmetrics(sm_cxscreen)
  end;
  if result.cy = 0 then begin
   result.cy:= getsystemmetrics(sm_cyscreen)
  end;
 end
 else begin
  result:= rectty(info.rcmonitor);
  winrecttorect(result);
 end;}
 gui_getwindowrect(id,result);
end;

function gui_getworkarea(id: winidty): rectty;
//var
// info: tmonitorinfo;
begin
// if systemparametersinfo(spi_getworkarea,0,@result,0) then begin
 {info.cbsize:= sizeof(info);
 if getmonitorinfo(monitorfromwindow(id,monitor_defaulttonearest),
                                                       @info) then begin
  result:= rectty(info.rcwork);
  winrecttorect(result);
 end
 else begin
  result:= nullrect;                            
 end;}
end;


const
 NIF_MESSAGE = $00000001;
 NIF_ICON = $00000002;
 NIF_TIP = $00000004;
 NIF_STATE = $00000008;
 NIF_INFO = $00000010;
 NIF_GUID = $00000020;

 NIIF_NONE = $00000000;
 NIIF_INFO = $00000001;
 NIIF_WARNING = $00000002;
 NIIF_ERROR = $00000003;
 NIIF_USER = $00000004;
 NIIF_NOSOUND = $00000010;
 NIIF_LARGE_ICON = $00000010;
 NIIF_RESPECT_QUIET_TIME = $00000080;
 NIIF_ICON_MASK = $0000000F;

 NIM_ADD = $00000000;
 NIM_MODIFY = $00000001;
 NIM_DELETE = $00000002;
 NIM_SETFOCUS = $00000003;
 NIM_SETVERSION = $00000004;

//type
 {iconunionty = record
  case boolean of
   false: (uTimeout: UINT);
   true: (uVersion: UINT); // Used with Shell_NotifyIcon flag NIM_SETVERSION.
 end;
 NOTIFYICONDATAW_2 = record
  cbSize: DWORD;
  Wnd: winidty;
  uID: UINT;
  uFlags: UINT;
  uCallbackMessage: UINT;
  hIcon: HICON;
  szTip: array [0..127] of widechar;
  dwState: DWORD;
  dwStateMask: DWORD;
  szInfo: array[0..255] of widechar;
  u: iconunionty;
  szInfoTitle: array[0..63] of widechar;
  dwInfoFlags: DWORD;
 end;
}
{function traycommand(var child: windowty; 
                       const command: integer; const flags: integer = 0;
                             const CallbackMessage: UINT = 0;
                             const Icon: HICON = 0;
                             const Tip: msestring = '';
                             const State: DWORD = 0;
                             const StateMask: DWORD = 0;
                             const Info: msestring = '';
                             const Timeout: UINT = 0;
                             const Version: UINT = 0;
                             const InfoTitle: msestring = '';
                             const InfoFlags: DWORD = 0): guierrorty;

// traycommand(child,command,flags,0,0,'',0,0,'',0,0,'',0);

 procedure movestr(const source: msestring; var dest; const acount: integer);
 var
  int1: integer;
 begin
  int1:= length(source);
  if int1 > acount then begin
   int1:= acount;
  end;
  move(source[1],dest,int1*sizeof(widechar));
 end;
 
var
// dataa: notifyicondataa;
// dataw: notifyicondataw_2;
// int1: integer;
begin
 result:= checkshellinterface;
 if result = gue_ok then begin
  result:= gue_notraywindow;
  if iswin95 then begin
  end
  else begin
   fillchar(dataw,sizeof(dataw),0);
   with dataw do begin
    cbsize:= sizeof(dataw);
    wnd:= child.id;
    uflags:= flags;
    uCallbackMessage:= CallbackMessage;
    hIcon:= Icon;
    movestr(tip,szTip,sizeof(szTip));
    dwState:= State;
    dwStateMask:= StateMask;
    movestr(Info,szInfo,256);
    if command = nim_setversion then begin
     u.uVersion:= version;
    end
    else begin
     u.uTimeout:= Timeout;
    end;
    movestr(InfoTitle,szInfoTitle,64);
    dwInfoFlags:= InfoFlags;
   end;
   if shell_notifyiconw(command,@dataw) then begin
    result:= gue_ok;
   end;
  end;
 end;
end;
}
function docktotray(var child: windowty): guierrorty;
begin
{ result:= traycommand(child,nim_add,nif_message,traycallbackmessage);
 if result = gue_ok then begin
  result:= traycommand(child,nim_setversion,0,0,0,'',0,0,'',0,0);
 end;}
end;

function undockfromtray(var child: windowty): guierrorty;
begin
 //result:= traycommand(child,nim_delete);
end;

function gui_showsysdock(var awindow: windowty): guierrorty;
begin
 result:= gui_hidewindow(awindow.id);
end;

function gui_hidesysdock(var awindow: windowty): guierrorty;
begin
 result:= gui_hidewindow(awindow.id);
end;

function gui_docktosyswindow(var child: windowty;
                                   const akind: syswindowty): guierrorty;
var
 rect1: rectty;
 pt1: pointty;
begin
{ gui_hidewindow(child.id);
 if akind = sywi_none then begin
  result:= undockfromtray(child);
  getwindowrectpa(child.id,rect1,pt1);
  result:= gui_reparentwindow(child.id,0,subpoint(rect1.pos,pt1));
 end
 else begin
  result:= gue_windownotfound;
  case akind of
   sywi_tray: begin
    result:= docktotray(child);
   end;
  end;
 end;}
end;

function gui_undockfromsyswindow(var child: windowty): guierrorty;
                    //hides window
begin
 gui_hidewindow(child.id);
 result:= undockfromtray(child);
end;

function gui_traymessage(var awindow: windowty; const message: msestring;
                          out messageid: longword;
                          const timeoutms: longword = 0): guierrorty;
var
 int1: integer;
begin
 messageid:= 1;
 int1:= timeoutms;
 if timeoutms = 0 then begin
  int1:= bigint;
 end;
 //result:= traycommand(awindow,nim_modify,nif_info,0,0,'',0,0,
 //                                                    message,int1,0,'',0);
end;

function gui_canceltraymessage(var awindow: windowty;
                          const messageid: longword): guierrorty;
begin
 //result:= traycommand(awindow,nim_modify,nif_info,0,0,'',0,0,
 //                                                    '',0,0,'',0);
end;

function gui_settrayicon(var awindow: windowty;
                                     const icon,mask: pixmapty): guierrorty;
//var
// ico{,ico1}: hicon;
begin
{ ico:= 0;
 if icon <> 0 then begin
  ico:= composeicon(icon,mask);
  if ico = 0 then begin
   exit;
  end;
 end;
 result:= traycommand(awindow,nim_modify,nif_icon,0,ico);}
end;

function gui_settrayhint(var awindow: windowty;
                                     const hint: msestring): guierrorty;
begin
// result:= traycommand(awindow,nim_modify,nif_tip,0,0,hint);
end;

function gui_initcolormap: guierrorty;
begin
 result:= gue_ok; //dummy
end;

function gui_init: guierrorty;
begin
 SDL_Init(SDL_INIT_EVERYTHING);
 mousewindow:= 0;
 mousecursor:= 0;
 applicationwindow:= 0;
 fillchar(keystate,sizeof(keystate),0);
 shiftstate:= [];
 charbuffer:= '';
 gui_setmainthread;
 eventlist:= tobjectqueue.create(true);
 //desktopwindow:= getdesktopwindow;

 //msesdlgdi.init;

 {fillchar(classinfoa,sizeof(classinfoa),0);
 if iswin95 then begin
  with classinfoa do begin
   lpszclassname:= childwidgetclassname;
   lpfnwndproc:= @childwindowproc;
   hinstance:= {$ifdef FPC}system{$else}sysinit{$endif}.HInstance;
   style:= classstyle;
   cbwndextra:= wndextrabytes;
  end;
  childwidgetclass:= registerclassa(classinfoa);
  fillchar(classinfoa,sizeof(classinfoa),0);
  with classinfoa do begin
   lpszclassname:= widgetclassname;
   lpfnwndproc:= @windowproc;
   hinstance:= {$ifdef FPC}system{$else}sysinit{$endif}.HInstance;
   style:= classstyle;
   cbwndextra:= wndextrabytes;
  end;
  widgetclass:= registerclassa(classinfoa);
 end
 else begin
  fillchar(classinfow,sizeof(classinfow),0);
  with classinfow do begin
   lpszclassname:= childwidgetclassname;
   lpfnwndproc:= @childwindowproc;
   hinstance:= {$ifdef FPC}system{$else}sysinit{$endif}.HInstance;
   style:= classstyle;
   cbwndextra:= wndextrabytes;
//   hbrbackground:= getstockobject(hollow_brush);
  end;
  childwidgetclass:= registerclassw(classinfow);
  fillchar(classinfow,sizeof(classinfow),0);
  with classinfow do begin
   lpszclassname:= widgetclassname;
   lpfnwndproc:= @windowproc;
   hinstance:= {$ifdef FPC}system{$else}sysinit{$endif}.HInstance;
   style:= classstyle;
   cbwndextra:= wndextrabytes;
  end;
  widgetclass:= registerclassw(classinfow);
 end;
 if widgetclass = 0 then begin
  result:= gue_registerclass;
 end
 else begin
  result:= gue_ok;
 end;}
 if applicationallocated then begin
  createapphandle(applicationwindow);
 end;
 result:= gue_ok;
end;

function gui_deinit: guierrorty;
var
 acursor: cursorshapety;

begin
 killtimer;
 //killmouseidletimer;
 if applicationwindow <> 0 then begin
  SDL_DestroyWindow(applicationwindow);
  applicationwindow:= 0;
 end;
 freeandnil(eventlist);
 //unregisterclass(widgetclassname,hinstance);
 //widgetclass:= 0;
 
 SDL_Quit;
 //msegdi32gdi.deinit;

 result:= gue_ok;
 mainthread:= 0;
 mousewindow:= 0;
 mousecursor:= 0;
 for acursor:= low(acursor) to high(acursor) do begin
  if cursors[acursor] <> 0 then begin
   //destroycursor(cursors[acursor]);
   cursors[acursor]:= 0;
  end;
 end;
end;

function gui_getgdifuncs: pgdifunctionaty;
begin
 result:= sdlgetgdifuncs;
end;

procedure GUI_DEBUGBEGIN;
begin
// setactivewindow(0);
end;

procedure GUI_DEBUGEND;
begin
end;

function gui_registergdi: guierrorty;
begin
 registergdi(sdlgetgdifuncs);
 result:= gue_ok;
end;

initialization
end.
