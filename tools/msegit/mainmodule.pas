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
   procedure drawimage(const acanvas: tcanvas); override;
  public
   constructor create; override;
 end;
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
   procedure drawimage(const acanvas: tcanvas); override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
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
                                        const astate: tgitstatecache);
   function getfiles(const apath: filenamety;
                          const gitstate: tgitstatecache): gitfileitemarty;
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
   fgitstate: tgitstatecache;
   procedure setrepo(avalue: filenamety); //no const!
  protected
   procedure closerepo;
   procedure loadrepo(const avalue: filenamety);
   procedure repoloaded;
   procedure repoclosed;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function getfiles(const apath: filenamety): gitfileitemarty;
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
 defaultfileicon = 10;
 modifiedfileicon = 6;
 untrackedfileicon = 14;
 mergependingicon = 16;
 pushpendingicon = 17;
 pushmergependingicon = 18;
 pusconflicticon = 19;
  
constructor tmainmo.create(aowner: tcomponent);
begin
 fopt:= tmsegitoptions.create;
 fdirtree:= tgitdirtreerootnode.create;
 fgit:= tgitcontroller.create(nil);
 inherited;
end;

destructor tmainmo.destroy;
begin
 closerepo;
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

procedure tmainmo.setrepo(avalue: filenamety);
begin
 loadrepo(avalue);
end;

procedure tmainmo.closerepo;
begin
 fdirtree.clear;
 freeandnil(fgitstate);
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
 setcurrentdir(freporoot);
 application.beginwait;
 try
  frepo:= filepath(avalue,fk_dir);
  fgit.status(frepo,fgitstate);
  fdirtree.loaddirtree(frepo);
  fdirtree.sort(false,true);
  fdirtree.updatestate(freporoot,frepo,fgitstate);
 finally
  application.endwait;
 end;
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

function tmainmo.getfiles(const apath: filenamety): gitfileitemarty;
var
 int1,int2: integer;
begin
// result:= fdirtree.getfiles(apath,fgitstate);
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
end;


{ tmsegitfileitem }

constructor tmsegitfileitem.create;
begin
 fimagenr:= defaultfileicon;
 inherited;
end;

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
 int1:= -1;
 if gist_pushconflict in fstatey then begin
  int1:= pusconflicticon;
 end
 else begin
  if gist_pushpending in fstatey then begin
   if gist_mergepending in fstatey then begin
    int1:= pushmergependingicon;
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
// inherited;
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
               const astate: tgitstatecache);
var
 lstr1: lmsestringty;
 int1,int2: integer;
 po1: pgitstateinfoty;
begin
 astate.reporoot:= areporoot;
 fstatex:= [];
 fstatey:= [];
 fimagenr:= defaultdiricon;
 int2:= length(arepo)-length(areporoot);
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

end.
