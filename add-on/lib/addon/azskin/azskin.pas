unit azskin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 mseclasses,classes,sysutils,msestrings,msefileutils,msetypes,msedataedits,
 mseformatstr,mseskin,msewidgets,mseapplication,msegui,frmchangeskin,
 msedrawtext,msegraphutils,msestat,msegraphedits,msegraphics,typinfo,
 mseedit,msetabs,msetoolbar,msemenus,msebitmap,
 msesimplewidgets,msegrids,mseglob,mseguiglob,mseformatpngwrite,mseformatpngread;

type
 
 tazskin = class(tcustomskincontroller)
  protected
   fwriter: tstatwriter;
   freader: tstatreader;
   fdataedit: dataeditskininfoty;
   fsb_horz: scrollbarskininfoty;
   fsb_vert: scrollbarskininfoty;
   fgroupbox: groupboxskininfoty;
   fgrid: gridskininfoty;
   fbutton: buttonskininfoty;
   fdatabutton: buttonskininfoty;
   fstepbutton: stepbuttonskininfoty;
   fframebutton: framebuttonskininfoty;
   fcontainer: containerskininfoty;
   fwidgetcolor: widgetcolorinfoty;
   ftabbar: tabbarskininfoty;
   ftabpage: tabpageskininfoty;
   ftoolbar_horz: toolbarskininfoty;
   ftoolbar_vert: toolbarskininfoty;
   fpopupmenu: menuskininfoty;
   fmainmenu: mainmenuskininfoty;
   fdispwidget: dispwidgetskininfoty;
   fbooleanedit: dataeditskininfoty;
   ffilename: filenamety;
   fdefaultfont,fmenufont,fmessagefont: toptionalfont;
   
   frmchangeskinfo: tfrmchangeskinfo;
   procedure handlewidget(const askin: skininfoty;
                           const acolor: pwidgetcolorinfoty = nil); override;
   procedure handlecontainer(const ainfo: skininfoty); override;
   procedure handlegroupbox(const ainfo: skininfoty); override;
   procedure handlesimplebutton(const ainfo: skininfoty); override;
   procedure handledatabutton(const ainfo: skininfoty); override;
   procedure handletabbar(const ainfo: skininfoty); override;
   procedure handletabpage(const ainfo: skininfoty); override;
   procedure handletoolbar(const ainfo: skininfoty); override;
   procedure handleedit(const ainfo: skininfoty); override;
   procedure handledataedit(const ainfo: skininfoty); override;
   procedure handlebooleanedit(const ainfo: skininfoty); override;
   procedure handlemainmenu(const ainfo: skininfoty); override;
   procedure handlepopupmenu(const ainfo: skininfoty); override;
   procedure handlegrid(const ainfo: skininfoty); override;
   procedure handledispwidget(const ainfo: skininfoty); override;
   procedure loaded; override;
   procedure readframetemplate(const aname: string; const areader: tstatreader; var frame_comp: tframecomp; var aimage: timagelist);
   procedure writeframetemplate(const aname: string; const awriter: tstatwriter; var frame_comp: tframecomp);
   procedure writefacetemplate(const aname: string; const awriter: tstatwriter; var face_comp: tfacecomp);
   procedure readfacetemplate(const aname: string; const areader: tstatreader; var face_comp: tfacecomp);
   procedure readfonttemplate(const aname: string; const areader: tstatreader; const afont: toptionalfont);
   procedure writefonttemplate(const aname: string; const awriter: tstatwriter; const afont: toptionalfont);
  public
   fdataedit_img, fbooleanedit_img, fbutton_img, fsb_horz_button_img, fsb_horz_end_img1, 
   fsb_horz_end_img2, fsb_vert_button_img, fsb_vert_end_img1, fsb_vert_end_img2, fstepbutton_img, 
   fcontainer_img, fgroupbox_img, fgrid_img, ffixrows_img, ffixcols_img, fdatacols_img, fdatabutton_img, 
   fframebutton_img, ftabbar_wihorz_img, ftabbar_tahorz_img, ftabbar_wihorzopo_img, ftabbar_tahorzopo_img, 
   ftabbar_wivert_img, ftabbar_tavert_img, ftabbar_wivertopo_img, ftabbar_tavertopo_img, ftoolbar_horz_img, 
   ftoolbar_vert_img, ftabpage_img, fpopupmenu_img, fpopupmenu_item_img, fpopupmenu_itemactive_img, 
   fmainmenu_ma_img, fmainmenu_ma_item_img, fmainmenu_ma_itemactive_img, fmainmenu_pop_img, 
   fmainmenu_pop_item_img, fmainmenu_pop_itemactive_img, fdisplay_img: timagelist;
   fbutton_fl,fdatabutton_fl,fbooleanedit_fl,fframebutton_fl,fstepbutton_fl,fsb_horz_button_fl, fsb_horz_end_fl1, 
   fsb_horz_end_fl2, fsb_vert_button_fl, fsb_vert_end_fl1, fsb_vert_end_fl2: tfacelist;
   fauthor,fversion: msestring;
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure loadtheme;
   procedure savetheme;
   procedure showdialog;
   property dataedit_face: tfacecomp read fdataedit.wi.fa;
   property dataedit_frame: tframecomp read fdataedit.wi.fra;
   property dataedit_empty_text: msestring read fdataedit.empty_text 
                                        write fdataedit.empty_text;
   property dataedit_empty_color: colorty read fdataedit.empty_color
                                  write fdataedit.empty_color default cl_default;
   property dataedit_empty_fontstyle: fontstylesty read fdataedit.empty_fontstyle 
                    write fdataedit.empty_fontstyle default [];
   property dataedit_empty_textflags: textflagsty read fdataedit.empty_textflags 
                    write fdataedit.empty_textflags default [];
   property dataedit_empty_textcolor: colorty read fdataedit.empty_textcolor 
                                 write fdataedit.empty_textcolor default cl_default;
   property dataedit_empty_textcolorbackground: colorty 
                     read fdataedit.empty_textcolorbackground 
                     write fdataedit.empty_textcolorbackground default cl_default;
   property booleanedit_face: tfacecomp read fbooleanedit.wi.fa;
   property booleanedit_frame: tframecomp read fbooleanedit.wi.fra;
   property button_color: colorty read fbutton.co write fbutton.co
                                                  default cl_default;
   property button_face: tfacecomp read fbutton.wi.fa;
   property button_frame: tframecomp read fbutton.wi.fra;
   property button_font: toptionalfont read fbutton.font;
   property default_font: toptionalfont read fdefaultfont;
   property menu_font: toptionalfont read fmenufont;
   property message_font: toptionalfont read fmessagefont;
   property sb_horz_facebutton: tfacecomp read fsb_horz.facebu;
   property sb_horz_faceendbutton: tfacecomp read fsb_horz.faceendbu;
   property sb_horz_framebutton: tframecomp read fsb_horz.framebu;
   property sb_horz_frameendbutton1: tframecomp read fsb_horz.frameendbu1;
   property sb_horz_frameendbutton2: tframecomp read fsb_horz.frameendbu2;
   property sb_vert_facebutton: tfacecomp read fsb_vert.facebu;
   property sb_vert_faceendbutton: tfacecomp read fsb_vert.faceendbu;
   property sb_vert_framebutton: tframecomp read fsb_vert.framebu;
   property sb_vert_frameendbutton1: tframecomp read fsb_vert.frameendbu1;
   property sb_vert_frameendbutton2: tframecomp read fsb_vert.frameendbu2;
   property stepbutton_color: colorty read fstepbutton.co write fstepbutton.co default cl_default;
   property stepbutton_frame: tframecomp read fstepbutton.fra;
   property stepbutton_face: tfacecomp read fstepbutton.fa;                        
   property widget_color: colorty read fwidgetcolor.co write fwidgetcolor.co default cl_default;
   property widget_colorcaptionframe: colorty read fwidgetcolor.cocaptionframe write fwidgetcolor.cocaptionframe default cl_default;
   property container_face: tfacecomp read fcontainer.wi.fa;
   property container_frame: tframecomp read fcontainer.wi.fra;
   property groupbox_face: tfacecomp read fgroupbox.wi.fa;
   property groupbox_frame: tframecomp read fgroupbox.wi.fra;
   property grid_face: tfacecomp read fgrid.wi.fa;
   property grid_frame: tframecomp read fgrid.wi.fra;
   property grid_fixrows_face: tfacecomp read fgrid.fixrows.face;
   property grid_fixrows_frame: tframecomp read fgrid.fixrows.frame;
   property grid_fixcols_face: tfacecomp read fgrid.fixcols.face;
   property grid_fixcols_frame: tframecomp read fgrid.fixcols.frame;
   property grid_datacols_face: tfacecomp read fgrid.datacols.face;
   property grid_datacols_frame: tframecomp read fgrid.datacols.frame;   
   property databutton_color: colorty read fdatabutton.co write fdatabutton.co default cl_default;
   property databutton_face: tfacecomp read fdatabutton.wi.fa;
   property databutton_frame: tframecomp read fdatabutton.wi.fra;
   property databutton_font: toptionalfont read fdatabutton.font;
   property framebutton_color: colorty read fframebutton.co write fframebutton.co default cl_default;
   property framebutton_colorglyph: colorty read fframebutton.coglyph write fframebutton.coglyph;
   property framebutton_face: tfacecomp read fframebutton.fa;
   property framebutton_frame: tframecomp read fframebutton.fra;
   property tabbar_horz_face: tfacecomp read ftabbar.wihorz.fa;
   property tabbar_horz_frame: tframecomp read ftabbar.wihorz.fra;
   property tabbar_horz_tab_color: colorty read ftabbar.tahorz.color write ftabbar.tahorz.color default cl_default;
   property tabbar_horz_tab_coloractive: colorty read ftabbar.tahorz.coloractive write ftabbar.tahorz.coloractive default cl_default;
   property tabbar_horz_tab_frame: tframecomp read ftabbar.tahorz.frame;
   property tabbar_horz_tab_face: tfacecomp read ftabbar.tahorz.face;
   property tabbar_horz_tab_faceactive: tfacecomp read ftabbar.tahorz.faceactive;
   property tabbar_horz_tab_shift: integer read ftabbar.tahorz.shift write ftabbar.tahorz.shift default defaulttabshift;
   property tabbar_horzopo_face: tfacecomp read ftabbar.wihorzopo.fa;
   property tabbar_horzopo_frame: tframecomp read ftabbar.wihorzopo.fra;
   property tabbar_horzopo_tab_color: colorty read ftabbar.tahorzopo.color write ftabbar.tahorzopo.color default cl_default;
   property tabbar_horzopo_tab_coloractive: colorty read ftabbar.tahorzopo.coloractive write ftabbar.tahorzopo.coloractive default cl_default;
   property tabbar_horzopo_tab_frame: tframecomp read ftabbar.tahorzopo.frame;
   property tabbar_horzopo_tab_face: tfacecomp read ftabbar.tahorzopo.face;
   property tabbar_horzopo_tab_faceactive: tfacecomp read ftabbar.tahorzopo.faceactive;
   property tabbar_horzopo_tab_shift: integer read ftabbar.tahorzopo.shift write ftabbar.tahorzopo.shift default defaulttabshift;
   property tabbar_vert_face: tfacecomp read ftabbar.wivert.fa;
   property tabbar_vert_frame: tframecomp read ftabbar.wivert.fra;
   property tabbar_vert_tab_color: colorty read ftabbar.tavert.color write ftabbar.tavert.color default cl_default;
   property tabbar_vert_tab_coloractive: colorty read ftabbar.tavert.coloractive write ftabbar.tavert.coloractive default cl_default;
   property tabbar_vert_tab_frame: tframecomp read ftabbar.tavert.frame;
   property tabbar_vert_tab_face: tfacecomp read ftabbar.tavert.face;
   property tabbar_vert_tab_faceactive: tfacecomp read ftabbar.tavert.faceactive;
   property tabbar_vert_tab_shift: integer read ftabbar.tavert.shift write ftabbar.tavert.shift default defaulttabshift;
   property tabbar_vertopo_face: tfacecomp read ftabbar.wivertopo.fa;
   property tabbar_vertopo_frame: tframecomp read ftabbar.wivertopo.fra;
   property tabbar_vertopo_tab_color: colorty read ftabbar.tavertopo.color write ftabbar.tavertopo.color default cl_default;
   property tabbar_vertopo_tab_coloractive: colorty read ftabbar.tavertopo.coloractive write ftabbar.tavertopo.coloractive default cl_default;
   property tabbar_vertopo_tab_frame: tframecomp read ftabbar.tavertopo.frame;
   property tabbar_vertopo_tab_face: tfacecomp read ftabbar.tavertopo.face;
   property tabbar_vertopo_tab_faceactive: tfacecomp read ftabbar.tavertopo.faceactive;
   property tabbar_vertopo_tab_shift: integer read ftabbar.tavertopo.shift write ftabbar.tavertopo.shift default defaulttabshift;
   property toolbar_horz_face: tfacecomp read ftoolbar_horz.wi.fa;
   property toolbar_horz_frame: tframecomp read ftoolbar_horz.wi.fra;
   property toolbar_horz_buttonface: tfacecomp read ftoolbar_horz.buttonface;
   property toolbar_vert_face: tfacecomp read ftoolbar_vert.wi.fa;
   property toolbar_vert_frame: tframecomp read ftoolbar_vert.wi.fra;
   property toolbar_vert_buttonface: tfacecomp read ftoolbar_vert.buttonface;
   property tabpage_face: tfacecomp read ftabpage.wi.fa;
   property tabpage_frame: tframecomp read ftabpage.wi.fra;
   property popupmenu_face: tfacecomp read fpopupmenu.face;
   property popupmenu_frame: tframecomp read fpopupmenu.frame;
   property popupmenu_itemface: tfacecomp read fpopupmenu.itemface;
   property popupmenu_itemframe: tframecomp read fpopupmenu.itemframe;
   property popupmenu_itemfaceactive: tfacecomp read fpopupmenu.itemfaceactive;
   property popupmenu_itemframeactive: tframecomp read fpopupmenu.itemframeactive;
   property mainmenu_face: tfacecomp read fmainmenu.ma.face;
   property mainmenu_frame: tframecomp read fmainmenu.ma.frame;
   property mainmenu_itemface: tfacecomp read fmainmenu.ma.itemface;
   property mainmenu_itemframe: tframecomp read fmainmenu.ma.itemframe;
   property mainmenu_itemfaceactive: tfacecomp read fmainmenu.ma.itemfaceactive;
   property mainmenu_itemframeactive: tframecomp read fmainmenu.ma.itemframeactive;
   property mainmenu_popupface: tfacecomp read fmainmenu.pop.face;
   property mainmenu_popupframe: tframecomp read fmainmenu.pop.frame;
   property mainmenu_popupitemface: tfacecomp read fmainmenu.pop.itemface;
   property mainmenu_popupitemframe: tframecomp read fmainmenu.pop.itemframe;
   property mainmenu_popupitemfaceactive: tfacecomp read fmainmenu.pop.itemfaceactive;
   property mainmenu_popupitemframeactive: tframecomp read fmainmenu.pop.itemframeactive;
   property dispwidget_color: colorty read fdispwidget.color.co
                              write fdispwidget.color.co default cl_default;
   property dispwidget_colorcaptionframe: colorty 
                         read fdispwidget.color.cocaptionframe 
                         write fdispwidget.color.cocaptionframe default cl_default;
   property dispwidget_face: tfacecomp read fdispwidget.wi.fa;
   property dispwidget_frame: tframecomp read fdispwidget.wi.fra;
  published
   property filename: filenamety read ffilename write ffilename;
 end;

