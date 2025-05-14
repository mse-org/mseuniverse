program staticgravitytest_xfwm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype console}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}
 mx,mxlib,mxutil,msetypes,mseguiintf,sysutils,msegraphutils;

const
 xpos1 = 50;
 ypos1 = 50;
 width1 = 200;
 height1 = 100;

var
 id: winidty;
 setattributes: txsetwindowattributes;
 attributes: txwindowattributes;
 sizehints: pxsizehints;
 int1: integer;
 rect1: rectty;
 x1: integer = 0;
 y1: integer = 0;
 w1: integer = 0;
 h1: integer = 0;
 xroot: integer = 0;
 yroot: integer = 0;
 
begin
 gui_init;
 with setattributes do begin 
  win_gravity:= staticgravity;
  background_pixel:= 0;
 end;
 id:= xcreatewindow(msedisplay,gui_getrootwindow(),xpos1,ypos1,width1,height1,0,
            copyfromparent,copyfromparent,pvisual(copyfromparent),
            cwwingravity or cwbackpixel,@setattributes);
 if id <> 0 then begin
  sizehints:= xallocsizehints;
  xgetwmnormalhints(msedisplay,id,sizehints,@int1);
  with sizehints^ do begin
   flags:= flags or pposition or psize or usposition or ussize 
               or pbasesize or pwingravity;
   x:= xpos1;
   y:= ypos1;
   width:= width1;
   height:= height1;
   base_width:= width1;
   base_height:= height1;
   win_gravity:= staticgravity;
  end;
  xsetwmnormalhints(msedisplay,id,sizehints);
  xfree(sizehints);
  xmapwindow(msedisplay,id);
  xflush(msedisplay);
 end;
 repeat
  xgetwindowattributes(msedisplay,id,@attributes);
  gui_getwindowrect(id,rect1);
  with attributes do begin
   if (rect1.x <> xroot) or (rect1.y <> yroot) or
          (x <> x1) or (y <> y1) or (width <> w1) or (height <> h1) then begin
    xroot:= rect1.x;
    yroot:= rect1.y;
    x1:= x;
    y1:= y;
    w1:= width;
    h1:= height;
    writeln('xroot: ',xroot,' yroot: ',yroot,
           ' x: ',x1, ' y: ',y1,' width: ',w1,' height: ',h1);
   end;
  end;
  sleep(100);
 until attributes.map_state <> isviewable;
 xdestroywindow(msedisplay,id);
end.
