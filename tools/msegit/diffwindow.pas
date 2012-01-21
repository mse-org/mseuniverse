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
 diffwindow_mfm,mainmodule,msestrings,difftab;
 
procedure tdiffwindowfo.patchtoolexe(const sender: TObject);
var
 mstr1,a,b: msestring;
begin
 if fiscommits then begin
  with tdifftabfo(tabs.activepage) do begin
   if grid.rowcount >= 2 then begin
    mstr1:= ed[1];
    if (length(mstr1) > 6+40+2+40) and msestartsstr('index ',mstr1) then begin
     a:= copy(mstr1,1+6,40);
     b:= copy(mstr1,1+6+40+2,40);
    end;
   end;
  end;
 end
 else begin
  a:= fa;
  b:= fb;
 end;
 mainmo.patchtoolcall(currentpath,a,b,fiscommits);
end;

procedure tdiffwindowfo.popupupdateexe(const sender: tcustommenu);
begin
 inherited;
 patchact.enabled:= singlediff and (mainmo.opt.difftool <> '');
 externaldiffact.enabled:= externaldiffact.enabled and not fiscommits;
end;

procedure tdiffwindowfo.afterstatreadexe(const sender: TObject);
begin
 tabs.activepageindex:= 0; //override stored value
end;


end.
