unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,
 msegrids,mseificomp,mseificompglob,mseifiglob,mselistbrowser,msestatfile,
 msestream,msestrings,msesys,sysutils,msecolordialog;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   tbutton3: tbutton;
   filenameed: tfilenameedit;
   codepointed: tintegeredit;
   colored: tcoloredit;
   tstatfile1: tstatfile;
   bitmapcomp: tbitmapcomp;
   heighted: tintegeredit;
   imagelist: timagelist;
   procedure dataeneredexe(const sender: TObject);
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,mseftglyphs;
 
procedure tmainfo.dataeneredexe(const sender: TObject);
var
 glyphs: tftglyphs;
begin
 glyphs:= tftglyphs.create(filenameed.value,0,heighted.value);
 try
  glyphs.getglyph(bitmapcomp.bitmap,codepointed.value,colored.value);
  imagelist.clear();
  imagelist.size:= bitmapcomp.bitmap.size;
  imagelist.addimage(bitmapcomp.bitmap);
 finally
  glyphs.free();
 end;
end;

end.
