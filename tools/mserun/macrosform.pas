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
unit macrosform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,
 msestrings,msewidgetgrid,sysutils,msesplitter,msesimplewidgets,msedialog,
 msememodialog,msegraphedits,msescrollbar;
type
 tmacrosfo = class(tmseform)
   tstatfile1: tstatfile;
   tlayouter1: tlayouter;
   okbu: tbutton;
   cancelbu: tbutton;
   tsimplewidget1: tsimplewidget;
   macrosplitter: tsplitter;
   macrogrid: twidgetgrid;
   e0: tbooleanedit;
   e1: tbooleanedit;
   e2: tbooleanedit;
   e3: tbooleanedit;
   e4: tbooleanedit;
   e5: tbooleanedit;
   val_macronames: tstringedit;
   val_macrovalues: tmemodialogedit;
   selectactivegroupgrid: twidgetgrid;
   activemacroselect: tbooleaneditradio;
   val_groupcomment: tstringedit;
   procedure acttiveselectondataentered(const sender: TObject);
   procedure selectactiveonrowsmoved(const sender: tcustomgrid;
       const fromindex: Integer; const toindex: Integer; const acount: Integer);
   procedure loadedexe(const sender: TObject);
   procedure closequeryexe(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure macrohintexe(const sender: TObject; var info: hintinfoty);
   procedure colhintexe(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
  protected
   fmacrogroup: int32;
   procedure activegroupchanged();
   procedure macrohint(const avalue: msestring; var info: hintinfoty);
 end;
 
implementation
uses
 macrosform_mfm,mainmodule,msearrayutils,msemacros,msebits;

procedure tmacrosfo.activegroupchanged();
var
 int1,int2: integer;
begin
 int2:= 0;
 for int1:= 0 to selectactivegroupgrid.rowcount-1 do begin
  if activemacroselect[int1] then begin
   int2:= int1;
   break;
  end;
 end;
 for int1:= 0 to 5 do begin
  if int1 = int2 then begin
   macrogrid.datacols[int1].color:= cl_infobackground;
  end
  else begin
   macrogrid.datacols[int1].color:= cl_default;
  end;
 end;
 fmacrogroup:= int2;
// mainmo.projectoptions.macrogroup:= int2;
end;

procedure tmacrosfo.selectactiveonrowsmoved(const sender: tcustomgrid;
       const fromindex: Integer; const toindex: Integer; const acount: Integer);
var
 ar1: array of longboolarty;
 int1: integer;
begin
 setlength(ar1,selectactivegroupgrid.rowcount);
 with macrogrid do begin
  beginupdate;
  for int1:= 0 to high(ar1) do begin
   ar1[int1]:= tbooleanedit(datacols[int1].editwidget).gridvalues;
  end;
  moveitem(pointerarty(ar1),fromindex,toindex);
  for int1:= 0 to high(ar1) do begin
   tbooleanedit(datacols[int1].editwidget).gridvalues:= ar1[int1];
  end;
  endupdate;
 end;
 activegroupchanged;
end;

procedure tmacrosfo.acttiveselectondataentered(const sender: TObject);
var
 int1: integer;
begin
 for int1:= 0 to selectactivegroupgrid.rowcount-1 do begin
  activemacroselect[int1]:= false;
 end;
 tbooleaneditradio(sender).value:= true;
 activegroupchanged;
end;

procedure tmacrosfo.loadedexe(const sender: TObject);
var
 int1: integer;
 ar1: integerarty;
begin
 with mainmo.projectoptions do begin
  ar1:= macroon;
  macrogrid.rowcount:= length(ar1);
  for int1:= 0 to high(ar1) do begin
   e0.gridvaluebitmask[int1]:= ar1[int1];
   {
   e0.gridupdatetagvalue(int1,ar1[int1]);
   e1.gridupdatetagvalue(int1,ar1[int1]);
   e2.gridupdatetagvalue(int1,ar1[int1]);
   e3.gridupdatetagvalue(int1,ar1[int1]);
   e4.gridupdatetagvalue(int1,ar1[int1]);
   e5.gridupdatetagvalue(int1,ar1[int1]);
   }
  end;
  activemacroselect[macrogroup]:= true;
  activegroupchanged();
 end;
end;

procedure tmacrosfo.closequeryexe(const sender: tcustommseform;
               var amodalresult: modalresultty);
var
 ar1: integerarty;
 int1: integer;
begin
 if amodalresult = mr_ok then begin
  setlength(ar1,macrogrid.datarowhigh+1);
  for int1:= 0 to high(ar1) do begin
   ar1[int1]:= e0.gridvaluebitmask[int1];
  {
   ar1[int1]:=  e0.gridvaluetag(int1,0) or e1.gridvaluetag(int1,0) or
                    e2.gridvaluetag(int1,0) or e3.gridvaluetag(int1,0) or
                    e4.gridvaluetag(int1,0) or e5.gridvaluetag(int1,0);
  }
  end;
  with mainmo.projectoptions do begin
   macroon:= ar1;
   macrogroup:= selectactivegroupgrid.row;
  end;
 end;
end;

procedure tmacrosfo.macrohint(const avalue: msestring; var info: hintinfoty);
var
 ar1,ar2: macroinfoarty;
 i1,i2: int32;
 ca1: card32;
begin
 ar1:= mainmo.macros.asarray;
 setlength(ar2,macrogrid.datarowhigh+1);
 ca1:= bits[fmacrogroup];
 i2:= 0;
 for i1:= 0 to high(ar2) do begin
  if e0.gridvaluebitmask[i1] and ca1 <> 0 then begin
   with ar2[i2] do begin
    name:= val_macronames[i1];
    value:= val_macrovalues[i1];
   end;
   inc(i2);
  end;
 end;
 setlength(ar2,i2);
 mainmo.macros.setasarray(ar2);
 info.caption:= mainmo.expandmacros(avalue);
 include(info.flags,hfl_show);
 mainmo.macros.setasarray(ar1); //restore
end;

procedure tmacrosfo.macrohintexe(const sender: TObject; var info: hintinfoty);
begin
 macrohint(tcustomedit(sender).text,info);
end;

procedure tmacrosfo.colhintexe(const sender: tdatacol; const arow: Integer;
               var info: hintinfoty);
begin
 macrohint(val_macrovalues[arow],info);
end;

end.
