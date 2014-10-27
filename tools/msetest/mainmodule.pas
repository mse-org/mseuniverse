{ MSEtest Copyright (c) 2014 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mseact,mseificomp,
 mseificompglob,mseifiglob,msestat,msestatfile,mseactions,msedatanodes,
 mselistbrowser,mclasses,mserttistat,msestrings,msebitmap,msedataedits,mseedit,
 msefiledialog,msegraphics,msegraphutils,msegrids,msegui,mseguiglob,msemenus,
 msestream,msesys,sysutils,msemacros,mseforms,msesimplewidgets,msewidgets;

const
 macrogroupcount = 6;
type
 testnodekindty = (tnk_none,tnk_group,tnk_leaf);
 teststatety = (tes_none,tes_ok,tes_error,tes_canceled);

{$M+}  //rtti on
 ttestitem = class;
 
 ttestnode = class(ttreelistedititem)
  private
   fnr: integer;
   function getenabled: boolean;
   procedure setenabled(const avalue: boolean);
  protected
   fteststate: teststatety;
   class function createstatsubnode(const reader: tstatreader): ttestnode;
   procedure statreadsubnode(const reader: tstatreader;
                                            var anode: ttreelistitem); override;
   class function kind(): testnodekindty; virtual;
   procedure dogetdefaults(); virtual;
   class function baseimagenr(): integer; virtual;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure valuechange(); override;
   procedure assign(const source: ttestnode); virtual;
   procedure getdefaults();
   procedure number(var alast: integer); virtual;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   function firsttestitem(const startindex: integer = 0): ttestitem;
   function nexttestitem(const aroot: ttestnode): ttestitem;
   procedure updateteststate();
   procedure updateparentteststate(); virtual;
   property teststate: teststatety read fteststate;
  published
   property caption;
   property enabled: boolean read getenabled write setenabled;
   property nr: integer read fnr write fnr;
 end;
 ptestnode = ^ttestnode;
 
 ttestpathnode = class(ttestnode)
  private
   fpath: filenamety;
   fcomment: msestring;
  protected
   procedure setpath(avalue: filenamety); virtual;
   procedure dogetdefaults(); override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure assign(const source: ttestnode); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   function rootfilepath(): msestring;
  published
   property path: filenamety read fpath write setpath;
   property comment: msestring read fcomment write fcomment;
 end;

 ttestvaluenode = class(ttestpathnode)
  private
   fcompilecommand: msestring;
   fcompiledirectory: msestring;
   fruncommand: msestring;
   frundirectory: msestring;
   finput: msestring;
   fexpectedoutput: msestring;
   fexpectederror: msestring;
   fexpectedexitcode: integer;
  protected
   procedure dogetdefaults(); override;
  public
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
  published
   property compilecommand: msestring read fcompilecommand 
                                              write fcompilecommand;
   property compiledirectory: msestring read fcompiledirectory 
                                              write fcompiledirectory;
   property runcommand: msestring read fruncommand write fruncommand;
   property rundirectory: msestring read frundirectory write frundirectory;
   property input: msestring read finput write finput;
   property expectedoutput: msestring read fexpectedoutput
                                                  write fexpectedoutput;
   property expectederror: msestring read fexpectederror
                                                  write fexpectederror;
   property expectedexitcode: integer read fexpectedexitcode 
                                          write fexpectedexitcode;
 end;
  
 ttestgroupnode = class(ttestvaluenode)
  private
   fcaptiondefault: msestring;
   fpathdefault: filenamety;
   fnrlast: integer;
  protected
   class function kind: testnodekindty; override;
   procedure dogetdefaults(); override;
   class function baseimagenr(): integer; override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure number(var alast: integer); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   procedure updateparentteststate(); override;
  published
   property captiondefault: msestring read fcaptiondefault 
                                                  write fcaptiondefault;
   property pathdefault: msestring read fpathdefault 
                                                  write fpathdefault;
   property nrlast: integer read fnrlast write fnrlast;
 end;

 ttestitem = class(ttestvaluenode)
  private
   fcompileresult: integer;
   factualoutput: msestring;
   factualerror: msestring;
   factualexitcode: integer;
   finputerror: boolean;
  protected
   class function kind: testnodekindty; override;
   procedure dogetdefaults(); override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure assign(const source: ttestnode); override;
   procedure number(var alast: integer); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   procedure setteststate(const astate: teststatety);
  published
   property inputerror: boolean read finputerror write finputerror;
   property compileresult: integer read fcompileresult write fcompileresult;
   property actualoutput: msestring read factualoutput
                                                  write factualoutput;
   property actualerror: msestring read factualerror
                                                  write factualerror;
   property actualexitcode: integer read factualexitcode 
                                          write factualexitcode;
 end;

{$M-}  //rtti off

 tprojectoptions = class(toptions)
  private
   fmacronames: msestringarty;
   fmacrovalues: msestringarty;
   fmacroon: integerarty;
   fmacrogroup: integer;
   fgroupcomment: msestringarty;
   procedure setmacrogroup(avalue: integer);
  protected
   procedure dostatupdate(const filer: tstatfiler); override;
  public
   constructor create();
   procedure clear();
  published
   property macronames: msestringarty read fmacronames write fmacronames;
   property macrovalues: msestringarty read fmacrovalues write fmacrovalues;
   property macroon: integerarty read fmacroon write fmacroon;
   property macrogroup: integer read fmacrogroup write setmacrogroup;
   property groupcomment: msestringarty read fgroupcomment write fgroupcomment;
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
   stoponcomperr: taction;
   stoponfirsterr: taction;
   procedure exitexe(const sender: TObject);
   procedure openexe(const sender: TObject);
   procedure getstatobjexe(const sender: TObject; var aobject: TObject);
   procedure evenloopstartexe(const sender: TObject);
   procedure saveexe(const sender: TObject);
   procedure saveasexe(const sender: TObject);
   procedure projectupdateexe(const sender: TObject; const filer: tstatfiler);
   procedure aftermainstareadexe(const sender: TObject);
   procedure runtestexe(const sender: TObject);
   procedure stoponerrexe(const sender: TObject);
   procedure newexe(const sender: TObject);
   procedure closeexe(const sender: TObject);
  private
   frootnode: ttestnode;
   fprojectoptions: tprojectoptions;
   fmodified: boolean;
   fprojectname: msestring;
   fprojectfile: filenamety;
   fmacros: tmacrolist;
   frunfo: tmseform;
   feditfo: tmsecomponent;
   fedititem: ttestnode;
   fokcount: integer;
   ferrorcount: integer;
   fclipboarditem: ttestnode;
  protected
   procedure updatecaption();
   procedure updateprojectname();
   procedure loadproject();
   procedure updatemacros();
   procedure readclipboard(const reader: tstatreader);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   function closeproject(): modalresultty;
   procedure openproject();
   function saveproject(): modalresultty;
   function saveasproject(): modalresultty;
   procedure projectchanged();
   procedure renumber();
   function findnumber(const anumber: integer): ttestitem;
   procedure beginedit(const aitem: ttestnode; const editfo: tmsecomponent);
   procedure endedit(const aitem: ttestnode; const editfo: tmsecomponent);
   procedure begineditmacros(const editfo: tmsecomponent);
   procedure endeditmacros(const editfo: tmsecomponent);
   function expandmacros(const avalue: msestring): msestring;
   function expandmacros(const aitem: ttestnode;
                                   const avalue: msestring): msestring;
   function expandmacros(const aitem: ttestnode; const avalue: msestring; 
                           const apath: msestring): msestring;
   property macros: tmacrolist read fmacros;
   function runtest(const aitem: ttestnode): teststatety;
   property okcount: integer read fokcount;
   property errorcount: integer read ferrorcount;
   
   property rootnode: ttestnode read frootnode;
   property projectoptions: tprojectoptions read fprojectoptions;
   property edititem: ttestnode read fedititem;
   
   procedure copytoclipboard(const aitem: ttestnode);
   function pastefromclipboard(): ttestnode;
 end;
 
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm,msefileutils,runform,msefilemacros,msebits;
 
{ ttestnode }

constructor ttestnode.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;
 fstate:= fstate + [ns_checkbox,ns_checked,ns_showparentnotchecked];
 fimagenr:= baseimagenr();
end;

class function ttestnode.createstatsubnode(
                                       const reader: tstatreader): ttestnode;
begin
 case reader.readinteger('kind',0) of
  ord(tnk_group): begin
   result:= ttestgroupnode.create();
  end;
  ord(tnk_leaf): begin
   result:= ttestitem.create();
  end;
  else begin
   result:= ttestitem.create();
  end;
 end;
end;

procedure ttestnode.statreadsubnode(const reader: tstatreader;
               var anode: ttreelistitem);
begin
 anode:= createstatsubnode(reader);
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
 updateteststate();
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

function ttestnode.firsttestitem(const startindex: integer = 0): ttestitem;
var
 int1: integer;
 n1: ttestnode;
begin
 result:= nil;
 for int1:= startindex to count-1 do begin
  n1:= ttestnode(fitems[int1]);
  if n1.checked then begin
   if n1 is ttestitem then begin
    result:= ttestitem(n1);
   end
   else begin
    result:= n1.firsttestitem();
   end;
   if result <> nil then begin
    break;
   end;
  end;
 end;
end;

function ttestnode.nexttestitem(const aroot: ttestnode): ttestitem;
var
 n1: ttestnode;
begin
 result:= nil;
 n1:= self;
 while (result = nil) and (n1 <> aroot) do begin
  result:= ttestnode(n1.parent).firsttestitem(n1.parentindex+1);
  n1:= ttestnode(n1.parent);
 end;
end;

procedure ttestnode.assign(const source: ttestnode);
begin
 //dummy
end;

procedure ttestnode.dogetdefaults;
begin
 //dummy
end;

procedure ttestnode.getdefaults;
begin
 dogetdefaults();
 change;
end;

procedure ttestnode.number(var alast: integer);
begin
 //dummy
end;

procedure ttestnode.updateteststate;
var
 int1: integer;
begin
 int1:= baseimagenr();
 if checked and not (ns1_parentnotchecked in fstate1) then begin
  case fteststate of
   tes_error: begin
    int1:= int1 + 2;
   end;
   tes_ok: begin
    int1:= int1 + 1;
   end;
  end;
 end;
 if imagenr <> int1 then begin
  imagenr:= int1;
  valuechange();
 end;
end;

class function ttestnode.baseimagenr: integer;
begin
 result:= 0;
end;

procedure ttestnode.valuechange;
begin
 inherited;
 updateparentteststate();
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
 statebefore: teststatety;
begin
 statebefore:= fteststate;
 fteststate:= tes_none;
 for int1:= 0 to count-1 do begin
  with ttestnode(fitems[int1]) do begin
   if checked then begin
    if fteststate = tes_error then begin
     self.fteststate:= tes_error;
     break;
    end;
    if fteststate = tes_ok then begin
     self.fteststate:= tes_ok;
    end;
   end;
  end;
 end;
 if fteststate <> statebefore then begin
  updateteststate();
 end;
 inherited;
end;

procedure ttestgroupnode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writemsestring('cdef',fcaptiondefault);
 writer.writemsestring('pdef',fpathdefault);
end;

procedure ttestgroupnode.dostatread(const reader: tstatreader);
begin
 inherited;
 fcaptiondefault:= reader.readmsestring('cdef','');
 fpathdefault:= reader.readmsestring('pdef','');
end;

procedure ttestgroupnode.dogetdefaults;
begin
 inherited;
 if parent is ttestgroupnode then begin
  with ttestgroupnode(parent) do begin
   self.fcaptiondefault:= fcaptiondefault;
   self.fpathdefault:= fpathdefault;
  end;
 end;
end;

procedure ttestgroupnode.number(var alast: integer);
var
 int1: integer;
begin
 fnr:= alast+1;
 for int1:= 0 to count - 1 do begin
  ttestnode(fitems[int1]).number(alast);
 end;
 fnrlast:= alast;
end;

class function ttestgroupnode.baseimagenr: integer;
begin
 result:= 3;
end;

{ ttestpathnode }

constructor ttestpathnode.create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil);
begin
 inherited;
