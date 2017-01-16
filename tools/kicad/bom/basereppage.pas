unit basereppage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msereport,mdb,mseifiglob,
 mserichstring,msesplitter,msestrings;

type
 tbasereppa = class(treppageform)
   treppagenumdisp1: treppagenumdisp;
   trepprintdatedisp1: trepprintdatedisp;
 end;
var
 basereppa: tbasereppa;
implementation
uses
 basereppage_mfm;
end.
