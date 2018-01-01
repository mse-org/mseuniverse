unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,msestat,msestatfile,
 mseassistivehandler;

type
 tmainmo = class(tmsedatamodule)
   tstatfile1: tstatfile;
   tassistivehandler1: tassistivehandler;
 end;
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm;
end.
