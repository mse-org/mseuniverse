unit tooltipform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msetimer;
type
 ttooltipfo = class(tmseform)
   tlabel1: tlabel;
   animtimer: tanimtimer;
   tanimitemcomp1: tanimitemcomp;
   ttimer1: ttimer;
   procedure mouseev(const sender: twidget; var ainfo: mouseeventinfoty);
   procedure tickev(const sender: tanimitem; const avalue: Real);
   procedure tiev(const sender: TObject);
  private
  public
   constructor create(const atransientfor: twidget); reintroduce;
 end;
implementation
uses
 tooltipform_mfm;

{ ttooltipfo }

constructor ttooltipfo.create(const atransientfor: twidget);
begin
 inherited create(nil);
 show(ml_none,atransientfor);
end;

procedure ttooltipfo.mouseev(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 if ainfo.eventkind = ek_buttonpress then begin
  release();
 end;
end;

procedure ttooltipfo.tickev(const sender: tanimitem; const avalue: Real);
begin
 windowopacity:= 1 - avalue;
 if avalue >= 1 then begin
  release();
 end;
end;

procedure ttooltipfo.tiev(const sender: TObject);
begin
 animtimer.enabled:= true;
end;

end.
