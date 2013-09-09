unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msewidgetgrid,msegraphedits,msescrollbar,msestatfile,
 msesplitter,msechartedit,msebitmap,msedatanodes,msefiledialog,mselistbrowser,
 msesys,msedispwidgets,mserichstring;

type
 trapdispinfoty = array[0..3] of pointty;
 xpointfixedty = record
  x,y: integer;
 end;
 pxpointfixedty = ^xpointfixedty;
 
 mountaininfoty = record
  chain: pointarty;
 end;
 mountaininfoarty = array of mountaininfoty;
 
 trity = record
  p: array[0..2] of pointty;
 end;
 triarty = array of trity;

 tmainfo = class(tmainform)
   grid: twidgetgrid;
   smoothed: tbooleanedit;
   projectstat: tstatfile;
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
   noaed: tbooleanedit;
   nobed: tbooleanedit;
   findxed: tintegeredit;
   findyed: tintegeredit;
   tbutton2: tbutton;
   projectfile: tfilenameedit;
   tbutton3: tbutton;
   mainstat: tstatfile;
   tbutton4: tbutton;
   angdisp: tintegerdisp;
   tridisped: tbooleanedit;
   numdisped: tbooleanedit;
   sated: tintegeredit;
   procedure datentexe(const sender: TObject);
   procedure paintexe(const sender: twidget; const acanvas: tcanvas);
   procedure setpointexe(const sender: TObject; var avalue: complexarty;
                   var accept: Boolean);
   procedure layoutexe(const sender: TObject);
   procedure triangexe(const sender: TObject);
   procedure tripaexe(const sender: twidget; const acanvas: tcanvas);
   procedure findedexe(const sender: TObject);
   procedure destroyexe(const sender: TObject);
   procedure filenamesetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure saveasexe(const sender: TObject);
   procedure statwriteexe(const sender: TObject; const writer: tstatwriter);
   procedure saveexe(const sender: TObject);
  private
   ftraps: array of trapdispinfoty;
   fdiags: segmentarty;
   fmountains: mountaininfoarty;
   ftriangles: triarty;
   procedure invalidisp;
   function polyvalues: pointarty;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msearrayutils,msenoise,mseformatstr,sysutils,msedrawtext,
 msepolytria;
var 
 testvar,testvar1,testvar2,testvar3,testvar4,testvar5,testvar6,
 testvar7,testvar8: integer;

function angdelta(const a,b,c: pointty): integer; forward;

procedure tmainfo.invalidisp;
var
 ar1: pointarty;
begin
 polydisp.invalidate;
 tridisp.invalidate;
 if grid.rowcount >= 3 then begin
  ar1:= polyvalues;
  angdisp.value:= angdelta(ar1[0],ar1[1],ar1[2]);
 end
 else begin
  angdisp.value:= 0;
 end;
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
  result:= ppointty(l)-ppointty(r);
 end;
end;

type
 trapnodekindty = (tnk_y,tnk_x,tnk_trap);
 segdirty = (sd_none,sd_same,sd_up,sd_down,sd_left,sd_right);
 xposty = (xp_left,xp_center,xp_right);


 ptrapinfoty = ^trapinfoty;
 pseginfoty = ^seginfoty;
 ptrapnodeinfoty = ^trapnodeinfoty;

 trapinfoty = record
  top,bottom: ppointty;  
  left,right: pseginfoty;
  node: ptrapnodeinfoty;
  above,abover,below,belowr: ptrapinfoty; //above,below = single or left
 end;
 
 segflagty = (sf_pointhandled,sf_reverse); //sf_reverse -> b below a
 segflagsty = set of segflagty;
 ppseginfoty = ^pseginfoty;
 segheaderty = record
  previous: pseginfoty;
  next: pseginfoty;
  b: ppointty;            //a is in previous segment
 end;
 seginfoty = record
  h: segheaderty;
  flags: segflagsty;
  dx,dy: integer;         //a-b
  trap: ptrapinfoty;      //inserted trap for b
  splitseg: pseginfoty;   //segment for horizontal split at b
  diags: array[0..2] of pseginfoty;
 end;
 
 trapnodeinfoty = record
  p,l,r: ptrapnodeinfoty; //parent,left,right
  case kind: trapnodekindty of
   tnk_y: (y: ppointty);
   tnk_x: (seg: pseginfoty);
   tnk_trap: (trap: ptrapinfoty);
 end;
{
 diaginfoty = record
  baseb,baset: pseginfoty;      //bottom,top
  closeb,closet: segheaderty;   //bottom,top
  bottomup: boolean;
 end;
 pdiaginfoty = ^diaginfoty;
}

 trianglety = array[0..2] of xpointfixedty;
 ptrianglety = ^trianglety;
 pmountainpointty = ^mountainpointty;
 mountainpointty = record
  p: ppointty;
  prev: pmountainpointty; 
  next: pmountainpointty;
 end;
const
 trapcountfact = 4;    //todo: check maximal buffer size
 nodecountfact = 8;
 mountaincountfact = 1;
 trianglecountfact = 1;
 trapsize = sizeof(trapinfoty)*trapcountfact;
 trapnodesize = sizeof(trapnodeinfoty)*nodecountfact;
 mountainsize = (3 * sizeof(mountainpointty)) * mountaincountfact;
                        //worst case
 trianglesize = sizeof(trianglety) * trianglecountfact;
 firstsize = trapsize+trapnodesize;
 secondsize = mountainsize+trianglesize;
{$if secondsize > firstsize}
 {$error 'mountain-triangles memory overflow'}
{$endif}

var
 traps: ptrapinfoty;
 segments: pseginfoty;
 points: ppointty;
 npoints: integer;
// diags: pdiaginfoty;

