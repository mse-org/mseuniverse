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
   factiverepos: booleanarty;
   freponames: msestringarty;
  published
   property activerepos: booleanarty read factiverepos write factiverepos;
   property reponames: msestringarty read freponames write freponames;
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
   procedure setrepo(avalue: filenamety); //no const!
   procedure addfiles(var aitem: gitfileinfoty);
  protected
   procedure closerepo;
   procedure loadrepo(const avalue: filenamety);
   procedure repoloaded;
   procedure repoclosed;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function getfiles(const apath: filenamety): msegitfileitemarty;
   property repo: filenamety read frepo write setrepo;
   property reporoot: filenamety read freporoot;
   property opt: tmsegitoptions read fopt;
   property dirtree: tgitdirtreerootnode read fdirtree;
   property remotesinfo: remoteinfoarty read fremotesinfo;
   property git: tgitcontroller read fgit;
 end;
 
var
 mainmo: tmainmo;

implementation

uses
 mainmodule_mfm,msefileutils,sysutils,msearrayutils,msesysintf,msesystypes,
 gitconsole;
  
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

function statetooriginicon(const astate: gitstatesty): integer;
begin
 result:= -1;
 if gist_pushconflict in astate then begin
  result:= pusconflicticon;
 end
 else begin
  if gist_pushpending in astate then begin
   if gist_mergepending in astate then begin
    result:= pushmergependingicon;
   end
   else begin
    result:= pushpendingicon;
   end;
  end
  else begin
   if gist_mergepending in astate then begin
    result:= mergependingicon;
   end
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
 ar2: booleanarty;
 int1: integer;
begin
 fdirtree.clear;
 ffilecache.clear;
 freeandnil(fgitstate);
 if frepo <> '' then begin
  setlength(ar1,length(fremotesinfo));
  setlength(ar2,length(fremotesinfo));
  for int1:= 0 to high(fremotesinfo) do begin
   with fremotesinfo[int1] do begin
    ar1[int1]:= name;
    ar2[int1]:= active;
   end;
  end;
  frepostat.reponames:= ar1;
  frepostat.activerepos:= ar2;
  repostat.writestat;
  fremotesinfo:= nil;
  frepo:= '';
  freporoot:= '';
  repoclosed;
 end;
end;

procedure tmainmo.loadrepo(const avalue: filenamety);
var
 ar1: msestringarty;
 ar2: booleanarty;
 int1,int2: integer;
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
   repostat.readstat;
   frepo:= filepath(avalue,fk_dir);
   fgit.status(frepo,fgitstate);
   fdirtree.loaddirtree(frepo);
   fdirtree.sort(false,true);
   fgit.lsfiles(frepo,false,false,false,true,fgitstate,ffilecache);
   fdirtree.updatestate(freporoot,frepo,fgitstate,ffilecache);
   fgit.lsfiles(frepo,true,fopt.showuntrackeditems,fopt.showignoreditems,true,
                            fgitstate,ffilecache);
   fgit.remoteshow(fremotesinfo);
   ar1:= frepostat.reponames;
   ar2:= frepostat.activerepos;
   for int2:= 0 to arrayminhigh([pointer(ar1),pointer(ar2)]) do begin
    for int1:= 0 to high(fremotesinfo) do begin
     with fremotesinfo[int1] do begin
      if ar1[int2] = name then begin
       active:= ar2[int2];
      end;
     end;
    end;
   end;
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
    int1:= modifiedfileicon;
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


{ tmsegitfileitem }

constructor tmsegitfileitem.create;
begin
 fimagenr:= defaultfileicon;
 inherited;
end;

function tmsegitfileitem.getoriginicon: integer;
begin
 result:= statetooriginicon(fstatey);
end;
{
procedure tmsegitfileitem.drawimage(const acanvas: tcanvas);
var
 int1: integer;
begin
 inherited;
 int1:= -1;
 if gist_pushconflict in fstatey then begin
  int1:= pusconflicticon;
 end
 else begin
  if gist_pushpending in fstatey then begin
   if gist_mergepending in fstatey then begin
    int1:= pusconflicticon;
   end
   else begin
    int1:= pushpendingicon;
   end;
  end
  else begin
   if gist_mergepending in fstatey then begin
    int1:= mergependingicon;
   end
  end;
 end;
 if int1 >= 0 then begin
  with fowner.layoutinfopo^ do begin
   fowner.imagelist.paint(acanvas,int1,imagerect,[al_ycentered]);
  end;
 end;
end;
}
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
 result:= statetooriginicon(fstatey);
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
//  mstr1: msestring;
  n1: tgitdirtreenode;
 begin
  with anode do begin
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
//    if apath <> '' then begin
//     mstr1:= apath+'/';
//    end
//    else begin
//     mstr1:= '';
//    end;
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
