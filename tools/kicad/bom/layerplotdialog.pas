unit layerplotdialog;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,sysutils,msesplitter,msesimplewidgets,mainmodule;
type
 tlayerplotdialogfo = class(tmseform)
   tstatfile1: tstatfile;
   val_title: tstringedit;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   tlayouter1: tlayouter;
   val_layername: tdropdownlistedit;
   procedure closeev(const sender: TObject);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
  private
//   ftitle: pmsestring;
//   finfo: pdocuplotpageinfoty;
   fpage: tlayerplotpage;
  public
   constructor create(const apage: tlayerplotpage);
 end;

implementation
uses
 layerplotdialog_mfm;

{ tlayerplotdialogfo }

constructor tlayerplotdialogfo.create(const apage: tlayerplotpage);
begin
 fpage:= apage;
// ftitle:= @atitle;
// finfo:= @ainfo;
 inherited create(nil);
 apage.loadvalues(self,'val_');
 caption:= 'PCB-Layer-Plot '+val_title.value;
// titleed.value:= ftitle^;
 val_layername.dropdown.cols[0].asarray:= mainmo.plotkinds;
// layered.value:= ainfo.layername;
end;

procedure tlayerplotdialogfo.closeev(const sender: TObject);
begin
 if window.modalresult = mr_ok then begin
  fpage.storevalues(self,'val_');
//  ftitle^:= titleed.value;
//  finfo^.layername:= layered.value;
 end;
end;

procedure tlayerplotdialogfo.macrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 mainmo.hintmacros(tedit(sender).text,info);
end;

end.
