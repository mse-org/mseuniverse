{ MSEgit Copyright (c) 2011 by Martin Schreiber
   
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
//
// under construction
//
unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mseglob,mseapplication,mseclasses,msedatamodules,msestat,msestatfile,
 mserttistat,mseact,mseactions,mseifiglob,msebitmap,msedataedits,msedatanodes,
 mseedit,msefiledialog,msegraphics,msegraphutils,msegrids,msegui,mseguiglob,
 mselistbrowser,msemenus,msestrings,msesys,msetypes,mseificomp,mseificompglob,
 msesimplewidgets,msewidgets,msegitcontroller;

type
 tmsegitfileitem = class(tgitfileitem)
  protected
//   procedure drawimage(const acanvas: tcanvas); override;
  public
   constructor create; override;
   function getoriginicon: integer;
 end;
 msegitfileitemarty = array of tmsegitfileitem;

 tmainmo = class;
 
 tmsegitoptions = class
  private
   fowner: tmainmo;
   fshowuntrackeditems: boolean;
   fshowignoreditems: boolean;
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
 end;

 tgitdirtreenode = class(tdirtreenode)
  private
   fgitstate: gitstatedataty;
   fdirstate: gitstatedataty;
//   fstatex: gitstatesty;
//   fstatey: gitstatesty;
  protected
   procedure setstate(const astate: gitstateinfoty; var aname: lmsestringty);
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure drawimage(const acanvas: tcanvas); override;
   function getoriginicon: integer;
   function gitpath: filenamety;
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
//   freponames: msestringarty;
   fcommitmessage: msestring;
  published
   property activeremote: msestring read factiveremote write factiveremote;
   property commitmessages: msestringarty read fcommitmessages 
                                                 write fcommitmessages;
   property commitmessage: msestring read fcommitmessage write fcommitmessage;
//   property reponames: msestringarty read freponames write freponames
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
  private
   frepo: filenamety;
   freporoot: filenamety;
   fopt: tmsegitoptions;
   frepostat: trepostat;
   fdirtree: tgitdirtreerootnode;
   ffilecache: tgitfilecache;
   fgit: tgitcontroller;
   fgitstate: tgitstatecache;
   fpathstart: integer;
   fvaluecount: integer;
   ffilear: msegitfileitemarty;
   fremotesinfo: remoteinfoarty;
   factiveremote: msestring;
   fnam: filenamety;
   fkind: commitkindty;
   procedure setrepo(avalue: filenamety); //no const!
   procedure addfiles(var aitem: gitfileinfoty);
   procedure setactiveremote(const avalue: msestring);
   procedure updatecommit(var aitem: gitfileinfoty);
  protected
   procedure updateoperation(const aoperation: commitkindty;
                                                  const afiles: filenamearty);
   procedure closerepo;
   procedure loadrepo(avalue: filenamety); //no const
   procedure repoloaded;
   procedure repoclosed;
   function getorigin: msestring;
   procedure listfileitems(var aitem: gitstateinfoty);
   function  getfilelist(const aitems: gitdirtreenodearty;
                               const amask: array of gitstatedataty; 
                                out aroot: tgitdirtreenode): msegitfileitemarty;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function execgitconsole(const acommand: msestring): boolean;
                        //true if OK
   function getpath(const adir: tgitdirtreenode;
                           const afilename: filenamety): filenamety;
                    //returns path relative to reporoot
   function getfiles(const apath: filenamety): msegitfileitemarty;
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
   function mergetoolcall(const afiles: filenamearty): boolean;
   procedure reload;
   property repo: filenamety read frepo write setrepo;
   property repostat: trepostat read frepostat;
   property reporoot: filenamety read freporoot;
   property opt: tmsegitoptions read fopt;
   property dirtree: tgitdirtreerootnode read fdirtree;
   property remotesinfo: remoteinfoarty read fremotesinfo;
   property activeremote: msestring read factiveremote write setactiveremote;
   property git: tgitcontroller read fgit;
 end;
 
var
 mainmo: tmainmo;

implementation

uses
 mainmodule_mfm,msefileutils,sysutils,msearrayutils,msesysintf,msesystypes,
 gitconsole,commitqueryform,revertqueryform;
  
const
 defaultfileicon = 0;
 modifiedfileoffset = 1;
 stagedfileoffset = 2;
 mergefileoffset = 3;
 
// modifiedfileicon = 15;
 untrackedfileicon = 6;
 addedfileoffset = 1;
// mergefileicon = 24;
// mergeconflictfileicon = 25;
// stagedfileicon = 16;
// stagedconflictfileicon = 19;

 defaultdiricon = 9;
 modifieddiroffset = 2;
 stageddiroffset = 4;
 mergediroffset = 6;
 untrackeddiricon = 21;
 
// unmergeddiricon = 26;
// modifieddiricon = 4;
// modifiedunmergeddiricon = 28;
// untrackeddiricon = 12;
 mergependingicon = 30;
 pushpendingicon = 31;
 pushmergependingicon = 32;
 pusconflicticon = 33;
 mergeconflictpendingicon = 34;
 mergeconflictpushpendingicon = 35;
// addedicon = 22;
// addedmodifiedicon = 23;
{
const
 defaultfileicon = 10;
 modifiedfileicon = 6;
 untrackedfileicon = 14;
 mergefileicon = 24;
 mergeconflictfileicon = 25;
 stagedfileicon = 30;
 stagedconflictfileicon = 31;

 defaultdiricon = 8;
 unmergeddiricon = 26;
 modifieddiricon = 4;
 modifiedunmergeddiricon = 28;
 untrackeddiricon = 12;
 mergependingicon = 16;
 pushpendingicon = 17;
 pushmergependingicon = 18;
 pusconflicticon = 19;
 mergeconflictpendingicon = 20;
 mergeconflictpushpendingicon = 21;
 addedicon = 22;
 addedmodifiedicon = 23;
}

function statetooriginicon(const astate: gitstatedataty): integer;
begin
 result:= -1;
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
//   int1:= int1 + modifiedfileoffset;
//   result:= mergeconflictfileicon;
//  end
//  else begin
//   result:= mergefileicon;
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
 result:= int1;
end;

{ tmainmo }

constructor tmainmo.create(aowner: tcomponent);
begin
 fopt:= tmsegitoptions.create(self);
 frepostat:= trepostat.create;
 ffilecache:= tgitfilecache.create;
 fdirtree:= tgitdirtreerootnode.create;
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
 loadrepo(avalue);
end;

procedure tmainmo.closerepo;
var
 ar1: msestringarty;
// ar2: booleanarty;
 int1: integer;
begin
 fdirtree.clear;
 ffilecache.clear;
 freeandnil(fgitstate);
 if frepo <> '' then begin
  setlength(ar1,length(fremotesinfo));
//  setlength(ar2,length(fremotesinfo));
  for int1:= 0 to high(fremotesinfo) do begin
   with fremotesinfo[int1] do begin
    ar1[int1]:= name;
//    ar2[int1]:= active;
   end;
  end;
//  frepostat.reponames:= ar1;
  frepostat.activeremote:= activeremote;
  repostatf.writestat;
  fremotesinfo:= nil;
  frepo:= '';
  freporoot:= '';
  repoclosed;
 end;
end;

procedure tmainmo.loadrepo(avalue: filenamety);
var
 int1{,int2}: integer;
 mstr1: msestring;
// bo1: boolean;
begin
 closerepo;
 if avalue <> '' then begin
  if not checkgit(avalue,freporoot) then begin
   showmessage(avalue+lineend+'is no git repository.','***ERROR***');
   abort;
  end;
  msefileutils.setcurrentdir(freporoot);
  application.beginwait;
  try
   frepostat.activeremote:= 'origin';
   repostatf.readstat;
   frepo:= filepath(avalue,fk_dir);
   fgit.remoteshow(fremotesinfo);
   factiveremote:= '';
   if high(fremotesinfo) >= 0 then begin
    mstr1:= frepostat.activeremote;
    for int1:= 0 to high(fremotesinfo) do begin
     if fremotesinfo[int1].name = mstr1 then begin
      factiveremote:= mstr1;
      break;
     end;
    end;
   end;
   fgit.status(frepo,getorigin,ffilecache,fgitstate);
   fdirtree.loaddirtree(frepo);
   fdirtree.sort(false,true);
   fgit.lsfiles(frepo,false,false,false,true,fgitstate,ffilecache);
                      //list tracked files
   fdirtree.updatestate(freporoot,frepo,fgitstate,ffilecache);
   fgit.lsfiles(frepo,true,fopt.showuntrackeditems,fopt.showignoreditems,true,
                            fgitstate,ffilecache);
   gitconsolefo.init;
  finally
   application.endwait;
  end;
  repoloaded;
 end;
end;

procedure tmainmo.reload;
begin
 loadrepo(freporoot);
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
begin
 result:= '';
 if factiveremote <> '' then begin
  result:= factiveremote + '/master';
 end;
end;

function tmainmo.getpath(const adir: tgitdirtreenode;
               const afilename: filenamety): filenamety;
begin
 result:= adir.path(1)+afilename;
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
  fgitstate.iterate(anode.path(1),amask,@listfileitems);
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
  fpathstart:= length(aroot.path(1))+1;
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
  mask3: gitstatedataty = (statex: [gist_modified]; statey : []);
var
 ar1: msegitfileitemarty;
 n1: tgitdirtreenode;
 int1: integer;
begin 
 if high(aitems) <> 0 then begin
  staged:= false;
 end;
 if staged then begin
  ar1:= getfilelist(aitems,[mask2,mask3],n1);
 end
 else begin
  ar1:= getfilelist(aitems,[mask1,mask2,mask3],n1);
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
    statey:= (statey + statex * cancommitstate);
    if gist_added in statey then begin
     statey:= [gist_untracked];
    end;
    statex:= statex - cancommitstate;    
   end;
   ck_revert: begin
    statey:= statey - [gist_modified];
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
                                                  const afiles: filenamearty);
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
 reporefreshedact.controller.execute;