end;

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

procedure ttestpathnode.assign(const source: ttestnode);
begin
 inherited;
 if source is ttestpathnode then begin
  with ttestpathnode(source) do begin
   self.fpath:= fpath;
   self.fcomment:= fcomment;
  end;
 end;
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
  result:= mainmo.expandmacros(ttestpathnode(n1).fpath)+result;
  n1:= n1.parent
 until not (n1 is ttestpathnode) or 
     (result <> '') and (result[1] = '/');   //stop at root path
end;

procedure ttestpathnode.dogetdefaults;
begin
 inherited;
 if parent is ttestpathnode then begin
  with ttestvaluenode(parent) do begin
   self.fcomment:= fcomment;
  end;
 end;
end;

{ ttestvaluenode }

procedure ttestvaluenode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writemsestring('cc',fcompilecommand);
 writer.writemsestring('cd',fcompiledirectory);
 writer.writemsestring('rc',fruncommand);
 writer.writemsestring('rd',frundirectory);
 writer.writemsestring('in',finput);
 writer.writemsestring('eo',fexpectedoutput);
 writer.writemsestring('ee',fexpectederror);
 writer.writeinteger('eec',fexpectedexitcode);
end;

procedure ttestvaluenode.dostatread(const reader: tstatreader);
begin
 inherited;
 fcompilecommand:= reader.readmsestring('cc','');
 fcompiledirectory:= reader.readmsestring('cd','');
 fruncommand:= reader.readmsestring('rc','');
 frundirectory:= reader.readmsestring('rd','');
 finput:= reader.readmsestring('in','');
 fexpectedoutput:= reader.readmsestring('eo','');
 fexpectederror:= reader.readmsestring('ee','');
 fexpectedexitcode:= reader.readinteger('eec',0);
