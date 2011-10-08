unit calc2;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesplitter,msesimplewidgets,
 msewidgets;
type
 tcalc2fo = class(tmseform)
   tlayouter1: tlayouter;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton4: tbutton;
   tbutton5: tbutton;
   tbutton6: tbutton;
 end;
var
 calc2fo: tcalc2fo;
implementation
uses
 calc2_mfm;
end.
