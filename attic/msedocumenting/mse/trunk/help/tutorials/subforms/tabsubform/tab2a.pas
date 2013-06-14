unit tab2a;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,basetab,mdb,
 msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseifiglob,
 mselookupbuffer,msestrings,msetypes;

type
 ttab2afo = class(tbasetabfo)
   tdbstringgrid1: tdbstringgrid;
 end;
var
 tab2afo: ttab2afo;
implementation
uses
 tab2a_mfm;
end.
