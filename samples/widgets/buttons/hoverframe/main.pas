unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msebitmap,mseimage;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   tfacelist1: tfacelist;
   concave: tfacecomp;
   convex: tfacecomp;
   tframecomp1: tframecomp;
   timagelist1: timagelist;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
