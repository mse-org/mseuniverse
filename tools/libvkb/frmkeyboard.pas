unit frmkeyboard;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,mseedit,mseimage,msegraphedits,mseificomp,mseificompglob,mseifiglob,
 msescrollbar,msetypes,msedataedits,msestrings,msegrids,mclasses,keypanelform,keybindings,
 keybindings_de,keybindings_ru,keybindings_uzcyr,keybindings_es,keybindings_zh,keybindings_fr;
 
type
 widgetkindty = (wik_string,wik_integer,wik_real);
 panelkindty = (pk_none,pk_abc,pk_123,pk_symbol,pk_options);
  
 tfrmkeyboardfo = class(tmseform)
   facewarn2: tfacecomp;
   facefunct2: tfacecomp;
   facelistwarn: tfacelist;
   facelistfunct: tfacelist;
   facenormal2: tfacecomp;
   facelistnormal: tfacelist;
   facecont: tfacecomp;
   facefunct: tfacecomp;
   framebutton: tframecomp;
   facenormal: tfacecomp;
   facewarn: tfacecomp;
   framecont: tframecomp;
   procedure widgetactivechangeexe(const oldwidget: twidget;
                   const newwidget: twidget);

   procedure asynceventexe(const sender: TObject; var atag: Integer);
  private
   function getshift: boolean;
   procedure setshift(const avalue: boolean);
   function getctrl: boolean;
   procedure setctrl(const avalue: boolean);
  protected
   finputwidget: twidget;
   fshiftstate: shiftstatesty;
   fwidgetkind: widgetkindty;
   fpanel1: tkeypanelfo;
   fpanel2: tkeypanelfo;
   fbinding: pkeybindingsty;
   fbindingupper: pkeybindingsty;
   procedure linkinputwidget(const awidget: twidget);
   procedure unlinkinputwidget;
   procedure updatewindowpos;
   procedure objectevent(const sender: tobject; 
                        const event: objecteventty); override;
   procedure updateshiftstate();
  public
   destructor destroy; override;
   procedure updatebuttons;
   procedure showkeyboard(const awidget: twidget);
   procedure keybuttonexe(const sender: TObject);
   procedure selectpanel(const akind: panelkindty);
   property shift: boolean read getshift write setshift;
   property ctrl: boolean read getctrl write setctrl;
   property widgetkind: widgetkindty read fwidgetkind;
 end;

var
 frmkeyboardfo: tfrmkeyboardfo;
implementation
uses
 frmkeyboard_mfm,msekeyboard,msesysutils,msedropdownlist,msetextedit,
 wcharsform,woptionsform,wnumbersform,wsymbolsform,sysutils;

type
 tcustomdropdownedit1 = class(tcustomdropdownedit);
 twidget1 = class(twidget);

procedure freepanel(var apanel: tkeypanelfo);
begin
 if apanel <> nil then begin
  apanel.name:= ''; //avoid name clash
  apanel.visible:= false;
  apanel.release;
  apanel:= nil;
 end;
end;

{ tfrmkeyboardfo }
 
destructor tfrmkeyboardfo.destroy;
begin
 unlinkinputwidget;
 inherited;
end;

procedure tfrmkeyboardfo.showkeyboard(const awidget: twidget);
begin
 if awidget<>nil then begin
  widgetactivechangeexe(nil, awidget);
 end;
end;

procedure tfrmkeyboardfo.linkinputwidget(const awidget: twidget);
begin
 setlinkedvar(awidget,tmsecomponent(finputwidget));
 if finputwidget <> nil then begin
  finputwidget.window.registermovenotification(ievent(self));
 end;
end;

procedure tfrmkeyboardfo.unlinkinputwidget;
begin
 if finputwidget <> nil then begin
  finputwidget.window.unregistermovenotification(ievent(self));
 end;
 setlinkedvar(nil,tmsecomponent(finputwidget));
                //automatically nil'd if inputwidget has been destroyed
 freepanel(fpanel1);
 freepanel(fpanel2);