function calcx(const y: integer; const seg: seginfoty): integer;
var
 int1: integer;
begin
 with seg do begin
  if dy = 0 then begin
   int1:= y - h.b^.y;
   if int1 > 0 then begin
    result:= bigint;
   end
   else begin
    if int1 = 0 then begin
     result:= h.b^.x;
     exit;
    end
    else begin
     result:= -bigint;
    end;
   end;
   result:= result * dx;
  end
  else begin
   result:= h.b^.x + (y - h.b^.y) * dx div dy;
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
   if y < seg^.h.b^.y then begin
    result:= -bigint;
   end;
   result:= result*dx;
  end
  else begin
   result:= h.b^.x + ((y - h.b^.y)*dx) div dy;
  end;
 end;
end;

type
 trapdumpinfoty = record
  t: ptrapinfoty;
  index: integer;
 end;
 
function cmptrap(const l,r): integer;
var
 y: integer;
begin
 result:= 0;
 y:= 0;
 if trapdumpinfoty(l).t^.top = nil then begin
  if trapdumpinfoty(r).t^.top <> nil then begin
   result:= -1;
  end;
 end
 else begin
  if trapdumpinfoty(r).t^.top = nil then begin
   result:= 1;
  end
  else begin
   y:= trapdumpinfoty(r).t^.top^.y;
   result:= trapdumpinfoty(l).t^.top^.y - y;
   if result = 0 then begin
    result:= trapdumpinfoty(l).t^.top-trapdumpinfoty(r).t^.top;
   end;
  end;
 end;
 if result = 0 then begin
  if trapdumpinfoty(l).t^.left = nil then begin
   if trapdumpinfoty(r).t^.left <> nil then begin
    result:= -1;
   end;
  end
  else begin
   if trapdumpinfoty(r).t^.left = nil then begin
    result:= 1;
   end
   else begin
    result:= calcx(trapdumpinfoty(l).t^.left,y) - 
                      calcx(trapdumpinfoty(r).t^.left,y);
    if result = 0 then begin
     if trapdumpinfoty(r).t^.right = nil then begin
      result:= -1;
     end;
     if trapdumpinfoty(l).t^.right = nil then begin
      inc(result);
     end;
    end;     
   end;
  end;
 end;
end;

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
        pointval(seg1^.h.b),' ',pointval(seg^.h.b),' ',
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
     writeln('(',inttostr(n^.trap-atraps),')$',hextostr(ptruint(n)));
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

var
 dumperror: boolean;

procedure dumptraps(const atraps: ptrapinfoty; const acount: integer;
                    const caption: string; const noerr: boolean);
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
 end; //trapval

 procedure getpoints(const seg: pseginfoty; out top,bottom: ppointty);
 var
  seg1: pseginfoty;
 begin
testvar:= seg-segments;
  top:= nil;
  bottom:= nil;
  if seg <> nil then begin
   seg1:= seg-1;
   if seg1 < segments then begin
    inc(seg1,npoints);
   end;
testvar1:= seg1-segments;
   if sf_reverse in seg^.flags then begin
    top:= seg^.h.b;
    bottom:= seg1^.h.b;
   end
   else begin
    top:= seg1^.h.b;
    bottom:= seg^.h.b;
   end;
  end;
 end; //getpoints

type
 pointposty = (pp_none,pp_left,pp_right,pp_both);
 
 function pointpos(const p: ppointty; 
                         const left,right: ppointty): pointposty;
 begin
  result:= pp_none;
  if p = left then begin
   result:= pp_left;
   if p = right then begin
    result:= pp_both;
   end;
  end
  else begin
   if p = right then begin
    result:= pp_right;
   end;
  end;
 end; //pointpos
 
 function pointpostop(const trap: ptrapinfoty): pointposty;
 var
  lefttop,leftbottom,righttop,rightbottom: ppointty;
 begin
  with trap^ do begin
   getpoints(left,lefttop,leftbottom);
   getpoints(right,righttop,rightbottom);
   result:= pointpos(top,lefttop,righttop);
  end;
 end;

 function pointposbottom(const trap: ptrapinfoty): pointposty;
 var
  lefttop,leftbottom,righttop,rightbottom: ppointty;
 begin
  with trap^ do begin
   getpoints(left,lefttop,leftbottom);
   getpoints(right,righttop,rightbottom);
   result:= pointpos(bottom,leftbottom,rightbottom);
  end;
 end;

var
 error: boolean;

 procedure seterror;
 begin
  if not noerr then begin
   error:= true;
  end;
 end;
  
var
 int1: integer;
 lt,lb,rt,rb,t,b: integer;
 toterror: boolean;
 trap1: ptrapinfoty;

