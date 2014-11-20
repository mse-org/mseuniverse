unit groupeditform;
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
 tgroupeditfo = class(tmseform)
   tstatfile1: tstatfile;
   tlayouter2: tlayouter;
   tlayouter1: tlayouter;
   val_enabled: tbooleanedit;
   val_caption: tstringedit;
   val_comment: tmemoedit;
   val_pathdefault: tfilenameedit;
   tlayouter3: tlayouter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer1: tspacer;
   tlayouter4: tlayouter;
   val_expectedexitcode: trealedit;
   val_runcommand: tstringedit;
   val_input: tstringedit;
   val_expectedoutput: tstringedit;
   val_expectederror: tstringedit;
   tlayouter5: tlayouter;
   val_compilecommand: tstringedit;
   tlabel1: tlabel;
   val_captiondefault: tstringedit;
   val_path: tfilenameedit;
   val_nr: tintegerdisp;
   tspacer5: tspacer;
   tspacer2: tspacer;
   val_nrlast: tintegerdisp;
   val_compiledirectory: tstringedit;
   val_rundirectory: tstringedit;
   procedure layoutexe(const sender: TObject);
   procedure macrohintexe(const sender: TObject; var info: hintinfoty);
   procedure filemacrohintexe(const sender: TObject; var info: hintinfoty);
   procedure pathmacrohintexe(const sender: TObject; var info: hintinfoty);
   procedure nrchangeexe(const sender: TObject);
  protected
   function pathmacro(): msestring;
   function filemacro(): msestring;
 end;

implementation
uses
 groupeditform_mfm,mainmodule;
 
procedure tgroupeditfo.layoutexe(const sender: TObject);
begin
 synccaptiondistx([val_caption,val_captiondefault,val_pathdefault,
                   val_path,val_compilecommand,val_compiledirectory,
                   val_runcommand,val_rundirectory,
                   val_comment,val_input,
                   val_expectedoutput,
                   val_expectederror,
                   val_expectedexitcode]);
 alignx(wam_start,[val_caption,val_captiondefault,val_pathdefault,
                   val_path,val_compilecommand,val_compiledirectory,
                   val_runcommand,val_rundirectory,
                   val_comment,val_input,
                   val_expectedoutput,
                   val_expectederror,
                   val_expectedexitcode],wam_start,1);
end;

function tgroupeditfo.pathmacro: msestring;
var
 n1: ttreelistitem;
begin
 n1:= mainmo.edititem.parent;
 if n1 is ttestpathnode then begin
  result:= ttestpathnode(n1).rootfilepath+val_path.value;
 end
 else begin
  result:= val_path.value;
 end; 
end;

function tgroupeditfo.filemacro: msestring;
begin
 result:= pathmacro()+val_pathdefault.value;
end;

procedure tgroupeditfo.pathmacrohintexe(const sender: TObject;
               var info: hintinfoty);
begin
 info.caption:= mainmo.expandmacros(mainmo.edititem,pathmacro,'',fn_path);
end;

procedure tgroupeditfo.macrohintexe(const sender: TObject; 
                                                      var info: hintinfoty);
begin
 info.caption:= mainmo.expandmacros(
             mainmo.edititem,tedit(sender).text,filemacro(),
             fieldnumberty(tedit(sender).tag));
 include(info.flags,hfl_show); //show empty hint
end;

procedure tgroupeditfo.filemacrohintexe(const sender: TObject;
                                               var info: hintinfoty);
begin
 info.caption:= mainmo.expandmacros(mainmo.edititem,filemacro,'',fn_path);
end;

procedure tgroupeditfo.nrchangeexe(const sender: TObject);
begin
 if val_nrlast.value < val_nr.value then begin
  val_nrlast.text:= ' ';
  val_nr.text:= ' ';
 end
 else begin
  val_nrlast.text:= '';
  val_nr.text:= '';
 end;
end;

end.
