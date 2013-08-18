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
   stoped: tintegeredit;
   noseged: tbooleanedit;
   nosegbed: tbooleanedit;
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
  next: ptrapinfoty; //for deleted list //todo: remove next
  top,bottom: ppointty;  
  left,right: pseginfoty;
  node: ptrapnodeinfoty;
  above,abover,below,belowr: ptrapinfoty; //above,below = single or left
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
//  splittrap: ptrapinfoty; //trap for horizontal split at b
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
        trapval(seg1^.trap),' ',trapval(nil{seg1^.splittrap}),' ',
        trapval(seg^.trap),' ',trapval(nil{seg^.splittrap}),' ');
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
   result:= '  -';
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
 writeln('------------------------------------------------------- '+caption);
 writeln('  T     t     b    tl    tr    bl    br   A  AR   B  BR');
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
        trapval(above),' ',trapval(abover),' ',
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
var testvar,testvar1,testvar2,testvar3,testvar4,testvar5,testvar6,
 testvar7: integer;

function isbelow(const l,r: ppointty): boolean;
               //true if l beow r
var
 int1: integer;
begin
 int1:= l^.y - r^.y;
 if int1 = 0 then begin
  result:= l - r >= 0;
 end
 else begin
  result:= int1 >= 0;
 end;
end;

function xdist(const point: ppointty; ref: pseginfoty): integer;
 //true if point right of segment
begin
 if ref^.dy = 0 then begin
  result:= (point^.y - ref^.b^.y) * ref^.dx; //dx = 1|-1
 end
 else begin
//todo: no division
  result:= point^.x -(ref^.b^.x + (point^.y-ref^.b^.y)*ref^.dx div ref^.dy);
 end;
end;

function isright(const point: ppointty; ref: pseginfoty): boolean;
 //true if point right of segment
begin
 result:= xdist(point,ref) >= 0;
end;

type
 segdirty = (sd_none,sd_same,sd_up,sd_down,sd_left,sd_right);

function segbefore(const seg: pseginfoty): pseginfoty;
begin
 result:= seg-1;
 if result < segments then begin
  inc(result,npoints);
 end;
end;

function segdirdown(const seg,ref: pseginfoty): segdirty;
//todo: handle dy = 0, unify with segdirup
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
  if isbelow(segcommon^.b,ptseg) then begin
   result:= sd_up;
  end
  else begin
   if ptseg^.x = ptref^.x then begin
    if isbelow(ptseg,ptref) then begin
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

function segdirup(const seg,ref: pseginfoty): segdirty;
//todo: handle dy = 0, unify with segdirdown
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
  if not isbelow(segcommon^.b,ptseg) then begin
   result:= sd_down;
  end
  else begin
   if ptseg^.x = ptref^.x then begin
    if isbelow(ptseg,ptref) then begin
     result:= sd_left;
    end
    else begin
     result:= sd_right;
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
  result^.abover:= nil;
  result^.below:= nil;
  result^.belowr:= nil;
//  result^.right:= nil;
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

 function findtrap(const apoint,second: ppointty): ptrapinfoty;
                     //second used if apoint is on edge
 var
  no1,no2: ptrapnodeinfoty;
  int1: integer;
 begin
  write('Search ',apoint^.x,':',apoint^.y);
  no1:= nodes;
  while true do begin
   no2:= no1^.l;
   case no1^.kind of
    tnk_trap: begin
     result:= no1^.trap;
     break;
    end;
    tnk_y: begin
     if isbelow(apoint,no1^.y) then begin
      no2:= no1^.r;
     end;
    end;
    tnk_x: begin
     int1:= xdist(apoint,no1^.seg);
     if int1 = 0 then begin
      int1:= xdist(second,no1^.seg);
     end;
//     if isright(apoint,no1^.seg) then begin
     if int1 > 0 then begin
      no2:= no1^.r;
     end;
    end;
   end;
   no1:= no2;
  end;
writeln(' found trap ',result-traps);
 end;
   
 procedure handlepoint(const seg: pseginfoty);
 var
  tplower,tpupper,tpbelow,tpbelowr: ptrapinfoty;
  no1,nol,nor: ptrapnodeinfoty;
  ppt1: ppointty;
 begin
  ppt1:= seg^.b;
  tpupper:= findtrap(ppt1,ppt1);
