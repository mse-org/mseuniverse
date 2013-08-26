unit utabeditorform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,
 msesimplewidgets,msewidgets,msedataedits,mseedit,msegrids,mseificomp,
 mseificompglob,mseifiglob,msestrings,msetypes,msewidgetgrid,mseeditglob,
 msesyntaxedit,msetextedit,msedispwidgets,mserichstring,msetoolbar;
 

const
 pascaldelims = msestring(' :;+-*/(){},=<>' + c_linefeed + c_return + c_tab); 
 
type
 tutabeditorfo = class(ttabform)
   mygrid: twidgetgrid;
   simpletext: tsyntaxedit;
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
   procedure on_editor_close_query(const sender: tcustommseform;
                   var amodalresult: modalresultty);
                   
 public
   OpenFileName : msestring; 
 end;
 
var
 utabeditorfo: tutabeditorfo;
 
implementation

uses
 utabeditorform_mfm, udmaction, sysutils;
 
 
procedure tutabeditorfo.on_editnotif(const sender: TObject;
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
//Panel for copy-cut-paste need same modif  
{  ea_caretupdating: begin
    if (simpletext.hasselection) or (simpletext.canpaste) then begin
      pt1:= info.caretrect.pos;
      pt1.y:= pt1.y + info.caretrect.cy; //shift below the caret
      Flaintoolbar.pos:= translatewidgetpoint(pt1,twidget(sender),
                           //source origin = simpletext
                           Flaintoolbar.parentwidget);
      Flaintoolbar.visible := True;
    end else begin
      Flaintoolbar.visible := False;
    end;
  end;}
 end;
end;

procedure tutabeditorfo.on_txt_mouse(const sender: TObject;
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

procedure tutabeditorfo.on_editor_close_query(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
  if simpletext.modified then begin
   if askyesno('File changed. Save?') then
     udmactionmo.on_actsave_execute(self);
  end;
end;

end.
