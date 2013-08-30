unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msewidgetgrid,msegraphedits,msescrollbar,msestatfile,
 msesplitter,msechartedit,msebitmap,msedatanodes,msefiledialog,mselistbrowser,
 msesys;

type
 trapdispinfoty = array[0..3] of pointty;
 
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
   fmountains: pointararty;
   procedure invalidisp;
   function polyvalues: pointarty;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msearrayutils,msenoise,mseformatstr,sysutils,msedrawtext;
var 
 testvar,testvar1,testvar2,testvar3,testvar4,testvar5,testvar6,
 testvar7,testvar8: integer;

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
 seginfoty = record
  previous: pseginfoty;
  next: pseginfoty;
  flags: segflagsty;
  b: ppointty;            //a is in previous segment
  dx,dy: integer;         //a-b
  trap: ptrapinfoty;      //inserted trap for b
  splitseg: pseginfoty;   //segment for horizontal split at b
 end;
 
 trapnodeinfoty = record
  p,l,r: ptrapnodeinfoty; //parent,left,right
  case kind: trapnodekindty of
   tnk_y: (y: ppointty);
   tnk_x: (seg: pseginfoty);
   tnk_trap: (trap: ptrapinfoty);
 end;

 diaginfoty = record
  top,basetop,basebottom,chainstart: pseginfoty;
  bottomup: boolean;
 end;
 pdiaginfoty = ^diaginfoty;

const
 trapcountfact = 4;    //todo: check maximal buffer size
 nodecountfact = 8;
 diagcountfact = 1;
 trapnodesize = sizeof(trapnodeinfoty)*trapcountfact;
 diagsize = sizeof(diaginfoty)*diagcountfact;
{$if diagsize > trapnodesize}
 {$error 'diagonal memory overflow'}
{$endif}

var
 traps: ptrapinfoty;
 segments: pseginfoty;
 points: ppointty;
 npoints: integer;
 diags: pdiaginfoty;

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
   result:= trapdumpinfoty(l).t^.top^.y - y
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
    top:= seg^.b;
    bottom:= seg1^.b;
   end
   else begin
    top:= seg1^.b;
    bottom:= seg^.b;
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

function isright(const point: ppointty; ref: pseginfoty): boolean;
 //true if point right of segment
begin
// result:= xpos(point,ref) = xp_right;
 result:= xdist(point,ref) >= 0;
end;

function segdirdown(const seg,ref: pseginfoty): segdirty;
//todo: handle dy = 0
var
 segcommon: pseginfoty;
 ptseg,ptref: ppointty;
