unit tab0;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,basetab,msedataedits,
 mseedit,mseifiglob,msestrings,msetypes;

type
 ttab0fo = class(tbasetabfo)
   edita: tstringedit;
   editb: tstringedit;
 end;
var
 tab0fo: ttab0fo;
implementation
uses
 tab0_mfm;
end.
