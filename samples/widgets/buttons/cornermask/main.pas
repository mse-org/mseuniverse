unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msebitmap,
 msesimplewidgets;

type
 tmainfo = class(tmainform)
   timagelist1: timagelist;
   tbutton1: tbutton;
   tfacelist1: tfacelist;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
