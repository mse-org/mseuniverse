program invalidvar;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,cwstring,{$endif}{$endif}
 sysutils;
type
 recty = record
  a: integer;
  b: integer;
 end;
 precty = ^recty;
var
 r1: recty;
 po1: precty;
begin
 po1:= @r1;
 po1^.a:= 123;
end.
