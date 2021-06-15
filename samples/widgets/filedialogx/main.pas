unit main;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface

uses
 msetypes, mseglob, mseguiglob, mseguiintf, mseapplication, msestat, msemenus,
 msegui, msegraphics, msegraphutils, mseevent, mseclasses, msewidgets, mseforms,
 mseimage, msebitmap, mseformatbmpicoread, mseformatjpgread, mseformatpngread,
 mseformatpnmread, mseformattgaread, mseformatxpmread, msekeyboard, mseact,
 msedataedits, msedatanodes, msedragglob, msedropdownlist, mseedit,msegrids,
  msegridsglob, mseificomp, mseificompglob, mseifiglob,mselistbrowser,
 msestatfile, msestream, msesys, msesimplewidgets,sysutils,classes, math,
  msefiledialogx,msedispwidgets, mserichstring, msegraphedits,
 msescrollbar, msecolordialog;

type
  tmainfo = class(tmainform)
    tbutton1: TButton;
    tstringdisp1: tstringdisp;
    tgroupbox1: tgroupbox;
    b_fdk_open: tbooleaneditradio;
    b_fdk_save: tbooleaneditradio;
    b_fdk_dir: tbooleaneditradio;
    b_fdk_none: tbooleaneditradio;
    b_fdk_new: tbooleaneditradio;
    thefilter: tstringedit;
    thetitle: tstringedit;
    custtitle: tbooleanedit;
    thebasedir: tstringedit;
    fontname: tdropdownlistedit;
    fontheight: tintegeredit;
    tbutton2: TButton;
    tbackcolor: tcoloredit;
    tfontcolor: tcoloredit;
    tfiledialogx1: tfiledialogx;
    tfilenameeditx1: tfilenameeditx;
   bshowoptions: tbooleanedit;
   tstatfile1: tstatfile;
   bhidehistory: tbooleanedit;
   bshowhidden: tbooleanedit;
   bhideicons: tbooleanedit;
   bcompact: tbooleanedit;
   
    procedure onex(const Sender: TObject);
   procedure onclose(const sender: TObject);
    end;

var
  mainfo: tmainfo;

implementation

uses
  main_mfm;

procedure tmainfo.onex(const Sender: TObject);
var
  dialogkind: filedialogkindty;
  ara, arb: msestringarty;
begin

  tfiledialogx1.controller.options := [];
 
  if b_fdk_open.Value then
    dialogkind := fdk_open
  else if b_fdk_save.Value then
    dialogkind := fdk_save
  else if b_fdk_dir.Value then
  begin
   tfiledialogx1.controller.options := [fdo_directory];
   end
  else if b_fdk_none.Value then 
    dialogkind := fdk_none
  else if b_fdk_new.Value then
    dialogkind := fdk_new;
    
    

  tfiledialogx1.controller.captionnew  := 'New File';
  tfiledialogx1.controller.captionopen := 'Open File';
  tfiledialogx1.controller.captionsave := 'Save File as';
  tfiledialogx1.controller.captiondir  := 'Open Directory';
  
  if bhidehistory.value then
   tfiledialogx1.controller.hidehistory  := true else
  tfiledialogx1.controller.hidehistory  := false;
  
  if bshowoptions.value then
  tfiledialogx1.controller.showoptions  := true else
  tfiledialogx1.controller.showoptions  := false;
  
  if bshowhidden.value then
  tfiledialogx1.controller.showhidden  := true else
  tfiledialogx1.controller.showhidden  := false;
  
  if bhideicons.value then
  tfiledialogx1.controller.hideicons  := true else
  tfiledialogx1.controller.hideicons  := false;
  
  if bcompact.value then
  tfiledialogx1.controller.compact  := true else
  tfiledialogx1.controller.compact  := false;
  
  setlength(ara, 5);
  setlength(arb, 5);

  ara[0] := 'All';
  ara[1] := 'Pascal';
  ara[2] := 'C';
  ara[3] := 'Java';
  ara[4] := 'Python';
  
  arb[0] := '"*.*"';
  arb[1] := '"*.pp" "*.pas" "*.inc" "*.dpr" "*.lpr"';
  arb[2] := '"*.c" "*.cpp" "*.h"';
  arb[3] := '"*.java"';
  arb[4] := '"*.py"';
 
  tfiledialogx1.controller.filterlist.asarraya := ara;
  tfiledialogx1.controller.filterlist.asarrayb := arb;

  tfiledialogx1.controller.filter := thefilter.Value;

  tfiledialogx1.controller.filename := thebasedir.Value;

  if fontheight.Value <> 0 then
    tfiledialogx1.controller.fontheight := fontheight.Value; // font height of dialogfile

  tfiledialogx1.controller.fontname := fontname.Value;       // font name of dialogfile

  tfiledialogx1.controller.fontcolor := tfontcolor.Value;    // font color of dialogfile

  tfiledialogx1.controller.backcolor := tbackcolor.Value;    // background color of dialogfile

  if custtitle.Value then
  begin
    if tfiledialogx1.controller.Execute(dialogkind, thetitle.Value) = mr_ok then
      tstringdisp1.Text := (tfiledialogx1.controller.filename);
  end
  else if tfiledialogx1.controller.Execute(dialogkind) = mr_ok then
    tstringdisp1.Text := (tfiledialogx1.controller.filename);

end;

procedure tmainfo.onclose(const sender: TObject);
begin
close;
end;

end.

