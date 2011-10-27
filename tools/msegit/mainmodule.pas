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

 tmsegitoptions = class
  private
   fshowuntrackeditems: boolean;
   fshowignoreditems: boolean;
   procedure setshowignoreditems(const avalue: boolean);
   procedure setshowuntrackeditems(const avalue: boolean);
  published
   property showuntrackeditems: boolean read fshowuntrackeditems 
                                             write setshowuntrackeditems;
   property showignoreditems: boolean read fshowignoreditems 
                                             write setshowignoreditems;
 end;

 tgitdirtreenode = class(tdirtreenode)
  private
   fstatex: gitstatesty;
   fstatey: gitstatesty;
  protected
   procedure setstate(const astate: gitstateinfoty; var aname: lmsestringty);
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure drawimage(const acanvas: tcanvas); override;
   function getoriginicon: integer;
 end;

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
//   freponames: msestringarty;
  published
   property activeremote: msestring read factiveremote write factiveremote;
//   property reponames: msestringarty read freponames write freponames;
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
   repostat: tstatfile;
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
   fvaluecount: integer;
   ffilear: msegitfileitemarty;
   fremotesinfo: remoteinfoarty;
   factiveremote: msestring;
   fnam: filenamety;
   procedure setrepo(avalue: filenamety); //no const!
   procedure addfiles(var aitem: gitfileinfoty);
   procedure setactiveremote(const avalue: msestring);
   procedure updatecommit(var aitem: gitfileinfoty);
  protected
   procedure closerepo;
   procedure loadrepo(const avalue: filenamety);
   procedure repoloaded;
   procedure repoclosed;
   function getorigin: msestring;
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
   function cancommit(const aitems: msegitfileitemarty): boolean; overload;
   procedure commit(const anode: tgitdirtreenode); overload;
   procedure commit(const anode: tgitdirtreenode;
                         const aitems: msegitfileitemarty); overload;
   function commit(const afiles: filenamearty;
                          const amessage: msestring): boolean; overload;
   property repo: filenamety read frepo write setrepo;
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
 gitconsole,commitqueryform;
  
const
 defaultdiricon = 8;
 modifieddiricon = 4;
 untrackeddiricon = 12;
 defaultfileicon = 10;
 modifiedfileicon = 6;
 untrackedfileicon = 14;
 mergependingicon = 16;
 pushpendingicon = 17;
 pushmergependingicon = 18;
 pusconflicticon = 19;
 mergeconflictpendingicon = 20;
 mergeconflictpushpendingicon = 21;
 addedicon = 22;
 addedmodifiedicon = 23;

function statetooriginicon(const astatex,astatey: gitstatesty): integer;
begin
 result:= -1;
 if gist_pushconflict in astatey then begin
  result:= pusconflicticon;
 end
 else begin
  if gist_pushpending in astatey then begin
   if gist_mergepending in astatey then begin
    if gist_mergeconflictpending in astatey then begin
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
   if gist_mergeconflictpending in astatey then begin
    result:= mergeconflictpendingicon;
   end
   else begin
    if gist_mergepending in astatey then begin
     result:= mergependingicon;
    end
   end;
  end;
 end;
end;

{ tmainmo }

constructor tmainmo.create(aowner: tcomponent);
begin
 fopt:= tmsegitoptions.create;
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
  repostat.writestat;
  fremotesinfo:= nil;
  frepo:= '';
  freporoot:= '';
  repoclosed;
 end;
end;

procedure tmainmo.loadrepo(const avalue: filenamety);
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
  setcurrentdir(freporoot);
  application.beginwait;
  try
   frepostat.activeremote:= 'origin';
   repostat.readstat;
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
 int1: integer;
begin
 with aitem.data do begin 
  if filename <> '' then begin
   n1:= tmsegitfileitem.create;
   additem(pointerarty(ffilear),pointer(n1),fvaluecount);
   n1.fcaption:= filename;
   n1.fstatex:= statex;
   n1.fstatey:= statey;
   int1:= defaultfileicon;
   if gist_modified in statey then begin
    if gist_added in statex then begin
     int1:= addedmodifiedicon;
    end
    else begin
     int1:= modifiedfileicon;
    end;
   end
   else begin
    if gist_added in statex then begin
     int1:= addedicon;
    end;
   end;
   if gist_untracked in statey then begin
    int1:= untrackedfileicon;
   end;
   n1.fimagenr:= int1;
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
 result:= (anode <> nil) and (gist_modified in anode.fstatey);
