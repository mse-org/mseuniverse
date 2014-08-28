program mdi;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 loaddefaultskin,msegui,main,form1,form2,form3;
begin
 application.createform(tform1fo,form1fo);
 application.createform(tform2fo,form2fo);
 application.createform(tform3fo,form3fo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
