program genlfsrtable;
//generates table for the 32 bit lfsr x^32+x^30+x^26+x^25+1
//
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,cwstring,{$endif}{$endif}
 sysutils;

function feedback(const value: integer): integer;
begin
 result:= ((value shr (32 - 25)) xor
          (value shr (30 - 25)) xor
          (value shr (26 - 25)) xor
          (value shr (25 - 25))) and 1;
end;

var
 int1: integer;
 by1: byte;
begin
 by1:= 0;
 for int1:= 0 to 255 do begin
  if int1 mod 32 = 0 then begin
   writeln;
  end;
  write(feedback(int1),',');
 end;
end.
