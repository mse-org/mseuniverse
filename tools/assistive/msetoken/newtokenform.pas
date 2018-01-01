unit newtokenform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msestatfile;
type
 tnewtokenfo = class(tmseform)
   tbutton1: tbutton;
   tstatfile1: tstatfile;
 end;
implementation
uses
 newtokenform_mfm;
end.
