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
   butclick: tfacecomp;
   nofocus: tfacecomp;
   tframecomp1: tframecomp;
   timagelist1: timagelist;
   hoover: tfacecomp;
   tmainmenu1: tmainmenu;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
