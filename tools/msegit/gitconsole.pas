{ MSEgit Copyright (c) 2011-2014 by Martin Schreiber
   
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
unit gitconsole;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msedispwidgets,
 msestrings,msetypes,msedataedits,mseedit,msegrids,mseifiglob,msewidgetgrid,
 mseterminal,msesplitter;

type
 tgitconsolefo = class(tdockform)
   grid: twidgetgrid;
   termed: tterminal;
   popupmen: tpopupmenu;
   procedure sendtextexe(const sender: TObject; var atext: msestring;
                   var donotsend: Boolean);
   procedure procfiexe(const sender: TObject);
   procedure clearexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu);
  private
   fexecgitwaiting: boolean;
   fpath: filenamety;
  protected
   procedure refreshprompt;
   function prompt: msestring;
   function doexec(const acommand: msestring; const agit: boolean): boolean;
  public
   procedure synctodirtree(const apath: filenamety);
   procedure init;
   procedure clear;
   function execgit(const acommand: msestring): boolean;
   function exec(const acommand: msestring): boolean;
 end;
 
var
 gitconsolefo: tgitconsolefo;

implementation
uses
 gitconsole_mfm,mainmodule,msefileutils,main,gitdirtreeform;

{ tgitconsolefo }

function tgitconsolefo.prompt: msestring;
begin
 result:= '(git)'+fpath+'> ';
end;

procedure tgitconsolefo.synctodirtree(const apath: filenamety);
begin
 fpath:= apath;
 refreshprompt;
end;

procedure tgitconsolefo.refreshprompt;
begin
 termed.prompt:= prompt;
end;

procedure tgitconsolefo.sendtextexe(const sender: TObject; var atext: msestring;
               var donotsend: Boolean);
var
 fna1: filenamety;
 po1: pmsechar;
 bo1: boolean;
begin
 if mainmo.reporoot <> '' then begin
  if not termed.running then begin
   donotsend:= true;
   termed.inputcolindex:= length(termed.text);
   if msestartsstr('cd ',atext) then begin
    po1:= pmsechar(pointer(atext))+3;
    bo1:= false;
    while po1^ = ' ' do begin
     inc(po1);
    end;
    bo1:= false;
    if po1^ = '/' then begin
     bo1:= true;
     inc(po1);
    end;
    if not bo1 then begin
     fna1:= fpath;
    end
    else begin
     fna1:= '';
    end;     
    fna1:= filepath(fna1+copy(atext,po1-pmsechar(pointer(atext))+1,bigint),
                                                                 fk_dir,true);
    if gitdirtreefo.setcurrentgitdir(fna1) then begin
     fpath:= fna1;
     mainfo.objchanged(true);
    end
    else begin
     termed.addline('cd: '+quotefilename(fna1)+': git directory not found.');
    end;
    termed.addline('');
    refreshprompt;
   end
   else begin
    termed.addline('');
    fna1:= setcurrentdirmse(mainmo.repo{root}+'/'+fpath);
    try
     termed.execprog(mainmo.git.encodegitcommand(atext));
    finally
     setcurrentdirmse(fna1);
    end;
   end;
  end;
 end;
end;

procedure tgitconsolefo.procfiexe(const sender: TObject);
begin
 if termed.inputcolindex > 0 then begin
  termed.addline('');
 end;
 termed.addchars(prompt);
 if fexecgitwaiting then begin
  fexecgitwaiting:= false;
  window.endmodal;
 end;
end;

procedure tgitconsolefo.clear;
begin
 grid.clear;
end;

procedure tgitconsolefo.init;
begin
 if not mainfo.refreshing then begin
  clear;
  if mainmo.isrepoloaded then begin
   termed.addchars(prompt);
  end;
 end;
end;

function tgitconsolefo.doexec(const acommand: msestring;
                                            const agit: boolean): boolean;
var
 mstr1: msestring;
 wi1: twindow;
begin
 if agit then begin
  termed.prompt:= '(git)!> ';
 end
 else begin
  termed.prompt:= '!> ';
 end;
 try
  if agit then begin
   mstr1:= mainmo.git.encodegitcommand(acommand);
  end
  else begin
   mstr1:= acommand;
  end;
  with termed do begin
   addchars(acommand+lineend);
   fexecgitwaiting:= true;
   execprog(mstr1);
   wi1:= nil;
   setlinkedvar(tlinkedobject(application.activewindow),tlinkedobject(wi1));
   self.show(ml_application);
   if wi1 <> nil then begin
    wi1.activate;
    wi1.bringtofront;
   end;
   result:= exitcode = 0;
  end;
 finally
  synctodirtree(fpath);
 end;
end;

function tgitconsolefo.execgit(const acommand: msestring): boolean;
begin
 result:= doexec(acommand,true);
end;

function tgitconsolefo.exec(const acommand: msestring): boolean;
begin
 result:= doexec(acommand,false);
end;

procedure tgitconsolefo.clearexe(const sender: TObject);
begin
 init;
end;

procedure tgitconsolefo.popupupdateexe(const sender: tcustommenu);

begin
 sender.menu.submenu[0].enabled:= mainmo.isrepoloaded;
end;

end.
