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
 msethread,mseformatstr,{msesysintf,}msestrings,msesystypes,
 sdl4msegui,msesdlgdi,dateutils;

type
 syseventty = SDL_Event;
   
const
 wheelstep = 120;

// pixel0 = $000000;
// pixel1 = $ffffff;
 pixel0 = $ffffff;   //select colorbackground
 pixel1 = $000000;   //select colorforeground

{$ifdef FPC}
{$include ../mseguiintf.inc}
{$else}
{$include mseguiintf.inc}
{$endif}

function getapplicationwindow: winidty;

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
             
function getapplicationwindow: winidty;
begin
 result:= applicationwindow;
end;

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
 result:= SDL_CheckError('copytoclipboard');
end;

function gui_canpastefromclipboard: boolean;
begin
 result:= SDL_HasClipboardText;
 SDL_CheckError('canpastefromclipboard');
end;

function gui_pastefromclipboard(out value: msestring): guierrorty;
var               //todo: get msechars from clipboard, win95?
 data: thandle;
 po1: pointer;
 str1: string;
begin
 result:= gue_clipboard;
 value:= SDL_GetClipboardText;
 result:= SDL_CheckError('pastefromclipboard');
end;

function gui_getwindowsize(id: winidty): windowsizety;
var
 flag: SDL_WindowFlags;
begin
 flag:= SDL_GetWindowFlags(id);
 case flag of
  SDL_WINDOW_FULLSCREEN: result:= wsi_fullscreen;
  SDL_WINDOW_MAXIMIZED: result:= wsi_maximized;
  SDL_WINDOW_MINIMIZED: result:= wsi_minimized;
 else
  result:= wsi_normal;
 end;
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
 result:= not (SDL_WINDOW_HIDDEN=aflag);
end;

function gui_windowvisible(id: winidty): boolean;
begin
 result:= iswindowvisible(id);
end;

function gui_setwindowstate(id: winidty; size: windowsizety;
                            visible: boolean): guierrorty;
begin
 case size of 
  wsi_normal: SDL_ShowWindow(id);
  wsi_minimized: SDL_MinimizeWindow(id);
  wsi_maximized: SDL_MaximizeWindow(id);
  wsi_fullscreen: SDL_SetWindowFullscreen(id,true);
  wsi_fullscreenvirt: SDL_SetWindowFullscreen(id,true);
 end;
 SDL_CheckError('setwindowstate');
end;

function gui_getpointerpos: pointty;
var
 x,y: integer;
begin
 //SDL_GetMouseState(@x,@y);
 SDL_GetRelativeMouseState(@x,@y);
 SDL_CheckError('getpointerpos');
 result.x:= x;
 result.y:= y;
end;

function gui_setpointerpos(const pos: pointty): guierrorty;
begin
 result:= gue_mousepos;
 SDL_WarpMouseInWindow(mousewindow,pos.x,pos.y);
 result:= SDL_CheckError('setpointerpos');
end;

function gui_movepointer(const dist: pointty): guierrorty;
var
 x,y: integer;
begin
 result:= gue_mousepos;
 SDL_GetMouseState(@x,@y);
 SDL_WarpMouseInWindow(mousewindow,x+dist.x,y+dist.y);
 result:= SDL_CheckError('movepointer');
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
 //create surface
 result:= SDL_CreateRGBSurface(0,size.cx,size.cy,32,0,0,0,0);
 SDL_CheckError('createpixmap');
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
 SDL_CheckError('createpixmapfromdata');
end;

function gui_freepixmap(pixmap: pixmapty): gdierrorty;
begin
 SDL_FreeSurface(pixmap);
 SDL_CheckError('freepixmap');
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
begin
 with CSDL_Surface(pixmap)^ do begin
  image.pixels:= pixels; 
  image.bgr:= false;
  image.size.cx:= w;
  image.size.cy:= h;
  image.length:= w*h;
 end;
 result:= gde_ok;
 SDL_CheckError('pixmatoimage'); 
end;

