#include <unistd.h>
#include <stdio.h>
#include <X11/Xlib.h>

#define inputmask (KeymapStateMask | \
              KeyPressMask | KeyReleaseMask |  \
                       ButtonPressMask | ButtonReleaseMask | \
                       PointerMotionMask | \
              EnterWindowMask | LeaveWindowMask | \
              FocusChangeMask | PropertyChangeMask | \
                       ExposureMask | StructureNotifyMask)

char* geteventname(int event)
{
 switch (event){
  case 2: return "KeyPress";


  case 3: return "KeyRelease";
  case 4: return "ButtonPress";
  case 5: return "ButtonRelease";
  case 6: return "MotionNotify";
  case 7: return "EnterNotify";
  case 8: return "LeaveNotify";
  case 9: return "FocusIn";
  case 10: return "FocusOut";
  case 11: return "KeymapNotify";
  case 12: return "Expose";
  case 13: return "GraphicsExpose";
  case 14: return "NoExpose";
  case 15: return "VisibilityNotify";
  case 16: return "CreateNotify";
  case 17: return "DestroyNotify";
  case 18: return "UnmapNotify";
  case 19: return "MapNotify";
  case 20: return "MapRequest";
  case 21: return "ReparentNotify";
  case 22: return "ConfigureNotify";
  case 23: return "ConfigureRequest";
  case 24: return "GravityNotify";
  case 25: return "ResizeRequest";
  case 26: return "CirculateNotify";
  case 27: return "CirculateRequest";
  case 28: return "PropertyNotify";
  case 29: return "SelectionClear";
  case 30: return "SelectionRequest";
  case 31: return "SelectionNotify";
  case 32: return "ColormapNotify";
  case 33: return "ClientMessage";
  case 34: return "MappingNotify";
  case 35: return "GenericEvent";
  default: return "";
 }
}
                       
int main(){
 Display*             disp;
 int                  defscreen;
 XSetWindowAttributes attributes;
 ulong                valuemask;
 XWindowChanges       changes;
 Window               win1;
 Window               win2;
 Window               win3;
 Window               root;
 ulong     black;
 ulong     white;
 int       i1;
 XEvent    xev;
 
 disp = XOpenDisplay(NULL);
 defscreen = DefaultScreen(disp);
 root = RootWindow(disp,defscreen);
 black = BlackPixel(disp,defscreen);
 white = WhitePixel(disp,defscreen);
 attributes.win_gravity = NorthWestGravity;
 valuemask = CWBackPixel | CWWinGravity;
 attributes.background_pixel = black;
 win1 = XCreateWindow(disp,root,200,200,200,200,0,
      CopyFromParent,CopyFromParent,CopyFromParent,
      valuemask,&attributes);
 XSelectInput(disp,win1,inputmask);

 XMapWindow(disp,win1);
 XSync(disp,1);
 i1 = 0;
 printf("Press any key in test window for terminating\n");
 while (1) {
  XNextEvent(disp,&xev);
  i1++;
  printf("%4i %2i %s\n",i1,xev.type,geteventname(xev.type));
  
  if (xev.type == KeyPress){
   break;
  };
 };
 return 0;
}