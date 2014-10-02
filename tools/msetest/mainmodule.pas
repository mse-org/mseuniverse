unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mseact,mseificomp,
 mseificompglob,mseifiglob,msestat,msestatfile,mseactions,msedatanodes,
 mselistbrowser,mclasses,mserttistat,msestrings,msebitmap,msedataedits,mseedit,
 msefiledialog,msegraphics,msegraphutils,msegrids,msegui,mseguiglob,msemenus,
 msestream,msesys,sysutils,msemacros,mseforms;

type
 testnodekindty = (tnk_none,tnk_group,tnk_leaf);
 teststatety = (tes_none,tes_ok,tes_error);

{$M+}  //rtti on
 ttestitem = class;
 
 ttestnode = class(ttreelistedititem)
  private
   function getenabled: boolean;
   procedure setenabled(const avalue: boolean);
  protected
   fteststate: teststatety;
   procedure statreadsubnode(const reader: tstatreader;
                                            var anode: ttreelistitem); override;
   class function kind: testnodekindty; virtual;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   function nexttestitem: ttestitem; virtual;
//   function run(): boolean; virtual; //true if ok
   procedure updateparentteststate(); virtual;
   property teststate: teststatety read fteststate;
  published
   property caption;
   property enabled: boolean read getenabled write setenabled;
 end;
 
 ttestpathnode = class(ttestnode)
  private
   fpath: filenamety;
   fcomment: msestring;
//   fpathabs: filenamety;
//   fpathrel: filenamety;
  protected
   procedure setpath(avalue: filenamety); virtual;
  public
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   function rootfilepath(): msestring;
  published
   property path: filenamety read fpath write setpath;
   property comment: msestring read fcomment write fcomment;
//   property pathrel: filenamety read fpathrel write dosetpath;
 end;
 
 ttestgroupnode = class(ttestpathnode)
  protected
   class function kind: testnodekindty; override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
//   function run(): boolean; override;
   procedure updateparentteststate(); override;
 end;

 ttestitem = class(ttestpathnode)
  private
//   fpathrel: filenamety;
   fcompilecommand: msestring;
   fruncommand: msestring;
   finput: string;
   fexpectedoutput: string;
   factualoutput: string;
   fexpectederror: string;
   factualerror: string;
   fexpectedexitcode: integer;
   factualexitcode: integer;
   fcompileresult: integer;
  protected
   class function kind: testnodekindty; override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   procedure setteststate(const astate: teststatety);
//   function run(): boolean; override;
  published
   property compilecommand: msestring read fcompilecommand 
                                              write fcompilecommand;
   property runcommand: msestring read fruncommand write fruncommand;
   property input: string read finput write finput;
   property compileresult: integer read fcompileresult write fcompileresult;
   property expectedoutput: string read fexpectedoutput
                                                  write fexpectedoutput;
   property actualoutput: string read factualoutput
                                                  write factualoutput;
   property expectederror: string read fexpectederror
                                                  write fexpectederror;
   property actualerror: string read factualerror
                                                  write factualerror;
   property expectedexitcode: integer read fexpectedexitcode 
                                          write fexpectedexitcode;
   property actualexitcode: integer read factualexitcode 
                                          write factualexitcode;
 end;