begin
 setlength(ar1,acount);
 for int1:= 0 to high(ar1) do begin
  ar1[int1].t:= atraps+int1;
  ar1[int1].index:= int1;
 end;
 sortarray(ar1,sizeof(trapdumpinfoty),@cmptrap,ar2);
 writeln('------------------------------------------------------- '+caption);
 writeln('  T     t     b    tl    tr    bl    br   A  AR   B  BR');
 toterror:= false;
 for int1:= 0 to high(ar1) do begin
  trap1:= ar1[int1].t;
  with trap1^ do begin
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
   write(rstring(inttostr(ar1[int1].index),3),' ',
        intvaly(t),' ',intvaly(b),' ',
        intvalx(lt),' ',intvalx(rt),' ',intvalx(lb),' ',intvalx(rb),' ',
        trapval(above),' ',trapval(abover),' ',
        trapval(below),' ',trapval(belowr));
   error:= false;
     
   if above <> nil then begin
    case pointpostop(trap1) of
     pp_left: begin
      case pointposbottom(above) of
       pp_left: begin
        if (above^.below <> trap1) or (above^.belowr <> nil) then begin
         seterror;
        end;
       end;
       pp_none: begin
        if (above^.belowr <> trap1) or (above^.below = trap1) then begin
         seterror;
        end;
       end;
       else begin
        seterror;
       end;
      end;
     end;
     pp_right: begin
      case pointposbottom(above) of
       pp_right: begin
        if (above^.below <> trap1) or (above^.belowr <> nil) then begin
         seterror;
        end;
       end;
       pp_none: begin
        if (above^.below <> trap1) or (above^.belowr = trap1) then begin
         seterror;
        end;
       end;
       else begin
        seterror;
       end;
      end;
     end;
     pp_none: begin
      case pointposbottom(above) of
       pp_right: begin
        if (abover = nil) or (abover^.below <> trap1) then begin
         seterror;
        end;
       end;
       pp_none: begin
        if (above^.below <> trap1) or (above^.belowr <> nil) then begin
         seterror;
        end;
       end;
      end;
     end;
    end;
    if abover <> nil then begin
     case pointpostop(trap1) of
      pp_none: begin
       if (abover^.below <> trap1) or (abover^.belowr <> nil) then begin
        seterror;
       end;
      end;
      else begin
       seterror;
      end;
     end;
    end;
   end
   else begin
    if abover <> nil then begin
     seterror;
    end;
   end;
   
   if below <> nil then begin
    case pointposbottom(trap1) of
     pp_left: begin
      case pointpostop(below) of
       pp_left: begin
        if (below^.above <> trap1) or (below^.abover <> nil) then begin
         seterror;
        end;
       end;
       pp_none: begin
        if (below^.abover <> trap1) or (below^.above = nil) then begin
         seterror;
        end;
       end;
       else begin
        seterror;
       end;
      end;
     end;
     pp_right: begin
      case pointpostop(below) of
       pp_right: begin
        if (below^.above <> trap1) or (below^.abover <> nil) then begin
         seterror;
        end;
       end;
       pp_none: begin
        if (below^.above <> trap1) or (below^.abover = nil) then begin
         seterror;
        end;
       end;
       else begin
        seterror;
       end;
      end;
     end;
     pp_none: begin
      case pointpostop(below) of
       pp_right,pp_none: begin
        if (below^.above <> trap1) or (below^.abover <> nil) then begin
         seterror;
        end;
       end;
       else begin
        seterror;
       end;
      end;
     end;
    end;
    if belowr <> nil then begin
     case pointposbottom(trap1) of
      pp_none: begin
       case pointpostop(belowr) of
        pp_left: begin
         if (belowr^.above <> trap1) or (belowr^.abover <> nil) then begin
          seterror;
         end;
        end;
        else begin
         seterror;
        end;
       end;
      end;
      else begin
       seterror;
      end;
     end; 
    end;
   end
   else begin
    if belowr <> nil then begin
     seterror;
    end;
   end; 
   if error then begin
    writeln(' *');
    toterror:= true;
   end
   else begin
    writeln;
   end;
  end;
 end;
 if toterror then begin
  writeln('                                               ***error***');
  dumperror:= true;
 end;
end;

procedure dump(const atraps: ptrapinfoty; const ntraps: integer;
            const anodes: ptrapnodeinfoty; const caption: string;
            const noerr: boolean);
begin
 dumperror:= false;
 dumptraps(atraps,ntraps,caption,noerr);
 writeln;
 dumpnodes(anodes,atraps);
end;

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
var
 int1: integer;
begin
 if ref^.dy = 0 then begin
  result:= point^.y - ref^.h.b^.y;
  if result = 0 then begin
   if ref = segments then begin
    int1:= npoints-1;
   end
   else begin
    int1:= 1;
   end;
   if not (sf_reverse in ref^.flags) then begin
    int1:= -int1;
   end;
   result:= int1*(point^.x - ref^.h.b^.x) - (point-ref^.h.b)*ref^.dx;
   if not (sf_reverse in ref^.flags) then begin
    result:= -result;
   end;
  end
  else begin
   if not (sf_reverse in ref^.flags) then begin //??????
    result:= -result;
   end;
  end;
 end
 else begin
//  result:= point^.x -(ref^.h.b^.x + (point^.y-ref^.h.b^.y)*ref^.dx div ref^.dy);
  result:= ref^.dy*(point^.x - ref^.h.b^.x) - (point^.y-ref^.h.b^.y)*ref^.dx;
  if ref^.dy < 0 then begin
   result:= -result;
  end;
 end;
end;
{
function xpos(const point: ppointty; ref: pseginfoty): xposty;
var
 int1: integer;
begin
 int1:= xdist(point,ref);
 result:= xp_left;
 if int1 = 0 then begin
  result:= xp_center;
 end
 else begin
  if int1 > 0 then begin
   result:= xp_right;
  end;
 end;
end;
}
function isright(const point: ppointty; ref: pseginfoty): boolean;
 //true if point right of segment
begin
// result:= xpos(point,ref) = xp_right;
 result:= xdist(point,ref) >= 0;
end;

function segdirdown(const seg,ref: pseginfoty): segdirty;
var
 segcommon: pseginfoty;
 ptseg,ptref: ppointty;
begin
 if seg = ref then begin
  result:= sd_same;
 end
 else begin
  segcommon:= seg^.h.previous;
  if segcommon = ref then begin
   ptseg:= seg^.h.b;
   ptref:= ref^.h.previous^.h.b;
  end
  else begin
   segcommon:= ref^.h.previous;
   if segcommon = seg then begin
    ptseg:= seg^.h.previous^.h.b;
    ptref:= ref^.h.b;
   end
   else begin
    result:= sd_none;
    exit;
   end;
  end;
