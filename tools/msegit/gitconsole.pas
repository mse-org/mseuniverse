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
   dirdisp: tstringdisp;
   grid: twidgetgrid;
   termed: tterminal;
   tspacer1: tspacer;
   procedure sendtextexe(const sender: TObject; var atext: msestring;
                   var donotsend: Boolean);
   procedure procfiexe(const sender: TObject);
  private
   fexecgitwaiting: boolean;
  public
   procedure synctodirtree(const apath: filenamety);
   procedure init;
   procedure clear;
   function execgit(const acommand: string): boolean;
 end;
 
var
 gitconsolefo: tgitconsolefo;
implementation
uses
 gitconsole_mfm,mainmodule,msefileutils,main;
const
 prompt = '(git)-> ';
{ tgitconsolefo }

procedure tgitconsolefo.synctodirtree(const apath: filenamety);
begin
 dirdisp.value:= apath;
end;

procedure tgitconsolefo.sendtextexe(const sender: TObject; var atext: msestring;
               var donotsend: Boolean);
var
 fna1: filenamety;
begin
 if mainmo.reporoot <> '' then begin
  application.lock;
  try
   if not termed.running then begin
    donotsend:= true;
    fna1:= setcurrentdirmse(mainmo.reporoot+'/'+dirdisp.value);
    try
     termed.execprog(mainmo.git.encodegitcommand(atext)); //encoding?
    finally
     setcurrentdirmse(fna1);
    end;
   end;
  finally
   application.unlock;
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
  termed.addchars(prompt);
 end;
end;

function tgitconsolefo.execgit(const acommand: string): boolean;
var
 mstr1: msestring;
 wi1: twindow;
begin
 mstr1:= mainmo.git.encodegitcommand(acommand);
 with termed do begin
  addchars(acommand+lineend);
  fexecgitwaiting:= true;
  execprog(mstr1);
  wi1:= nil;
  setlinkedvar(tlinkedobject(application.activewindow),tlinkedobject(wi1));
  show(ml_application);
  if wi1 <> nil then begin
   wi1.activate;
   wi1.bringtofront;
  end;
  result:= exitcode = 0;
 end;
end;

end.
