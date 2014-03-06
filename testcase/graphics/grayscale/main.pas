unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msesimplewidgets,
 mseimage,msestatfile,msecolordialog,msegraphedits,msescrollbar,msedispwidgets,
 mserichstring;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   di: timage;
   kinded: tenumtypeedit;
   tstatfile1: tstatfile;
   tbutton3: tbutton;
   cxed: tintegeredit;
   cyed: tintegeredit;
   bgcoled: tcoloredit;
   fgcoled: tcoloredit;
   tbutton4: tbutton;
   tbutton5: tbutton;
   tbutton6: tbutton;
   tbutton2: tbutton;
   tbutton7: tbutton;
   maskfgcoled: tcoloredit;
   maskbgcoled: tcoloredit;
   tbutton8: tbutton;
   tbutton9: tbutton;
   maskeded: tbooleanedit;
   graymasked: tbooleanedit;
   colormasked: tbooleanedit;
   transpcoled: tcoloredit;
   piddi: tintegerdisp;
   stretchxed: tbooleanedit;
   stretchyed: tbooleanedit;
   intpoled: tbooleanedit;
   bmbgcoled: tcoloredit;
   bmfgcoled: tcoloredit;
   madi: tpaintbox;
   procedure exe(const sender: TObject);
   procedure kindsetexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure kindinitexe(const sender: tenumtypeedit);
   procedure clearexe(const sender: TObject);
   procedure initex(const sender: TObject);
   procedure setsizeexe(const sender: TObject);
   procedure lineexe(const sender: TObject);
   procedure circexe(const sender: TObject);
   procedure maskinitexe(const sender: TObject);
   procedure masklineexe(const sender: TObject);
   procedure maskcircexe(const sender: TObject);
   procedure checkoptions(const sender: TObject);
   procedure setmaskedexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure graymasksetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure colormasksetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure transpcolsetexe(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure loadedexe(const sender: TObject);
   procedure setstretchyexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure setstretchxexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure setintpolexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure setbmfgcolsetexe(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure setbmbgcolsetexe(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure dipaexe(const sender: twidget; const acanvas: tcanvas);
   procedure maskpaexe(const sender: twidget; const acanvas: tcanvas);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mseprocutils;
 
procedure tmainfo.exe(const sender: TObject);
var
 ha1: pixmapty;
begin
 ha1:= gui_createpixmap(ms(100,50),0,bmk_gray);
 gui_freepixmap(ha1);
end;

procedure tmainfo.kindsetexe(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 di.bitmap.kind:= bitmapkindty(avalue);
end;

procedure tmainfo.kindinitexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(bitmapkindty);
end;

procedure tmainfo.clearexe(const sender: TObject);
begin
 di.bitmap.clear();
end;

procedure tmainfo.initex(const sender: TObject);
begin
 di.bitmap.init(bgcoled.value);
end;

procedure tmainfo.setsizeexe(const sender: TObject);
begin
 di.bitmap.size:= ms(cxed.value,cyed.value);
end;

procedure tmainfo.lineexe(const sender: TObject);
begin
 di.bitmap.canvas.drawline(mp(0,0),mp(cxed.value,cyed.value),fgcoled.value);
 di.bitmap.change();
end;

procedure tmainfo.circexe(const sender: TObject);
begin
 di.bitmap.canvas.fillellipse1(mr(0,0,cxed.value,cyed.value),fgcoled.value);
 di.bitmap.change();
end;

procedure tmainfo.maskinitexe(const sender: TObject);
begin
 di.bitmap.mask.init(maskbgcoled.value);
end;

procedure tmainfo.masklineexe(const sender: TObject);
begin
 di.bitmap.mask.canvas.drawline(mp(0,0),
                          mp(cxed.value,cyed.value),maskfgcoled.value);
 di.bitmap.change();
end;

procedure tmainfo.maskcircexe(const sender: TObject);
begin
 di.bitmap.mask.canvas.fillellipse1(
                   mr(0,0,cxed.value,cyed.value),maskfgcoled.value);
 di.bitmap.change();
end;

procedure tmainfo.checkoptions(const sender: TObject);
begin
 with di.bitmap do begin
  graymasked.value:= graymask;
  colormasked.value:= colormask;
 end;
end;

procedure tmainfo.setmaskedexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 di.bitmap.masked:= avalue;
end;

procedure tmainfo.graymasksetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 di.bitmap.graymask:= avalue;
end;

procedure tmainfo.colormasksetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 di.bitmap.colormask:= avalue;
end;

procedure tmainfo.transpcolsetexe(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 di.bitmap.transparentcolor:= avalue;
end;

procedure tmainfo.loadedexe(const sender: TObject);
begin
 piddi.value:= getpid;
end;

procedure tmainfo.setstretchyexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  di.bitmap.alignment:= di.bitmap.alignment + [al_stretchy];
 end
 else begin
  di.bitmap.alignment:= di.bitmap.alignment - [al_stretchy];
 end;
end;

procedure tmainfo.setstretchxexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  di.bitmap.alignment:= di.bitmap.alignment + [al_stretchx];
 end
 else begin
  di.bitmap.alignment:= di.bitmap.alignment - [al_stretchx];
 end;
end;

procedure tmainfo.setintpolexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  di.bitmap.alignment:= di.bitmap.alignment + [al_intpol];
 end
 else begin
  di.bitmap.alignment:= di.bitmap.alignment - [al_intpol];
 end;
end;

procedure tmainfo.setbmfgcolsetexe(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 di.bitmap.colorforeground:= avalue;
end;

procedure tmainfo.setbmbgcolsetexe(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 di.bitmap.colorbackground:= avalue;
end;

procedure tmainfo.dipaexe(const sender: twidget; const acanvas: tcanvas);
begin
 madi.invalidate();
end;

procedure tmainfo.maskpaexe(const sender: twidget; const acanvas: tcanvas);
begin
 if di.bitmap.masked then begin
  di.bitmap.mask.paint(acanvas,nullpoint);
 end;
end;

end.
