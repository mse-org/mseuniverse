unit diffwindow;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,diffform,mseact,
 mseactions,mseifiglob;

type
 tdiffwindowfo = class(tdifffo)
   patchact: taction;
   procedure patchtoolexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu); override;
   procedure afterstatreadexe(const sender: TObject);
  protected
 end;

var
 diffwindowfo: tdiffwindowfo;

implementation
uses
 diffwindow_mfm,mainmodule;
 
procedure tdiffwindowfo.patchtoolexe(const sender: TObject);
begin
 mainmo.patchtoolcall(currentpath,fa,fb);
end;

procedure tdiffwindowfo.popupupdateexe(const sender: tcustommenu);
begin
 inherited;
 patchact.enabled:= singlediff and (mainmo.opt.difftool <> '');
end;

procedure tdiffwindowfo.afterstatreadexe(const sender: TObject);
begin
 tabs.activepageindex:= 0; //override stored value
end;


end.
