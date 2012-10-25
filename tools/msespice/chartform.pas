{ MSEgit Copyright (c) 2012 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit chartform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msechart,
 msengspice,msesplitter,msedataedits,mseedit,mseifiglob,msestrings,msetypes,
 msesimplewidgets,msewidgets,msegraphedits,mserealsumedit,msegrids,
 msewidgetgrid,msecolordialog,scalegridform,msetimer;

type
 tchartfo = class(tdockform)
   chart: tchart;
   tsplitter1: tsplitter;
   tscrollbox1: tscrollbox;
   tracesgrid: twidgetgrid;
   xexpdisp: tstringedit;
   start: trealedit;
   range: trealedit;
   autoscale: tbooleanedit;
   yexpdisp: tstringedit;
   tracecolor: tcoloredit;
   tsplitter2: tsplitter;
   tsimplewidget1: tsimplewidget;
   tsplitter3: tsplitter;
   xscalefo: tscalegridfo;
   yscalefo: tscalegridfo;
   xscalenum: tintegeredit;
   yscalenum: tintegeredit;
   timer: ttimer;
   procedure tracedataentered(const sender: TObject);
   procedure updatechartexe(const sender: TObject);
   procedure doupdatechart;
   procedure dataenteredexe(const sender: TObject);
  protected
  public
   procedure clear;
   procedure updatechart;
 end;

implementation
uses
 chartform_mfm,msereal;

{ tchartfo }

procedure tchartfo.clear;
begin
 chart.clear;
// chart.xdials.count:= 0;
// chart.ydials.count:= 0;
end;

procedure tchartfo.doupdatechart;

 procedure checkscale(var ascalefo: tscalegridfo; const isy: boolean);
 var
  int1,int2: integer;
  min,max: real;
 begin
  with ascalefo do begin
   for int1:= 0 to scalegrid.rowhigh do begin
    if autoscale[int1] then begin
     min:= bigreal;
     max:= -bigreal;
     for int2:= 0 to tracesgrid.rowhigh do begin
      if isy then begin
       if yscalenum[int2] = int1+1 then begin
        chart.traces[int2].minmaxy(min,max);
       end;
      end
      else begin
       if xscalenum[int2] = int1+1 then begin
        chart.traces[int2].minmaxx(min,max);
       end;
      end;
     end;
     if max >= min then begin
      range[int1]:= calctracerange(min,max);
      start[int1]:= min;
     end;
    end;
   end;
   if isy then begin
    for int1:= 0 to tracesgrid.rowhigh do begin
     int2:= yscalenum[int1]-1;
     if int2 <= scalegrid.rowhigh then begin
      chart.traces[int1].ystart:= start[int2];
      chart.traces[int1].yrange:= range[int2];
     end;
    end;
    updatechart(chart,chart.ydials);
   end
   else begin
    for int1:= 0 to tracesgrid.rowhigh do begin
     int2:= xscalenum[int1]-1;
     if int2 <= scalegrid.rowhigh then begin
      chart.traces[int1].xstart:= start[int2];
      chart.traces[int1].xrange:= range[int2];
     end;
    end;
    updatechart(chart,chart.xdials);
   end;
  end;
 end;
 
var
 int1: integer;
begin
 for int1:= 0 to tracesgrid.rowhigh do begin
  if int1 >= chart.traces.count then begin
   break;
  end;
  with chart.traces[int1] do begin
   color:= tracecolor[int1];
  end;
 end;
 checkscale(xscalefo,false);
 checkscale(yscalefo,true);
// yscalefo.updatechart(chart,chart.ydials);
end;

procedure tchartfo.tracedataentered(const sender: TObject);
begin
 updatechart;
end;

procedure tchartfo.updatechartexe(const sender: TObject);
begin
 doupdatechart;
end;

procedure tchartfo.updatechart;
begin
 timer.enabled:= true;
end;

procedure tchartfo.dataenteredexe(const sender: TObject);
begin
 updatechart;
end;

end.
