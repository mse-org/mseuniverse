unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar,
 msetypes,msestatfile,msedataedits,mseedit,msestrings,msechartedit,msegrids,
 msewidgetgrid,msedispwidgets,mserichstring,msebitmap,msecolordialog;

type
 tmainfo = class(tmainform)
   di: tpaintbox;
   smoothed: tbooleanedit;
   tstatfile1: tstatfile;
   liwied: tintegeredit;
   caped: tenumtypeedit;
   joined: tenumtypeedit;
   pointsdi: tpaintbox;
   pointsed: txychartedit;
   grid: twidgetgrid;
   xpointed: tintegeredit;
   ypointed: tintegeredit;
   dashesed: thexstringedit;
   closeded: tbooleanedit;
   tandisp: trealdisp;
   sindisp: trealdisp;
   cosdisp: trealdisp;
   bru: tbitmapcomp;
   brushed: tbooleanedit;
   monoed: tbooleanedit;
   backgrounded: tcoloredit;
   foregrounded: tcoloredit;
   brumono: tbitmapcomp;
   yoffs: tintegeredit;
   xoffs: tintegeredit;
   procedure datent(const sender: TObject);
   procedure paintexe(const sender: twidget; const acanvas: tcanvas);
   procedure initcapexe(const sender: tenumtypeedit);
   procedure initjoinexe(const sender: tenumtypeedit);
   procedure pointsdatentexe(const sender: TObject);
   procedure pointeddatentexe(const sender: TObject);
   procedure rowcochaexe(const sender: tcustomgrid; const acell: gridcoordty);
   procedure pintspaexe(const sender: twidget; const acanvas: tcanvas);
  private
   procedure gridtochart;
   procedure charttogrid;
   procedure setupcanvas(const acanvas: tcanvas);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.datent(const sender: TObject);
begin
 di.invalidate;
 pointsdi.invalidate;
end;

procedure tmainfo.setupcanvas(const acanvas: tcanvas);
var
 co1: colorty;
begin
 if brushed.value then begin
  if monoed.value then begin
   brumono.bitmap.colorforeground:= foregrounded.value;
   brumono.bitmap.colorbackground:= backgrounded.value;
   acanvas.brush:= brumono.bitmap;
  end
  else begin
   acanvas.brush:= bru.bitmap;
  end;
  acanvas.brushorigin:= mp(xoffs.value,yoffs.value);
  co1:= cl_black;
  if brushed.value then begin
   co1:= cl_brush;
  end;
  acanvas.color:= co1;
 end
 else begin
  acanvas.color:= cl_black;
 end;
 acanvas.smooth:= smoothed.value;
 acanvas.linewidth:= liwied.value; 
 acanvas.capstyle:= capstylety(caped.value);
 acanvas.joinstyle:= joinstylety(joined.value);
 acanvas.dashes:= dashesed.value;
end;

procedure tmainfo.paintexe(const sender: twidget; const acanvas: tcanvas);
 procedure drawmarker;
 var
  offs: integer;
 begin
  offs:= liwied.value;
  if offs = 0 then begin
   offs:= 1;
  end;
  offs:= (offs+1) div 2 + 3;
  acanvas.save;
  acanvas.smooth:= false;
  acanvas.capstyle:= cs_butt;
  acanvas.linewidth:= 0;
  acanvas.dashes:= '';
  acanvas.drawline(mp(20,20),mp(10,20));
  acanvas.drawline(mp(20,20),mp(20,10));
  acanvas.drawline(mp(30,20-offs),mp(30,15-offs));
  acanvas.drawline(mp(55,20-offs),mp(55,15-offs));
  acanvas.drawline(mp(20-offs,30),mp(15-offs,30));
  acanvas.drawline(mp(20-offs,55),mp(15-offs,55));
  acanvas.move(mp(0,60));
  acanvas.drawline(mp(20-offs,20),mp(15-offs,20));
  acanvas.drawline(mp(20,20-offs),mp(20,15-offs));
  acanvas.drawline(mp(50+offs,20),mp(55+offs,20));
  acanvas.drawline(mp(50,20-offs),mp(50,15-offs));
  acanvas.drawline(mp(20-offs,60),mp(15-offs,60));
  acanvas.drawline(mp(20,60+offs),mp(20,65+offs));
  acanvas.drawline(mp(50+offs,60),mp(55+offs,60));
  acanvas.drawline(mp(50,60+offs),mp(50,65+offs));
  acanvas.restore;
 end;
 
