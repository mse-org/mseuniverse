unit basetab;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,msestatfile;
type
 tbasetabfo = class(tmseform)
   tabstat: tstatfile;
 end;
var
 basetabfo: tbasetabfo;
implementation
uses
 basetab_mfm;
end.