function gui_imagetopixmap(const image: imagety; out pixmap: pixmapty;
                           gchandle: longword): gdierrorty;
begin
 result:= gde_pixmap;
 pixmap:= SDL_CreateRGBSurfaceFrom(image.pixels,image.size.cx,image.size.cy,32,image.size.cx*4,0,0,0,0);
 //SDL_SaveBMP_toFile(pixmap,'xx.bmp');
 SDL_CheckError('imagetopixmap');
 result:= gde_ok;
end;

function gui_setwindowfocus(id: winidty): guierrorty;
begin
 result:= gue_windowfocus;
 SDL_ShowWindow(id);
 result:= SDL_CheckError('setwindowfocus');
end;

function gui_setappfocus(id: winidty): guierrorty;
begin
 result:= gue_windowfocus;
 SDL_ShowWindow(id);
 result:= SDL_CheckError('setappfocus');
end;

function gui_minimizeapplication: guierrorty;
begin
 SDL_MinimizeWindow(applicationwindow);
 result:= SDL_CheckError('miniizeapplication');
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
 cursor:= SDL_CreateCursor(curdragand,curdragxor,32,32,0,0);
 SDL_SetCursor(cursor);
 mousecursor:= cursor;
 result:= SDL_CheckError('setcursorshape');
end;

procedure killtimer;
begin
 if timer <> 0 then begin
  SDL_RemoveTimer(timer);
  //SDL_CheckError('killtimer');
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
 //result:= SDL_CheckError('settimer');
end;

procedure gui_beep;
begin
 //windows.MessageBeep($ffffffff);
end;

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
 result:= gue_destroywindow;
 SDL_DestroyWindow(awindow.id);
 result:= SDL_CheckError('destroywindow');
 windowdestroyed(awindow.id);
end;

function gui_showwindow(id: winidty): guierrorty;
begin
 SDL_ShowWindow(id);
 result:= SDL_CheckError('showwindow');
end;

function gui_hidewindow(id: winidty): guierrorty;
begin
 SDL_HideWindow(id);
 result:= SDL_CheckError('HideWindow');
end;

function gui_raisewindow(id: winidty): guierrorty;
begin
 SDL_RaiseWindow(id);
 result:= SDL_CheckError('raisewindow');
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
  result:= SDL_CheckError('setwindowcaption');
 end;
end;

function composeicon(const icon,mask: pixmapty): PSDL_Surface;
begin
 if mask<>0 then begin
  SDL_SetSurfaceBlendMode(mask,SDL_BLENDMODE_ADD);
  SDL_UpperBlit(mask,nil,icon,nil);
 end;
 result:= icon;
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
 result:= SDL_CheckError('setwindowicon');
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

