unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms, msestrings,msetypes,
 msegrids,msewidgetgrid,msestream,msewidgets,sysutils,msedispwidgets,
 mseeditglob,msesyntaxedit,msetextedit,msesimplewidgets,msebitmap,
 msefiledialog,mselistbrowser,msesys,msegraphedits,msetoolbar,mseact,
 mseactions,msedataedits,mseedit;
 
const
 pascaldelims = msestring(' :;+-*/(){},=<>' + c_linefeed + c_return + c_tab); 

type
 tmainfo = class(tmainform)
   tpopupmenu1: tpopupmenu;
   timagelist1: timagelist;
   tfiledialog1: tfiledialog;
   actNew: tnoguiaction;
   actOpen: tnoguiaction;
   actSave: tnoguiaction;
   actUndo: tnoguiaction;
   actRedo: tnoguiaction;
   actCopy: tnoguiaction;
   actCut: tnoguiaction;
   actPaste: tnoguiaction;
   mygrid: twidgetgrid;
   simpletext: tsyntaxedit;
   actZoomIn: tnoguiaction;
   actZoomOut: tnoguiaction;
   ttoolbar2: ttoolbar;
   actSaveAs: tnoguiaction;
   actFind: tnoguiaction;
   tsimplewidget3: tsimplewidget;
   tsimplewidget2: tsimplewidget;
   dispRC: tstringdisp;
   dispInfo: tstringdisp;
   dispFilePath: tstringdisp;
   tsimplewidget1: tsimplewidget;
   tbutton1: tbutton;
   tbutton3: tbutton;
   btnShowInfo: tbutton;
   dispencode: tstringdisp;
   Flaintoolbar: ttoolbar;
   procedure on_editnotif(const sender: TObject;
                   var info: editnotificationinfoty);
   procedure on_txt_mouse(const sender: TObject;
                   var info: textmouseeventinfoty);
   procedure On_create_frm(const sender: TObject);
   procedure on_update(const sender: tcustommenu);
   procedure act_open(const sender: TObject);
   procedure act_new(const sender: TObject);
   procedure onSave_execute(const sender: TObject);
   procedure on_save_update(const sender: tcustomaction);
   procedure on_update_undo(const sender: tcustomaction);
   procedure on_undo_execute(const sender: TObject);
   procedure on_redo_execute(const sender: TObject);
   procedure on_redo_update(const sender: tcustomaction);
   procedure on_copy_execute(const sender: TObject);
   procedure on_copy_update(const sender: tcustomaction);
   procedure on_cut_execute(const sender: TObject);
   procedure on_paste_execute(const sender: TObject);
   procedure on_paste_update(const sender: tcustomaction);
   procedure showinfo;
   procedure MakeNew;
   procedure on_clos_query(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure on_Zoom_in(const sender: tcustomaction);
   procedure on_Zoom_out(const sender: tcustomaction);
   procedure on_Zoom_execute(const sender: TObject);
   procedure on_Zoom_out_execute(const sender: TObject);
   procedure on_save_as_execute(const sender: TObject);
   procedure on_save_as_update(const sender: tcustomaction);
   procedure on_set_value(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure on_Scrol_grid_row(const sender: tcustomgrid; var step: Integer);
   procedure on_focus_grid(const sender: TObject);
   procedure on_btnsi_execute(const sender: TObject);
///
   procedure charcount(aStroka : msestring);   
   procedure charcount1(aStroka : msestring);
   procedure on_find_execute(const sender: TObject);
 end;
var
 mainfo: tmainfo;
 EditFileName : msestring;
 
implementation

uses
 main_mfm, msegridsglob, msekeyboard, ufrmcharinfo, Classes;
 

procedure tmainfo.on_save_as_execute(const sender: TObject);
begin
  tfiledialog1.dialogkind := fdk_save;
  if tfiledialog1.execute = mr_ok then begin
    simpletext.savetofile(tfiledialog1.controller.filename);
    EditFileName := tfiledialog1.controller.filename;
    showinfo;
  end else begin
    Exit;
  end;
end;

procedure tmainfo.on_save_as_update(const sender: tcustomaction);
begin
{  if (length(simpletext.gettext) >= 0) and (simpletext.modified) then
    actSaveAs.state := actSaveAs.state - [as_disabled]
    else
      actSaveAs.state := actSaveAs.state + [as_disabled];  }
end; 
 
procedure tmainfo.onSave_execute(const sender: TObject);
begin
  if Length(EditFileName) > 0 then begin
    simpletext.Savetofile(EditFileName);
    showinfo;
  end else begin
    tfiledialog1.dialogkind := fdk_save;
    if tfiledialog1.execute = mr_ok then begin
      simpletext.savetofile(tfiledialog1.controller.filename);
      EditFileName := tfiledialog1.controller.filename;
      showinfo;
    end else begin
      Exit;
    end;
  end;
end; 
 
procedure tmainfo.on_save_update(const sender: tcustomaction);
var
  EditChange, EditnotChange : msestring; //not need but :)
begin
  EditChange := 'Change';
  EditnotChange := 'Not change';
  actSave.enabled := simpletext.modified;
  if simpletext.modified then begin
    dispInfo.value := EditChange;
  end else begin
    dispInfo.value := EditnotChange;  
  end;
end;

///Start standart actions

procedure tmainfo.on_update_undo(const sender: tcustomaction);
begin
  actUndo.enabled := simpletext.canundo;
end;

procedure tmainfo.on_undo_execute(const sender: TObject);
begin
  simpletext.undo;
end;

procedure tmainfo.on_redo_update(const sender: tcustomaction);
begin
  if simpletext.canredo then
    actRedo.enabled := simpletext.canredo;
end;

procedure tmainfo.on_redo_execute(const sender: TObject);
begin
  simpletext.redo;
end;


procedure tmainfo.on_copy_update(const sender: tcustomaction);
begin
  actCopy.enabled := simpletext.hasselection;
  actCut.enabled := simpletext.hasselection;
end;

procedure tmainfo.on_copy_execute(const sender: TObject);
begin
  simpletext.copyselection;
end;

procedure tmainfo.on_cut_execute(const sender: TObject);
begin
  simpletext.cutselection;
end;

procedure tmainfo.on_paste_execute(const sender: TObject);
begin
  simpletext.paste;
end;

procedure tmainfo.on_paste_update(const sender: tcustomaction);
begin
  actPaste.enabled := simpletext.canpaste;
end;

///End standart actions

procedure tmainfo.on_editnotif(const sender: TObject;
               var info: editnotificationinfoty);
var
  Pos_X, Pos_Y : integer; //not need but :) 
  pt1: pointty;              
begin
 case info.action of
  ea_indexmoved: begin
    Pos_X := simpletext.editpos.row+1;
    Pos_Y := simpletext.editpos.col; //+1;
    dispRC.value:= 'Row: ' + inttostr(Pos_X) + ':'+ ' Col: ' + inttostr(Pos_Y);
  end;
  ea_caretupdating: begin
//Panel for copy-cut-paste need sme modif
    if (simpletext.hasselection) or (simpletext.canpaste) then begin
      pt1:= info.caretrect.pos;
      pt1.y:= pt1.y + info.caretrect.cy; //shift below the caret
      Flaintoolbar.pos:= translatewidgetpoint(pt1,twidget(sender),
                           //source origin = simpletext
                           Flaintoolbar.parentwidget);
//                                 (twidget(sender).parentwidget).parentwidget);    
                           //dest origin = simpletext.parentwidget 
      Flaintoolbar.visible := True;
    end else begin
      Flaintoolbar.visible := False;
    end;
  end;
 end;
end;

procedure tmainfo.on_txt_mouse(const sender: TObject;
               var info: textmouseeventinfoty); 
var
 RHelpRect: rectty;                            
begin
//interesting procedure :)
//   simpletext.showlink(info.pos,pascaldelims + '.[]');
//double-click in editor
 if simpletext.isdblclicked(info.mouseeventinfopo^) then begin
    if ss_triple in info.mouseeventinfopo^.shiftstate then begin
     simpletext.setselection(makegridcoord(0,simpletext.row), makegridcoord(bigint,simpletext.row),true)
      end else begin
       simpletext.selectword(info.pos,pascaldelims+'.[]');
    end;
   include(info.mouseeventinfopo^.eventstate,es_processed);
  end;
end;

procedure tmainfo.MakeNew;
begin
  simpletext.clear;
  mainfo.caption := 'New.txt';
  dispFilePath.value := '--';
  EditFileName := '';
end; 

procedure tmainfo.On_create_frm(const sender: TObject);
begin
  MakeNew;
end;


procedure tmainfo.on_update(const sender: tcustommenu);
begin
  sender.menu[0].caption := simpletext.selectedtext;
end;

procedure tmainfo.act_open(const sender: TObject);
begin
  if simpletext.modified then begin
   if askyesno('File changed. Save?') then begin
    if Length(EditFileName) > 0 then begin
      simpletext.Savetofile(EditFileName);
      showinfo;
    end else begin
      tfiledialog1.dialogkind := fdk_open;
      if tfiledialog1.execute = mr_ok then begin
        simpletext.savetofile(tfiledialog1.controller.filename);
        EditFileName := tfiledialog1.controller.filename;
        showinfo;
      end else begin
        Exit;
      end;
    end;
   end;
  end;
  
  if tfiledialog1.execute = mr_ok then begin
    simpletext.loadfromfile(tfiledialog1.controller.filename);
    EditFileName := tfiledialog1.controller.filename;
    showinfo;   
  end;  
end;

procedure tmainfo.act_new(const sender: TObject);
begin
  if simpletext.modified then begin
   if askyesno('File changed. Save?') then begin
    if Length(EditFileName) > 0 then begin
      simpletext.Savetofile(EditFileName);
      showinfo;
    end else begin
      tfiledialog1.dialogkind := fdk_save;
      if tfiledialog1.execute = mr_ok then begin
        simpletext.savetofile(tfiledialog1.controller.filename);
        EditFileName := tfiledialog1.controller.filename;
        showinfo;
      end else begin
        Exit;
      end;
    end;
   end;
  end;
  MakeNew;
end;

procedure tmainfo.showinfo;
begin
// use sysutils.pas
  mainfo.caption := ExtractFileName(EditFileName);
  dispFilePath.value := ExtractFileDir(EditFileName);  
end;


procedure tmainfo.on_clos_query(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
  if simpletext.modified then begin
   if askyesno('File changed. Save?') then begin
      onSave_execute(self);
    end;
  end;
end;

procedure tmainfo.on_Zoom_in(const sender: tcustomaction);
begin
  if simpletext.font.height = 30 then
    actZoomIn.enabled := False
      else actZoomIn.enabled := True;
end;

procedure tmainfo.on_Zoom_execute(const sender: TObject);
begin
  simpletext.font.height := simpletext.font.height + 1;
end;

procedure tmainfo.on_Zoom_out(const sender: tcustomaction);
begin
  if simpletext.font.height = 12 then
    actZoomOut.enabled := False
      else actZoomOut.enabled := True;
end;

procedure tmainfo.on_Zoom_out_execute(const sender: TObject);
begin
  simpletext.font.height := simpletext.font.height - 1;
end;


procedure tmainfo.on_set_value(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
//  tintegerdisp1.value := avalue;
end;


procedure tmainfo.on_Scrol_grid_row(const sender: tcustomgrid;
               var step: Integer);
begin
  Flaintoolbar.visible := False;
end;

procedure tmainfo.on_focus_grid(const sender: TObject);
begin
{ if (simpletext.hasselection) or (simpletext.canpaste) then
   Flaintoolbar.visible := True;}
end;

/////////////// Need change (Same error) 
procedure tmainfo.charcount(aStroka : msestring);
var
  i, l, n, zz, zzz: Integer;
const
  WordDelim = ' !,.?:;%*"“”-+<>&$#~|=\/1234567890';  
begin
  l := 0;
  n := 0;
  zz := 0;
  zzz := 0;


  zzz := length(aStroka);

  For i := 1 to Length(aStroka) do begin
    If   aStroka[i] <> ' ' then zz := zz+1;
    if msePosEx(aStroka[i], WordDelim) = 0 then begin
      l := l + 1;
    end else begin
        If l <> 0 then begin
          l := 0;
          n := n + 1;
        end;
    end;
  end;

  With ufrmcharinfofo do begin
    tintegeredit2[0] := n;
    tintegeredit2[1] := zzz;    
    tintegeredit2[2] := zz;    
  end;
end;

procedure tmainfo.charcount1(aStroka : msestring);
var
  i, l, n, zz, zzz: Integer;
const
  WordDelim = ' !,.?:;%*"“”-+<>&$#~|=\/1234567890';  
begin
  l := 0;
  n := 0;
  zz := 0;
  zzz := 0;

  zzz := length(aStroka);
  For i := 1 to Length(aStroka) do begin
    If   aStroka[i] <> ' ' then zz := zz+1;
    if msePosEx(aStroka[i], WordDelim) = 0 then begin
      l := l + 1;
    end else begin
        If l <> 0 then begin
          l := 0;
          n := n + 1;
        end;
    end;
  end;
  With ufrmcharinfofo do begin
    tintegeredit1[0] := n;
    tintegeredit1[1] := zzz;    
    tintegeredit1[2] := zz;    
  end;
end;


procedure tmainfo.on_btnsi_execute(const sender: TObject);
var
  myList : TStrings;
  z : integer;
  stroka, selstroka : msestring;
begin
  if Length(simpletext[0]) = 0 then exit;
  if not Assigned(ufrmcharinfofo) then
    application.createform(tufrmcharinfofo,ufrmcharinfofo)
    else ufrmcharinfofo.show; 
///
  for z := 0 to mygrid.rowcount -1 do begin
    stroka := stroka + simpletext[z] ;
  end;  
  if (simpletext.hasselection) and (length(simpletext.selectedtext) > 0) then charcount1(simpletext.selectedtext);
  charcount(stroka);  

end;

procedure tmainfo.on_find_execute(const sender: TObject);
begin
//realizing after charinfo 
end;


end.
