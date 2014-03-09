{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
unit main;
interface
uses
 mseglob,mseguiglob,msegraphics,msegraphutils,msegui,msesimplewidgets,
 msewidgets,msedragglob,msescrollbar,msestat,msestatfile,msestream,msestrings,
 sysutils,mseforms,mseclasses,msetypes,msetabs,mseifiglob,msecolordialog,
 msedataedits,mseedit,msebitmap,msefiledialog,msedispwidgets,mseevent,
 mseapplication,mseimage,msegraphedits,mseificomp,mseificompglob,msemenus;

type
  
 tmainfo = class(tmainform)
   magickbu: tbutton;
   tfilenameedit1: tfilenameedit;
   tstatfile1: tstatfile;
   di2: timage;
   formatdi: tstringdisp;
   cxdi: tintegerdisp;
   cydi: tintegerdisp;
   builtinbu: tbutton;
   tdi: trealdisp;
   tbutton3: tbutton;
   tbutton4: tbutton;
   format: tstringedit;
   monoed: tbooleaneditradio;
   maskeded: tbooleanedit;
   colormasked: tbooleaneditradio;
   bgcled: tcoloredit;
   fgcled: tcoloredit;
   tbutton5: tbutton;
   qed: tintegeredit;
   indexed: tintegeredit;
   widthed: tintegeredit;
   heighted: tintegeredit;
   pingbu: tbutton;
   roted: trealedit;
   bgcoled: tcoloredit;
   densed: trealedit;
   rotmonomasked: tbooleanedit;
   filtered: tenumtypeedit;
   rotaftscaed: tbooleanedit;
   sampleed: tbooleanedit;
   resizeed: tbooleanedit;
   blured: trealedit;
   rotbefscaed: tbooleanedit;
   graymasked: tbooleaneditradio;
   grayed: tbooleaneditradio;
   procedure magickexe(const sender: TObject);
   procedure builtinexe(const sender: TObject);
   procedure writeexe(const sender: TObject);
   procedure readexe(const sender: TObject);
   procedure colormaskset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure maskedset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure monoset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure setbgexe(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure setfgexe(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure paintexe(const sender: TObject);
   procedure pasizeexe(const sender: twidget; const acanvas: tcanvas);
   procedure sidatent(const sender: TObject);
   procedure pingexe(const sender: TObject);
   procedure typeintexe(const sender: tenumtypeedit);
   procedure samplesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure resizesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure rotbefsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure rotaftsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure graymaskset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure grayset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  public
 end;
  
var
 mainfo: tmainfo;
implementation

uses
 main_mfm,msesysintf,msefileutils,msesystypes,msesys,

 mseformatpngread,mseformatpngwrite,
 mseformatbmpicoread,
 mseformatjpgread,mseformatjpgwrite,
 mseformatpnmread,
 mseformattgaread,
 mseformattiffread,mseformattiffwrite,
 mseformatxpmread,

 msegraphicsmagick,msemagickstream,msectypes,msestockobjects;

{ tmainfo }

procedure tmainfo.magickexe(const sender: TObject);
const
 pngfilter: array[0..0] of msestring = ('*.png'); 
 jpgfilter: array[0..0] of msestring = ('*.jpg'); 
 bmpfilter: array[0..0] of msestring = ('*.bmp'); 
begin
 registerformats(['png','jpeg','bmp','pdf','ps'],
         [stockobjects.captions[sc_PNG_Image],
          stockobjects.captions[sc_JPEG_Image],
          stockobjects.captions[sc_MS_bitmap]],
          [{pngfilter,jpgfilter,bmpfilter}]);
 builtinbu.color:= cl_default;
 magickbu.color:= cl_red;
 pingbu.enabled:= true;
end;

procedure tmainfo.builtinexe(const sender: TObject);
begin
 mseformatpngread.registerformat();
 mseformatpngwrite.registerformat();
 mseformatjpgread.registerformat(); 
 mseformatjpgwrite.registerformat(); 
 mseformatbmpicoread.registerformat();
 builtinbu.color:= cl_red;
 magickbu.color:= cl_default;
 pingbu.enabled:= false;
end;

procedure tmainfo.writeexe(const sender: TObject);
var
 t1: tdatetime;
 dir,fname: filenamety;
begin
 splitfilepath(tfilenameedit1.value,dir,fname);
 application.beginwait();
 try
  t1:= now;
  di2.bitmap.writetofile(dir+'w_'+
               removefileext(fname)+'.'+format.value,
                          string(format.value),
       [qed.value,widthed.value,heighted.value,roted.value,bgcoled.value,
        densed.value,rotmonomasked.valuebitmask,filtered.value,blured.value]);
  tdi.value:= (now-t1)*(24*60*60);
 finally
  application.endwait();
 end;
end;

procedure tmainfo.readexe(const sender: TObject);
var
 t1: tdatetime;
begin
 application.beginwait();
 try
  t1:= now;
  formatdi.value:= di2.bitmap.loadfromfile(tfilenameedit1.value,'',
    [indexed.value,widthed.value,heighted.value,roted.value,bgcoled.value,
    densed.value,rotmonomasked.valuebitmask,filtered.value,blured.value]);
  tdi.value:= (now-t1)*(24*60*60);
 finally
  application.endwait();
 end;
 cxdi.value:= di2.bitmap.width;
 cydi.value:= di2.bitmap.height;
 case di2.bitmap.kind of
  bmk_mono: begin
   monoed.value:= true;
  end;
  bmk_gray: begin
   grayed.value:= true;
  end;
  else begin
   monoed.value:= false;
   grayed.value:= false;
  end;
 end;
 maskeded.value:= di2.bitmap.masked;
 graymasked.value:= di2.bitmap.graymask;
 colormasked.value:= di2.bitmap.colormask;
end;

procedure tmainfo.colormaskset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 di2.bitmap.colormask:= avalue;
end;

procedure tmainfo.graymaskset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 di2.bitmap.graymask:= avalue;
end;

procedure tmainfo.maskedset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 di2.bitmap.masked:= avalue;
end;

procedure tmainfo.monoset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  di2.bitmap.kind:= bmk_mono;
 end
 else begin
  di2.bitmap.kind:= bmk_rgb;
 end;
end;

procedure tmainfo.grayset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  di2.bitmap.kind:= bmk_gray;
 end
 else begin
  di2.bitmap.kind:= bmk_rgb;
 end;
end;

procedure tmainfo.setbgexe(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 di2.bitmap.colorbackground:= avalue;
end;

procedure tmainfo.setfgexe(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 di2.bitmap.colorforeground:= avalue;
end;

procedure tmainfo.paintexe(const sender: TObject);
begin
 with di2.bitmap do begin
  if kind = bmk_mono then begin
   init(cl_0);
   di2.bitmap.canvas.drawline(mp(0,0),mp(width-1,height-1),cl_1);
  end
  else begin
   init(bgcled.value);
   di2.bitmap.canvas.drawline(mp(0,0),mp(width-1,height-1),fgcled.value);
  end;
  change;
 end;
end;

procedure tmainfo.pasizeexe(const sender: twidget; const acanvas: tcanvas);
begin
 acanvas.drawxorframe(mr(0,0,widthed.value,heighted.value),
                                -2,stockobjects.bitmaps[stb_dens50]);
end;

procedure tmainfo.sidatent(const sender: TObject);
begin
 di2.invalidate;
end;

procedure tmainfo.pingexe(const sender: TObject);
var
 inf: gminfoty;
 t1: tdatetime;
 stream1: tmsefilestream;
 bo1: boolean;
begin
 stream1:= tmsefilestream.create(tfilenameedit1.value,fm_read);
 application.beginwait();
 try
  t1:= now;
  bo1:= pinggmgraphic(stream1,inf);
  tdi.value:= (now-t1)*(24*60*60);
  if bo1 then begin
   formatdi.value:= inf.formatlabel;
   cxdi.value:= inf.size.cx;
   cydi.value:= inf.size.cy;
  end
  else begin
   formatdi.value:= '';
   cxdi.value:= 0;
   cydi.value:= 0;
  end;
 finally
  application.endwait();
  stream1.free;
 end;
end;

procedure tmainfo.typeintexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(filtertypes);
end;

procedure tmainfo.samplesetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  resizeed.value:= false;
  blured.enabled:= false;
  filtered.enabled:= false;
 end;
end;

procedure tmainfo.resizesetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  sampleed.value:= false;
 end;
 blured.enabled:= avalue;
 filtered.enabled:= avalue;
end;

procedure tmainfo.rotbefsetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  rotaftscaed.value:= false;
 end;
end;

procedure tmainfo.rotaftsetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  rotbefscaed.value:= false;
 end;
end;

end.