{
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
begin
 result:= iswindowvisible(handle);
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
 SDL_SetWindowPosition(id,rect.x+dist.x,rect.y+dist.y);
 result:= SDL_CheckError('movewindowrect');
end;

function getclientrect(winid: winidty; windowrect: prectty = nil): rectty;
                     //screen origin
begin
 SDL_GetWindowSize(winid,result.cx,result.cy);
 SDL_GetWindowPosition(winid,result.x,result.y);
 SDL_CheckError('getclientrect');
end;

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
 result:= SDL_CheckError('getwindowpos');
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
 rect1: rectty;
begin
 result:= gue_resizewindow;
 rect1:= getclientrect(id);
 if not ((rect.x=rect1.x) and (rect.y=rect1.y) and 
  (rect.cx=rect1.cx) and (rect.cy=rect1.cy)) then begin
  SDL_SetWindowPosition(id,rect.x,rect.y);
  SDL_SetWindowSize(id,rect.cx,rect.cy);
  SDL_GetWindowSurface(id);
  result:= SDL_CheckError('reposwindow');
  if configuredwindow <> id then begin
   postconfigureevent(id);
  end;
 end else begin
  result:= gue_ok;
 end;
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
 result:= SDL_CheckError('setdecoratewindowrect');
end;

function gui_setembeddedwindowrect(id: winidty; const rect: rectty): guierrorty;
begin
 result:= gue_resizewindow;
 SDL_SetWindowPosition(id,rect.x,rect.y);
 result:= SDL_CheckError('setembeddedwindowrect');
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
var
 sdlevent: SDL_Event;
begin
 result:= gue_postevent;
 case event.kind of
  {ek_focusin,ek_focusout,ek_checkapplicationactive,
  ek_enterwindow,ek_leavewindow,
  ek_mousewheel,
  ek_mousemove,ek_mousepark,
  ek_mouseenter,ek_mouseleave,ek_mousecaptureend,
  ek_clientmouseenter,ek_clientmouseleave,
  ek_configure,
  ek_terminate,ek_abort,ek_destroy,ek_show,ek_hide,ek_close,
  ek_activate,ek_loaded,
  ek_keypress,ek_keyrelease,ek_timer,ek_wakeup,
  ek_release,ek_closeform,ek_checkscreenrange,
  ek_childscaled,
  ek_dropdown,ek_async,ek_execute,ek_component,
  ek_synchronize,ek_releaseobject,
  ek_connect,
  ek_dbedit,ek_dbupdaterowdata,ek_data,ek_objectdata,ek_childproc,
  ek_dbinsert, 
  ek_mse,
  ek_user}
  ek_resize: begin
   debugwriteln('post resize event');
  end;
  ek_expose: begin
   debugwriteln('post expose event');
  end;
  ek_buttonpress,ek_buttonrelease: begin
   debugwriteln('post button press/release event');
   with tmouseevent(event) do begin
    sdlevent.button.x:= fpos.x;
    sdlevent.button.y:= fpos.y;
    SDL_PushEvent(@sdlevent);
   end;
  end;
 end;
 //result:= SDL_CheckError('postevent');   
 SDL_PumpEvents;
 {if windows.postmessage(applicationwindow,msemessage,longword(event),0) then begin
  result:= gue_ok;
 end
 else begin
  result:= gue_postevent;
 end;}
end;

function gui_escapepressed: boolean;
begin
 result:= escapepressed;
end;

procedure gui_resetescapepressed;
begin
 escapepressed:= false;
end;

procedure dispatchevents;
var
 str1: string;
 e: SDL_Event;
begin
 if eventlooping > 0 then begin
  exit;
 end;
 SDL_PumpEvents;
 {while peekmessagew(msg,0,0,0,pm_remove) do begin
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
 //SDL_CheckError('hasevent');
end;

function gui_getevent: tmseevent;
var
 e: SDL_Event;
 rect1: rectty;
 winid: winidty;
 key1: keyty;
 shiftstate1: shiftstatesty;
 release1: boolean;
 mousewheel1: mousewheelty;
 pt1: pointty;
begin
 dispatchevents;
 result:= nil;
 while true do begin
  if (SDL_PollEvent(@e)>0) then begin
   case e.type_ of
    SDL_QUITEV:  begin
     application.postevent(tmseevent.create(ek_terminate));
     break;
    end;
    SDL_WINDOWEVENT : begin
     winid:= SDL_GetWindowFromID(e.window.window);
     if (e.window.event = SDL_WINDOWEVENT_ENTER) or (e.window.event = SDL_WINDOWEVENT_FOCUS_GAINED) then begin
      if (winid = applicationwindow) and (lastfocuswindow <> 0) then begin
       if windowvisible(lastfocuswindow) then begin
        gui_setwindowfocus(lastfocuswindow);
       end
       else begin
        if application.activewindow <> nil then begin
         gui_setwindowfocus(application.activewindow.winid);
        end
        else begin
         if application.mainwindow <> nil then begin
          gui_setwindowfocus(application.mainwindow.winid);
         end;
        end;
       end;
      end
      else begin
       if windowvisible(winid) then begin
        lastfocuswindow:= winid;
        if e.window.event = SDL_WINDOWEVENT_FOCUS_GAINED then begin
         result:= twindowevent.create(ek_focusin,winid);
        end else if e.window.event = SDL_WINDOWEVENT_ENTER then begin
         result:= twindowevent.create(ek_enterwindow,winid)
        end;
       end;
      end;
     end else if (e.window.event = SDL_WINDOWEVENT_LEAVE) or (e.window.event = SDL_WINDOWEVENT_FOCUS_LOST) then begin
      result:= twindowevent.create(ek_leavewindow,winid);
     end else if (e.window.event = SDL_WINDOWEVENT_CLOSE) then begin
      if winid = applicationwindow then begin
       result:= tmseevent.create(ek_terminate);
      end else begin
       result:= twindowevent.create(ek_close,winid);
      end;
     end else if (e.window.event = SDL_WINDOWEVENT_RESIZED) 
      or (e.window.event = SDL_WINDOWEVENT_SIZE_CHANGED) then begin
      SDL_GetWindowSurface(winid);
      postconfigureevent(winid);
      SDL_CheckError('resized');
     end else if (e.window.event = SDL_WINDOWEVENT_EXPOSED) then begin
      gui_getwindowrect(winid,rect1);
      result:= twindowrectevent.create(ek_expose,winid,rect1,nullpoint);
     end else if (e.window.event = SDL_WINDOWEVENT_MOVED) then begin
      postconfigureevent(winid);
     end else if (e.window.event = SDL_WINDOWEVENT_HIDDEN) then begin
      result:= twindowevent.create(ek_hide,winid);
     end else if (e.window.event = SDL_WINDOWEVENT_SHOWN) then begin
      result:= twindowevent.create(ek_show,winid);
     end;
     {if winid = sizingwindow then begin
      inc(eventlooping);
      try
       tapplication1(application).eventloop(true);
      finally
       dec(eventlooping);
      end;
     end;}
     break;
    end;
    SDL_TEXTINPUT: begin
     charbuffer:= charbuffer + pchar(e.text.text);
     result:= tkeyevent.create(e.text.window,false,key_none,key_none,shiftstate,
                                    charbuffer,e.text.timestamp);
     break;
    end; 
    SDL_KEYDOWN : begin
     key1:= SDL_KeyCodeToKey(e.keydown.keysym.sym);
     shiftstate:= SDL_GetShiftState(e.keydown);
     if key1 = key_escape then begin
      escapepressed:= true;
     end;
     result:= tkeyevent.create(SDL_GetWindowFromID(e.keydown.window),false,
       key1,key1,shiftstate,charbuffer,e.keydown.timestamp);
     break;
    end;
    SDL_KEYUP : begin
     key1:= SDL_KeyCodeToKey(e.keydown.keysym.sym);
     shiftstate:= SDL_GetShiftState(e.keydown);
     result:= tkeyevent.create(SDL_GetWindowFromID(e.keydown.window),true,
       key1,key1,shiftstate,charbuffer,e.keydown.timestamp);
     charbuffer:= '';
     break;
    end;
    SDL_MOUSEMOTION: begin
     shiftstate1:= sdlmousetoshiftstate(e.motion.state);
     shiftstate1:= shiftstate1+shiftstate;
     release1:= false;
     result:= tmouseevent.create(SDL_GetWindowFromID(e.motion.window),release1,
      checkbutton(e.motion.state),mw_none,
      makepoint(e.motion.x,e.motion.y),shiftstate1, e.motion.timestamp);
     break;
    end;
    SDL_MOUSEBUTTONDOWN,SDL_MOUSEBUTTONUP: begin
     shiftstate1:= sdlmousetoshiftstate(e.button.state);
     shiftstate1:= shiftstate1+shiftstate;
     if e.type_=SDL_MOUSEBUTTONUP then
      release1:= true
     else
      release1:= false;
     result:= tmouseevent.create(SDL_GetWindowFromID(e.button.window),release1,
      checkbutton(e.button.state),mw_none,
      makepoint(e.button.x,e.button.y),shiftstate1, e.button.timestamp);
     break;
    end;
    SDL_MOUSEWHEEL: begin
     if mousewindow <> 0 then begin
      //e.wheel.x ( - -> left + -> right )
      //e.wheel.y ( - -> up   + -> down )
      pt1:= gui_getpointerpos;
      subpoint1(pt1,getclientrect(mousewindow).pos);
      inc(mousewheelpos,e.wheel.y);
      while mousewheelpos >= wheelstep do begin
       result:= tmouseevent.create(SDL_GetWindowFromID(e.wheel.window),false,mb_none,mw_up,pt1,
              shiftstate,e.wheel.timestamp);
       dec(mousewheelpos,wheelstep);
      end;
      while mousewheelpos <= -wheelstep do begin
       result:= tmouseevent.create(SDL_GetWindowFromID(e.wheel.window),false,mb_none,mw_down,pt1,
              shiftstate,e.wheel.timestamp);
       inc(mousewheelpos,wheelstep);
      end;
     end;
     break;
    end;
   end;
  end;
 end;
end;

function createapphandle(out id: winidty): guierrorty;
var
 str1: string;
begin
 str1:= application.applicationname;
 id:= SDL_CreateWindow(pchar(str1),0,0,1,1,SDL_WINDOWEVENT_HIDDEN);
 if id = 0 then begin
  result:= gue_createwindow;
  SDL_CheckError('createapphandle');
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
 windowstyleex: SDL_WindowFlags;
 rect1: rectty;
 classname: pchar;
 ownerwindow: winidty;
begin
 fillchar(awindow,sizeof(awindow),0);
 with awindow,options do begin
  ownerwindow:= applicationwindow;
  windowstyleex:= SDL_WINDOW_SHOWN;
  if (options * noframewindowtypes <> []) or
    (wo_message in options) then begin
   windowstyleex:= windowstyleex or SDL_WINDOW_BORDERLESS;
  end else begin
   windowstyleex:= windowstyleex or SDL_WINDOW_RESIZABLE;
  end;
  if pos = wp_minimized then begin
   windowstyleex:= windowstyleex or SDL_WINDOW_MINIMIZED;
  end else if pos = wp_maximized then begin
   windowstyleex:= windowstyleex or SDL_WINDOW_MAXIMIZED;
  end else if (pos = wp_fullscreen) or (pos = wp_fullscreenvirt) then begin
   windowstyleex:= windowstyleex or SDL_WINDOW_FULLSCREEN;
  end; 
  if wo_taskbar in options then begin
   SDL_HideWindow(applicationwindow);
   ownerwindow:= 0;
  end;
  result:= gue_createwindow;
  rect1:= rect;

  if not ((transientfor <> 0) or (options * [wo_popup,wo_message,wo_notaskbar] <> [])) then begin
   if parent <> 0 then begin
    classname:= childwidgetclassname;
   end else begin
    classname:= widgetclassname;
   end;
  end;
  id:= SDL_CreateWindow(classname,rect1.x,rect1.y,rect1.cx,rect1.cy,windowstyleex);
  result:= SDL_CheckError('createwindow');
  if (transientfor <> 0) or (options * [wo_popup,wo_message,wo_notaskbar] <> []) then begin
   if transientfor <> 0 then begin
    ownerwindow:= transientfor;
   end;
   if transientfor = 0 then begin
    SDL_SetWindowPosition(id,0,0);
   end;
  end else begin
   if setgroup and (groupleader = 0) or (wo_groupleader in options) then begin
    groupleaderwindow:= id;
   end;
   {if not (pos = wp_default) and (parent = 0) then begin
    result:= gui_reposwindow(id,rect);
   end else begin
    result:= gue_ok;
   end;}
  end;
  if icon <> 0 then begin
   gui_setwindowicon(id,icon,iconmask);
   if (groupleaderwindow = id) then begin
    gui_setwindowicon(applicationwindow,icon,iconmask);
   end;
  end;
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
 debugwriteln('workarea');
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
 SDL_CheckError('Init video');
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
  SDL_CheckError('deinit');
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
