unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msewidgets,msesplitter,
 msestatfile;

type
 tmainfo = class(tmainform)
   tsimplewidget1: tsimplewidget;
   tsimplewidget4: tsimplewidget;
   tsimplewidget3: tsimplewidget;
   tsplitter1: tsplitter;
   tsimplewidget2: tsimplewidget;
   tstatfile1: tstatfile;
   tsplitter2: tsplitter;
   tfacecomp1: tfacecomp;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