{$M-}  //rtti off

 tprojectoptions = class(toptions)
  private
   fmacronames: msestringarty;
   fmacrovalues: msestringarty;
  protected
   procedure dostatupdate(const filer: tstatfiler); override;
  public
   procedure clear();
  published
   property macronames: msestringarty read fmacronames write fmacronames;
   property macrovalues: msestringarty read fmacrovalues write fmacrovalues;
 end;
  
 tmainmo = class(tmsedatamodule)
   exitact: taction;
   newact: taction;
   saveact: taction;
   openact: taction;
   closeact: taction;
   saveasact: taction;
   projectstat: tstatfile;
   mainstat: tstatfile;
   connectgui: tifiactionlinkcomp;
   trttistat1: trttistat;
   projectcaption: tifistringlinkcomp;
   projectfiledialog: tfiledialog;
   runtestact: taction;
   procedure exitexe(const sender: TObject);
   procedure openexe(const sender: TObject);
   procedure getstatobjexe(const sender: TObject; var aobject: TObject);
   procedure evenloopstartexe(const sender: TObject);
   procedure saveexe(const sender: TObject);
   procedure saveasexe(const sender: TObject);
   procedure projectupdateexe(const sender: TObject; const filer: tstatfiler);
   procedure aftermainstareadexe(const sender: TObject);
   procedure runtestexe(const sender: TObject);
  private
   frootnode: ttestnode;
   fprojectoptions: tprojectoptions;
   fmodified: boolean;
   fprojectname: msestring;
   fprojectfile: filenamety;
   fmacros: tmacrolist;
   frunfo: tmseform;
   feditfo: tmsecomponent;
   fedititem: ttestitem;
  protected
   procedure updatecaption();
   procedure updateprojectname();
   procedure loadproject();
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   function closeproject(): modalresultty;
   procedure openproject();
   function saveproject(): modalresultty;
   function saveasproject(): modalresultty;
   procedure projectchanged();
   procedure beginedit(const aitem: ttestitem; const editfo: tmsecomponent);
   procedure endedit(const aitem: ttestitem; const editfo: tmsecomponent);
   procedure begineditmacros(const editfo: tmsecomponent);
   procedure endeditmacros(const editfo: tmsecomponent);
   function expandmacros(const aitem: ttestnode;
                                   const avalue: msestring): msestring;
   function expandmacros(const aitem: ttestnode; const avalue: msestring; 
                           const apath: msestring): msestring;
   function runtest(const aitem: ttestnode): boolean; //true if ok
   
   property rootnode: ttestnode read frootnode;
   property projectoptions: tprojectoptions read fprojectoptions;
   property edititem: ttestitem read fedititem;
 end;
 
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm,msewidgets,msefileutils,runform;

{tmainmo}

constructor tmainmo.create(aowner: tcomponent);
begin
 frootnode:= ttestnode.create();
 fprojectoptions:= tprojectoptions.create();
 fmacros:= tmacrolist.create([mao_caseinsensitive,mao_curlybraceonly]);
 inherited;
end;

destructor tmainmo.destroy();
begin
 inherited;
 frunfo.free();
 fmacros.free();
 frootnode.free();
 fprojectoptions.free();
end;

procedure tmainmo.exitexe(const sender: TObject);
begin
 if closeproject() <> mr_cancel then begin
  application.terminated:= true;
 end;
end;

procedure tmainmo.updateprojectname();
begin
 fprojectfile:= projectfiledialog.controller.filename;
 fprojectname:= filename(fprojectfile);
 projectstat.filename:= fprojectfile;
 updatecaption();
end;

procedure tmainmo.loadproject();
begin
 updateprojectname();
 if fprojectfile <> '' then begin
  projectstat.readstat();
  fmacros.setasarray(fprojectoptions.macronames,fprojectoptions.macrovalues);
  frootnode.checked:= true;
  frootnode.updateparentnotcheckedtree();
  connectgui.controller.execute();
 end;
end;

procedure tmainmo.openproject();
begin
 if (projectfiledialog.execute(fdk_open) = mr_ok) and
                                    (closeproject() <> mr_cancel) then begin
  loadproject();
 end;
end;

function tmainmo.saveproject(): modalresultty;
begin
 if fprojectfile = '' then begin
  result:= saveasproject();
 end
 else begin
  projectstat.writestat();
  fmodified:= false;
  updatecaption();
  result:= mr_ok;
 end;
end;

function tmainmo.saveasproject(): modalresultty;
begin
 result:= projectfiledialog.execute(fdk_save);
 if result = mr_ok then begin
  updateprojectname();
  result:= saveproject();
 end;
end;

function tmainmo.closeproject(): modalresultty;
var
 n1: ttestnode;
begin
 result:= mr_yes;
 if fmodified then begin
  result:= askyesnocancel('Project has been modified, save it?');
 end;
 if result <> mr_cancel then begin
  if fprojectfile <> '' then begin
   if result = mr_yes then begin
    result:= saveproject();
   end
   else begin
    result:= mr_ok;
   end;
   if result = mr_ok then begin
    n1:= frootnode;
    frootnode:= nil;
    connectgui.controller.execute(); //disconnect
    frootnode:= n1;
    frootnode.clear();
    fmodified:= false;
    fprojectname:= '';
    fprojectfile:= '';
    updatecaption();
    fprojectoptions.clear();
    fmacros.clear();
   end;
  end;
 end;
end;

procedure tmainmo.openexe(const sender: TObject);
begin
 openproject();
end;

procedure tmainmo.getstatobjexe(const sender: TObject; var aobject: TObject);
begin
 aobject:= projectoptions;
end;

procedure tmainmo.projectchanged();
begin
 if not fmodified then begin
  fmodified:= true;
  updatecaption();
 end;
end;

procedure tmainmo.updatecaption();
var
 mstr1: msestring;
