unit sdl4msegui;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,msesystypes;
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
 procedure SDL_GetWindowPosition(window: winidty; x, y: integer); cdecl; external SDLLibName;
 procedure SDL_SetWindowPosition(window: winidty; x, y: integer); cdecl; external SDLLibName;
 procedure SDL_GetWindowSize(window: winidty; w, h: integer); cdecl; external SDLLibName;
 procedure SDL_SetWindowSize(window: winidty; w, h: integer); cdecl; external SDLLibName;
 function SDL_GetWindowFlags(window: winidty): SDL_WindowFlags; cdecl; external SDLLibName;
 procedure SDL_MinimizeWindow(window: winidty); cdecl; external SDLLibName;
 procedure SDL_SetWindowTitle(window: winidty; const title: PChar); cdecl; external SDLLibName;
 procedure SDL_SetWindowIcon(window: winidty; icon: PSDL_Surface); cdecl; external SDLLibName;

// error 
const
  ERR_MAX_STRLEN = 128;
  ERR_MAX_ARGS = 5;

type
  TArg = record
    case Byte of
      0: (value_ptr: Pointer);
      (* #if 0 means: never
      1 :  ( value_c : Byte );
      *)
      2: (value_i: Integer);
      3: (value_f: double);
      4: (buf: array[0..ERR_MAX_STRLEN - 1] of Byte);
  end;

  PSDL_error = ^TSDL_error;
  TSDL_error = record
    { This is a numeric value corresponding to the current error }
    error: Integer;

    { This is a key used to index into a language hashtable containing
       internationalized versions of the SDL error messages.  If the key
       is not in the hashtable, or no hashtable is available, the key is
       used directly as an error message format string. }
    key: array[0..ERR_MAX_STRLEN - 1] of Byte;

    { These are the arguments for the error functions }
    argc: Integer;
    args: array[0..ERR_MAX_ARGS - 1] of TArg;
  end;

 function SDL_GetError: pchar; cdecl; external SDLLibName;

// thread
 function SDL_CreateMutex: mutexty; cdecl; external SDLLibName;
 procedure SDL_DestroyMutex(varmutex: mutexty); cdecl; external SDLLibName;
 function SDL_mutexP(mutex: mutexty): integer; cdecl; external SDLLibName;
 function SDL_mutexV(mutex: mutexty): integer; cdecl; external SDLLibName;
 function SDL_CreateSemaphore(initial_value: cardinal): semty; cdecl; external SDLLibName;
 function SDL_SemPost(sem: semty): integer; cdecl; external SDLLibName;
 procedure SDL_DestroySemaphore(sem: semty); cdecl; external SDLLibName;
 function SDL_SemWait(sem: semty): integer; cdecl; external SDLLibName;
 function SDL_SemWaitTimeout(sem: semty; ms:cardinal): integer; cdecl; external SDLLibName;
 function SDL_SemValue(sem: semty): cardinal; cdecl; external SDLLibName;
 function SDL_SemTryWait(sem: semty): integer; cdecl; external SDLLibName;
 
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

type
 SDL_Texture = pbyte;
 SDL_Renderer = ptruint;
 
 function SDL_CreateRenderer(window: winidty; index: integer; flags: Cardinal): SDL_Renderer; cdecl; external SDLLibName;
 function SDL_CreateTexture(renderer: SDL_Renderer; format: Cardinal; access,w,h: integer): SDL_Texture; cdecl; external SDLLibName;

//keyboard
 procedure SDL_StartTextInput; cdecl; external SDLLibName;
// timer
 procedure SDL_Delay(ms: Cardinal); cdecl; external SDLLibName;

//file I/O
type
 TStdio = record
   autoclose: Integer;
  // FILE * is only defined in Kylix so we use a simple Pointer
   fp: Pointer;
 end;

 TMem = record
   base: PUInt8;
   here: PUInt8;
   stop: PUInt8;
 end;

 TUnknown = record
   data1: Pointer;
 end;

 // first declare the pointer type
 PSDL_RWops = ^TSDL_RWops;
 // now the pointer to function types
 TSeek = function( context: PSDL_RWops; offset: Integer; whence: Integer ): Integer; cdecl;
 TRead = function( context: PSDL_RWops; Ptr: Pointer; size: Integer; maxnum : Integer ): Integer;  cdecl;
 TWrite = function( context: PSDL_RWops; Ptr: Pointer; size: Integer; num: Integer ): Integer; cdecl;
 TClose = function( context: PSDL_RWops ): Integer; cdecl;
 // the variant record itself
 TSDL_RWops = record
   seek: TSeek;
   read: TRead;
   write: TWrite;
   close: TClose;
   // a keyword as name is not allowed
   type_: UInt32;
   // be warned! structure alignment may arise at this point
   case Integer of
     0: (stdio: TStdio);
     1: (mem: TMem);
     2: (unknown: TUnknown);
 end;

 SDL_RWops = TSDL_RWops;

 function SDL_RWFromFile(filename, mode: PAnsiChar): PSDL_RWops; cdecl; external SDLLibName;
 procedure SDL_FreeRW(area: PSDL_RWops); cdecl; external SDLLibName;
 function SDL_RWFromFP(fp: Pointer; autoclose: Integer): PSDL_RWops; cdecl; external SDLLibName;
 function SDL_RWFromMem(mem: Pointer; size: Integer): PSDL_RWops; cdecl; external SDLLibName;
 function SDL_RWFromConstMem(const mem: Pointer; size: Integer) : PSDL_RWops; cdecl; external SDLLibName;
 function SDL_AllocRW: PSDL_RWops; cdecl; external SDLLibName;
 function SDL_RWSeek(context: PSDL_RWops; offset: Integer; whence: Integer) : Integer; cdecl; external SDLLibName;
 function SDL_RWTell(context: PSDL_RWops): Integer; cdecl; external SDLLibName;
 function SDL_RWRead(context: PSDL_RWops; ptr: Pointer; size: Integer; n : Integer): Integer; cdecl; external SDLLibName;
 function SDL_RWWrite(context: PSDL_RWops; ptr: Pointer; size: Integer; n : Integer): Integer; cdecl; external SDLLibName;
 function SDL_RWClose(context: PSDL_RWops): Integer; cdecl; external SDLLibName;

implementation
end.
