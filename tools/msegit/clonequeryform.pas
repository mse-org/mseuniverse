unit clonequeryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msebitmap,msedataedits,
 msedatanodes,mseedit,msefiledialog,msegrids,mseifiglob,mselistbrowser,
 msestrings,msesys,msetypes,msestatfile,msesimplewidgets,msewidgets;
type
 tclonequeryfo = class(tmseform)
   clonedired: tfilenameedit;
   tstatfile1: tstatfile;
   tbutton1: tbutton;
   tbutton2: tbutton;
   cloneurled: thistoryedit;
 end;
implementation
uses
 clonequeryform_mfm;
end.