begin
 mstr1:= '';
 if fmodified then begin
  mstr1:= '*';
 end;
 if fprojectname = '' then begin
  mstr1:= mstr1 + '<new>';
 end
 else begin
  mstr1:= mstr1+fprojectname;
 end;
 projectcaption.controller.value:= mstr1;
end;

procedure tmainmo.evenloopstartexe(const sender: TObject);
begin
// connectgui.controller.execute();
 updatecaption();
end;

procedure tmainmo.saveexe(const sender: TObject);
begin
 saveproject();
end;

procedure tmainmo.saveasexe(const sender: TObject);
begin
 saveasproject();
end;

procedure tmainmo.projectupdateexe(const sender: TObject;
               const filer: tstatfiler);
begin
 filer.setsection('tree');
 frootnode.dostatupdate(filer);
 filer.setsection('options');
 fprojectoptions.dostatupdate(filer);
end;

procedure tmainmo.aftermainstareadexe(const sender: TObject);
begin
 loadproject(); 
end;

procedure tmainmo.beginedit(const aitem: ttestitem; 
                                       const editfo: tmsecomponent);
begin
 fedititem:= aitem;
 feditfo:= editfo;
 objecttovalues(aitem,editfo,'val_');
end;

procedure tmainmo.endedit(const aitem: ttestitem; const editfo: tmsecomponent);
begin
 fedititem:= nil;
 feditfo:= nil;
 valuestoobject(editfo,aitem,'val_');
 projectchanged();
end;

procedure tmainmo.begineditmacros(const editfo: tmsecomponent);
begin
 objecttovalues(fprojectoptions,editfo,'val_');
end;

procedure tmainmo.endeditmacros(const editfo: tmsecomponent);
begin
 valuestoobject(editfo,fprojectoptions,'val_');
 fmacros.setasarray(fprojectoptions.macronames,fprojectoptions.macrovalues);
 projectchanged();
end;

function tmainmo.expandmacros(const aitem: ttestnode;
                                   const avalue: msestring): msestring;
begin
 if aitem is ttestpathnode then begin
  result:= msemacros.expandmacros(avalue,fmacros.asarray(['FILE'],
                                       [ttestpathnode(aitem).rootfilepath]));
 end
 else begin
  result:= fmacros.expandmacros(avalue);
 end;
end;

function tmainmo.expandmacros(const aitem: ttestnode; const avalue: msestring; 
                           const apath: msestring): msestring;
begin
 result:= msemacros.expandmacros(avalue,fmacros.asarray(['FILE'],[apath]));
end;

function tmainmo.runtest(const aitem: ttestnode): boolean;
begin
 result:= false;
 if frunfo = nil then begin
  setlinkedvar(trunfo.create(nil),tmsecomponent(frunfo));
 end;
 result:= trunfo(frunfo).runtest(aitem);
end;

procedure tmainmo.runtestexe(const sender: TObject);
var
 n1: ttestitem;
begin
 if (feditfo <> nil) then begin
  n1:= ttestitem.create;
  try
   valuestoobject(feditfo,n1,'val_');   
   runtest(n1);
   objecttovalues(n1,feditfo,'val_');   
  finally
   n1.destroy();
  end;
 end;
end;

{ ttestnode }

constructor ttestnode.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;
 fstate:= fstate + [ns_checkbox,ns_checked,ns_showparentnotchecked];
end;

procedure ttestnode.statreadsubnode(const reader: tstatreader;
               var anode: ttreelistitem);
begin
 case reader.readinteger('kind',0) of
  ord(tnk_group): begin
   anode:= ttestgroupnode.create();
  end;
  ord(tnk_leaf): begin
   anode:= ttestitem.create();
  end;
  else begin
   anode:= ttestitem.create();
  end;
 end;
end;

class function ttestnode.kind: testnodekindty;
begin
 result:= tnk_none;
end;

procedure ttestnode.dostatwrite(const writer: tstatwriter);
begin
 writer.writeinteger('kind',ord(kind));
 inherited;
 writer.writeinteger('teststate',ord(fteststate));
end;

procedure ttestnode.dostatread(const reader: tstatreader);
begin
 inherited;
 fteststate:= teststatety(reader.readinteger('teststate',0));
end;
{
function ttestnode.run: boolean;
begin
 result:= true; //dummy
end;
}
procedure ttestnode.updateparentteststate();
begin
 if parent is ttestnode then begin
  ttestnode(parent).updateparentteststate();
 end;
end;

function ttestnode.getenabled: boolean;
begin
 result:= checked;
end;

