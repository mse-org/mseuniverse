unit plotsettings;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar;
type
 tplotsettingsfo = class(tsubform)
   val_mirrorx: tbooleanedit;
   val_mirrory: tbooleanedit;
   val_rotate90: tbooleanedit;
   val_rotate180: tbooleanedit;
 end;
var
 plotsettingsfo: tplotsettingsfo;
implementation
uses
 plotsettings_mfm;
end.
