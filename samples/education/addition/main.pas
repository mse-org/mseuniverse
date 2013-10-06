unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedispwidgets,
 mserichstring,msestrings,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msetypes,msesimplewidgets,msewidgets;

type
 tmainfo = class(tmainform)
   a: tintegeredit;
   b: tintegeredit;
   res: tintegerdisp;
   tbutton1: tbutton;
   procedure dataenteredexe(const sender: TObject);
   procedure exitexe(const sender: TObject);
 end;

var
 mainfo: tmainfo;

implementation

uses
 main_mfm;
 
procedure tmainfo.dataenteredexe(const sender: TObject);
begin
 res.value:= a.value + b.value;
end;

procedure tmainfo.exitexe(const sender: TObject);
begin
 close;
end;

end.
