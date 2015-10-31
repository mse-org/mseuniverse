unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseimage,
 msebitmap,msestatfile,msecolordialog,msedataedits,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestream,msestrings,sysutils;

type
 tmainfo = class(tmainform)
   image1: timage;
   tbitmapcomp1: tbitmapcomp;
   facelist: tfacelist;
   tstatfile1: tstatfile;
   bgcolor: tcoloredit;
   blendcolor1: tcoloredit;
   coloropacity: trealedit;
   blendcolor2: tcoloredit;
   patternopacity: trealedit;
   tframecomp1: tframecomp;
   timage2: timage;
   procedure bgcolorset(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure color1set(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure color2set(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
   procedure coloropaset(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure patternopaset(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.bgcolorset(const sender: TObject; var avalue: colorty;
               var accept: Boolean);begin
 image1.color:= avalue;
end;

procedure tmainfo.color1set(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 facelist.list[0].fade_color[0]:= avalue;
end;

procedure tmainfo.color2set(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 facelist.list[0].fade_color[1]:= avalue;
end;

procedure tmainfo.coloropaset(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 facelist.list[0].fade_opacity:= opacitycolor(avalue);
end;

procedure tmainfo.patternopaset(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 facelist.list[0].image.opacity:= opacitycolor(avalue);
end;

end.
