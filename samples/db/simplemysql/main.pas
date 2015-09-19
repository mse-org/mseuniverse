unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedatabase,
 msemysqlconn,sysutils,mdb,msebufdataset,msedb,mseifiglob,msesqldb,msqldb,
 msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mselookupbuffer,msescrollbar,msestatfile,msestream,msestrings;

type
 tmainfo = class(tmainform)
   conn: tmsemysqlconnection;
   trans: tmsesqltransaction;
   query: tmsesqlquery;
   dataso: tmsedatasource;
   dbnav: tdbnavigator;
   grid: tdbstringgrid;
 end;
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm;
end.
