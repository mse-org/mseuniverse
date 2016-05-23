unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,msestrings,
 sysutils,msesimplewidgets,mclasses,popup;

type

 tmainfo = class(tmainform)
   tbutton1: tbutton;
   tstringedit1: tstringedit;
   tstringedit2: tstringedit;
   tstringedit3: tstringedit;
   procedure showexe(const sender: TObject);
  private
   fpopup: tpopupfo;
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msepointer;
 
{ thintpopup }
(*
constructor thintpopup.create(aowner: tcomponent; atransientfor: twindow;
                              const aplacementrect: rectty;
                              const aplacement: captionposty = cp_bottomleft);
begin
 inherited create(aowner,atransientfor);
 fplacementrect:= aplacementrect;
 fplacement:= aplacement;
// optionswidget:= optionswidget - [ow_mousefocus];
 optionswidget:= optionswidget + [ow_subfocus]; 
                     //if the popup widget has children which need mouse focus
 color:= cl_infobackground;
 createframe();
 frame.levelo:= 1;
 size:= ms(100,30);
 if atransientfor <> nil then begin
  frefpos:= atransientfor.screenpos;
  atransientfor.registermovenotification(ievent(self));
 end;
 updatepos();
 show(ml_none,atransientfor);
 begincapture();
 application.registeronapplicationactivechanged(@doapplicationactivechanged);
end;

destructor thintpopup.destroy();
begin
 releasemouse();
 if transientfor <> nil then begin
  transientfor.unregistermovenotification(ievent(self));
 end;
 application.unregisteronapplicationactivechanged(@doapplicationactivechanged);
 inherited;
end;

procedure thintpopup.mouseevent(var info: mouseeventinfoty);
begin
 if (info.eventkind = ek_buttonpress) and not pointinrect(info.pos,paintrect) or 
    (info.eventkind = ek_mouseleave) and  application.active then begin
                    //mouse captured by another widget
  release();
 end
 else begin
  inherited;
 end;
end;

procedure thintpopup.begincapture();
begin
 capturemouse(false);
 application.widgetcursorshape:= cr_default;
end;

procedure thintpopup.updatepos();
var
 rect1: rectty;
begin
 rect1:= fplacementrect;
 if transientfor <> nil then begin
  addpoint1(rect1.pos,subpoint(transientfor.screenpos,frefpos));
 end;
 widgetrect:= placepopuprect(transientfor,rect1,fplacement,size);
end;

procedure thintpopup.doapplicationactivechanged(const avalue: boolean);
begin
 visible:= avalue;
 if avalue then begin
  begincapture();
 end;
end;

procedure thintpopup.objectevent(const sender: tobject;
               const event: objecteventty);
begin
 inherited;
 if (event = oe_changed) and (sender = transientfor) then begin
  updatepos();
 end;
end;
*)
{ tmainfo }

procedure tmainfo.showexe(const sender: TObject);
begin
 if fpopup = nil then begin
  setlinkedvar(tpopupfo.create(window.focusedwidget),
                                       tmsecomponent(fpopup));
    //fpopup will be set to nil automatically if it is destroyed
 end;
end;

end.
