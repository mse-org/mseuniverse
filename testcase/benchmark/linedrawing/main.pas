unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar,msedispwidgets,
 mserichstring,msestrings,msesimplewidgets,mseact,msedataedits,mseedit,
 msestatfile,msestream,sysutils,msetimer;

type
 tmainfo = class(tmainform)
   slider: tslider;
   speeddi: trealdisp;
   paintbox: tpaintbox;
   slanted: tbooleanedit;
   zerolineed: tbooleanedit;
   dasheded: tbooleanedit;
   maxed: trealedit;
   mined: trealedit;
   runed: tbooleanedit;
   tstatfile1: tstatfile;
   timer: ttimer;
   procedure paintev(const sender: twidget; const acanvas: tcanvas);
   procedure createdev(const sender: TObject);
   procedure runsetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure tiev(const sender: TObject);
   procedure speedentev(const sender: TObject);
   procedure zerolinesetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure slantseev(const sender: TObject);
  private
   runhigh: int32;
   poly: pointarty;
   count: int32;
   last: card64;
   procedure updatepoly();
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,msesysutils{$ifndef mswindows},msex11gdi{$endif};
const
 segmentcount = 80;

procedure tmainfo.paintev(const sender: twidget; const acanvas: tcanvas);
var
 co1: colorty;
 i1,i2: int32;
 ca1: card32;
begin
 co1:= cl_white;
 if odd(count) then begin
  co1:= cl_black;
 end;
 if timeout(last) then begin
  co1:= cl_red;
 end;
 last:= timestep(1050000); //check missed 1sec tick 
 acanvas.color:= cl_black;
 if dasheded.value then begin
  acanvas.dashes:= #2#2;
 end;
 i2:= 0;
 if runed.value then begin
  i2:= runhigh;
 end;
 for i1:= 0 to i2 do begin
  acanvas.drawlines(poly);
 end;
 if runed.value then begin
  acanvas.fillrect(mr(100,100,10,10),co1);
 end;
 inc(count);
end;

procedure tmainfo.createdev(const sender: TObject);
begin
 updatepoly();
{$ifdef mswindows}
 zerolineed.enabled:= false;
{$endif}
end;

procedure tmainfo.updatepoly();
var
 po1: ppointty;
 i1: int32;
begin
 setlength(poly,160);
 po1:= pointer(poly);
 if slanted.value then begin
  for i1:= 0 to 39 do begin
   po1^.x:= i1 * 6;
   po1^.y:= 0;
   inc(po1);
   po1^.x:= (po1-1)^.x+3;
   po1^.y:= 240;
   inc(po1);
  end;
  for i1:= 0 to 39 do begin
   po1^.y:= i1 * 6;
   po1^.x:= 0;
   inc(po1);
   po1^.y:= (po1-1)^.y+3;
   po1^.x:= 240;
   inc(po1);
  end;
 end
 else begin
  for i1:= 0 to 19 do begin
   po1^.x:= i1 * 12;
   po1^.y:= 0;
   inc(po1);
   po1^.x:= (po1-1)^.x+6;
   po1^.y:= (po1-1)^.y;
   inc(po1);
   po1^.x:= (po1-1)^.x;
   po1^.y:= 240;
   inc(po1);
   po1^.x:= (po1-1)^.x+6;
   po1^.y:= (po1-1)^.y;
   inc(po1);
  end;
  for i1:= 0 to 19 do begin
   po1^.y:= i1 * 12;
   po1^.x:= 0;
   inc(po1);
   po1^.y:= (po1-1)^.y+6;
   po1^.x:= (po1-1)^.x;
   inc(po1);
   po1^.y:= (po1-1)^.y;
   po1^.x:= 240;
   inc(po1);
   po1^.y:= (po1-1)^.y+6;
   po1^.x:= (po1-1)^.x;
   inc(po1);
  end;
 end;
end;

procedure tmainfo.runsetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 timer.enabled:= avalue;
end;

procedure tmainfo.tiev(const sender: TObject);
begin
 paintbox.invalidate();
end;

procedure tmainfo.speedentev(const sender: TObject);
begin
 speeddi.value:= ((maxed.value - mined.value) * slider.value + mined.value);
 runhigh:= round(speeddi.value/segmentcount) - 1;
end;

procedure tmainfo.zerolinesetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
{$ifndef mswindows}
 zerolineworkaround:= avalue;
{$endif}
end;

procedure tmainfo.slantseev(const sender: TObject);
begin
 updatepoly();
end;

end.
