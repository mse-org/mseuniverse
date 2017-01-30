unit bomdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 docupageeditform,msegraphedits,mseificomp,mseificompglob,mseifiglob,
 msescrollbar;

type
 tbomdialogfo = class(tdocupageeditfo)
   val_showreferences: tbooleanedit;
   val_showdistributors: tbooleanedit;
 end;
var
 bomdialogfo: tbomdialogfo;
implementation
uses
 bomdialogform_mfm;
end.