implementation
uses
 msetabsglob;
type
 twidget1 = class(twidget);

constructor tazskin.create(aowner: tcomponent);
begin
 inherited;
 self.colors.count:= 14;
 tskincolor(self.colors.items[0]).color:= cl_background;
 tskincolor(self.colors.items[0]).rgb:= cl_background;
 tskincolor(self.colors.items[1]).color:= cl_foreground;
 tskincolor(self.colors.items[1]).rgb:= cl_foreground;
 tskincolor(self.colors.items[2]).color:= cl_active;
 tskincolor(self.colors.items[2]).rgb:= cl_active;
 tskincolor(self.colors.items[3]).color:= cl_noedit;
 tskincolor(self.colors.items[3]).rgb:= cl_noedit;
 tskincolor(self.colors.items[4]).color:= cl_text;
 tskincolor(self.colors.items[4]).rgb:= cl_text;
 tskincolor(self.colors.items[5]).color:= cl_selectedtext;
 tskincolor(self.colors.items[5]).rgb:= cl_selectedtext;
 tskincolor(self.colors.items[6]).color:= cl_selectedtextbackground;
 tskincolor(self.colors.items[6]).rgb:= cl_selectedtextbackground;
 tskincolor(self.colors.items[7]).color:= cl_infobackground;
 tskincolor(self.colors.items[7]).rgb:= cl_infobackground;
 tskincolor(self.colors.items[8]).color:= cl_glyph;
 tskincolor(self.colors.items[8]).rgb:= cl_glyph;
 tskincolor(self.colors.items[9]).color:= cl_activegrip;
 tskincolor(self.colors.items[9]).rgb:= cl_activegrip;
 tskincolor(self.colors.items[10]).color:= cl_empty;
 tskincolor(self.colors.items[10]).rgb:= cl_empty;
 tskincolor(self.colors.items[11]).color:= cl_emptytext;
 tskincolor(self.colors.items[11]).rgb:= cl_emptytext;
 tskincolor(self.colors.items[12]).color:= cl_emptytextbackground;
 tskincolor(self.colors.items[12]).rgb:= cl_emptytextbackground;
 tskincolor(self.colors.items[13]).color:= cl_zebra;
 tskincolor(self.colors.items[13]).rgb:= cl_zebra;

 fdefaultfont:= toptionalfont.create;
 fmenufont:= toptionalfont.create;
 fmessagefont:= toptionalfont.create;
 fbutton.font:= toptionalfont.create;
 fwidgetcolor.co:= cl_default;
 fwidgetcolor.cocaptionframe:= cl_default;
 fstepbutton.co:= cl_default;
 fdispwidget.color.co:= cl_default;
 fdispwidget.color.cocaptionframe:= cl_default;

 fdataedit.empty_color:= cl_default;
 fdataedit.empty_textcolor:= cl_default;
 fdataedit.empty_textcolorbackground:= cl_default;

 fbutton.co:= cl_default;
 fdatabutton.co:= cl_default;
 fframebutton.co:= cl_default;
 fframebutton.coglyph:= cl_default;
 ftabbar.tahorz.color:= cl_default;
 ftabbar.tahorz.coloractive:= cl_default;
 ftabbar.tahorz.shift:= defaulttabshift;
 ftabbar.tavert.color:= cl_default;
 ftabbar.tavert.coloractive:= cl_default;
 ftabbar.tavert.shift:= defaulttabshift;
 ftabbar.tahorzopo.color:= cl_default;
 ftabbar.tahorzopo.coloractive:= cl_default;
 ftabbar.tahorzopo.shift:= defaulttabshift;
 ftabbar.tavertopo.color:= cl_default;
 ftabbar.tavertopo.coloractive:= cl_default;
 ftabbar.tavertopo.shift:= defaulttabshift;
 self.fontalias.count:= 3;
 tskinfontalias(self.fontalias.items[0]).alias:= 'stf_default';
 tskinfontalias(self.fontalias.items[1]).alias:= 'stf_menu';
 tskinfontalias(self.fontalias.items[2]).alias:= 'stf_message';
end;

destructor tazskin.destroy;
begin
 active:= false;
 fbutton.font.free;
 fdefaultfont.free;
 fmenufont.free;
 fmessagefont.free;
 fdatabutton.font.free;
 inherited;
 {if fdataedit.wi.fra<>nil then begin
  if fdataedit.wi.fra.template.font<>nil then fdataedit.wi.fra.template.font.free;
 end;
 if fbooleanedit.wi.fra<>nil then begin
  if fbooleanedit.wi.fra.template.font<>nil then fbooleanedit.wi.fra.template.font.free;
 end;
 if fgrid.wi.fra<>nil then begin
  if fgrid.wi.fra.template.font<>nil then fgrid.wi.fra.template.font.free;
 end;
 if fgroupbox.wi.fra<>nil then begin
  if fgroupbox.wi.fra.template.font<>nil then fgroupbox.wi.fra.template.font.free;
 end;
 if fcontainer.wi.fra<>nil then begin
  if fcontainer.wi.fra.template.font<>nil then fcontainer.wi.fra.template.font.free;
 end;}
end;

procedure tazskin.loadtheme;
var
 str1: string;
 co1: integerarty;
 int1: integer;
