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
unit logform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,dispform,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,mainmodule;

type
 tlogfo = class(tdispfo)
   grid: twidgetgrid;
   message: tstringedit;
   commit: tstringedit;
   commitdate: tdatetimeedit;
   committer: tstringedit;
  private
   fpath: filenamety;
  protected
   procedure dorefresh; override;
   procedure doclear; override;   
  public
   procedure refresh(const adir: tgitdirtreenode; const afile: tmsegitfileitem);
 end;

var
 logfo: tlogfo;
implementation
uses
 logform_mfm,msegitcontroller;

{ tlogfo }

procedure tlogfo.dorefresh;
var
 ar1: refinfoarty;
 po1,po2,po4: pmsestring;
 po3: pdatetime;
 int1: integer;
begin
 if mainmo.git.revlist(ar1,fpath,mainmo.opt.maxlog) then begin
  grid.beginupdate;
  grid.rowcount:= length(ar1);
  po1:= message.griddata.datapo;
  po2:= commit.griddata.datapo;
  po3:= commitdate.griddata.datapo;
  po4:= committer.griddata.datapo;
  for int1:= 0 to high(ar1) do begin
   with ar1[int1] do begin
    po1[int1]:= message;
    po2[int1]:= commit;
    po3[int1]:= commitdate;
    po4[int1]:= committer;
   end;
  end;
  grid.row:= 0;
  grid.endupdate;
 end
 else begin
  grid.clear;
 end;
end;

procedure tlogfo.doclear;
begin
 fpath:= '';
 grid.clear;
end;

procedure tlogfo.refresh(const adir: tgitdirtreenode;
               const afile: tmsegitfileitem);
begin
 fpath:= '';
 if (adir <> nil) then begin
  fpath:= adir.gitpath;
  if afile <> nil then begin
   fpath:= fpath+afile.caption;
  end;
 end;
 inherited refresh;
end;

end.
