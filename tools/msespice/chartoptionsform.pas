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
 msecolordialog,msewidgets,scalegridform,mseact,mseactions;

type
 tchartoptionsfo = class(tdockform)
   tsplitter2: tsplitter;
   tracesgrid: twidgetgrid;
   xexpdisp: tstringedit;
   xscalenum: tintegeredit;
   yexpdisp: tstringedit;
   yscalenum: tintegeredit;
   tracecolor: tcoloredit;
   tsimplewidget1: tsimplewidget;
   tsplitter3: tsplitter;
   xscalefo: tscalegridfo;
   yscalefo: tscalegridfo;
   chartact: taction;
   tpopupmenu1: tpopupmenu;
   plotact: taction;
   yunitdisp: tstringedit;
   xunitdisp: tstringedit;
   procedure dataenteredexe(const sender: TObject);
   procedure childmouseexe(const sender: twidget; var ainfo: mouseeventinfoty);
   procedure showchartexe(const sender: TObject);
   procedure showplotexe(const sender: TObject);
  public
 end;

implementation
uses
 chartoptionsform_mfm,chartform;

procedure tchartoptionsfo.dataenteredexe(const sender: TObject);
begin
 tchartfo(owner).updatechart;
end;

procedure tchartoptionsfo.childmouseexe(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 if msegui.isdblclick(ainfo) then begin
  chartact.execute;
 end;
end;

procedure tchartoptionsfo.showchartexe(const sender: TObject);
begin
 tchartfo(owner).activate; 
end;

procedure tchartoptionsfo.showplotexe(const sender: TObject);
begin
 tchartfo(owner).showplotexe(nil); 
end;

end.
