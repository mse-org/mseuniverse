
unit fcarbonskin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,msegui,mseskin,msestrings,
 msesysenv,msemacros, msegraphics, msegraphutils, msebitmap;
 
type
 tfcarbonskinmo = class(tmsedatamodule)
   fadevertkonvex: tfacecomp;
   fadehorzconvex: tfacecomp;
   fadehorzconcave: tfacecomp;
   fadevertconcave: tfacecomp;
   skin: tskincontroller;
   fadecontainer: tfacecomp;
   nullface: tfacecomp;
   tframecomp1: tframecomp;
   timagelist1: timagelist;
   tfontcomp1: tfontcomp;
 end;
var
 skin: tmsedatamodule;
 
implementation
uses
 fcarbonskin_mfm;

end.
