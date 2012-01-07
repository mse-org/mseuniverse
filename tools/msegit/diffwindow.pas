unit diffwindow;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,
 diffform;

type
 tdiffwindowfo = class(tdifffo)
   procedure patchtoolexe(const sender: TObject);
 end;
var
 diffwindowfo: tdiffwindowfo;
implementation
uses
 diffwindow_mfm,mainmodule;
 
procedure tdiffwindowfo.patchtoolexe(const sender: TObject);
begin
 mainmo.patchtoolcall(currentpath,fa,fb);
end;

end.