testvar1:= seg-segments;
testvar2:= ref-segments;
testvar3:= ptseg-points;
testvar4:= ptref-points;
  if isbelow(segcommon^.h.b,ptseg) then begin
   result:= sd_up;
  end
  else begin
   result:= sd_left;
   if ptseg^.x = ptref^.x then begin
    if isbelow(ptseg,ptref) then begin
     result:= sd_right;
    end;
   end
   else begin
    if seg^.dy = 0 then begin
     if ref^.dy = 0 then begin
      if ptref^.x-segcommon^.h.b^.x < 0 then begin
       if ptseg^.x-segcommon^.h.b^.x > 0 then begin
        result:= sd_right;
       end
       else begin
        if isbelow(ptseg,ptref) then begin
         result:= sd_right;
        end;
       end;
      end
      else begin
       if ptseg^.x-segcommon^.h.b^.x > 0 then begin
        if isbelow(ptref,ptseg) then begin
         result:= sd_right;
        end;
       end;
      end;
     end
     else begin
      if ptseg^.x-segcommon^.h.b^.x >= 0 then begin
       result:= sd_right;
      end;
     end;
    end
    else begin
     if ref^.dy = 0 then begin
      if ptref^.x-segcommon^.h.b^.x < 0 then begin
       result:= sd_right;
      end;
     end
     else begin
      if (seg^.dx*ref^.dy < ref^.dx*seg^.dy) xor 
       not((sf_reverse in ref^.flags) xor (sf_reverse in seg^.flags)) then begin 
  //                not((ref^.dy < 0) xor (seg^.dy < 0)) then begin 
                          //direction of one segment reversed
       result:= sd_right;
      end;
     end;
    end;
   end;
  end;
 end;
end;
var
 nodes: ptrapnodeinfoty;
 pointsar: pointarty;
 nodescopy: ptrapnodeinfoty = nil;
 
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
    if int1 > 0 then begin
     no2:= no1^.r;
    end;
   end;
  end;
  no1:= no2;
 end;
writeln(' found trap ',result-traps);
end;

var
 buffer: pointer;

function angdelta(const a,b,c: pointty): integer;
    //>0 -> ccw, a.y <= b.y <= c.y
var
 dx1,dy1,dx2,dy2: integer;

 procedure calctandiff;
 begin
  dy1:= b.y - a.y;
  dy2:= c.y - b.y;
  result:= dx2*dy1 - dx1*dy2; //y is top-down
 end; //calctandiff

begin
 dx1:= b.x - a.x;
 dx2:= c.x - b.x;
 if dx1 >= 0 then begin
  if dx2 < 0 then begin
   if c.y-a.y < 0 then begin
    result:= 1;
   end
   else begin
    result:= -1;
   end;
  end
  else begin
   calctandiff;
  end;
 end
 else begin
  if dx2 > 0 then begin
   if c.y-a.y < 0 then begin
    result:= -1;
   end
   else begin
    result:= 1;
   end;
  end
  else begin
   calctandiff;
  end;
 end;
end;

procedure tmainfo.triangexe(const sender: TObject);
// x,y range = $7fff..-$8000 (16 bit X11 space)
var
 shuffle: ppseginfoty;
 newtraps: ptrapinfoty;
 newnodes: ptrapnodeinfoty;

 function newtrap: ptrapinfoty;
 begin
  result:= newtraps;
  inc(newtraps);
  result^.above:= nil;
  result^.abover:= nil;
  result^.below:= nil;
  result^.belowr:= nil;
  result^.node:= nil;
 end;
 
 function newnode: ptrapnodeinfoty;
 begin
  result:= newnodes;
  inc(newnodes);
 end;

var
 toptrap: ptrapinfoty = nil;
 
 procedure finddiags;
 
   function checkdiag(const atrap: ptrapinfoty; const up: boolean): boolean; 
                //false if error or triangle
   var
    topseg,bottomseg,lefta,righta: pseginfoty;
   begin
    result:= true;
    with atrap^ do begin
     if (atrap = nil) or (left = nil) or (right = nil) or 
              (top = nil) or (bottom = nil) then begin //segment crossing
      result:= false;
      exit;
     end;
     lefta:= left^.h.previous;
     righta:= right^.h.previous;
     if (left = righta) and (up xor (left^.h.b = bottom)) or 
        (right = lefta) and (up xor (right^.h.b = bottom)) then begin //triangle
      result:= false;
     end;   
     if not((top = left^.h.b) and (bottom = lefta^.h.b) or
            (bottom = left^.h.b) and (top = lefta^.h.b) or
            (top = right^.h.b) and (bottom = righta^.h.b) or
            (bottom = right^.h.b) and (top = righta^.h.b)) then begin
      topseg:= segments+(top-points);
      bottomseg:= segments+(bottom-points);
      with topseg^ do begin
       if diags[0] <> nil then begin
        if diags[1] <> nil then begin
         diags[2]:= bottomseg;
        end
        else begin
         diags[1]:= bottomseg;
        end;
       end
       else begin
        diags[0]:= bottomseg;
       end;
      end;
      with bottomseg^ do begin
       if diags[0] <> nil then begin
        if diags[1] <> nil then begin
         diags[2]:= topseg;
        end
        else begin
         diags[1]:= topseg;
        end;
       end
       else begin
        diags[0]:= topseg;
       end;
      end;
     end;
    end;
   end; //checkdiag
 
  procedure findup(const atrap: ptrapinfoty); forward;
  
  procedure finddown(const atrap: ptrapinfoty);
  var
   tr1: ptrapinfoty;
  begin
   tr1:= atrap;
   while checkdiag(tr1,false) do begin
    with tr1^ do begin
     if belowr <> nil then begin
      finddown(belowr);
     end;
     if below^.above = tr1 then begin
      if below^.abover <> nil then begin
       findup(below^.abover);
      end;
     end
     else begin
      findup(below^.above);
     end;
     tr1:= below;
    end;
   end;  
  end; //finddown
 
  procedure findup(const atrap: ptrapinfoty);
  var
   tr1: ptrapinfoty;
  begin
   tr1:= atrap;
   while checkdiag(tr1,true) do begin
    with tr1^ do begin
     if abover <> nil then begin
      findup(abover);     
     end;
     if above^.below = tr1 then begin
      if above^.belowr <> nil then begin
       finddown(above^.belowr);
      end;
     end
     else begin
      finddown(above^.below);
     end;
     tr1:= above;
    end;
   end;  
  end; //findup
   
 begin
  finddown(toptrap);
 end; //finddiags

 function newnode(const atrap: ptrapinfoty; 
                     const aparent: ptrapnodeinfoty): ptrapnodeinfoty;
 begin
  result:= newnodes;
  inc(newnodes);
  result^.kind:= tnk_trap;
  result^.trap:= atrap;
  result^.p:= aparent;
  atrap^.node:= result;
 end; //newnode
   
 procedure handlepoint(const seg: pseginfoty);
 var
  tplower,tpupper,tpbelow,tpbelowr: ptrapinfoty;
  no1,nol,nor: ptrapnodeinfoty;
  ppt1: ppointty;
 begin
  ppt1:= seg^.h.b;
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
 end; //handlepoint

