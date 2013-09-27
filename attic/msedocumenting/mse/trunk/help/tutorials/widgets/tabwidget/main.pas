unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedragglob,
 msescrollbar,msestatfile,msestream,msestrings,msetabs,msewidgets,sysutils,
 mseskin,msebitmap;

type
 tmainfo = class(tmainform)
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
   imli: timagelist;
   headerframe: tframecomp;
   tabframe: tframecomp;
   tabfacelist: tfacelist;
   tabface: tfacecomp;
   tabfaceactive: tfacecomp;
   tabfaceclicked: tfacecomp;
   tabfacemouse: tfacecomp;
   tabbarface: tfacecomp;
   tabpagefacea: tfacecomp;
   tabpagefaceb: tfacecomp;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
