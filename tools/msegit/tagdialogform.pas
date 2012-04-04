unit tagdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestrings,
 msesimplewidgets,msewidgets;
type
 ttagdialogfo = class(tmseform)
   tbutton1: tbutton;
   tbutton2: tbutton;
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