end;

procedure ttestvaluenode.dogetdefaults;
begin
 inherited;
 if parent is ttestvaluenode then begin
  with ttestvaluenode(parent) do begin
   self.fcompilecommand:= fcompilecommand;
   self.fcompiledirectory:= fcompiledirectory;
   self.fruncommand:= fruncommand;
   self.frundirectory:= frundirectory;
   self.finput:= finput;
   self.fexpectedoutput:= fexpectedoutput;
   self.fexpectederror:= fexpectederror;
   self.fexpectedexitcode:= fexpectedexitcode;
  end;
 end;
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
 writer.writeinteger('cr',fcompileresult);
 writer.writemsestring('ao',factualoutput);
 writer.writemsestring('ae',factualerror);
 writer.writeinteger('aec',factualexitcode);
 writer.writeboolean('ie',finputerror);
end;

procedure ttestitem.dostatread(const reader: tstatreader);
begin
 inherited;
 fcompileresult:= reader.readinteger('cr',0);
 factualoutput:= reader.readmsestring('ao','');
 factualerror:= reader.readmsestring('ae','');
 factualexitcode:= reader.readinteger('aec',0);
 finputerror:= reader.readboolean('ie',false);
end;

procedure ttestitem.setteststate(const astate: teststatety);
begin
 fteststate:= astate;
 updateparentteststate();
