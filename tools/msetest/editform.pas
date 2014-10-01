unit editform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,msestrings,
 sysutils,msesimplewidgets,msegraphedits,msescrollbar,msebitmap,msedatanodes,
 msefiledialog,msegrids,mselistbrowser,msesys,msedialog,msesplitter,
 msedispwidgets,mserichstring;
type
 teditfo = class(tmseform)
   tstatfile1: tstatfile;
   tlayouter2: tlayouter;
   tlayouter1: tlayouter;
   val_enabled: tbooleanedit;
   val_caption: tstringedit;
   val_comment: tmemoedit;
   val_path: tfilenameedit;
   tlayouter3: tlayouter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer1: tspacer;
   tlayouter4: tlayouter;
   val_expectedexitcode: tintegeredit;
   tspacer2: tspacer;
   val_actualexitcode: tintegeredit;
   val_runcommand: tstringedit;
   val_input: tdialogstringedit;
   tbutton3: tbutton;
   val_expectedoutput: tdialogstringedit;
   val_actualoutput: tstringedit;
   val_expectederror: tdialogstringedit;
   val_actualerror: tstringedit;
   tspacer3: tspacer;
   tlayouter5: tlayouter;
   val_compilecommand: tstringedit;
   tspacer4: tspacer;
   val_compileresult: tintegeredit;
   procedure layoutexe(const sender: TObject);
   procedure macrohintexe(const sender: TObject; var info: hintinfoty);
   procedure compileresultchangeexe(const sender: TObject);
   procedure outputputchangeexe(const sender: TObject);
   procedure errorchangeexe(const sender: TObject);
   procedure exitcodechangeexe(const sender: TObject);
  protected
   procedure seterror(const adisp: tdataedit; const aerror: boolean);
 end;

implementation
uses
 editform_mfm,mainmodule;
 
procedure teditfo.layoutexe(const sender: TObject);
begin
 synccaptiondistx([val_caption,val_path,val_compilecommand,val_runcommand,
                   val_comment,val_input,
                   val_expectedoutput,val_actualoutput,
                   val_expectederror,val_actualerror,
                   val_expectedexitcode]);
 alignx(wam_start,[val_caption,val_path,val_compilecommand,val_runcommand,
                   val_comment,val_input,
                   val_expectedoutput,val_actualoutput,
                   val_expectederror,val_actualerror,
                   val_expectedexitcode],wam_start,1);
end;

procedure teditfo.macrohintexe(const sender: TObject; var info: hintinfoty);
begin
 info.caption:= mainmo.expandmacros(tedit(sender).text);
end;

procedure teditfo.seterror(const adisp: tdataedit; const aerror: boolean);
begin
 if aerror then begin
  adisp.frame.colorclient:= cl_ltred;
 end
 else begin
  adisp.frame.colorclient:= cl_active;
 end;
end;

procedure teditfo.compileresultchangeexe(const sender: TObject);
begin
 seterror(val_compileresult,
         val_compileresult.value <> 0);
end;

procedure teditfo.outputputchangeexe(const sender: TObject);
begin
 seterror(val_actualoutput,
         val_expectedoutput.value <> val_actualoutput.value);
end;

procedure teditfo.errorchangeexe(const sender: TObject);
begin
 seterror(val_actualerror,
         val_expectederror.value <> val_actualerror.value);
end;

procedure teditfo.exitcodechangeexe(const sender: TObject);
begin
 seterror(val_actualexitcode,
         val_expectedexitcode.value <> val_actualexitcode.value);
end;

end.
