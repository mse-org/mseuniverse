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
   titleed: tstringedit;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   tlayouter1: tlayouter;
   layered: tdropdownlistedit;
   procedure closeev(const sender: TObject);
  private
   ftitle: pmsestring;
   finfo: pdocuplotpageinfoty;
  public
   constructor create(var ainfo: docuplotpageinfoty; var atitle: msestring);
 end;

implementation
uses
 layerplotdialog_mfm;

{ tlayerplotdialogfo }

constructor tlayerplotdialogfo.create(var ainfo: docuplotpageinfoty;
                                                   var atitle: msestring);
begin
 ftitle:= @atitle;
 finfo:= @ainfo;
 inherited create(nil);
 caption:= 'PCB-Layer-Plot '+ftitle^;
 titleed.value:= ftitle^;
 layered.dropdown.cols[0].asarray:= mainmo.plotkinds;
 layered.value:= ainfo.layername;
end;

procedure tlayerplotdialogfo.closeev(const sender: TObject);
begin
 if window.modalresult = mr_ok then begin
  ftitle^:= titleed.value;
  finfo^.layername:= layered.value;
 end;
end;

end.
