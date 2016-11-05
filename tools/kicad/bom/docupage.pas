unit docupage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetabs,
 msesplitter,mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msebitmap,msedatanodes,msefiledialog,
 msegrids,mselistbrowser,msesys;
type
 tdocupagefo = class(ttabform)
   tlayouter1: tlayouter;
   nameed: tstringedit;
   plotdired: tfilenameedit;
   procedure namesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
 end;
var
 docupagefo: tdocupagefo;
implementation
uses
 docupage_mfm;
 
procedure tdocupagefo.namesetev(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 caption:= avalue;
end;

end.
