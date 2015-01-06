unit renamequeryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestrings,
 msestatfile,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselistbrowser,msestream,msesys,sysutils,
 msesplitter,msesimplewidgets,msedispwidgets,mserichstring;
type
 trenamequeryfo = class(tmseform)
   tstatfile1: tstatfile;
   newnameed: tfilenameedit;
   tlayouter1: tlayouter;
   okbu: tbutton;
   cancelbu: tbutton;
   oldnamedisp: tstringdisp;
   procedure setnewexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
  public
   function exec(const oldname: filenamety): filenamety;
 end;
var
 renamequeryfo: trenamequeryfo;
implementation
uses
 renamequeryform_mfm;

{ trenamequeryfo }

function trenamequeryfo.exec(const oldname: filenamety): filenamety;
begin
 result:= '';
 oldnamedisp.value:= oldname;
 newnameed.value:= oldname;
 if show(ml_application) = mr_ok then begin
  result:= newnameed.value;
 end;
end;

procedure trenamequeryfo.setnewexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if avalue = '' then begin
  avalue:= oldnamedisp.value;
 end;
end;

end.
