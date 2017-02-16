unit bomfieldeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 msesimplewidgets,msestatfile,mseact,msedataedits,mseedit,msegrids,mseificomp,
 mseificompglob,mseifiglob,msestream,msestrings,msewidgetgrid,sysutils;
type
 tbomfieldeditfo = class(tmseform)
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   tstatfile1: tstatfile;
   bomfieldgrid: twidgetgrid;
   tint64edit1: tint64edit;
   tdropdownlistedit1: tdropdownlistedit;
   tstringedit1: tstringedit;
 end;

implementation
uses
 bomfieldeditform_mfm;
end.
