unit clientmain;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msegrids,mseifidbgui,
 msestrings,msetypes,msedataedits,mseedit,mseifiglob,mseifigui,mseifilink;

type
 tclientmainfo = class(tmainform)
   tdbrxwidgetgrid1: tdbrxwidgetgrid;
   tintegeredit1: tintegeredit;
   tstringedit1: tstringedit;
 end;
var
 clientmainfo: tclientmainfo;
implementation
uses
 clientmain_mfm;
end.
