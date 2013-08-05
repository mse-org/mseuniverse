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
 trapdispinfoty = array[0..3] of pointty;
 
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
   tbutton1: tbutton;
   procedure datentexe(const sender: TObject);
   procedure paintexe(const sender: twidget; const acanvas: tcanvas);
   procedure setpointexe(const sender: TObject; var avalue: complexarty;
                   var accept: Boolean);
   procedure layoutexe(const sender: TObject);
   procedure triangexe(const sender: TObject);
   procedure tripaexe(const sender: twidget; const acanvas: tcanvas);
  private
   ftraps: array of trapdispinfoty;
   procedure invalidisp;
   function polyvalues: pointarty;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msearrayutils,msenoise,mseformatstr,sysutils;

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
  above,below,belowr: ptrapinfoty; //below = single or left
 end;
 
 segflagty = (sf_pointhandled,sf_reverse); //sf_reverse -> b below a
 segflagsty = set of segflagty;
 ppseginfoty = ^pseginfoty;
 seginfoty = record
  flags: segflagsty;
  b: ppointty;        //a is in previous segment
  dx,dy: integer;     //a-b
  trap: ptrapinfoty;  //inserted trap for b
                           //or left trap after horizontal split
  rtrap: ptrapinfoty;  //right trap for b after horizontal split
 end;
 
 trapnodeinfoty = record
  p,l,r: ptrapnodeinfoty; //parent,left,right
  case kind: trapnodekindty of
   tnk_y: (y: ppointty);
   tnk_x: (seg: pseginfoty);
   tnk_trap: (trap: ptrapinfoty);
 end;

function calcx(const y: integer; const seg: seginfoty): integer;
var
 int1: integer;
begin
 with seg do begin
  if dy = 0 then begin
   int1:= y - b^.y;
   if int1 > 0 then begin
    result:= bigint;
   end
   else begin
    if int1 = 0 then begin
     result:= b^.x;
     exit;
    end
    else begin
     result:= -bigint;
    end;
   end;
   result:= result * dx;
  end
  else begin
   result:= b^.x + (y - b^.y) * dx div dy;
  end;
 end;
end;

type
 trapinfoarty = array of trapinfoty;

function calcx(const seg: pseginfoty; const y: integer): integer;
begin
 with seg^ do begin
  if dy = 0 then begin
   result:= bigint;
   if y < seg^.b^.y then begin
    result:= -bigint;
   end;
   result:= result*dx;
  end
  else begin
   result:= b^.x + ((y - b^.y)*dx) div dy;
  end;
 end;
end;

function cmptrap(const l,r): integer;
var
 y: integer;
begin
 result:= 0;
 y:= 0;
 if trapinfoty(l).top = nil then begin
  if trapinfoty(r).top <> nil then begin
   result:= -1;
  end;
 end
 else begin
  if trapinfoty(r).top = nil then begin
   result:= 1;
  end
  else begin
   y:= trapinfoty(r).top^.y;
   result:= trapinfoty(l).top^.y - y
  end;
 end;
 if result = 0 then begin
  if trapinfoty(l).left = nil then begin
   if trapinfoty(r).left <> nil then begin
    result:= -1;
   end;
  end
  else begin
   if trapinfoty(r).left = nil then begin
    result:= 1;
   end
   else begin
    result:= calcx(trapinfoty(l).left,y) - calcx(trapinfoty(r).left,y);
   end;
  end;
 end;
end;
 
procedure dumptraps(const ataps: ptrapinfoty; const acount: integer);

 function pointval(x,y: integer): string;
 begin
  if x > 10000 then begin
   x:= 10000;
  end;
  if y > 10000 then begin
   y:= 10000;
  end;
  result:= rstring(inttostr(x),5)+':'+lstring(inttostr(y),5)+' ';
 end; //pointval

var
 ar1: trapinfoarty;
 int1: integer;
 lt,lb,rt,rb,t,b: integer;
