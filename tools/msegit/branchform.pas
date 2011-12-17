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
unit branchform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msegraphedits,
 msememodialog,mseact,mseactions,msegitcontroller,msesplitter,dispform;

type
 tbranchfo = class(tdispfo)
   remotegrid: twidgetgrid;
   remoteactive: tbooleaneditradio;
   remotebranch: tstringedit;
   remote: tstringedit;
   remotepopup: tpopupmenu;
   localgrid: twidgetgrid;
   localbranch: tstringedit;
   localactive: tbooleaneditradio;
   tsplitter1: tsplitter;
   localpopup: tpopupmenu;
   logbranch: tbooleaneditradio;
   remotebranchlink: tbooleanedit;
   procedure remotebranchsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure remoteactivesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure remoterowdeleteexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure remotepopupupdateexe(const sender: tcustommenu);
   procedure remotedeleteexe(const sender: TObject);
   procedure remotecreateexe(const sender: TObject);
   procedure remotecelleventexe(const sender: TObject;
                   var info: celleventinfoty);
   procedure localbranchsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure localactivesetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure localrowdeleteexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure localpopupupdateexe(const sender: tcustommenu);
   procedure localcreateexe(const sender: TObject);
   procedure localdeleteexe(const sender: TObject);
   procedure remoterowinsertexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure befremotecoldraw(const sender: tcol; const canvas: tcanvas;
                   var cellinfo: cellinfoty; var processed: Boolean);
   procedure activelogsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure linkbranchsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  protected
   function currentremote: msestring;
   procedure doclear; override;
   procedure dorefresh; override;
 end;
 
var
 branchfo: tbranchfo;

implementation

uses
 branchform_mfm,mainmodule,msewidgets,main,msefileutils,mseeditglob,logform;

procedure tbranchfo.doclear;
begin
 with localgrid do begin
  optionsgrid:= optionsgrid - [og_autofirstrow,og_autoappend];
  clear;
 end;
 with remotegrid do begin
  optionsgrid:= optionsgrid - [og_autofirstrow,og_autoappend];
  clear;
 end;
end;

procedure tbranchfo.dorefresh;
var
 int1,int2,int3: integer;
 mstr1: msestring;
 bo1: boolean;
begin
 localgrid.rowcount:= length(mainmo.branches);
 logbranch.checkedrow:= -1;
 localactive.checkedrow:= -1;
 with localgrid do begin
  optionsgrid:= optionsgrid + [og_autofirstrow,og_autoappend];
 end;
 for int1:= 0 to localgrid.rowhigh do begin
  with mainmo.branches[int1] do begin
   localbranch[int1]:= info.name;
   if active then begin
    localactive.checkedrow:= int1;
   end;
   if info.name = mainmo.repostat.activelogbranch then begin
    logbranch.checkedrow:= int1;
   end;
   if active then begin
    localgrid.rowcolorstate[int1]:= 0;
   end;
  end;
 end;
 int3:= 0;
 for int1:= 0 to high(mainmo.remotesinfo) do begin
  with mainmo.remotesinfo[int1] do begin
   if name <> '' then begin
    remotegrid.rowcount:= 1 + int3 + length(branches);
    remote[int3]:= name;
    mstr1:= mainmo.activeremotebranch[name];
    bo1:= name = mainmo.activeremote;
    if bo1 then begin
     remoteactive[int3]:= true;
     remotegrid.rowcolorstate[int3]:= 0;
    end;
    remotegrid.datacols.mergecols(int3,0,1);
    inc(int3);
    for int2:= 0 to high(branches) do begin
     with branches[int2] do begin
      remotebranch[int3]:= info.name;
      remotebranchlink[int3]:= linklocalbranch;
      if info.name = mstr1 then begin
       remoteactive[int3]:= true;
       if bo1 then begin
        remotegrid.rowcolorstate[int3]:= 0;
       end;
      end;
     end;
     inc(int3);
    end;
   end;
  end;
 end;
 with remotegrid do begin
  if rowcount > 0 then begin
   optionsgrid:= optionsgrid + [og_autofirstrow,og_autoappend];
  end;
 end;
end;
 
