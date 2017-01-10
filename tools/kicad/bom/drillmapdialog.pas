unit drillmapdialog;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,sysutils,msesplitter,msesimplewidgets,mainmodule,plotsettings;
type
 tdrillmapdialogfo = class(tmseform)
   tstatfile1: tstatfile;
   val_title: tstringedit;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   tlayouter1: tlayouter;
   val_layeraname: tdropdownlistedit;
   plotsettings: tplotsettingsfo;
   val_layerbname: tdropdownlistedit;
   procedure closeev(const sender: TObject);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
  private
//   ftitle: pmsestring;
//   finfo: pdocuplotpageinfoty;
   fpage: tdrillmappage;
  public
   constructor create(const apage: tdrillmappage);
 end;

implementation
uses
 drillmapdialog_mfm;

{ tdrillmapdialogfo }

constructor tdrillmapdialogfo.create(const apage: tdrillmappage);
begin
 fpage:= apage;
 inherited create(nil);
 apage.loadvalues(self,'val_');
 apage.loadvalues(plotsettings,'val_');
 val_layeraname.dropdown.cols[0].asarray:= mainmo.plotkinds;
 val_layerbname.dropdown.cols[0].asarray:= mainmo.plotkinds;
end;

procedure tdrillmapdialogfo.closeev(const sender: TObject);
begin
 if window.modalresult = mr_ok then begin
  fpage.storevalues(self,'val_');
  fpage.storevalues(plotsettings,'val_');
 end;
end;

procedure tdrillmapdialogfo.macrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 mainmo.hintmacros(tedit(sender).text,info);
end;

end.
