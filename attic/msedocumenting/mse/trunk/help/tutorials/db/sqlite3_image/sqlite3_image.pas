program sqlite3_image;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}msegui,mseforms,main,skin;
begin
 application.createdatamodule(tskinmo,skinmo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