end;

procedure ttestitem.assign(const source: ttestnode);
begin
 inherited;
 if source is ttestitem then begin
  with ttestitem(source) do begin
   self.fcompilecommand:= fcompilecommand;
   self.fcompileresult:= fcompileresult;
   self.fruncommand:= fruncommand;
   self.finput:= finput;
   self.fexpectedoutput:= fexpectedoutput;
   self.factualoutput:= factualoutput;
   self.fexpectederror:= fexpectederror;
   self.factualerror:= factualerror;
   self.fexpectedexitcode:= fexpectedexitcode;
   self.factualexitcode:= factualexitcode;
   self.finputerror:= finputerror;
  end;
 end;
end;

procedure ttestitem.dogetdefaults;
begin
 inherited;
 if parent is ttestgroupnode then begin
  with ttestgroupnode(parent) do begin
   self.fcaption:= fcaptiondefault;
  end;
 end;
end;

procedure ttestitem.number(var alast: integer);
begin
 inc(alast);
 fnr:= alast;
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

{tmainmo}

constructor tmainmo.create(aowner: tcomponent);
begin
 frootnode:= ttestnode.create();
 fprojectoptions:= tprojectoptions.create();
 fmacros:= tmacrolist.create([mao_caseinsensitive,mao_curlybraceonly]);
 fmacros.setpredefined(filemacros);
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
  updatemacros();
  frootnode.checked:= true;
  frootnode.updateparentnotcheckedtree();
  renumber();
  connectgui.controller.execute();
 end;
