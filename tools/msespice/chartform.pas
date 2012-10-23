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
 msewidgetgrid,msecolordialog,scalegridform;

type
 tchartfo = class(tdockform)
   chart: tchart;
   tsplitter1: tsplitter;
   tscrollbox1: tscrollbox;
   scalesgrid: twidgetgrid;
   xexpdisp: tstringedit;
   xstart: trealedit;
   xrange: trealedit;
   xautoscale: tbooleanedit;
   yexpdisp: tstringedit;
   ystart: trealedit;
   yrange: trealedit;
   yautoscale: tbooleanedit;
   tracecolor: tcoloredit;
   tsplitter2: tsplitter;
   tsimplewidget1: tsimplewidget;
   tsplitter3: tsplitter;
   xscalefo: tscalegridfo;
   yscalefo: tscalegridfo;
   xscalenum: tintegeredit;
   yscalenum: tintegeredit;
   procedure tracedataentered(const sender: TObject);
  protected
  public
   procedure clear;
   procedure updatechart;
 end;

implementation
uses
 chartform_mfm;

{ tchartfo }

procedure tchartfo.clear;
begin
 chart.clear;
// chart.xdials.count:= 0;
// chart.ydials.count:= 0;
end;

procedure tchartfo.updatechart;
var
 int1: integer;
begin
 for int1:= 0 to scalesgrid.rowhigh do begin
  if int1 >= chart.traces.count then begin
   break;
  end;
  with chart.traces[int1] do begin
   color:= tracecolor[int1];
  end;
 end;
 xscalefo.updatechart(chart,chart.xdials);
 yscalefo.updatechart(chart,chart.ydials);
end;

procedure tchartfo.tracedataentered(const sender: TObject);
begin
 updatechart;
end;

end.
