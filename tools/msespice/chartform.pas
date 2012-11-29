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
 mseact,mseactions,mselistbrowser,spiceform,msedispwidgets,mserichstring;

type
 tchartfo = class(tspicefo)
   chart: tchart;
   optionsact: taction;
   plotact: taction;
   resetzoomact: taction;
   tspacer1: tspacer;
   titledisp: tstringdisp;
   procedure tracedataentered(const sender: TObject);
   procedure dataenteredexe(const sender: TObject);
   procedure showoptionsexe(const sender: TObject);
   procedure childmouseexe(const sender: twidget; var ainfo: mouseeventinfoty);
   procedure showplotexe(const sender: TObject);
   procedure beforepaintexe(const sender: twidget; const acanvas: tcanvas);
   procedure printchartexe(const sender: TObject);
   procedure resetzoomupdateexe(const sender: tcustomaction);
   procedure resetzoomexe(const sender: TObject);
  private
   foptfo: tchartoptionsfo;
   fshowmenuitem: tmenuitem;
   fchartvalid: boolean;
   procedure activateexe(const sender: tobject);
   function getchartcaption: msestring;
   procedure setchartcaption(const avalue: msestring);
   function gettitle: msestring;
   procedure settitle(const avalue: msestring);
  protected
   fnode: ttreelistedititem; //tchartnode
   procedure doupdatechart;
  public
   constructor create(const aowner: tcomponent;
                       const anode: ttreelistedititem //tchartnode
                                                       ); reintroduce;
   destructor destroy; override;
   procedure clear;
   procedure updatechart;
   property chartcaption: msestring read getchartcaption write setchartcaption;
   property optfo: tchartoptionsfo read foptfo;
   property title: msestring read gettitle write settitle;
 end;

procedure syncfitframe(const adock: tdockcontroller);

implementation
uses
 chartform_mfm,msereal,main,plotpage,dockform,printwindow;

procedure syncfitframe(const adock: tdockcontroller);
var
 left1: integer = 0;
 top1: integer = 0;
 right1: integer = 0;
 bottom1: integer = 0;
 ar1: booleanarty;
 children1: widgetarty;
  
 procedure checkfit;
 var
  int1: integer;
 begin
  setlength(ar1,length(children1));
  for int1:= 0 to high(ar1) do begin
   if not (csdestroying in children1[int1].componentstate) and 
                                    (children1[int1] is tchartfo) then begin
    ar1[int1]:= true;
    with tchartfo(children1[int1]).chart.fitframe do begin
     if left > left1 then begin
      left1:= left;
     end;
     if top > top1 then begin
      top1:= top;
     end;
     if right > right1 then begin
      right1:= right;
     end;
     if bottom > bottom1 then begin
      bottom1:= bottom;
     end;
    end;
   end;
  end;
 end; //checkfit

var
 int1: integer;
const
 pad = 1; 
begin
 children1:= adock.getitems;
 case adock.currentsplitdir of
  sd_horz: begin
   checkfit;
   for int1:= 0 to high(ar1) do begin
    if ar1[int1] then begin
     with tchartfo(children1[int1]).chart,frame,fitframe do begin
      framei_left:= left1-left + pad;
      framei_top:= pad;
      framei_right:= right1-right+pad+1;
      framei_bottom:= pad;
     end;
    end;
   end;
  end;
  sd_vert: begin
   checkfit;
   for int1:= 0 to high(ar1) do begin
    if ar1[int1] then begin
     with tchartfo(children1[int1]).chart,frame,fitframe do begin
      framei_left:= pad;
      framei_top:= top1-top+pad;
      framei_right:= 1;
      framei_bottom:= bottom1-bottom+pad+1;
     end;
    end;
   end;
  end;
  else begin
   for int1:= 0 to high(children1) do begin
    if children1[int1] is tcustomchart then begin
     tchartfo(children1[int1]).chart.frame.framei:= mf(pad,pad,pad+1,pad+1);
    end;
   end;
  end;
 end;
end;

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
end;

