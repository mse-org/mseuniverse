unit paramform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,spiceform,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msememodialog,
 mseificomp,mseificompglob;

type
 tparamfo = class(tspicefo)
   grid: twidgetgrid;
   paramname: tstringedit;
   paramexpression: tmemodialogedit;
   procedure datamodifiedeexe(const sender: TObject);
 end;
var
 paramfo: tparamfo;
implementation
uses
 paramform_mfm,mainmodule;
 
procedure tparamfo.datamodifiedeexe(const sender: TObject);
begin
 mainmo.projectmodified;
end;

end.
