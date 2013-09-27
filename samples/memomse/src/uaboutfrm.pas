unit uaboutfrm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msetypes;
type
 tuaboutfrmfo = class(ttabform)
   tmemoedit1: tmemoedit;
 end;
var
 uaboutfrmfo: tuaboutfrmfo;
implementation
uses
 uaboutfrm_mfm;
end.
