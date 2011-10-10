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

 tmsegitoptions = class
  private
   fshowuntrackeditems: boolean;
  published
   property showuntrackeditems: boolean read fshowuntrackeditems 
                                             write fshowuntrackeditems;
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
 end;

 tgitfileitem = class(tlistedititem)
 end;
 gitfileitemarty = array of tgitfileitem;
  
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
                                        const astate: gitstateinfoarty);
   function getfiles(const apath: filenamety): gitfileitemarty;
 end;
  
 tmainmo = class(tmsedatamodule)
   optionsstat: trttistat;
   mainstat: tstatfile;
   openrepoact: taction;
   quitact: taction;
   repositoryfiledialog: tfiledialog;
   repoclosedact: tifiactionlinkcomp;
   repoloadedact: tifiactionlinkcomp;
   procedure quitexe(const sender: TObject);
   procedure openrepoexe(const sender: TObject);
   procedure getoptionsobjexe(const sender: TObject; var aobject: TObject);
  private
   frepo: filenamety;
   freporoot: filenamety;
   fopt: tmsegitoptions;
   fdirtree: tgitdirtreerootnode;
   fgit: tgitcontroller;
   fgitstate: gitstateinfoarty;
   procedure setrepo(const avalue: filenamety);
  protected
   procedure closerepo;
   procedure loadrepo(const avalue: filenamety);
   procedure repoloaded;
   procedure repoclosed;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property repo: filenamety read frepo write setrepo;
   property opt: tmsegitoptions read fopt;
   property dirtree: tgitdirtreerootnode read fdirtree;
 end;
 
var
 mainmo: tmainmo;

implementation

uses
 mainmodule_mfm,msefileutils,sysutils,msearrayutils,msesysintf,msesystypes;

const
 defaultdiricon = 8;
 modifieddiricon = 4;
 untrackeddiricon = 12;
  
constructor tmainmo.create(aowner: tcomponent);
begin
 fopt:= tmsegitoptions.create;
 fdirtree:= tgitdirtreerootnode.create;
 fgit:= tgitcontroller.create(nil);
 inherited;
end;

destructor tmainmo.destroy;
begin
 fgit.free;
 fopt.free;
 fdirtree.free;
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

procedure tmainmo.setrepo(const avalue: filenamety);
begin
 loadrepo(avalue);
end;

procedure tmainmo.closerepo;
begin
 fdirtree.clear;
 if frepo <> '' then begin
  frepo:= '';
  freporoot:= '';
  repoclosed;
 end;
end;

procedure tmainmo.loadrepo(const avalue: filenamety);
begin
 closerepo; 
 if not checkgit(avalue,freporoot) then begin
  showmessage(avalue+lineend+'is no git repository.','***ERROR***');
  abort;
 end;
 frepo:= filepath(avalue,fk_dir);
 fgit.status(fgitstate,frepo);
 fdirtree.loaddirtree(frepo);
 fdirtree.sort(false,true);
 fdirtree.updatestate(freporoot,frepo,fgitstate);
 repoloaded;
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
 include(fstatex,astate.data.statex);
 include(fstatey,astate.data.statey);
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

{ tgitdirtreerootnode }

destructor tgitdirtreerootnode.destroy;
begin
 inherited;
end;

procedure tgitdirtreerootnode.loaddirtree(const apath: filenamety);
begin
 froot:= true;
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
               const astate: gitstateinfoarty);
var
 lstr1: lmsestringty;
 int1,int2: integer;
 po1: pgitstateinfoty;
begin
 fstatex:= [];
 fstatey:= [];
 fimagenr:= defaultdiricon;
 int2:= length(arepo)-length(areporoot);
 for int1:= 0 to high(astate) do begin
  po1:= @astate[int1];
  lstr1.po:= pmsechar(po1^.name)+int2;
  lstr1.len:= length(po1^.name)-int2;
  setstate(po1^,lstr1);
 end;
end;

function tgitdirtreerootnode.getfiles(const apath: filenamety): gitfileitemarty;
var
 dirstream: dirstreamty;
 info: fileinfoty;
 n1: tgitfileitem;
 int1: integer;
begin
 result:= nil;
 fillchar(dirstream,sizeof(dirstream),0);
 with dirstream.dirinfo do begin
  dirname:= filepath(apath);
  include:= [fa_all];
  exclude:= [fa_dir];
  if sys_opendirstream(dirstream) = sye_ok then begin
   int1:= 0;
   while sys_readdirstream(dirstream,info) do begin
    n1:= tgitfileitem.create(nil);
    n1.fcaption:= info.name;
    additem(pointerarty(result),n1,int1);
   end;
   sys_closedirstream(dirstream);
   setlength(result,int1);
  end;
 end;
end;

{ tmsegitoptions }

end.