begin
 if ffilename<>'' then begin
  if findfile(ffilename) then begin
   freader:= tstatreader.create(ffilename);
   fauthor:= 'Anonymous';
   fversion:= '';
   if freader.findsection('Copyright') then begin
    fauthor:= freader.readstring('Creator',fauthor);
    fversion:= freader.readstring('Version',fversion);
   end;
   if freader.findsection('SystemColors') then begin
    co1:= nil;
    setlength(co1,19);
    for int1:= 0 to 18 do begin
     co1[int1]:= cl_default;
    end;
    co1:= freader.readarray('Colors',co1);
    self.colors.colordkshadow:= co1[0];
    self.colors.colorshadow:= co1[1];
    self.colors.colorframe:= co1[2];
    self.colors.colorlight:= co1[3];
    self.colors.colorhighlight:= co1[4];
    for int1:= 5 to 18 do begin
     tskincolor(self.colors.items[int1-5]).rgb:= co1[int1];
    end;
   end;   
   if freader.findsection('Widget') then begin
    fwidgetcolor.co:= freader.readinteger('widgetcolor', fwidgetcolor.co);
    fwidgetcolor.cocaptionframe:= freader.readinteger('captionframecolor', fwidgetcolor.cocaptionframe);
   end;
   if freader.findsection('DefaultFont') then begin
    readfonttemplate('DefaultFont',freader,fdefaultfont);
   end;
   if freader.findsection('MenuFont') then begin
    readfonttemplate('MenuFont',freader,fmenufont);
   end;
   if freader.findsection('MessageFont') then begin
    readfonttemplate('MessageFont',freader,fmessagefont);
   end;
   tskinfontalias(self.fontalias.items[0]).name := fdefaultfont.name;
   tskinfontalias(self.fontalias.items[0]).width := fdefaultfont.width;
   tskinfontalias(self.fontalias.items[0]).height := fdefaultfont.height;
   self.font_default.color := fdefaultfont.color;
   self.font_default.colorbackground := fdefaultfont.colorbackground;
   self.font_default.shadow_color := fdefaultfont.shadow_color;
   self.font_default.shadow_shiftx := fdefaultfont.shadow_shiftx;
   self.font_default.shadow_shifty := fdefaultfont.shadow_shifty;
   self.font_default.gloss_color := fdefaultfont.gloss_color;
   self.font_default.gloss_shiftx := fdefaultfont.gloss_shiftx;
   self.font_default.gloss_shifty := fdefaultfont.gloss_shifty;
   self.font_default.style:= fdefaultfont.style;

   tskinfontalias(self.fontalias.items[1]).name := fmenufont.name;
   tskinfontalias(self.fontalias.items[1]).width := fmenufont.width;
   tskinfontalias(self.fontalias.items[1]).height := fmenufont.height;
   self.font_menu.color := fmenufont.color;
   self.font_menu.colorbackground := fmenufont.colorbackground;
   self.font_menu.shadow_color := fmenufont.shadow_color;
   self.font_menu.shadow_shiftx := fmenufont.shadow_shiftx;
   self.font_menu.shadow_shifty := fmenufont.shadow_shifty;
   self.font_menu.gloss_color := fmenufont.gloss_color;
   self.font_menu.gloss_shiftx := fmenufont.gloss_shiftx;
   self.font_menu.gloss_shifty := fmenufont.gloss_shifty;
   self.font_menu.style:= fmenufont.style;

   tskinfontalias(self.fontalias.items[2]).name := fmessagefont.name;
   tskinfontalias(self.fontalias.items[2]).width := fmessagefont.width;
   tskinfontalias(self.fontalias.items[2]).height := fmessagefont.height;
   self.font_message.color := fmessagefont.color;
   self.font_message.colorbackground := fmessagefont.colorbackground;
   self.font_message.shadow_color := fmessagefont.shadow_color;
   self.font_message.shadow_shiftx := fmessagefont.shadow_shiftx;
   self.font_message.shadow_shifty := fmessagefont.shadow_shifty;
   self.font_message.gloss_color := fmessagefont.gloss_color;
   self.font_message.gloss_shiftx := fmessagefont.gloss_shiftx;
   self.font_message.gloss_shifty := fmessagefont.gloss_shifty;
   self.font_message.style:= fmessagefont.style;

   self.fontalias.setfontalias;
   readframetemplate('GroupBox',freader, fgroupbox.wi.fra,fgroupbox_img);
   readfacetemplate('GroupBox',freader,fgroupbox.wi.fa);
   if fgroupbox.wi.fra<>nil then begin
    if freader.findsection('GroupBox-Font') then begin
     if fgroupbox.wi.fra.template.font=nil then fgroupbox.wi.fra.template.font:= toptionalfont.create;
     readfonttemplate('GroupBox',freader,fgroupbox.wi.fra.template.font);
    end else begin
     if fgroupbox.wi.fra.template.font<>nil then fgroupbox.wi.fra.template.font.free;
    end;
   end;
   if freader.findsection('Edit') then begin
    fdataedit.empty_text:= freader.readstring('empty_text',fdataedit.empty_text);
    fdataedit.empty_color:= freader.readinteger('empty_color',fdataedit.empty_color);
    str1:= freader.readstring('empty_fontstyle','');
    integer(tintegerset(fdataedit.empty_fontstyle)):=StringToSet(ptypeinfo(typeinfo(fdataedit.empty_fontstyle)),str1);
    str1:= freader.readstring('empty_textflags','');
    fdataedit.empty_textflags:=textflagsty(StringToSet(ptypeinfo(typeinfo(fdataedit.empty_textflags)),str1));
    fdataedit.empty_textcolor:= freader.readinteger('empty_textcolor',fdataedit.empty_textcolor);
    fdataedit.empty_textcolorbackground:= freader.readinteger('empty_textcolorbackground',fdataedit.empty_textcolorbackground);
   end;
   readframetemplate('Edit',freader,fdataedit.wi.fra,fdataedit_img);
   readfacetemplate('Edit',freader,fdataedit.wi.fa);
   if fdataedit.wi.fra<>nil then begin
    if freader.findsection('Edit-Font') then begin
     if fdataedit.wi.fra.template.font=nil then fdataedit.wi.fra.template.font:= toptionalfont.create;
     readfonttemplate('Edit',freader,fdataedit.wi.fra.template.font);
    end else begin
     if fdataedit.wi.fra.template.font<>nil then fdataedit.wi.fra.template.font.free;
    end;
   end;
   readframetemplate('BooleanEdit',freader,fbooleanedit.wi.fra,fbooleanedit_img);
   readfacetemplate('BooleanEdit',freader,fbooleanedit.wi.fa);
   if fbooleanedit.wi.fra<>nil then begin
    if freader.findsection('BooleanEdit-Font') then begin
     if fbooleanedit.wi.fra.template.font=nil then fbooleanedit.wi.fra.template.font:= toptionalfont.create;
     readfonttemplate('BooleanEdit',freader,fbooleanedit.wi.fra.template.font);
    end else begin
     if fbooleanedit.wi.fra.template.font<>nil then fbooleanedit.wi.fra.template.font.free;
    end;
   end;
   if freader.findsection('Button') then begin
    //fbutton.co:= cl_default;
    fbutton.co:= freader.readinteger('buttoncolor', fbutton.co);
   end;
   readframetemplate('Button',freader,fbutton.wi.fra,fbutton_img);
   readfacetemplate('Button',freader,fbutton.wi.fa);
   readfonttemplate('Button',freader,fbutton.font);
   if freader.findsection('DataButton') then begin
    fdatabutton.co:= cl_default;
    fdatabutton.co:= freader.readinteger('buttoncolor', fdatabutton.co);    
   end;
   readframetemplate('DataButton', freader, fdatabutton.wi.fra,fdatabutton_img);
   readfacetemplate('DataButton', freader,fdatabutton.wi.fa);
 
   readframetemplate('Container',freader, fcontainer.wi.fra,fcontainer_img);
   readfacetemplate('Container',freader,fcontainer.wi.fa);
   if fcontainer.wi.fra<>nil then begin
    if freader.findsection('Container-Font') then begin
     if fcontainer.wi.fra.template.font=nil then fcontainer.wi.fra.template.font:= toptionalfont.create;
     readfonttemplate('Container',freader,fcontainer.wi.fra.template.font);
    end else begin
     if fcontainer.wi.fra.template.font<>nil then fcontainer.wi.fra.template.font.free;
    end;
   end;

   if freader.findsection('FrameButton') then begin
    fframebutton.co:= cl_default;
    fframebutton.co:= freader.readinteger('buttoncolor', fframebutton.co);
   end;  
   readframetemplate('FrameButton',freader, fframebutton.fra,fframebutton_img);
   readfacetemplate('FrameButton',freader,fframebutton.fa);
   readframetemplate('StepButton',freader, fstepbutton.fra,fstepbutton_img);
   readfacetemplate('StepButton',freader,fstepbutton.fa);
   readframetemplate('Toolbar-Horizontal',freader, ftoolbar_horz.wi.fra,ftoolbar_horz_img);
   readfacetemplate('Toolbar-Horizontal',freader,ftoolbar_horz.wi.fa);
   readfacetemplate('Toolbar-Horizontal-Item',freader, ftoolbar_horz.buttonface);
   readframetemplate('Toolbar-Vertical',freader, ftoolbar_vert.wi.fra,ftoolbar_vert_img);
   readfacetemplate('Toolbar-Vertical',freader,ftoolbar_vert.wi.fa);
   readfacetemplate('Toolbar-Vertical-Item',freader, ftoolbar_vert.buttonface);
   readframetemplate('MainMenu',freader, fmainmenu.ma.frame,fmainmenu_ma_img);
   readfacetemplate('MainMenu',freader,fmainmenu.ma.face);
   readframetemplate('MainMenu-Item',freader, fmainmenu.ma.itemframe,fmainmenu_ma_item_img);
   readfacetemplate('MainMenu-Item',freader,fmainmenu.ma.itemface);
   readframetemplate('MainMenu-Item-Active',freader, fmainmenu.ma.itemframeactive,fmainmenu_ma_itemactive_img);
   readfacetemplate('MainMenu-Item-Active',freader,fmainmenu.ma.itemfaceactive);
   readframetemplate('Mainmenu-Popup',freader, fmainmenu.pop.frame,fmainmenu_pop_img);
   readfacetemplate('Mainmenu-Popup',freader,fmainmenu.pop.face);
   readframetemplate('Mainmenu-Popup-Item',freader, fmainmenu.pop.itemframe,fmainmenu_pop_item_img);
   readfacetemplate('Mainmenu-Popup-Item',freader,fmainmenu.pop.itemface);
   readframetemplate('Mainmenu-Popup-Item-Active',freader, fmainmenu.pop.itemframeactive, fmainmenu_pop_itemactive_img);
   readfacetemplate('Mainmenu-Popup-Item-Active',freader,fmainmenu.pop.itemfaceactive);
   readframetemplate('PopupMenu',freader, fpopupmenu.frame,fpopupmenu_img);
   readfacetemplate('PopupMenu',freader,fpopupmenu.face);
   readframetemplate('PopupMenu-Item',freader, fpopupmenu.itemframe,fpopupmenu_item_img);
   readfacetemplate('PopupMenu-Item',freader,fpopupmenu.itemface);
   readframetemplate('PopupMenu-Item-Active',freader, fpopupmenu.itemframeactive,fpopupmenu_itemactive_img);
   readfacetemplate('PopupMenu-Item-Active',freader,fpopupmenu.itemfaceactive);
   readframetemplate('Scrollbar-Horizontal-Button',freader, fsb_horz.framebu,fsb_horz_button_img);
   readfacetemplate('Scrollbar-Horizontal-Button',freader,fsb_horz.facebu);
   readframetemplate('Scrollbar-Horizontal-Start',freader, fsb_horz.frameendbu1,fsb_horz_end_img1);
   readframetemplate('Scrollbar-Horizontal-End',freader, fsb_horz.frameendbu2,fsb_horz_end_img2);
   readfacetemplate('Scrollbar-Horizontal-Arrow',freader,fsb_horz.faceendbu);
   readframetemplate('Scrollbar-Vertical-Button',freader, fsb_vert.framebu,fsb_vert_button_img);
   readfacetemplate('Scrollbar-Vertical-Button',freader,fsb_vert.facebu);
   readframetemplate('Scrollbar-Vertical-Start',freader, fsb_vert.frameendbu1,fsb_vert_end_img1);
   readframetemplate('Scrollbar-Vertical-End',freader, fsb_vert.frameendbu2,fsb_vert_end_img2);
   readfacetemplate('Scrollbar-Vertical-Arrow',freader,fsb_vert.faceendbu);
   readframetemplate('TabPage',freader, ftabpage.wi.fra,ftabpage_img);
   readfacetemplate('TabPage',freader,ftabpage.wi.fa);
   if freader.findsection('Tabbar-Horizontal-Top') then begin
    ftabbar.tahorz.shift:= freader.readinteger('Shift',ftabbar.tahorz.shift);
    ftabbar.tahorz.color:= freader.readinteger('TabColor',ftabbar.tahorz.color);
    ftabbar.tahorz.coloractive:= freader.readinteger('TabColorActive',ftabbar.tahorz.coloractive);
   end;
   readframetemplate('Tabbar-Horizontal-Top',freader, ftabbar.wihorz.fra,ftabbar_wihorz_img);
   readfacetemplate('Tabbar-Horizontal-Top',freader,ftabbar.wihorz.fa);
   readframetemplate('Tabbar-Horizontal-Top-Item',freader, ftabbar.tahorz.frame,ftabbar_tahorz_img);
   readfacetemplate('Tabbar-Horizontal-Top-Item',freader,ftabbar.tahorz.face);
   readfacetemplate('Tabbar-Horizontal-Top-Item-Active',freader,ftabbar.tahorz.faceactive);
   if freader.findsection('Tabbar-Horizontal-Bottom') then begin
    ftabbar.tahorzopo.shift:= freader.readinteger('Shift',ftabbar.tahorzopo.shift);
    ftabbar.tahorzopo.color:= freader.readinteger('TabColor',ftabbar.tahorzopo.color);
    ftabbar.tahorzopo.coloractive:= freader.readinteger('TabColorActive',ftabbar.tahorzopo.coloractive);
   end;
   readframetemplate('Tabbar-Horizontal-Bottom',freader, ftabbar.wihorzopo.fra,ftabbar_wihorzopo_img);
   readfacetemplate('Tabbar-Horizontal-Bottom',freader,ftabbar.wihorzopo.fa);
   readframetemplate('Tabbar-Horizontal-Bottom-Item',freader, ftabbar.tahorzopo.frame,ftabbar_tahorzopo_img);
   readfacetemplate('Tabbar-Horizontal-Bottom-Item',freader,ftabbar.tahorzopo.face);
   readfacetemplate('Tabbar-Horizontal-Bottom-Item-Active',freader,ftabbar.tahorzopo.faceactive);
   if freader.findsection('Tabbar-Vertical-Left') then begin
    ftabbar.tavert.shift:= freader.readinteger('Shift',ftabbar.tavert.shift);
    ftabbar.tavert.color:= freader.readinteger('TabColor',ftabbar.tavert.color);
    ftabbar.tavert.coloractive:= freader.readinteger('TabColorActive',ftabbar.tavert.coloractive);
   end;
   readframetemplate('Tabbar-Vertical-Left',freader, ftabbar.wivert.fra,ftabbar_wivert_img);
   readfacetemplate('Tabbar-Vertical-Left',freader,ftabbar.wivert.fa);
   readframetemplate('Tabbar-Vertical-Left-Item',freader, ftabbar.tavert.frame,ftabbar_tavert_img);
   readfacetemplate('Tabbar-Vertical-Left-Item',freader,ftabbar.tavert.face);
   readfacetemplate('Tabbar-Vertical-Left-Item-Active',freader,ftabbar.tavert.faceactive);
   if freader.findsection('Tabbar-Vertical-Right') then begin
    ftabbar.tavertopo.shift:= freader.readinteger('Shift',ftabbar.tavertopo.shift);
    ftabbar.tavertopo.color:= freader.readinteger('TabColor',ftabbar.tavertopo.color);
    ftabbar.tavertopo.coloractive:= freader.readinteger('TabColorActive',ftabbar.tavertopo.coloractive);
   end;
   readframetemplate('Tabbar-Vertical-Right',freader, ftabbar.wivertopo.fra,ftabbar_wivertopo_img);
   readfacetemplate('Tabbar-Vertical-Right',freader,ftabbar.wivertopo.fa);
   readframetemplate('Tabbar-Vertical-Right-Item',freader, ftabbar.tavertopo.frame,ftabbar_tavertopo_img);
   readfacetemplate('Tabbar-Vertical-Right-Item',freader,ftabbar.tavertopo.face);
   readfacetemplate('Tabbar-Vertical-Right-Item-Active',freader,ftabbar.tavertopo.faceactive);
   readframetemplate('Grid',freader, fgrid.wi.fra,fgrid_img);
   readfacetemplate('Grid',freader,fgrid.wi.fa);
   if fgrid.wi.fra<>nil then begin
    if freader.findsection('Grid-Font') then begin
     if fgrid.wi.fra.template.font=nil then fgrid.wi.fra.template.font:= toptionalfont.create;
     readfonttemplate('Grid',freader,fgrid.wi.fra.template.font);
    end else begin
     if fgrid.wi.fra.template.font<>nil then fgrid.wi.fra.template.font.free;
    end;
   end;
   readframetemplate('Grid-FixRows',freader, fgrid.fixrows.frame,ffixrows_img);
   readfacetemplate('Grid-FixRows',freader,fgrid.fixrows.face);
   readframetemplate('Grid-FixCols',freader, fgrid.fixcols.frame,ffixcols_img);
   readfacetemplate('Grid-FixCols',freader,fgrid.fixcols.face);
   readframetemplate('Grid-DataCols',freader, fgrid.datacols.frame,fdatacols_img);
   readfacetemplate('Grid-DataCols',freader,fgrid.datacols.face);
   if freader.findsection('DisplayWidget') then begin
    fdispwidget.color.co:= freader.readinteger('Color', fdispwidget.color.co);
    fdispwidget.color.cocaptionframe:= freader.readinteger('ColorCaptionFrame', fdispwidget.color.cocaptionframe);
   end;
   readframetemplate('DisplayWidget',freader,fdispwidget.wi.fra,fbutton_img);
   readfacetemplate('DisplayWidget',freader,fdispwidget.wi.fa);
   freader.free;
  end;
 end else begin
  self.active:= false;
 end;
 application.invalidate;
