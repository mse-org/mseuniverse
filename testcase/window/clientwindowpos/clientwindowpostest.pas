program clientwindowpostest;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype console}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}
 mx,mxlib,mxutil,msetypes,mseguiintf,msesysintf,msestream,sysutils,msegraphutils;

const
 xpos1 = 100;
 ypos1 = 100;
 width1 = 200;
 height1 = 100;

var
 id: winidty;
 gc: pxgc;
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
 id:= xcreatewindow(msedisplay,gui_getrootwindow(),xpos1,ypos1,width1,height1,0,
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
  xmapwindow(msedisplay,id);
  setfilenonblock(sys_stdin(),true);
  gc:= xcreategc(msedisplay,id,0,nil);
  repeat
   with rect1 do begin
    if xgetgeometry(msedisplay,id,@int1,@x,@y,@cx,@cy,
                                                @int1,@int1) <> 0 then begin
     gui_getwindowrect(id,rect2);
     writeln('rx:',rect2.x,' ry:',rect2.y,' x:',x,' y:',y,' cx:',cx,' cy:',cy);
    end;
   end;
   if bo1 then begin
    xsetforeground(msedisplay,gc,$0000ff);
   end
   else begin
    xsetforeground(msedisplay,gc,$00ff00);
   end;
   xfillrectangle(msedisplay,id,gc,0,0,5000,5000);
   bo1:= not bo1;
   xflush(msedisplay);   
   sleep(1000);
  until sys_read(sys_stdin(),@by1,1) > 0;
  xdestroywindow(msedisplay,id);
  xfreegc(msedisplay,gc);
 end;
end.
