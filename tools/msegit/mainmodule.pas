{ MSEgit Copyright (c) 2011-2012 by Martin Schreiber
   
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
 classes,mseglob,mseapplication,mseclasses,msedatamodules,msestat,msestatfile,
 mserttistat,mseact,mseactions,mseifiglob,msebitmap,msedataedits,msedatanodes,
 mseedit,msefiledialog,msegraphics,msegraphutils,msegrids,msegui,mseguiglob,
 mselistbrowser,msemenus,msestrings,msesys,msetypes,mseificomp,mseificompglob,
 msesimplewidgets,msewidgets,msegitcontroller,msehash,msestream;

const
 defaultmaxlog = 50;
 defaultdiffcontextn = 3;
type
 tmsegitfileitem = class(tgitfileitem)
  protected
  public
   constructor create; override;
   function getoriginicon: integer;
 end;
 pmsegitfileitem = ^tmsegitfileitem;
 msegitfileitemarty = array of tmsegitfileitem;

 tmainmo = class;
 
 tmsegitoptions = class
  private
   fowner: tmainmo;
   fshowuntrackeditems: boolean;
   fshowignoreditems: boolean;
   fmaxlog: integer;
   fshowutc: boolean;
   fdiffcontextn: integer;
   fdifftool: msestring;
   fmergetool: msestring;
   fpatchtool: msestring;
   fsplitdiffs: boolean;
   procedure setshowignoreditems(const avalue: boolean);
   procedure setshowuntrackeditems(const avalue: boolean);
   function getgitcommand: msestring;
   procedure setgitcommand(const avalue: msestring);
  public
   constructor create(const aowner: tmainmo);
  published
   property showuntrackeditems: boolean read fshowuntrackeditems 
                                             write setshowuntrackeditems;
   property showignoreditems: boolean read fshowignoreditems 
                                             write setshowignoreditems;
   property gitcommand: msestring read getgitcommand write setgitcommand;
   property maxlog: integer read fmaxlog write fmaxlog;
   property showutc: boolean read fshowutc write fshowutc;
   property diffcontextn: integer read fdiffcontextn write fdiffcontextn;
   property splitdiffs: boolean read fsplitdiffs write fsplitdiffs;
   property difftool: msestring read fdifftool write fdifftool;
   property mergetool: msestring read fmergetool write fmergetool;
   property patchtool: msestring read fpatchtool write fpatchtool;
 end;

 tgitdirtreenode = class(tdirtreenode)
  private
   fgitstate: gitstatedataty;
   fdirstate: gitstatedataty;
  protected
   procedure setstate(const astate: gitstateinfoty; var aname: lmsestringty);
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure drawimage(var alayoutinfo: listitemlayoutinfoty;
                                         const acanvas: tcanvas); override;
   function getoriginicon: integer;
   function gitpath: filenamety;
   function gitbasepath: filenamety;
   property gitstatex: gitstatesty read fgitstate.statex;
   property gitstatey: gitstatesty read fgitstate.statey;
   property dirstatex: gitstatesty read fdirstate.statex;
   property dirstatey: gitstatesty read fdirstate.statey;
 end;
 gitdirtreenodearty = array of tgitdirtreenode;

 tgitdirtreerootnode = class(tgitdirtreenode)
  private
   froot: boolean;
  protected
   function createsubnode: ttreelistitem; override;
   procedure checkfiles(var afiles: filenamearty); override;
  public
   destructor destroy; override;
   procedure loaddirtree(const apath: filenamety); override;
   procedure updatestate(const areporoot,arepo: filenamety;
                   const astate: tgitstatecache; const afiles: tgitfilecache);
   function getfiles(const apath: filenamety;
                          const gitstate: tgitstatecache): gitfileitemarty;
 end;

 trepostat = class
  private
   factiveremote: msestring;
   fcommitmessages: msestringarty;
   fcommitmessage: msestring;
   factivelocallogbranch: msestring;
   factiveremotelogbranch: msestring;
   factiveremotelog: msestring;
   flinkedremotebranches: msestringarty;
   fhiddenremotes: msestringarty;
   fhiddenremotebranches: msestringarty;
   fhiddenlocalbranches: msestringarty;
   flocalbranchorder: msestringarty;
   fremotesorder: msestringarty;
   fremotebranchorder: msestringarty;
   fshowhiddenbranches: boolean;
  public
   procedure reset;
   function activelogcommit: msestring;
  published
   property activeremote: msestring read factiveremote write factiveremote;
   property activelocallogbranch: msestring read factivelocallogbranch 
                                                write factivelocallogbranch;
   property activeremotelog: msestring read factiveremotelog 
                                                write factiveremotelog;
   property activeremotelogbranch: msestring read factiveremotelogbranch 
                                                write factiveremotelogbranch;
   property commitmessages: msestringarty read fcommitmessages 
                                                 write fcommitmessages;
   property commitmessage: msestring read fcommitmessage write fcommitmessage;
   property linkedremotebranches: msestringarty read flinkedremotebranches 
                                                write flinkedremotebranches;
   property hiddenremotes: msestringarty read fhiddenremotes 
                                                write fhiddenremotes;
   property hiddenremotebranches: msestringarty read fhiddenremotebranches 
                                                write fhiddenremotebranches;
   property hiddenlocalbranches: msestringarty read fhiddenlocalbranches 
                                                write fhiddenlocalbranches;
   property localbranchorder: msestringarty read flocalbranchorder 
                                                write flocalbranchorder;
   property remotesorder: msestringarty read fremotesorder write fremotesorder;
   property remotebranchorder: msestringarty read fremotebranchorder 
                                                  write fremotebranchorder;
   property showhiddenbranches: boolean read fshowhiddenbranches
                                                  write fshowhiddenbranches;
                                                  
 end;

 trefsitem = class
  public
   remote: msestring;
   info: refsinfoty;
 end;
 refsitemarty = array of trefsitem;
 
 trefsnamelist = class(tobjectmsestringhashdatalist)
  public
   constructor create;
   procedure add(const aitem: trefsitem);
 end;
 
 trefsitemlist = class(tobjectmsestringhashdatalist)
  private
   fnamelist: trefsnamelist;
  protected
   fitems: refsitemarty;
   fitemscount: integer;
   procedure listitems(var item: objectmsestringdataty);
  public
   constructor create;
   destructor destroy; override;
   procedure add(const aremote: msestring; const ainfo: refsinfoty);
   function getitemsbycommit(const  acommit: msestring): refsitemarty;
 end;
 
 tmainmo = class(tmsedatamodule)
   optionsobj: trttistat;
   mainstat: tstatfile;
   openrepoact: taction;
   quitact: taction;
   repositoryfiledialog: tfiledialog;
   repoclosedact: tifiactionlinkcomp;
   repoloadedact: tifiactionlinkcomp;
   images: timagelist;
   repostatf: tstatfile;
   repoobj: trttistat;
   reporefreshedact: tifiactionlinkcomp;
   procedure quitexe(const sender: TObject);
   procedure openrepoexe(const sender: TObject);
   procedure getoptionsobjexe(const sender: TObject; var aobject: TObject);
   procedure repogetobj(const sender: TObject; var aobject: TObject);
   procedure reporeadexe(const sender: TObject; const reader: tstatreader);
   procedure repowriteexe(const sender: TObject; const writer: tstatwriter);
   procedure statfilemissingexe(const sender: tstatfile;
                   const afilename: msestring;
                   var astream: ttextstream; var aretry: Boolean);
  private
   frepo: filenamety;
   freporoot: filenamety;
   frepobase: filenamety;
   fopt: tmsegitoptions;
   frepostat: trepostat;
   fdirtree: tgitdirtreerootnode;
   ffilecache: tgitfilecache;
   frefsinfo: trefsitemlist;
   fgit: tgitcontroller;
   fgitstate: tgitstatecache;
   fpathstart: integer;
   fvaluecount: integer;
   ffilear: msegitfileitemarty;
   fremotesinfo: remoteinfoarty;
   factiveremote: msestring;
   fnam: filenamety;
   fkind: commitkindty;
   fmergehead: msestring;
   fmergemessage: msestring;
   frebasing: boolean;
   fbranches: localbranchinfoarty;
   factivebranch: msestring;
   fhasremote: boolean;
   fstashes: stashinfoarty;
   ftmpfiles: filenamearty;
   procedure setrepo(avalue: filenamety); //no const!
   procedure addfiles(var aitem: gitfileinfoty);
   procedure setactiveremote(const avalue: msestring);
   procedure updatecommit(var aitem: gitfileinfoty);
   function getactiveremotebranch(const aremote: msestring): msestring;
   procedure setactiveremotebranch(const aremote: msestring;
                            const abranch: msestring);
   procedure readremote(const aindex: integer; const avalue: msestring);
   function writeremote(const index: integer): msestring;
   function getlinkremotebranch(const aremote: msestring; 
                 const abranch: msestring): boolean;
   procedure setlinkremotebranch(const aremote: msestring;
                  const abranch: msestring; const avalue: boolean);
   function gethideremotebranch(const aremote: msestring;
                                 const abranch: msestring): boolean;
   procedure sethideremotebranch(const aremote: msestring;
                                 const abranch: msestring;
                   const avalue: boolean);
   function gethidelocalbranch(const abranch: msestring): boolean;
   procedure sethidelocalbranch(const abranch: msestring; const avalue: boolean);
   function gethideremote(const aremote: msestring): boolean;
   procedure sethideremote(const aremote: msestring; const avalue: boolean);
  protected
   function findremote(const aremote: msestring): premoteinfoty;
   function findremotebranch(const aremote: msestring;
               const abranch: msestring): premotebranchinfoty;
   function findlocalbranch(const abranch: msestring): plocalbranchinfoty;
   procedure updateoperation(const aoperation: commitkindty;
                  const afiles: filenamearty; const refreshed: boolean = true);
   procedure readmergeinfo;
   procedure closerepo;
   procedure loadrepo(avalue: filenamety; const clearconsole: boolean);
                       //no const
   procedure repoloaded;
   procedure repoclosed;
   function getorigin: msestring;
   procedure listfileitems(var aitem: gitstateinfoty);
   function  getfilelist(const aitems: gitdirtreenodearty;
                               const amask: array of gitstatedataty; 
                                out aroot: tgitdirtreenode): msegitfileitemarty;
   function encodepathparams(const adir: tgitdirtreenode;
                               const afiles: msegitfileitemarty): string;
   function getremote(const aremotetarget: msestring): msestring;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function execgitconsole(const acommand: string): boolean;
   function execconsole(const acommand: string): boolean;
                        //true if OK
   function getpath(const adir: tgitdirtreenode;
                           const afilename: filenamety): filenamety;
                    //returns path relative to reporoot
   function getfiles(const apath: filenamety): msegitfileitemarty;
   
   function checkoutbranch(const aname: msestring): boolean;
   function checkout(const atreeish: msestring;
                                const anode: tgitdirtreenode;
                                const afiles: msegitfileitemarty): boolean;

   function fetch(const aremote,aremotebranch: msestring): boolean;
   function pull(const aremote,aremotebranch: msestring): boolean;
   function push(const aremote,aremotebranch: msestring): boolean;
   function merge(const asourceref: msestring): boolean;
   function cherrypick(const acommits: msestringarty): boolean;

   function cancommit(const anode: tgitdirtreenode): boolean; overload;
   function cancommit(const aitems: gitdirtreenodearty): boolean; overload;
   function cancommit(const aitems: msegitfileitemarty): boolean; overload;
   function commit(const aitems: gitdirtreenodearty;
                           staged: boolean): boolean; overload;
   function commit(const anode: tgitdirtreenode;
                     const aitems: msegitfileitemarty;
                     const staged: boolean): boolean; overload;
   function commit(const afiles: filenamearty;
                          const amessage: msestring;
                          const akind: commitkindty): boolean; overload;
   function commitall: boolean;
   function mergecommit: boolean;
   function mergereset: boolean;
   function rebase(const aupstream: msestring): boolean;
   function rebasecontinue: boolean;
   function rebaseskip: boolean;
   function rebaseabort: boolean;
   function commitstaged(const anode: tgitdirtreenode;
              const afiles: filenamearty; const amessage: msestring): boolean;
   function canadd(const aitems: msegitfileitemarty): boolean; overload;
   function canadd(const anodes: gitdirtreenodearty): boolean; overload;
   function add(const anodes: gitdirtreenodearty): boolean; overload;
   function add(const anode: tgitdirtreenode;
                   const aitems: msegitfileitemarty): boolean; overload;
   function canrevert(const aitems: msegitfileitemarty): boolean; overload;
   function canrevert(const aitems: gitdirtreenodearty): boolean; overload;
   function revert(const aitems: gitdirtreenodearty): boolean;
   function revert(const afiles: filenamearty): boolean;
   function revert(const anode: tgitdirtreenode;
                   const aitems: msegitfileitemarty): boolean; overload;
   function canremove(const aitems: msegitfileitemarty): boolean; overload;
   function canremove(const aitems: gitdirtreenodearty): boolean; overload;
   function remove(const aitems: gitdirtreenodearty): boolean; overload;
   function remove(const afiles: filenamearty;
                               const untrack: boolean): boolean; overload;
   function remove(const anode: tgitdirtreenode;
                    const aitems: msegitfileitemarty): boolean; overload;
   function mergetoolcall(const afiles: filenamearty): boolean;
   function patchtoolcall(const afile: filenamety;
                const basecommit,theircommit: msestring;
                                       const isindex: boolean): boolean;
   procedure reload;
   procedure releasedirtree;
   procedure loadstash;
   procedure updatelocalbranchorder;
   procedure updateremotesorder;
   procedure updateremotebranchorder;
   function repoloaded: boolean;
   property repo: filenamety read frepo write setrepo;
                  //absolute path to repo dir
   property reporoot: filenamety read freporoot;
                  //absolut path to .git containing dir
   property repobase: filenamety read frepobase;
                  //relativepath reporoot -> repo
   property repostat: trepostat read frepostat;
   property hasremote: boolean read fhasremote;
   
   function merging: boolean;
   function rebasing: boolean;
   property mergehead: msestring read fmergehead;
   property mergemessage: msestring read fmergemessage;
   
   function renamebranch(const aremote: msestring; const oldname: msestring;
                 const newname: msestring): boolean;
   function deletebranch(const aremote: msestring;
                                      const abranch: msestring): boolean;
   function createbranch(const aremote: msestring;
                         const abranch: msestring;
                         const astartpoint: msestring): boolean;
   function createremote(const aremote: msestring; const afetch: msestring;
                                const apush: msestring): boolean;
   function changeremote(const aremote: msestring; const newname: msestring;
                         const afetch: msestring;
                         const apush: msestring): boolean;
   function deleteremote(const aremote: msestring): boolean;
   function setbranchtracking(
                 const abranch,aremote,aremotebranch: msestring): boolean;
   
   function createtmpfile(out dest: filenamety; const afilename: filenamety;
             const acaption: msestring; const acommit: msestring = '';
             const isindex: boolean = false): boolean;
   procedure deletetmpfiles;
   function branchbyname(const aname: msestring;
                           var ainfo: localbranchinfoty): boolean;
   
   property opt: tmsegitoptions read fopt;
   property dirtree: tgitdirtreerootnode read fdirtree;
   property stashes: stashinfoarty read fstashes;
   property activebranch: msestring read factivebranch;
   property branches: localbranchinfoarty read fbranches;
   property remotesinfo: remoteinfoarty read fremotesinfo;
   property activeremote: msestring read factiveremote write setactiveremote;
   property activeremotebranch[const aremote: msestring]: msestring read
                     getactiveremotebranch write setactiveremotebranch;
   property linkremotebranch[const aremote: msestring;
              const abranch: msestring]: boolean read getlinkremotebranch 
                              write setlinkremotebranch;
   property hideremotebranch[const aremote: msestring;
              const abranch: msestring]: boolean read gethideremotebranch 
                              write sethideremotebranch;
   property hideremote[const aremote: msestring]: boolean 
                         read gethideremote write sethideremote;
   property hidelocalbranch[const abranch: msestring]: boolean 
                         read gethidelocalbranch write sethidelocalbranch;
   function remotetarget: msestring;
   function remotetargetref: msestring;
   function remotetargetbranch: msestring;
   function stashsave(const amessage: msestring): boolean;
   function stashpop: boolean;
   property git: tgitcontroller read fgit;
   property refsinfo: trefsitemlist read frefsinfo;
 end;
 
var
 mainmo: tmainmo;

function checkname(const aname: msestring): boolean;

implementation

uses
 mainmodule_mfm,msefileutils,sysutils,msearrayutils,msesysintf,msesystypes,
 gitconsole,commitqueryform,revertqueryform,removequeryform,
 branchform,remotesform,mseformatstr,mseprocutils,msesysenv,main,filesform,
 dirtreeform,defaultstat;
  
const
 defaultfileicon = 0;
 modifiedfileoffset = 1;
 stagedfileoffset = 2;
 mergefileoffset = 3;
 
 untrackedfileicon = 6;
 addedfileoffset = 1;
 deletedmodifiedfileicon = 9;
 deletedfileicon = 10;

 defaultdiricon = 11;
 modifieddiroffset = 2;
 stageddiroffset = 4;
 mergediroffset = 6;
 
 untrackeddiricon = 23;

 remoteiconbase = 32; 
 mergependingicon = remoteiconbase+0;
 pushpendingicon = remoteiconbase+1;
 pushmergependingicon = remoteiconbase+2;
 pusconflicticon = remoteiconbase+3;
 mergeconflictpendingicon = remoteiconbase+4;
 mergeconflictpushpendingicon = remoteiconbase+5;

function checkname(const aname: msestring): boolean;
begin
 result:= trim(aname) <> '';
 if not result then begin
  showmessage('Invalid name "'+aname+'".','***ERROR***');
 end;
end;

function statetooriginicon(const astate: gitstatedataty): integer;
begin
 result:= -1;
 if mainmo.hasremote then begin
  if gist_pushconflict in astate.statey then begin
   result:= pusconflicticon;
  end
  else begin
   if gist_pushpending in astate.statey then begin
    if gist_mergepending in astate.statey then begin
     if gist_mergeconflictpending in astate.statey then begin
      result:= mergeconflictpushpendingicon;
     end
     else begin
      result:= pushmergependingicon;
     end;
    end
    else begin
     result:= pushpendingicon;
    end;
   end
   else begin
    if gist_mergeconflictpending in astate.statey then begin
     result:= mergeconflictpendingicon;
    end
    else begin
     if gist_mergepending in astate.statey then begin
      result:= mergependingicon;
     end
    end;
   end;
  end;
 end;
end;

function statetofileicon(const astate: gitstatedataty): integer;
var
 int1: integer;
begin
 int1:= defaultfileicon;
 if (gist_unmerged in astate.statex) or 
                        (gist_unmerged in astate.statey) then begin
  if (gist_unmerged in astate.statex) and 
                     (gist_unmerged in astate.statey) then begin
   int1:= int1+mergefileoffset;
  end;
 end
 else begin
  if gist_added in astate.statex then begin
   int1:= untrackedfileicon + addedfileoffset;
  end;
 end;
 if gist_modified in astate.statey then begin
  int1:= int1 + modifiedfileoffset;
 end;
 if gist_modified in astate.statex then begin
  int1:= int1 + stagedfileoffset;
 end;
{
 else begin
  if gist_modified in astate.statey then begin
   if gist_added in astate.statex then begin
    result:= addedmodifiedicon;
   end
   else begin
    result:= modifiedfileicon;
   end;
  end
  else begin
   if gist_modified in astate.statex then begin
    result:= stagedfileicon;
   end
   else begin
    if gist_added in astate.statex then begin
     result:= addedicon;
    end;
   end;
  end;
  if gist_untracked in astate.statey then begin
   result:= untrackedfileicon;
  end;
 end;
}
 if gist_untracked in astate.statey then begin
  int1:= untrackedfileicon;
 end;
 if  gist_deleted in astate.statey then begin
  int1:= deletedmodifiedfileicon;
 end;
 if (gist_deleted in astate.statex) then begin
  int1:= deletedfileicon;
 end;
 result:= int1;
end;

{ tmainmo }

constructor tmainmo.create(aowner: tcomponent);
begin
 fopt:= tmsegitoptions.create(self);
 frepostat:= trepostat.create;
 ffilecache:= tgitfilecache.create;
 fdirtree:= tgitdirtreerootnode.create;
 frefsinfo:= trefsitemlist.create;
 fgit:= tgitcontroller.create(nil);
 inherited;
end;

destructor tmainmo.destroy;
begin
 closerepo;
 fgit.free;
 frepostat.free;
 fopt.free;
 fdirtree.free;
 ffilecache.free;
 frefsinfo.free;
 inherited;
end;

procedure tmainmo.quitexe(const sender: TObject);
begin
 application.terminated:= true;
end;

procedure tmainmo.openrepoexe(const sender: TObject);
begin
 with repositoryfiledialog do begin
  if execute = mr_ok then begin
   repo:= controller.filename;
  end;
 end;
end;

procedure tmainmo.setrepo(avalue: filenamety);
begin
 loadrepo(avalue,true);
end;

procedure tmainmo.closerepo;
var
 ar1,ar2,ar3: msestringarty;
 int1,int2: integer;
begin
 fmergehead:= '';
 fmergemessage:= '';
 factivebranch:= '';
 fdirtree.clear;
 ffilecache.clear;
 freeandnil(fgitstate);
 frefsinfo.clear;
 deletetmpfiles;
 if frepo <> '' then begin
  ar1:= nil;
  ar2:= nil;
  ar3:= nil;
  for int1:= 0 to high(fremotesinfo) do begin
   with fremotesinfo[int1] do begin
    if hidden then begin
     additem(ar2,name);
    end;
    for int2:= 0 to high(branches) do begin
     with branches[int2] do begin
      if linklocalbranch then begin
       additem(ar1,'"'+name+'" "'+info.name+'"');
      end;
      if hidden then begin
       additem(ar3,'"'+name+'" "'+info.name+'"');
      end;
     end;
    end;
   end;
  end;
  frepostat.linkedremotebranches:= ar1;
  frepostat.hiddenremotes:= ar2;
  frepostat.hiddenremotebranches:= ar3;
  ar1:= nil;
  for int1:= 0 to high(fbranches) do begin
   with fbranches[int1] do begin
    if hidden then begin
     additem(ar1,info.name);
    end;
   end;
  end;
  frepostat.hiddenlocalbranches:= ar1;
  
  frepostat.activeremote:= activeremote;
  repostatf.writestat;
  fremotesinfo:= nil;
  fhasremote:= false;
  frepo:= '';
  freporoot:= '';
  frepobase:= '';
  frepostat.reset;
  repoclosed;
 end;
end;

procedure tmainmo.readmergeinfo;
var
 str1,str2: string;
begin
 if tryreadfiledatastring('.git/MERGE_HEAD',str1) then begin
  fmergehead:= utf8tostring(str1);
  if tryreadfiledatastring('.git/MERGE_MSG',str2) then begin
   fmergemessage:= utf8tostring(str2);
  end;
 end;
 frebasing:= finddir('.git/rebase-apply');
end;

procedure tmainmo.loadstash;
begin
 fgit.stashlist(fstashes);
end;

procedure tmainmo.loadrepo(avalue: filenamety; const clearconsole: boolean);
var
 int1,int2,int3,int4: integer;
 mstr1: msestring;
 ar1: msestringarty;
begin
 closerepo;
 if avalue <> '' then begin
  if not checkgit(avalue,freporoot) then begin
   showmessage(avalue+lineend+'is no git repository.','***ERROR***');
   abort;
  end;
  setcurrentdirmse(freporoot);
  application.beginwait;
  try
   readmergeinfo;
   if activeremote = '' then begin
    frepostat.activeremote:= 'origin';
   end
   else begin
    frepostat.activeremote:= activeremote;
   end;
   frepo:= filepath(avalue,fk_dir);
   frepobase:= copy(frepo,(length(freporoot)+1),bigint);
   fgit.remoteshow(fremotesinfo);
   fgit.branchshow(fbranches,factivebranch);
   int2:= 0;
   repostatf.readstat;
   for int1:= 0 to high(frepostat.flocalbranchorder) do begin
    for int3:= int2 to high(fbranches) do begin
     if fbranches[int3].info.name = frepostat.flocalbranchorder[int1] then begin
      moveitem(fbranches,int3,int2,sizeof(fbranches[0]));
      inc(int2);
      break;
     end;
    end;
   end;
   int2:= 0;
   for int1:= 0 to high(frepostat.fremotesorder) do begin
    for int3:= int2 to high(fremotesinfo) do begin
     if fremotesinfo[int3].name = frepostat.fremotesorder[int1] then begin
      moveitem(fremotesinfo,int3,int2,sizeof(fremotesinfo[0]));
      inc(int2);
      break;
     end;
    end;
   end;
   if frepostat.fremotebranchorder <> nil then begin
    int1:= 0;
    while int1 <= high(frepostat.fremotebranchorder) do begin
     mstr1:= frepostat.fremotebranchorder[int1];
     inc(int1);
     if (mstr1 <> '') and (mstr1[1] = ' ') then begin
      mstr1:= unquotestring(copy(mstr1,2,bigint),'"');
      for int2:= 0 to high(fremotesinfo) do begin
       if fremotesinfo[int2].name = mstr1 then begin
        with fremotesinfo[int2] do begin
         int4:= 0;
         while (int1 <= high(frepostat.fremotebranchorder)) do begin
          mstr1:= frepostat.fremotebranchorder[int1];
          if (mstr1 <> '') and (mstr1[1] = ' ') then begin
           break;
          end;
          inc(int1);
          mstr1:= unquotestring(mstr1,'"');
          for int3:= 0 to high(branches) do begin
           if branches[int3].info.name = mstr1 then begin
            moveitem(branches,int3,int4,sizeof(branches[0]));
            inc(int4);
            break;
           end;
          end;
         end;
        end;
        break;
       end;
      end;
     end;
    end;
   end;
   factiveremote:= '';
   if high(fremotesinfo) >= 0 then begin
    mstr1:= frepostat.activeremote;
    for int1:= 0 to high(fremotesinfo) do begin
     with fremotesinfo[int1] do begin
      if name = mstr1 then begin
       factiveremote:= mstr1;
      end;
      for int2:= 0 to high(branches) do begin
       frefsinfo.add(name,branches[int2].info);
      end;
     end;
    end;
   end;
   for int2:= 0 to high(fbranches) do begin
    frefsinfo.add('',fbranches[int2].info);
   end;
   for int2:= 0 to high(frepostat.flinkedremotebranches) do begin
    splitstringquoted(frepostat.flinkedremotebranches[int2],ar1,'"',' ');
    if high(ar1) = 1 then begin
     linkremotebranch[ar1[0],ar1[1]]:= true;
    end;
   end;
   for int2:= 0 to high(frepostat.fhiddenremotes) do begin
    hideremote[frepostat.fhiddenremotes[int2]]:= true;
   end;
   for int2:= 0 to high(frepostat.fhiddenremotebranches) do begin
    splitstringquoted(frepostat.fhiddenremotebranches[int2],ar1,'"',' ');
    if high(ar1) = 1 then begin
     hideremotebranch[ar1[0],ar1[1]]:= true;
    end;
   end;
   for int2:= 0 to high(frepostat.fhiddenlocalbranches) do begin
    hidelocalbranch[frepostat.fhiddenlocalbranches[int2]]:= true;
   end;
   fgit.status(frepo,getorigin,ffilecache,fgitstate);
   loadstash;
   fdirtree.loaddirtree(frepo);
   fdirtree.sort(false,true);
   fgit.lsfiles(frepo,false,false,false,true,fgitstate,ffilecache);
                      //list tracked files
   fdirtree.updatestate(freporoot,frepo,fgitstate,ffilecache);
   fgit.lsfiles(frepo,true,fopt.showuntrackeditems,fopt.showignoreditems,true,
                            fgitstate,ffilecache);
   if clearconsole then begin
    gitconsolefo.init;
   end;
  finally
   application.endwait;
  end;
  fhasremote:= high(fremotesinfo) >= 0;
 
  branchfo.dorefresh;
  branchfo.setactiveremotelog(repostat.activeremotelog,
                                 repostat.activeremotelogbranch);
  branchfo.setactivelocallog(repostat.activelocallogbranch);
  if (repostat.activelocallogbranch = '') and 
            ((repostat.activeremotelog = '') or
             (repostat.activeremotelogbranch = '')) then begin
   branchfo.setactivelocallog(activebranch);
  end;
  repoloaded;
 end;
end;

procedure tmainmo.reload;
begin
 loadrepo(frepo,false);
end;

procedure tmainmo.releasedirtree;
begin
 fdirtree:= tgitdirtreerootnode.create;
end;

procedure tmainmo.repoloaded;
begin
 repoloadedact.controller.execute;
end;

procedure tmainmo.repoclosed;
begin
 repoclosedact.controller.execute;
end;

procedure tmainmo.getoptionsobjexe(const sender: TObject; var aobject: TObject);
begin
 aobject:= fopt;
end;

procedure tmainmo.addfiles(var aitem: gitfileinfoty);
var
 n1: tmsegitfileitem;
// int1: integer;
begin
 with aitem.data.stateinfo do begin 
  if filename <> '' then begin
   n1:= tmsegitfileitem.create;
   additem(pointerarty(ffilear),pointer(n1),fvaluecount);
   n1.fcaption:= filename;
   n1.fgitstate:= data;
   n1.fimagenr:= statetofileicon(data);
  end;
 end;
end;

function tmainmo.getfiles(const apath: filenamety): msegitfileitemarty;
//var
// int1,int2: integer;
begin
{
 if fgit.lsfiles(apath,fopt.showuntrackeditems,fopt.showignoreditems,
                                   fgitstate,tmsegitfileitem,result) then begin
  for int1:= 0 to high(result) do begin
   with tmsegitfileitem(result[int1]) do begin
    int2:= defaultfileicon;
    if gist_modified in fstatey then begin
     int2:= modifiedfileicon;
    end;
    if gist_untracked in fstatey then begin
     int2:= untrackedfileicon;
    end;
    fimagenr:= int2;
   end;
  end;
 end;
 }
 fvaluecount:= 0;
 ffilear:= nil;
 ffilecache.iterate(fgitstate.getrepodir(apath),@addfiles);
 setlength(ffilear,fvaluecount);
 result:= ffilear;
 ffilear:= nil;
end;

procedure tmainmo.repogetobj(const sender: TObject; var aobject: TObject);
begin
 aobject:= frepostat;
end;

procedure tmainmo.setactiveremote(const avalue: msestring);
var
 int1: integer;
 bo1: boolean;
begin
 if avalue <> '' then begin
  bo1:= false;
  for int1:= 0 to high(fremotesinfo) do begin
   if fremotesinfo[int1].name = avalue then begin
    bo1:= true;
    break;
   end;
  end;
  if not bo1 then begin
   raise exception.create('Invalid remote.');
  end;
 end;
 factiveremote:= avalue;
end;

function tmainmo.getorigin: msestring;
var
 mstr1: msestring;
begin
 result:= '';
 if factiveremote <> '' then begin
  result:= factiveremote;
  mstr1:= activeremotebranch[factiveremote];
  if mstr1 <> '' then begin
   result:= result+'/'+mstr1;
  end;
 end;
end;

function tmainmo.getpath(const adir: tgitdirtreenode;
               const afilename: filenamety): filenamety;
begin
 result:= adir.gitbasepath+afilename;
end;

function tmainmo.cancommit(const anode: tgitdirtreenode): boolean;
begin
 result:= (anode <> nil) and checkcancommit(anode.fgitstate);
end;

function tmainmo.cancommit(const aitems: gitdirtreenodearty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= high(aitems) downto 0 do begin
  result:= cancommit(aitems[int1]);
  if result then begin
   break;
  end;
 end;
end;

procedure tmainmo.listfileitems(var aitem: gitstateinfoty);
var
 n1: tmsegitfileitem;
begin
 n1:= tmsegitfileitem.create(aitem,fpathstart);
 n1.fimagenr:= statetofileicon(n1.fgitstate);
 additem(pointerarty(ffilear),pointer(n1),fvaluecount);
end;

function tmainmo.getfilelist(const aitems: gitdirtreenodearty;
                                const amask: array of gitstatedataty; 
                                out aroot: tgitdirtreenode): msegitfileitemarty;
              
 procedure sca(const anode: tgitdirtreenode);
 var
  int1: integer;
 begin
  fgitstate.iterate(anode.gitbasepath,amask,@listfileitems);
  for int1:= 0 to anode.count-1 do begin
   sca(tgitdirtreenode(anode.fitems[int1]));
  end;
 end; //sca
 
var
 int1,int2,int3: integer;
 n2: tgitdirtreenode;
 bo1: boolean;
begin
 result:= nil;
 aroot:= nil;
 if high(aitems) >= 0 then begin
  aroot:= aitems[0];
  for int1:= 1 to high(aitems) do begin
   if aitems[int1].treelevel < aroot.treelevel then begin
    aroot:= aitems[int1];
   end;
  end;
  fvaluecount:= 0;
  ffilear:= nil;
  if (high(aitems) > 0) and (aroot.parent <> nil) then begin
   aroot:= tgitdirtreenode(aroot.parent);
  end;
  fpathstart:= length(aroot.gitbasepath)+1;
  for int1:= 0 to high(aitems) do begin
   n2:= aitems[int1];
   bo1:= true;
   for int2:= n2.treelevel-1 downto aroot.treelevel do begin
    n2:= tgitdirtreenode(n2.parent);
    for int3:= 0 to high(aitems) do begin
     if aitems[int3] = n2 then begin
      bo1:= false; //handled by parent
      break;
     end;
    end;
    if not bo1 then begin
     break;
    end;
   end; 
   if bo1 then begin
    sca(aitems[int1]);
   end;
  end;
  result:= copy(ffilear,0,fvaluecount);
  ffilear:= nil;
  setlength(ffilear,fvaluecount);
 end;
end;

function tmainmo.commit(const aitems: gitdirtreenodearty;
                                  staged: boolean): boolean;
 const
  mask1: gitstatedataty = (statex: []; statey : [gist_modified]);
  mask2: gitstatedataty = (statex: [gist_added]; statey : []);
  mask3: gitstatedataty = (statex: [gist_deleted]; statey : []);
  mask4: gitstatedataty = (statex: [gist_modified]; statey : []);
var
 ar1: msegitfileitemarty;
 n1: tgitdirtreenode;
 int1: integer;
begin 
 if high(aitems) <> 0 then begin
  staged:= false;
 end;
 if staged then begin
  ar1:= getfilelist(aitems,[mask2,mask3,mask4],n1);
 end
 else begin
  ar1:= getfilelist(aitems,[mask1,mask2,mask3,mask4],n1);
 end;
 try
  result:= commit(n1,ar1,staged);
 finally
  for int1:= high(ar1) downto 0 do begin
   ar1[int1].free;
  end;
 end;
//  end;
end;

function tmainmo.cancommit(const aitems: msegitfileitemarty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(aitems) do begin
  if checkcancommit(aitems[int1].fgitstate) then begin
   result:= true;
   break;
  end;
 end;
end;

function tmainmo.commit(const anode: tgitdirtreenode;
                         const aitems: msegitfileitemarty;
                         const staged: boolean): boolean;
begin
 result:= tcommitqueryfo.create(nil).exec(anode,aitems,staged);
end;

procedure updatecommitinfo(const akind: commitkindty;
                                          var adata: gitstatedataty);
begin
 with adata do begin
  case akind of
   ck_commit,ck_amend: begin
    statey:= (statey - cancommitstate) + [gist_pushpending];
    statex:= statex - cancommitstate;
   end;
   ck_stage: begin
    statex:= statex + statey * cancommitstate;
    statey:= statey - cancommitstate;
   end;
   ck_unstage: begin
    statey:= (statey + statex * cancommitstate)-[gist_deleted];
    if gist_added in statey then begin
     statey:= [gist_untracked];
    end;
    statex:= statex - cancommitstate;    
   end;
   ck_revert: begin
    statey:= statey - [gist_modified,gist_deleted];
   end;
   ck_modify: begin
    statey:= statey + [gist_modified];
   end;
   ck_remove: begin
    statex:= statex + [gist_deleted];
   end;
  end;
 end;
end;

procedure tmainmo.updatecommit(var aitem: gitfileinfoty);
begin
 if aitem.data.stateinfo.filename = fnam then begin
  updatecommitinfo(fkind,aitem.data.stateinfo.data);
 end;
end;

procedure tmainmo.updateoperation(const aoperation: commitkindty;
               const afiles: filenamearty; const refreshed: boolean = true);
var
 int1: integer;
 po1: pgitstatedataty;
 dir: filenamety;
begin
 for int1:= 0 to high(afiles) do begin
  po1:= fgitstate.find(afiles[int1]);
  if po1 <> nil then begin
   updatecommitinfo(aoperation,po1^);
  end;
  fkind:= aoperation;
  splitfilepath(afiles[int1],dir,fnam);
  ffilecache.iterate(dir,@updatecommit);
 end;
 if dirtree.owner <> nil then begin
  dirtree.owner.beginupdate;
 end;
 try
  dirtree.updatestate(reporoot,repo,fgitstate,ffilecache);
 finally
  if dirtree.owner <> nil then begin
   dirtree.owner.endupdate;
  end;
 end;
 if refreshed then begin
  reporefreshedact.controller.execute;
 end;
end;

function tmainmo.commit(const afiles: filenamearty;
                        const amessage: msestring;
                        const akind: commitkindty): boolean;
var
 str1: string;
begin
 result:= false;
 if (afiles <> nil) or (akind = ck_amend) then begin
  case akind of
   ck_stage: begin
    str1:= 'add ';
   end;
   ck_unstage: begin
    str1:= 'reset -q ';
   end;
   ck_amend,ck_commit: begin
    str1:= 'commit ';
    if amessage <> '' then begin
     str1:= str1 + '-m'+fgit.encodestringparam(amessage)+' ';
    end;
    if akind = ck_amend then begin
     str1:= str1 + '--amend ';
    end;
   end;
   else begin
    exit;
   end;
  end;
  result:= execgitconsole(str1+fgit.encodepathparams(afiles,true));
  if result then begin   
   fgit.branchshow(fbranches,factivebranch);
   updateoperation(akind,afiles);
  end;
 end;
end;

function tmainmo.commitstaged(const anode: tgitdirtreenode;
          const afiles: filenamearty;
          const amessage: msestring): boolean;
begin
 result:= execgitconsole('commit -m'+fgit.encodestringparam(amessage)+' '+
         fgit.encodepathparam(anode.gitpath,true));
 if result then begin   
  updateoperation(ck_commit,afiles);
 end;
end;

function tmainmo.commitall: boolean;
var
 ar1: gitdirtreenodearty;
begin
 setlength(ar1,1);
 ar1[0]:= fdirtree;
 result:= commit(ar1,false);
end;

function tmainmo.mergecommit: boolean;
var
 ar1: gitdirtreenodearty;
begin
 setlength(ar1,1);
 ar1[0]:= fdirtree;
 result:= commit(ar1,true);
end;

function tmainmo.mergereset: boolean;
begin
 result:= execgitconsole('reset --merge');
end;

function tmainmo.execgitconsole(const acommand: string): boolean;
begin
 result:= gitconsolefo.execgit(acommand);
 if not result then begin
  gitconsolefo.activate;
 end;
end;

function tmainmo.execconsole(const acommand: string): boolean;
begin
 result:= gitconsolefo.exec(acommand);
 if not result then begin
  gitconsolefo.activate;
 end;
end;

function tmainmo.canadd(const anodes: gitdirtreenodearty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= high(anodes) downto 0 do begin
  if gist_untracked in anodes[int1].fdirstate.statey then begin
   result:= true;
   break;
  end;
 end;
end;

function tmainmo.canadd(const aitems: msegitfileitemarty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= high(aitems) downto 0 do begin
  if gist_untracked in aitems[int1].fgitstate.statey then begin
   result:= true;
   break;
  end;
 end;
end;

function tmainmo.add(const anodes: gitdirtreenodearty): boolean;
var
 ar1: msestringarty;
 int1,int2: integer;
begin
 result:= false;
 setlength(ar1,length(anodes));
 int2:= 0;
 for int1:= 0 to high(ar1) do begin
  if gist_untracked in anodes[int1].fdirstate.statey then begin
   ar1[int2]:= anodes[int1].path(1);
   inc(int2);
  end;
 end;
 if int2 > 0 then begin
  setlength(ar1,int2);
  result:= execgitconsole('add '+fgit.encodepathparams(ar1,true));
 end;
end;

function tmainmo.add(const anode: tgitdirtreenode;
                              const aitems: msegitfileitemarty): boolean;
var
 ar1: msestringarty;
 int1,int2: integer;
begin
 result:= false;
 setlength(ar1,length(aitems));
 int2:= 0;
 for int1:= 0 to high(ar1) do begin
  if gist_untracked in aitems[int1].fgitstate.statey then begin
   ar1[int2]:= getpath(anode,aitems[int1].caption);
   inc(int2);
  end;
 end;
 if int2 > 0 then begin
  setlength(ar1,int2);
  result:= execgitconsole('add '+fgit.encodepathparams(ar1,true));
 end;
end;

function tmainmo.canrevert(const aitems: msegitfileitemarty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(aitems) do begin
  if checkcanrevert(aitems[int1].fgitstate) then begin
   result:= true;
   break;
  end;
 end;
end;

function tmainmo.canrevert(const aitems: gitdirtreenodearty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(aitems) do begin
  if checkcanrevert(aitems[int1].fgitstate) then begin
   result:= true;
   break;
  end;
 end;
end;

function tmainmo.revert(const anode: tgitdirtreenode;
               const aitems: msegitfileitemarty): boolean;
begin
 result:= trevertqueryfo.create(nil).exec(anode,aitems);
end;

function tmainmo.revert(const afiles: filenamearty): boolean;
begin
 result:= execgitconsole('checkout '+fgit.encodepathparams(afiles,true));
 if result then begin   
  updateoperation(ck_revert,afiles);
 end;
end;

function tmainmo.revert(const aitems: gitdirtreenodearty): boolean;
 const
  mask1: gitstatedataty = (statex: []; statey : [gist_modified]);
  mask2: gitstatedataty = (statex: []; statey : [gist_deleted]);
var
 ar1: msegitfileitemarty;
 n1: tgitdirtreenode;
 int1: integer;
begin 
 ar1:= getfilelist(aitems,[mask1,mask2],n1);
 try
  result:= revert(n1,ar1);
 finally
  for int1:= high(ar1) downto 0 do begin
   ar1[int1].free;
  end;
 end;
end;

function tmainmo.canremove(const aitems: msegitfileitemarty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(aitems) do begin
  if checkcanremove(aitems[int1].fgitstate) then begin
   result:= true;
   break;
  end;
 end;
end;

function tmainmo.canremove(const aitems: gitdirtreenodearty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(aitems) do begin
  if checkcanrevert(aitems[int1].fgitstate) then begin
   result:= true;
   break;
  end;
 end;
end;

function tmainmo.remove(const anode: tgitdirtreenode;
               const aitems: msegitfileitemarty): boolean;
begin
 result:= tremovequeryfo.create(nil).exec(anode,aitems);
end;

function tmainmo.remove(const afiles: filenamearty;
                                 const untrack: boolean): boolean;
var
 str1: string;
begin
 str1:= 'rm ';
 if untrack then begin
  str1:= str1 + '--cached ';
 end;
 result:= execgitconsole(str1+fgit.encodepathparams(afiles,true));
 if result then begin   
  updateoperation(ck_remove,afiles);
 end;
end;

function tmainmo.remove(const aitems: gitdirtreenodearty): boolean;
 const
  mask1: gitstatedataty = (statex: []; statey : []);
var
 ar1: msegitfileitemarty;
 n1: tgitdirtreenode;
 int1: integer;
begin 
 ar1:= getfilelist(aitems,[mask1],n1);
 try
  result:= remove(n1,ar1);
 finally
  for int1:= high(ar1) downto 0 do begin
   ar1[int1].free;
  end;
 end;
end;

function tmainmo.mergetoolcall(const afiles: filenamearty): boolean;
begin
 result:= execgitconsole('mergetool --no-prompt --tool='+
                            git.encodestringparam(opt.mergetool)+' '+
                              fgit.encodepathparams(afiles,true));
 if result then begin
  mainfo.reload;
 end;
end;

function tmainmo.patchtoolcall(const afile: filenamety;
                 const basecommit,theircommit: msestring;
                            const isindex: boolean): boolean;
var
 base,their: filenamety;
 ar1: msestringarty;
// ar2: msegitfileitemarty;
begin
 try
  result:= createtmpfile(base,afile,'BASE',basecommit,isindex);
  if result then begin
   result:= createtmpfile(their,afile,'THEIRS',theircommit,isindex);
  end;
  if not result then begin
   raise exception.create('Can not create temp files.');
  end;
  ar1:= parsecommandline(opt.patchtool);
  if ar1 <> nil then begin
   if high(ar1) = 0 then begin
    result:= execconsole(ar1[0]+' '+git.encodepathparam(base,true)+ ' '+
                           git.encodepathparam(their,true)+ ' '+
                           git.encodepathparam(afile,true));
   end
   else begin
    result:= execconsole(expandmacros(opt.patchtool,
                initmacros(['BASE','THEIRS','MINE'],[base,their,afile])));
   end;
   if result then begin
    setlength(ar1,1);
    ar1[0]:= afile;
    updateoperation(ck_modify,ar1,false);
    dirtreefo.syncfilesfo(false);
   end;
  end;
 finally
  deletetmpfiles;
 end;
end;

function tmainmo.getremote(const aremotetarget: msestring): msestring;
var
 po1: pmsechar;
begin
 result:= aremotetarget;
 if aremotetarget <> '' then begin
  po1:= msestrscan(pmsechar(pointer(aremotetarget)),' ');
  if po1 <> nil then begin
   result:= psubstr(pmsechar(pointer(aremotetarget)),po1);
  end;
 end;
end;

function tmainmo.fetch(const aremote,aremotebranch: msestring): boolean;
//var
// mstr1: msestring;
begin
// mstr1:= activeremote;
 if aremote = '' then begin
  result:= execgitconsole('fetch');
 end
 else begin
  result:= execgitconsole('fetch '+
      fgit.encodestring(aremote+' '+aremotebranch){+' '+
      fgit.encodestringparam('+refs/heads/*:refs/remotes/'+aremote+'/*')});
 end;
end;

function tmainmo.pull(const aremote,aremotebranch: msestring): boolean;
//var
// mstr1: msestring;
begin
// mstr1:= activeremote;
 if aremote = '' then begin
  result:= execgitconsole('pull');
 end
 else begin
  result:= execgitconsole('pull '+
   fgit.encodestring(aremote+' '+aremotebranch){+' '+
   fgit.encodestringparam('+refs/heads/*:refs/remotes/'+aremote+'/*')});
 end;
end;

function tmainmo.push(const aremote,aremotebranch: msestring): boolean;
var
 str1: string;
begin
 if aremote = '' then begin
  result:= execgitconsole('push');
 end
 else begin
  if activebranch = '' then begin
   result:= false;
  end
  else begin
   str1:= 'push '+fgit.encodestring(aremote)+' ';
   if aremotebranch <> '' then begin
    str1:= str1+fgit.encodestringparam(factivebranch+':'+aremotebranch);
   end
   else begin
    str1:= str1+fgit.encodestringparam(factivebranch);
   end;
   result:= execgitconsole(str1);
  end;
 end;
end;

function tmainmo.merge(const asourceref: msestring): boolean;
begin
 if asourceref = '' then begin
  result:= execgitconsole('merge FETCH_HEAD');
 end
 else begin
  result:= execgitconsole('merge '+fgit.encodestring(asourceref));
 end;
end;

function tmainmo.rebase(const aupstream: msestring): boolean;
begin
 result:= execgitconsole('rebase '+fgit.encodestringparam(aupstream));
end;

function tmainmo.rebasecontinue: boolean;
begin
 result:= execgitconsole('rebase --continue');
end;

function tmainmo.rebaseskip: boolean;
begin
 result:= execgitconsole('rebase --skip');
end;

function tmainmo.rebaseabort: boolean;
begin
 result:= execgitconsole('rebase --abort');
end;


function tmainmo.cherrypick(const acommits: msestringarty): boolean;
var
 int1: integer;
 str1: string;
begin
 result:= false;
 if acommits <> nil then begin
  str1:= '';
  for int1:= 0 to high(acommits) do begin
   str1:= str1+' '+fgit.encodestring(acommits[int1]);
  end;
  result:= execgitconsole('cherry-pick '+str1);
 end;
end;

function tmainmo.repoloaded: boolean;
begin
 result:= frepo <> '';
end;

function tmainmo.merging: boolean;
begin
 result:= fmergehead <> '';
end;

function tmainmo.rebasing: boolean;
begin
 result:= frebasing;
end;

function tmainmo.checkoutbranch(const aname: msestring): boolean;
begin
 result:= execgitconsole('checkout '+git.encodestringparam(aname));
end;

function tmainmo.checkout(const atreeish: msestring;
               const anode: tgitdirtreenode;
               const afiles: msegitfileitemarty): boolean;
begin
 result:= execgitconsole('checkout '+atreeish+' '+
                                 encodepathparams(anode,afiles));
end;

function tmainmo.renamebranch(const aremote: msestring;
               const oldname: msestring; const newname: msestring): boolean;
var
 int1,int2: integer;
begin
 if aremote = '' then begin
  result:= execgitconsole('branch -m '+fgit.encodestringparam(oldname)+' '+
                                   fgit.encodestringparam(newname));
  if result then begin
   for int1:= 0 to high(fbranches) do begin
    if fbranches[int1].info.name = oldname then begin
     fbranches[int1].info.name:= newname;
     break;
    end;
   end;
  end;
 end
 else begin
  result:= execgitconsole('push '+aremote+' '+
   fgit.encodestringparam(oldname)+':'+fgit.encodestringparam(newname)+
                  ' :'+fgit.encodestringparam(oldname));
  if result then begin
   for int2:= 0 to high(fremotesinfo) do begin
    if fremotesinfo[int2].name = aremote then begin
     with fremotesinfo[int2] do begin
      for int1:= 0 to high(branches) do begin
       if branches[int1].info.name = oldname then begin
        branches[int1].info.name:= newname;
        break;
       end;
      end;
     end;
     break;
    end;
   end;
  end;
 end;
end;

function tmainmo.deletebranch(const aremote: msestring;
               const abranch: msestring): boolean;
begin
 if aremote = '' then begin
  result:= execgitconsole('branch -d '+abranch);
 end
 else begin
  result:= execgitconsole('push '+aremote+' :'+abranch);
 end;
end;

function tmainmo.createbranch(const aremote: msestring;
               const abranch: msestring;
               const astartpoint: msestring): boolean;
begin
 if aremote = '' then begin
  result:= execgitconsole('branch '+fgit.encodestringparam(abranch)+' '+
                 fgit.encodestringparam(astartpoint));
 end
 else begin
  result:= execgitconsole('push '+aremote+' '+activebranch+':'+abranch);
 end;
end;

function tmainmo.getactiveremotebranch(const aremote: msestring): msestring;
var
 int1: integer;
begin
 result:= '';
 for int1:= 0 to high(fremotesinfo) do begin
  with fremotesinfo[int1] do begin
   if name = aremote then begin
    result:= activebranch;
    break;
   end;
  end;
 end;
end;

procedure tmainmo.setactiveremotebranch(const aremote: msestring;
               const abranch: msestring);
var
 int1: integer;
begin
 for int1:= 0 to high(fremotesinfo) do begin
  with fremotesinfo[int1] do begin
   if name = aremote then begin
    activebranch:= abranch;
    break;
   end;
  end;
 end;
end;

procedure tmainmo.readremote(const aindex: integer; const avalue: msestring);
var
 na,bra: msestring;
begin
 if decoderecord(avalue,[@na,@bra],'SS') then begin
  activeremotebranch[na]:= bra;
 end;
end;

function tmainmo.writeremote(const index: integer): msestring;
begin
 with fremotesinfo[index] do begin
  result:= encoderecord([name,activebranch]);
 end;
end;

procedure tmainmo.reporeadexe(const sender: TObject; const reader: tstatreader);
begin
 reader.readrecordarray('remotes',nil,@readremote);
end;

procedure tmainmo.repowriteexe(const sender: TObject;
               const writer: tstatwriter);
begin
 writer.writerecordarray('remotes',length(fremotesinfo),@writeremote);
end;

function tmainmo.remotetarget: msestring;
begin
 result:= activeremotebranch[activeremote];
 if result <> '' then begin
  result:= activeremote+' '+result;
 end
 else begin
  result:= activeremote;
 end;
end;

function tmainmo.remotetargetbranch: msestring;
begin
 result:= activeremotebranch[activeremote];
end;

function tmainmo.remotetargetref: msestring;
begin
 result:= activeremote;
 if result <> '' then begin
  result:= result+'/'+activeremotebranch[activeremote];
 end;
end;

function tmainmo.createremote(const aremote: msestring; const afetch: msestring;
               const apush: msestring): boolean;
begin
 result:= checkname(aremote);
 if result then begin
  result:= afetch <> '';
  if result then begin
   result:= execgitconsole('remote add '+fgit.encodestringparam(aremote)+' '+
                 fgit.encodestringparam(afetch));
   if result then begin
    if apush <> '' then begin
     result:= execgitconsole('remote set-url --push '+
                                fgit.encodestringparam(aremote)+' '+
                                 fgit.encodestringparam(apush));
    end;
   end;
  end;
 end;
end;

function tmainmo.changeremote(const aremote: msestring;
               const newname: msestring; const afetch: msestring;
               const apush: msestring): boolean;
begin
 result:= checkname(newname);
 if result then begin
  result:= afetch <> '';
  if result then begin
   if aremote <> newname then begin
    result:= execgitconsole('remote rename ' +
    fgit.encodestringparam(aremote)+' ' + fgit.encodestringparam(newname));
   end;
   if result then begin
    result:= execgitconsole('remote set-url '+
                      fgit.encodestringparam(newname)+' '+
                      fgit.encodestringparam(afetch));
    if result then begin
     result:= execgitconsole('remote set-url --push '+
                    fgit.encodestringparam(newname)+' '+
                      fgit.encodestringparam(apush));
    end;
   end;
  end;
 end;
end;

function tmainmo.deleteremote(const aremote: msestring): boolean;
begin
 result:= execgitconsole('remote rm '+fgit.encodestringparam(aremote));
end;

function tmainmo.encodepathparams(const adir: tgitdirtreenode;
               const afiles: msegitfileitemarty): string;
var
 ar1: msestringarty;
 fna1: filenamety;
 int1: integer;
begin
 if adir <> nil then begin
  fna1:= adir.gitpath;
  if afiles = nil then begin
   setlength(ar1,1);
   ar1[0]:= fna1;
  end
  else begin
   setlength(ar1,length(afiles));
   for int1:= 0 to high(ar1) do begin
    ar1[int1]:= fna1+afiles[int1].caption;
   end;
  end;  
 end;
 result:= fgit.encodepathparams(ar1,true);
end;

function tmainmo.findremotebranch(const aremote: msestring;
                                  const abranch: msestring): premotebranchinfoty;
var
 int1,int2: integer;          
begin
 result:= nil;
 for int1:= 0 to high(fremotesinfo) do begin
  with fremotesinfo[int1] do begin
   if name = aremote then begin
    for int2:= 0 to high(branches) do begin
     with branches[int2] do begin
      if info.name = abranch then begin
       result:= @branches[int2];
       break;
      end;
     end;
    end;
    break;
   end;
  end;
 end;
end;

function tmainmo.getlinkremotebranch(const aremote: msestring;
               const abranch: msestring): boolean;
var
 po1: premotebranchinfoty;
begin
 po1:= findremotebranch(aremote,abranch);
 result:= (po1 <> nil) and po1^.linklocalbranch;
end;

procedure tmainmo.setlinkremotebranch(const aremote: msestring;
               const abranch: msestring; const avalue: boolean);
var
 po1: premotebranchinfoty;
begin
 po1:= findremotebranch(aremote,abranch);
 if po1 <> nil then begin
  po1^.linklocalbranch:= avalue;
 end;
end;

function tmainmo.gethideremotebranch(const aremote: msestring;
               const abranch: msestring): boolean;
var
 po1: premotebranchinfoty;
begin
 po1:= findremotebranch(aremote,abranch);
 result:= (po1 <> nil) and po1^.hidden;
end;

procedure tmainmo.sethideremotebranch(const aremote: msestring;
               const abranch: msestring; const avalue: boolean);
var
 po1: premotebranchinfoty;
begin
 po1:= findremotebranch(aremote,abranch);
 if po1 <> nil then begin
  po1^.hidden:= avalue;
 end;
end;

function tmainmo.stashsave(const amessage: msestring): boolean;
begin
 if amessage = '' then begin
  result:= execgitconsole('stash save');
 end
 else begin
  result:= execgitconsole('stash save '+fgit.encodestringparam(amessage));
 end;
end;

function tmainmo.stashpop: boolean;
begin
 result:= execgitconsole('stash pop');
end;

procedure tmainmo.updatelocalbranchorder;
var
 int1: integer;
begin
 setlength(frepostat.flocalbranchorder,branchfo.localgrid.rowcount);
 for int1:= 0 to branchfo.localgrid.rowhigh do begin
  frepostat.flocalbranchorder[int1]:= branchfo.localbranch[int1];
 end;
end;

procedure tmainmo.updateremotesorder;
var
 int1: integer;
begin
 setlength(frepostat.fremotesorder,remotesfo.grid.rowcount);
 for int1:= 0 to remotesfo.grid.rowhigh do begin
  frepostat.fremotesorder[int1]:= remotesfo.remote[int1];
 end;
end;

procedure tmainmo.updateremotebranchorder;
var
 int1: integer;
 mstr1: msestring;
begin
 setlength(frepostat.fremotebranchorder,branchfo.remotegrid.rowcount);
 for int1:= 0 to high(frepostat.fremotebranchorder) do begin
  mstr1:= branchfo.remotebranch[int1];
  if mstr1 = '' then begin
   mstr1:= ' '+quotestring(branchfo.remote[int1],'"');
  end
  else begin
   mstr1:= quotestring(mstr1,'"');
  end;
  frepostat.fremotebranchorder[int1]:= mstr1;
 end;
end;

function tmainmo.createtmpfile(out dest: filenamety; 
               const afilename: filenamety;
               const acaption: msestring;
               const acommit: msestring = '';
               const isindex: boolean = false): boolean;
var
 fna1,fna2: filenamety;
begin
 fna2:= fileext(afilename);
 fna1:= afilename+'.'+acaption+'.'+inttostrmse(getpid);
 if fna2 <> '' then begin
  fna1:= fna1 + '.'+fna2;
 end;
 additem(ftmpfiles,fna1);
 if acommit = '' then begin
  result:= trycopyfile(afilename,fna1);
 end
 else begin
  if isindex then begin
   result:= fgit.cat(fna1,acommit);
  end
  else begin
   result:= fgit.cat(afilename,fna1,acommit);
  end;
 end;
 dest:= fna1;
end;

procedure tmainmo.deletetmpfiles;
var
 int1: integer;
begin
 for int1:= 0 to high(ftmpfiles) do begin
  trydeletefile(ftmpfiles[int1]);
 end;
 ftmpfiles:= nil;
end;

function tmainmo.gethidelocalbranch(const abranch: msestring): boolean;
var
 po1: plocalbranchinfoty;
begin
 po1:= findlocalbranch(abranch);
 result:= (po1 <> nil) and po1^.hidden;
end;

procedure tmainmo.sethidelocalbranch(const abranch: msestring;
                                                    const avalue: boolean);
var
 po1: plocalbranchinfoty;
begin
 po1:= findlocalbranch(abranch);
 if po1 <> nil then begin
  po1^.hidden:= avalue;
 end;
end;

function tmainmo.findlocalbranch(const abranch: msestring): plocalbranchinfoty;
var
 int1: integer;
begin
 result:= nil;
 for int1:= 0 to high(fbranches) do begin
  if fbranches[int1].info.name = abranch then begin
   result:= @fbranches[int1];
   break;
  end;
 end;
end;

function tmainmo.findremote(const aremote: msestring): premoteinfoty;
var
 int1: integer;
begin
 result:= nil;
 for int1:= 0 to high(fremotesinfo) do begin
  if fremotesinfo[int1].name = aremote then begin
   result:= @fremotesinfo[int1];
   break;
  end;
 end;
end;

function tmainmo.gethideremote(const aremote: msestring): boolean;
var
 po1: premoteinfoty;
begin
 po1:= findremote(aremote);
 result:= (po1 <> nil) and po1^.hidden;
end;

procedure tmainmo.sethideremote(const aremote: msestring;
               const avalue: boolean);
var
 po1: premoteinfoty;
begin
 po1:= findremote(aremote);
 if po1 <> nil then begin
  po1^.hidden:= avalue;
 end;
end;

function tmainmo.branchbyname(const aname: msestring;
               var ainfo: localbranchinfoty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(fbranches) do begin
  if fbranches[int1].info.name = aname then begin
   ainfo:= fbranches[int1];
   result:= true;
  end;
 end;
end;

function tmainmo.setbranchtracking(const abranch: msestring;
               const aremote: msestring;
               const aremotebranch: msestring): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(fbranches) do begin
  if fbranches[int1].info.name = abranch then begin
   with fbranches[int1] do begin
    if aremote = '' then begin
     result:= execgitconsole('config --unset branch.'+abranch+'.merge');
     if result then begin
      trackremote:= '';
      trackbranch:= '';
     end;
    end
    else begin
     result:= execgitconsole('branch --set-upstream '+abranch+ ' '+
                  aremote+'/'+aremotebranch);  
     if result then begin
      trackremote:= aremote;
      trackbranch:= aremotebranch;
     end;
    end;
   end;
  end;
 end;
end;

procedure tmainmo.statfilemissingexe(const sender: tstatfile;
               const afilename: msestring; var astream: ttextstream;
               var aretry: Boolean);
begin
 astream:= ttextstringcopystream.create(defaultstatdata);
end;

{ tmsegitfileitem }

constructor tmsegitfileitem.create;
begin
 fimagenr:= defaultfileicon;
 inherited;
end;

function tmsegitfileitem.getoriginicon: integer;
begin
 result:= statetooriginicon(fgitstate);
end;

{ tgitdirtreenode }

constructor tgitdirtreenode.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;
 fimagenr:= defaultdiricon;
end;

procedure tgitdirtreenode.setstate(const astate: gitstateinfoty;
               var aname: lmsestringty);
var
 n1: tgitdirtreenode;
 po1: pmsechar;
 lstr1: lmsestringty;
 int1: integer;
begin
 with fgitstate do begin
  statex:= statex + astate.data.statex;
  statey:= statey + astate.data.statey;
 end;
 lstr1:= aname;
 po1:= msestrings.strscan(aname,msechar('/'));
 if po1 <> nil then begin
  lstr1.len:= po1-lstr1.po;
 end;
 n1:= tgitdirtreenode(finditembycaption(lstr1));
 if n1 <> nil then begin
  if po1 <> nil then begin
   aname.po:= po1+1;
   aname.len:= aname.len - lstr1.len - 1;
   n1.setstate(astate,aname);
  end;
 end;
 int1:= defaultdiricon;
 with fgitstate do begin
  if [gist_modified,gist_deleted] * statey <> [] then begin
   int1:= int1 + modifieddiroffset;
  end
  else begin
   if statex * [gist_modified,gist_added,gist_deleted] <> [] then begin
    int1:= int1 + stageddiroffset;
   end;
  end;
  if (gist_unmerged in statex) or (gist_unmerged in statey) then begin
   int1:= int1 + mergediroffset;
  end;
  if (lstr1.len = 0) and (gist_untracked in statey) then begin //directory end
   int1:= untrackeddiricon;
  end;
 end;
 fimagenr:= int1;
end;

procedure tgitdirtreenode.drawimage(var alayoutinfo: listitemlayoutinfoty;
                                                      const acanvas: tcanvas);
var
 int1: integer;
begin
 alayoutinfo.imageextra.cx:= 16;
 inherited;
 if acanvas <> nil then begin
  int1:= getoriginicon;
  if int1 >= 0 then begin
   with alayoutinfo do begin
    fowner.imagelist.paint(acanvas,int1,imagerect,[al_left,al_ycentered]);
   end;
  end;
 end;
end;

function tgitdirtreenode.getoriginicon: integer;
begin
 result:= statetooriginicon(fgitstate);
end;

function tgitdirtreenode.gitpath: filenamety;
begin
 result:= path(1);
end;

function tgitdirtreenode.gitbasepath: filenamety;
begin
 result:= mainmo.repobase+gitpath;
end;

{ tgitdirtreerootnode }

destructor tgitdirtreerootnode.destroy;
begin
 inherited;
end;

procedure tgitdirtreerootnode.loaddirtree(const apath: filenamety);
begin
 froot:= true;
 caption:= getlastpathsection(apath); 
 inherited;
end;

procedure tgitdirtreerootnode.checkfiles(var afiles: filenamearty);
var
 int1: integer;
begin
 if froot then begin
  froot:= false;
  for int1:= 0 to high(afiles) do begin
   if pos('.git',afiles[int1]) = length(afiles[int1])-3 then begin
    deleteitem(afiles,int1);
    break;
   end;
  end;
 end;
end;

function tgitdirtreerootnode.createsubnode: ttreelistitem;
begin
 result:= tgitdirtreenode.create;
end;

procedure tgitdirtreerootnode.updatestate(const areporoot,arepo: filenamety;
               const astate: tgitstatecache; const afiles: tgitfilecache);
var
 lstr1: lmsestringty;
 int1,int2: integer;
 po1: pgitstateinfoty;
 
 procedure checkuntracked(const anode: tgitdirtreenode; const apath: filenamety);
 var
  int1: integer;
  n1: tgitdirtreenode;
 begin
  with anode,fdirstate do begin
   statex:= [];
   statey:= [];
   fgitstate.statex:= [];
   fgitstate.statey:= [];
   if afiles.find(apath) = nil then begin
    include(statey,gist_untracked);
    fimagenr:= untrackeddiricon;
   end
   else begin
    n1:= tgitdirtreenode(parent);
    while (n1 <> nil) and (gist_untracked in n1.fdirstate.statey) do begin
     exclude(n1.fdirstate.statey,gist_untracked);
     n1.fimagenr:= defaultdiricon;
     n1:= tgitdirtreenode(n1.parent);
    end;
   end;
   if fcount > 0 then begin
    for int1:= 0 to fcount - 1 do begin
     checkuntracked(tgitdirtreenode(fitems[int1]),
                     apath+tgitdirtreenode(fitems[int1]).fcaption+'/');
    end;
   end;
  end;
 end;
 
begin
 astate.reporoot:= areporoot;
 fgitstate.statex:= [];
 fgitstate.statey:= [];
 fimagenr:= defaultdiricon;
 int2:= length(arepo)-length(areporoot);
 checkuntracked(self,astate.getrepodir(arepo));
 for int1:= astate.count - 1 downto 0 do begin
  po1:= astate.next;
  lstr1.po:= pmsechar(po1^.filename)+int2;
  lstr1.len:= length(po1^.filename)-int2;
  setstate(po1^,lstr1);
 end;
end;

function tgitdirtreerootnode.getfiles(const apath: filenamety;
                    const gitstate: tgitstatecache): gitfileitemarty;
var
 dirstream: dirstreamty;
 info: fileinfoty;
 n1: tmsegitfileitem;
 int1: integer;
 po1: pgitstatedataty;
 pref: filenamety;
begin
 result:= nil;
 fillchar(dirstream,sizeof(dirstream),0);
 pref:= gitstate.getrepodir(apath);
 with dirstream.dirinfo do begin
  dirname:= filepath(apath);
  include:= [fa_all];
  exclude:= [fa_dir];
  if sys_opendirstream(dirstream) = sye_ok then begin
   int1:= 0;
   while sys_readdirstream(dirstream,info) do begin
    n1:= tmsegitfileitem.create;
    n1.fcaption:= info.name;
    po1:= gitstate.find(pref+info.name);
    if po1 <> nil then begin
     with n1 do begin
      fgitstate.statex:= po1^.statex;
      fgitstate.statey:= po1^.statey;
      fimagenr:= statetofileicon(fgitstate);
     {
      int2:= defaultfileicon;
      if gist_modified in fgitstate.statey then begin
       int2:= modifiedfileicon;
      end;
      if gist_untracked in fgitstate.statey then begin
       int2:= untrackedfileicon;
      end;
      fimagenr:= int2;
     }
     end;
    end;
    additem(pointerarty(result),n1,int1);
   end;
   sys_closedirstream(dirstream);
   setlength(result,int1);
  end;
 end;
end;

{ tmsegitoptions }

constructor tmsegitoptions.create(const aowner: tmainmo);
begin
 fowner:= aowner;
 fmaxlog:= defaultmaxlog;
 fdiffcontextn:= defaultdiffcontextn;
end;

procedure tmsegitoptions.setshowignoreditems(const avalue: boolean);
begin
 fshowignoreditems:= avalue;
 fshowuntrackeditems:= fshowuntrackeditems or avalue;
end;

procedure tmsegitoptions.setshowuntrackeditems(const avalue: boolean);
begin
 fshowuntrackeditems:= avalue;
 fshowignoreditems:= fshowignoreditems and avalue;
end;

function tmsegitoptions.getgitcommand: msestring;
begin
 result:= fowner.fgit.gitcommand;
end;

procedure tmsegitoptions.setgitcommand(const avalue: msestring);
begin
 fowner.fgit.gitcommand:= avalue;
end;

{ trepostat }

procedure trepostat.reset;
begin
 factiveremote:= '';
 factivelocallogbranch:= '';
 factiveremotelog:= '';
 factiveremotelogbranch:= '';
 fcommitmessages:= nil;
 fcommitmessage:= '';
end;

function trepostat.activelogcommit: msestring;
begin
 result:= '';
 if activelocallogbranch <> '' then begin
  result:= activelocallogbranch;
 end
 else begin
  if activeremotelog <> '' then begin
   result:= activeremotelog;
   if activeremotelogbranch <> '' then begin
    result:= result+'/'+activeremotelogbranch;
   end;
  end;
 end;
end;

{ trefsitemlist }

constructor trefsitemlist.create;
begin
 fnamelist:= trefsnamelist.create;
 inherited;
end;

destructor trefsitemlist.destroy;
begin
 fnamelist.free;
 inherited;
end;

procedure trefsitemlist.add(const aremote: msestring; const ainfo: refsinfoty);
var
 n1: trefsitem;
begin
 n1:= trefsitem.create;
 n1.remote:= aremote;
 n1.info:= ainfo;
 inherited add(ainfo.commit,n1);
 fnamelist.add(n1);
end;

procedure trefsitemlist.listitems(var item: objectmsestringdataty);
begin
 additem(pointerarty(fitems),item.data,fitemscount);
end;

function trefsitemlist.getitemsbycommit(const acommit: msestring): refsitemarty;
begin
 fitems:= nil;
 fitemscount:= 0;
 iterate(acommit,@listitems);
 setlength(fitems,fitemscount);
 result:= fitems;
 fitems:= nil;
end;

{ trefsnamelist }

constructor trefsnamelist.create;
begin
 inherited create(false);
end;

procedure trefsnamelist.add(const aitem: trefsitem);
begin
 inherited add(aitem.remote+':'+aitem.info.name,aitem);
end;

end.
