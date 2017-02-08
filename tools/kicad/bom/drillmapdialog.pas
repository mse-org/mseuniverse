unit drillmapdialog;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,sysutils,msesplitter,msesimplewidgets,mainmodule,plotsettings,
 msegraphedits,msescrollbar,docupageeditform;
type
 tdrillmapdialogfo = class(tdocupageeditfo)
   tlayouter1: tlayouter;
   val_layeraname: tdropdownlistedit;
   plotsettings: tplotsettingsfo;
   val_layerbname: tdropdownlistedit;
   val_nonplated: tbooleanedit;
  private
  protected
{
   procedure loadvalues() override;
   procedure storevalues() override;
}
  public
//   constructor create(const apage: tdrillmappage);
 end;

implementation
uses
 drillmapdialog_mfm;

{ tdrillmapdialogfo }
{
constructor tdrillmapdialogfo.create(const apage: tdrillmappage);
begin
 inherited create(apage);
 val_layeraname.dropdown.cols[0].asarray:= mainmo.culayernames;
 val_layerbname.dropdown.cols[0].asarray:= mainmo.culayernames;
end;

procedure tdrillmapdialogfo.loadvalues();
begin
 inherited;
 fpage.loadvalues(plotsettings,'val_');
end;

procedure tdrillmapdialogfo.storevalues();
begin
 inherited;
 fpage.storevalues(plotsettings,'val_');
end;
}

end.
