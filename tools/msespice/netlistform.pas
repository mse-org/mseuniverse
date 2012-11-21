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
   procedure filechangeexe(const sender: tfilechangenotifyer;
                   const info: filechangeinfoty);
   procedure idelexe(var again: Boolean);
  private
   fmodified: boolean;
   fcheckfilechanged: boolean;
  protected
   procedure updatecaption;
   function checkfilechanged: boolean;
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
 netlistform_mfm,msefileutils,msewidgets,mainmodule,msestream,mserichstring;

{ tnetlistfo }

procedure tnetlistfo.loadfile(const afile: filenamety);
begin
 try
  if edit.filename <> '' then begin
   filechange.removenotification(edit.filename);
  end;
  edit.loadfromfile(afile);
  filechange.addnotification(edit.filename);
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
 filechange.removenotification(edit.filename);
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
  filechange.removenotification(edit.filename);
  edit.savetofile(filedialog.controller.filename);
  filechange.addnotification(edit.filename);
  mainmo.projectoptions.netlist:= filedialog.controller.filename;
  updatecaption;
 end;
end;

function tnetlistfo.checkfilechanged: boolean;
var
 stream1: ttextstream;
 int1,int2: integer;
 po1: prichstringty;
 mstr1: msestring;
begin
 result:= edit.modified;
 if not result then begin
  result:= true;
  if ttextstream.trycreate(stream1,edit.filename,fm_read) then begin
                            //else locked or deleted
   try
    stream1.encoding:= edit.encoding;
    int1:= 0;
    int2:= edit.datalist.count - 1;
    po1:= edit.datalist.datapo;
    for int1:= 0 to int2 do begin
     if not stream1.readln(mstr1) then begin
      if int1 <> int2 then begin
       exit;
      end;
     end;
     if mstr1 <> po1^.text then begin
      exit;
     end;
     inc(po1);
    end;
    if stream1.eof then begin
     result:= false;
    end;
   finally
    stream1.free;
   end;
  end;
 end;
end;

procedure tnetlistfo.filechangeexe(const sender: tfilechangenotifyer;
               const info: filechangeinfoty);
begin
 fcheckfilechanged:= true;
 application.wakeupmainthread;
end;

procedure tnetlistfo.idelexe(var again: Boolean);
var
 pt1: gridcoordty;
 bo1:boolean;
begin
 if fcheckfilechanged and application.active then begin
  fcheckfilechanged:= false;
  bo1:= not edit.modified or askyesno('File "'+edit.filename+
  '" has changed, there are changes in edit buffer also.'+lineend+'Reload?');
  if bo1 then begin
   pt1:= edit.editpos;
   loadfile(edit.filename);
   edit.editpos:= pt1;
  end;   
 end;
end;

end.
