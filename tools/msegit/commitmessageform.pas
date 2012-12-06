unit commitmessageform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 mseifiglob,msestrings,msetypes,msesplitter,msesimplewidgets,msewidgets,
 msestatfile;
type
 tcommitmessagefo = class(tmseform)
   messageed: tmemoedit;
   tlayouter1: tlayouter;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tstatfile1: tstatfile;
 end;
var
 commitmessagefo: tcommitmessagefo;
implementation
uses
 commitmessageform_mfm;
end.
