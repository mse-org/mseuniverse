unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msewidgetgrid,msegraphedits,msescrollbar,msestatfile,
 msesplitter,msechartedit,msebitmap,msedatanodes,msefiledialog,mselistbrowser,
 msesys,msedispwidgets,mserichstring,msecolordialog;

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
   scaleed: trealedit;
   offsxed: trealedit;
   offsyed: trealedit;
   tbutton5: tbutton;
   brushed: tbooleanedit;
   bru: tbitmapcomp;
   smoothed: tbooleanedit;
   xoffs: tintegeredit;
   yoffs: tintegeredit;
   tsplitter3: tsplitter;
   brumono: tbitmapcomp;
   monoed: tbooleanedit;
   foregrounded: tcoloredit;
   backgrounded: tcoloredit;
   linewidthed: tintegeredit;
   linedisp: tpaintbox;
   procedure datentexe(const sender: TObject);
   procedure paintexe(const sender: twidget; const acanvas: tcanvas);
   procedure setpointexe(const sender: TObject; var avalue: complexarty;
                   var accept: Boolean);
   procedure layoutexe(const sender: TObject);
   procedure tripaexe(const sender: twidget; const acanvas: tcanvas);
   procedure findedexe(const sender: TObject);
   procedure filenamesetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure saveasexe(const sender: TObject);
   procedure statwriteexe(const sender: TObject; const writer: tstatwriter);
   procedure saveexe(const sender: TObject);
   procedure clrexe(const sender: TObject);
   procedure paintlineexe(const sender: twidget; const acanvas: tcanvas);
  private
   ftraps: array of trapdispinfoty;
   fdiags: segmentarty;
   fmountains: mountaininfoarty;
   ftriangles: triarty;
   procedure invalidisp;
   procedure xyvalues(out xar,yar: realarty);
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

procedure tmainfo.invalidisp;
var
 ar1: pointarty;
begin
 linedisp.invalidate;
 polydisp.invalidate;
 tridisp.invalidate;
end;
 
procedure tmainfo.xyvalues(out xar,yar: realarty);
var
 int1: integer;
begin
  xar:= xed.gridvalues;
  yar:= yed.gridvalues;
  for int1:= 0 to high(xar) do begin
   xar[int1]:= (xar[int1]+offsxed.value)/scaleed.value;
   yar[int1]:= (yar[int1]+offsyed.value)/scaleed.value;
  end;
end;

procedure tmainfo.datentexe(const sender: TObject);
var
 xar,yar: realarty;
begin
{$ifdef mse_debugpolytria}
 debugstop:= stoped.value;
 debugnoa:= noaed.value;
 debugnob:= nobed.value;
 debugnoseg:= noseged.value;
 debugnosegsplit:= nosegbed.value;
{$endif}
 invalidisp;
 xyvalues(xar,yar);
 with charted.traces[0] do begin
  xdata:= xar;
  ydata:= yar;
 end;
end;

procedure tmainfo.paintexe(const sender: twidget; const acanvas: tcanvas);
var
 ar1: pointarty;
 co1: colorty;
begin
 ar1:= polyvalues;
 acanvas.smooth:= smoothed.value;
 if monoed.value then begin
  brumono.bitmap.colorforeground:= foregrounded.value;
  brumono.bitmap.colorbackground:= backgrounded.value;
  acanvas.brush:= brumono.bitmap;
 end
 else begin
  acanvas.brush:= bru.bitmap;
 end;
 acanvas.brushorigin:= mp(xoffs.value,yoffs.value);
 co1:= foregrounded.value;
 if brushed.value then begin
  co1:= cl_brush;
 end;
 acanvas.fillpolygon(ar1,co1);
 acanvas.move(mp(0,200));
 if monoed.value then begin
  brumono.bitmap.colorforeground:= backgrounded.value;
  brumono.bitmap.colorbackground:= foregrounded.value;
 end
 else begin
  if not brushed.value then begin
   co1:= backgrounded.value;
  end;
 end;
 acanvas.fillpolygon(ar1,co1);
end;

procedure tmainfo.paintlineexe(const sender: twidget; const acanvas: tcanvas);
var
 ar1: pointarty;
begin
 ar1:= polyvalues;
 acanvas.linewidth:= linewidthed.value;
 acanvas.smooth:= smoothed.value;
 acanvas.drawlines(ar1,false,foregrounded.value);
 acanvas.move(mp(0,200));  
 acanvas.drawlines(ar1,true,backgrounded.value);
end;

procedure tmainfo.setpointexe(const sender: TObject; var avalue: complexarty;
               var accept: Boolean);
var
 ar1: complexarty;
 int1: integer;
begin
 setlength(ar1,length(avalue));
 for int1:= 0 to high(ar1) do begin
  ar1[int1].re:= (avalue[int1].re-offsxed.value)*scaleed.value;
  ar1[int1].im:= (avalue[int1].im-offsyed.value)*scaleed.value;
 end;
 xed.griddata.assignre(ar1);  
 yed.griddata.assignim(ar1);
 invalidisp;
end;

function tmainfo.polyvalues: pointarty;
var
 int1: integer;
 fx,fy: real;
 xar,yar: realarty;
begin
 fx:= charted.width;
 fy:= charted.height;
 xyvalues(xar,yar);
 setlength(result,grid.rowcount);
 for int1:= 0 to high(result) do begin
  with result[int1] do begin
   x:= round(xar[int1]*fx);
   y:= round(yar[int1]*fy);
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
 int1,int2: integer;
begin
{$ifdef mse_debugpolytria}
 if debugdumperror then begin
  guibeep;
 end;
{$endif}
 ar1:= polyvalues;
{$ifdef mse_debugpolytria1}
 if tridisped.value then begin
  for int1:= 0 to high(debugtriangles) do begin
   acanvas.fillpolygon(debugtriangles[int1].p,
                             hsbtorgb((int1*50) mod 360,sated.value,100));
  end;
 end
 else begin
  for int1:= 0 to high(debugmountains) do begin
   acanvas.fillpolygon(debugmountains[int1].chain,
                             hsbtorgb((int1*50) mod 360,sated.value,100));
  end;
 end;
 for int1:= 0 to high(debugtraps) do begin
  for int2:= 0 to 3 do begin
   with debugtraps[int1][int2] do begin
    if x = maxint then begin
     x:= tridisp.width-1;
    end;
    if y = maxint then begin
     y:= tridisp.height-1;
    end;
   end;
  end;
  acanvas.drawlines(debugtraps[int1],true,cl_green);
 end;
 acanvas.drawlinesegments(debugdiags,cl_blue);
{$endif}
 acanvas.dashes:= #1#3;
 acanvas.drawlines(ar1,true,cl_red);
{$ifdef mse_debugpolytria1}
 for int1:= 0 to high(debugtraps) do begin
  if numdisped.value then begin
   drawtext(acanvas,inttostr(int1),
     mr((debugtraps[int1][0].x+debugtraps[int1][1].x+debugtraps[int1][2].x+
                  debugtraps[int1][3].x) div 4,
       (debugtraps[int1][0].y+debugtraps[int1][2].y)div 2,
       0,0),[tf_xcentered,tf_ycentered]);
  end;
 end;
{$endif}
end;

procedure tmainfo.findedexe(const sender: TObject);
var
 pt1: pointty;
begin
{
 if buffer <> nil then begin
  pt1.x:= findxed.value;
  pt1.y:= findyed.value;
  nodes:= nodescopy;
  findtrap(@pt1,@pt1);
 end;
}
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

procedure tmainfo.clrexe(const sender: TObject);
begin
 grid.clear;
 datentexe(nil);
end;

end.
