unit popup;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,msestrings,
 sysutils,msegraphedits,msescrollbar;
type
 tpopupfo = class(tmseform)
   tslider1: tslider;
   tstringedit1: tstringedit;
   procedure applicationev(const sender: tactcomponent; var aevent: tmseevent;
                   var handled: Boolean);
   procedure dataenteredev(const sender: TObject);
   procedure applicationactivechangedev(const avalue: Boolean);
  protected
   frefpos: pointty;
   fplacementrect: rectty;
   procedure objectevent(const sender: tobject; 
                                         const event: objecteventty) override;
   procedure updatepos();
  public
   constructor create(const atransientfor: twidget); reintroduce;
   destructor destroy(); override;
 end;

implementation
uses
 popup_mfm;
 
{ tpopupfo }

constructor tpopupfo.create(const atransientfor: twidget);
begin
 inherited create(nil);
 if atransientfor <> nil then begin
  fplacementrect:= atransientfor.widgetscreenrect;
  frefpos:= atransientfor.window.screenpos;
  updatepos();
  atransientfor.window.registermovenotification(ievent(self));
 end;
 show(ml_none,atransientfor);
end;

destructor tpopupfo.destroy();
begin
 if window.transientfor <> nil then begin
  window.transientfor.unregistermovenotification(ievent(self));
 end;
 inherited;
end;

procedure tpopupfo.updatepos();
var
 rect1: rectty;
begin
 rect1:= fplacementrect;
 if window.transientfor <> nil then begin
  addpoint1(rect1.pos,subpoint(window.transientfor.screenpos,frefpos));
 end;
 widgetrect:= placepopuprect(window,rect1,cp_bottomleft,size);
end;

procedure tpopupfo.objectevent(const sender: tobject; 
                                           const event: objecteventty);
begin
 inherited;
 if (event = oe_changed) and (sender = window.transientfor) then begin
  updatepos();
 end;
end;

procedure tpopupfo.applicationev(const sender: tactcomponent;
               var aevent: tmseevent; var handled: Boolean);
begin
 if (aevent.kind = ek_buttonpress) then begin
  with tmouseevent(aevent) do begin
   if (fwinid <> window.winid) or //click in other window
                           not pointinrect(fpos,widgetsizerect) then begin
                                  //click out of window in case of modal
    release();
   end;
  end;
 end;
end;

procedure tpopupfo.dataenteredev(const sender: TObject);
begin
 release();
end;

procedure tpopupfo.applicationactivechangedev(const avalue: Boolean);
begin
 visible:= avalue;
end;

end.