var
 segcounter: integer;
 
 procedure handlesegment(const aseg: pseginfoty);

  procedure splitnode(const newright: boolean; const ltrap,rtrap: ptrapinfoty);
  var
   noabove,noleft,noright: ptrapnodeinfoty;
  begin
   if newright then begin
    noabove:= ltrap^.node;
    noleft:= newnode(ltrap,noabove);
    noright:= rtrap^.node;
    if noright = nil then begin //new trap
     noright:= newnode(rtrap,noabove);
    end;
   end
   else begin
    noabove:= rtrap^.node;
    noright:= newnode(rtrap,noabove);
    noleft:= ltrap^.node;
    if noleft = nil then begin //new trap
     noleft:= newnode(ltrap,noabove);
    end;
   end;
   with noabove^ do begin
    l:= noleft;           // (Tb) ->     (s)
    r:= noright;          //         (Tl)   (Tr)
    kind:= tnk_x;
    seg:= aseg;
   end;
  end; //splitnode horz

  var
   bottompoint: ppointty;

  procedure updatebelow(const newright: boolean; const trold,trnew: ptrapinfoty);
  var
   aisright: boolean;
   seg1: pseginfoty;
  begin
   if trold^.below = nil then begin
    exit; //crossing
   end;

   if newright then begin
    seg1:= trold^.right;
   end
   else begin
    seg1:= trold^.left;
   end;
testvar1:= trold-traps;
testvar2:= trnew-traps;
testvar3:= trold^.below-traps;
testvar4:= trold^.belowr-traps;
testvar5:= trold^.above-traps;
testvar6:= trold^.abover-traps;
testvar7:= trold^.below^.above-traps;
testvar8:= trold^.below^.abover-traps;
   if trold^.below^.top = bottompoint then begin  //last
    if trold^.belowr <> nil then begin            //existing segment below
     if newright then begin
      trnew^.below:= trold^.belowr;
      trnew^.below^.above:= trnew;
     end
     else begin
      trnew^.below:= trold^.below;
      trold^.below^.above:= trnew;
      trold^.below:= trold^.belowr;
     end;
     trold^.belowr:= nil;
     trnew^.belowr:= nil;
    end
    else begin      
     if trold^.below^.abover <> nil then begin     //existing segment above
      trnew^.below:= trold^.below;
      if (trold^.below^.above = trold) xor newright then begin 
             //existing trap is not on new side
       if newright then begin
        trold^.below^.abover:= trnew;
       end
       else begin
        trold^.below^.above:= trnew;
       end;
      end;
     end
     else begin                           //no existing segment
      trnew^.below:= trold^.below;
      with trold^.below^ do begin
       if newright then begin
        abover:= trnew;
       end
       else begin
        above:= trnew;
        abover:= trold;
       end;
      end;
     end;
    end;
   end
   else begin //not last
    aisright:= isright(trold^.below^.top,seg1);
    if trold^.belowr = nil then begin //no existing segment below
     trnew^.below:= trold^.below;
     with trold^.below^ do begin
      if abover = nil then begin  //single trap above
       if newright then begin
        abover:= trnew;
       end
       else begin
        abover:= trold;
        above:= trnew;
       end;
      end
      else begin
       if aisright then begin
        if newright then begin
         above:= trnew;
        end;
       end
       else begin
        if not newright then begin
         abover:= trnew;
        end;
       end;
      end;
     end;
    end
    else begin                           //existing segment below
     if aisright then begin
      trnew^.below:= trold^.below;
      if newright then begin
       trnew^.belowr:= trold^.belowr;
       trnew^.below^.above:= trnew;
       trold^.belowr^.above:= trnew;
       trold^.belowr:= nil;
      end;
     end
     else begin
      if newright then begin
       trnew^.below:= trold^.belowr;
      end
      else begin
       trnew^.below:= trold^.below;
       trnew^.below^.above:= trnew;
       trnew^.belowr:= trold^.belowr;
       trnew^.belowr^.above:= trnew;
       trold^.below:= trold^.belowr;
       trold^.belowr:= nil;
      end;
     end;
    end;
   end;
  end; //updatebelow
    
  procedure splittrap(const newright: boolean; const old: ptrapinfoty;
                              var left,right,trnew: ptrapinfoty);
  var
   trabove: ptrapinfoty;
   trabover: ptrapinfoty;
  begin
   trnew:= newtrap;
   trabove:= old^.above;
   trabover:= old^.abover;
   trnew^.top:= old^.top;
   trnew^.bottom:= old^.bottom;
   trnew^.left:= old^.left;
   trnew^.right:= old^.right;
   trnew^.above:= trabove;
   if newright then begin
    old^.right:= aseg;
    trnew^.left:= aseg;
    right:= trnew;
    left:= old;
    old^.abover:= nil;
   end
   else begin
    old^.left:= aseg;
    trnew^.right:= aseg;
    right:= old;
    left:= trnew;
    if old^.abover <> nil then begin
     old^.above:= old^.abover;
     old^.abover:= nil;
    end;
   end;
   updatebelow(newright,old,trnew);
   left^.above:= trabove;
   if trabover = nil then begin //no existing segment above
    right^.above:= trabove;
    if newright or (trabove^.belowr = nil) then begin //first segment
     trabove^.belowr:= right;
    end
    else begin
     if not newright then begin
      trabove^.below:= left;
     end;
    end;
   end
   else begin
    trabove^.below:= left;
    right^.above:= trabover;
    trabover^.below:= right;
   end;
   splitnode(newright,left,right);
  end; //splittrap
  
 var
  sd1: segdirty;
  sega,segb: pseginfoty;
  trap1,trap2,trap1l,trap1r,trbelow,trbelowr,exttrap: ptrapinfoty;
  isright1: boolean;
  
 begin
  if sf_reverse in aseg^.flags then begin
   sega:= aseg;
   segb:= aseg^.h.previous;
  end
  else begin
   segb:= aseg;
   sega:= aseg^.h.previous;
  end;
  bottompoint:= segb^.trap^.top;
  if sega^.splitseg = nil then begin //no existing edge
   isright1:= false;
   splittrap(true,sega^.trap,trap1l,trap1r,trap1);
   sega^.splitseg:= aseg;
  end
  else begin
   trap1:= sega^.trap;
   sd1:= segdirdown(sega^.splitseg,aseg);
   case sd1 of
    sd_up: begin //existing edge above
     if trap1^.below = nil then begin
      exit; //error
     end;
     isright1:= isright(trap1^.below^.top,aseg);
    end;
    sd_right: begin
     if trap1^.above = nil then begin
      exit; //error
     end;
     trap1:= trap1^.above^.below;
     isright1:= true;
     if (trap1^.above = traps) then begin
      toptrap:= trap1;
     end;
    end;
    else begin
     if trap1^.above = nil then begin
      exit; //error
     end;
     trap1:= trap1^.above^.belowr;
     isright1:= false;
     if (trap1^.above = traps) then begin
      toptrap:= trap1;
     end;
    end;
   end;
   splittrap(not isright1,trap1,trap1l,trap1r,trap1);
  end;

