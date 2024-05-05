unit tab2;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,basetab,db,msedataedits,
 msedbedit,mseedit,msegraphedits,msegrids,mseifiglob,mselookupbuffer,msestrings,
 msetypes;

type
 ttab2fo = class(tbasetabfo)
   tdbstringgrid1: tdbstringgrid;
 end;
var
 tab2fo: ttab2fo;
implementation
uses
 tab2_mfm;
end.
