unit docureport;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msereport,mdb,mseifiglob,
 mserichstring,msesplitter,msestrings;

type
 tdocure = class(treport)
   treportpage1: treportpage;
 end;
implementation
uses
 docureport_mfm;
end.