end;

procedure tmainmo.openproject();
begin
 if (closeproject() <> mr_cancel) and 
            (projectfiledialog.execute(fdk_open) = mr_ok) then begin
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
  result:= askyesnocancel('Project has been modified, save it?','Confirmation');
 end;
 if result <> mr_cancel then begin
  if (result = mr_yes) then begin
   if fprojectfile <> '' then begin
    result:= saveproject();
   end
   else begin
    if fmodified then begin
     result:= saveasproject();
    end
    else begin
     result:= mr_ok;
    end;
   end;
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
//   projectfiledialog.controller.filename:= '';
  end;
 end;
end;

procedure tmainmo.openexe(const sender: TObject);
begin
 openproject();
end;

procedure tmainmo.saveexe(const sender: TObject);
begin
 saveproject();
end;

procedure tmainmo.saveasexe(const sender: TObject);
begin
 saveasproject();
end;

procedure tmainmo.newexe(const sender: TObject);
begin
 if closeproject <> mr_cancel then begin
  fprojectname:= '<new>';
  updatecaption();
  projectfiledialog.controller.filename:= '';
  if projectfiledialog.execute(fdk_new) <> mr_cancel then begin
   updateprojectname();
  end;
 end;
end;

procedure tmainmo.closeexe(const sender: TObject);
begin
 closeproject();
end;

procedure tmainmo.getstatobjexe(const sender: TObject; var aobject: TObject);
begin
 aobject:= projectoptions;
end;

procedure tmainmo.projectchanged();
begin
 renumber();
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
 if (fprojectname = '') and fmodified then begin
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

procedure tmainmo.beginedit(const aitem: ttestnode; 
                                       const editfo: tmsecomponent);
begin
 fedititem:= aitem;
 feditfo:= editfo;
 objecttovalues(aitem,editfo,'val_');
end;

procedure tmainmo.endedit(const aitem: ttestnode; const editfo: tmsecomponent);
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
 updatemacros();
 projectchanged();
end;

function tmainmo.expandmacros(const avalue: msestring): msestring;
begin
 result:= fmacros.expandmacros(avalue);
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

function tmainmo.runtest(const aitem: ttestnode): teststatety;
begin
 result:= tes_none;
 if frunfo = nil then begin
  setlinkedvar(trunfo.create(nil),tmsecomponent(frunfo));
 end;
 with trunfo(frunfo) do begin
  result:= runtest(aitem);
  fokcount:= okdi.value;
  ferrorcount:= errordi.value;
 end;
end;

procedure tmainmo.runtestexe(const sender: TObject);
var
 n1: ttestitem;
