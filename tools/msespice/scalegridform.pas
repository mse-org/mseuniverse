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
unit scalegridform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msegraphedits,
 mserealsumedit,msedial,msechart;
type
 tscalegridfo = class(tsubform)
   scalegrid: twidgetgrid;
   log: tbooleanedit;
   maingridlinewidth: trealedit;
   intervalco: trealedit;
   capt: tstringedit;
   oppos: tbooleanedit;
   start: trealedit;
   range: trealedit;
   autoscale: tbooleanedit;
   startmargin: trealedit;
   endmargin: trealedit;
   procedure dataenteredexe(const sender: TObject);
   procedure rowcountchangeexe(const sender: tcustomgrid);
   procedure setvalueexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
  public
   procedure updatedial(const adial: tcustomdialcontroller;
                                             const aindex: integer);
   procedure updatechart(const achart: tchart; const adials: tchartdials);
 end;
var
 scalegridfo: tscalegridfo;
implementation
uses
 scalegridform_mfm,chartform;
 
procedure tscalegridfo.dataenteredexe(const sender: TObject);
begin
 tchartfo(owner.owner).updatechart;
end;

procedure tscalegridfo.updatedial(const adial: tcustomdialcontroller;
               const aindex: integer);
begin
 with adial do begin
  opposite:= oppos[aindex];
//  visible:= vis[aindex];
  range:= self.range[aindex];
  start:= self.start[aindex];
  ticks.clear;
  ticks.count:= 1;
  with ticks[0] do begin
   interval:= autointerval(range,intervalco[aindex]);
   caption:= capt[aindex];
  end;
 end;
end;

procedure tscalegridfo.updatechart(const achart: tchart;
                                          const adials: tchartdials);
var
 int1: integer;
begin
 adials.count:= scalegrid.datarowhigh+1;
 for int1:= 0 to adials.count-1 do begin
  updatedial(adials[int1],int1);
 end;
end;

procedure tscalegridfo.rowcountchangeexe(const sender: tcustomgrid);
begin
 dataenteredexe(nil);
end;

procedure tscalegridfo.setvalueexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 autoscale.value:= false;
end;

end.
