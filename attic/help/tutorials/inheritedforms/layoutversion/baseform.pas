unit baseform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msestrings,msetypes;
type
 tbasefo = class(tmseform)
   tbutton1: tbutton;
   edit1: tstringedit;
   tlabel1: tlabel;
   procedure destroyex(const sender: TObject);
   procedure setva(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
 end;
var
 basefo: tbasefo;
implementation
uses
 baseform_mfm,main;
 
procedure tbasefo.destroyex(const sender: TObject);
begin
 if mainfo.theform = self then begin
  mainfo.theform:= nil;
 end;
end;

procedure tbasefo.setva(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 mainfo.textedit.value:= avalue;
end;

end.
