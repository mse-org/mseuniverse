unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msewidgetgrid,msechartedit,msebitmap,msestatfile,
 msecolordialog,msegraphedits,msescrollbar;

type
 tmainfo = class(tmainform)
   di: tpaintbox;
   grid: twidgetgrid;
   xpointed: tintegeredit;
   ypointed: tintegeredit;
   pointsed: txychartedit;
   brumono: tbitmapcomp;
   bru: tbitmapcomp;
   tstatfile1: tstatfile;
   dashesed: thexstringedit;
   joined: tenumtypeedit;
   caped: tenumtypeedit;
   liwied: tintegeredit;
   backgrounded: tcoloredit;
   yoffs: tintegeredit;
   smoothed: tbooleanedit;
   brushed: tbooleanedit;
   monoed: tbooleanedit;
   xoffs: tintegeredit;
   foregrounded: tcoloredit;
   procedure datentexe(const sender: TObject);
   procedure pointsdatentexe(const sender: TObject);
   procedure pointeddatentexe(const sender: TObject);
   procedure paintexe(const sender: twidget; const acanvas: tcanvas);
   procedure initcapexe(const sender: tenumtypeedit);
   procedure initjoinexe(const sender: tenumtypeedit);
  protected
   procedure gridtochart;
   procedure charttogrid;
   procedure setupcanvas(const acanvas: tcanvas);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.initcapexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(capstylety);
end;

procedure tmainfo.initjoinexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(joinstylety);
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

procedure tmainfo.datentexe(const sender: TObject);
begin
 di.invalidate;
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
 di.invalidate;
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
 di.invalidate;
end;

procedure tmainfo.pointsdatentexe(const sender: TObject);
begin
 charttogrid;
end;

procedure tmainfo.pointeddatentexe(const sender: TObject);
begin
 gridtochart;
end;

procedure tmainfo.paintexe(const sender: twidget; const acanvas: tcanvas);
var
 px,py: pinteger;
 ar1: pointarty;
 int1: integer;
 h: integer;
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
 if length(ar1) >= 2 then begin
  acanvas.drawellipse(mr(ar1[0].x,ar1[0].y,ar1[1].x-ar1[0].x,
                       ar1[1].y-ar1[0].y));
 end;
end;

end.