end;

function tmainmo.commit(const afiles: filenamearty;
                        const amessage: msestring;
                        const akind: commitkindty): boolean;
var
 mstr1: msestring;
begin
 result:= false;
 if afiles <> nil then begin
  case akind of
   ck_stage: begin
    mstr1:= 'add ';
   end;
   ck_unstage: begin
    mstr1:= 'reset -q ';
   end;
   ck_amend,ck_commit: begin
    mstr1:= 'commit ';
    if amessage <> '' then begin
     mstr1:= mstr1 + '-m'+fgit.encodestringparam(amessage)+' ';
    end;
    if akind = ck_amend then begin
     mstr1:= mstr1 + '--amend ';
    end;
   end;
   else begin
    exit;
   end;
  end;
  result:= execgitconsole(mstr1+fgit.encodepathparams(afiles,true));
  if result then begin   
   updateoperation(akind,afiles);
  end;
 end;
end;

function tmainmo.commitstaged(const anode: tgitdirtreenode;
          const afiles: filenamearty;
          const amessage: msestring): boolean;
begin
 result:= execgitconsole('commit -m'+fgit.encodestringparam(amessage)+' '+
         anode.gitpath);
 if result then begin   
  updateoperation(ck_commit,afiles);
 end;
end;

function tmainmo.execgitconsole(const acommand: msestring): boolean;
begin
 result:= gitconsolefo.execgit(acommand);
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
var
 ar1: msegitfileitemarty;
 n1: tgitdirtreenode;
 int1: integer;
