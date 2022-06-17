program testtransp;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 sysutils, classes, MClasses,msetypes, mseglob, mseguiglob, mseguiintf,
 mseapplication, msestat, msemenus,msegui,msegraphics, msegraphutils, mseevent,
 mseclasses, msewidgets, mseforms,msesimplewidgets, msedispwidgets,
 mserichstring, mseedit, msestatfile, msestream, msedragglob, msegrids,
 msegridsglob, mseimage,
 main;
 
begin
 application.createform(tmainfo,mainfo);
 application.run;
end.
