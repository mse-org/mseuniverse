program staticgravitytest;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype console}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}
 x,xlib,xutil,msetypes,mseguiintf;

const
 xpos1 = 100;
 ypos1 = 100;
 width1 = 200;
 height1 = 100;

var
 id: winidty;
 attributes: txsetwindowattributes;
 changes: txwindowchanges;
 sizehints: pxsizehints;
 int1: integer;
begin
 gui_init;
 with attributes do begin 
  win_gravity:= staticgravity;
  background_pixel:= 0;
 end;
 id:= xcreatewindow(msedisplay,mserootwindow,xpos1,ypos1,width1,height1,0,
            copyfromparent,copyfromparent,pvisual(copyfromparent),
            cwwingravity or cwbackpixel,@attributes);
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
{
 fillchar(changes,sizeof(changes),0);
 with changes do begin
  x:= xpos1;
  y:= ypos1;
  width:= width1;
  height:= height1;
 end;
  
  xconfigurewindow(msedisplay,id,cwx or cwy or cwwidth or cwheight,@changes);
} 
  xmapwindow(msedisplay,id);
  xflush(msedisplay);
  readln;
  xdestroywindow(msedisplay,id);
 end;
end.