end;

procedure tfrmkeyboardfo.updatewindowpos;
var
 arect : rectty;
begin
 if finputwidget <> nil then begin
  if finputwidget.window.modal then begin
   arect:= placepopuprect(finputwidget.rootwidget,mr(nullpoint,finputwidget.rootwidget.size),cp_bottomleft,size);
   if testintersectrect(arect,finputwidget.widgetclientrect) then begin
    widgetrect:= placepopuprect(finputwidget,mr(nullpoint,finputwidget.size),cp_bottomleft,size);
   end else begin
    widgetrect:= arect;
   end;
  end else begin                                                 
   widgetrect:= placepopuprect(finputwidget,mr(nullpoint,finputwidget.size),cp_bottomleft,size);
  end;
 end;
end;

procedure tfrmkeyboardfo.widgetactivechangeexe(const oldwidget: twidget;
                                                  const newwidget: twidget);
var
 panelkind1: panelkindty;
begin
 panelkind1:= pk_none;
 if (newwidget <> nil) then begin
  if checkdescendent(newwidget) then begin
   exit;
  end;
  if((newwidget is tcustomdataedit) and 
         not tcustomdataedit(newwidget).readonly) and 
     not ((newwidget is tcustomdropdownedit) and 
                (deo_selectonly in 
                      tcustomdropdownedit1(newwidget).fdropdown.options)) or 
    ((newwidget is tcustomstringgrid) and 
       not (co_readonly in 
              tcustomstringgrid(newwidget).datacols.options)) or 
    ((newwidget is tcustomtextedit) and not tcustomtextedit(newwidget).readonly) then begin
   fwidgetkind:= wik_string;
   if (newwidget is tcustomrealedit) then begin
    fwidgetkind:= wik_real;
   end
   else begin
    if (newwidget is tcustomintegeredit) or 
             (newwidget is tcustomint64edit) then begin
     fwidgetkind:= wik_integer;
    end;
   end;
   if fwidgetkind = wik_string then begin
    panelkind1:= pk_abc;
   end
   else begin
    panelkind1:= pk_123;
   end;
   linkinputwidget(newwidget);
  end;
 end;
 if (panelkind1 = pk_none) then begin
  unlinkinputwidget();
  hide;
 end
 else begin
  selectpanel(panelkind1);
 end;
end;

procedure tfrmkeyboardfo.objectevent(const sender: tobject;
                                               const event: objecteventty);
begin
 inherited;
 if (finputwidget <> nil) and (event = oe_changed) and 
                      (sender = finputwidget.window) then begin
  updatewindowpos;  
 end;              
end;

//bo_nocandefocus must be set in button options

procedure tfrmkeyboardfo.keybuttonexe(const sender: TObject);
var
 i1: integer;
 po1: pkeybindingsty;
 ss1: shiftstatesty;
begin
 if (finputwidget <> nil) and (sender is tcomponent) then begin
  i1:= tcomponent(sender).tag;
  if (i1 >= 0) and (i1 <= keymax) then begin
   if ss_shift in fshiftstate then begin
    po1:= fbindingupper;
   end
   else begin
    po1:= fbinding;
   end;
   ss1:= fshiftstate;
   with po1^[i1] do begin
    if shiftstate <> [] then begin
     ss1:= shiftstate;
     if shiftstate = [ss_none] then begin
      ss1:= [];
     end;
//    case i1 of
//     10, 11, 22, 36, 43, 47, 53, 91:
//      finputwidget.window.postkeyevent(key,[],false,chars)
//    else
    end;
    finputwidget.window.postkeyevent(key,ss1,false,chars);
   end;
  end;
 end;
end;

