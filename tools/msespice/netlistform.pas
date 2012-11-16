unit netlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,spiceform,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,mseeditglob,
 msesyntaxedit,msetextedit,msefilechange,msesyntaxpainter,msebitmap,
 msedatanodes,msefiledialog,mselistbrowser,msesys,mseact,mseactions;

type
 tnetlistfo = class(tspicefo)
   grid: twidgetgrid;
   edit: tsyntaxedit;
   filechange: tfilechangenotifyer;
   syntaxpainter: tsyntaxpainter;
   filedialog: tfiledialog;
   saveact: taction;
   saveasact: taction;
   procedure textedexe(const sender: tcustomedit; var atext: msestring);
   procedure saveupdateexe(const sender: tcustomaction);
   procedure saveexe(const sender: TObject);
   procedure saveasexe(const sender: TObject);
  private
   fmodified: boolean;
  protected
   procedure updatecaption;
  public
   procedure loadfile(const afile: filenamety);
   function checksave: boolean; //true if ok
   procedure save;
   procedure close;
 end;
var
 netlistfo: tnetlistfo;
implementation
uses
 netlistform_mfm,msefileutils,msewidgets,mainmodule;

{ tnetlistfo }

procedure tnetlistfo.loadfile(const afile: filenamety);
begin
 try
  edit.loadfromfile(afile);
 except
  application.handleexception;
 end;
 fmodified:= false;
 updatecaption;
end;

procedure tnetlistfo.textedexe(const sender: tcustomedit; var atext: msestring);
begin
 if not fmodified then begin
  fmodified:= true;
  updatecaption;
 end;
end;

procedure tnetlistfo.updatecaption;
var
 fna1: filenamety;
begin
 fna1:= filename(edit.filename);
 if fna1 = '' then begin
  fna1:= '<new>';
 end;
 if edit.modified then begin
  fna1:= '*'+fna1;
 end;
 caption:= fna1;
end;

procedure tnetlistfo.save;
begin
 edit.savetofile('');
 fmodified:= false;
 updatecaption;
end;

procedure tnetlistfo.close;
begin
 edit.clear;
 fmodified:= false;
 updatecaption;
end;

function tnetlistfo.checksave: boolean;
var
 mr1: modalresultty;
begin
 result:= true;
 if edit.modified then begin
  mr1:= askyesnocancel('Netlist '+edit.filename+' is modified. Save?');
  case mr1 of
   mr_yes: begin
    save;
   end;
   mr_no: begin
   end;
   else begin
    result:= false;
   end;
  end;
 end;
end;

procedure tnetlistfo.saveupdateexe(const sender: tcustomaction);
begin
 saveact.enabled:= edit.modified;
 saveasact.enabled:= mainmo.projectloaded;
end;

procedure tnetlistfo.saveexe(const sender: TObject);
begin
 save;
end;

procedure tnetlistfo.saveasexe(const sender: TObject);
begin
 if filedialog.execute(fdk_save) = mr_ok then begin
  edit.savetofile(filedialog.controller.filename);
  mainmo.projectoptions.netlist:= filedialog.controller.filename;
  updatecaption;
 end;
end;

end.
