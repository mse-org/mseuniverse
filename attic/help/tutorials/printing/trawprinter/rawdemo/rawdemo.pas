program rawdemo;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}

 {$ifdef mswindows} // windows only
uses
 msegui,mseforms,main;
 {$endif}
begin
{$ifdef mswindows} // windows only
 application.createform(tmainfo,mainfo);
 application.run;
{$else}
 writeln('Windows only, sorry...');
{$endif}
end.
