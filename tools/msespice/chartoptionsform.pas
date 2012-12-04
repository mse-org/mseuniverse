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
unit chartoptionsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msesplitter,
 msedataedits,mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,
 msecolordialog,msewidgets,scalegridform,mseact,mseactions,spiceform;

type
 tchartoptionsfo = class(tspicefo)
   tsplitter2a: tsplitter;
   tracesgrid: twidgetgrid;
   xexpdisp: tstringedit;
   xscalenum: tintegeredit;
   yexpdisp: tstringedit;
   yscalenum: tintegeredit;
   tracecolor: tcoloredit;
   chartact: taction;
   plotact: taction;
   yunit: tstringedit;
   xunit: tstringedit;
   tracesymbol: tenumedit;
   tracelegend: tstringedit;
   yscalefo: tscalegridfo;
   tsplitter3a: tsplitter;
   xscalefo: tscalegridfo;
   tracekey: tintegeredit;
   procedure datamodifiedexe(const sender: TObject);
   procedure showchartexe(const sender: TObject);
   procedure showplotexe(const sender: TObject);
   procedure createexe(const sender: TObject);
   procedure tracecelleventexe(const sender: TObject;
                   var info: celleventinfoty);
   procedure dialcelleventexe(const sender: TObject; var info: celleventinfoty);
   procedure tracerowmovedexe(const sender: tcustomgrid;
                   const fromindex: Integer; const toindex: Integer;
                   const acount: Integer);
  protected
   procedure chartchange;
  public
 end;

implementation
uses
 chartoptionsform_mfm,chartform,mainmodule,mselistbrowser,plotpage;

procedure tchartoptionsfo.chartchange;
begin
 tchartfo(owner).updatechart;
 mainmo.projectmodified;
end;

procedure tchartoptionsfo.datamodifiedexe(const sender: TObject);
begin
 chartchange;
end;

procedure tchartoptionsfo.showchartexe(const sender: TObject);
begin
 tchartfo(owner).activate; 
end;

procedure tchartoptionsfo.showplotexe(const sender: TObject);
var
 node1: ttreelistedititem;
begin
 with tchartfo(owner) do begin
  if tracesgrid.active and (tracesgrid.row >= 0) and
                    (tracesgrid.row < node.count) then begin
   node1:= ttreelistedititem(node[tracesgrid.row]);
   node1.activate;
   with tplotpagefo(node1.editwidget.owner) do begin
    if self.xexpdisp.focused then begin
     tracegrid.col:= value0.gridcol;
    end
    else begin
     if self.yexpdisp.focused then begin
      tracegrid.col:= yexpression.gridcol;
     end;
    end;
   end;
  end
  else begin
   showplotexe(nil);
  end;
 end;
end;

procedure tchartoptionsfo.createexe(const sender: TObject);
begin
 tracesymbol.dropdown.cols[0].asarray:= mainmo.tracesymbolnames;
end;

procedure tchartoptionsfo.tracecelleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) then begin
  plotact.execute;
 end;
end;

procedure tchartoptionsfo.dialcelleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) then begin
  chartact.execute;
 end;
end;

procedure tchartoptionsfo.tracerowmovedexe(const sender: tcustomgrid;
               const fromindex: Integer; const toindex: Integer;
               const acount: Integer);
begin
 if sender.userinput then begin
  tchartfo(owner).chart.traces.move(fromindex,toindex);
 end;
end;

end.
