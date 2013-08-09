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
 main_mfm,msearrayutils,msenoise,mseformatstr,sysutils,msedrawtext;

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
  splitseg: pseginfoty;   //segment for horizontal split at b
  splittrap: ptrapinfoty; //trap for horizontal split at b
 end;
 
 trapnodeinfoty = record
  p,l,r: ptrapnodeinfoty; //parent,left,right
  case kind: trapnodekindty of
   tnk_y: (y: ppointty);
   tnk_x: (seg: pseginfoty);
   tnk_trap: (trap: ptrapinfoty);
 end;

var
 traps: ptrapinfoty;

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

type
 trapdumpinfoty = record
  t: trapinfoty;
  index: integer;
 end;
 
function cmptrap(const l,r): integer;
var
 y: integer;
begin
 result:= 0;
 y:= 0;
 if trapdumpinfoty(l).t.top = nil then begin
  if trapdumpinfoty(r).t.top <> nil then begin
   result:= -1;
  end;
 end
 else begin
  if trapdumpinfoty(r).t.top = nil then begin
   result:= 1;
  end
  else begin
   y:= trapdumpinfoty(r).t.top^.y;
   result:= trapdumpinfoty(l).t.top^.y - y
  end;
 end;
 if result = 0 then begin
  if trapdumpinfoty(l).t.left = nil then begin
   if trapdumpinfoty(r).t.left <> nil then begin
    result:= -1;
   end;
  end
  else begin
   if trapdumpinfoty(r).t.left = nil then begin
    result:= 1;
   end
   else begin
    result:= calcx(trapdumpinfoty(l).t.left,y) - 
                      calcx(trapdumpinfoty(r).t.left,y);
    if result = 0 then begin
     if trapdumpinfoty(r).t.right = nil then begin
      result:= -1;
     end;
     if trapdumpinfoty(l).t.right = nil then begin
      inc(result);
     end;
    end;     
   end;
  end;
 end;
end;

var
 segments: pseginfoty;
 npoints: integer;

function intvalx(const value: integer): string;
begin
 if value <= -10000 then begin
  result:= '    <';
 end
 else begin
  if value >= 10000 then begin
   result:= '    >';
  end
  else begin
   result:= rstring(inttostr(value),5);
  end;
 end;
end;

function intvaly(const value: integer): string;
begin
 if value <= -10000 then begin
  result:= '    ^';
 end
 else begin
  if value >= 10000 then begin
   result:= '    v';
  end
  else begin
   result:= rstring(inttostr(value),5);
  end;
 end;
end;

function pointval(const x,y: integer): string;
begin
 result:= intvalx(x)+':'+intvaly(y)+' ';
end; //pointval

function pointval(const apoint: ppointty): string;
begin
 result:= intvalx(apoint^.x)+':'+intvaly(apoint^.y)+' ';
end; //pointval 

function trapval(const atrap: ptrapinfoty): string;
begin
 if atrap = nil then begin
  result:= 'NIL';
 end
 else begin
  result:= rstring(inttostr(atrap-traps),3);
 end;
end;

procedure dumpseg(const seg: pseginfoty);
var
 seg1: pseginfoty;
begin
// writeln('********************************');
 writeln('  S     A            B       Atr Asp Brt Bsp');
 seg1:= seg-1;
 if seg1 < segments then begin
  inc(seg1,npoints);
 end;
 writeln(rstring(inttostr(seg-segments),3),
        pointval(seg1^.b),' ',pointval(seg^.b),' ',
        trapval(seg1^.trap),' ',trapval(seg1^.splittrap),' ',
        trapval(seg^.trap),' ',trapval(seg^.splittrap),' ');
end;

procedure dumpnodes(const anodes: ptrapnodeinfoty; 
                                       const atraps: ptrapinfoty);
type
 levelsty = array[0..255] of boolean;