end;

procedure tazskin.writeframetemplate(const aname: string; const awriter: tstatwriter; var frame_comp: tframecomp);
var
 str1: string;
 int3: integer;
 procedure writefacelist(const alistname: string; const afacelist: tcustomface);
 var
  int1,int2: integer;
  rea1: realarty;
  co1: integerarty;
  str2: string;
 begin
  int1:= afacelist.fade_pos.count;
  if int1>0 then begin
   setlength(rea1,int1);
   for int2:= 0 to int1-1 do begin
    rea1[int2]:= afacelist.fade_pos[int2];
   end;
   fwriter.writearray(alistname+'-face_pos',rea1);
   setlength(co1,int1);
   for int2:= 0 to int1-1 do begin
    co1[int2]:= afacelist.fade_color[int2];
   end;
   fwriter.writearray(alistname+'-face_color',co1);
   fwriter.writeinteger(alistname+'-face_direction',ord(afacelist.fade_direction));
  end;
  if afacelist.image.hasimage then begin
   str2:= afacelist.image.writetostring('png',[]);
   str2:= bytestrtostr(str2);
   awriter.writestring(alistname+'-face-image',str2);
   str2:= settostring(ptypeinfo(typeinfo(afacelist.image.alignment)),
                integer(tintegerset(afacelist.image.alignment)),true);
   awriter.writestring(alistname+'-image-alignment',str2);
   str2:= settostring(ptypeinfo(typeinfo(afacelist.image.options)),
                integer(tintegerset(afacelist.image.options)),true);
   awriter.writestring(alistname+'-image-options',str2);
  end;
  str2:= settostring(ptypeinfo(typeinfo(afacelist.options)),
              integer(tintegerset(afacelist.options)),true);
  awriter.writestring(alistname+'-options',str2);
 end;
begin
 if frame_comp<>nil then begin
  awriter.writesection(aname+'-Frame');
  awriter.writeinteger('framewidth',frame_comp.template.framewidth);
  awriter.writeinteger('colorclient',frame_comp.template.colorclient);
  awriter.writeinteger('colorframe',frame_comp.template.colorframe);
  awriter.writeinteger('levelo',frame_comp.template.levelo);
  awriter.writeinteger('leveli',frame_comp.template.leveli);
  awriter.writeinteger('colorframeactive',frame_comp.template.colorframeactive);
  awriter.writeinteger('framei_left',frame_comp.template.framei_left);
  awriter.writeinteger('framei_top',frame_comp.template.framei_top);
  awriter.writeinteger('framei_right',frame_comp.template.framei_right);
  awriter.writeinteger('framei_bottom',frame_comp.template.framei_bottom);
  if (frame_comp.template.frameface_list<>nil) then begin
   if frame_comp.template.frameface_list.list.count>0 then begin
    awriter.writeinteger('frameface_list_count', frame_comp.template.frameface_list.list.count);
    awriter.writeinteger('frameface_offset', frame_comp.template.frameface_offset);
    awriter.writeinteger('frameface_offset1', frame_comp.template.frameface_offset1);
    awriter.writeinteger('frameface_offsetdisabled', frame_comp.template.frameface_offsetdisabled);
    awriter.writeinteger('frameface_offsetmouse',frame_comp.template.frameface_offsetmouse);
    awriter.writeinteger('frameface_offsetclicked', frame_comp.template.frameface_offsetclicked);
    awriter.writeinteger('frameface_offsetactive', frame_comp.template.frameface_offsetactive);
    awriter.writeinteger('frameface_offsetactivemouse', frame_comp.template.frameface_offsetactivemouse);
    awriter.writeinteger('frameface_offsetactiveclicked', frame_comp.template.frameface_offsetactiveclicked);
    for int3:=0 to frame_comp.template.frameface_list.list.count-1 do begin
     writefacelist('facelist-'+inttostr(int3),frame_comp.template.frameface_list.list.items[int3]);
    end;
   end;
  end;
  //awriter.writeinteger('font', frame_comp.template.font); //toptionalfont
  awriter.writeinteger('captiondist', frame_comp.template.captiondist); 
  awriter.writeinteger('captionoffset', frame_comp.template.captionoffset); 
  awriter.writeinteger('extraspace', frame_comp.template.extraspace);
  awriter.writeinteger('imagedist', frame_comp.template.imagedist);
  awriter.writeinteger('imagedisttop', frame_comp.template.imagedisttop);
  awriter.writeinteger('imagedistbottom', frame_comp.template.imagedistbottom);
  awriter.writeinteger('colordkshadow', frame_comp.template.colordkshadow);
  awriter.writeinteger('colorshadow', frame_comp.template.colorshadow);
  awriter.writeinteger('colorlight', frame_comp.template.colorlight);
  awriter.writeinteger('colorhighlight', frame_comp.template.colorhighlight);
  awriter.writeinteger('colordkwidth', frame_comp.template.colordkwidth);
  awriter.writeinteger('colorhlwidth', frame_comp.template.colorhlwidth);
  //awriter.writeinteger('hiddenedges', frame_comp.template.hiddenedges); //edgesty
  str1:= settostring(ptypeinfo(typeinfo(frame_comp.template.optionsskin)),
              integer(tintegerset(frame_comp.template.optionsskin)),true);
  awriter.writestring('optionsskin',str1);
  if frame_comp.template.frameimage_list<>nil then begin   
   str1:= frame_comp.template.frameimage_list.bitmap.writetostring('png',[]);
   str1:= bytestrtostr(str1);
   awriter.writestring('frame-image',str1);
   awriter.writeinteger('frame-image-count',frame_comp.template.frameimage_list.count);
   awriter.writeboolean('frame-image-masked',frame_comp.template.frameimage_list.masked);
   awriter.writeinteger('frame-image-width',frame_comp.template.frameimage_list.width);
   awriter.writeinteger('frame-image-height',frame_comp.template.frameimage_list.height);
   awriter.writeinteger('frame-image-offset',frame_comp.template.frameimage_offset);
   awriter.writeinteger('frame-image-offsetactive',frame_comp.template.frameimage_offsetactive);
   awriter.writeinteger('frame-image-offsetactiveclicked',frame_comp.template.frameimage_offsetactiveclicked);
   awriter.writeinteger('frame-image-offsetclicked',frame_comp.template.frameimage_offsetclicked);
   awriter.writeinteger('frame-image-offsetactivemouse',frame_comp.template.frameimage_offsetactivemouse);
   awriter.writeinteger('frame-image-offsetmouse',frame_comp.template.frameimage_offsetmouse);
   awriter.writeinteger('frame-image-offsetdisabled',frame_comp.template.frameimage_offsetdisabled);
   awriter.writeinteger('frame-image-left',frame_comp.template.frameimage_left);
   awriter.writeinteger('frame-image-right',frame_comp.template.frameimage_right);
   awriter.writeinteger('frame-image-top',frame_comp.template.frameimage_top);
   awriter.writeinteger('frame-image-bottom',frame_comp.template.frameimage_bottom);
  end;

 end;
end;

