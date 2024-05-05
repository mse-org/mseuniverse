unit report2;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msereport,db,mserichstring,
 msesplitter,msestrings,msedbdispwidgets,msetypes,msedb;

type
 treport2re = class(treport)
   treportpage1: treportpage;
   treppagenumdisp1: treppagenumdisp;
   tbandarea1: tbandarea;
   tdbintegerdisp1: tdbintegerdisp;
   tdbstringdisp1: tdbstringdisp;
   treportpage2: treportpage;
   treppagenumdisp2: treppagenumdisp;
   tbandarea2: tbandarea;
   enddummy: treportpage;
   detailgroup2: tbandgroup;
   header2: trecordband;
   detail2: trecordband;
   detailgroup: tbandgroup;
   detail: trecordband;
   header: trecordband;
 end;
var
 report2re: treport2re;
implementation
uses
 report2_mfm;
end.
