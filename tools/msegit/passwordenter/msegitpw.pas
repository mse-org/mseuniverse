program msegitpw;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype console}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}
 msegui,mseforms,main,msesysintf,msestrings,sysutils;
begin
 application.createform(tmainfo,mainfo);
 application.run;
 sys_closefile(sys_stdout);
 sleep(100);
 halt(procresult);
end.
