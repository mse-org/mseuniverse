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
 mseeditglob,msetextedit,mainmodule,mseact,mseactions,dispform;

type
 tdifffo = class(tdispfo)
   grid: twidgetgrid;
   ed: ttextedit;
  private
   fpath: msestring;
  protected
   procedure dorefresh; override;
   procedure doclear; override;
//   procedure updatedisp;
  public
   procedure refresh(const adir: tgitdirtreenode; const afile: tmsegitfileitem);
 end;
var
 difffo: tdifffo;
implementation
uses
 diffform_mfm,mserichstring;
const
 chunkcolor = cl_dkmagenta;
 addcolor = $008000;
 removecolor = cl_dkred;
 
{ tdifffo }

procedure tdifffo.doclear;
begin
 fpath:= '';
 grid.clear;
end;

procedure tdifffo.dorefresh;
var
 int1: integer;
 po1: prichstringaty;
 chunkformat,addformat,removeformat: formatinfoarty;
begin
 if fpath <> '' then begin
  setfontcolor(chunkformat,0,bigint,chunkcolor);
  setfontcolor(addformat,0,bigint,addcolor);
  setfontcolor(removeformat,0,bigint,removecolor);
  grid.beginupdate;
  try
   ed.gridvalues:= mainmo.git.diff(fpath);
   po1:= ed.datalist.datapo;
   for int1:= 0 to ed.datalist.count-1 do begin
    with po1^[int1] do begin
     if text <> '' then begin
      case text[1] of
       '@': begin
        format:= chunkformat;
       end;
       '+': begin
        format:= addformat;
       end;
       '-': begin
        format:= removeformat;
       end;
      end;
     end;
    end;
   end;
  finally
   grid.endupdate;
  end;
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
 inherited refresh;
end;

end.
