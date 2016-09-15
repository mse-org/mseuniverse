program minimal;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 msegui,main,ibase60dyn;
begin
 initializeibase60(['libfbclient.so.3.0.1']);
 application.createform(tmainfo,mainfo);
 application.run;
end.
