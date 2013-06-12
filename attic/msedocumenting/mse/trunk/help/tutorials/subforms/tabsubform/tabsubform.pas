program tabsubform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif}
 msegui,mseforms,main,datamodule;
begin
 application.createdatamodule(tdatamo,datamo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