begin 
 ar1:= getfilelist(aitems,[mask1],n1);
 try
  result:= revert(n1,ar1);
 finally
  for int1:= high(ar1) downto 0 do begin
   ar1[int1].free;
  end;
 end;
end;

function tmainmo.mergetoolcall(const afiles: filenamearty): boolean;
begin
 result:= execgitconsole('mergetool --no-prompt '+
                              fgit.encodepathparams(afiles,true));
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
  if gist_modified in statey then begin
   int1:= int1 + modifieddiroffset;
  end
  else begin
   if gist_modified in statex then begin
    int1:= int1 + stageddiroffset;
   end;
  end;
  if (gist_unmerged in statex) or (gist_unmerged in statey) then begin
   int1:= int1 + mergediroffset;
  end;
  
 {
  if (gist_unmerged in statex) or (gist_unmerged in statey) then begin
   if gist_modified in statey then begin
    int1:= modifiedunmergeddiricon;
   end
   else begin
    int1:= unmergeddiricon;
   end;
  end
  else begin
   if (gist_modified in statey) or (gist_modified in statex) then begin
    int1:= modifieddiricon;
   end;
  end;
 }
  if (lstr1.len = 0) and (gist_untracked in statey) then begin //directory end
   int1:= untrackeddiricon;
  end;
 end;
 fimagenr:= int1;
end;

procedure tgitdirtreenode.drawimage(const acanvas: tcanvas);
var
 int1: integer;
begin
 inherited;
 int1:= getoriginicon;
 if int1 >= 0 then begin
  with fowner.layoutinfopo^ do begin
   fowner.imagelist.paint(acanvas,int1,imagerect,[al_left,al_ycentered]);
  end;
 end;
// inherited;
end;

function tgitdirtreenode.getoriginicon: integer;
begin
 result:= statetooriginicon(fgitstate);
end;

function tgitdirtreenode.gitpath: filenamety;
begin
 result:= path(1);
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

end.