procedure tazskin.readframetemplate(const aname: string; const areader: tstatreader; var frame_comp: tframecomp; var aimage: timagelist);
var
 str1: string;
 int3,int4,int5: integer;
 bo1: boolean;

 procedure readfacelist(const alistname: string; const afacelist: tcustomface);
 var
  rea1: realarty;
  int1,int2: integer;
  co1: integerarty;
  str2: string;
 begin
  rea1:= nil;
  rea1:= freader.readarray(alistname+'-face_pos',rea1);
  int1:= length(rea1);
  if int1>0 then begin
   afacelist.fade_pos.count:= int1;
   for int2:= 0 to int1-1 do begin
    afacelist.fade_pos[int2]:= rea1[int2];
   end;
   co1:= nil;
   afacelist.fade_color.count:= int1;
   co1:= freader.readarray(alistname+'-face_color',co1);
   for int2:= 0 to int1-1 do begin
    afacelist.fade_color[int2]:= co1[int2];
   end;
   int2:= freader.readinteger(alistname+'-face_direction',ord(afacelist.fade_direction));
   afacelist.fade_direction:= graphicdirectionty(int2);
  end else begin
   afacelist.fade_pos.count:= 0;
  end;
  str2:= areader.readstring(alistname+'-face-image',str2);
  if str2<>'' then begin
   str2:= strtobytestr(str2);
   afacelist.image.loadfromstring(str2,'png');
   str2:= areader.readstring(alistname+'-image-alignment','');
   afacelist.image.alignment:=alignmentsty(StringToSet(ptypeinfo(typeinfo(afacelist.image.alignment)),str2));
   str2:= areader.readstring(alistname+'-image-options','');
   afacelist.image.options:=bitmapoptionsty(StringToSet(ptypeinfo(typeinfo(afacelist.image.options)),str2));
  end else begin
   afacelist.image.clear;
  end;
  str2:= areader.readstring(alistname+'-options','');
  afacelist.options:=faceoptionsty(StringToSet(ptypeinfo(typeinfo(afacelist.options)),str2));
 end;

begin
 if areader.findsection(aname+'-Frame') then begin
  if frame_comp=nil then frame_comp:= tframecomp.create(self);
   frame_comp.template.framewidth:=  areader.readinteger('framewidth',frame_comp.template.framewidth);
   frame_comp.template.colorclient:=  areader.readinteger('colorclient',frame_comp.template.colorclient);
   frame_comp.template.colorframe:=  areader.readinteger('colorframe',frame_comp.template.colorframe);
   frame_comp.template.levelo:=  areader.readinteger('levelo',frame_comp.template.levelo);
   frame_comp.template.leveli:=  areader.readinteger('leveli',frame_comp.template.leveli);
   frame_comp.template.colorframeactive:=  areader.readinteger('colorframeactive',frame_comp.template.colorframeactive);
   frame_comp.template.framei_left:=  areader.readinteger('framei_left',frame_comp.template.framei_left);
   frame_comp.template.framei_top:=  areader.readinteger('framei_top',frame_comp.template.framei_top);
   frame_comp.template.framei_right:=  areader.readinteger('framei_right',frame_comp.template.framei_right);
   frame_comp.template.framei_bottom:=  areader.readinteger('framei_bottom',frame_comp.template.framei_bottom);
   str1:= '';
   str1:= areader.readstring('frame-image',str1);
   if str1<>'' then begin   
    str1:= strtobytestr(str1);
    if aimage=nil then aimage:= timagelist.create(frame_comp);
    int3:= 0;
    int3:= areader.readinteger('frame-image-width',int3);
    aimage.width:= int3;
    int3:= 0;
    int3:= areader.readinteger('frame-image-height',int3);
    aimage.height:= int3;
    int3:= 0;
    int3:= areader.readinteger('frame-image-count',int3);
    aimage.count:= int3;
    bo1:= false;
    bo1:= areader.readboolean('frame-image-masked',bo1);
    aimage.masked:= bo1;
    aimage.bitmap.loadfromstring(str1,'png');
    frame_comp.template.frameimage_list:= aimage;
    frame_comp.template.frameimage_left:=  areader.readinteger('frame-image-left',frame_comp.template.frameimage_left);
    frame_comp.template.frameimage_top:=  areader.readinteger('frame-image-top',frame_comp.template.frameimage_top);
    frame_comp.template.frameimage_right:=  areader.readinteger('frame-image-right',frame_comp.template.frameimage_right);
    frame_comp.template.frameimage_bottom:=  areader.readinteger('frame-image-bottom',frame_comp.template.frameimage_bottom);
    frame_comp.template.frameimage_offset:=  areader.readinteger('frame-image-offset' ,frame_comp.template.frameimage_offset);
    frame_comp.template.frameimage_offsetdisabled:=   areader.readinteger('frame-image-offsetdisabled' ,frame_comp.template.frameimage_offsetdisabled);
    frame_comp.template.frameimage_offsetmouse:=  areader.readinteger('frame-image-offsetmouse', frame_comp.template.frameimage_offsetmouse);
    frame_comp.template.frameimage_offsetclicked:=  areader.readinteger('frame-image-offsetclicked', frame_comp.template.frameimage_offsetclicked);
    frame_comp.template.frameimage_offsetactive:=  areader.readinteger('frame-image-offsetactive', frame_comp.template.frameimage_offsetactive);
    frame_comp.template.frameimage_offsetactivemouse:=  areader.readinteger('frame-image-offsetactivemouse', frame_comp.template.frameimage_offsetactivemouse);
    frame_comp.template.frameimage_offsetactiveclicked:=  areader.readinteger('frame-image-offsetactiveclicked', frame_comp.template.frameimage_offsetactiveclicked);
   end else begin
    if aimage<>nil then freeandnil(aimage);
   end;
   int4:= 0;
   int4:=  areader.readinteger('frameface_list_count', int4);
   frame_comp.template.frameface_offset:=  areader.readinteger('frameface_offset', frame_comp.template.frameface_offset);
   frame_comp.template.frameface_offset1:=  areader.readinteger('frameface_offset1', frame_comp.template.frameface_offset1);
   frame_comp.template.frameface_offsetdisabled:=  areader.readinteger('frameface_offsetdisabled', frame_comp.template.frameface_offsetdisabled);
   frame_comp.template.frameface_offsetmouse:=  areader.readinteger('frameface_offsetmouse',frame_comp.template.frameface_offsetmouse);
   frame_comp.template.frameface_offsetclicked:=  areader.readinteger('frameface_offsetclicked', frame_comp.template.frameface_offsetclicked);
   frame_comp.template.frameface_offsetactive:=  areader.readinteger('frameface_offsetactive', frame_comp.template.frameface_offsetactive);
   frame_comp.template.frameface_offsetactivemouse:=  areader.readinteger('frameface_offsetactivemouse', frame_comp.template.frameface_offsetactivemouse);
   frame_comp.template.frameface_offsetactiveclicked:=  areader.readinteger('frameface_offsetactiveclicked', frame_comp.template.frameface_offsetactiveclicked);
   if int4>0 then begin
    if aname='Button' then begin
     if fbutton_fl=nil then begin
      fbutton_fl:= tfacelist.create(self);
     end else begin
      fbutton_fl.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fbutton_fl;
    end else if aname='FrameButton' then begin
     if fframebutton_fl=nil then begin
      fframebutton_fl:= tfacelist.create(self);
     end else begin
      fframebutton_fl.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fframebutton_fl;
    end else if aname='DataButton' then begin
     if fdatabutton_fl=nil then begin
      fdatabutton_fl:= tfacelist.create(self);
     end else begin
      fdatabutton_fl.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fdatabutton_fl;
    end else if aname='StepButton' then begin
     if fstepbutton_fl=nil then begin
      fstepbutton_fl:= tfacelist.create(self);
     end else begin
      fstepbutton_fl.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fstepbutton_fl;
    end else if aname='BooleanEdit' then begin
     if fbooleanedit_fl=nil then begin
      fbooleanedit_fl:= tfacelist.create(self);
     end else begin
      fbooleanedit_fl.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fbooleanedit_fl;
    end else if aname='Scrollbar-Horizontal-Button' then begin
     if fsb_horz_button_fl=nil then begin
      fsb_horz_button_fl:= tfacelist.create(self);
     end else begin
      fsb_horz_button_fl.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fsb_horz_button_fl;
    end else if aname='Scrollbar-Horizontal-Start' then begin
     if fsb_horz_end_fl1=nil then begin
      fsb_horz_end_fl1:= tfacelist.create(self);
     end else begin
      fsb_horz_end_fl1.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fsb_horz_end_fl1;
    end else if aname='Scrollbar-Horizontal-End' then begin
     if fsb_horz_end_fl2=nil then begin
      fsb_horz_end_fl2:= tfacelist.create(self);
     end else begin
      fsb_horz_end_fl2.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fsb_horz_end_fl2;
    end else if aname='Scrollbar-Vertical-Button' then begin
     if fsb_vert_button_fl=nil then begin
      fsb_vert_button_fl:= tfacelist.create(self);
     end else begin
      fsb_vert_button_fl.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fsb_vert_button_fl;
    end else if aname='Scrollbar-Vertical-Start' then begin
     if fsb_vert_end_fl1=nil then begin
      fsb_vert_end_fl1:= tfacelist.create(self);
     end else begin
      fsb_vert_end_fl1.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fsb_vert_end_fl1;
    end else if aname='Scrollbar-Vertical-End' then begin
     if fsb_vert_end_fl2=nil then begin
      fsb_vert_end_fl2:= tfacelist.create(self);
     end else begin
      fsb_vert_end_fl2.list.count:= 0;
     end;
     frame_comp.template.frameface_list:= fsb_vert_end_fl2;
    end;


    frame_comp.template.frameface_list.list.count:= int4;
    for int5:=0 to int4-1 do begin
     readfacelist('facelist-'+inttostr(int5),frame_comp.template.frameface_list.list.items[int5]);
    end;
   end;
   //frame_comp.template.font:=  areader.readinteger('font', frame_comp.template.font);
   frame_comp.template.captiondist:=   areader.readinteger('captiondist', frame_comp.template.captiondist);
   frame_comp.template.captionoffset:=   areader.readinteger('captionoffset', frame_comp.template.captionoffset);
   frame_comp.template.extraspace:=  areader.readinteger('extraspace', frame_comp.template.extraspace);
   frame_comp.template.imagedist:=  areader.readinteger('imagedist', frame_comp.template.imagedist);
   frame_comp.template.imagedisttop:=  areader.readinteger('imagedisttop', frame_comp.template.imagedisttop);
   frame_comp.template.imagedistbottom:=  areader.readinteger('imagedistbottom', frame_comp.template.imagedistbottom);
   frame_comp.template.colordkshadow:=  areader.readinteger('colordkshadow', frame_comp.template.colordkshadow);
   frame_comp.template.colorshadow:=  areader.readinteger('colorshadow', frame_comp.template.colorshadow);
   frame_comp.template.colorlight:=  areader.readinteger('colorlight', frame_comp.template.colorlight);
   frame_comp.template.colorhighlight:=  areader.readinteger('colorhighlight', frame_comp.template.colorhighlight);
   frame_comp.template.colordkwidth:=  areader.readinteger('colordkwidth', frame_comp.template.colordkwidth);
   frame_comp.template.colorhlwidth:=  areader.readinteger('colorhlwidth', frame_comp.template.colorhlwidth);
   //frame_comp.template.hiddenedges:=  areader.readinteger('hiddenedges', frame_comp.template.hiddenedges:);
   str1:= areader.readstring('optionsskin','');
   frame_comp.template.optionsskin:=frameskinoptionsty(StringToSet(ptypeinfo(typeinfo(frame_comp.template.optionsskin)),str1));
 end else begin
  if frame_comp<>nil then begin
   if frame_comp.template.font<>nil then frame_comp.template.font.free;
   freeandnil(frame_comp);
  end;
 end;
end;

procedure tazskin.writefacetemplate(const aname: string; const awriter: tstatwriter; var face_comp: tfacecomp);
var
 int1,int2: integer;
 rea1: realarty;
 co1: integerarty;
 str1: string;
