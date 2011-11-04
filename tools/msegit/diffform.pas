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
unit diffform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msestatfile,
 msedataedits,mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,
 mseeditglob,msetextedit,mainmodule,mseact,mseactions;

type
 tdifffo = class(tdockform)
   grid: twidgetgrid;
   ed: ttextedit;
   repocloseact: taction;
   procedure showexe(const sender: TObject);
   procedure hideexe(const sender: TObject);
   procedure repocloseexe(const sender: TObject);
  private
   fpath: msestring;
  protected
   procedure updatedisp;
  public
   procedure refresh(const adir: tgitdirtreenode;
                 const afile: tmsegitfileitem);
 end;
var
 difffo: tdifffo;
implementation
uses
 diffform_mfm;

{ tdifffo }

procedure tdifffo.updatedisp;
begin
 if fpath <> '' then begin
  ed.gridvalues:= mainmo.git.diff(fpath);
 end
 else begin
  grid.clear;
 end;
end;

procedure tdifffo.refresh(const adir: tgitdirtreenode;
               const afile: tmsegitfileitem);
begin
 fpath:= '';
 if (adir <> nil) and (afile <> nil) then begin
  fpath:= adir.gitpath+afile.caption;
 end;
 if visible then begin
  updatedisp;
 end;
end;

procedure tdifffo.showexe(const sender: TObject);
begin
 updatedisp;
end;

procedure tdifffo.hideexe(const sender: TObject);
begin
 grid.clear;
end;

procedure tdifffo.repocloseexe(const sender: TObject);
begin
 grid.clear;
end;

end.