var
 level: integer;
 levels: levelsty;

 procedure dump(const n: ptrapnodeinfoty; const lline,rline: boolean);
 var
  int1: integer;
 begin
  if n <> nil then begin
   inc(level);
   if n^.kind <> tnk_trap then begin
    levels[level-1]:= lline;
    dump(n^.l,false,true);
   end;
   for int1:= 0 to level-2 do begin
    if levels[int1] then begin
     write('|');
    end
    else begin
     write(' ');
    end;
   end;
   write('+');
   case n^.kind of
    tnk_trap: begin
     writeln('(',inttostr(n^.trap-atraps),')');
    end;
    tnk_x: begin
     writeln('X=',n^.seg-segments);
    end;
    tnk_y: begin
     writeln('Y=',n^.y^.y);
    end;
   end;
   if n^.kind <> tnk_trap then begin
    levels[level-1]:= rline;
    dump(n^.r,true,false);
   end;
   dec(level);
   levels[level]:= false;
  end;
 end;
begin
 level:= 0;
 dump(anodes,false,false);
end;

procedure dumptraps(const atraps: ptrapinfoty; const acount: integer;
                    const caption: string);
var
 ar1: array of trapdumpinfoty;
 ar2: integerarty;

 function trapval(const trap: ptrapinfoty): string;
 begin
  if trap = nil then begin
   result:= '   ';
  end
  else begin
   result:= rstring(inttostr(trap-atraps),3);
  end;
 end;
 
var
 int1: integer;
 lt,lb,rt,rb,t,b: integer;
begin
 setlength(ar1,acount);
 for int1:= 0 to high(ar1) do begin
  ar1[int1].t:= atraps[int1];
  ar1[int1].index:= int1;
 end;
 sortarray(ar1,sizeof(trapdumpinfoty),@cmptrap,ar2);
 writeln('----------------------------------------------- '+caption);
 writeln('  T     t     b    tl    tr    bl    br   B  BR');
 for int1:= 0 to high(ar1) do begin
  with ar1[int1].t do begin
   lt:= -10000;
   lb:= -10000;
   t:= -10000;
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
   writeln(rstring(inttostr(ar1[int1].index),3),' ',
        intvaly(t),' ',intvaly(b),' ',
        intvalx(lt),' ',intvalx(rt),' ',intvalx(lb),' ',intvalx(rb),' ',
        trapval(below),' ',trapval(belowr));
  end;
 end;
end;

procedure dump(const atraps: ptrapinfoty; const ntraps: integer;
                        const anodes: ptrapnodeinfoty; const caption: string);
begin
 dumptraps(atraps,ntraps,caption);
 writeln;
 dumpnodes(anodes,atraps);
end;
var testvar,testvar1,testvar2,testvar3,testvar4: integer;

function cmpy(const l,r: ppointty): integer;
begin
 result:= l^.y - r^.y;
 if result = 0 then begin
  result:= l - r;
 end;
end;

function cmpx(const l: ppointty; r: pseginfoty): integer;
 //<0 -> l = left of segment
begin
 if r^.dy = 0 then begin
  result:= (l^.y - r^.b^.y) * r^.dx; //dx = 1|-1
 end
 else begin
//todo: no division
  result:= l^.x -(r^.b^.x + (l^.y-r^.b^.y)*r^.dx div r^.dy);
 end;
end;

type
 segdirty = (sd_none,sd_same,sd_up,sd_left,sd_right);

function segbefore(const seg: pseginfoty): pseginfoty;
begin
 result:= seg-1;
 if result < segments then begin
  inc(result,npoints);
 end;
end;

function segdir(const seg,ref: pseginfoty): segdirty;
//todo: handle dy = 0
var
 segcommon: pseginfoty;
 ptseg,ptref: ppointty;
