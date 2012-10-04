program mseinstaller;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,cwstring,{$endif}{$endif}msegui,mseforms,main,skinblue;

{$ifdef mswindows} 
 {$R mse-installer-icon.res} 
 {$R mse-installer-ver.res} 
{$endif} 
begin
 application.createdatamodule(tskinblue,skinbluemo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
