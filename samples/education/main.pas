unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedispwidgets,
 mserichstring,msestrings,msetypes,msedataedits,mseedit,mseifiglob;

type
 tmainfo = class(tmainform)
   ciphercount: tintegerdisp;
   cipher: tintegeredit;
   loopcount: tintegeredit;
   procedure dataeneteredexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
 
implementation
uses
 sysutils,main_mfm;

function countciphers(loops: integer; searchfor: char): integer;
var
 mainloopcounter: integer;
 cipherloopcounter: integer;
 foundcount: integer;
 str1: string;
begin
 foundcount:= 0;
 for mainloopcounter:= 1 to loops do begin
  str1:= inttostr(mainloopcounter);
  for cipherloopcounter:= 1 to length(str1) do begin
   if str1[cipherloopcounter] = searchfor then begin
    inc(foundcount);
   end;
  end;
 end;
 result:= foundcount;
end;
 
procedure tmainfo.dataeneteredexe(const sender: TObject);
begin
 ciphercount.value:= countciphers(loopcount.value,inttostr(cipher.value)[1]);
end;

end.
