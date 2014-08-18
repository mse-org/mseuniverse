unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedragglob,
 msescrollbar,msestatfile,msestream,msestrings,msetabs,sysutils,mseskin,
 msesimplewidgets;

type
 tmainfo = class(tmainform)
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
   ttabpage4: ttabpage;
   fadegrayright: tfacecomp;
   tbutton1: tbutton;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
