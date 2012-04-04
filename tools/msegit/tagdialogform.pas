unit tagdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestrings,
 msesimplewidgets,msewidgets,msedataedits,mseedit,mseifiglob,msetypes,
 msestatfile,msedispwidgets,mserichstring;
type
 ttagdialogfo = class(tmseform)
   tbutton1: tbutton;
   tbutton2: tbutton;
   nameed: tstringedit;
   messageed: tmemoedit;
   tstatfile1: tstatfile;
   commitdisp: tstringdisp;
   procedure loadedexe(const sender: TObject);
   procedure updateexe(const sender: tcustombutton);
  public
   function exec(const acommit: msestring): boolean;
 end;
var
 tagdialogfo: ttagdialogfo;
implementation
uses
 tagdialogform_mfm,mainmodule,main;

{ ttagdialogfo }

function ttagdialogfo.exec(const acommit: msestring): boolean;
begin
 commitdisp.value:= acommit;
 result:= show(ml_application) = mr_ok;
 if result then begin
  result:= mainmo.createtag(nameed.value,messageed.value,acommit);
 end;
end;

procedure ttagdialogfo.loadedexe(const sender: TObject);
begin
 if not mainfo.hastagdialogstat then begin
  nameed.value:= '';
  messageed.value:= '';
  mainfo.hastagdialogstat:= true;
 end;
end;

procedure ttagdialogfo.updateexe(const sender: tcustombutton);
begin
 sender.enabled:= nameed.value <> '';
end;

end.
