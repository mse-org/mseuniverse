unit frmabout;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msegui,msegraphics,
 msegraphutils,mseclasses,mseforms,mseimage,msedispwidgets,
 msetabs,msedataedits,msesimplewidgets;
type
 tfrmaboutfo = class(tmseform)
   timage1: timage;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
   tstringdisp1: tstringdisp;
   tmemoedit1: tmemoedit;
   tmemoedit2: tmemoedit;
   tmemoedit3: tmemoedit;
   ttabpage4: ttabpage;
   tmemoedit4: tmemoedit;
   tbutton1: tbutton;
 end;
var
 frmaboutfo: tfrmaboutfo;
implementation
uses
 frmabout_mfm;
end.
