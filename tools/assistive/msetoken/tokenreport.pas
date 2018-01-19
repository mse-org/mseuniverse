unit tokenreport;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msereport,mdb,mseifiglob,
 mserichstring,msesplitter,msedb,msedbdispwidgets;

type
 ttokenre = class(treport)
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
 tokenre: ttokenre;
implementation
uses
 tokenreport_mfm;
end.
