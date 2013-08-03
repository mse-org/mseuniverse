unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msewidgetgrid,msegraphedits,msescrollbar,msestatfile,
 msesplitter,msechartedit,msebitmap;

type
 tmainfo = class(tmainform)
   grid: twidgetgrid;
   smoothed: tbooleanedit;
   tstatfile1: tstatfile;
   tsimplewidget1: tsimplewidget;
   tridisp: tpaintbox;
   tsplitter1: tsplitter;
   polydisp: tpaintbox;
   tsplitter2: tsplitter;
   charted: txychartedit;
   yed: trealedit;
   xed: trealedit;
   procedure datentexe(const sender: TObject);
   procedure paintexe(const sender: twidget; const acanvas: tcanvas);
   procedure tripaintexe(const sender: twidget; const acanvas: tcanvas);
   procedure setpointexe(const sender: TObject; var avalue: complexarty;
                   var accept: Boolean);
   procedure layoutexe(const sender: TObject);
  private
   procedure invalidisp;
   function polyvalues: pointarty;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msearrayutils,msenoise;

procedure tmainfo.invalidisp;
begin
 polydisp.invalidate;
 tridisp.invalidate;
end;
 
procedure tmainfo.datentexe(const sender: TObject);
begin
 invalidisp;
 with charted.traces[0] do begin
  xdata:= xed.gridvalues;
  ydata:= yed.gridvalues;
 end;
end;

procedure tmainfo.paintexe(const sender: twidget; const acanvas: tcanvas);
var
 ar1: pointarty;
begin
 ar1:= polyvalues;
 acanvas.smooth:= smoothed.value;
 acanvas.fillpolygon(ar1,cl_blue);
end;

function compareymin(const l,r): integer;
var
 lmin,rmin: integer;
 int1: integer;
begin
 lmin:= ppointty(l)^.y;
 int1:= (ppointty(l)+1)^.y;
 if int1 < lmin then begin
  int1:= lmin;
 end;
 rmin:= ppointty(r)^.y;
 int1:= (ppointty(r)+1)^.y;
 if int1 < rmin then begin
  int1:= rmin;
 end;
 result:= lmin - rmin;
end;

function compareymax(const l,r): integer;
var
 lmax,rmax: integer;
 int1: integer;
begin
 lmax:= ppointty(l)^.y;
 int1:= (ppointty(l)+1)^.y;
 if int1 > lmax then begin
  int1:= lmax;
 end;
 rmax:= ppointty(r)^.y;
 int1:= (ppointty(r)+1)^.y;
 if int1 > rmax then begin
  int1:= rmax;
 end;
 result:= lmax - rmax;
end;

function comparey(const l,r): integer;
begin
 result:= ppointty(l)^.y - ppointty(r)^.y;
 if result = 0 then begin
  result:= @l-@r;
 end;
end;

type
 trapnodekindty = (tnk_y,tnk_x,tnk_trap);

 ptrapinfoty = ^trapinfoty;
 pseginfoty = ^seginfoty;
 ptrapnodeinfoty = ^trapnodeinfoty;

 trapinfoty = record
  next: ptrapinfoty; //for deleted list
  top,bottom: ppointty;  
  left,right: pseginfoty;
  node: ptrapnodeinfoty;
 end;
 
 segflagty = (sf_pointhandled);
 segflagsty = set of segflagty;
 ppseginfoty = ^pseginfoty;
 seginfoty = record
  flags: segflagsty;
  b: ppointty; //a is in previous segment
  dx,dy: integer; //a-b
 end;
 
 trapnodeinfoty = record
  p,l,r: ptrapnodeinfoty; //parent,left,right
  case kind: trapnodekindty of
   tnk_y: (y: ppointty);
   tnk_x: (seg: pseginfoty);
   tnk_trap: (trap: ptrapinfoty);
 end;
 
