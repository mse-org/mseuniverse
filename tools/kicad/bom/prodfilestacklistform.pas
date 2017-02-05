unit prodfilestacklistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 listeditform;

type
 tprodfilestacklistfo = class(tlisteditfo)
   procedure dialogev(const sender: TObject);
 end;
implementation
uses
 prodfilestacklistform_mfm,prodfilestackeditform;
 
procedure tprodfilestacklistfo.dialogev(const sender: TObject);
begin
 tprodfilestackeditfo.create(nil).show(ml_application);
end;

end.
