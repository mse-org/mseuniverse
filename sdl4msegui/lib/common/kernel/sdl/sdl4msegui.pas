unit sdl4msegui;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,msesystypes,mseguiglob;
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
 PSDL_Rect = ^SDL_Rect;
 
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
 //PSDL_Surface = ^SDL_Surface;
 PSDL_Surface = pixmapty;

 // event
 
 {$I sdl_EventConsts.inc}
 
type
 
 SDL_scancode = 0..SDL_NUM_SCANCODES;

const
 SDL_WINDOWEVENT_NONE = 0;           // Never used */
 SDL_WINDOWEVENT_SHOWN = 1;          // Window has been shown */
 SDL_WINDOWEVENT_HIDDEN = 2;         // Window has been hidden */
 SDL_WINDOWEVENT_EXPOSED = 3;        // Window has been exposed and should be redrawn */
 SDL_WINDOWEVENT_MOVED = 4;          // Window has been moved to data1, data2 
 SDL_WINDOWEVENT_RESIZED = 5;        // Window has been resized to data1xdata2 */
 SDL_WINDOWEVENT_SIZE_CHANGED = 6;   // The window size has changed, either as a result of an API call or through the system or user changing the window size. */
 SDL_WINDOWEVENT_MINIMIZED = 7;      // Window has been minimized */
 SDL_WINDOWEVENT_MAXIMIZED = 8;      // Window has been maximized */
 SDL_WINDOWEVENT_RESTORED = 9;       // Window has been restored to normal size and position */
 SDL_WINDOWEVENT_ENTER = 10;          // Window has gained mouse focus */
 SDL_WINDOWEVENT_LEAVE = 11;          // Window has lost mouse focus */
 SDL_WINDOWEVENT_FOCUS_GAINED = 12;   // Window has gained keyboard focus */
 SDL_WINDOWEVENT_FOCUS_LOST = 13;     // Window has lost keyboard focus */
 SDL_WINDOWEVENT_CLOSE = 14;          // The window manager requests that the window be closed */

 TEXT_SIZE = 32;

type
{*
 *  \brief The SDL keysym structure, used in key events.
 }
  SDL_Keysym = packed record
   scancode: SDL_scancode; //**< SDL physical key code - see ::SDL_Scancode for details */
   sym: integer; //**< SDL virtual key code - see ::SDL_Keycode for details */
   mods: word; //**< current key modifiers */
   unicode: cardinal; //**< \deprecated use SDL_TextInputEvent instead */ 
  end;

{*
 *  \brief Window state change event data (event.window.*)
 }
 SDL_Window_Event = record
  type_: cardinal;
  timestamp: cardinal;
  window: winidty;
  event: byte; //**< ::SDL_WindowEventID */
  padding1: byte;
  padding2: byte;
  Data1: integer;
  Data2: integer;
 end;

{*
 *  \brief Keyboard button event structure (event.key.*)
 *}
 SDL_KeyboardEvent = packed record
  type_: cardinal; //**< ::SDL_KEYDOWN or ::SDL_KEYUP */
  timestamp: cardinal;
  window: winidty;
  state: byte; //**< ::SDL_PRESSED or ::SDL_RELEASED */
  repeat_: byte; //**< Non-zero if this is a key repeat */
  padding2: byte;
  padding3: byte;
  keysym: SDL_Keysym; //**< The key that was pressed or released */       
 end;

{*
 *  \brief Keyboard text editing event structure (event.edit.*)
 }
 SDL_TextEditingEvent = record
  type_: cardinal;
  timestamp: cardinal;
  window: winidty;
  text: array[0..TEXT_SIZE - 1] of AnsiChar; //**< The editing text */
  start: integer; //**< The start cursor of selected editing text */
  length: integer; //**< The length of selected editing text */
 end;

 SDL_TextInputEvent = record
  type_: cardinal;
  timestamp: cardinal;
  window: winidty;
  text: array[0..TEXT_SIZE - 1] of AnsiChar;
 end;

{*
 *  \brief Mouse motion event structure (event.motion.*)
 }
 SDL_MouseMotionEvent = record
   type_: cardinal;
   window: winidty;
   which: byte;
   state: byte;
   pad: word;
   x: integer;
   y: integer;
   z: integer;
   pressure: integer;
   pressure_min: integer;
   pressure_max: integer;
   rotation: integer;
   tilt_x: integer;
   tilt_y: integer;
   cursor: integer;
   xrel: integer;
   yrel: integer;
 end;