begin
 setlength(ar1,acount);
 move(ataps^,ar1[0],acount*sizeof(trapinfoty));
 sortarray(ar1,sizeof(trapinfoty),@cmptrap);
 writeln('******************************************');
 writeln('n     topleft    topright   bottomleft bottomright');
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   lt:= 0;
   lb:= 0;
   t:= 0;
   rt:= 10000;
   rb:= 10000;
   b:= 10000;
   if top <> nil then begin
    t:= top^.y;
   end;
   if bottom <> nil then begin
    b:= bottom^.y;
   end;
   if left <> nil then begin
    lt:= calcx(left,t);
    lb:= calcx(left,b);
   end;
   if right <> nil then begin
    rt:= calcx(right,t);
    rb:= calcx(right,b);
   end;
  end;
  writeln(rstring(inttostr(int1),3),pointval(lt,t),pointval(rt,t),
                           pointval(lb,b),pointval(rb,b));
 end;
end;
 
procedure tmainfo.triangexe(const sender: TObject);
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
  result^.above:= nil;
  result^.below:= nil;
  result^.right:= nil;
 end;
 
 function newnode: ptrapnodeinfoty;
 begin
  result:= newnodes;
  inc(newnodes);
 end;

 function newnode(const atrap: ptrapinfoty; 
                     const aparent: ptrapnodeinfoty): ptrapnodeinfoty;
 begin
  result:= newnodes;
  inc(newnodes);
  result^.kind:= tnk_trap;
  result^.trap:= atrap;
  result^.p:= aparent;
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
   
 procedure handlepoint(const seg: pseginfoty);
 var
  tplower,tpupper: ptrapinfoty;
  no1,nol,nor: ptrapnodeinfoty;
  ppt1: ppointty;
 begin
  ppt1:= seg^.b;
  tpupper:= findtrap(ppt1);
  tplower:= newtrap;            //split trap, lower
  tplower^.top:= ppt1;
  tplower^.bottom:= tpupper^.bottom;
  tpupper^.bottom:= ppt1;    //upper
  tplower^.left:= tpupper^.left;   //same segment
  tplower^.right:= tpupper^.right; //same segment
  tpupper^.below:= tplower;
  tplower^.above:= tpupper;
  seg^.trap:= tplower;
  
  no1:= tpupper^.node;         //old leaf
  nol:= newnode(tpupper,no1);
  nor:= newnode(tplower,no1);
  no1^.l:= nol;
  no1^.r:= nor;
  no1^.kind:= tnk_y;
  no1^.y:= ppt1;
  tpupper^.node:= nol;
  tplower^.node:= nor;
  
  include(seg^.flags,sf_pointhandled);
 end;
 
 procedure handlesegment(const aseg: pseginfoty);
 var
  sega,segb: pseginfoty;
  trabove,trleft,trright: ptrapinfoty;
  noabove,noleft,noright: ptrapnodeinfoty;
  trap1,trap2: ptrapinfoty;
 begin
  if sf_reverse in aseg^.flags then begin
   sega:= aseg;
   segb:= aseg - 1;
   if segb < segments then begin
    inc(segb,npoints);
   end;
  end
  else begin
   segb:= aseg;
   sega:= aseg - 1;
   if sega < segments then begin
    inc(sega,npoints);
   end;
  end;
  if sega^.rtrap = nil then begin //no existing edge
   trabove:= sega^.trap^.above;
   trright:= newtrap;
   trleft:= sega^.trap;
   trright^.right:= trleft^.right;
   trleft^.right:= aseg;
   trright^.left:= aseg;
   trright^.top:= trleft^.top;
   trright^.bottom:= trleft^.bottom;
   trabove^.belowr:= trright;
   trright^.below:= trleft^.below;
   
   noabove:= trleft^.node;
   noleft:= newnode(trleft,noabove);      // (T1) ->     (s)
   noright:= newnode(trright,noabove);    //         (T1)   (T2)
   with noabove^ do begin
    l:= noleft;
    r:= noright;
    kind:= tnk_x;
    seg:= aseg;
   end;
  end
  else begin
  end;
  trap1:= trleft;                    //upper
  trap2:= trleft^.below;             //lower
  while trap2 <> segb^.trap do begin //split crossed lines by segment
   trap2^.left:= segb;               //move edge to right
   trap1^.bottom:= trap2^.bottom;
   trap1:= trap2;
   trap2:= trap2^.below;
  end;
  segb^.rtrap:= trright;
  segb^.trap:= trleft;
 end;

