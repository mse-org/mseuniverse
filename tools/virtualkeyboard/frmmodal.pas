unit frmmodal;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msecalendardatetimeedit;
type
 tfrmmodalfo = class(tmseform)
   tbutton2: tbutton;
   tintegeredit1: tintegeredit;
   tmemoedit1: tmemoedit;
   tcalendardatetimeedit1: tcalendardatetimeedit;
   procedure closeform(const sender: TObject);
 end;
var
 frmmodalfo: tfrmmodalfo;
implementation
uses
 frmmodal_mfm;
procedure tfrmmodalfo.closeform(const sender: TObject);
begin
 self.close;
end;

end.
