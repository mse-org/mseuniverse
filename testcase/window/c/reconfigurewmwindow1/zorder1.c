#include "unistd.h"
#include <X11/Xlib.h>

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
 attributes.background_pixel = white;
 win2 = XCreateWindow(disp,root,240,240,200,200,0,
      CopyFromParent,CopyFromParent,CopyFromParent,
      valuemask,&attributes);
 attributes.background_pixel = black;
 win3 = XCreateWindow(disp,root,280,280,200,200,0,
      CopyFromParent,CopyFromParent,CopyFromParent,
      valuemask,&attributes);
 XMapWindow(disp,win1);
 XMapWindow(disp,win2);
 XMapWindow(disp,win3);
 XRaiseWindow(disp,win1);
 XRaiseWindow(disp,win2);
 XRaiseWindow(disp,win3);
 while (1) {
  XMoveWindow(disp,win1,200,200);
  XMoveWindow(disp,win2,240,240);
  XMoveWindow(disp,win3,280,280);
  changes.sibling = win3;
  if (i1 & 1) {
   changes.stack_mode = Above;
  }
  else{
   changes.stack_mode = Below;
  };
  i1+= 1;
  XReconfigureWMWindow(disp,win1,defscreen,
                            CWSibling | CWStackMode,&changes);
  XSync(disp,1);
  sleep(1);
 }
 return 0;
}