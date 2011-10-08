unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,msebitmap,msedataedits,mseedit,msestrings,msetypes,msegraphedits,
 msedispwidgets;

type
 tmainfo = class(tmainform)
   trichbutton1: trichbutton;
   backgroundimagelist: timagelist;
   tdatabutton1: tdatabutton;
   tdatabutton2: tdatabutton;
   trichbutton2: trichbutton;
   adisp: tintegerdisp;
   bdisp: tintegerdisp;
   tbutton1: tbutton;
   tstringedit1: tstringedit;
   tfacelist1: tfacelist;
   tbutton2: tbutton;
   foregroundimagelist: timagelist;
   procedure exe(const sender: TObject);
   procedure aset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure bset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.exe(const sender: TObject);
begin
 msegui.beep;
end;

procedure tmainfo.aset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 adisp.value:= avalue;
end;

procedure tmainfo.bset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 bdisp.value:= avalue;
end;

end.
