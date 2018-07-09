unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
