unit listreppage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,basereppage,
 mdb,mseifiglob,msereport,mserichstring,msesplitter,msestrings;

type
 tlistreppa = class(tbasereppa)
   tbandarea2: tbandarea;
   title: trecordband;
 end;

implementation
uses
 listreppage_mfm;
end.
