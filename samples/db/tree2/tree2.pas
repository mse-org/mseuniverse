program tree2;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 msegui,main,mainmodule;
begin
 application.createdatamodule(tmainmo,mainmo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
