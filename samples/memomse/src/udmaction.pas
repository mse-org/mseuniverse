unit udmaction;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,mseact,mseificomp,
 mseificompglob,mseifiglob,msebitmap,msedragglob,msegraphutils,msegui,
 mseguiglob,msemenus,msescrollbar,msestat,msestatfile,msestream,msestrings,
 msetabs,msewidgets,sysutils,msedataedits,msedatanodes,mseedit,msefiledialog,
 msegraphics,msegrids,mselistbrowser,msesys,msetypes, utabeditorform;

type
 tudmactionmo = class(tmsedatamodule)
   actZoomOut: tnoguiaction;
   actZoomIn: tnoguiaction;
   actFind: tnoguiaction;
   actPaste: tnoguiaction;
   actCut: tnoguiaction;
   actCopy: tnoguiaction;
   actRedo: tnoguiaction;
   actUndo: tnoguiaction;
   actSaveAs: tnoguiaction;
   actSave: tnoguiaction;
   actOpen: tnoguiaction;
   actNew: tnoguiaction;
   timagelist1: timagelist;
   openfiledialog: tfiledialog;
   actclosePage: tnoguiaction;
   procedure on_act_new_execute(const sender: TObject);
   
   procedure on_act_open_execute(const sender: TObject);
   procedure on_actsave_execute(const sender: TObject);
   procedure on_actsave_update(const sender: tcustomaction);
   procedure on_actsaveas_execute(const sender: TObject);
   procedure on_actUndo_execute(const sender: TObject);
   procedure on_actundo_update(const sender: tcustomaction);
   procedure on_actredo_execute(const sender: TObject);
   procedure on_actredo_update(const sender: tcustomaction);
   procedure on_actcopy_execute(const sender: TObject);
   procedure on_actcopy_update(const sender: tcustomaction);
   procedure on_actcut_execute(const sender: TObject);
   procedure on_actpaste_execute(const sender: TObject);
   procedure on_actpaste_update(const sender: tcustomaction);
   procedure on_actzoomin_execute(const sender: TObject);
   procedure on_actzoomin_update(const sender: tcustomaction);
   procedure on_actzoomout_execute(const sender: TObject);
   procedure on_actzoomout_update(const sender: tcustomaction);
   procedure on_actsaveas_update(const sender: tcustomaction);
   procedure on_actclosepage_update(const sender: tcustomaction);
   procedure on_actclosepage_execute(const sender: TObject);
 public
   procedure openfile(OFN : msestring);   
   procedure makenew;   
 end;
 
type
 teditorpage1 = class(tutabeditorfo); 
 
var
 udmactionmo: tudmactionmo;
 page: teditorpage1;
  
implementation

uses
 udmaction_mfm, main; //not good
 
procedure tudmactionmo.makenew;
begin
  on_act_new_execute(self);
end; 
 
 
procedure tudmactionmo.openfile(OFN : msestring);
var
  editorfrmOpen : tutabeditorfo;
  iopen : integer;
begin
  editorfrmOpen := tutabeditorfo.create(nil);
  try
   iopen := mainfo.ttabwidget1.activepageindex+1;
   mainfo.ttabwidget1.add(editorfrmOpen, iopen);
   editorfrmOpen.caption := ExtractFileName(OFN);
   editorfrmOpen.dispFilePath.value := ExtractFileDir(OFN);
   editorfrmOpen.simpletext.loadfromfile(OFN);
   editorfrmOpen.OpenFileName := OFN;
   OFN := '';
  except
   editorfrmOpen.Free;
   editorfrmOpen := nil;
   application.handleexception(self);
  end;    
end;


procedure tudmactionmo.on_act_new_execute(const sender: TObject);
var
  editorfrmNew : tutabeditorfo;
  i : integer;
begin
 editorfrmNew := tutabeditorfo.create(nil);
 try
  i := mainfo.ttabwidget1.activepageindex+1;
  mainfo.ttabwidget1.add(editorfrmNew, i);
  if i = 0 then
    editorfrmNew.caption := 'New' + '.txt'
      else
        editorfrmNew.caption := 'New' + inttostr(i) + '.txt';
 except
  editorfrmNew.Free;
  editorfrmNew := nil;
  application.handleexception(self);
 end;
end;

procedure tudmactionmo.on_act_open_execute(const sender: TObject);
var
  editorfrmOpen : tutabeditorfo;
  iopen : integer;
  EditFileName : msestring;
