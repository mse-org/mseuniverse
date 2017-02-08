unit bomdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 docupageeditform,msegraphedits,mseificomp,mseificompglob,mseifiglob,
 msescrollbar,msedbedit;

type
 tbomdialogfo = class(tdocupageeditfo)
   val_showreferences: tdbbooleanedit;
   val_showdistributors: tdbbooleanedit;
 end;
implementation
uses
 bomdialogform_mfm;
end.
