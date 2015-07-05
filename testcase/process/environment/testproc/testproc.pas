program testproc;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,cwstring,{$endif}{$endif}
 sysutils;
var
 i1: int32;
begin
 writeln('*testproc start');
 writeln('*params:');
 for i1:= 0 to paramcount do begin
  writeln(inttostr(i1)+': '+paramstr(i1));
 end;
 writeln('*envvars:');
 for i1:= 0 to getenvironmentvariablecount-1 do begin
  writeln(inttostr(i1)+': '+getenvironmentstring(i1));
 end;
 writeln('*testproc end');
end.
