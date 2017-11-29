unit basedynform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mclasses,msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,
 msemenus,msegui,msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msesimplewidgets,msewidgets,mseact,msedataedits,msedropdownlist,mseedit,
 mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,sysutils;

type
 tbasedynfo = class(tdockform)
   tlabel2: tlabel;
   tstringedit1: tstringedit;
  public
 end;
var
 basedynfo: tbasedynfo;
implementation
uses
 basedynform_mfm,main;
 
{ tbasedynfo }

end.
