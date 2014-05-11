program reconfigurewmwindowtest;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype console}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}
 x,xlib,xutil,msetypes,mseguiintf,msesysintf,msestream,sysutils,msegraphutils;

const
 xpos1 = 100;
 ypos1 = 100;
 width1 = 200;
 height1 = 100;
 xpos2 = 150;
 ypos2 = 150;

var
 id1,id2: winidty;
 gc1,gc2: pxgc;
 attributes: txsetwindowattributes;
 changes: txwindowchanges;
 sizehints: pxsizehints;
 int1: integer;
 by1: byte;
 rect1,rect2: rectty;
 bo1: boolean = false;
begin
 gui_init;
 with attributes do begin 
  win_gravity:= staticgravity;
  background_pixel:= 0;
 end;
 id1:= xcreatewindow(msedisplay,mserootwindow,xpos1,ypos1,width1,height1,0,
            copyfromparent,copyfromparent,pvisual(copyfromparent),
            cwwingravity or cwbackpixel,@attributes);
 id2:= xcreatewindow(msedisplay,mserootwindow,xpos2,ypos2,width1,height1,0,
            copyfromparent,copyfromparent,pvisual(copyfromparent),
            cwwingravity or cwbackpixel,@attributes);
 if (id1 <> 0) and (id2 <> 0) then begin
  sizehints:= xallocsizehints;
  xgetwmnormalhints(msedisplay,id1,sizehints,@int1);
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
  xsetwmnormalhints(msedisplay,id1,sizehints);
  with sizehints^ do begin
   x:= xpos2;
   y:= ypos2;
  end;
  xsetwmnormalhints(msedisplay,id2,sizehints);
  xfree(sizehints);
  xmapwindow(msedisplay,id1);
  xmapwindow(msedisplay,id2);
  setfilenonblock(sys_stdin(),true);
  gc1:= xcreategc(msedisplay,id1,0,nil);
  gc2:= xcreategc(msedisplay,id2,0,nil);
  xsetforeground(msedisplay,gc1,$0000ff);
  xsetforeground(msedisplay,gc2,$00ff00);
  changes.stack_mode:= above;
  repeat
   with rect1 do begin
    if xgetgeometry(msedisplay,id1,@int1,@x,@y,@cx,@cy,
                                                @int1,@int1) <> 0 then begin
     gui_getwindowrect(id1,rect2);
     writeln('win1 rx:',rect2.x,' ry:',rect2.y,' x:',x,' y:',y,' cx:',cx,' cy:',cy);
    end;
    if xgetgeometry(msedisplay,id2,@int1,@x,@y,@cx,@cy,
                                                @int1,@int1) <> 0 then begin
     gui_getwindowrect(id2,rect2);
     writeln('win2 rx:',rect2.x,' ry:',rect2.y,' x:',x,' y:',y,' cx:',cx,' cy:',cy);
    end;
   end;
   if bo1 then begin
    changes.sibling:= id1;
    xreconfigurewmwindow(msedisplay,id2,msedefaultscreenno,
                              cwsibling or cwstackmode,@changes);
   end
   else begin
    changes.sibling:= id2;
    xreconfigurewmwindow(msedisplay,id1,msedefaultscreenno,
                              cwsibling or cwstackmode,@changes);
   end;
   bo1:= not bo1;
   xsync(msedisplay,false);
   xfillrectangle(msedisplay,id1,gc1,0,0,5000,5000);
   xfillrectangle(msedisplay,id2,gc2,0,0,5000,5000);
   xflush(msedisplay);
   sleep(1000);
  until sys_read(sys_stdin(),@by1,1) > 0;
  xdestroywindow(msedisplay,id1);
  xdestroywindow(msedisplay,id2);
  xfreegc(msedisplay,gc1);
  xfreegc(msedisplay,gc2);
 end;
end.
