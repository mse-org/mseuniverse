unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msesimplewidgets,
 mseimage,msestatfile;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   di: timage;
   tenumtypeedit1: tenumtypeedit;
   tstatfile1: tstatfile;
   procedure exe(const sender: TObject);
   procedure kindsetexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure kindinitexe(const sender: tenumtypeedit);
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

end.
