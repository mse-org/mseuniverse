unit macrosform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,
 msestrings,msewidgetgrid,sysutils,msesplitter,msesimplewidgets,msedialog,
 msememodialog;
type
 tmacrosfo = class(tmseform)
   grid: twidgetgrid;
   val_macronames: tstringedit;
   val_macrovalues: tmemodialogedit;
   tstatfile1: tstatfile;
   tlayouter1: tlayouter;
   okbu: tbutton;
   cancelbu: tbutton;
 end;
var
 macrosfo: tmacrosfo;
implementation
uses
 macrosform_mfm;
end.
