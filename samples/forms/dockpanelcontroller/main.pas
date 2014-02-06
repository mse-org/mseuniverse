unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedock,
 msedragglob,msedockpanelform,msestrings,mseact,mseactions,mseificomp,
 mseificompglob,mseifiglob,msestatfile,msesimplewidgets,msestream;

type
 tmainfo = class(tdockform)
   mainmen: tmainmenu;
   panelcontroller: tdockpanelformcontroller;
   showaact: taction;
   showbact: taction;
   showcact: taction;
   showdact: taction;
   showeact: taction;
   mainsta: tstatfile;
   procedure exitexe(const sender: TObject);
   procedure newpanelexe(const sender: TObject);
   procedure showaexe(const sender: TObject);
   procedure showbexe(const sender: TObject);
   procedure showcexe(const sender: TObject);
   procedure showdexe(const sender: TObject);
   procedure showeexe(const sender: TObject);
   procedure helpexe(const sender: TObject);
   procedure statmissingexe(const sender: tstatfile; const afilename: msestring;
                   var astream: ttextstream; var aretry: Boolean);
   procedure resetleayoutexe(const sender: TObject);
   procedure designtimeexe(const sender: TObject);
   procedure asynceventex(const sender: TObject; var atag: Integer);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,aform,bform,cform,dform,eform,msefileutils;
 
procedure tmainfo.exitexe(const sender: TObject);
begin
 application.terminated:= true;
end;

procedure tmainfo.newpanelexe(const sender: TObject);
begin
 panelcontroller.newpanel.activate;
end;

procedure tmainfo.showaexe(const sender: TObject);
begin
 afo.activate;
end;

procedure tmainfo.showbexe(const sender: TObject);
begin
 bfo.activate;
end;

procedure tmainfo.showcexe(const sender: TObject);
begin
 cfo.activate;
end;

procedure tmainfo.showdexe(const sender: TObject);
begin
 dfo.activate;
end;

procedure tmainfo.showeexe(const sender: TObject);
begin
 efo.activate;
end;

procedure tmainfo.helpexe(const sender: TObject);
begin
 showmessage('Click on top-right small circle button in order to'+lineend+
              'show/hide the grip frames.');
end;

procedure tmainfo.resetleayoutexe(const sender: TObject);
begin
 trydeletefile(mainsta.filename);
 mainsta.readstat();
end;

procedure tmainfo.asynceventex(const sender: TObject; var atag: Integer);
begin
 if atag = 1 then begin
  afo.parentwidget:= nil;
  bfo.parentwidget:= nil;
  cfo.parentwidget:= nil;
  dfo.parentwidget:= nil;
  efo.parentwidget:= nil;
  panelcontroller.removepanels;
  reloadmodules();
  show;
  afo.show;
  bfo.show;
  cfo.show;
  dfo.show;
  efo.show;
 end;
end;

procedure tmainfo.designtimeexe(const sender: TObject);
begin
 asyncevent(1);
end;

procedure tmainfo.statmissingexe(const sender: tstatfile;
               const afilename: msestring; var astream: ttextstream;
               var aretry: Boolean);
begin
 astream:= ttextstringcopystream.create(  
         //default layout, text made by pasting the text of the *.sta file
         //and RightClick-'Convert to Pascal string'

'[mainfo.panelcontroller]'+lineend+
'panels=2'+lineend+
' panel3'+lineend+
' panel4'+lineend+
'[mainfo]'+lineend+
'splitdir=2'+lineend+
'useroptions=15747'+lineend+
'stackedunder='+lineend+
'parent='+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=289'+lineend+
'y=141'+lineend+
'cx=444'+lineend+
'cy=366'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'wsize=0'+lineend+
'active=1'+lineend+
'visible=1'+lineend+
'[efo]'+lineend+
'splitdir=0'+lineend+
'useroptions=16507'+lineend+
'parent=mainfo.panelcontroller.panel3.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=208'+lineend+
'cy=158'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[dfo]'+lineend+
'splitdir=0'+lineend+
'useroptions=16507'+lineend+
'parent=mainfo.panelcontroller.panel3.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=208'+lineend+
'cy=158'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[cfo]'+lineend+
'splitdir=0'+lineend+
'useroptions=16507'+lineend+
'parent=mainfo.panelcontroller.panel4.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=209'+lineend+
'cy=186'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[bfo]'+lineend+
'splitdir=0'+lineend+
'useroptions=16507'+lineend+
'parent=mainfo.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=2'+lineend+
'y=47'+lineend+
'cx=430'+lineend+
'cy=112'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[afo]'+lineend+
'splitdir=0'+lineend+
'useroptions=49275'+lineend+
'parent=mainfo.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=2'+lineend+
'y=2'+lineend+
'cx=430'+lineend+
'cy=42'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[mainfo.panelcontroller.panel3]'+lineend+
'splitdir=3'+lineend+
'useroptions=32239'+lineend+
'order=2'+lineend+
' dfo'+lineend+
' efo'+lineend+
'activetab=0'+lineend+
'parent=mainfo.panelcontroller.panel4.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=212'+lineend+
'y=0'+lineend+
'cx=208'+lineend+
'cy=186'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'children=1'+lineend+
' ,0,0,208,176'+lineend+
'focusedchild=0'+lineend+
'[mainfo.panelcontroller.panel4]'+lineend+
'splitdir=1'+lineend+
'useroptions=32239'+lineend+
'parent=mainfo.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=2'+lineend+
'y=162'+lineend+
'cx=430'+lineend+
'cy=186'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'children=2'+lineend+
' cfo,0,0,209,186'+lineend+
' panel3,212,0,208,186'+lineend+
'focusedchild=1'+lineend+
'');
         
end;

end.
