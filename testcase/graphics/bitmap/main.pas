unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseforms,msecalendardatetimeedit,msedataedits,mseedit,mseglob,msegui,
 mseguiglob,mseifiglob,msemenus,msestrings,msetypes,msedispwidgets,msegraphics,
 msegraphutils,msesimplewidgets,msewidgets,msecolordialog,msestat,msestatfile,
 msegraphedits,mseclasses,msegrids,msewidgetgrid,mseterminal,msethreadcomp,
 sysutils,mseapplication,mseimage,mseificompglob,msebitmap,msefiledialog,
 mserichstring,mseificomp,msescrollbar,msepostscriptprinter,mseprinter; 
type
 tmainfo = class(tdockform)
   ima: timage;
   graymasked: tbooleanedit;
   colormasked: tbooleanedit;
   kinded: tenumtypeedit;
   maskeded: tbooleanedit;
   fileed: tfilenameedit;
   tbutton1: tbutton;
   tstatfile1: tstatfile;
   bmpfged: tcoloredit;
   bmpbged: tcoloredit;
   fged: tcoloredit;
   bged: tcoloredit;
   tbutton3: tbutton;
   mbged: tcoloredit;
   mfged: tcoloredit;
   tbutton4: tbutton;
   bmptransed: tcoloredit;
   stretchxed: tbooleanedit;
   stretchyed: tbooleanedit;
   intpoled: tbooleanedit;
   opaed: tcoloredit;
   destkinded: tenumtypeedit;
   dima: timage;
   piddi: tintegerdisp;
   clipxed: tintegeredit;
   clipyed: tintegeredit;
   clipbmped: tbooleanedit;
   tbutton2: tbutton;
   printer: tpostscriptprinter;
   colorspaceed: tenumtypeedit;
   procedure loadedexe(const sender: TObject);
   procedure initexe(const sender: tenumtypeedit);
   procedure graymaskset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure colormaskset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure kindset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure maskedset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure loadexe(const sender: TObject);
   procedure datentexe(const sender: TObject);
   procedure setbmpbg(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure setbmpfg(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure paintexe(const sender: TObject);
   procedure maskpaintexe(const sender: TObject);
   procedure setbmptrans(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure setstretchy(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure setstretchx(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure setintpol(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure setopa(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure dkindset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure imapaexe(const sender: twidget; const acanvas: tcanvas);
   procedure colorspaceset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure colorspaceinitexe(const sender: tenumtypeedit);
   procedure printexe(const sender: TObject);
  private
   procedure check();
 end;
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,mseformatstr,msemime,msedatalist,mseprocutils,msefileutils,
 mseformatpngread,mseguiintf,msestream,msesys;

procedure tmainfo.check;
begin
 with ima.bitmap do begin
  kinded.value:= ord(kind);
  maskeded.value:= masked;
  graymasked.value:= graymask;
  colormasked.value:= colormask;
  bmpfged.value:= colorforeground;
  bmpbged.value:= colorbackground;
  bmptransed.value:= transparentcolor;
 end;
end;
 
procedure tmainfo.loadedexe(const sender: TObject);
begin
 dima.bitmap.size:= dima.paintsize;
 check();
 piddi.value:= getpid();
end;

procedure tmainfo.initexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(bitmapkindty);
end;

procedure tmainfo.graymaskset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 ima.bitmap.graymask:= avalue;
end;

procedure tmainfo.colormaskset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 ima.bitmap.colormask:= avalue;
end;

procedure tmainfo.kindset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 ima.bitmap.kind:= bitmapkindty(avalue);
end;

procedure tmainfo.maskedset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 ima.bitmap.masked:= avalue;
end;

procedure tmainfo.loadexe(const sender: TObject);
begin
 ima.bitmap.loadfromfile(fileed.value,'',[]);
 check();
end;

procedure tmainfo.datentexe(const sender: TObject);
begin
 check;
 ima.invalidate();
end;

procedure tmainfo.setbmpbg(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 ima.bitmap.colorbackground:= avalue;
end;

procedure tmainfo.setbmpfg(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 ima.bitmap.colorforeground:= avalue;
end;

procedure tmainfo.setbmptrans(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 ima.bitmap.transparentcolor:= avalue;
end;

procedure tmainfo.paintexe(const sender: TObject);
begin
 with ima.bitmap do begin
  init(bged.value);
  canvas.fillellipse1(mr(nullpoint,size),fged.value);
  canvas.drawline(nullpoint,pointty(size),fged.value);
 end;
end;

procedure tmainfo.maskpaintexe(const sender: TObject);
begin
 if ima.bitmap.masked then begin
  with ima.bitmap.mask do begin
   init(mbged.value);
   canvas.fillellipse1(mr(nullpoint,size),mfged.value);
   canvas.drawline(nullpoint,pointty(size),mfged.value);
  end;
 end;
end;

procedure tmainfo.setstretchy(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  ima.bitmap.alignment:= ima.bitmap.alignment + [al_stretchy];
 end
 else begin
  ima.bitmap.alignment:= ima.bitmap.alignment - [al_stretchy];
 end;
end;

procedure tmainfo.setstretchx(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  ima.bitmap.alignment:= ima.bitmap.alignment + [al_stretchx];
 end
 else begin
  ima.bitmap.alignment:= ima.bitmap.alignment - [al_stretchx];
 end;
end;

procedure tmainfo.setintpol(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  ima.bitmap.alignment:= ima.bitmap.alignment + [al_intpol];
 end
 else begin
  ima.bitmap.alignment:= ima.bitmap.alignment - [al_intpol];
 end;
end;

procedure tmainfo.setopa(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 ima.bitmap.opacity:= avalue;
end;

procedure tmainfo.dkindset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 dima.bitmap.kind:= bitmapkindty(avalue);
end;

procedure tmainfo.imapaexe(const sender: twidget; const acanvas: tcanvas);
var
 bo1: boolean;
begin
 bo1:= (clipxed.value <> 0) and (clipyed.value <> 0);
 ima.face.image.paint(dima.bitmap.canvas,mr(nullpoint,dima.bitmap.size));

 if bo1 and clipbmped.value then begin
  dima.bitmap.canvas.subcliprect(mr(10,10,clipxed.value,clipyed.value));
 end;
 ima.bitmap.paint(dima.bitmap.canvas,mr(nullpoint,dima.bitmap.size));
 dima.bitmap.canvas.resetclipregion;
 dima.invalidate();
end;

procedure tmainfo.colorspaceset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 printer.canvas.colorspace:= colorspacety(avalue);
end;

procedure tmainfo.colorspaceinitexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(colorspacety);
end;

procedure tmainfo.printexe(const sender: TObject);
var
 bo1: boolean;
begin
 printer.beginprint(ttextstream.create('test.ps',fm_create));
 bo1:= (clipxed.value <> 0) and (clipyed.value <> 0);
 if bo1 and clipbmped.value then begin
  printer.canvas.subcliprect(mr(10,10,clipxed.value,clipyed.value));
 end;
 ima.bitmap.paint(printer.canvas,mr(nullpoint,dima.paintsize));
 printer.endprint();
 printer.canvas.resetclipregion;
end;

end.
