unit drillmapdialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,sysutils,msesplitter,msesimplewidgets,mainmodule,plotsettings,
 msegraphedits,msescrollbar,docupageeditform,msedbedit,mclasses;
type
 tdrillmapdialogfo = class(tdocupageeditfo)
   tlayouter1: tlayouter;
   val_layeraname: tdbdropdownlistedit;
   plotsettings: tplotsettingsfo;
   val_layerbname: tdbdropdownlistedit;
   val_nonplated: tdbbooleanedit;
  private
  protected
{
   procedure loadvalues() override;
   procedure storevalues() override;
}
  public
   constructor create(aowner: tcomponent); override;
 end;

implementation
uses
 drillmapdialogform_mfm;

{ tdrillmapdialogfo }

constructor tdrillmapdialogfo.create(aowner: tcomponent);
begin
 inherited;
 val_layeraname.dropdown.cols[0].asarray:= mainmo.culayernames;
 val_layerbname.dropdown.cols[0].asarray:= mainmo.culayernames;
end;
{
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
