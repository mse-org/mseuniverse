program memomse;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif}
 msegui,mseforms,main, sysutils;
begin
 application.createform(tmainfo,mainfo); 
 if Length(paramstr(1)) > 0 then begin
   mainfo.simpletext.loadfromfile(paramstr(1));
   EditFileName := paramstr(1);
   mainfo.showinfo;
 end;
 application.run;
end.