begin
  EditFileName := '';
  openfiledialog.dialogkind := fdk_open;
  if openfiledialog.execute = mr_ok then begin
    editorfrmOpen := tutabeditorfo.create(nil);
    try
     EditFileName := openfiledialog.controller.filename;
     iopen := mainfo.ttabwidget1.activepageindex+1;
     mainfo.ttabwidget1.add(editorfrmOpen, iopen);
     editorfrmOpen.caption := ExtractFileName(EditFileName);
     editorfrmOpen.dispFilePath.value := ExtractFileDir(EditFileName);
     editorfrmOpen.simpletext.loadfromfile(EditFileName);
     editorfrmOpen.OpenFileName := EditFileName;
     EditFileName := '';
    except
     editorfrmOpen.Free;
     editorfrmOpen := nil;
     application.handleexception(self);
    end;    
  end else begin
    Exit;
  end;
end;

procedure tudmactionmo.on_actsave_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    if Length(page.OpenFileName) > 0 then begin
      page.simpletext.Savetofile(page.OpenFileName);
    end else begin
      openfiledialog.dialogkind := fdk_save;
      if openfiledialog.execute = mr_ok then begin
        page.simpletext.savetofile(openfiledialog.controller.filename);
        page.caption := ExtractFileName(openfiledialog.controller.filename);
        page.dispFilePath.value := ExtractFileDir(openfiledialog.controller.filename);
      end else begin
        Exit;
      end;
    end;
  end;
end;

procedure tudmactionmo.on_actsave_update(const sender: tcustomaction);
var
// page: teditorpage1;
 EditChange, EditnotChange : msestring;
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    EditChange := 'Change';
    EditnotChange := 'Not change';
    actSave.enabled := page.simpletext.modified;
    case page.simpletext.modified of
      True : page.dispInfo.value := EditChange;
      False : page.dispInfo.value := EditnotChange;
    end;
  end else begin
    actSave.enabled := False;
  end;
end;

procedure tudmactionmo.on_actsaveas_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    actSaveAs.enabled := True
      else
        actSaveAs.enabled := False;
end;

procedure tudmactionmo.on_actsaveas_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    openfiledialog.dialogkind := fdk_save;
    if openfiledialog.execute = mr_ok then begin
      page.simpletext.savetofile(openfiledialog.controller.filename);
      page.caption := ExtractFileName(openfiledialog.controller.filename);
      page.dispFilePath.value := ExtractFileDir(openfiledialog.controller.filename);
    end else begin
      Exit;
    end;
  end;
end;

procedure tudmactionmo.on_actUndo_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    page.simpletext.undo;
end;

procedure tudmactionmo.on_actundo_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    if page.simpletext.canundo then
      actUndo.enabled := true
      else
        actUndo.enabled := False;
  end;
end;

procedure tudmactionmo.on_actredo_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    page.simpletext.redo;
end;

procedure tudmactionmo.on_actredo_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    actUndo.enabled := page.simpletext.canredo
      else
        actUndo.enabled := False;
end;

procedure tudmactionmo.on_actcopy_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    page.simpletext.copyselection;
end;

procedure tudmactionmo.on_actcut_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    page.simpletext.cutselection;
end;

procedure tudmactionmo.on_actcopy_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    actCopy.enabled := page.simpletext.hasselection;
    actCut.enabled := page.simpletext.hasselection; 
  end else begin
    actCopy.enabled := False;
    actCut.enabled := False;        
  end;
end;

procedure tudmactionmo.on_actpaste_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    page.simpletext.paste;
end;

procedure tudmactionmo.on_actpaste_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    actPaste.enabled := page.simpletext.canpaste
      else
        actUndo.enabled := False;
end;

procedure tudmactionmo.on_actzoomin_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    page.simpletext.font.height := page.simpletext.font.height + 1;
end;

procedure tudmactionmo.on_actzoomin_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    if page.simpletext.font.height = 30 then
      actZoomIn.enabled := False
        else actZoomIn.enabled := True;
  end;
end;

procedure tudmactionmo.on_actzoomout_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then
    page.simpletext.font.height := page.simpletext.font.height - 1;
end;

procedure tudmactionmo.on_actzoomout_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    if page.simpletext.font.height = 12 then
      actZoomOut.enabled := False
        else actZoomOut.enabled := True;
  end;
end;

procedure tudmactionmo.on_actclosepage_update(const sender: tcustomaction);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    actclosePage.enabled := True
  end else begin
    makenew;
//    actclosePage.enabled := False;
  end;
end;

procedure tudmactionmo.on_actclosepage_execute(const sender: TObject);
{var
 page: teditorpage1;}
begin
  page:= teditorpage1(mainfo.ttabwidget1.activepage);
  if page <> nil then begin
    page.close;
    page.Free;
  end;
end;

end.