begin
 if face_comp<>nil then begin
  awriter.writesection(aname+'-Face');
  int1:= face_comp.template.fade_pos.count;
  if int1>0 then begin
   setlength(rea1,int1);
   for int2:= 0 to int1-1 do begin
    rea1[int2]:= face_comp.template.fade_pos[int2];
   end;
   fwriter.writearray('face_pos',rea1);
   setlength(co1,int1);
   for int2:= 0 to int1-1 do begin
    co1[int2]:= face_comp.template.fade_color[int2];
   end;
   fwriter.writearray('face_color',co1);
   fwriter.writeinteger('face_direction',ord(face_comp.template.fade_direction));
  end;
  if face_comp.template.image.hasimage then begin
   str1:= face_comp.template.image.writetostring('png',[]);
   str1:= bytestrtostr(str1);
   awriter.writestring('face-image',str1);
   str1:= settostring(ptypeinfo(typeinfo(face_comp.template.image.alignment)),
                integer(tintegerset(face_comp.template.image.alignment)),true);
   awriter.writestring('image-alignment',str1);
   str1:= settostring(ptypeinfo(typeinfo(face_comp.template.image.options)),
                integer(tintegerset(face_comp.template.image.options)),true);
   awriter.writestring('image-options',str1);
  end;
  str1:= settostring(ptypeinfo(typeinfo(face_comp.template.options)),
              integer(tintegerset(face_comp.template.options)),true);
  awriter.writestring('options',str1);
 end;
end;

procedure tazskin.readfacetemplate(const aname: string; const areader: tstatreader; var face_comp: tfacecomp);
var
 rea1: realarty;
 int1,int2: integer;
 co1: integerarty;
 str1: string;
begin
 if areader.findsection(aname+'-Face') then begin
  if face_comp=nil then face_comp:= tfacecomp.create(self);
  rea1:= nil;
  rea1:= freader.readarray('face_pos',rea1);
  int1:= length(rea1);
  if int1>0 then begin
   face_comp.template.fade_pos.count:= int1;
   for int2:= 0 to int1-1 do begin
    face_comp.template.fade_pos[int2]:= rea1[int2];
   end;
   co1:= nil;
   face_comp.template.fade_color.count:= int1;
   co1:= freader.readarray('face_color',co1);
   for int2:= 0 to int1-1 do begin
    face_comp.template.fade_color[int2]:= co1[int2];
   end;
   int2:= freader.readinteger('face_direction',ord(face_comp.template.fade_direction));
   face_comp.template.fade_direction:= graphicdirectionty(int2);
  end else begin
   face_comp.template.fade_pos.count:= 0;
  end;
  str1:= areader.readstring('face-image',str1);
  if str1<>'' then begin
   str1:= strtobytestr(str1);
   face_comp.template.image.loadfromstring(str1,'png');
   str1:= areader.readstring('image-alignment','');
   face_comp.template.image.alignment:=alignmentsty(StringToSet(ptypeinfo(typeinfo(face_comp.template.image.alignment)),str1));
   str1:= areader.readstring('image-options','');
   face_comp.template.image.options:=bitmapoptionsty(StringToSet(ptypeinfo(typeinfo(face_comp.template.image.options)),str1));
  end else begin
   face_comp.template.image.clear;
  end;
  str1:= areader.readstring('options','');
  face_comp.template.options:=faceoptionsty(StringToSet(ptypeinfo(typeinfo(face_comp.template.options)),str1));
 end else begin
  if face_comp<>nil then freeandnil(face_comp);
 end;
end;

procedure tazskin.readfonttemplate(const aname: string; const areader: tstatreader; const afont: toptionalfont);
var
 str1: string;
begin
 if areader.findsection(aname+'-Font') then begin
  afont.name := areader.readstring('fontname', afont.name);
  afont.width := areader.readinteger('fontwidth', afont.width);
  afont.height := areader.readinteger('fontheight', afont.height);
  afont.color := areader.readinteger('textcolor', afont.color);
  afont.colorbackground := areader.readinteger('textcolorbg', afont.colorbackground);
  afont.shadow_color := areader.readinteger('shadowcolor', afont.shadow_color);
  afont.shadow_shiftx := areader.readinteger('shadowx', afont.shadow_shiftx);
  afont.shadow_shifty := areader.readinteger('shadowy', afont.shadow_shifty);
  afont.gloss_color := areader.readinteger('glosscolor', afont.gloss_color);
  afont.gloss_shiftx := areader.readinteger('glossx', afont.gloss_shiftx);
  afont.gloss_shifty := areader.readinteger('glossy', afont.gloss_shifty);
  str1:= areader.readstring('fontstyle','');
  afont.style:=fontstylesty(StringToSet(ptypeinfo(typeinfo(afont.style)),str1));
 end;
end;

procedure tazskin.writefonttemplate(const aname: string; const awriter: tstatwriter; const afont: toptionalfont);
var
 str1: string;
begin
 awriter.writesection(aname+'-Font');
 awriter.writestring('fontname', afont.name);
 awriter.writeinteger('fontwidth', afont.width);
 awriter.writeinteger('fontheight', afont.height);
 awriter.writeinteger('textcolor', afont.color);
 awriter.writeinteger('textcolorbg', afont.colorbackground);
 awriter.writeinteger('shadowcolor', afont.shadow_color);
 awriter.writeinteger('shadowx', afont.shadow_shiftx);
 awriter.writeinteger('shadowy', afont.shadow_shifty);
 awriter.writeinteger('glosscolor', afont.gloss_color);
 awriter.writeinteger('glossx', afont.gloss_shiftx);
 awriter.writeinteger('glossy', afont.gloss_shifty);
 str1:= settostring(ptypeinfo(typeinfo(afont.style)),
              integer(tintegerset(afont.style)),true);
 awriter.writestring('fontstyle',str1);
end;

procedure tazskin.savetheme;
var
 str1: string;
 int1: integer;
 co1: integerarty;
