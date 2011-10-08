program noguiapp;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef linux}cthreads,{$endif}msenogui,sysutils,mainmodule;
begin
 application.createdatamodule(tmainmo,mainmo);
 application.run;
end.