{*
 *  \brief Mouse button event structure (event.button.*)
 }
  SDL_MouseButtonEvent = packed record
    type_: cardinal;
    window: winidty;
    which: byte;
    button: byte;
    state: byte;
    pad: byte;
    x: integer;
    y: integer;
  end;

{*
 *  \brief Mouse wheel event structure (event.wheel.*)
 }
  SDL_MouseWheelEvent = packed record
    type_: cardinal;
    window: winidty;
    which: byte;
    pad1: byte;
    pad2: word;
    x: integer;
    y: integer;
  end;

{*
 * \brief Tablet pen proximity event
 }
  SDL_ProximityEvent = packed record
    type_: cardinal;
    window: winidty;
    which: byte;
    pad1: byte;
    pad2: word;
    cursor: integer;
    x: integer;
    y: integer;
  end;

{*
 *  \brief Joystick axis motion event structure (event.jaxis.*)
 }
  SDL_JoyAxisEvent = packed record
    type_: cardinal;
    which: byte;
    axis: byte;
    pad: word;
    value: integer;
  end;

{*
 *  \brief Joystick trackball motion event structure (event.jball.*)
 }
  SDL_JoyBallEvent = packed record
    type_: cardinal;
    which: byte;
    ball: byte;
    pad: word;
    xrel: integer;
    yrel: integer;
  end;

 SDL_HatPosition = set of (sdlhUp, sdlhRight, sdlhDown, sdlhLeft);

{*
 *  \brief Joystick hat position change event structure (event.jhat.*)
 }
  SDL_JoyHatEvent = packed record
    type_: cardinal;
    which: byte;
    hat: byte;
    value: SDL_HatPosition;
    pad: byte;
  end;

{*
 *  \brief Joystick button event structure (event.jbutton.*)
 }
  SDL_JoyButtonEvent = packed record
    type_: cardinal;
    which: byte;
    buton: byte;
    stte: byte;
    pad: byte;
  end;

{*
 *  \brief The "quit requested" event
 }
  SDL_QuitEvent = packed record
    type_: cardinal;
  end;

{*
 *  \brief A user-defined event type (event.user.*)
 }
  SDL_User_Event = packed record
    type_: cardinal;
    windowID: cardinal;
    code: integer;
    data1: pointer;
    data2: pointer;
  end;

