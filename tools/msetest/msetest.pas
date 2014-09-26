program msetest;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 msegui,main,mainmodule,loadguitemplates,msegraphics;
begin
// flushgdi:= true;
 application.createform(tmainfo,mainfo);
 application.createdatamodule(tmainmo,mainmo);
 application.run;
end.