procedure ttestnode.setenabled(const avalue: boolean);
begin
 checked:= avalue;
end;

function ttestnode.nexttestitem: ttestitem;
begin
 result:= nil;
end;

{ ttestgroupnode }

constructor ttestgroupnode.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;
 include(fstate,ns_subitems);
end;

class function ttestgroupnode.kind: testnodekindty;
begin
 result:= tnk_group;
end;
{
function ttestgroupnode.run(): boolean;
var
 int1: integer;
begin
 result:= true;
 if treechecked then begin
  fteststate:= tes_none;
  if count > 0 then begin
   fteststate:= tes_ok;
   for int1:= 0 to count-1 do begin
    if not ttestnode(fitems[int1]).run() then begin
     result:= false;
    end;
   end;
  end;
  if result = false then begin
   fteststate:= tes_error;
  end;
 end;
end;
}
procedure ttestgroupnode.updateparentteststate();
var
 int1: integer;
begin
 fteststate:= tes_none;
 for int1:= 0 to count-1 do begin
  with ttestnode(fitems[int1]) do begin
   if fteststate = tes_error then begin
    self.fteststate:= tes_error;
    break;
   end;
   if fteststate = tes_ok then begin
    self.fteststate:= tes_ok;
   end;
  end;
 end;
 inherited;
end;

{ ttestpathnode }

procedure ttestpathnode.setpath(avalue: filenamety);
begin
 fpath:= avalue;
end;

procedure ttestpathnode.dostatread(const reader: tstatreader);
begin
 inherited;
 fpath:= reader.readmsestring('path','');
 fcomment:= reader.readmsestring('comment','');
// fpathabs:= reader.readmsestring('pathabs','');
// fpathrel:= reader.readmsestring('pathrel','');
end;

procedure ttestpathnode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writemsestring('path',fpath);
 writer.writemsestring('comment',fcomment);
// writer.writemsestring('pathabs',fpathabs);
// writer.writemsestring('pathrel',fpathrel);
end;

function ttestpathnode.rootfilepath: msestring;
var
 n1: ttreelistitem;
begin
 result:= '';
 n1:= self;
 repeat
  result:= ttestpathnode(n1).fpath+result;
  n1:= n1.parent
 until not (n1 is ttestpathnode) or 
     (result <> '') and (result[1] = '/');   //stop at root path
end;

{ ttestitem }

constructor ttestitem.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;
end;

class function ttestitem.kind: testnodekindty;
begin
 result:= tnk_leaf;
end;

procedure ttestitem.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writemsestring('cc',fcompilecommand);
 writer.writeinteger('cr',fcompileresult);
 writer.writemsestring('rc',fruncommand);
 writer.writebinarystring('in',finput);
 writer.writebinarystring('eo',fexpectedoutput);
 writer.writebinarystring('ao',factualoutput);
 writer.writebinarystring('ee',fexpectederror);
 writer.writebinarystring('ae',factualerror);
 writer.writeinteger('eec',fexpectedexitcode);
 writer.writeinteger('aec',factualexitcode);
end;

procedure ttestitem.dostatread(const reader: tstatreader);
begin
 inherited;
 fcompilecommand:= reader.readmsestring('cc','');
 fcompileresult:= reader.readinteger('cr',0);
 fruncommand:= reader.readmsestring('rc','');
 finput:= reader.readbinarystring('in','');
 fexpectedoutput:= reader.readbinarystring('eo','');
 factualoutput:= reader.readbinarystring('ao','');
 fexpectederror:= reader.readbinarystring('ee','');
 factualerror:= reader.readbinarystring('ae','');
 fexpectedexitcode:= reader.readinteger('eec',0);
 factualexitcode:= reader.readinteger('aec',0);
end;

procedure ttestitem.setteststate(const astate: teststatety);
begin
 fteststate:= astate;
 updateparentteststate();
end;
{
function ttestitem.run: boolean;
begin
 result:= true;
 if treechecked then begin
  mainmo.run
  if (caption <> '') and (caption[1] = 'E') then begin
   fteststate:= tes_error;
   result:= false;
  end
  else begin
   fteststate:= tes_ok;
   result:= true;
  end;
 end;
end;
}
{ tprojectoptions }

procedure tprojectoptions.dostatupdate(const filer: tstatfiler);
begin
 inherited;
 filer.updatevalue('macronames',fmacronames);
 filer.updatevalue('macrovalues',fmacrovalues);
end;

procedure tprojectoptions.clear;
begin
 fmacronames:= nil;
 fmacrovalues:= nil;
end;

end.