begin
 if seg = ref then begin
  result:= sd_same;
 end
 else begin
  segcommon:= seg^.previous;
  if segcommon = ref then begin
   ptseg:= seg^.b;
   ptref:= ref^.previous^.b;
  end
  else begin
   segcommon:= ref^.previous;
   if segcommon = seg then begin
    ptseg:= seg^.previous^.b;
    ptref:= ref^.b;
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
    if (seg^.dx*ref^.dy < ref^.dx*seg^.dy) xor 
                not((ref^.dy < 0) xor (seg^.dy < 0)) then begin 
                        //direction of one segment reversed
     result:= sd_right;
    end
    else begin
     result:= sd_left;
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
(*
 function finddiags: integer; //return count
 var
  newdiags: pdiaginfoty;

  procedure finddown(const atrap,astop: ptrapinfoty);

   procedure findup(const atrap,astop: ptrapinfoty);
   var
    tr1: ptrapinfoty;
   begin
    tr1:= atrap;
    while true do begin
     with tr1^ do begin
      if abover <> nil then begin
       findup(abover,tr1);
      end;
      if (left = nil) or (right = nil) then begin
       exit; //error because of segment crossing
      end;
      if (left = right^.previous) or (right = left^.previous) then begin
       break; //triangle
      end;
      tr1:= above;
     end;
    end;
    finddown(tr1,astop);
   end;
   
  var
   tr1,toptrap: ptrapinfoty;
   lefta,righta: pseginfoty;

   procedure makediag;
   begin
    with tr1^ do begin
     newdiags^.top:= segments+(toptrap^.top-points);
     newdiags^.basetop:= segments+(top-points);
     newdiags^.basebottom:= segments+(bottom-points);
            //close chain below
     if newdiags^.basebottom^.previous = newdiags^.top then begin
      newdiags^.bottomup:= false;
      newdiags^.basebottom^.previous:= newdiags^.basetop;
     end
     else begin
      newdiags^.bottomup:= true;
      newdiags^.chainstart:= newdiags^.basetop^.previous;
      newdiags^.basetop^.previous:= newdiags^.basebottom;
     end;
     inc(newdiags);
     toptrap:= tr1;
    end;
   end; //makediag
var
 hasdiag: boolean;   
  begin
   toptrap:= atrap;
   tr1:= atrap;
   repeat
    with tr1^ do begin
     if (left = nil) or (right = nil) or 
                 (top = nil) or (bottom = nil) then begin
      exit; //error because of segment crossing
     end;
     if abover <> nil then begin
      findup(abover,tr1);
     end;
     lefta:= left^.previous;
     righta:=right^.previous;
     if (top = left^.b) and (bottom = lefta^.b) or
            (bottom = left^.b) and (top = lefta^.b) or
            (top = right^.b) and (bottom = righta^.b) or
            (bottom = right^.b) and (top = righta^.b) then begin
      hasdiag:= false;
     end
     else begin
      hasdiag:= true;
      makediag;
     end;
     if belowr <> nil then begin
      finddown(belowr,astop);
     end;
     if (tr1^.left = righta) and (bottom = righta^.b) or 
        (tr1^.right = lefta) and (bottom = lefta^.b) then begin
      break; //triangle below
     end;
    end;
    tr1:= tr1^.below;
   until tr1 = astop;
   if not hasdiag then begin
    makediag;
   end;
  end;

 begin
  diags:= pointer(nodes);
  newdiags:= diags;
  finddown(toptrap,nil);
  result:= newdiags-diags;
 end;
*) 

 function finddiags: integer; //returns count
 var
  newdiags: pdiaginfoty;
  tr1: ptrapinfoty;
  lefta,righta: pseginfoty;

  procedure makediag;
  begin
   with tr1^ do begin
    newdiags^.basetop:= segments+(top-points);
    newdiags^.basebottom:= segments+(bottom-points);
    if newdiags^.basetop > newdiags^.basebottom then begin
     newdiags^.bottomup:= false;
     newdiags^.top:= newdiags^.basebottom^.previous;
     newdiags^.chainstart:= newdiags^.basetop^.next;
     newdiags^.basebottom^.previous:= newdiags^.basetop^.next;
     newdiags^.basetop^.next:= newdiags^.basetop^.previous; 
    end
    else begin
     newdiags^.bottomup:= true;
     newdiags^.top:= newdiags^.basebottom^.next;
     newdiags^.chainstart:= newdiags^.basetop^.previous;
     newdiags^.basebottom^.previous:= newdiags^.basetop^.next;
     newdiags^.basetop^.next:= newdiags^.basetop^.previous; 
    end;
   end;
   inc(newdiags);
  end; //makediag
  
 begin
  diags:= pointer(nodes);
  newdiags:= diags;
  tr1:= newtraps;
  repeat
   dec(tr1);
testvar:= tr1-traps;
   with tr1^ do begin
    if (left <> nil) and (right <> nil) then begin
     lefta:= left^.previous;
     righta:= right^.previous;
     if not((top = left^.b) and (bottom = lefta^.b) or
            (bottom = left^.b) and (top = lefta^.b) or
            (top = right^.b) and (bottom = righta^.b) or
            (bottom = right^.b) and (top = righta^.b)) then begin
      makediag;
     end;
    end;
   end;
  until tr1 = traps;
  result:= newdiags-diags;
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
//   noleft:= newnode(ltrap,noabove);       // (Tb) ->     (s)
//   noright:= newnode(rtrap,noabove);      //         (Tl)   (Tr)
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
   int1: integer;
   aisright: boolean;
   seg1: pseginfoty;
//   trleft,trright: ptrapinfoty;
  begin
   if trold^.below = nil then begin
    exit; //crossing
   end;

   if newright then begin
    seg1:= trold^.right;
//    trleft:= trold;
//    trright:= trnew;
   end
   else begin
    seg1:= trold^.left;
//    trleft:= trnew;
//    trright:= trold;
   end;