begin
 if ffilename<>'' then begin
  fwriter:= tstatwriter.create(ffilename);
  fwriter.writesection('Copyright');
  fwriter.writestring('Creator',fauthor);
  fwriter.writestring('Version',fversion);
  fwriter.writesection('SystemColors');
  co1:= nil;
  setlength(co1,19);
  co1[0]:= self.colors.colordkshadow;
  co1[1]:= self.colors.colorshadow;
  co1[2]:= self.colors.colorframe;
  co1[3]:= self.colors.colorlight;
  co1[4]:= self.colors.colorhighlight;
  for int1:= 5 to 18 do begin
   co1[int1]:= tskincolor(self.colors.items[int1-5]).rgb;
  end;
  fwriter.writearray('Colors', co1);

  fwriter.writesection('Widget');
  fwriter.writeinteger('widgetcolor', fwidgetcolor.co);
  fwriter.writeinteger('captionframecolor', fwidgetcolor.cocaptionframe);

  fdefaultfont.name :=  frmchangeskinfo.wfontname.value;
  fdefaultfont.width :=  frmchangeskinfo.wfontwidth.value;
  fdefaultfont.height :=  frmchangeskinfo.wfontheight.value;
  fdefaultfont.color :=  frmchangeskinfo.wtextcolor.value;
  fdefaultfont.colorbackground :=  frmchangeskinfo.wtextcolorbg.value;
  fdefaultfont.shadow_color :=  frmchangeskinfo.wshadowcolor.value;
  fdefaultfont.shadow_shiftx :=  frmchangeskinfo.wshadowx.value;
  fdefaultfont.shadow_shifty :=  frmchangeskinfo.wshadowy.value;
  fdefaultfont.gloss_color :=  frmchangeskinfo.wglosscolor.value;
  fdefaultfont.gloss_shiftx :=  frmchangeskinfo.wglossx.value;
  fdefaultfont.gloss_shifty :=  frmchangeskinfo.wglossy.value;
  if frmchangeskinfo.wbold.value then begin
   fdefaultfont.style:= fdefaultfont.style + [fs_bold];
  end else begin
   fdefaultfont.style:= fdefaultfont.style - [fs_bold];
  end;
  if frmchangeskinfo.witalic.value then begin
   fdefaultfont.style:= fdefaultfont.style + [fs_italic];
  end else begin
   fdefaultfont.style:= fdefaultfont.style - [fs_italic];
  end;
  if frmchangeskinfo.wunderline.value then begin
   fdefaultfont.style:= fdefaultfont.style + [fs_underline];
  end else begin
   fdefaultfont.style:= fdefaultfont.style - [fs_underline];
  end;
  if frmchangeskinfo.wstrikeout.value then begin
   fdefaultfont.style:= fdefaultfont.style + [fs_strikeout];
  end else begin
   fdefaultfont.style:= fdefaultfont.style - [fs_strikeout];
  end;  
  fwriter.writesection('DefaultFont');
  writefonttemplate('DefaultFont',fwriter,fdefaultfont);


  fmenufont.name :=  frmchangeskinfo.wfontname1.value;
  fmenufont.width :=  frmchangeskinfo.wfontwidth1.value;
  fmenufont.height :=  frmchangeskinfo.wfontheight1.value;
  fmenufont.color :=  frmchangeskinfo.wtextcolor1.value;
  fmenufont.colorbackground :=  frmchangeskinfo.wtextcolorbg1.value;
  fmenufont.shadow_color :=  frmchangeskinfo.wshadowcolor1.value;
  fmenufont.shadow_shiftx :=  frmchangeskinfo.wshadowx1.value;
  fmenufont.shadow_shifty :=  frmchangeskinfo.wshadowy1.value;
  fmenufont.gloss_color :=  frmchangeskinfo.wglosscolor1.value;
  fmenufont.gloss_shiftx :=  frmchangeskinfo.wglossx1.value;
  fmenufont.gloss_shifty :=  frmchangeskinfo.wglossy1.value;
  if frmchangeskinfo.wbold1.value then begin
   fmenufont.style:= fmenufont.style + [fs_bold];
  end else begin
   fmenufont.style:= fmenufont.style - [fs_bold];
  end;
  if frmchangeskinfo.witalic1.value then begin
   fmenufont.style:= fmenufont.style + [fs_italic];
  end else begin
   fmenufont.style:= fmenufont.style - [fs_italic];
  end;
  if frmchangeskinfo.wunderline1.value then begin
   fmenufont.style:= fmenufont.style + [fs_underline];
  end else begin
   fmenufont.style:= fmenufont.style - [fs_underline];
  end;
  if frmchangeskinfo.wstrikeout1.value then begin
   fmenufont.style:= fmenufont.style + [fs_strikeout];
  end else begin
   fmenufont.style:= fmenufont.style - [fs_strikeout];
  end;  
  fwriter.writesection('MenuFont');
  writefonttemplate('MenuFont',fwriter,fmenufont);

  fmessagefont.name :=  frmchangeskinfo.wfontname2.value;
  fmessagefont.width :=  frmchangeskinfo.wfontwidth2.value;
  fmessagefont.height :=  frmchangeskinfo.wfontheight2.value;
  fmessagefont.color :=  frmchangeskinfo.wtextcolor2.value;
  fmessagefont.colorbackground :=  frmchangeskinfo.wtextcolorbg2.value;
  fmessagefont.shadow_color :=  frmchangeskinfo.wshadowcolor2.value;
  fmessagefont.shadow_shiftx :=  frmchangeskinfo.wshadowx2.value;
  fmessagefont.shadow_shifty :=  frmchangeskinfo.wshadowy2.value;
  fmessagefont.gloss_color :=  frmchangeskinfo.wglosscolor2.value;
  fmessagefont.gloss_shiftx :=  frmchangeskinfo.wglossx2.value;
  fmessagefont.gloss_shifty :=  frmchangeskinfo.wglossy2.value;
  if frmchangeskinfo.wbold2.value then begin
   fmessagefont.style:= fmessagefont.style + [fs_bold];
  end else begin
   fmessagefont.style:= fmessagefont.style - [fs_bold];
  end;
  if frmchangeskinfo.witalic2.value then begin
   fmessagefont.style:= fmessagefont.style + [fs_italic];
  end else begin
   fmessagefont.style:= fmessagefont.style - [fs_italic];
  end;
  if frmchangeskinfo.wunderline2.value then begin
   fmessagefont.style:= fmessagefont.style + [fs_underline];
  end else begin
   fmessagefont.style:= fmessagefont.style - [fs_underline];
  end;
  if frmchangeskinfo.wstrikeout2.value then begin
   fmessagefont.style:= fmessagefont.style + [fs_strikeout];
  end else begin
   fmessagefont.style:= fmessagefont.style - [fs_strikeout];
  end;  
  fwriter.writesection('MessageFont');
  writefonttemplate('MessageFont',fwriter,fmessagefont);
      
  fwriter.writesection('Edit');
  fwriter.writestring('empty_text', fdataedit.empty_text);
  fwriter.writeinteger('empty_color',fdataedit.empty_color);
  str1:= settostring(ptypeinfo(typeinfo(fdataedit.empty_fontstyle)),
               integer(tintegerset(fdataedit.empty_fontstyle)),true);
  fwriter.writestring('empty_fontstyle',str1); 
  str1:= settostring(ptypeinfo(typeinfo(fdataedit.empty_textflags)),
               integer(tintegerset(fdataedit.empty_textflags)),true);
  fwriter.writestring('empty_textflags',str1); 
  fwriter.writeinteger('empty_textcolor', fdataedit.empty_textcolor);
  fwriter.writeinteger('empty_textcolorbackground',fdataedit.empty_textcolorbackground); 
  fwriter.writeinteger('empty_textcolorbackground',fdataedit.empty_textcolorbackground); 
  writeframetemplate('Edit',fwriter, fdataedit.wi.fra);
  writefacetemplate('Edit',fwriter,fdataedit.wi.fa);
  if fdataedit.wi.fra<>nil then begin
   if fdataedit.wi.fra.template.font<>nil then begin
    writefonttemplate('Edit',fwriter,fdataedit.wi.fra.template.font);
   end;
  end;

  writeframetemplate('BooleanEdit',fwriter, fbooleanedit.wi.fra);
  writefacetemplate('BooleanEdit',fwriter,fbooleanedit.wi.fa);
  if fbooleanedit.wi.fra<>nil then begin
   if fbooleanedit.wi.fra.template.font<>nil then begin
    writefonttemplate('BooleanEdit',fwriter,fbooleanedit.wi.fra.template.font);
   end;
  end;
  fwriter.writesection('Button');
  fwriter.writeinteger('buttoncolor', fbutton.co);
  writeframetemplate('Button',fwriter, fbutton.wi.fra);
  writefacetemplate('Button',fwriter,fbutton.wi.fa);
  writefonttemplate('Button',fwriter,fbutton.font);

  fwriter.writesection('DataButton');
  fwriter.writeinteger('buttoncolor', fdatabutton.co);
  writeframetemplate('DataButton',fwriter, fdatabutton.wi.fra);
  writefacetemplate('DataButton',fwriter,fdatabutton.wi.fa);

  writeframetemplate('Container',fwriter, fcontainer.wi.fra);
  writefacetemplate('Container',fwriter,fcontainer.wi.fa);
  if fcontainer.wi.fra<>nil then begin
   if fcontainer.wi.fra.template.font<>nil then begin
    writefonttemplate('Container',fwriter,fcontainer.wi.fra.template.font);
   end;
  end;

  fwriter.writesection('FrameButton');
  fwriter.writeinteger('buttoncolor', fframebutton.co);
  writeframetemplate('FrameButton',fwriter, fframebutton.fra);
  writefacetemplate('FrameButton',fwriter,fframebutton.fa);
  
  writeframetemplate('StepButton',fwriter, fstepbutton.fra);
  writefacetemplate('StepButton',fwriter,fstepbutton.fa);

  writeframetemplate('Toolbar-Horizontal',fwriter, ftoolbar_horz.wi.fra);
  writefacetemplate('Toolbar-Horizontal',fwriter,ftoolbar_horz.wi.fa);

  writefacetemplate('Toolbar-Horizontal-Item',fwriter, ftoolbar_horz.buttonface);

  writeframetemplate('Toolbar-Vertical',fwriter, ftoolbar_vert.wi.fra);
  writefacetemplate('Toolbar-Vertical',fwriter,ftoolbar_vert.wi.fa);

  writefacetemplate('Toolbar-Vertical-Item',fwriter, ftoolbar_vert.buttonface);

  writeframetemplate('GroupBox',fwriter, fgroupbox.wi.fra);
  writefacetemplate('GroupBox',fwriter,fgroupbox.wi.fa);
  if fgroupbox.wi.fra<>nil then begin
   if fgroupbox.wi.fra.template.font<>nil then begin
    writefonttemplate('GroupBox',fwriter,fgroupbox.wi.fra.template.font);
   end;
  end;

  writeframetemplate('MainMenu',fwriter, fmainmenu.ma.frame);
  writefacetemplate('MainMenu',fwriter,fmainmenu.ma.face);

  writeframetemplate('MainMenu-Item',fwriter, fmainmenu.ma.itemframe);
  writefacetemplate('MainMenu-Item',fwriter,fmainmenu.ma.itemface);

  writeframetemplate('MainMenu-Item-Active',fwriter, fmainmenu.ma.itemframeactive);
  writefacetemplate('MainMenu-Item-Active',fwriter,fmainmenu.ma.itemfaceactive);

  writeframetemplate('Mainmenu-Popup',fwriter, fmainmenu.pop.frame);
  writefacetemplate('Mainmenu-Popup',fwriter,fmainmenu.pop.face);

  writeframetemplate('Mainmenu-Popup-Item',fwriter, fmainmenu.pop.itemframe);
  writefacetemplate('Mainmenu-Popup-Item',fwriter,fmainmenu.pop.itemface);

  writeframetemplate('Mainmenu-Popup-Item-Active',fwriter, fmainmenu.pop.itemframeactive);
  writefacetemplate('Mainmenu-Popup-Item-Active',fwriter,fmainmenu.pop.itemfaceactive);

  writeframetemplate('PopupMenu',fwriter, fpopupmenu.frame);
  writefacetemplate('PopupMenu',fwriter,fpopupmenu.face);

  writeframetemplate('PopupMenu-Item',fwriter, fpopupmenu.itemframe);
  writefacetemplate('PopupMenu-Item',fwriter,fpopupmenu.itemface);

  writeframetemplate('PopupMenu-Item-Active',fwriter, fpopupmenu.itemframeactive);
  writefacetemplate('PopupMenu-Item-Active',fwriter,fpopupmenu.itemfaceactive);

  writeframetemplate('Scrollbar-Horizontal-Button',fwriter, fsb_horz.framebu);
  writefacetemplate('Scrollbar-Horizontal-Button',fwriter,fsb_horz.facebu);

  writeframetemplate('Scrollbar-Horizontal-Start',fwriter, fsb_horz.frameendbu1);

  writeframetemplate('Scrollbar-Horizontal-End',fwriter, fsb_horz.frameendbu2);
  
  writefacetemplate('Scrollbar-Horizontal-Arrow',fwriter,fsb_horz.faceendbu);

  writeframetemplate('Scrollbar-Vertical-Button',fwriter, fsb_vert.framebu);
  writefacetemplate('Scrollbar-Vertical-Button',fwriter,fsb_vert.facebu);

  writeframetemplate('Scrollbar-Vertical-Start',fwriter, fsb_vert.frameendbu1);

  writeframetemplate('Scrollbar-Vertical-End',fwriter, fsb_vert.frameendbu2);
  
  writefacetemplate('Scrollbar-Vertical-Arrow',fwriter,fsb_vert.faceendbu);

  writeframetemplate('TabPage',fwriter, ftabpage.wi.fra);
  writefacetemplate('TabPage',fwriter,ftabpage.wi.fa);

  fwriter.writesection('Tabbar-Horizontal-Top');
  fwriter.writeinteger('Shift',ftabbar.tahorz.shift);
  fwriter.writeinteger('TabColor',ftabbar.tahorz.color);
  fwriter.writeinteger('TabColorActive',ftabbar.tahorz.coloractive);
  writeframetemplate('Tabbar-Horizontal-Top',fwriter, ftabbar.wihorz.fra);
  writefacetemplate('Tabbar-Horizontal-Top',fwriter,ftabbar.wihorz.fa);

  writeframetemplate('Tabbar-Horizontal-Top-Item',fwriter, ftabbar.tahorz.frame);
  writefacetemplate('Tabbar-Horizontal-Top-Item',fwriter,ftabbar.tahorz.face);

  writefacetemplate('Tabbar-Horizontal-Top-Item-Active',fwriter,ftabbar.tahorz.faceactive);

  fwriter.writesection('Tabbar-Horizontal-Bottom');
  fwriter.writeinteger('Shift',ftabbar.tahorzopo.shift);
  fwriter.writeinteger('TabColor',ftabbar.tahorzopo.color);
  fwriter.writeinteger('TabColorActive',ftabbar.tahorzopo.coloractive);

  writeframetemplate('Tabbar-Horizontal-Bottom',fwriter, ftabbar.wihorzopo.fra);
  writefacetemplate('Tabbar-Horizontal-Bottom',fwriter,ftabbar.wihorzopo.fa);

  writeframetemplate('Tabbar-Horizontal-Bottom-Item',fwriter, ftabbar.tahorzopo.frame);
  writefacetemplate('Tabbar-Horizontal-Bottom-Item',fwriter,ftabbar.tahorzopo.face);

  writefacetemplate('Tabbar-Horizontal-Bottom-Item-Active',fwriter,ftabbar.tahorzopo.faceactive);

  fwriter.writesection('Tabbar-Vertical-Left');
  fwriter.writeinteger('Shift',ftabbar.tavert.shift);
  fwriter.writeinteger('TabColor',ftabbar.tavert.color);
  fwriter.writeinteger('TabColorActive',ftabbar.tavert.coloractive);
  writeframetemplate('Tabbar-Vertical-Left',fwriter, ftabbar.wivert.fra);
  writefacetemplate('Tabbar-Vertical-Left',fwriter,ftabbar.wivert.fa);

  writeframetemplate('Tabbar-Vertical-Left-Item',fwriter, ftabbar.tavert.frame);
  writefacetemplate('Tabbar-Vertical-Left-Item',fwriter,ftabbar.tavert.face);

  writefacetemplate('Tabbar-Vertical-Left-Item-Active',fwriter,ftabbar.tavert.faceactive);

  fwriter.writesection('Tabbar-Vertical-Right');
  fwriter.writeinteger('Shift',ftabbar.tavertopo.shift);
  fwriter.writeinteger('TabColor',ftabbar.tavertopo.color);
  fwriter.writeinteger('TabColorActive',ftabbar.tavertopo.coloractive);
  writeframetemplate('Tabbar-Vertical-Right',fwriter, ftabbar.wivertopo.fra);
  writefacetemplate('Tabbar-Vertical-Right',fwriter,ftabbar.wivertopo.fa);

  writeframetemplate('Tabbar-Vertical-Right-Item',fwriter, ftabbar.tavertopo.frame);
  writefacetemplate('Tabbar-Vertical-Right-Item',fwriter,ftabbar.tavertopo.face);

  writefacetemplate('Tabbar-Vertical-Right-Item-Active',fwriter,ftabbar.tavertopo.faceactive);

  writeframetemplate('Grid',fwriter, fgrid.wi.fra);
  writefacetemplate('Grid',fwriter,fgrid.wi.fa);
  if fgrid.wi.fra<>nil then begin
   if fgrid.wi.fra.template.font<>nil then begin
    writefonttemplate('Grid',fwriter,fgrid.wi.fra.template.font);
   end;
  end;

  writeframetemplate('Grid-FixRows',fwriter, fgrid.fixrows.frame);
  writefacetemplate('Grid-FixRows',fwriter,fgrid.fixrows.face);


  writeframetemplate('Grid-FixCols',fwriter, fgrid.fixcols.frame);
  writefacetemplate('Grid-FixCols',fwriter,fgrid.fixcols.face);

  writeframetemplate('Grid-DataCols',fwriter, fgrid.datacols.frame);
  writefacetemplate('Grid-DataCols',fwriter,fgrid.datacols.face);
  fwriter.writesection('DisplayWidget');
  fwriter.writeinteger('Color', fdispwidget.color.co);
  fwriter.writeinteger('ColorCaptionFrame', fdispwidget.color.cocaptionframe);
  writeframetemplate('DisplayWidget',fwriter, fdispwidget.wi.fra);
  writefacetemplate('DisplayWidget',fwriter,fdispwidget.wi.fa);
  fwriter.free;
 end;
