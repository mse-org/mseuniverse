unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,mseact,
 msedataedits,msedbedit,msedropdownlist,mseedit,msegraphedits,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,
 msestream,sysutils,msebufdataset,msedb,mselocaldataset,msedatabase,
 msesqlite3conn,msesqldb,msqldb,msesplitter;

type
 tmainfo = class(tmainform)
   detailnavig: tdbnavigator;
   detailgrid: tdbstringgrid;
   detailds: tmsedatasource;
   conn: tsqlite3connection;
   trans: tmsesqltransaction;
   detailqu: tmsesqlquery;
   masterqu: tmsesqlquery;
   masterds: tmsedatasource;
   tspacer1: tspacer;
   tsplitter1: tsplitter;
   tstatfile1: tstatfile;
   horzconvex: tfacecomp;
   tsimplewidget1: tsimplewidget;
   mastergrid: tdbwidgetgrid;
   tdbintegeredit1: tdbintegeredit;
   tdbenumeditdb1: tdbenumeditdb;
   tspacer2: tspacer;
   masternavig: tdbnavigator;
   detail_pk: tmselongintfield;
   procedure detailbeforedeleteev(DataSet: TDataSet);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.detailbeforedeleteev(DataSet: TDataSet);
begin
 if masterqu.indexlocal.indexbyname('value').find([detail_pk]) then begin
  showerror('Record is in use.');
  abort();
 end;
end;

end.
