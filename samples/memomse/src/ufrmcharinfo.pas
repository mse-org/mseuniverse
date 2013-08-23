unit ufrmcharinfo;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 msegrids,mseificomp,mseificompglob,mseifiglob,msestrings,msetypes,msewidgetgrid;
type
 tufrmcharinfofo = class(tmseform)
   twidgetgrid1: twidgetgrid;
   tstringedit1: tstringedit;
   tintegeredit1: tintegeredit;
   tintegeredit2: tintegeredit;
 end;
var
 ufrmcharinfofo: tufrmcharinfofo;
implementation
uses
 ufrmcharinfo_mfm;
end.