begin
 if (feditfo <> nil) then begin
  n1:= ttestitem.create;
  n1.assign(fedititem); //backup
  try
   valuestoobject(feditfo,fedititem,'val_');   //get current values
   runtest(fedititem);
   objecttovalues(fedititem,feditfo,'val_');   //store new values
  finally
   fedititem.assign(n1); //restore
   n1.destroy();
  end;
 end;
end;

procedure tmainmo.renumber;
var
 int1,int2: integer;
begin
 int2:= 0;
 for int1:= 0 to frootnode.count-1 do begin
  ttestnode(frootnode.fitems[int1]).number(int2);
 end;
end;

function tmainmo.findnumber(const anumber: integer): ttestitem;
 
 procedure check(const anode: ttestnode);
 var
  int1: integer;
 begin
  if anode is ttestitem then begin
   if anode.fnr = anumber then begin
    result:= ttestitem(anode);
    exit;
   end;
  end;
  if anode.nr > anumber then begin
   exit;
  end;
  for int1:= 1 to anode.count-1 do begin
   if ttestnode(anode.fitems[int1]).nr > anumber then begin
    check(ttestnode(anode.fitems[int1-1]));
    exit;
   end;
  end;
  if anode.count > 0 then begin
   check(ttestnode(anode.fitems[anode.count-1]));
  end;
 end;
 
begin
 result:= nil;
 check(rootnode);
end;


procedure tmainmo.stoponerrexe(const sender: TObject);
begin
 projectchanged();
end;

procedure tmainmo.copytoclipboard(const aitem: ttestnode);
begin
 if aitem <> nil then begin
  msewidgets.copytoclipboard(utf8tostring(writestat([@aitem.dostatwrite],
                                                                  'msetest')));
 end;
end;

procedure tmainmo.readclipboard(const reader: tstatreader);
begin
 fclipboarditem:= ttestnode.createstatsubnode(reader);
 if fclipboarditem <> nil then begin
  fclipboarditem.dostatread(reader);
 end;
end;

function tmainmo.pastefromclipboard: ttestnode;
var
 mstr1: msestring;
begin
 fclipboarditem:= nil;
 if msewidgets.pastefromclipboard(mstr1) then begin
  readstat([@readclipboard],stringtoutf8(mstr1),'msetest');
 end;
 result:= fclipboarditem;
 fclipboarditem:= nil;
end;

procedure tmainmo.updatemacros();
var
 int1,int2,int3,mask: integer;
 ar1: macroinfoarty;
begin
 with fprojectoptions do begin
  int2:= high(fmacronames);
  if int2 < high(fmacrovalues) then begin
   int2:= high(fmacrovalues);
  end;
  mask:= bits[fmacrogroup];
  setlength(ar1,int2+1); //max
  int3:= 0;
  for int1:= 0 to int2 do begin
   if (high(fmacroon) < int1) or (fmacroon[int1] and mask <> 0) then begin
    with ar1[int3] do begin
     name:= fmacronames[int1];
     value:= fmacrovalues[int1];
    end;
    inc(int3);
   end;
  end;
  setlength(ar1,int3);
  fmacros.setasarray(ar1);
 end;
end;

{ tprojectoptions }

constructor tprojectoptions.create;
begin
 inherited;
 setlength(fgroupcomment,macrogroupcount);
end;

procedure tprojectoptions.dostatupdate(const filer: tstatfiler);
begin
 inherited;
 setlength(fgroupcomment,macrogroupcount);
// filer.updatevalue('macronames',fmacronames);
// filer.updatevalue('macrovalues',fmacrovalues);
end;

procedure tprojectoptions.clear;
begin
 fmacronames:= nil;
 fmacrovalues:= nil;
 fmacroon:= nil;
 fmacrogroup:= 0;
 fgroupcomment:= nil;
end;

procedure tprojectoptions.setmacrogroup(avalue: integer);
begin
 if avalue < 0 then begin
  avalue:= 0;
 end
 else begin
  if avalue >= macrogroupcount then begin
   avalue:= macrogroupcount - 1;
  end;
 end;
 fmacrogroup:= avalue; 
end;

end.
