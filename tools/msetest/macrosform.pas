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
  protected
   procedure activegroupchanged();
 end;
 
implementation
uses
 macrosform_mfm,mainmodule,msearrayutils;

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
 mainmo.projectoptions.macrogroup:= int2;
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
   e0.gridupdatetagvalue(int1,ar1[int1]);
   e1.gridupdatetagvalue(int1,ar1[int1]);
   e2.gridupdatetagvalue(int1,ar1[int1]);
   e3.gridupdatetagvalue(int1,ar1[int1]);
   e4.gridupdatetagvalue(int1,ar1[int1]);
   e5.gridupdatetagvalue(int1,ar1[int1]);
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
   ar1[int1]:=  e0.gridvaluetag(int1,0) or e1.gridvaluetag(int1,0) or
                    e2.gridvaluetag(int1,0) or e3.gridvaluetag(int1,0) or
                    e4.gridvaluetag(int1,0) or e5.gridvaluetag(int1,0);
  end;
  with mainmo.projectoptions do begin
   macroon:= ar1;
   macrogroup:= selectactivegroupgrid.row;
  end;
 end;
end;

end.
