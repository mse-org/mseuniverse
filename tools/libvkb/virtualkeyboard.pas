unit virtualkeyboard;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 frmkeyboard,msegui;
 
procedure enabledvirtualkeyboard;
procedure disabledvirtualkeyboard;

implementation

procedure enabledvirtualkeyboard;
begin
 if frmkeyboardfo=nil then begin
  application.createform(tfrmkeyboardfo,frmkeyboardfo);
  if application.activewidget<>nil then begin
   frmkeyboardfo.showkeyboard(application.activewidget);
  end;
 end;
end;

procedure disabledvirtualkeyboard;
begin
 frmkeyboardfo.free;
 frmkeyboardfo:= nil;
end;

end.
