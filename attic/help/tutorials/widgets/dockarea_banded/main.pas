unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedock,msesimplewidgets,msewidgets,
 msedataedits,mseedit,msestrings,msetypes,mseact,msetoolbar,msebitmap,msegrids,
 msesplitter;

type
 tmainfo = class(tmseform)
   tdockpanel1: tdockpanel;
   tbutton1: tbutton;
   tstringedit1: tstringedit;
   ttoolbar1: ttoolbar;
   timagelist1: timagelist;
   tstringgrid1: tstringgrid;
   tspacer1: tspacer;
   procedure ex(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.ex(const sender: TObject);
begin
 close;
end;

end.
