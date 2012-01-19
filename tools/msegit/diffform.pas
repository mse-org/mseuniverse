{ MSEgit Copyright (c) 2011-2012 by Martin Schreiber
   
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
 classes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msestatfile,
 msedataedits,mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,
 mseeditglob,msetextedit,mainmodule,mseact,mseactions,dispform,msescrollbar,
 msetabs,msewidgets,sysutils,difftab;

type
 tdifffo = class(tdispfo)
   tpopupmenu1: tpopupmenu;
   externaldiffact: taction;
   tabs: ttabwidget;
   procedure externaldiffexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu); virtual;
  private
   procedure showdiff(const dest: tdifftabfo; const text: msestringarty);
   procedure cleartabs;
  protected
   fpath: msestring;
   fa: msestring;
   fb: msestring;
   fcanexternaldiff: boolean;
   function currentpath: filenamety;
   procedure dorefresh; override;
   procedure doclear; override;
   function singlediff: boolean;
  public
   constructor create(aowner: tcomponent); override;
   procedure refresh(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem;
                   const oldcommit: msestring; const newcommit: msestring);
 end;

implementation
uses
 diffform_mfm,mserichstring,msearrayutils,msefileutils;
 
const
 chunkcolor = cl_dkmagenta;
 addcolor = $008000;
 removecolor = cl_dkred;
 
{ tdifffo }

constructor tdifffo.create(aowner: tcomponent);
begin
 inherited;
 tabs.add(itabpage(tdifftabfo.create(nil)));
end;

procedure tdifffo.cleartabs;
var
 int1: integer;
begin
 tabs.beginupdate;
 for int1:= tabs.count - 1 downto 1 do begin
  tabs[int1].free;
 end;
 tdifftabfo(tabs[0]).grid.clear;
 tabs.endupdate;
end;

procedure tdifffo.doclear;
//var
// int1: integer;
begin
 fcanexternaldiff:= false;
 fpath:= '';
 fa:= '';
 fb:= '';
 cleartabs;
// grid.clear;
end;

function tdifffo.currentpath: filenamety;
begin
 if fcanexternaldiff then begin
  result:= fpath;
 end
 else begin
  result:= mainmo.repobase+tabs.activepageintf.gettabhint;
 end;
end;

procedure tdifffo.externaldiffexe(const sender: TObject);
begin
 with mainmo.git do begin
  mainmo.execgitconsole('difftool -y --tool='+
              encodestringparam(mainmo.opt.difftool)+' '+
                       noemptystringparam(fa)+noemptystringparam(fb)+
         ' -- '+encodepathparam(currentpath,true));
 end;
end;

procedure tdifffo.showdiff(const dest: tdifftabfo; const text: msestringarty);
var
 int1: integer;
 po1: prichstringaty;
 chunkformat,addformat,removeformat: formatinfoarty;
begin
 setfontcolor1(chunkformat,0,bigint,chunkcolor);
 setfontcolor1(addformat,0,bigint,addcolor);
 setfontcolor1(removeformat,0,bigint,removecolor);
 with dest do begin
  grid.beginupdate;
  try
   ed.gridvalues:= text;
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
 end;
end;

procedure tdifffo.dorefresh;
var
 int1,int2,int3: integer;
 ar1: msestringarty;
 ar3: filenamearty;
 captions,hints: msestringarty;
 ar2: msestringararty;
begin
 ar1:= mainmo.git.diff(fa,fb,fpath,mainmo.opt.diffcontextn);
 int2:= -1;
 if mainmo.opt.splitdiffs then begin
  int3:= 3+length(mainmo.repobase);
  for int1:= 0 to high(ar1) do begin
   if msestartsstr('diff ',ar1[int1]) then begin
    if int2 >= 0 then begin   
     additem(ar2,copy(ar1,int2,int1-int2));
    end;
    splitstringquoted(ar1[int1],ar3,'"',' ');
    additem(hints,msestring(copy(ar3[high(ar3)],int3,bigint)));
    additem(captions,filename(hints[high(hints)]));
    int2:= int1;
   end;
  end;
  if int2 >= 0 then begin
   additem(ar2,copy(ar1,int2,bigint));
  end;
 end
 else begin
  if ar1 <> nil then begin
   additem(ar2,ar1);
   setlength(captions,1);
   setlength(hints,1);
  end;
 end;
 if ar2 = nil then begin
  cleartabs;
 end
 else begin
  tabs.beginupdate;
  for int2:= tabs.count-1 downto length(ar2) do begin
   tabs[int2].free;
  end;
  for int2:= tabs.count to high(ar2) do begin  
   tabs.add(itabpage(tdifftabfo.create(nil)));
  end;
  for int1:= 0 to tabs.count - 1 do begin
   with tdifftabfo(tabs[int1]) do begin
    caption:= captions[int1];
    tabhint:= hints[int1];
   end;
   showdiff(tdifftabfo(tabs[int1]),ar2[int1]);
  end;
  tabs.endupdate;
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
 if (adir <> nil) then begin
  fpath:= adir.gitbasepath;
 end;
 if afile <> nil then begin
  fpath:= fpath+afile.caption;
  fcanexternaldiff:= true;
 end;
 inherited refresh;
end;

procedure tdifffo.popupupdateexe(const sender: tcustommenu);
begin
 externaldiffact.enabled:= singlediff and (mainmo.opt.difftool <> '');
end;

function tdifffo.singlediff: boolean;
begin
 result:=(fcanexternaldiff or 
        mainmo.opt.splitdiffs and (tabs.activepageintf <> nil) and 
                                   (tabs.activepageintf.getcaption <> ''))
end;

end.
