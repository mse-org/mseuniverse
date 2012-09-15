unit tab3;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,basetab,db,msedataedits,
 msedbedit,mseedit,msegraphedits,msegrids,mseifiglob,mselookupbuffer,msestrings,
 msetypes;

type
 ttab3fo = class(tbasetabfo)
   tdbstringgrid1: tdbstringgrid;
 end;
var
 tab3fo: ttab3fo;
implementation
uses
 tab3_mfm;
end.
