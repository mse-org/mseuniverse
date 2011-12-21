unit lastmessageform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestatfile,
 msesimplewidgets,msewidgets,msedataedits,mseedit,msegrids,mseifiglob,
 msestrings,msetypes,msewidgetgrid;
type
 tlastmessagefo = class(tmseform)
   tstatfile1: tstatfile;
   tbutton1: tbutton;
   tbutton2: tbutton;
   grid: twidgetgrid;
   ed: tstringedit;
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
 end;
var
 lastmessagefo: tlastmessagefo;
implementation
uses
 lastmessageform_mfm;
 
procedure tlastmessagefo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if (grid.row >= 0) and (iscellclick(info,[ccr_dblclick])) then begin
  window.modalresult:= mr_ok;
 end;
end;

end.