dump(traps,newtraps-traps,nodes,'segment0',true);
testvar1:= trap1l-traps;
testvar2:= trap1r-traps;
testvar4:= segb^.trap-traps;

if not ((segcounter = stoped.value) and nosegbed.value) then begin
  while trap1^.below <> nil do begin
   trap2:= trap1^.below;
   if trap2^.top = bottompoint then begin
    break;
   end;
   isright1:= isright(trap2^.top,aseg); //point right of segment   
   if (trap1^.belowr <> nil) and not isright1 then begin
    trap2:= trap1^.belowr;
   end;
   trbelow:= trap2^.below;
   trbelowr:= trap2^.belowr;
   
                               //split crossed lines by segment
testvar1:= trap1-traps;
testvar2:= trap2-traps;      
testvar3:= trap1l-traps;
testvar4:= trap1r-traps;
testvar5:= trbelow-traps;
testvar6:= trbelowr-traps;

   if isright1 then begin                 
    exttrap:= trap1l;
    trap2^.left:= aseg;               //move edge to right
    if trap2^.above = exttrap then begin
     trap2^.above:= trap2^.abover;
     trap2^.abover:= nil;
    end;
    trap1l^.bottom:= trap2^.bottom;
    trap1r:= trap2;
    trap1l^.below:= trbelow;
    trap1l^.belowr:= trbelowr;
   end
   else begin
    exttrap:= trap1r;
    trap2^.right:= aseg;              //move edge to left
    if trap2^.abover = exttrap then begin
     trap2^.abover:= nil;
    end;
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
   updatebelow(not isright1,trap2,exttrap);
   splitnode(not isright1,trap1l,trap1r);
   trap1:= trap2;
  end;
end;
  segb^.splitseg:= aseg;

dump(traps,newtraps-traps,nodes,'segment1',false);
 end;

var
 int1,int2: integer;
 seg1,seg2: pseginfoty;
 sizetraps,sizenodes: integer;
 ppt1,ppt2: ppointty;
 bo1: boolean;
 triangles,newtriangle: ptrianglety;
 newmountain: pmountainpointty;
 
 procedure findmountains(const aseg: pseginfoty; const first: boolean);
 var
  seg1,seg2: pseginfoty; 
  int1: integer;
  start: pmountainpointty;
  rightside,bottomup: boolean;
  pttop,ptbottom,pt1,pt2: pmountainpointty;
  dy,dx: integer;
  searchcount: integer;
 begin
  start:= newmountain;
  seg1:= aseg;
  repeat
   with seg1^ do begin
    newmountain^.prev:= newmountain-1;
    newmountain^.next:= newmountain+1;
    newmountain^.p:= h.b;
    inc(newmountain);
    seg2:= nil;
    int1:= 0;
    if diags[0] <> nil then begin
     seg2:= diags[0];
    end;
    if (seg2 <> aseg) and ((diags[1] > seg2) or (diags[1] = aseg)) then begin
     seg2:= diags[1];
     int1:= 1;
    end;
    if (seg2 <> aseg) and ((diags[2] > seg2)  or (diags[2] = aseg)) then begin
     seg2:= diags[2];
     int1:= 2;
    end;
    if seg2 <> nil then begin
     diags[int1]:= nil; //eat
     if seg2 <> aseg then begin //new mountain