procedure tbranchfo.localbranchsetexe(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 accept:= checkname(avalue);
 if accept then begin
  if localbranch.value = '' then begin
   accept:= askyesno('Do you want to create branch '+avalue+' from '+
                  logfo.currentcommithint+'?');
   if accept then begin
    accept:= mainmo.createbranch('',avalue,logfo.currentcommit);
   end;
  end
  else begin
   accept:= askyesno('Do you want to rename branch "'+
                      localbranch.value+'" to "'+avalue+'"?');
   if accept then begin
    if not mainmo.renamebranch('',localbranch.value,avalue) then begin
     avalue:= localbranch.value;
    end;
   end;
  end;
 end;
end;

procedure tbranchfo.remotebranchsetexe(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
var
 mstr1: msestring;
begin
 accept:= checkname(avalue);
 if accept then begin
  mstr1:= currentremote;
  if remotebranch.value = '' then begin
   accept:= askyesno('Do you want to create remote branch '+mstr1+' '+
                                                                avalue+'?');
   if accept then begin
    accept:= mainmo.createbranch(mstr1,avalue,'');
   end;
  end
  else begin
   accept:= askyesno('Do you want to rename remote branch '+mstr1+
                  ' "'+remotebranch.value+'" to "'+
                         avalue+'"?','***WARNING***');
   if accept then begin
    if not mainmo.renamebranch(mstr1,remotebranch.value,avalue) then begin
     avalue:= remotebranch.value;
    end;
   end;
  end;
 end;
end;

function tbranchfo.currentremote: msestring;
var
 int1: integer;
begin
 result:= '';
 for int1:= remotegrid.row downto 0 do begin
  if remote[int1] <> '' then begin
   result:= remote[int1];
   break;
  end;
 end;
end;

procedure tbranchfo.localactivesetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
begin
 accept:= askyesno('Do you want to switch to branch "'+
                      localbranch.value+'"?') and
                      mainmo.checkoutbranch(localbranch.value);
 if accept then begin
  if mainmo.linkremotebranch[mainmo.activeremote,localbranch.value] then begin
   mainmo.activeremotebranch[mainmo.activeremote]:= localbranch.value;
  end;
  mainmo.repostat.activelogbranch:= localbranch.value;
  logbranch.value:= true;
  mainfo.reload;
  accept:= false;
 end;
 exit;
end;

procedure tbranchfo.remoteactivesetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
var
 int1: integer;
 mstr1: msestring;
 bo1: boolean;
 rowbefore: integer;
begin
 rowbefore:= remotegrid.row;
 if remote.value <> '' then begin  //switch remote
  mstr1:= mainmo.activeremotebranch[remote.value];
  if mainmo.linkremotebranch[remote.value,mstr1] and 
                                  (mstr1 <> mainmo.activebranch) then begin
   if askyesno('Do you want to switch to branch "'+mstr1+'"?') and
                                     mainmo.checkoutbranch(mstr1) then begin
    mainmo.repostat.activelogbranch:= mstr1;
   end
   else begin
    accept:= false;
    exit;
   end;
  end;
  bo1:= false;
  for int1:= 0 to remotegrid.rowhigh do begin
   remotegrid.rowcolorstate[int1]:= -1;
   if remote[int1] <> '' then begin
    bo1:= false;
    if remotegrid.row = int1 then begin
     if avalue then begin
      bo1:= true;
      remotegrid.rowcolorstate[int1]:= 0;
     end;     
    end;
    remoteactive[int1]:= false;
   end
   else begin
    if bo1 and remoteactive[int1] then begin
     remotegrid.rowcolorstate[int1]:= 0;
    end;
   end;
  end;
  mainmo.activeremote:= remote.value;
 end 
 else begin                    //switch remote branch
  if (mainmo.activeremote = currentremote) and 
                     (mainmo.activebranch <> remotebranch.value) and
      mainmo.linkremotebranch[mainmo.activeremote,remotebranch.value] then begin
   if askyesno('Do you want to switch to branch "'+
     remotebranch.value+'"?') and
                mainmo.checkoutbranch(remotebranch.value) then begin
     mainmo.repostat.activelogbranch:= remotebranch.value;
   end
   else begin
    accept:= false;
    exit;
   end;
  end;
  mstr1:= '';
  for int1:= remotegrid.row - 1 downto 0 do begin
   mstr1:= remote[int1];
   if mstr1 <> '' then begin
    break;
   end;
  end;
  bo1:= false;
  for int1:= remotegrid.row - 1 downto 0 do begin
   if remote[int1] <> '' then begin
    bo1:= remoteactive[int1];
    break;
   end;
   remoteactive[int1]:= false;
   remotegrid.rowcolorstate[int1]:= -1;
  end;
  for int1:= remotegrid.row+1 to remotegrid.rowhigh do begin
   if remote[int1] <> '' then begin
    break;
   end;
   remoteactive[int1]:= false;
   remotegrid.rowcolorstate[int1]:= -1;
  end;
  if bo1 then begin
   remotegrid.rowcolorstate[-1]:= 0;
  end;
  if mstr1 <> '' then begin
   trydeletefile('.git/FETCH_HEAD'); //invalid
  end;
  mainmo.activeremotebranch[mstr1]:= remotebranch.value;
  if mainmo.activeremote <> currentremote then begin
   exit;
  end;
 end;
 mainfo.reload;
 remotegrid.row:= rowbefore;
end;

procedure tbranchfo.localrowdeleteexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
//var
// mstr1,mstr2: msestring;
begin
 if localbranch.value <> '' then begin
  if not askyesno('Do you want to delete branch '+localbranch.value+'?') or
                not mainmo.deletebranch('',localbranch.value) then begin
   acount:= 0;
  end;
 end;
end;

procedure tbranchfo.remoterowdeleteexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
var
 mstr1: msestring;
begin
 if remotebranch.value <> '' then begin
  if remote.value = '' then begin
   mstr1:= currentremote;
   if not askyesno('Do you want to delete branch '+
                     mstr1 +' ' + remotebranch.value+'?') or
                 not mainmo.deletebranch(mstr1,remotebranch.value) then begin
    acount:= 0;
   end;
  end
  else begin
   acount:= 0;
  end;
 end;
end;

procedure tbranchfo.localpopupupdateexe(const sender: tcustommenu);
begin
 //dummy
end;

procedure tbranchfo.localcreateexe(const sender: TObject);
begin
 localgrid.insertrow(localgrid.row+1,1);
 localgrid.row:= localgrid.row+1;
end;

procedure tbranchfo.localdeleteexe(const sender: TObject);
begin
 localgrid.deleterow(localgrid.row,1);
end;

procedure tbranchfo.remotepopupupdateexe(const sender: tcustommenu);
begin
 sender.menu[1].enabled:= remote.value = '';
end;

procedure tbranchfo.remotedeleteexe(const sender: TObject);
begin
 remotegrid.deleterow(remotegrid.row,1);
end;

procedure tbranchfo.remotecreateexe(const sender: TObject);
begin
 remotegrid.insertrow(remotegrid.row+1,1);
 remotegrid.row:= remotegrid.row+1;
end;

procedure tbranchfo.remotecelleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  if (remote.value <> '') or (info.cell.row = 0) then begin
   remotebranch.optionsedit:= (remotebranch.optionsedit + [oe_readonly]) -
                                                                [oe_notnull];
  end
  else begin
   remotebranch.optionsedit:= (remotebranch.optionsedit - [oe_readonly]) +
                                                                [oe_notnull];
  end;
 end;
end;

procedure tbranchfo.remoterowinsertexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
begin
 if aindex = 0 then begin
  acount:= 0;
 end;
end;

procedure tbranchfo.befremotecoldraw(const sender: tcol; const canvas: tcanvas;
               var cellinfo: cellinfoty; var processed: Boolean);
begin
 with cellinfo do begin
  if remote[cell.row] = '' then begin
   color:= cl_transparent;
  end;
 end;
end;

procedure tbranchfo.activelogsetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  mainmo.repostat.activelogbranch:= localbranch.value;
  mainfo.objchanged;
 end;
end;

procedure tbranchfo.linkbranchsetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if remote.value = '' then begin
  mainmo.linkremotebranch[currentremote,remotebranch.value]:= avalue;
 end
 else begin
  avalue:= false;
 end;
end;

end.
