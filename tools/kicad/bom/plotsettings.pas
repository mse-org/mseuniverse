unit plotsettings;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar,mseact,
 msedataedits,mseedit,msestatfile,msestream,msestrings,sysutils,
 msedbedit;
type
 tplotsettingsfo = class(tsubform)
   val_mirrorx: tdbbooleanedit;
   val_mirrory: tdbbooleanedit;
   val_rotate90: tdbbooleanedit;
   val_rotate180: tdbbooleanedit;
   val_scale: tdbrealedit;
   val_shifthorz: tdbrealedit;
   val_shiftvert: tdbrealedit;
 end;

implementation
uses
 plotsettings_mfm;
end.