begin
 acanvas.color:= cl_black;
 drawmarker;
 setupcanvas(acanvas);
 acanvas.drawline(mp(30,20),mp(55,20));
 acanvas.drawline(mp(20,30),mp(20,55));
 acanvas.drawlines([mp(20,80),mp(50,80),mp(50,120),mp(20,120)]);
 acanvas.move(mp(60,0));
 acanvas.color:= cl_black;
 drawmarker;
 setupcanvas(acanvas);
 acanvas.drawline(mp(55,20),mp(30,20));
 acanvas.drawline(mp(20,55),mp(20,30));
 acanvas.drawlines([mp(20,120),mp(50,120),mp(50,80),mp(20,80)]);
end;

procedure tmainfo.initcapexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(capstylety);
end;

procedure tmainfo.initjoinexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(joinstylety);
end;

procedure tmainfo.pointsdatentexe(const sender: TObject);
begin
 charttogrid;
end;

procedure tmainfo.pointeddatentexe(const sender: TObject);
begin
 gridtochart;
end;

procedure tmainfo.rowcochaexe(const sender: tcustomgrid;
               const acell: gridcoordty);
begin
 gridtochart;
end;

procedure tmainfo.gridtochart;
var
 ar1: complexarty;
 px,py: pinteger;
 w,h: integer;
 int1: integer;
begin
 w:= pointsed.clientwidth;
 h:= pointsed.clientheight;
 px:= xpointed.griddata.datapo;
 py:= ypointed.griddata.datapo;
 setlength(ar1,grid.rowcount);
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   re:= px[int1]/w;
   im:= py[int1]/h;
  end;
 end;
 pointsdi.invalidate;
end;

procedure tmainfo.charttogrid;
var
 ar1: complexarty;
 ar2,ar3: integerarty;
 w,h: integer;
 int1: integer;
begin
 w:= pointsed.clientwidth;
 h:= pointsed.clientheight;
 ar1:= pointsed.traces[0].xydata;
 setlength(ar2,length(ar1));
 setlength(ar3,length(ar1));
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   ar2[int1]:= round(re * w);
   ar3[int1]:= round(im * h);
  end;
 end;
 xpointed.gridvalues:= ar2;
 ypointed.gridvalues:= ar3;
 pointsdi.invalidate;
end;

procedure tmainfo.pintspaexe(const sender: twidget; const acanvas: tcanvas);
var
 px,py: pinteger;
 ar1: pointarty;
 int1: integer;
 h: integer;
 dxa,dya,dxb,dyb: integer;
 rea1,rea2,wa,wb: real;
begin
 setupcanvas(acanvas);
 px:= xpointed.griddata.datapo;
 py:= ypointed.griddata.datapo;
 h:= pointsed.clientheight;
 setlength(ar1,grid.rowcount);
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   x:= round(px[int1]);
   y:= h-round(py[int1]);
  end;
 end;
 acanvas.drawlines(ar1,closeded.value);
 if length(ar1) >= 3 then begin
  dxa:= ar1[0].x-ar1[1].x;
  dya:= ar1[0].y-ar1[1].y;
  dxb:= ar1[2].x-ar1[1].x;
  dyb:= ar1[2].y-ar1[1].y;
  rea1:= -(dxa*dyb - dxb*dya);
  rea2:= (dxa*dxb + dya*dyb);
  if rea2 <> 0 then begin
   tandisp.value:= rea1/rea2;
  end
  else begin
   tandisp.clear;
  end;
  wa:= sqrt(dxa*dxa+dya*dya);  
  wb:= sqrt(dxb*dxb+dyb*dyb);
  rea1:= -(dxa*dyb - dxb*dya);
  rea2:= (wa*wb);
  if rea2 <> 0 then begin
   sindisp.value:= rea1/rea2;
   cosdisp.value:= (dxa*dxb + dya*dyb)/rea2;
  end
  else begin
   sindisp.clear;
   cosdisp.clear;
  end;
 end
 else begin
  tandisp.clear;
  sindisp.clear;
  cosdisp.clear;
 end;
end;

end.
