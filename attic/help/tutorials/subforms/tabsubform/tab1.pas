unit tab1;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,basetab,msedataedits,
 mseedit,mseifiglob,msestrings,msetypes;

type
 ttab1fo = class(tbasetabfo)
   editc: tstringedit;
   editb: tstringedit;
   edita: tstringedit;
 end;
var
 tab1fo: ttab1fo;
implementation
uses
 tab1_mfm;
end.
