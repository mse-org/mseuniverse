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
 msesimplewidgets,msewidgets;

type
 tmsegitoptions = class
 end;

 tgitdirtreenode = class(tdirtreenode)
  private
   froot: boolean;
  protected
   procedure checkfiles(var afiles: filenamearty); override;
  public
   procedure loaddirtree(const apath: filenamety); override;
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
   fopt: tmsegitoptions;
   fdirtree: tgitdirtreenode;
   procedure setrepo(const avalue: filenamety);
  protected
   function checkgit(const adir: filenamety): boolean;
   procedure closerepo;
   procedure loadrepo(const avalue: filenamety);
   procedure repoloaded;
   procedure repoclosed;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   property repo: filenamety read frepo write setrepo;
   property opt: tmsegitoptions read fopt;
   property dirtree: tgitdirtreenode read fdirtree;
 end;
 
var
 mainmo: tmainmo;

implementation

uses
 mainmodule_mfm,msefileutils,sysutils,msearrayutils;
 
constructor tmainmo.create(aowner: tcomponent);
begin
 fopt:= tmsegitoptions.create;
 fdirtree:= tgitdirtreenode.create;
 inherited;
end;

destructor tmainmo.destroy;
begin
 fopt.free;
 fdirtree.free;
 inherited;
end;

procedure tmainmo.quitexe(const sender: TObject);
begin
 application.terminated:= true;
end;

function tmainmo.checkgit(const adir: filenamety): boolean;
begin
 result:= finddir(adir+'/.git'); //todo: better check
 if not result then begin
  showmessage(adir+lineend+'is no git repository.','***ERROR***');
 end;
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
 if frepo <> '' then begin
  frepo:= '';
  repoclosed;
 end;
end;

procedure tmainmo.loadrepo(const avalue: filenamety);
begin
 closerepo;
 if not checkgit(avalue) then begin
  abort;
 end;
 frepo:= avalue;
 fdirtree.loaddirtree(avalue);
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

procedure tgitdirtreenode.loaddirtree(const apath: filenamety);
begin
 froot:= true;
 inherited;
end;

procedure tgitdirtreenode.checkfiles(var afiles: filenamearty);
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

end.
