unit plotsettings;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar,mseact,
 msedataedits,mseedit,msestatfile,msestream,msestrings,sysutils;
type
 tplotsettingsfo = class(tsubform)
   val_mirrorx: tbooleanedit;
   val_mirrory: tbooleanedit;
   val_rotate90: tbooleanedit;
   val_rotate180: tbooleanedit;
   val_scale: trealedit;
   val_shifthorz: trealedit;
   val_shiftvert: trealedit;
 end;
var
 plotsettingsfo: tplotsettingsfo;
implementation
uses
 plotsettings_mfm;
end.
