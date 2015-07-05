program testproc;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,cwstring,{$endif}{$endif}
 sysutils,msestrings{$ifdef mswindows},windows{$endif};

{$ifdef mswindows}
function getenvironmentvariablecount(): int32;
var
 po1,po2: pchar;
 i1: int32;
begin
 po1:= getenvironmentstrings();
 po2:= po1;
 i1:= 0;
 while po2^ <> #0 do begin
  while po2^ <> #0 do begin
   inc(po2);
  end;
  inc(po2);
  inc(i1);
 end; 
 freeenvironmentstrings(po1);
 result:= i1;
end;
              //fpc version is buggy
function getenvironmentstring(aindex: int32): string;
var
 po1,ps,pe: pchar;
begin
 result:= '';
 po1:= getenvironmentstrings();
 ps:= po1;
 pe:= po1;
 repeat
  while pe^ <> #0 do begin
   inc(pe);
  end;
  if aindex = 0 then begin
   result:= psubstr(ps,pe);
   break;
  end;
  ps:= pe+1;
  pe:= ps;
  dec(aindex)
 until (ps^ = #0);
 freeenvironmentstrings(po1);
end;
{$endif}

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
