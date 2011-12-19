unit difftab;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,mseeditglob,
 msetextedit;
type
 tdifftabfo = class(ttabform)
   grid: twidgetgrid;
   ed: ttextedit;
 end;
var
 difftabfo: tdifftabfo;
implementation
uses
 difftab_mfm;
end.
