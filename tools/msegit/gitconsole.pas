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
unit gitconsole;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msedispwidgets,
 msestrings,msetypes,msedataedits,mseedit,msegrids,mseifiglob,msewidgetgrid,
 mseterminal;

type
 tgitconsolefo = class(tdockform)
   dirdisp: tstringdisp;
   grid: twidgetgrid;
   termed: tterminal;
   procedure sendtextexe(const sender: TObject; var atext: msestring;
                   var donotsend: Boolean);
   procedure procfiexe(const sender: TObject);
  public
   procedure synctodirtree(const apath: filenamety);
   procedure init;
   procedure clear;
 end;
 
var
 gitconsolefo: tgitconsolefo;
implementation
uses
 gitconsole_mfm,mainmodule,msefileutils;
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
 donotsend:= true;
 if mainmo.reporoot <> '' then begin
  application.lock;
  try
   fna1:= setcurrentdir(mainmo.reporoot+'/'+dirdisp.value);
   termed.execprog(mainmo.git.getgitcommand(atext));
   setcurrentdir(fna1);
  finally
   application.unlock;
  end;   
 end;
end;

procedure tgitconsolefo.procfiexe(const sender: TObject);
begin
 termed.addchars(prompt);
end;

procedure tgitconsolefo.clear;
begin
 grid.clear;
end;

procedure tgitconsolefo.init;
begin
 clear;
 termed.addchars(prompt);
end;

end.
