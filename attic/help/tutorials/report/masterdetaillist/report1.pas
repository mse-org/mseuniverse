unit report1;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msereport,db,mserichstring,
 msesplitter,msestrings,msedataedits,mseedit,msepostscriptprinter,mseprinter,
 msetypes;

type
 treport1re = class(treport)
   treportpage1: treportpage;
   tbandarea1: tbandarea;
   treppagenumdisp1: treppagenumdisp;
   customer: trecordband;
   enddummy: trecordband;
   detailgroup: tbandgroup;
   detail: trecordband;
   header: trecordband;
 end;
var
 report1re: treport1re;
implementation
uses
 report1_mfm;
end.