{*
 *  \brief A video driver dependent system event (event.syswm.*)
 }
  SDL_SysWM_Event = packed record
     type_: cardinal;
     msg: pointer;
  end;

  SDL_Event = record
    case UInt32 of
      SDL_FIRSTEVENT: (type_: cardinal);
      SDL_QUITEV: (quit: SDL_QuitEvent );
      SDL_WINDOWEVENT: (win: SDL_Window_Event);
      SDL_SYSWMEVENT: (syswin: SDL_SysWM_Event);
      SDL_KEYDOWN, SDL_KEYUP: (key: SDL_KeyboardEvent);
      SDL_TEXTEDITING: (edit: SDL_TextEditingEvent);
      SDL_TEXTINPUT: (input: SDL_TextInputEvent);
      SDL_MOUSEMOTION: (motion: SDL_MouseMotionEvent);
      SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP: (button: SDL_MouseButtonEvent);
      SDL_MOUSEWHEEL: (wheel: SDL_MouseWheelEvent);
      SDL_PROXIMITYIN, SDL_PROXIMITYOUT: (prox: SDL_ProximityEvent);
      SDL_JOYAXISMOTION: (jaxis: SDL_JoyAxisEvent );
      SDL_JOYBALLMOTION: (jball: SDL_JoyBallEvent );
      SDL_JOYHATMOTION: (jhat: SDL_JoyHatEvent );
      SDL_JOYBUTTONDOWN, SDL_JOYBUTTONUP: (jbutton: SDL_JoyButtonEvent );
      SDL_USEREVENT : ( user : SDL_User_Event );
  end;
  PSdlEvent = ^SDL_Event;

  SDL_EventAction = (SdlAddEvent, SdlPeekEvent, SdlGetEvent);

  SDL_EventFilter = function (userdata: pointer; event: PSdlEvent): integer;

  SDL_EventArray = array of SDL_Event; 

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
 procedure SDL_GetWindowPosition(window: winidty; var x, y: integer); cdecl; external SDLLibName;
 procedure SDL_SetWindowPosition(window: winidty; x, y: integer); cdecl; external SDLLibName;
 procedure SDL_GetWindowSize(window: winidty; var w, h: integer); cdecl; external SDLLibName;
 procedure SDL_SetWindowSize(window: winidty; w, h: integer); cdecl; external SDLLibName;
 function SDL_GetWindowFlags(window: winidty): SDL_WindowFlags; cdecl; external SDLLibName;
 procedure SDL_MinimizeWindow(window: winidty); cdecl; external SDLLibName;
 procedure SDL_SetWindowTitle(window: winidty; const title: PChar); cdecl; external SDLLibName;
 procedure SDL_SetWindowIcon(window: winidty; icon: PSDL_Surface); cdecl; external SDLLibName;
 procedure SDL_UpdateWindowSurface(window: winidty); cdecl; external SDLLibName;

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
 PSdlTextureAccess = ^SDL_TextureAccess;
 SDL_TextureAccess = (sdltaStatic, sdltaStreaming, sdltaRenderTarget);
 SDL_BlendMode = (sdlbBlend, sdlbAdd, sdlbMod, sdlbForce32 = 31);
 SDL_BlendModes = set of SDL_BlendMode;

 function SDL_CreateRenderer(window: winidty; index: integer; flags: Cardinal): SDL_Renderer; cdecl; external SDLLibName;
 function SDL_CreateTexture(renderer: SDL_Renderer; format: Cardinal; access,w,h: integer): SDL_Texture; cdecl; external SDLLibName;
 function SDL_GetRenderer(window: winidty): SDL_Renderer; cdecl; external SDLLibName;
 function SDL_CreateSoftwareRenderer(surface: PSDL_Surface): SDL_Renderer; cdecl; external SDLLibName;
 procedure SDL_DestroyRenderer(renderer: SDL_Renderer); cdecl; external SDLLibName;
 function SDL_CreateTextureFromSurface(renderer: SDL_Renderer; surface: PSDL_Surface): SDL_Texture; cdecl; external SDLLibName;
 function SDL_QueryTexture(texture: SDL_Texture; format: PCardinal;
                           access: PSdlTextureAccess; w, h: PInteger): integer; cdecl; external SDLLibName;
 function SDL_SetTextureColorMod(texture: SDL_Texture; r, g, b: Uint8): Integer; cdecl; external SDLLibName;
 function SDL_GetTextureColorMod(texture: SDL_Texture; var r, g, b: Uint8): Integer; cdecl; external SDLLibName;
 function SDL_SetTextureAlphaMod(textureID: SDL_Texture; alpha: byte): integer; cdecl; external SDLLibName;
 function SDL_GetTextureAlphaMod(textureID: SDL_Texture; var alpha: byte): integer; cdecl; external SDLLibName;
 function SDL_GetTextureHandle(texture: SDL_Texture): integer; cdecl; external SDLLibName;
 function SDL_SetTextureBlendMode(texture: SDL_Texture; blendMode: SDL_BlendModes): Integer; cdecl; external SDLLibName;
 function SDL_GetTextureBlendMode(texture: SDL_Texture; var blendMode: SDL_BlendModes): Integer; cdecl; external SDLLibName;
 function SDL_SetRenderDrawColor(renderer: SDL_Renderer; r, g, b, a: byte): integer; cdecl; overload; external SDLLibName;
 function SDL_SetRenderDrawBlendMode(renderer: SDL_Renderer; blendMode: SDL_BlendModes): integer; cdecl; external SDLLibName;
 function SDL_GetRenderDrawBlendMode(renderer: SDL_Renderer; var blendMode: SDL_BlendModes): integer; cdecl; external SDLLibName;
 function SDL_RenderClear(renderer: SDL_Renderer): Integer; cdecl; external SDLLibName;
 function SDL_RenderDrawLine(renderer: SDL_Renderer; x1, y1, x2, y2: integer): integer; cdecl; external SDLLibName;
 function SDL_RenderDrawRect(renderer: SDL_Renderer; const rect: PSDL_Rect): integer; cdecl; external SDLLibName;
 function SDL_RenderFillRect(renderer: SDL_Renderer; const rect: PSDL_Rect): integer; cdecl; external SDLLibName;
 function SDL_RenderDrawPoint(renderer: SDL_Renderer; x: integer; y: integer): integer; cdecl; external SDLLibName;
 function SDL_RenderCopy(renderer: SDL_Renderer; texture: SDL_Texture; const srcrect, dstrect: PSDL_Rect): integer; cdecl; external SDLLibName;
 procedure SDL_RenderPresent(renderer: SDL_Renderer); cdecl; external SDLLibName;
 procedure SDL_DestroyTexture(textureID: SDL_Texture); cdecl; external SDLLibName;