end;

procedure tazskin.loaded;
begin
 loadtheme;
 inherited;
end;

procedure tazskin.showdialog;
var
 int1: integer;
begin
 if frmchangeskinfo=nil then begin
  frmchangeskinfo:= tfrmchangeskinfo.create(self);
 end;
 frmchangeskinfo.wwidgetcolor.value:= fwidgetcolor.co;
 frmchangeskinfo.wframecolor.value:= fwidgetcolor.cocaptionframe;
 frmchangeskinfo.wsystemcolorv[0]:= self.colors.colordkshadow;
 frmchangeskinfo.wsystemcolorv[1]:= self.colors.colorshadow;
 frmchangeskinfo.wsystemcolorv[2]:= self.colors.colorframe;
 frmchangeskinfo.wsystemcolorv[3]:= self.colors.colorlight;
 frmchangeskinfo.wsystemcolorv[4]:= self.colors.colorhighlight;
 for int1:= 5 to 18 do begin
  frmchangeskinfo.wsystemcolorv[int1]:= tskincolor(self.colors.items[int1-5]).rgb;
 end;
 frmchangeskinfo.wauthor.value:= fauthor;
 frmchangeskinfo.wversion.value:= fversion;
 frmchangeskinfo.wfontname.value:= fdefaultfont.name;
 frmchangeskinfo.wfontwidth.value:= fdefaultfont.width;
 frmchangeskinfo.wfontheight.value:= fdefaultfont.height;
 frmchangeskinfo.wtextcolor.value:= fdefaultfont.color;
 frmchangeskinfo.wtextcolorbg.value:= fdefaultfont.colorbackground;
 frmchangeskinfo.wshadowcolor.value:= fdefaultfont.shadow_color;
 frmchangeskinfo.wshadowx.value:= fdefaultfont.shadow_shiftx;
 frmchangeskinfo.wshadowy.value:= fdefaultfont.shadow_shifty;
 frmchangeskinfo.wglosscolor.value:= fdefaultfont.gloss_color;
 frmchangeskinfo.wglossx.value:= fdefaultfont.gloss_shiftx;
 frmchangeskinfo.wglossy.value:= fdefaultfont.gloss_shifty;
 frmchangeskinfo.wbold.value:= (fs_bold in fdefaultfont.style);
 frmchangeskinfo.witalic.value:= (fs_italic in fdefaultfont.style);
 frmchangeskinfo.wunderline.value:= (fs_underline in fdefaultfont.style);
 frmchangeskinfo.wstrikeout.value:= (fs_strikeout in fdefaultfont.style);

 frmchangeskinfo.wfontname1.value:= fmenufont.name;
 frmchangeskinfo.wfontwidth1.value:= fmenufont.width;
 frmchangeskinfo.wfontheight1.value:= fmenufont.height;
 frmchangeskinfo.wtextcolor1.value:= fmenufont.color;
 frmchangeskinfo.wtextcolorbg1.value:= fmenufont.colorbackground;
 frmchangeskinfo.wshadowcolor1.value:= fmenufont.shadow_color;
 frmchangeskinfo.wshadowx1.value:= fmenufont.shadow_shiftx;
 frmchangeskinfo.wshadowy1.value:= fmenufont.shadow_shifty;
 frmchangeskinfo.wglosscolor1.value:= fmenufont.gloss_color;
 frmchangeskinfo.wglossx1.value:= fmenufont.gloss_shiftx;
 frmchangeskinfo.wglossy1.value:= fmenufont.gloss_shifty;
 frmchangeskinfo.wbold1.value:= (fs_bold in fmenufont.style);
 frmchangeskinfo.witalic1.value:= (fs_italic in fmenufont.style);
 frmchangeskinfo.wunderline1.value:= (fs_underline in fmenufont.style);
 frmchangeskinfo.wstrikeout1.value:= (fs_strikeout in fmenufont.style);

 frmchangeskinfo.wfontname2.value:= fmessagefont.name;
 frmchangeskinfo.wfontwidth2.value:= fmessagefont.width;
 frmchangeskinfo.wfontheight2.value:= fmessagefont.height;
 frmchangeskinfo.wtextcolor2.value:= fmessagefont.color;
 frmchangeskinfo.wtextcolorbg2.value:= fmessagefont.colorbackground;
 frmchangeskinfo.wshadowcolor2.value:= fmessagefont.shadow_color;
 frmchangeskinfo.wshadowx2.value:= fmessagefont.shadow_shiftx;
 frmchangeskinfo.wshadowy2.value:= fmessagefont.shadow_shifty;
 frmchangeskinfo.wglosscolor2.value:= fmessagefont.gloss_color;
 frmchangeskinfo.wglossx2.value:= fmessagefont.gloss_shiftx;
 frmchangeskinfo.wglossy2.value:= fmessagefont.gloss_shifty;
 frmchangeskinfo.wbold2.value:= (fs_bold in fmessagefont.style);
 frmchangeskinfo.witalic2.value:= (fs_italic in fmessagefont.style);
 frmchangeskinfo.wunderline2.value:= (fs_underline in fmessagefont.style);
 frmchangeskinfo.wstrikeout2.value:= (fs_strikeout in fmessagefont.style);

 frmchangeskinfo.show(true);
end;

procedure tazskin.handlewidget(const askin: skininfoty;
                           const acolor: pwidgetcolorinfoty = nil);
var
 int1: integer;
 wi1: twidget1;
 co1,co2: colorty;
begin
 if acolor = nil then begin
  co1:= fwidgetcolor.co;
  co2:= fwidgetcolor.cocaptionframe
 end
 else begin
  co1:= acolor^.co;
  if co1 = cl_default then begin
   co1:= fwidgetcolor.co;
  end;
  co2:= acolor^.cocaptionframe;
  if co2 = cl_default then begin
   co2:= fwidgetcolor.cocaptionframe;
  end;
 end;
 wi1:= twidget1(askin.instance);
 with wi1 do begin
  if fframe <> nil then begin
   if fframe is tcustomscrollframe then begin
    setscrollbarskin(tcustomscrollframe(fframe).sbvert,fsb_vert);
    setscrollbarskin(tcustomscrollframe(fframe).sbhorz,fsb_horz);
   end
   else begin
    if fframe is tcustombuttonframe then begin
     with tcustombuttonframe(fframe) do begin
      for int1:= 0 to buttons.count - 1 do begin
       setframebuttonskin(buttons[int1],fframebutton);
      end;
     end;
    end
    else begin
     if fframe is tcustomstepframe then begin
      setstepbuttonskin(tcustomstepframe(fframe),fstepbutton);
     end;
    end; 
   end; 
  end;
  if not setwidgetcolorcaptionframe(wi1,co2) then begin
   setwidgetcolor(wi1,co1);
  end;
 end;
end;

procedure tazskin.handledispwidget(const ainfo: skininfoty);
begin
 handlewidget(ainfo,@fdispwidget.color);
 setwidgetskin(twidget(ainfo.instance),fdispwidget.wi);
end;

procedure tazskin.handlegroupbox(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
 setgroupboxskin(tgroupbox(ainfo.instance),fgroupbox);
end;

procedure tazskin.handlesimplebutton(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
 setwidgetcolor(twidget(ainfo.instance),fbutton.co);
 setwidgetskin(twidget(ainfo.instance),fbutton.wi);
 setwidgetfont(twidget(ainfo.instance),fbutton.font);
end;

procedure tazskin.handledatabutton(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
 setwidgetcolor(twidget(ainfo.instance),fdatabutton.co);
 setwidgetskin(twidget(ainfo.instance),fdatabutton.wi);
 setwidgetfont(twidget(ainfo.instance),fdatabutton.font);
end;

procedure tazskin.handlecontainer(const ainfo: skininfoty);
begin
 setwidgetskin(twidget(ainfo.instance),fcontainer.wi);
end;

procedure tazskin.handletabbar(const ainfo: skininfoty);
var
 ta1: tcustomtabbar;
begin
 handlewidget(ainfo);
 ta1:= tcustomtabbar(ainfo.instance);
 if tabo_vertical in ta1.options then begin
  if tabo_opposite in ta1.options then begin
   setwidgetskin(ta1,ftabbar.wivertopo);
   settabsskin(ta1,ftabbar.tavertopo);
  end
  else begin
   setwidgetskin(ta1,ftabbar.wivert);
   settabsskin(ta1,ftabbar.tavert);
  end;
 end
 else begin
  if tabo_opposite in ta1.options then begin
   setwidgetskin(ta1,ftabbar.wihorzopo);
   settabsskin(ta1,ftabbar.tahorzopo);
  end
  else begin
   setwidgetskin(ta1,ftabbar.wihorz);
   settabsskin(ta1,ftabbar.tahorz);
  end;
 end;
 setstepbuttonskin(ta1.frame,fstepbutton);
end;

procedure tazskin.handletabpage(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
 setwidgetskin(ttabpage(ainfo.instance),ftabpage.wi);
end;

procedure tazskin.handletoolbar(const ainfo: skininfoty);
var
 tb1: tcustomtoolbar;
begin
 handlewidget(ainfo);
 tb1:= tcustomtoolbar(ainfo.instance);
 if tb1.width >= tb1.height then begin
  setwidgetskin(tb1,ftoolbar_horz.wi);
  setstepbuttonskin(tb1.frame,fstepbutton);
  if ftoolbar_horz.buttonface <> nil then begin
   with tb1.buttons do begin
    createface;
    setfacetemplate(ftoolbar_horz.buttonface,face);
   end;
  end;
 end
 else begin
  setwidgetskin(tb1,ftoolbar_vert.wi);
  setstepbuttonskin(tb1.frame,fstepbutton);
  if ftoolbar_vert.buttonface <> nil then begin
   with tb1.buttons do begin
    createface;
    setfacetemplate(ftoolbar_vert.buttonface,face);
   end;
  end;
 end;
end;

procedure tazskin.handleedit(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
end;

procedure tazskin.handledataedit(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
 setdataeditskin(tdataedit(ainfo.instance),fdataedit);
end;

procedure tazskin.handlebooleanedit(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
 setgraphdataeditskin(tgraphdataedit(ainfo.instance),fbooleanedit);
end;

procedure tazskin.handlemainmenu(const ainfo: skininfoty);
begin
 setmainmenuskin(tcustommainmenu(ainfo.instance),fmainmenu);
end;

procedure tazskin.handlepopupmenu(const ainfo: skininfoty);
begin
 setpopupmenuskin(tpopupmenu(ainfo.instance),fpopupmenu);
end;

procedure tazskin.handlegrid(const ainfo: skininfoty);
begin
 handlewidget(ainfo);
 setgridskin(tcustomgrid(ainfo.instance),fgrid);
end;

end.