{ MSEtest Copyright (c) 2014 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit testeditform;
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
 ttesteditfo = class(tmseform)
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
   tbutton3: tbutton;
   val_expectedoutput: tstringedit;
   val_actualoutput: tstringedit;
   val_expectederror: tstringedit;
   val_actualerror: tstringedit;
   tspacer3: tspacer;
   tlayouter5: tlayouter;
   val_compilecommand: tstringedit;
   tspacer4: tspacer;
   val_compileresult: tintegeredit;
   val_nr: tintegerdisp;
   tspacer5: tspacer;
   tlayouter6: tlayouter;
   val_input: tstringedit;
   val_inputerror: tbooleandisp;
   tspacer6: tspacer;
   val_compiledirectory: tstringedit;
   val_rundirectory: tstringedit;
   procedure layoutexe(const sender: TObject);
   procedure macrohintexe(const sender: TObject; var info: hintinfoty);
   procedure compileresultchangeexe(const sender: TObject);
   procedure outputputchangeexe(const sender: TObject);
   procedure errorchangeexe(const sender: TObject);
   procedure exitcodechangeexe(const sender: TObject);
   procedure filemacrohintexe(const sender: TObject; var info: hintinfoty);
   procedure inputerrorchangeexe(const sender: TObject);
  protected
   function filemacro(): msestring;
 end;

implementation
uses
 testeditform_mfm,mainmodule,runform;
 
procedure ttesteditfo.layoutexe(const sender: TObject);
begin
 synccaptiondistx([val_caption,val_path,val_compilecommand,val_compiledirectory,
                   val_runcommand,val_rundirectory,
                   val_comment,val_input,
                   val_expectedoutput,val_actualoutput,
                   val_expectederror,val_actualerror,
                   val_expectedexitcode]);
 alignx(wam_start,[val_caption,val_path,val_compilecommand,val_compiledirectory,
                   val_runcommand,val_rundirectory,
                   val_comment,val_input,
                   val_expectedoutput,val_actualoutput,
                   val_expectederror,val_actualerror,
                   val_expectedexitcode],wam_start,1);
end;

procedure ttesteditfo.macrohintexe(const sender: TObject; var info: hintinfoty);
begin
 info.caption:= mainmo.expandmacros(
                        mainmo.edititem,tedit(sender).text,filemacro);
end;

procedure ttesteditfo.filemacrohintexe(const sender: TObject;
                                                 var info: hintinfoty);
begin
 info.caption:= mainmo.expandmacros(mainmo.edititem,filemacro,'');
end;

procedure ttesteditfo.compileresultchangeexe(const sender: TObject);
begin
 seterror(val_compileresult,
         val_compileresult.value <> 0);
end;

procedure ttesteditfo.outputputchangeexe(const sender: TObject);
begin
 seterror(val_actualoutput,
         val_expectedoutput.value <> 
                            removelineterminator(val_actualoutput.value));
end;

procedure ttesteditfo.errorchangeexe(const sender: TObject);
begin
 seterror(val_actualerror,
         val_expectederror.value <> 
                           removelineterminator(val_actualerror.value));
end;

procedure ttesteditfo.exitcodechangeexe(const sender: TObject);
begin
 seterror(val_actualexitcode,
         val_expectedexitcode.value <> val_actualexitcode.value);
end;

procedure ttesteditfo.inputerrorchangeexe(const sender: TObject);
begin
 seterror(val_inputerror,val_inputerror.value);
end;

function ttesteditfo.filemacro: msestring;
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

end.
