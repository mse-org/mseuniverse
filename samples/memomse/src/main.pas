unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms, msestrings,
 msetypes,msegrids,msewidgetgrid,msestream,msewidgets,sysutils,msedispwidgets,
 mseeditglob,msesyntaxedit,msetextedit,msesimplewidgets,msebitmap,msedatanodes,
 msefiledialog,mselistbrowser,msesys,msegraphedits,msetoolbar,mseact,mseactions,
 msecolordialog,mseificomp,mseificompglob,mseifiglob;
 
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
   ttoolbar1: ttoolbar;
   tgroupbox1: tgroupbox;
   tstringdisp1: tstringdisp;
   tstringdisp2: tstringdisp;
   tstringdisp3: tstringdisp;
   simpletext: tsyntaxedit;
   actZoomIn: tnoguiaction;
   actZoomOut: tnoguiaction;
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
   procedure on_cut_update(const sender: tcustomaction);
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
 end;
var
 mainfo: tmainfo;
 EditFileName : msestring;
 
implementation

uses
 main_mfm, msegridsglob;
 
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
    tstringdisp2.value := EditChange;
  end else begin
    tstringdisp2.value := EditnotChange;  
  end;
end;

///Start standart actions

procedure tmainfo.on_update_undo(const sender: tcustomaction);
begin
  actUndo.enabled := simpletext.canundo;
//or
{  if simpletext.canundo then
    actUndo.state := actUndo.state - [as_disabled]
    else
      actUndo.state := actUndo.state + [as_disabled];}
end;

procedure tmainfo.on_undo_execute(const sender: TObject);
begin
  simpletext.undo;
end;

procedure tmainfo.on_redo_update(const sender: tcustomaction);
begin
  if simpletext.canredo then
    actRedo.state := actRedo.state - [as_disabled]
    else
      actRedo.state := actRedo.state + [as_disabled];
end;

procedure tmainfo.on_redo_execute(const sender: TObject);
begin
  simpletext.redo;
end;


procedure tmainfo.on_copy_update(const sender: tcustomaction);
begin
  actCopy.enabled := simpletext.hasselection;
  actCut.enabled := simpletext.hasselection;
//or  
{  if simpletext.hasselection then
    actCopy.state := actCopy.state - [as_disabled]
    else
      actCopy.state := actCopy.state + [as_disabled];}  
end;

procedure tmainfo.on_copy_execute(const sender: TObject);
begin
  simpletext.copyselection;
end;

procedure tmainfo.on_cut_update(const sender: tcustomaction);
begin
//not need. all do on_copy_update.
//  actCut.enabled := simpletext.hasselection;
//or
{  if simpletext.hasselection then
    actCut.state := actCut.state - [as_disabled]
    else
      actCut.state := actCut.state + [as_disabled];}
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
//or
{  if simpletext.canpaste then
    actPaste.state := actPaste.state - [as_disabled]
    else
      actPaste.state := actPaste.state + [as_disabled];}
end;

///End standart actions

procedure tmainfo.on_editnotif(const sender: TObject;
               var info: editnotificationinfoty);
var
  Pos_X, Pos_Y : integer; //not need but :)               
begin
 if info.action = ea_indexmoved then begin
   Pos_X := simpletext.editpos.row+1;
   Pos_Y := simpletext.editpos.col+1;
   tstringdisp1.value:= 'Row: ' + inttostr(Pos_X) + ':'+ ' Col: ' + inttostr(Pos_Y);
 end;
end;

procedure tmainfo.on_txt_mouse(const sender: TObject;
               var info: textmouseeventinfoty);
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
  tstringdisp3.value := '--';
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
  tstringdisp3.value := ExtractFileDir(EditFileName);  
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

end.