procedure tfrmkeyboardfo.updatebuttons;
var
 po1: pkeybindingsty;

 procedure updatepanel(const panel: tkeypanelfo; const bindings: keybindingsty);
 var
  i1: integer;
  ar1: widgetarty;
 begin
  ar1:= twidget1(twidget(panel)).fwidgets;
  for i1:= 0 to high(ar1) do begin
   if ar1[i1] is tcustombutton then begin
    with tcustombutton(ar1[i1]) do begin
     if (tag >= 0) and (tag <= keymax) then begin
      with bindings[tag] do begin
       if caption = '' then begin
        tcustombutton(ar1[i1]).caption:= chars;
       end
       else begin
        tcustombutton(ar1[i1]).caption:= caption;
       end;
      end;
     end;
    end;
   end;
  end;
  panel.updatebuttons();
 end;
var
 si1: sizety;
begin
 if ss_shift in fshiftstate then begin
  fbindingupper:= keyboardlangs[ord(keylang)].upper;
  po1:= fbindingupper;
 end
 else begin
  fbinding:= keyboardlangs[ord(keylang)].lower;
  po1:= fbinding;
 end;
 updatepanel(fpanel1,po1^);
 fpanel1.pos:= nullpoint;
 si1:= fpanel1.size;
 fpanel1.updatebuttons;
 fpanel1.visible:= true;
 if fpanel2 <> nil then begin
  updatepanel(fpanel2,po1^);
  fpanel2.pos:= mp(si1.cx,0);
  si1.cx:= si1.cx + fpanel2.width;
  fpanel2.updatebuttons;
  fpanel2.visible:= true;
 end;
 size:= si1;
end;

procedure tfrmkeyboardfo.asynceventexe(const sender: TObject;
               var atag: Integer);
begin
 case panelkindty(atag) of
  pk_abc: begin
   freepanel(fpanel2);
   if not (fpanel1 is twcharsfo) then begin
    freepanel(fpanel1);
    fpanel1:= twcharsfo.create(self,self);
   end;
  end;
  pk_123: begin
   if fpanel2 is twnumbersfo then begin
    freepanel(fpanel1);
    fpanel1:= fpanel2;
    fpanel2:= nil;
   end
   else begin
    freepanel(fpanel2);
    if not (fpanel1 is twnumbersfo) then begin
     freepanel(fpanel1);
     fpanel1:= twnumbersfo.create(self,self);
    end;
   end;
  end;
  pk_symbol: begin
   if not (fpanel1 is twoptionsfo) then begin
    freepanel(fpanel1);
    fpanel1:= twsymbolsfo.create(self,self);
   end;
   if not (fpanel2 is twnumbersfo) then begin
    freepanel(fpanel2);
    fpanel2:= twnumbersfo.create(self,self);
   end;
  end;
  pk_options: begin
   freepanel(fpanel2);
   if not (fpanel1 is twoptionsfo) then begin
    freepanel(fpanel1);
    fpanel1:= twoptionsfo.create(self,self);
   end;
  end;
  else begin
   unlinkinputwidget;
   hide;
   exit;
  end;
 end;
 if finputwidget <> nil then begin
  updatebuttons;
  updatewindowpos;
  show(ml_none,finputwidget.window);
 end;
end;

procedure tfrmkeyboardfo.selectpanel(const akind: panelkindty);
begin
 asyncevent(ord(akind));
end;

function tfrmkeyboardfo.getshift: boolean;
begin
 result:= ss_shift in fshiftstate;
end;

procedure tfrmkeyboardfo.setshift(const avalue: boolean);
begin
 if shift <> avalue then begin
  if avalue then begin
   include(fshiftstate,ss_shift);
  end
  else begin
   exclude(fshiftstate,ss_shift);
  end;
  updateshiftstate;
 end;
end;

function tfrmkeyboardfo.getctrl: boolean;
begin
 result:= ss_ctrl in fshiftstate;
end;

procedure tfrmkeyboardfo.setctrl(const avalue: boolean);
begin
 if ctrl <> avalue then begin
  if avalue then begin
   include(fshiftstate,ss_ctrl);
  end
  else begin
   exclude(fshiftstate,ss_ctrl);
  end;
  updateshiftstate;
 end;
end;

procedure tfrmkeyboardfo.updateshiftstate();
begin
 updatebuttons();
end;

end.
