unit voucherreport;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msereport,mdb,mseifiglob,
 mserichstring,msesplitter,msedb,msedbdispwidgets;

type
 tvoucherre = class(treport)
   treportpage1: treportpage;
   trepvaluedisp1: trepvaluedisp;
   trepprintdatedisp1: trepprintdatedisp;
   trecordband1: trecordband;
   dataso: tmsedatasource;
   trecordband2: trecordband;
   trecordband3: trecordband;
   trecordband4: trecordband;
   trecordband5: trecordband;
   trecordband6: trecordband;
   tdbbarcode1: tdbbarcode;
   tdbintegerdisp1: tdbintegerdisp;
   trecordband7: trecordband;
 end;
var
 voucherre: tvoucherre;
implementation
uses
 voucherreport_mfm;
end.
