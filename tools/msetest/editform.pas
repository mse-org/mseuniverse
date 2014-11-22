unit editform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms;
type
 teditfo = class(tmseform)
  public
   procedure init() virtual;
 end;

implementation
uses
 editform_mfm;

{ teditfo }

procedure teditfo.init();
begin
 //dummy 
end;

end.
