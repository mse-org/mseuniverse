unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mdb,msebufdataset,
 msedb,mseifiglob,mselocaldataset;

type
 tmainmo = class(tmsedatamodule)
   ds1: tlocaldataset;
   ds2: tlocaldataset;
 end;
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm;
end.
