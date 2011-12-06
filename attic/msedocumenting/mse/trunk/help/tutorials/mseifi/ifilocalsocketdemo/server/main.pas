unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,msesockets,msesys,
 msethreadcomp,msestrings,msessl;

type
 tmainmo = class(tmsedatamodule)
   tsocketserver1: tsocketserver;
   commandthread: tthreadcomp;
   ssl: tssl;
   procedure acceptexe(const sender: tcustomsocketserver;
                   const asocket: Integer; const addr: socketaddrty;
                   var accept: Boolean);
   procedure chdisconnectexe(const sender: tcustomsocketserver;
                   const apipes: tcustomcommpipes);
   procedure commandthreadexe(const sender: tthreadcomp);
   procedure chconnect(const sender: tcustomsocketserver;
                   const apipes: tcustomcommpipes);
  private
   fconncount: integer;
 end;

var
 mainmo: tmainmo;

procedure writelnlocked(const atext: string);

implementation
uses
 main_mfm,sysutils,clientmodule;
 
procedure writelnlocked(const atext: string);
begin
 application.lock;
 writeln(atext);
 application.unlock;
end;
 
procedure tmainmo.commandthreadexe(const sender: tthreadcomp);
var
 str1: string;
begin
 writelnlocked('MSEifi local socket demo server started.'+lineend+
         'Enter q for quit.');
 while not application.terminated do begin
  readln(str1);
  if str1 = 'q' then begin
   application.terminated:= true;
  end;
 end;
 writelnlocked('Server terminated.');
end;

procedure tmainmo.acceptexe(const sender: tcustomsocketserver;
               const asocket: Integer; const addr: socketaddrty;
               var accept: Boolean);
begin
 accept:= true;
 inc(fconncount);
 writeln('connection '+ inttostr(fconncount)+' accepted');
end;

procedure tmainmo.chdisconnectexe(const sender: tcustomsocketserver;
               const apipes: tcustomcommpipes);
begin
 writeln('connection '+ inttostr(fconncount)+' closed');
 dec(fconncount);
end;

procedure tmainmo.chconnect(const sender: tcustomsocketserver;
               const apipes: tcustomcommpipes);
var
 mo1: tclientmo;
begin
 application.createdatamodule(tclientmo,mo1);
 with mo1 do begin
  channel.link(apipes);
 end;
end;

end.