var
 ar1: pointarty;
 int1,int2: integer;
 seg1,seg2: pseginfoty;
 sizetraps,sizenodes: integer;
 ppt1,ppt2: ppointty;
  
begin
mwcnoiseinit(1,1);
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
    rtrap:= nil;
    flags:= [];
    b:= ppt1;
    dx:= ppt2^.x-ppt1^.x; //b->a slope
    dy:= ppt2^.y-ppt1^.y; //b->a slope
    if dy = 0 then begin
     if ppt2 > ppt1 then begin
      dx:= -1;
      include(flags,sf_reverse);
     end
     else begin
      dx:= 1;
     end;
    end
    else begin
     if dy > 0 then begin
      include(flags,sf_reverse);
     end;      
    end;
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

  deltraps:= nil;      //init memory sources
  newtraps:= traps;
  newnodes:= nodes;
  
  with newnode^ do begin //init root node
   kind:= tnk_trap;
   trap:= traps;
  end;

  with newtrap^ do begin //init trap plane
   node:= nodes;
   left:= nil;
   right:= nil;
   top:= nil;
   bottom:= nil;
  end;
 
  for int1:= npoints-1 downto 0 do begin
   seg1:= shuffle[int1];
   seg2:= seg1-1;
   if seg2 < segments then begin
    inc(seg2,npoints);
   end;
   if not (sf_pointhandled in seg2^.flags) then begin
    handlepoint(seg2);
   end;
   if not (sf_pointhandled in seg1^.flags) then begin
    handlepoint(seg1);
   end;
   handlesegment(seg1);
dumptraps(traps,newtraps-traps);
if int1 = 1 then begin
 break;
end;
  end;

  setlength(ftraps,newtraps-traps);
  for int1:= 0 to high(ftraps) do begin
   with traps[int1] do begin
    if top = nil then begin
     ftraps[int1][0].y:= 0;
     ftraps[int1][1].y:= 0;
    end
    else begin
     ftraps[int1][0].y:= top^.y;
     ftraps[int1][1].y:= top^.y;
    end;
    if bottom = nil then begin
     ftraps[int1][2].y:= tridisp.height-1;
     ftraps[int1][3].y:= tridisp.height-1;
    end
    else begin
     ftraps[int1][2].y:= bottom^.y;
     ftraps[int1][3].y:= bottom^.y;
    end;
    if left = nil then begin
     ftraps[int1][0].x:= 0;
     ftraps[int1][3].x:= 0;
    end
    else begin
     ftraps[int1][0].x:= calcx(top^.y,left^);
     ftraps[int1][3].x:= calcx(bottom^.y,left^);
    end;
    if right = nil then begin
     ftraps[int1][1].x:= tridisp.width-1;
     ftraps[int1][2].x:= tridisp.width-1;
    end
    else begin
     ftraps[int1][1].x:= calcx(top^.y,right^);
     ftraps[int1][2].x:= calcx(bottom^.y,right^);
    end;
   end;
  end;
  freemem(buffer);
  invalidisp;
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
 xed.valuerange:= charted.width;
 yed.valuerange:= charted.height;
end;

procedure tmainfo.tripaexe(const sender: twidget; const acanvas: tcanvas);
var
 ar1: pointarty;
 int1: integer;
begin
 ar1:= polyvalues;
 for int1:= 0 to high(ftraps) do begin
  acanvas.drawline(ftraps[int1][0],ftraps[int1][2],cl_gray);
  acanvas.drawline(ftraps[int1][1],ftraps[int1][3],cl_gray);
 end;  
 for int1:= 0 to high(ftraps) do begin
  acanvas.drawlines(ftraps[int1],true,cl_green);
 end;
 acanvas.dashes:= #1#3;
 acanvas.drawlines(ar1,true,cl_red);
end;

end.
