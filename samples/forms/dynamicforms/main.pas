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
   createaact: taction;
   createbact: taction;
   createcact: taction;
   createdact: taction;
   createeact: taction;
   mainsta: tstatfile;
   procedure exitexe(const sender: TObject);
   procedure newpanelexe(const sender: TObject);
   procedure createaexe(const sender: TObject);
   procedure createbexe(const sender: TObject);
   procedure createcexe(const sender: TObject);
   procedure createdexe(const sender: TObject);
   procedure createeexe(const sender: TObject);
   procedure helpexe(const sender: TObject);
   procedure statmissingexe(const sender: tstatfile; const afilename: msestring;
                   var astream: ttextstream; var aretry: Boolean);
   procedure resetleayoutexe(const sender: TObject);
   procedure createdynformev(const sender: tdockpanelformcontroller;
                   const aclassname: AnsiString; const aname: AnsiString;
                   var acomponent: tmsecomponent);
   procedure regcompev(const sender: tdockpanelformcontroller;
                   const acomponent: tmsecomponent);
   procedure unregcompev(const sender: tdockpanelformcontroller;
                   const acomponent: tmsecomponent);
  protected
   procedure showdynform(const sender: tobject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,aform,bform,cform,dform,eform,msefileutils,basedynform;
 
procedure tmainfo.exitexe(const sender: TObject);
begin
 application.terminated:= true;
end;

procedure tmainfo.newpanelexe(const sender: TObject);
begin
 panelcontroller.newpanel.activate;
end;

procedure tmainfo.createaexe(const sender: TObject);
begin
 panelcontroller.createdynamicwidget(tafo).activate();
end;

procedure tmainfo.createbexe(const sender: TObject);
begin
 panelcontroller.createdynamicwidget(tbfo).activate();
end;

procedure tmainfo.createcexe(const sender: TObject);
begin
 panelcontroller.createdynamicwidget(tcfo).activate();
end;

procedure tmainfo.createdexe(const sender: TObject);
begin
 panelcontroller.createdynamicwidget(tdfo).activate();
end;

procedure tmainfo.createeexe(const sender: TObject);
begin
 panelcontroller.createdynamicwidget(tefo).activate();
end;

procedure tmainfo.helpexe(const sender: TObject);
begin
 showmessage('Click on top-right small circle button in order to'+lineend+
              'show/hide the grip frames.');
end;

procedure tmainfo.resetleayoutexe(const sender: TObject);
begin
 trydeletefile(mainsta.filename);
 mainsta.options:= mainsta.options + [sfo_nodata];
 try
  mainsta.readstat();
 finally
  mainsta.options:= mainsta.options - [sfo_nodata];
 end;
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
'dynamiccomps=5'+lineend+
' tafo,afo'+lineend+
' tbfo,bfo'+lineend+
' tafo,afo_1'+lineend+
' tcfo,cfo'+lineend+
' tcfo,cfo_1'+lineend+
'[mainfo]'+lineend+
'splitdir=2'+lineend+
'useroptions=15491'+lineend+
'stackedunder=cfo_1'+lineend+
'parent='+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=47'+lineend+
'y=165'+lineend+
'cx=444'+lineend+
'cy=325'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'wsize=0'+lineend+
'active=0'+lineend+
'visible=1'+lineend+
'[afo.tstringedit1]'+lineend+
'value='+lineend+
'[afo]'+lineend+
'splitdir=0'+lineend+
'useroptions=268451963'+lineend+
'parent=mainfo.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=229'+lineend+
'cx=434'+lineend+
'cy=80'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[bfo.tstringedit1]'+lineend+
'value='+lineend+
'[bfo]'+lineend+
'splitdir=0'+lineend+
'useroptions=268451963'+lineend+
'parent=mainfo.panelcontroller.panel3.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=424'+lineend+
'cy=49'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[afo_1.tstringedit1]'+lineend+
'value='+lineend+
'[afo_1]'+lineend+
'splitdir=0'+lineend+
'useroptions=268451963'+lineend+
'parent=mainfo.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=81'+lineend+
'cx=434'+lineend+
'cy=145'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[cfo.tstringedit1]'+lineend+
'value='+lineend+
'[cfo]'+lineend+
'splitdir=0'+lineend+
'useroptions=268451963'+lineend+
'parent=mainfo.panelcontroller.panel3.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=424'+lineend+
'cy=49'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[cfo_1.tstringedit1]'+lineend+
'value='+lineend+
'[cfo_1]'+lineend+
'splitdir=0'+lineend+
'useroptions=268451963'+lineend+
'stackedunder='+lineend+
'parent='+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=255'+lineend+
'y=325'+lineend+
'cx=149'+lineend+
'cy=100'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'wsize=0'+lineend+
'active=1'+lineend+
'visible=1'+lineend+
'[mainfo.panelcontroller.panel3]'+lineend+
'splitdir=3'+lineend+
'useroptions=805338607'+lineend+
'order=2'+lineend+
' cfo'+lineend+
' bfo'+lineend+
'activetab=0'+lineend+
'parent=mainfo.panelcontroller.panel4.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=424'+lineend+
'cy=78'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'children=1'+lineend+
' ,0,0,424,68'+lineend+
'focusedchild=0'+lineend+
'[mainfo.panelcontroller.panel4]'+lineend+
'splitdir=1'+lineend+
'useroptions=805338607'+lineend+
'parent=mainfo.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=434'+lineend+
'cy=78'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'children=1'+lineend+
' panel3,0,0,424,78'+lineend+
'focusedchild=0'+lineend+
'');
         
end;

procedure tmainfo.createdynformev(const sender: tdockpanelformcontroller;
               const aclassname: AnsiString; const aname: AnsiString;
               var acomponent: tmsecomponent);
begin
 acomponent:= sender.createdynamiccomp(aclassname);
end;

procedure tmainfo.regcompev(const sender: tdockpanelformcontroller;
               const acomponent: tmsecomponent);
var
 men1: tmenuitem;
begin
 men1:= mainmen.menu.itembynames(['view',acomponent.name]);
 if (men1 = nil) and (acomponent is tbasedynfo) then begin
  men1:= tmenuitem.create();
  men1.name:= acomponent.name;
  men1.caption:= tbasedynfo(acomponent).caption + ' '+
                                          msestring(acomponent.name);
  men1.tagpointer:= acomponent;
  men1.onexecute:= @showdynform;
  mainmen.menu.itembyname('view').submenu.insert(bigint,men1);
 end;
end;

procedure tmainfo.unregcompev(const sender: tdockpanelformcontroller;
               const acomponent: tmsecomponent);
begin
 mainmen.menu.deleteitembynames(['view',acomponent.name]);
end;

procedure tmainfo.showdynform(const sender: tobject);
begin
 twidget(tmenuitem(sender).tagpointer).activate();
end;

end.
