unit azthemeedit;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msegui,msegraphics,
 msegraphutils,mseclasses,mseforms,
 msewidgets,msedataedits,msegrids,msewidgetgrid,
 msecolordialog,msesimplewidgets,msegraphedits,
 msebitmap,msefiledialog,mselistbrowser,msesys,
 msetabs,sysutils,msesplitter,msedataimage;

type
 tazthemeeditfo = class(tmseform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   filedialog: tfiledialog;
   ttabwidget1: ttabwidget;
   wtabframe: ttabpage;
   layframe: tlayouter;
   wframewidth: tintegeredit;
   wcolorclient: tcoloredit;
   wcolorframe: tcoloredit;
   wlevelo: tintegeredit;
   wleveli: tintegeredit;
   wcolorframeactive: tcoloredit;
   wcolorlight: tcoloredit;
   wcolordkshadow: tcoloredit;
   wcolorshadow: tcoloredit;
   wcolorhighlight: tcoloredit;
   wcolorhlwidth: tintegeredit;
   wcolordkwidth: tintegeredit;
   wtabfont: ttabpage;
   tlayouter2: tlayouter;
   wtextcolorbg: tcoloredit;
   wshadowcolor: tcoloredit;
   wglosscolor: tcoloredit;
   wshadowx: tintegeredit;
   wfontheight: tintegeredit;
   wtextcolor: tcoloredit;
   wfontname: tdropdownlistedit;
   wfontwidth: tintegeredit;
   wshadowy: tintegeredit;
   wglossx: tintegeredit;
   wglossy: tintegeredit;
   wbold: tbooleanedit;
   witalic: tbooleanedit;
   wunderline: tbooleanedit;
   wstrikeout: tbooleanedit;
   wtabemptytext: ttabpage;
   wtabface: ttabpage;
   wframe: tbooleanedit;
   wface: tbooleanedit;
   wfont: tbooleanedit;
   wtabothers: ttabpage;
   dlgimage: tfiledialog;
   tlayouter3: tlayouter;
   wbuttoncolor: tcoloredit;
   wtabshift: tintegeredit;
   wtabactivecolor: tcoloredit;
   wtabcolor: tcoloredit;
   wglyphcolor: tcoloredit;
   wnormalimg: tbooleanedit;
   ttabwidget2: ttabwidget;
   wtabnormal: ttabpage;
   wactiveimg: tbooleanedit;
   wmouseimg: tbooleanedit;
   wclickedimg: tbooleanedit;
   gridnormal: twidgetgrid;
   normalimg: tdataimage;
   normalname: tstringedit;
   normaldlg: tstockglyphdatabutton;
   wimgwidth: tintegeredit;
   wimgheight: tintegeredit;
   wdisabledimg: tbooleanedit;
   wimgright: tintegeredit;
   wimgleft: tintegeredit;
   wimgtop: tintegeredit;
   wimgbottom: tintegeredit;
   wtabactive: ttabpage;
   twidgetgrid2: twidgetgrid;
   activeimg: tdataimage;
   tstringedit2: tstringedit;
   activedlg: tstockglyphdatabutton;
   wtabmouse: ttabpage;
   twidgetgrid3: twidgetgrid;
   mouseimg: tdataimage;
   tstringedit3: tstringedit;
   mousedlg: tstockglyphdatabutton;
   wtabclicked: ttabpage;
   twidgetgrid4: twidgetgrid;
   clickedimg: tdataimage;
   tstringedit4: tstringedit;
   clickeddlg: tstockglyphdatabutton;
   wtabdisabled: ttabpage;
   twidgetgrid5: twidgetgrid;
   disableimg: tdataimage;
   tstringedit5: tstringedit;
   disableddlg: tstockglyphdatabutton;
   tlabel1: tlabel;
   wnoclickanim: tbooleanedit;
   wnofocusanim: tbooleanedit;
   wnomouseanim: tbooleanedit;
   wflat: tbooleanedit;
   tlabel2: tlabel;
   facefix: tsimplewidget;
   btnchangefacefix: tbutton;
   wtabmultiface: ttabpage;
   wmultiface: tbooleanedit;
   ttabwidget3: ttabwidget;
   wtabnormalface: ttabpage;
   wtabactiveface: ttabpage;
   wtabmouseface: ttabpage;
   wtabclickedface: ttabpage;
   wtabdisabledface: ttabpage;
   wactiveface: tbooleanedit;
   wclickedface: tbooleanedit;
   wdisabledface: tbooleanedit;
   wmouseface: tbooleanedit;
   wnormface: tbooleanedit;
   facenormal: tsimplewidget;
   btnfacenorm: tbutton;
   btnfaceactive: tbutton;
   faceactive: tsimplewidget;
   btnfacemouse: tbutton;
   facemouse: tsimplewidget;
   btnfaceclicked: tbutton;
   faceclicked: tsimplewidget;
   btnfacedisabled: tbutton;
   facedisabled: tsimplewidget;
   wdispframecolor: tcoloredit;
   wdispcolor: tcoloredit;
   procedure azthemeeditfo_onloaded(const sender: TObject);
   procedure wframe_ondataentered(const sender: TObject);
   procedure wface_ondataentered(const sender: TObject);
   procedure wfont_ondataentered(const sender: TObject);
   procedure normaldlg_onexecute(const sender: TObject);
   procedure activedlg_onexecute(const sender: TObject);
   procedure mousedlg_onexecute(const sender: TObject);
   procedure clickeddlg_onexecute(const sender: TObject);
   procedure disableddlg_onexecute(const sender: TObject);
   procedure wnormalimg_ondataentered(const sender: TObject);
   procedure wactiveimg_ondataentered(const sender: TObject);
   procedure wmouseimg_ondataentered(const sender: TObject);
   procedure wclickedimg_ondataentered(const sender: TObject);
   procedure wdisabledimg_ondataentered(const sender: TObject);
   procedure btnchangefacefix_onexecute(const sender: TObject);
   procedure readface(const aface: tcustomface);
   procedure applyface(const aface: tcustomface);
   procedure wmultiface_ondataentered(const sender: TObject);
   procedure wnormface_ondataentered(const sender: TObject);
   procedure wactiveface_ondataentered(const sender: TObject);
   procedure wmouseface_ondataentered(const sender: TObject);
   procedure wclickedface_ondataentered(const sender: TObject);
   procedure wdisabledface_ondataentered(const sender: TObject);
   procedure btnfacenorm_onexecute(const sender: TObject);
   procedure btnfaceactive_onexecute(const sender: TObject);
   procedure btnfacemouse_onexecute(const sender: TObject);
   procedure btnfaceclicked_onexecute(const sender: TObject);
   procedure btnfacedisabled_onexecute(const sender: TObject);
 end;

var
 azthemeeditfo: tazthemeeditfo;
 
implementation

uses
 azthemeedit_mfm,azfaceedit;
  
{ tazthemeeditfo }

procedure tazthemeeditfo.azthemeeditfo_onloaded(const sender: TObject);
begin
 wfontname.dropdown.cols[0].asarray := getenumnames(typeinfo(stockfontty));
end;

procedure tazthemeeditfo.wframe_ondataentered(const sender: TObject);
begin
 layframe.enabled:= not wframe.value;
end;

procedure tazthemeeditfo.wface_ondataentered(const sender: TObject);
begin
 wtabface.enabled:= not wface.value;
end;

procedure tazthemeeditfo.wfont_ondataentered(const sender: TObject);
begin
 wtabfont.enabled:= not wfont.value;
end;

procedure tazthemeeditfo.normaldlg_onexecute(const sender: TObject);
begin
 if dlgimage.execute(fdk_open) = mr_ok then begin
  normalimg.loadfromfile(dlgimage.controller.filename);
 end;
end;

procedure tazthemeeditfo.activedlg_onexecute(const sender: TObject);
begin
 if dlgimage.execute(fdk_open) = mr_ok then begin
  activeimg.loadfromfile(dlgimage.controller.filename);
 end;
end;

procedure tazthemeeditfo.mousedlg_onexecute(const sender: TObject);
begin
 if dlgimage.execute(fdk_open) = mr_ok then begin
  mouseimg.loadfromfile(dlgimage.controller.filename);
 end;
end;

procedure tazthemeeditfo.clickeddlg_onexecute(const sender: TObject);
begin
 if dlgimage.execute(fdk_open) = mr_ok then begin
  clickedimg.loadfromfile(dlgimage.controller.filename);
 end;
end;

procedure tazthemeeditfo.disableddlg_onexecute(const sender: TObject);
begin
 if dlgimage.execute(fdk_open) = mr_ok then begin
  disableimg.loadfromfile(dlgimage.controller.filename);
 end;
end;

procedure tazthemeeditfo.wnormalimg_ondataentered(const sender: TObject);
begin
 wtabnormal.enabled:= wnormalimg.value;
end;

procedure tazthemeeditfo.wactiveimg_ondataentered(const sender: TObject);
begin
 wtabactive.enabled:= wactiveimg.value;
end;

procedure tazthemeeditfo.wmouseimg_ondataentered(const sender: TObject);
begin
 wtabmouse.enabled:= wmouseimg.value;
end;

procedure tazthemeeditfo.wclickedimg_ondataentered(const sender: TObject);
begin
 wtabclicked.enabled:= wclickedimg.value;
end;

procedure tazthemeeditfo.wdisabledimg_ondataentered(const sender: TObject);
begin
 wtabdisabled.enabled:= wdisabledimg.value;
end;

procedure tazthemeeditfo.applyface(const aface: tcustomface);
var
 aimage: imagety;
begin
 with aface do begin
  fade_direction:= graphicdirectionty(azfaceeditfo.wdirection.value);
  fade_pos.assign(azfaceeditfo.fadedisp.face.fade_pos);
  fade_color.assign(azfaceeditfo.fadedisp.face.fade_color);
  if azfaceeditfo.imgface.bitmap.hasimage then begin
   azfaceeditfo.imgface.bitmap.savetoimage(aimage);
   image.alignment:= azfaceeditfo.imgface.bitmap.alignment;
   image.options:= azfaceeditfo.imgface.bitmap.options;
   image.loadfromimage(aimage);
  end else begin
   image.clear;
  end;
  if azfaceeditfo.walphafadeimg.value then
   options:= options+[fao_alphafadeimage]
  else
   options:= options-[fao_alphafadeimage];
 end;
end;

procedure tazthemeeditfo.readface(const aface: tcustomface);
var
 int1: integer;
 aimage: imagety;
begin
 with aface do begin
  azfaceeditfo.grid.rowcount:= fade_pos.count;
  for int1:= 0 to azfaceeditfo.grid.rowhigh do begin
   azfaceeditfo.posed[int1]:= fade_pos[int1];
   azfaceeditfo.colored[int1]:= fade_color[int1];
  end;
  azfaceeditfo.wdirection.value:= ord(fade_direction);
  if image.hasimage then begin
   image.savetoimage(aimage);
   azfaceeditfo.imgface.bitmap.loadfromimage(aimage);
   azfaceeditfo.imgface.bitmap.alignment:= image.alignment;
   azfaceeditfo.wtiled.value:= al_tiled in image.alignment;
   azfaceeditfo.wfit.value:= al_fit in image.alignment;
   azfaceeditfo.wstretchx.value:= al_stretchx in image.alignment;
   azfaceeditfo.wstretchy.value:= al_stretchy in image.alignment;
   azfaceeditfo.wgrayed.value:= al_grayed in image.alignment;
   azfaceeditfo.wmask.value:= bmo_masked in image.options;
   azfaceeditfo.wcolormasked.value:= bmo_colormask in image.options;
   if al_left in image.alignment then
    azfaceeditfo.whorzfaceimg.value:= 0
   else if al_xcentered in image.alignment then
    azfaceeditfo.whorzfaceimg.value:= 1
   else if al_right in image.alignment then
    azfaceeditfo.whorzfaceimg.value:= 2;
   if al_top in image.alignment then
    azfaceeditfo.wvertfaceimg.value:= 0
   else if al_ycentered in image.alignment then
    azfaceeditfo.wvertfaceimg.value:= 1
   else if al_bottom in image.alignment then
    azfaceeditfo.wvertfaceimg.value:= 2;
  end else begin
   azfaceeditfo.imgface.bitmap.clear;
  end;
  azfaceeditfo.walphafadeimg.value:= fao_alphafadeimage in options;
  azfaceeditfo.change;
 end;
end;

procedure tazthemeeditfo.btnchangefacefix_onexecute(const sender: TObject);
begin
 readface(facefix.face);
 if azfaceeditfo.show(true)=mr_ok then begin
  applyface(facefix.face)
 end;
end;

procedure tazthemeeditfo.wmultiface_ondataentered(const sender: TObject);
begin
 wtabmultiface.enabled:= wmultiface.value;
end;

procedure tazthemeeditfo.wnormface_ondataentered(const sender: TObject);
begin
 wtabnormalface.enabled:= wnormface.value;
end;

procedure tazthemeeditfo.wactiveface_ondataentered(const sender: TObject);
begin
 wtabactiveface.enabled:= wactiveface.value;
end;

procedure tazthemeeditfo.wmouseface_ondataentered(const sender: TObject);
begin
 wtabmouseface.enabled:= wmouseface.value;
end;

procedure tazthemeeditfo.wclickedface_ondataentered(const sender: TObject);
begin
 wtabclickedface.enabled:= wclickedface.value;
end;

procedure tazthemeeditfo.wdisabledface_ondataentered(const sender: TObject);
begin
 wtabdisabledface.enabled:= wdisabledface.value;
end;

procedure tazthemeeditfo.btnfacenorm_onexecute(const sender: TObject);
begin
 readface(facenormal.face);
 if azfaceeditfo.show(true)=mr_ok then begin
  applyface(facenormal.face)
 end;
end;

procedure tazthemeeditfo.btnfaceactive_onexecute(const sender: TObject);
begin
 readface(faceactive.face);
 if azfaceeditfo.show(true)=mr_ok then begin
  applyface(faceactive.face)
 end;
end;

procedure tazthemeeditfo.btnfacemouse_onexecute(const sender: TObject);
begin
 readface(facemouse.face);
 if azfaceeditfo.show(true)=mr_ok then begin
  applyface(facemouse.face)
 end;
end;

procedure tazthemeeditfo.btnfaceclicked_onexecute(const sender: TObject);
begin
 readface(faceclicked.face);
 if azfaceeditfo.show(true)=mr_ok then begin
  applyface(faceclicked.face)
 end;
end;

procedure tazthemeeditfo.btnfacedisabled_onexecute(const sender: TObject);
begin
 readface(facedisabled.face);
 if azfaceeditfo.show(true)=mr_ok then begin
  applyface(facedisabled.face)
 end;
end;

end.
