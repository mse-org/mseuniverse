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
   constructor create(aowner: tcomponent); override;
 end;
var
 basedynfo: tbasedynfo;
implementation
uses
 basedynform_mfm,main;
 
{ tbasedynfo }

constructor tbasedynfo.create(aowner: tcomponent);
begin
 inherited;
 mainfo.panelcontroller.registerdynamiccomp(self);
end;

end.
