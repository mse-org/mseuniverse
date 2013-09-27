unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msewidgets,msetimer,
 msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msetypes,
 msebitmap,msedatanodes,msefiledialog,msegrids,mselistbrowser,msesys;

type
 tmainfo = class(tmainform)
   tdropdownlistedit1: tdropdownlistedit;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
end.
