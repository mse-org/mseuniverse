unit printwindow;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms;
type
 tprintwindowfo = class(tmseform)
  private
   fwidget: twidget;
  public
   constructor create(const awidget: twidget);
 end;

implementation
uses
 printwindow_mfm;
 
{ tprintwindowfo }

constructor tprintwindowfo.create(const awidget: twidget);
begin
 fwidget:= awidget;
 inherited create(nil);
 try
  show(ml_application);
 finally
  release;
 end; 
end;

end.
