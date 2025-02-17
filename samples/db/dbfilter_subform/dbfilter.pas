// By Med Hanza 2025

program dbfilter;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}msegui,mseforms,main,dmain;
begin
 application.createdatamodule(tdmainmo,dmainmo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
