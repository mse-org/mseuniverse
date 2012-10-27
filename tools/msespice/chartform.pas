{ MSEspice Copyright (c) 2012 by Martin Schreiber
   
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
 msewidgetgrid,msecolordialog,scalegridform,msetimer,chartoptionsform,classes,
 mseact,mseactions,mselistbrowser;

type
 tchartfo = class(tdockform)
   chart: tchart;
   start: trealedit;
   range: trealedit;
   autoscale: tbooleanedit;
   timer: ttimer;
   tpopupmenu1: tpopupmenu;
   optionsact: taction;
   plotact: taction;
   procedure tracedataentered(const sender: TObject);
   procedure updatechartexe(const sender: TObject);
   procedure doupdatechart;
   procedure dataenteredexe(const sender: TObject);
   procedure showoptionsexe(const sender: TObject);
   procedure childmouseexe(const sender: twidget; var ainfo: mouseeventinfoty);
   procedure showplotexe(const sender: TObject);
  private
   foptfo: tchartoptionsfo;
   fshowmenuitem: tmenuitem;
   procedure activateexe(const sender: tobject);
   function getchartcaption: msestring;
   procedure setchartcaption(const avalue: msestring);
  protected
   fnode: ttreelistedititem; //tchartnode
  public
   constructor create(const aowner: tcomponent;
                       const anode: ttreelistedititem //tchartnode
                                                       ); reintroduce;
   destructor destroy; override;
   procedure clear;
   procedure updatechart;
   property chartcaption: msestring read getchartcaption write setchartcaption;
   property optfo: tchartoptionsfo read foptfo;
 end;

implementation
uses
 chartform_mfm,msereal,main,plotpage;

{ tchartfo }

constructor tchartfo.create(const aowner: tcomponent;
                                      const anode: ttreelistedititem);
begin
 inherited create(aowner);
  fnode:= anode;
 foptfo:= tchartoptionsfo.create(self);
 fshowmenuitem:= tmenuitem.create;
 with fshowmenuitem do begin
  onexecute:= @activateexe;
 end;
 mainfo.mainme.menu.itembynames(['view','charts']).
                              submenu.insert(bigint,fshowmenuitem);
end;

destructor tchartfo.destroy;
begin
 foptfo.free;
 fshowmenuitem.create;
 inherited;
end;

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
     for int2:= 0 to foptfo.tracesgrid.rowhigh do begin
      if isy then begin
       if foptfo.yscalenum[int2] = int1+1 then begin
        chart.traces[int2].minmaxy1(min,max);
       end;
      end
      else begin
       if foptfo.xscalenum[int2] = int1+1 then begin
        chart.traces[int2].minmaxx1(min,max);
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
    for int1:= 0 to foptfo.tracesgrid.rowhigh do begin
     int2:= foptfo.yscalenum[int1]-1;
     if int2 <= scalegrid.rowhigh then begin
      chart.traces[int1].ystart:= start[int2];
      chart.traces[int1].yrange:= range[int2];
     end;
    end;
    updatechart(chart,chart.ydials);
   end
   else begin
    for int1:= 0 to foptfo.tracesgrid.rowhigh do begin
     int2:= foptfo.xscalenum[int1]-1;
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
 for int1:= 0 to foptfo.tracesgrid.rowhigh do begin
  if int1 >= chart.traces.count then begin
   break;
  end;
  with chart.traces[int1] do begin
   color:= foptfo.tracecolor[int1];
  end;
 end;
 checkscale(foptfo.xscalefo,false);
 checkscale(foptfo.yscalefo,true);
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

procedure tchartfo.childmouseexe(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 if msegui.isdblclick(ainfo) then begin
  optionsact.execute;
 end;
end;

procedure tchartfo.activateexe(const sender: tobject);
begin
 activate;
end;

function tchartfo.getchartcaption: msestring;
begin
 result:= caption;
end;

procedure tchartfo.setchartcaption(const avalue: msestring);
begin
 caption:= avalue;
 optfo.caption:= avalue + ' [Options]';
 fshowmenuitem.caption:= avalue;
 fshowmenuitem.parentmenu.submenu.sort;
end;

procedure tchartfo.showoptionsexe(const sender: TObject);
begin
 optfo.activate;
end;

procedure tchartfo.showplotexe(const sender: TObject);
begin
 fnode.activate;
end;

end.
