unit tagdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestrings;
type
 ttagdialogfo = class(tmseform)
  public
   function exec(const acommit: msestring): boolean;
 end;
var
 tagdialogfo: ttagdialogfo;
implementation
uses
 tagdialogform_mfm;

{ ttagdialogfo }

function ttagdialogfo.exec(const acommit: msestring): boolean;
begin
 result:= false;
end;

end.