testvar:= tpupper-traps;
  tplower:= newtrap;            //split trap, lower
  tplower^.top:= ppt1;
  tplower^.bottom:= tpupper^.bottom;
  tpupper^.bottom:= ppt1;    //upper
  tplower^.left:= tpupper^.left;    //same segment
  tplower^.right:= tpupper^.right;  //same segment
  tplower^.below:= tpupper^.below;  //same below
  tplower^.belowr:= tpupper^.belowr;//same belowr
  tplower^.above:= tpupper;         //abover = nil
  tpbelow:= tpupper^.below;
  tpbelowr:= tpupper^.belowr;
  if tpbelow <> nil then begin
   if tpbelow^.above = tpupper then begin
    tpbelow^.above:= tplower;
   end;
   if tpbelow^.abover = tpupper then begin
    tpbelow^.abover:= tplower;
   end;
   if tpbelowr <> nil then begin
    if tpbelowr^.above = tpupper then begin
     tpbelowr^.above:= tplower;
    end;
    if tpbelowr^.abover = tpupper then begin
     tpbelowr^.abover:= tplower;
    end;
   end;
  end;
  {
  if tpbelow <> nil then begin
   if tpbelow^.above = tpupper then begin
    tpbelow^.above:= tplower;
   end
   else begin
    tpbelow^.abover:= tplower;
   end;
  end;
  if tpbelowr <> nil then begin
   tpbelowr^.above:= tplower;
//   tpbelowr^.abover:= nil;
  end;
  }
  tpupper^.below:= tplower;
  tpupper^.belowr:= nil;            //no split segment
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

var
 segcounter: integer;
 
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
   trbelow: ptrapinfoty;
   trbelowr: ptrapinfoty;
   trabove: ptrapinfoty;
   trabover: ptrapinfoty;
   pointbelowisright: boolean;
  begin
testvar:= old-traps;
   trnew:= newtrap;
   trabove:= old^.above;
   trabover:= old^.abover;
   trbelow:= old^.below;
   trbelowr:= old^.belowr;
   trnew^.top:= old^.top;
   trnew^.bottom:= old^.bottom;
   trnew^.left:= old^.left;
   trnew^.right:= old^.right;
   trnew^.above:= trabove;
   trnew^.below:= trbelow;
testvar1:= trabove-traps;
testvar2:= trabover-traps;
testvar3:= trbelow-traps;
testvar4:= trbelowr-traps;
   if newright then begin
    old^.right:= aseg;
    trnew^.left:= aseg;
    right:= trnew;
    left:= old;
   end
   else begin
    old^.left:= aseg;
    trnew^.right:= aseg;
    right:= old;
    left:= trnew;
   end;
//if segcounter = 1 then begin
//exit;
//end;
   if trbelow <> nil then begin
    pointbelowisright:= isright(trbelow^.top,aseg);
    if pointbelowisright xor not newright then begin
     if (trbelow <> nil) and (trbelow^.above = old) then begin
      trbelow^.above:= trnew;
      if (trbelowr <> nil) and (trbelowr^.above = old) then begin
       trbelowr^.above:= trnew;
      end;
     end;
    end;
    if trbelowr <> nil then begin
     if pointbelowisright then begin
      right^.belowr:= trbelowr;
      left^.belowr:= nil;
     end
     else begin
      left^.belowr:= trbelowr;
      right^.below:= trbelowr;
      right^.belowr:= nil;
     end;
    end;
   end;

   left^.above:= trabove;
   if trabover = nil then begin //no existing segment above
    right^.above:= trabove;
    if trabove <> nil then begin
     if trabove^.belowr = nil then begin //first segment
      trabove^.belowr:= right;
     end;
    end;
   end
   else begin
    right^.above:= trabover;
    trabover^.below:= right;
   end;  
   splitnode(newright,left,right);
  end; //splittrap
  
 var
  sega,segb: pseginfoty;
//  trleft,trright: ptrapinfoty;
  trap1,trap2,trap1l,trap1r,trbelow,trbelowr,exttrap: ptrapinfoty;
  isright1,isright2,bo2: boolean;
  bottompoint: ppointty;
  
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
   isright1:= false;
   splittrap(true,sega^.trap,trap1l,trap1r,trap1);
   sega^.splitseg:= aseg;
//   sega^.splittrap:= trap1r;
  end
  else begin
   isright1:= segdirdown(sega^.splitseg,aseg) <> sd_right; 
   splittrap(isright1,findtrap(sega^.b,segb^.b),trap1l,trap1r,trap1);
//   splittrap(segdir(sega^.splitseg,aseg) <> sd_right,sega^.splittrap,trap1l,trap1r,trap1);
  end;
dump(traps,newtraps-traps,nodes,'segment0');
testvar1:= trap1l-traps;
testvar2:= trap1r-traps;
testvar4:= segb^.trap-traps;

  bottompoint:= segb^.trap^.top;
  bo2:= false;
if not ((segcounter = stoped.value) and nosegbed.value) then begin
  while trap1^.below <> nil do begin
   trap2:= trap1^.below;
   if trap2^.top = bottompoint then begin
    break;
   end; 
   bo2:= true;


   isright1:= isright(trap2^.top,aseg); //point right of segment   
   if (trap1^.belowr <> nil) and not isright1 then begin
    trap2:= trap1^.belowr;
   end;
   trbelow:= trap2^.below;
   trbelowr:= trap2^.belowr;
   
                               //split crossed lines by segment
