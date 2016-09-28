unit componentkindeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,mseact,
 msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils,msesplitter,msesimplewidgets;
type
 tcomponentkindeditfo = class(tmseform)
   tdbnavigator1: tdbnavigator;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   tdbwidgetgrid1: tdbwidgetgrid;
   nameed: tdbstringedit;
   tdbdatetimeedit1: tdbdatetimeedit;
   tdbdatetimeedit2: tdbdatetimeedit;
   designationed: tdbstringedit;
 end;
var
 componentkindeditfo: tcomponentkindeditfo;
implementation
uses
 componentkindeditform_mfm;
end.