procedure tchartfo.doupdatechart;

 procedure checkscale(var ascalefo: tscalegridfo; const isy: boolean);
 var
  int1,int2: integer;
  ar1: complexarty;
 begin
  with ascalefo do begin
   setlength(ar1,scalegrid.rowcount);
   for int1:= 0 to scalegrid.rowhigh do begin
    with ar1[int1] do begin
     re:= bigreal;  //min
     im:= -bigreal; //max
    end;
    for int2:= 0 to foptfo.tracesgrid.rowhigh do begin
     if int2 >= chart.traces.count then begin
      break;
     end;
     if isy then begin
      if foptfo.yscalenum[int2] = int1+1 then begin
       with chart.traces[int2] do begin
        logy:= log[int1];
        if autoscale[int1] then begin
         with ar1[int1] do begin
          minmaxy1(re,im);
         end;
        end;
       end;
      end;
     end
     else begin
      if foptfo.xscalenum[int2] = int1+1 then begin
       with chart.traces[int2] do begin
        logx:= log[int1];
        if autoscale[int1] then begin
         with ar1[int1] do begin
          minmaxx1(re,im);
         end;
        end;
       end;
      end;
     end;
    end;
   end;
   for int1:= 0 to high(ar1) do begin
    if autoscale[int1] then begin
     with ar1[int1] do begin
      im:= calctracerange(re,im,log[int1],startmargin[int1],endmargin[int1]);
     end;
    end;
   end;
   if isy then begin
    for int1:= 0 to foptfo.tracesgrid.rowhigh do begin
     if int1 >= chart.traces.count then begin
      break;
     end;
     int2:= foptfo.yscalenum[int1]-1;
     if int2 <= scalegrid.rowhigh then begin
      ascalefo.unittext[int2]:= foptfo.yunit[int1];
      with chart.traces[int1] do begin;
       if autoscale[int2] then begin
        with ar1[int2] do begin
         ascalefo.start[int2]:= re;
         ystart:= re;
         ascalefo.range[int2]:= im;
         yrange:= im;
        end;
       end
       else begin
        ystart:= ascalefo.start[int2];
        yrange:= ascalefo.range[int2];
       end;
      end;
     end;
    end;
    updatechart(chart,chart.ydials);
   end
   else begin
    for int1:= 0 to foptfo.tracesgrid.rowhigh do begin
     if int1 >= chart.traces.count then begin
      break;
     end;
     int2:= foptfo.xscalenum[int1]-1;
     if int2 <= scalegrid.rowhigh then begin
      ascalefo.unittext[int2]:= foptfo.xunit[int1];
      with chart.traces[int1] do begin;
       if autoscale[int2] then begin
        with ar1[int2] do begin
         ascalefo.start[int2]:= re;
         xstart:= re;
         ascalefo.range[int2]:= im;
         xrange:= im;
        end;
       end
       else begin
        xstart:= ascalefo.start[int2];
        xrange:= ascalefo.range[int2];
       end;
      end;
     end;
    end;
    updatechart(chart,chart.xdials);
   end;
  end;
 end;
 
var
 int1: integer;
begin
 if not fchartvalid then begin
  fchartvalid:= true;
  for int1:= 0 to foptfo.tracesgrid.rowhigh do begin
   if int1 >= chart.traces.count then begin
    break;
   end;
   with chart.traces[int1] do begin
    color:= foptfo.tracecolor[int1];
    imagenr:= foptfo.tracesymbol[int1];
    legend_caption:= foptfo.tracelegend[int1];
   end;
  end;
  checkscale(foptfo.xscalefo,false);
  checkscale(foptfo.yscalefo,true);
  if parentofcontainer is tdockfo then begin
   tdockfo(parentofcontainer).chartchanged(self);
  end;
 end;
end;

procedure tchartfo.tracedataentered(const sender: TObject);
begin
 updatechart;
end;

procedure tchartfo.updatechart;
begin
 fchartvalid:= false;
 invalidate;
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

procedure tchartfo.beforepaintexe(const sender: twidget;
               const acanvas: tcanvas);
begin
 doupdatechart;
end;

procedure tchartfo.printchartexe(const sender: TObject);
begin
 tprintwindowfo.create(chart);
end;

procedure tchartfo.resetzoomupdateexe(const sender: tcustomaction);
begin
 sender.enabled:= (chart.frame.zoomwidth <> 1) or (chart.frame.zoomheight <> 1);
end;

procedure tchartfo.resetzoomexe(const sender: TObject);
begin
 chart.frame.zoom:= mc(1,1);
end;

function tchartfo.gettitle: msestring;
begin
 result:= titledisp.value;
end;

procedure tchartfo.settitle(const avalue: msestring);
begin
 titledisp.value:= avalue;
 titledisp.visible:= avalue <> '';
end;

end.
