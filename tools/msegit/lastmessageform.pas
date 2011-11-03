unit lastmessageform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestatfile,
 msesimplewidgets,msewidgets,msedataedits,mseedit,msegrids,mseifiglob,
 msestrings,msetypes,msewidgetgrid;
type
 tlastmessagefo = class(tmseform)
   tstatfile1: tstatfile;
   tbutton1: tbutton;
   tbutton2: tbutton;
   grid: twidgetgrid;
   ed: tstringedit;
 end;
var
 lastmessagefo: tlastmessagefo;
implementation
uses
 lastmessageform_mfm;
end.
