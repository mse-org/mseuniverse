unit sdl4msegui;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes;
{$i sdl2_types.inc}

// base function

const
  SDL_INIT_TIMER = $00000001;
  SDL_INIT_AUDIO = $00000010;
  SDL_INIT_VIDEO = $00000020;
  SDL_INIT_CDROM = $00000100;
  SDL_INIT_JOYSTICK = $00000200;
  SDL_INIT_NOPARACHUTE = $00100000;
  SDL_INIT_EVENTTHREAD = $01000000;
  SDL_INIT_EVERYTHING = $0000FFFF;

type
 SDL_Rect = record
  x,y: integer;
  w,h: integer;
 end;

 SDL_Color = record
  r: byte;
  g: byte;
  b: byte;
  unused: byte;
 end;
 PSDL_Color = ^SDL_Color;

 SDL_Palette = record
  ncolors: integer;
  colors: PSDL_Color;
  version: Cardinal;
  refcount: integer;
 end;
 PSDL_Palette = ^SDL_Palette;

 PSDL_PixelFormat = ^SDL_PixelFormat;
 SDL_PixelFormat = record
  format: Cardinal;
  palette: PSDL_Palette;
  BitsPerPixel: byte;
  BytesPerPixel: byte;
  padding: word;
  Rmask, Gmask, Bmask, Amask: Cardinal;
  Rloss, Gloss, Bloss, Aloss: byte;
  Rshift, Gshift, Bshift, Ashift: byte;
  refcount: integer;
  next: PSDL_PixelFormat;
 end;

 SDL_Surface = record
  flags: Cardinal; // Read-only
  format: PSDL_PixelFormat; // Read-only
  w, h: Integer; // Read-only
  pitch: integer; // Read-only
  pixels: Pointer; // Read-write
  offset: Integer; // Private
  hwdata: Pointer; //TPrivate_hwdata;  Hardware-specific surface info
  // clipping information:
  clip_rect: SDL_Rect; // Read-only
  unused1: Cardinal; // for binary compatibility
  // Allow recursive locks
  locked: Cardinal; // Private
  // info for fast blit mapping to other surfaces
  Blitmap: Pointer; // PSDL_BlitMap; //   Private
  // format version, bumped at every change to invalidate blit maps
  format_version: Cardinal; // Private
  refcount: Integer;
 end;
 PSDL_Surface = ^SDL_Surface;

 function SDL_Init( flags : Cardinal ) : Integer; cdecl; external SDLLibName;
 procedure SDL_Quit; cdecl; external SDLLibName;

// window management

{
 SDL_WINDOW_FULLSCREEN = $00000001;         //**< fullscreen window; implies borderless */
 SDL_WINDOW_OPENGL = $00000002;             //**< window usable with OpenGL context */
 SDL_WINDOW_SHOWN = $00000004;              //**< window is visible */
 SDL_WINDOW_HIDDEN = 0x00000008,            //**< window is not visible */
 SDL_WINDOW_BORDERLESS = $00000008;         //**< no window decoration */
 SDL_WINDOW_RESIZABLE = $00000010;          //**< window can be resized */
 SDL_WINDOW_MINIMIZED = $00000020;          //**< minimized */
 SDL_WINDOW_MAXIMIZED = $00000040;          //**< maximized */
 SDL_WINDOW_INPUT_GRABBED = $00000100;      //**< window has grabbed input focus */
 SDL_WINDOW_INPUT_FOCUS = $00000200;        //**< window has input focus */
 SDL_WINDOW_MOUSE_FOCUS = $00000400;        //**< window has mouse focus */
 SDL_WINDOW_FOREIGN = $00000800;             //**< window not created by SDL */
}
type
 SDL_WindowFlags = set of ( SDL_WINDOW_FULLSCREEN, // = $00000001,
                     SDL_WINDOW_OPENGL, // = $00000002,
                     SDL_WINDOW_SHOWN, // = $00000004,
                     SDL_WINDOW_HIDDEN, // = $00000008,
                     SDL_WINDOW_BORDERLESS, // = $00000008,
                     SDL_WINDOW_RESIZABLE, // = $00000010,
                     SDL_WINDOW_MINIMIZED, // = $00000020,
                     SDL_WINDOW_MAXIMIZED, // = $00000040,
                     SDL_WINDOW_INPUT_GRABBED, // = $00000100,
                     SDL_WINDOW_INPUT_FOCUS, // = $00000200,
                     SDL_WINDOW_MOUSE_FOCUS, // = $00000400,
                     SDL_WINDOW_FOREIGN); // = $00000800);


 function SDL_CreateWindow(title: PChar; x, y, w, h: integer; flags: SDL_WindowFlags): winidty; 
   cdecl; external SDLLibName;
 procedure SDL_DestroyWindow(window: winidty); cdecl; external SDLLibName;
 procedure SDL_ShowWindow(window: winidty); cdecl; external SDLLibName;
 procedure SDL_HideWindow(window: winidty); cdecl; external SDLLibName;
 procedure SDL_RaiseWindow(window: winidty); cdecl; external SDLLibName;
 procedure SDL_SetWindowPosition(window: winidty; x, y: integer); cdecl; external SDLLibName;
 procedure SDL_SetWindowSize(window: winidty; w, h: integer); cdecl; external SDLLibName;
 function SDL_GetWindowFlags(window: winidty): SDL_WindowFlags; cdecl; external SDLLibName;
 procedure SDL_MinimizeWindow(window: winidty); cdecl; external SDLLibName;
 procedure SDL_SetWindowTitle(window: winidty; const title: PChar); cdecl; external SDLLibName;
 procedure SDL_SetWindowIcon(window: winidty; icon: PSDL_Surface); cdecl; external SDLLibName;

// mouse
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

type
 SDL_Cursor = ptruint;

 function SDL_GetMouseState(x,y: integer): byte; cdecl; external SDLLibName;
 function SDL_GetRelativeMouseState(x,y: integer): byte; cdecl; external SDLLibName;
 procedure SDL_WarpMouseInWindow(window: winidty; x, y: integer); cdecl; external SDLLibName;
 function SDL_CreateCursor(const data: pbyte; const Umask: pbyte; w,h,hot_x,hot_y: integer): SDL_Cursor; cdecl; external SDLLibName;
 procedure SDL_SetCursor(cursor: SDL_Cursor); cdecl; external SDLLibName;

// 2D renderer
const
 SDL_RENDERER_SOFTWARE = $00000001;         //**< The renderer is a software fallback */ 
 SDL_RENDERER_ACCELERATED = $00000002;      //**< The renderer uses hardware 
                                            //      acceleration */
 SDL_RENDERER_PRESENTVSYNC = $00000004;     //**< Present is synchronized 
                                            //      with the refresh rate */
 SDL_RENDERER_TARGETTEXTURE = $00000008;     //**< The renderer supports

 function SDL_CreateRenderer(window: winidty; index: integer; flags: Cardinal): ptruint; cdecl; external SDLLibName;

// timer
 procedure SDL_Delay(ms: Cardinal); cdecl; external SDLLibName;

implementation
end.