testvar1:= trold-traps;
testvar2:= trnew-traps;
testvar3:= trold^.below-traps;
testvar4:= trold^.belowr-traps;
testvar5:= trold^.above-traps;
testvar6:= trold^.abover-traps;
testvar7:= trold^.below^.above-traps;
testvar8:= trold^.below^.abover-traps;
   aisright:= isright(trold^.below^.top,seg1);
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
    if trold^.belowr = nil then begin //no existing segment below
     trnew^.below:= trold^.below;
     with trold^.below^ do begin
      if abover = nil then begin  //single trap above
//{
       if newright then begin
        abover:= trnew;
       end
       else begin
        abover:= trold;
        above:= trnew;
       end;
//}
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
  end;
    
  procedure splittrap(const newright: boolean; const old: ptrapinfoty;
                              var left,right,trnew: ptrapinfoty);
  var
   trabove: ptrapinfoty;
   trabover: ptrapinfoty;
   pointbelowpos: xposty;
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
  isright1,isright2,bo2: boolean;
  
 begin
  if sf_reverse in aseg^.flags then begin
   sega:= aseg;
   segb:= aseg^.previous;
  end
  else begin
   segb:= aseg;
   sega:= aseg^.previous;
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
     isright1:= isright(trap1^.below^.top,aseg);
    end;
    sd_right: begin
     trap1:= trap1^.above^.below;
     isright1:= true;
     if (trap1^.above = traps) then begin
      toptrap:= trap1;
     end;
    end;
    else begin
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
  
begin
mwcnoiseinit(1,1);
 if grid.rowcount > 1 then begin
  pointsar:= polyvalues;
  npoints:= length(pointsar);
  points:= pointer(pointsar);
 
  sizetraps:= trapcountfact*npoints*sizeof(trapinfoty);
  sizenodes:= nodecountfact*npoints*sizeof(trapnodeinfoty);
  if buffer <> nil then begin
   freemem(buffer);
  end;
  getmem(buffer,npoints*(sizeof(seginfoty)+sizeof(pseginfoty)) + 
                                                sizetraps + sizenodes);
  segments:= buffer;
  shuffle:= pointer(segments+npoints);
  traps:= pointer(shuffle+npoints);
  nodes:= pointer(traps)+sizetraps;
  ppt1:= points;
  ppt2:= points+npoints-1;
  seg1:= segments;
  for int1:= npoints-1 downto 0 do begin //init segments
   shuffle[int1]:= seg1;
   with seg1^ do begin
    previous:= seg1-1;
    next:= seg1+1;
    splitseg:= nil;
    trap:= nil;
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
    ppt2:= ppt1;
    inc(ppt1);
   end;
   inc(seg1);
  end;
  segments^.previous:= segments + npoints - 1;
//  (segments+npoints-1)^.next:= segments;
  for int1:= npoints-1 downto 0 do begin //shuffle segments
   int2:= mwcnoise mod npoints;
   seg1:= shuffle[int2];
   shuffle[int2]:= shuffle[int1];
   shuffle[int1]:= seg1;
  end;

//  deltraps:= nil;      
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
   seg2:= seg1^.previous;
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
  setlength(fdiags,finddiags);
  setlength(fmountains,length(fdiags));
  for int1:= 0 to high(fdiags) do begin
   with diags[int1] do begin
    fdiags[int1].a:= basetop^.b^;
    fdiags[int1].b:= basebottom^.b^;
    setlength(fmountains[int1],1);
    if bottomup then begin
     fmountains[int1][0]:= basetop^.b^;
     seg1:= chainstart;
     while true do begin
      setlength(fmountains[int1],high(fmountains[int1])+2);
      fmountains[int1][high(fmountains[int1])]:= seg1^.b^;
      if seg1 = basebottom then begin
       break;
      end;
      seg1:= seg1^.previous;
     end;
    end
    else begin
     fmountains[int1][0]:= basebottom^.b^;
     seg1:= top;
     while true do begin
      setlength(fmountains[int1],high(fmountains[int1])+2);
      fmountains[int1][high(fmountains[int1])]:= seg1^.b^;
      if seg1 = basetop then begin
       break;
      end;
      seg1:= seg1^.previous;
     end;
    end;
   end;
  end;
  
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
 for int1:= 0 to high(fmountains) do begin
  acanvas.fillpolygon(fmountains[int1],hsbtorgb((int1*50) mod 360,20,100));
 end;
 for int1:= 0 to high(ftraps) do begin
  acanvas.drawlines(ftraps[int1],true,cl_green);
 end;
 acanvas.drawlinesegments(fdiags,cl_blue);
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