// surface
 function SDL_CreateRGBSurface (flags: cardinal;
                                   width: integer;
                                   height: integer;
                                   depth: integer;
                                   Rmask: Uint32;
                                   Gmask: Uint32;
                                   Bmask: Uint32;
                                   Amask: Uint32): PSDL_Surface; cdecl; external SDLLibName;
 function SDL_CreateRGBSurfaceFrom (pixels: pointer;
                                       width: integer;
                                       height: integer;
                                       depth: integer;
                                       pitch: integer;
                                       Rmask: Uint32;
                                       Gmask: Uint32;
                                       Bmask: Uint32;
                                       Amask: Uint32): PSDL_Surface; cdecl; external SDLLibName;
 function SDL_LoadBMP(filename: PAnsiChar): PSDL_Surface; cdecl; external SDLLibName;
 procedure SDL_FreeSurface(surface: PSDL_Surface); cdecl; external SDLLibName;

// event

 procedure SDL_PumpEvents; cdecl; external SDLLibName;
 function SDL_PeepEvents(events: PSdlEvent; numevents: integer; action: SDL_EventAction;
                        minType, maxType: cardinal): integer; cdecl; external SDLLibName;
 function SDL_GetEvents(minType: cardinal = 0; maxType: cardinal = SDL_LASTEVENT): SDL_EventArray; cdecl; external SDLLibName;
 function SDL_HasEvent(type_: Cardinal): boolean; cdecl; external SDLLibName;
 function SDL_HasEvents(minType, maxType: Cardinal): boolean; cdecl; external SDLLibName;
 procedure SDL_FlushEvent(type_: Cardinal); cdecl; external SDLLibName;
 procedure SDL_FlushEvents(minType, maxType: Cardinal); cdecl; external SDLLibName;
 function SDL_PollEvent(event: PSdlEvent): integer; cdecl; external SDLLibName;
 function SDL_WaitEvent(event: PSdlEvent): integer; cdecl; external SDLLibName;
 function SDL_WaitEventTimeout(event: PSdlEvent; timeout: integer): integer; cdecl; external SDLLibName;
 function SDL_PushEvent(const event: SDL_Event): integer; cdecl; external SDLLibName;
 procedure SDL_SetEventFilter(filter: SDL_EventFilter; userdata: pointer);cdecl; external SDLLibName;
 function SDL_GetEventFilter(out filter: SDL_EventFilter; out userdata: pointer): boolean; cdecl; external SDLLibName;
 procedure SDL_FilterEvents(filter: SDL_EventFilter; userdata: pointer); cdecl; external SDLLibName;
 function SDL_EventState(type_: cardinal; state: integer): byte; cdecl; external SDLLibName;
 function SDL_GetEventState(type_:cardinal): byte;  cdecl; external SDLLibName;
 function SDL_RegisterEvents(numevents: integer): cardinal;  cdecl; external SDLLibName;

//keyboard
 procedure SDL_StartTextInput; cdecl; external SDLLibName;

// timer
type
 TSDL_NewTimerCallback = function( interval: UInt32; param: Pointer ): UInt32; cdecl;

 procedure SDL_Delay(ms: Cardinal); cdecl; external SDLLibName;
 function SDL_AddTimer(interval: UInt32; callback: pointer{TSDL_NewTimerCallback}; param : Pointer): integer; cdecl; external SDLLibName;
 procedure SDL_RemoveTimer(id: integer); cdecl; external SDLLibName;
 function SDL_GetTicks: UInt32; cdecl; external SDLLibName;

// clipboard
 function SDL_SetClipboardText(const text: pchar): integer; cdecl; external SDLLibName;
 function SDL_HasClipboardText: boolean; cdecl; external SDLLibName;
 function SDL_GetClipboardText: pchar; cdecl; external SDLLibName;
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
