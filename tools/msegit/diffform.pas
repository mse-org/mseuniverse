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
   tpopupmenu1: tpopupmenu;
   externaldiffact: taction;
   procedure externaldiffexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu);
  private
   fpath: msestring;
   fa: msestring;
   fb: msestring;
   fcanexternaldiff: boolean;
  protected
   procedure dorefresh; override;
   procedure doclear; override;
//   procedure updatedisp;
  public
   procedure refresh(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem;
                   const oldcommit: msestring; const newcommit: msestring);
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
 fcanexternaldiff:= false;
 fpath:= '';
 fa:= '';
 fb:= '';
 grid.clear;
end;

procedure tdifffo.externaldiffexe(const sender: TObject);
begin
 with mainmo.git do begin
  mainmo.execgitconsole('difftool -y --tool='+
              encodestringparam(mainmo.opt.difftool)+' '+
                       noemptystringparam(fa)+noemptystringparam(fb)+
                       ' -- '+encodepathparam(fpath,true));
 end;
end;

procedure tdifffo.dorefresh;
var
 int1: integer;
 po1: prichstringaty;
 chunkformat,addformat,removeformat: formatinfoarty;
begin
 if (fpath <> '') or (fa <> '') or (fb <> '') then begin
  setfontcolor1(chunkformat,0,bigint,chunkcolor);
  setfontcolor1(addformat,0,bigint,addcolor);
  setfontcolor1(removeformat,0,bigint,removecolor);
  grid.beginupdate;
  try
   ed.gridvalues:= mainmo.git.diff(fa,fb,fpath,mainmo.opt.diffcontextn);
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
                                      const afile: tmsegitfileitem;
                   const oldcommit: msestring; const newcommit: msestring);
begin
 fcanexternaldiff:= false;
 fpath:= '';
 fa:= newcommit;
 fb:= oldcommit;
 if (adir <> nil) and (afile <> nil) then begin
  fpath:= adir.gitpath+afile.caption;
  fcanexternaldiff:= true;
 end;
 inherited refresh;
end;

procedure tdifffo.popupupdateexe(const sender: tcustommenu);
begin
 externaldiffact.enabled:= fcanexternaldiff and (mainmo.opt.difftool <> '');
end;

end.
