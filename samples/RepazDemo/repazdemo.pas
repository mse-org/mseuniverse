program repazdemo;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}msegui,mseforms,main,
 datamodule,msedatamodules;
begin
 application.createdatamodule(tdatamo,datamo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
