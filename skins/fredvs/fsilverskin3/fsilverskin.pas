
unit fsilverskin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,msegui,mseskin,msestrings,
 msesysenv,msemacros, msegraphics, msegraphutils, msebitmap;
 
type
 tfsilverskinmo = class(tmsedatamodule)
   fadevertkonvex: tfacecomp;
   fadehorzconvex: tfacecomp;
   fadehorzconcave: tfacecomp;
   fadevertconcave: tfacecomp;
   skin: tskincontroller;
   timagelist2: timagelist;
   tfontcomp1: tfontcomp;
   tframecomp2: tframecomp;
   timagelist4: timagelist;
 end;
var
 skin: tmsedatamodule;
 
implementation
uses
 fsilverskin_mfm;

end.