end;

procedure tmainmo.commit(const anode: tgitdirtreenode);
begin
end;

function tmainmo.cancommit(const aitems: msegitfileitemarty): boolean;
var
 int1: integer;
begin
 result:= false;
 for int1:= 0 to high(aitems) do begin
  if gist_modified in aitems[int1].fstatey then begin
   result:= true;
   break;
  end;
 end;
end;

procedure tmainmo.commit(const anode: tgitdirtreenode;
                                   const aitems: msegitfileitemarty);
var
 ar1: msegitfileitemarty;
begin
 ar1:= tcommitqueryfo.create(nil).exec(anode,aitems);
end;

procedure tmainmo.updatecommit(var aitem: gitfileinfoty);
begin
 with aitem.data do begin
  if filename = fnam then begin
   statey:= (statey - [gist_modified]) + [gist_pushpending];
  end;
 end;
end;

function tmainmo.commit(const afiles: filenamearty;
                                     const amessage: msestring): boolean;
var
 int1: integer;
 po1: pgitstatedataty;
 po2: pgitfiledataty;
 dir: filenamety;
begin
 result:= false;
 if afiles <> nil then begin
  result:= execgitconsole('commit -m'+fgit.encodestringparam(amessage)+' '+
                                          fgit.encodepathparams(afiles,true));
  if result then begin
   for int1:= 0 to high(afiles) do begin
    po1:= fgitstate.find(afiles[int1]);
    if po1 <> nil then begin
     po1^.statey:= (po1^.statey - [gist_modified]) + [gist_pushpending];
    end;
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
 end;
end;

function tmainmo.execgitconsole(const acommand: msestring): boolean;
begin
 result:= gitconsolefo.execgit(acommand);
end;


{ tmsegitfileitem }

constructor tmsegitfileitem.create;
begin
 fimagenr:= defaultfileicon;
 inherited;
end;

function tmsegitfileitem.getoriginicon: integer;
begin
 result:= statetooriginicon(fstatex,fstatey);
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
 fstatex:= fstatex + astate.data.statex;
 fstatey:= fstatey + astate.data.statey;
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
 if gist_modified in fstatey then begin
  int1:= modifieddiricon;
 end;
 if (lstr1.len = 0) and (gist_untracked in fstatey) then begin //directory end
  int1:= untrackeddiricon;
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
 result:= statetooriginicon(fstatex,fstatey);
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
  with anode do begin
   fstatex:= [];
   fstatey:= [];
   if afiles.find(apath) = nil then begin
    include(fstatey,gist_untracked);
    fimagenr:= untrackeddiricon;
   end
   else begin
    n1:= tgitdirtreenode(parent);
    while (n1 <> nil) and (gist_untracked in n1.fstatey) do begin
     exclude(n1.fstatey,gist_untracked);
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
 fstatex:= [];
 fstatey:= [];
 fimagenr:= defaultdiricon;
 int2:= length(arepo)-length(areporoot);
 checkuntracked(self,astate.getrepodir(arepo));
 for int1:= astate.count - 1 downto 0 do begin
  po1:= astate.next;
  lstr1.po:= pmsechar(po1^.name)+int2;
  lstr1.len:= length(po1^.name)-int2;
  setstate(po1^,lstr1);
 end;
end;

function tgitdirtreerootnode.getfiles(const apath: filenamety;
                    const gitstate: tgitstatecache): gitfileitemarty;
var
 dirstream: dirstreamty;
 info: fileinfoty;
 n1: tmsegitfileitem;
 int1,int2: integer;
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
      fstatex:= po1^.statex;
      fstatey:= po1^.statey;
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
    additem(pointerarty(result),n1,int1);
   end;
   sys_closedirstream(dirstream);
   setlength(result,int1);
  end;
 end;
end;

{ tmsegitoptions }

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

{ trepostat }
end.
