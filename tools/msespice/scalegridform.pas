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
   procedure dataenteredexe(const sender: TObject);
   procedure rowcountchangeexe(const sender: tcustomgrid);
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
 tchartfo(owner).updatechart;
end;

procedure tscalegridfo.updatedial(const adial: tcustomdialcontroller;
               const aindex: integer);
begin
 with adial do begin
  opposite:= oppos[aindex];
//  visible:= vis[aindex];
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

end.
