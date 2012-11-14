unit netlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,spiceform,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,mseeditglob,
 msesyntaxedit,msetextedit,msefilechange,msesyntaxpainter,msebitmap,
 msedatanodes,msefiledialog,mselistbrowser,msesys;

type
 tnetlistfo = class(tspicefo)
   grid: twidgetgrid;
   edit: tsyntaxedit;
   filechange: tfilechangenotifyer;
   syntaxpainter: tsyntaxpainter;
   filedialog: tfiledialog;
   procedure textedexe(const sender: tcustomedit; var atext: msestring);
  private
   fmodified: boolean;
  protected
   procedure updatecaption;
  public
   procedure loadfile(const afile: filenamety);
 end;
var
 netlistfo: tnetlistfo;
implementation
uses
 netlistform_mfm,msefileutils;

{ tnetlistfo }

procedure tnetlistfo.loadfile(const afile: filenamety);
begin
 edit.loadfromfile(afile);
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
begin
 if edit.modified then begin
  caption:= '*'+filename(edit.filename);
 end
 else begin
  caption:= filename(edit.filename);
 end;
end;

end.
