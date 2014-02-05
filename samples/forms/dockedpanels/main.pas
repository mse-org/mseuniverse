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
   panelsta: tstatfile;
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
 mainsta.readstat;
 panelsta.readstat;
end;

procedure tmainfo.statmissingexe(const sender: tstatfile;
               const afilename: msestring; var astream: ttextstream;
               var aretry: Boolean);
begin
 astream:= ttextstringcopystream.create(  
         //default layout, text made by pasting the text of the *.sta file
         //and RightClick-'Convert to Pascal string'
'[mainfo.mainsta]'+lineend+
'savedmemoryfiles=0'+lineend+
'[mainfo.panelcontroller]'+lineend+
'panels=3'+lineend+
' panel1'+lineend+
' panel2'+lineend+
' panel3'+lineend+
'clients=63'+lineend+
' [mainfo.panelcontroller.panel1]'+lineend+
' splitdir=2'+lineend+
' useroptions=32239'+lineend+
' parent=mainfo.container'+lineend+
' visible=1'+lineend+
' mdistate=0'+lineend+
' nx=0'+lineend+
' ny=0'+lineend+
' ncx=0'+lineend+
' ncy=0'+lineend+
' x=2'+lineend+
' y=2'+lineend+
' cx=436'+lineend+
' cy=179'+lineend+
' rcx=0'+lineend+
' rcy=0'+lineend+
' children=2'+lineend+
'  dfo,0,32,426,147'+lineend+
'  cfo,0,0,426,29'+lineend+
' focusedchild=0'+lineend+
' [mainfo.panelcontroller.panel2]'+lineend+
' splitdir=1'+lineend+
' useroptions=32239'+lineend+
' parent=mainfo.container'+lineend+
' visible=1'+lineend+
' mdistate=0'+lineend+
' nx=0'+lineend+
' ny=0'+lineend+
' ncx=0'+lineend+
' ncy=0'+lineend+
' x=2'+lineend+
' y=184'+lineend+
' cx=436'+lineend+
' cy=173'+lineend+
' rcx=0'+lineend+
' rcy=0'+lineend+
' children=2'+lineend+
'  panel3,70,0,356,173'+lineend+
'  efo,0,0,67,173'+lineend+
' focusedchild=0'+lineend+
' [mainfo.panelcontroller.panel3]'+lineend+
' splitdir=3'+lineend+
' useroptions=32239'+lineend+
' order=2'+lineend+
'  bfo'+lineend+
'  afo'+lineend+
' activetab=1'+lineend+
' parent=mainfo.panelcontroller.panel2.container'+lineend+
' visible=1'+lineend+
' mdistate=0'+lineend+
' nx=0'+lineend+
' ny=0'+lineend+
' ncx=0'+lineend+
' ncy=0'+lineend+
' x=70'+lineend+
' y=0'+lineend+
' cx=356'+lineend+
' cy=173'+lineend+
' rcx=0'+lineend+
' rcy=0'+lineend+
' children=1'+lineend+
'  ,0,0,356,163'+lineend+
' focusedchild=0'+lineend+
'[mainfo]'+lineend+
'splitdir=2'+lineend+
'useroptions=15491'+lineend+
'stackedunder='+lineend+
'parent='+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=110'+lineend+
'y=261'+lineend+
'cx=450'+lineend+
'cy=375'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'wsize=0'+lineend+
'active=1'+lineend+
'visible=1'+lineend+
'[efo]'+lineend+
'splitdir=0'+lineend+
'useroptions=16507'+lineend+
'parent=mainfo.panelcontroller.panel2.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=67'+lineend+
'cy=173'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[dfo]'+lineend+
'splitdir=0'+lineend+
'useroptions=16507'+lineend+
'parent=mainfo.panelcontroller.panel1.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=32'+lineend+
'cx=426'+lineend+
'cy=147'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[cfo]'+lineend+
'splitdir=0'+lineend+
'useroptions=49275'+lineend+
'parent=mainfo.panelcontroller.panel1.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=426'+lineend+
'cy=29'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[bfo]'+lineend+
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
'cx=356'+lineend+
'cy=145'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[afo]'+lineend+
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
'cx=356'+lineend+
'cy=145'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'');
end;

end.