setlength(fdiags,high(fdiags)+2);
with fdiags[high(fdiags)] do begin
a:= seg1^.h.b^;;
b:= seg2^.h.b^;
end;
      findmountains(seg1,false);
     end;
     seg1:= seg2;
    end
    else begin
     seg1:= seg1^.h.next;
    end;
   end;
  until seg1 = aseg;

setlength(fmountains,high(fmountains)+2);
with fmountains[high(fmountains)] do begin
 setlength(chain,newmountain-start);
 for int1:= 0 to high(chain) do begin
  chain[int1]:= start[int1].p^;
 end;
end;

  dec(newmountain); //last
  start^.prev:= nil;
  newmountain^.next:= nil;
  ptbottom:= start;
  pttop:= start;
  pt1:= start;
  repeat
   if isbelow(pt1^.p,ptbottom^.p) then begin
    ptbottom:= pt1;
   end;
   if isbelow(pttop^.p,pt1^.p) then begin
    pttop:= pt1;
   end;
   pt1:= pt1^.next;
  until pt1 = nil;   
  start^.prev:= newmountain;
  newmountain^.next:= start;
  if ptbottom^.next = pttop then begin
   ptbottom^.next:= nil;
   pttop^.prev:= nil;
  end
  else begin
   pttop^.next:= nil;
   ptbottom^.prev:= nil;
  end;
  if pttop^.p^.y <> ptbottom^.p^.y then begin //not empty
   bottomup:= ptbottom^.prev = nil;
   if bottomup then begin
    pt1:= ptbottom^.next;
   end
   else begin
    pt1:= pttop^.next;
   end;
   pt2:= pt1;
   int1:= 0;
   dx:= pttop^.p^.x - ptbottom^.p^.x;
   dy:= pttop^.p^.y - ptbottom^.p^.y; //always negative
   repeat
    int1:= dy*(pt1^.p^.x - pttop^.p^.x) - (pt1^.p^.y-pttop^.p^.y)*dx;
    pt1:= pt1^.next;
   until (int1 <> 0) or (pt1 = nil);
   if int1 <> 0 then begin //not empty
    rightside:= int1 < 0;
    pt1:= pt2;
    bo1:= false;
    searchcount:= 0;
    while searchcount < 4 do begin //else error
     int1:= angdelta(pt1^.prev^.p^,pt1^.p^,pt1^.next^.p^);
     if int1 <> 0 then begin  //not empty
      if (int1 > 0) xor rightside xor bottomup then begin //cut ear
       searchcount:= 0;
       with pt1^.prev^.p^ do begin
        pxpointfixedty(newtriangle)^.x:= x*65536;
        pxpointfixedty(newtriangle)^.y:= y*65536;
       end;
       inc(pxpointfixedty(newtriangle));
       with pt1^.p^ do begin
        pxpointfixedty(newtriangle)^.x:= x*65536;
        pxpointfixedty(newtriangle)^.y:= y*65536;
       end;
       inc(pxpointfixedty(newtriangle));
       with pt1^.next^.p^ do begin
        pxpointfixedty(newtriangle)^.x:= x*65536;
        pxpointfixedty(newtriangle)^.y:= y*65536;
       end;
       inc(pxpointfixedty(newtriangle));
      end
      else begin       //no ear, try next
       if bo1 then begin
        pt1:= pt1^.prev;
        if pt1^.prev = nil then begin
         inc(searchcount);
         pt1:= pt1^.next;
         bo1:= false;
        end;
       end
       else begin
        pt1:= pt1^.next;
        if pt1^.next = nil then begin
         inc(searchcount);
         pt1:= pt1^.prev;
         bo1:= true;
        end;
       end;
       continue;
      end;
     end;
     pt1^.prev^.next:= pt1^.next; //delete node
     pt1^.next^.prev:= pt1^.prev;
     pt1:= pt1^.prev;
     if pt1^.prev = nil then begin
      pt1:= pt1^.next;
      if pt1^.next = nil then begin
       break;                    //finished
      end;
     end;
    end;
   end;
  end;
  newmountain:= start; //restore

setlength(ftriangles,newtriangle-triangles);
for int1:= 0 to high(ftriangles) do begin
 with ftriangles[int1] do begin
  p[0].x:= triangles[int1][0].x div 65536;
  p[0].y:= triangles[int1][0].y div 65536;
  p[1].x:= triangles[int1][1].x div 65536;
  p[1].y:= triangles[int1][1].y div 65536;
  p[2].x:= triangles[int1][2].x div 65536;
  p[2].y:= triangles[int1][2].y div 65536;
 end;
end;

 end; //findmountains
var
 noisestate: mwcinfoty;   
