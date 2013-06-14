unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,msepipestream;

type
 tmainmo = class(tmsedatamodule)
   pipereader: tpipereadercomp;
   procedure pipebrokenexe(const sender: tpipereader);
   procedure inputavailexe(const sender: tpipereader);
   procedure loadedexe(const sender: TObject);
 end;
var
 mainmo: tmainmo;
implementation
uses
 main_mfm,msesysintf,sysutils;
 
procedure tmainmo.pipebrokenexe(const sender: tpipereader);
begin
 application.terminated:= true;
end;

procedure tmainmo.inputavailexe(const sender: tpipereader);
var
 str1: string;
begin
 if sender.readstrln(str1) then begin
  writeln(uppercase(str1));
  if trim(str1) = 'q' then begin
   writeln('Quitting.');
   application.terminated:= true;
  end;
 end;
end;

procedure tmainmo.loadedexe(const sender: TObject);
begin
 pipereader.pipereader.handle:= sys_stdin;
 writeln('MSEide+MSEgui');
 writeln('Hello world! :-)');
 writeln('"q" for quit.');
end;

end.
