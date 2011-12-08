unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedatabase,
 msesqlite3conn,sysutils,db,msebufdataset,msedb,msesqldb,msqldb,msedataedits,
 msedbedit,mseedit,msegraphedits,msegrids,mseifiglob,mselookupbuffer,msestrings,
 msetypes;

type
 tmainfo = class(tmainform)
   conn: tsqlite3connection;
   trans: tmsesqltransaction;
   query: tmsesqlquery;
   dataso: tmsedatasource;
   tdbstringgrid1: tdbstringgrid;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