begin
 noisestate.fw:= $a91b43f5; //"random" seed
 noisestate.fz:= $730c9a26; //"random" seed
 if grid.rowcount > 1 then begin
  pointsar:= polyvalues;
  npoints:= length(pointsar);
  points:= pointer(pointsar);
 
  sizetraps:= npoints*trapsize;
  sizenodes:= npoints*trapnodesize;
  if buffer <> nil then begin
   freemem(buffer);
  end;
  getmem(buffer,npoints*(sizeof(seginfoty)+sizeof(pseginfoty)) + 
                                                sizetraps + sizenodes);
  segments:= buffer;
  shuffle:= pointer(segments+npoints);
  traps:= pointer(shuffle+npoints);
  nodes:= pointer(traps)+sizetraps;
  ppt1:= points;            //b
  ppt2:= points+npoints-1;  //a
  seg1:= segments;
  for int1:= npoints-1 downto 0 do begin //init segments
   shuffle[int1]:= seg1;
   with seg1^ do begin
    h.previous:= seg1-1;
    h.next:= seg1+1;
    splitseg:= nil;
    trap:= nil;
    flags:= [];
    diags[0]:= nil;
    diags[1]:= nil;
    diags[2]:= nil;
    
    h.b:= ppt1;
    dx:= ppt2^.x-ppt1^.x; //b->a slope
    dy:= ppt2^.y-ppt1^.y; //b->a slope
    if dy = 0 then begin
     if ppt2 > ppt1 then begin
      include(flags,sf_reverse);
     end;
    end
    else begin
     if dy > 0 then begin
      include(flags,sf_reverse);
     end;      
    end;
    ppt2:= ppt1;
    inc(ppt1);
   end;
   inc(seg1);
  end;
  segments^.h.previous:= segments + npoints - 1;
  (segments+npoints-1)^.h.next:= segments;
  for int1:= npoints-1 downto 0 do begin //shuffle segments
   int2:= mwcnoise(noisestate) mod npoints;
   seg1:= shuffle[int2];
   shuffle[int2]:= shuffle[int1];
   shuffle[int1]:= seg1;
  end;

  newtraps:= traps;      //init memory sources
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
   seg2:= seg1^.h.previous;
writeln('************************************** (',segcounter,')');
dumpseg(seg1);
if segcounter = stoped.value then begin
 testvar:= 0;
end;

if not((segcounter = stoped.value) and noaed.value) then begin
   if not (sf_pointhandled in seg2^.flags) then begin
    handlepoint(seg2);
dump(traps,newtraps-traps,nodes,'point A',false);
   end;
end;
if not((segcounter = stoped.value) and nobed.value) then begin
   if not (sf_pointhandled in seg1^.flags) then begin
    handlepoint(seg1);
dump(traps,newtraps-traps,nodes,'point B',false);
   end;
end;
writeln('----------------');
dumpseg(seg1);
if (segcounter = stoped.value) and 
                  (noseged.value or noaed.value or nobed.value) then begin
 break;
end;
   handlesegment(seg1);
writeln('----------------');
dumpseg(seg1);
if segcounter = stoped.value then begin
 break;
end;
  end;
writeln('toptrap: ',trapval(toptrap),' points: ',npoints,' traps: ',newtraps-traps, ' nodes: ',newnodes-nodes,
 ' ',formatfloatmse((newnodes-nodes)/npoints,'0.00'));
if dumperror then begin
 writeln('****error****                                         ****error****');
 guibeep;
end
else begin
 writeln('OK                                                               OK');
end;

  if nodescopy <> nil then begin
   freemem(nodescopy);
  end;
  int1:= (newnode-nodes)*sizeof(trapnodeinfoty);
  getmem(nodescopy,int1);
  move(nodes^,nodescopy^,int1);
setlength(ftraps,newtraps-traps);
int2:= 0;
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
  finddiags;
  fdiags:= nil;
  fmountains:= nil;
  newmountain:= pointer(traps); //traps not used anymore
  triangles:= pointer(newmountain)+npoints*mountainsize;
  newtriangle:= triangles;
  findmountains(segments,true);
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
 if tridisped.value then begin
  for int1:= 0 to high(ftriangles) do begin
   acanvas.fillpolygon(ftriangles[int1].p,
                             hsbtorgb((int1*50) mod 360,sated.value,100));
  end;
 end
 else begin
  for int1:= 0 to high(fmountains) do begin
   acanvas.fillpolygon(fmountains[int1].chain,
                             hsbtorgb((int1*50) mod 360,sated.value,100));
  end;
 end;
 for int1:= 0 to high(ftraps) do begin
  acanvas.drawlines(ftraps[int1],true,cl_green);
 end;
 acanvas.drawlinesegments(fdiags,cl_blue);
 acanvas.dashes:= #1#3;
 acanvas.drawlines(ar1,true,cl_red);
 for int1:= 0 to high(ftraps) do begin
  if numdisped.value then begin
   drawtext(acanvas,inttostr(int1),
     mr((ftraps[int1][0].x+ftraps[int1][1].x+ftraps[int1][2].x+
                  ftraps[int1][3].x) div 4,
                    (ftraps[int1][0].y+ftraps[int1][2].y)div 2,
       0,0),[tf_xcentered,tf_ycentered]);
  end;
 end;
end;

procedure tmainfo.findedexe(const sender: TObject);
var
 pt1: pointty;
begin
 if buffer <> nil then begin
  pt1.x:= findxed.value;
  pt1.y:= findyed.value;
  nodes:= nodescopy;
  findtrap(@pt1,@pt1);
 end;
end;

procedure tmainfo.destroyexe(const sender: TObject);
begin
 if buffer <> nil then begin
  freemem(buffer);
  freemem(nodescopy);
 end;
end;

procedure tmainfo.filenamesetexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if avalue <> '' then begin
  projectstat.readstat(avalue);
 end;
end;

procedure tmainfo.saveasexe(const sender: TObject);
begin
 if projectfile.controller.execute(fdk_save) = mr_ok then begin
  projectfile.value:= projectfile.controller.filename;
  projectstat.writestat(projectfile.value);
 end;
end;

procedure tmainfo.statwriteexe(const sender: TObject;
               const writer: tstatwriter);
begin
 projectstat.writestat(projectfile.value);
end;

procedure tmainfo.saveexe(const sender: TObject);
begin
 projectstat.writestat(projectfile.value);
end;

end.
