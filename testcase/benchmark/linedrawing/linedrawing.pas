program linedrawing;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 msegui,main,loadguitemplates;
begin
 application.createform(tmainfo,mainfo);
 application.run;
end.
