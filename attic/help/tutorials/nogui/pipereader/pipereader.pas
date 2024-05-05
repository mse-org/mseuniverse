program pipereader;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,cwstring,{$endif}{$endif}
 sysutils,msenogui,main;
begin
 application.createdatamodule(tmainmo,mainmo);
 application.run;
end.
