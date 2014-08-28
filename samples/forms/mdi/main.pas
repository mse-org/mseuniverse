unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedock,
 msedragglob,msestatfile,msestrings,msestream;

type
 tmainfo = class(tmainform)
   tdockpanel1: tdockpanel;
   tstatfile1: tstatfile;
   tmainmenu1: tmainmenu;
   procedure show1exe(const sender: TObject);
   procedure show2exe(const sender: TObject);
   procedure show3exe(const sender: TObject);
   procedure exitexe(const sender: TObject);
   procedure statmissingexe(const sender: tstatfile; const afilename: msestring;
                   var astream: ttextstream; var aretry: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,form1,form2,form3;

procedure tmainfo.show1exe(const sender: TObject);
begin
 form1fo.show();
end;

procedure tmainfo.show2exe(const sender: TObject);
begin
 form2fo.show();
end;

procedure tmainfo.show3exe(const sender: TObject);
begin
 form3fo.show();
end;

procedure tmainfo.exitexe(const sender: TObject);
begin
 close();
end;

procedure tmainfo.statmissingexe(const sender: tstatfile;
               const afilename: msestring; var astream: ttextstream;
               var aretry: Boolean);
begin
 //copy-paste the default statfile text, select the text, 
 //RightClick-'Convert to Pascal string'
 
 astream:= ttextstringcopystream.create(
'[mainfo.tdockpanel1]'+lineend+
'splitdir=0'+lineend+
'useroptions=391'+lineend+
'parent=mainfo.container'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=0'+lineend+
'ny=0'+lineend+
'ncx=0'+lineend+
'ncy=0'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=516'+lineend+
'cy=278'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'children=3'+lineend+
' form3fo,303,15,200,200'+lineend+
' form1fo,8,3,236,130'+lineend+
' form2fo,153,61,200,200'+lineend+
'focusedchild=2'+lineend+
'[mainfo]'+lineend+
'stackedunder='+lineend+
'x=235'+lineend+
'y=233'+lineend+
'cx=516'+lineend+
'cy=294'+lineend+
'wsize=0'+lineend+
'active=1'+lineend+
'visible=1'+lineend+
'[form3fo]'+lineend+
'splitdir=0'+lineend+
'useroptions=123'+lineend+
'parent=mainfo.tdockpanel1'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=303'+lineend+
'ny=15'+lineend+
'ncx=200'+lineend+
'ncy=200'+lineend+
'x=303'+lineend+
'y=15'+lineend+
'cx=200'+lineend+
'cy=200'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[form2fo]'+lineend+
'splitdir=0'+lineend+
'useroptions=123'+lineend+
'parent=mainfo.tdockpanel1'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=153'+lineend+
'ny=61'+lineend+
'ncx=200'+lineend+
'ncy=200'+lineend+
'x=153'+lineend+
'y=61'+lineend+
'cx=200'+lineend+
'cy=200'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
'[form1fo]'+lineend+
'splitdir=0'+lineend+
'useroptions=123'+lineend+
'parent=mainfo.tdockpanel1'+lineend+
'visible=1'+lineend+
'mdistate=0'+lineend+
'nx=8'+lineend+
'ny=3'+lineend+
'ncx=236'+lineend+
'ncy=130'+lineend+
'x=8'+lineend+
'y=3'+lineend+
'cx=236'+lineend+
'cy=130'+lineend+
'rcx=0'+lineend+
'rcy=0'+lineend+
''
)
 
end;

end.
