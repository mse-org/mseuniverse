{ MSEspice Copyright (c) 2012-2013 by Martin Schreiber
   
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
 mserealsumedit,msedial,msechart,mseificomp,mseificompglob,msescrollbar;
type
 tscalegridfo = class(tsubform)
   scalegrid: twidgetgrid;
   log: tbooleanedit;
   intervalco: trealedit;
   capt: tstringedit;
   oppos: tbooleanedit;
   start: trealedit;
   range: trealedit;
   autoscale: tbooleanedit;
   startmargin: trealedit;
   endmargin: trealedit;
   intervalco2: trealedit;
   gridline: tbooleanedit;
   unittext: tstringedit;
   mka: trealedit;
   mkb: trealedit;
   mkb_a: trealedit;
   hidescale: tbooleanedit;
   procedure datamodifiedexe(const sender: TObject);
   procedure setvalueexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure setlogexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure mkasetexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure mkbsetexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure mkb_asetexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
  private
   fboxlineseen: boolean;
  protected
   procedure updatedial(const adial: tcustomdialcontroller;
                  const aindex: integer; var hasnormal,hasopposite: boolean);
  public
   procedure updatechart(const achart: tcustomchart; const adials: tchartdials);
 end;
var
 scalegridfo: tscalegridfo;
implementation
uses
 scalegridform_mfm,chartform,mainmodule;
 
procedure tscalegridfo.datamodifiedexe(const sender: TObject);
begin
 tchartfo(owner.owner).updatechart;
 mainmo.projectmodified;
end;

procedure tscalegridfo.updatedial(const adial: tcustomdialcontroller;
               const aindex: integer; var hasnormal,hasopposite: boolean);

 procedure updatemarker(const amarker: tdialmarker;
                             const amark: trealedit; const acolor: colorty);
 begin
  with amarker do begin
   options:= [dmo_limitoverloadi,dmo_hidelimit];
   color:= acolor;
   dashes:= #2#3;
   value:= amark[aindex];
  end;
 end; //updatemarker
 
var
 bo1: boolean;
begin
 with adial do begin
  if not hidescale[aindex] then begin 
   if not fboxlineseen then begin
    fboxlineseen:= true;
    options:= [do_sideline,do_boxline];
   end
   else begin
    options:= [do_sideline];
   end;
  end
  else begin
   options:= [do_invisible,do_sideline];
  end;
  opposite:= oppos[aindex];
  range:= self.range[aindex];
  start:= self.start[aindex];
  log:= self.log[aindex];
  ticks.clear;
  ticks.count:= 1;
  with ticks[0] do begin
   captionunit:= self.unittext[aindex];
   if log then begin
    intervalcount:= intervalco[aindex];
   end
   else begin
    interval:= autointerval(range,intervalco[aindex]);
   end;
   caption:= capt[aindex];
   if opposite then begin
    bo1:= hasopposite;
    hasopposite:= true;
   end
   else begin
    bo1:= hasnormal;
    hasnormal:= true;
   end;     
   if bo1 then begin
    length:= 5;
    fitdist:= 5;
   end
   else begin
    if gridline[aindex] then begin
     length:= 0;
    end
    else begin
     length:= 5;
    end;
    fitdist:= 0;
   end;
  end;
  if intervalco2[aindex] > 0 then begin
   ticks.count:= 2;
   with ticks[1] do begin
    if log then begin
     intervalcount:= ticks[0].intervalcount*intervalco2[aindex];
    end
    else begin
     interval:= ticks[0].interval/intervalco2[aindex];
    end;
    if bo1 then begin
     length:= 2;
//     fitdist:= 2;
    end
    else begin
     if gridline[aindex] then begin
      length:= 0;
//     fitdist:= 0;
      dashes:= #1#1;
     end
     else begin
      length:= 2;
     end;
    end;
   end;
  end;
  markers.count:= 2;
  updatemarker(markers[0],mka,cl_red);
  updatemarker(markers[1],mkb,cl_blue);
 end;
end;

procedure tscalegridfo.updatechart(const achart: tcustomchart;
                                          const adials: tchartdials);
var
 int1: integer;
 bo1,bo2: boolean;
begin
 bo1:= false;
 bo2:= false;
// adials.count:= scalegrid.datarowhigh+1;
 adials.count:= scalegrid.rowcount;
 fboxlineseen:= false;
 for int1:= 0 to adials.count-1 do begin
  updatedial(adials[int1],int1,bo1,bo2);
 end;
end;

procedure tscalegridfo.setvalueexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 autoscale.value:= false;
end;

procedure tscalegridfo.setlogexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  intervalco.value:= 1;
  intervalco2.value:= 10;
 end
 else begin
  intervalco.value:= 5;
  intervalco2.value:= 5;
 end;
end;

procedure tscalegridfo.mkasetexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 if avalue = emptyreal then begin
  mkb_a.value:= emptyreal;
 end
 else begin
  if mkb.value <> emptyreal then begin
   mkb_a.value:= mkb.value - avalue;
  end;
 end;
end;

procedure tscalegridfo.mkbsetexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 if avalue = emptyreal then begin
  mkb_a.value:= emptyreal;
 end
 else begin
  if mka.value <> emptyreal then begin
   mkb_a.value:= avalue - mka.value;
  end;
 end;
end;

procedure tscalegridfo.mkb_asetexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 if (avalue = emptyreal) then begin
  if (mka.value <> emptyreal) and (mkb.value <> emptyreal) then begin
   avalue:= mkb.value-mka.value;  
  end;
 end
 else begin
  if mka.value <> emptyreal then begin
   mkb.value:= mka.value + avalue;
  end
  else begin
   if mkb.value <> emptyreal then begin
    mka.value:= mkb.value - avalue;
   end
   else begin
    avalue:= emptyreal;
   end;
  end;
 end;
end;

end.
