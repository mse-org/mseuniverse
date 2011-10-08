program noguitimer;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}
 sysutils,msenogui,mseclasses,main;
begin
 application.createdatamodule(tmainmo,mainmo);
 application.run;
end.
