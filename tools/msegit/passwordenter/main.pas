unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 mseifiglob,msestrings,msetypes,msedispwidgets,mserichstring,msesimplewidgets,
 msewidgets;

type
 tmainfo = class(tmainform)
   password: tstringedit;
   prompt: tstringdisp;
   tbutton1: tbutton;
   tbutton2: tbutton;
   procedure loadedexe(const sender: TObject);
   procedure closequeryexe(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure showexe(const sender: TObject);
 end;
 
var
 mainfo: tmainfo;
 procresult: integer = 255;
 
implementation
uses
 main_mfm,msesys,sysutils,msesysintf;
 
procedure tmainfo.loadedexe(const sender: TObject);
begin
 prompt.value:= getcommandlineargument(1);
end;

procedure tmainfo.closequeryexe(const sender: tcustommseform;
               var amodalresult: modalresultty);
var
 str1: string;
begin
 if amodalresult = mr_ok then begin
  str1:= stringtoutf8(password.value){+c_linefeed};
  sys_write(sys_stdout,pointer(str1),length(str1));
  procresult:= 0;
 end;
end;

procedure tmainfo.showexe(const sender: TObject);
begin
 activate;
end;

end.