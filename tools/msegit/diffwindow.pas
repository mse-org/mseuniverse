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
unit diffwindow;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,diffform,mseact,
 mseactions,mseifiglob,msebitmap,msedataedits,msedatanodes,mseedit,
 msefiledialog,msegrids,mselistbrowser,msestrings,msesys,msetypes;

type
 tdiffwindowfo = class(tdifffo)
   patchact: taction;
   mergetoolact: taction;
   revertact: taction;
   savediffact: taction;
   difffiledialog: tfiledialog;
   procedure patchtoolexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu); override;
   procedure afterstatreadexe(const sender: TObject);
   procedure mergetoolexe(const sender: TObject);
   procedure popupupdateexe1(const sender: tcustommenu);
   procedure revertexe(const sender: TObject);
   procedure savediffexe(const sender: TObject);
  protected
   fcandiffpopup: boolean;
 end;

var
 diffwindowfo: tdiffwindowfo;

implementation
uses
 diffwindow_mfm,mainmodule,difftab,logform,msewidgets,msefileutils,msestream;
 
procedure tdiffwindowfo.patchtoolexe(const sender: TObject);
var
 mstr1,a,b: msestring;
begin
 if fi.iscommits then begin
  with tdifftabfo(tabs.activepage) do begin
   if grid.rowcount >= 2 then begin
    mstr1:= ed[1];
    if (length(mstr1) > 6+40+2+40) and msestartsstr('index ',mstr1) then begin
     a:= copy(mstr1,1+6,40);
     b:= copy(mstr1,1+6+40+2,40);
    end;
   end;
  end;
 end
 else begin
  a:= fi.a;
  b:= fi.b;
 end;
 mainmo.patchtoolcall(currentpath,a,b,fi.iscommits);
end;

procedure tdiffwindowfo.popupupdateexe(const sender: tcustommenu);
begin
 inherited;
 savediffact.enabled:= (tabs.activepageindex >= 0) and 
                (tdifftabfo(tabs.activepage).grid.rowcount > 0);
 fcandiffpopup:= singlediff and savediffact.enabled;

 patchact.enabled:= fcandiffpopup and (mainmo.opt.difftool <> '');
 externaldiffact.enabled:= externaldiffact.enabled and not fi.iscommits;
 mergetoolact.enabled:= fcandiffpopup and mainmo.canmergetool;
end;

procedure tdiffwindowfo.afterstatreadexe(const sender: TObject);
begin
 tabs.activepageindex:= 0; //override stored value
end;

procedure tdiffwindowfo.mergetoolexe(const sender: TObject);
var
 ar1: filenamearty;
begin
 setlength(ar1,1);
 ar1[0]:= currentpath;
 if ar1[0] <> '' then begin
  if mainmo.mergetoolcall(ar1) then begin
   activate;
  end;
 end;
end;

procedure tdiffwindowfo.popupupdateexe1(const sender: tcustommenu);
begin
 popupupdateexe(sender);
 revertact.enabled:= fcandiffpopup and logfo.isbasediff;
end;

procedure tdiffwindowfo.revertexe(const sender: TObject);
begin
 if askyesno('Do you want to revert "'+currentpath+'"?') then begin
  mainmo.revert(currentpath);
 end;
end;

procedure tdiffwindowfo.savediffexe(const sender: TObject);
var
 stream1: ttextstream;
 int1: integer;
begin
 if mainmo.opt.splitdiffs then begin
  with difffiledialog.controller do begin
   filename:= filepath(lastdir,tabs.activepageintf.getcaption+'.diff');
  end;
 end;
 if difffiledialog.execute = mr_ok then begin
  stream1:= ttextstream.create(difffiledialog.controller.filename,fm_create);
  stream1.encoding:= charencodingty(mainmo.opt.diffencoding);
  with tdifftabfo(tabs.activepage) do begin
   for int1:= 0 to grid.rowhigh do begin
    stream1.writestrln(ed[int1]);
   end;
  end;   
  try
  finally
   stream1.free;
  end;
 end;
end;


end.