begin
 if seg = ref then begin
  result:= sd_same;
 end
 else begin
  segcommon:= segbefore(seg);
  if segcommon = ref then begin
   ptseg:= seg^.b;
   ptref:= segbefore(ref)^.b;
  end
  else begin
   segcommon:= segbefore(ref);
   if segcommon = seg then begin
    ptseg:= segbefore(seg)^.b;
    ptref:= ref^.b;
   end
   else begin
    result:= sd_none;
    exit;
   end;
  end;
  if cmpy(segcommon^.b,ptseg) > 0 then begin
   result:= sd_up;
  end
  else begin
   if ptseg^.x = ptref^.x then begin
    if cmpy(ptseg,ptref) > 0 then begin
     result:= sd_right;
    end
    else begin
     result:= sd_left;
    end;
   end
   else begin
    if seg^.dx*ref^.dy > ref^.dx*seg^.dy then begin
     result:= sd_right;
    end
    else begin
     result:= sd_left;
    end;
   end;
  end;
 end;
end;

procedure tmainfo.triangexe(const sender: TObject);
// x,y range = $7fff..-$8000 (16 bit X11 space)
var
 buffer: pointer;
 shuffle: ppseginfoty;
 points: ppointty; 
 nodes: ptrapnodeinfoty;
 deltraps,newtraps: ptrapinfoty;
 newnodes: ptrapnodeinfoty;

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
  result^.belowr:= nil;
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
  atrap^.node:= result;
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
     if cmpy(apoint,no1^.y) > 0 then begin
      no2:= no1^.r;
     end;
    end;
    tnk_x: begin
     if cmpx(apoint,no1^.seg) > 0 then begin
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
  tplower^.left:= tpupper^.left;    //same segment
  tplower^.right:= tpupper^.right;  //same segment
  tplower^.below:= tpupper^.below;  //same below
  tplower^.belowr:= tpupper^.belowr;//same belowr
  tpupper^.below:= tplower;
  tpupper^.belowr:= nil;
  tplower^.above:= tpupper;
  seg^.trap:= tplower;
  
  no1:= tpupper^.node;         //old leaf
  nol:= newnode(tpupper,no1);  //new leaf
  nor:= newnode(tplower,no1);  //new leaf
  no1^.l:= nol;
  no1^.r:= nor;
  no1^.kind:= tnk_y;
  no1^.y:= ppt1;
  
  include(seg^.flags,sf_pointhandled);
 end;
 
 procedure handlesegment(const aseg: pseginfoty);

  procedure splitnode(const newright: boolean; const ltrap,rtrap: ptrapinfoty);
  var
   noabove,noleft,noright: ptrapnodeinfoty;
  begin
   if newright then begin
    noabove:= ltrap^.node;
   end
   else begin
    noabove:= rtrap^.node;
   end;
   noleft:= newnode(ltrap,noabove);       // (Tb) ->     (s)
   noright:= newnode(rtrap,noabove);      //         (Tl)   (Tr)
   with noabove^ do begin
    l:= noleft;
    r:= noright;
    kind:= tnk_x;
    seg:= aseg;
   end;
  end; //splitnode

  procedure splittrap(const newright: boolean; const old: ptrapinfoty;
                              var left,right,trnew: ptrapinfoty);
  var
   trabove: ptrapinfoty;
  begin
testvar:= old-traps;
   trnew:= newtrap;
   trabove:= old^.above;
   trnew^.top:= old^.top;
   trnew^.bottom:= old^.bottom;
   trnew^.left:= old^.left;
   trnew^.right:= old^.right;
   trnew^.above:= trabove;
   if newright then begin
    trnew^.below:= old^.belowr;
    if trnew^.below = nil then begin
     trnew^.below:= old^.below;       //single
    end;
    old^.right:= aseg;
    trnew^.left:= aseg;
//    trnew^.below:= old^.belowr;
//    if trnew^.below = nil then begin
//     trnew^.below:= old^.below;
//    end;
    right:= trnew;
    left:= old;
   end
   else begin
    trnew^.below:= old^.below;
    old^.left:= aseg;
    trnew^.right:= aseg;
