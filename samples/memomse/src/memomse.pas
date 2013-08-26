program memomse;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif}
 msegui,mseforms,main, sysutils, udmaction;
begin
 application.createdatamodule(tudmactionmo, udmactionmo);
 application.createform(tmainfo,mainfo); 
 if Length(paramstr(1)) > 0 then begin
   udmactionmo.openfile(paramstr(1));
 end else begin
   udmactionmo.makenew;
 end;
 application.run;
end.