//   isright1:= isright(trap2^.top,aseg); //point right of segment
testvar1:= trap1-traps;
testvar2:= trap2-traps;
      
testvar3:= trap1l-traps;
testvar4:= trap1r-traps;
testvar5:= trbelow-traps;
testvar6:= trbelowr-traps;
   if isright1 then begin                 
    exttrap:= trap1l;
    trap2^.left:= aseg;               //move edge to right
    trap1l^.bottom:= trap2^.bottom;
//    trap2^.above:= trap1r;
    trap1r:= trap2;
    trap1l^.below:= trbelow;
    trap1l^.belowr:= trbelowr;
   end
   else begin
    exttrap:= trap1r;
    trap2^.right:= aseg;              //move edge to left
//    trap1r^.bottom:= trap2^.bottom;
//    if trap2^.abover = nil then begin
//     trap2^.above:= trap1l;
//    end
//    else begin
//     trap2^.abover:= trap1l;
//    end;
    trap1l:= trap2;
    if trbelowr <> nil then begin
     trap1r^.below:= trbelowr;
    end
    else begin
     trap1r^.below:= trbelow;
    end;
    trap1r^.belowr:= nil;
   end;
testvar7:= exttrap-traps;
   exttrap^.bottom:= trap2^.bottom;
   if (trbelow <> nil) and (trbelow^.top <> bottompoint) then begin
    if isright(trbelow^.top,aseg) xor isright1 then begin
     if (trbelow <> nil) and (trbelow^.above = trap2) then begin
      trbelow^.above:= exttrap;
      if (trbelowr <> nil) and (trbelowr^.above = trap2) then begin
       trbelowr^.above:= exttrap;
      end;
     end;
    end;
   end;
{
   if (trbelow <> nil) and (trbelow^.above = trap1) then begin
    trbelow^.above:= trap2;
   end;
   if (trbelowr <> nil) and (trbelowr^.above = trap1) then begin
    trbelowr^.above:= trap2;
   end;
}
//   trap1^.below:= trbelow;
//   trap1^.belowr:= trbelowr;
   splitnode(not isright1,trap1l,trap1r);
   trap1:= trap2;
   {
   trap2:= trap1^.below;
   if isleft1 and (trap1^.belowr <> nil) then begin
    trap2:= trap1^.belowr;
   end;
   }
  end;
{
  if bo2 then begin
   if not bo1 then begin
    if trap1^.belowr <> nil then begin
     trap1^.below:= trap1^.belowr; //move to right
    end;
   end;
   trap1^.belowr:= nil;
  end;
}
end;
testvar:= segb^.trap-traps;
  with segb^.trap^ do begin
testvar1:= above-traps;
testvar2:= abover-traps;
testvar3:= aseg-segments;
   if segb^.splitseg = nil then begin //no existing seg
    segb^.splitseg:= aseg;
    above:= trap1l;
    abover:= trap1r;
   end
   else begin
    if abover = nil then begin //no existing seg above
     above:= trap1l;
     abover:= trap1r;
    end
    else begin
testvar4:= segb^.splitseg-segments;
     if segdirup(aseg,segb^.splitseg) <> sd_right then begin
      if not isright1 then begin
       above:= trap1l;
      end;
     end
     else begin
      if isright1 then begin
       abover:= trap1r;
      end;
     end;
    end;
   end;
  end;
  
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
//    splittrap:= nil;
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
 
  for segcounter:= npoints-1 downto 0 do begin
   seg1:= shuffle[segcounter];
   seg2:= seg1-1;
   if seg2 < segments then begin
    inc(seg2,npoints);
   end;
writeln('************************************** (',segcounter,')');
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
if (segcounter = stoped.value) and noseged.value then begin
 break;
end;
   handlesegment(seg1);
writeln('----------------');
dumpseg(seg1);
if segcounter = stoped.value then begin
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
     if top = nil then begin
      ftraps[int1][0].x:= 0;
     end
     else begin
      ftraps[int1][0].x:= calcx(top^.y,left^);
     end;
     if bottom = nil then begin
      ftraps[int1][3].x:= tridisp.width-1;
     end
     else begin
      ftraps[int1][3].x:= calcx(bottom^.y,left^);
     end;
    end;
    if right = nil then begin
     ftraps[int1][1].x:= tridisp.width-1;
     ftraps[int1][2].x:= tridisp.width-1;
    end
    else begin
     if top = nil then begin
      ftraps[int1][1].x:= tridisp.width-1;
     end
     else begin
      ftraps[int1][1].x:= calcx(top^.y,right^);
     end;
     if bottom = nil then begin
      ftraps[int1][2].x:= 0;
     end
     else begin
      ftraps[int1][2].x:= calcx(bottom^.y,right^);
     end;
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