procedure tmainfo.tripaintexe(const sender: twidget; const acanvas: tcanvas);
// x,y range = $7fff..-$8000 (16 bit X11 space)
var
 buffer: pointer;
 segments: pseginfoty;
 shuffle: ppseginfoty;
 points: ppointty; 
 npoints: integer;
 traps: ptrapinfoty;
 nodes: ptrapnodeinfoty;
 deltraps,newtraps: ptrapinfoty;
 newnodes: ptrapnodeinfoty;

 function cmpy(const l,r: ppointty): integer;
 begin
  result:= l^.y - r^.y;
  if result = 0 then begin
   result:= l - r;
  end;
 end;

 function cmpx(const l: pseginfoty; r: ppointty): integer;
  //<0 -> r = right of segment
 begin
  if l^.dy = 0 then begin
   result:= (l^.b^.y - r^.y) * l^.dx; //dx = 1|-1
  end
  else begin
   result:= (l^.b^.x + (r^.y-l^.b^.y)*l^.dx div l^.dy) - r^.x;
  end;
 end;

 function newtrap: ptrapinfoty;
 begin
  if deltraps = nil then begin
   result:= newtraps;
   inc(newtraps);
  end
  else begin
   result:= deltraps;
   deltraps:= result^.next;
  end;
 end;
 
 function newnode: ptrapnodeinfoty;
 begin
  result:= newnodes;
  inc(newnodes);
 end;

 function findtrap(const apoint: ppointty): ptrapinfoty;
 var
  no1,no2: ptrapnodeinfoty;
 begin
  no1:= nodes;
  while true do begin
   no2:= no1^.l;
   case no1^.kind of
    tnk_trap: begin
     result:= no1^.trap;
     break;
    end;
    tnk_y: begin
     if cmpy(no1^.y,apoint) < 0 then begin
      no2:= no1^.r;
     end;
    end;
    tnk_x: begin
     if cmpx(no1^.seg,apoint) < 0 then begin
      no2:= no1^.r;
     end;
    end;
   end;
   no1:= no2;
  end;
 end;
   
 procedure handlepoint(const apoint: ppointty);
 var
  tpl,tpr: ptrapinfoty;
  no1,nol,nor: ptrapnodeinfoty;
 begin
  tpl:= findtrap(apoint);
  tpr:= newtrap;            //split trap, lower
  tpr^.top:= apoint;
  tpr^.bottom:= tpl^.bottom;
  tpl^.bottom:= apoint;    //upper
  tpr^.left:= tpl^.left;   //same segmet
  tpr^.right:= tpl^.right; //same segment
  
  no1:= tpl^.node;         //old leaf
  nol:= newnode;
  nor:= newnode;
  no1^.l:= nol;
  no1^.r:= nor;
  no1^.kind:= tnk_y;
  no1^.y:= apoint;
  
  nol^.kind:= tnk_trap;
  nol^.trap:= tpl;
  tpl^.node:= nol;

  nor^.kind:= tnk_trap;
  nor^.trap:= tpr;
  tpr^.node:= nor;
 end;
 
 procedure handlesegment(b: ppointty);
 var
  a: ppointty;
  pt1: ppointty;
 begin
  a:= b-1;
  if a < points then begin
   inc(a,npoints);
  end;
  if cmpy(a,b) > 0 then begin //swap
   pt1:= a;
   b:= a;
   a:= pt1;
  end;
  //a top, b bottom
  
 end;

var
 ar1: pointarty;
 int1,int2: integer;
 seg1,seg2: pseginfoty;
 sizetraps,sizenodes: integer;
 ppt1,ppt2: ppointty;
  
begin
 if grid.rowcount > 1 then begin
  ar1:= polyvalues;
  npoints:= length(ar1);
  points:= pointer(ar1);
 
   //todo: check maximal buffer size
  sizetraps:= 2*npoints*sizeof(trapinfoty);
  sizenodes:= 4*npoints*sizeof(trapnodeinfoty);
  getmem(buffer,npoints*(sizeof(seginfoty)+sizeof(pseginfoty)) + 
                                                sizetraps + sizenodes);
  segments:= buffer;
  shuffle:= pointer(segments+npoints);
  traps:= pointer(shuffle+npoints);
  nodes:= pointer(traps)+sizetraps;
  ppt1:= points;
  ppt2:= points+npoints-1;
  seg1:= segments;
  seg2:= seg1 + npoints;
  for int1:= npoints-1 downto 0 do begin //init segments
   shuffle[int1]:= seg1;
   with seg1^ do begin
    b:= ppt1;
    dx:= ppt2^.x-ppt1^.x; //b->a slope
    dy:= ppt2^.y-ppt1^.y; //b->a slope
    if dy = 0 then begin
     if ppt2 < ppt2 then begin
      dx:= -1;
     end
     else begin
      dx:= 1;
     end;
    end;
    flags:= [];
    inc(seg1);
    ppt2:= ppt1;
    inc(ppt1);
   end;
  end;
  for int1:= npoints-1 downto 0 do begin //shuffle segments
   int2:= mwcnoise mod npoints;
   seg1:= shuffle[int1];
   shuffle[int2]:= shuffle[int1];
   shuffle[int1]:= seg1;
  end;
  
  with nodes^ do begin //init root node
   kind:= tnk_trap;
   trap:= traps;
  end;

  with traps^ do begin //init trap plane
   node:= nodes;
   left:= nil;
   right:= nil;
   top:= nil;
   bottom:= nil;
  end;

  deltraps:= nil;      //init trap memory source
  newtraps:= traps+1;
  newnodes:= nodes+1;
  
  for int1:= npoints-1 downto 0 do begin
   seg1:= shuffle[int1];
   seg2:= seg1-1;
   if seg1 < segments then begin
    inc(seg2,npoints);
   end;
   if not (sf_pointhandled in seg2^.flags) then begin
    handlepoint(seg2^.b);
    include(seg2^.flags,sf_pointhandled);
   end;
   if not (sf_pointhandled in seg1^.flags) then begin
    handlepoint(seg1^.b);
    include(seg1^.flags,sf_pointhandled);
   end;
   handlesegment(seg1^.b);
  end;

  freemem(buffer);
 end;  
end;

procedure tmainfo.setpointexe(const sender: TObject; var avalue: complexarty;
               var accept: Boolean);
begin
 xed.griddata.assignre(avalue);  
 yed.griddata.assignim(avalue);
 invalidisp;
end;

function tmainfo.polyvalues: pointarty;
var
 int1: integer;
 fx,fy: real;
begin
 fx:= charted.width;
 fy:= charted.height;
 setlength(result,grid.rowcount);
 for int1:= 0 to high(result) do begin
  with result[int1] do begin
   x:= round(xed[int1]*fx);
   y:= round(yed[int1]*fy);
  end;
 end;
end;

procedure tmainfo.layoutexe(const sender: TObject);
begin
 invalidisp;
end;

end.
