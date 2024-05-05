unit skin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,msegui,mseskin;

type
 tskinmo = class(tmsedatamodule)
   nullface: tfacecomp;
   fadecontainer: tfacecomp;
   fadehorzconcave: tfacecomp;
   fadevertconcave: tfacecomp;
   skin: tskincontroller;
   fadehorzconvex: tfacecomp;
   fadevertkonvex: tfacecomp;
 end;
var
 skinmo: tskinmo;
implementation
uses
 skin_mfm;
end.
