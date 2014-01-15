program echo;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,cwstring,{$endif}{$endif}
 sysutils;
var
 str1: string;
begin
 writeln('*echo started, send Q for teminating*');
 flush(output);
 repeat
  readln(str1);
  str1:= uppercase(str1);
  writeln(str1);
  flush(output);
 until trim(str1) = 'Q';
 writeln('*echo terminated*');
end.
