unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msesimplewidgets,
 mseimage,msestatfile,msecolordialog,msegraphedits,msescrollbar;

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
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
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

end.