//    trnew^.below:= old^.below;
    right:= old;
    left:= trnew;
   end;
   trabove^.below:= left;
   trabove^.belowr:= right;
   splitnode(newright,left,right);
  end; //splittrap
  
 var
  sega,segb: pseginfoty;
  trleft,trright: ptrapinfoty;
  trap1,trap2,trap1l,trap1r: ptrapinfoty;
  bo1: boolean;
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
  if sega^.splitseg = nil then begin //no existing edge
   splittrap(true,sega^.trap,trleft,trright,trap1);
   sega^.splitseg:= aseg;
   sega^.splittrap:= trright;
//   splitnode(true,trleft,trright);
  end
  else begin
   case segdir(sega^.splitseg,aseg) of
    sd_up: begin
     splittrap(true,sega^.trap,trleft,trright,trap1);
    end;
    sd_left: begin
     splittrap(true,sega^.trap,trleft,trright,trap1);
    end;
    sd_right: begin
     splittrap(false,sega^.splittrap,trleft,trright,trap1);
    end;
    else begin
     raise exception.create('Invalid edge.');
    end;
   end;
  end;
dump(traps,newtraps-traps,nodes,'segment0');
if aseg - segments = 1 then begin
//exit;
end;
  trap1l:= trleft;
  trap1r:= trright;
  trap2:= trap1^.below;              //??? correct starting?
testvar4:= segb^.trap-traps;
  while trap2 <> segb^.trap do begin //split crossed lines by segment
testvar1:= trap1-traps;
testvar2:= trap2-traps;
   bo1:= cmpx(trap2^.top,sega) < 0; //point left of segment
//   if bo1 then begin
//    trap2:= trap1^.belowr;
//   end
//   else begin
//    trap2:= trap1^.below;
//   end;

//   trap1^.bottom:= trap2^.bottom;    //extend to bottom
   trap1^.below:= trap2^.below;
   trap1^.belowr:= trap2^.belowr;
   if bo1 then begin
    trap2^.right:= segb;              //move edge to left
    trap1l^.bottom:= trap2^.bottom;
    trap1r:= trap2;
   end
   else begin
    trap2^.left:= segb;               //move edge to right
    trap1r^.bottom:= trap2^.bottom;
    trap1l:= trap2;
   end;
   splitnode(bo1,trap1,trap2);
   trap1:= trap2;
   trap2:= trap1^.below;
  end;
  segb^.splitseg:= aseg;
//  segb^.trap:= trleft;
dump(traps,newtraps-traps,nodes,'segment1');
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
  sizetraps:= 4*npoints*sizeof(trapinfoty);
  sizenodes:= 8*npoints*sizeof(trapnodeinfoty);
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
    splitseg:= nil;
    trap:= nil;
    splittrap:= nil;
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
   seg1:= shuffle[int2];
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
writeln('**************************************');
dumpseg(seg1);
   if not (sf_pointhandled in seg2^.flags) then begin
    handlepoint(seg2);
dump(traps,newtraps-traps,nodes,'point A');
   end;
   if not (sf_pointhandled in seg1^.flags) then begin
    handlepoint(seg1);
dump(traps,newtraps-traps,nodes,'point B');
   end;
writeln('----------------');
dumpseg(seg1);
   handlesegment(seg1);
writeln('----------------');
dumpseg(seg1);
//if int1 = 1 then begin
// break;
//end;
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
 {
 for int1:= 0 to high(ftraps) do begin
  acanvas.drawline(ftraps[int1][0],ftraps[int1][2],cl_gray);
  acanvas.drawline(ftraps[int1][1],ftraps[int1][3],cl_gray);
 end;  
 }
 for int1:= 0 to high(ftraps) do begin
  acanvas.drawlines(ftraps[int1],true,cl_green);
 end;
 acanvas.dashes:= #1#3;
 acanvas.drawlines(ar1,true,cl_red);
 for int1:= 0 to high(ftraps) do begin
  drawtext(acanvas,inttostr(int1),
  mr((ftraps[int1][0].x+ftraps[int1][1].x+ftraps[int1][2].x+
                  ftraps[int1][3].x) div 4,
                    (ftraps[int1][0].y+ftraps[int1][2].y)div 2,
       0,0),[tf_xcentered,tf_ycentered]);
 end;
end;

end.
