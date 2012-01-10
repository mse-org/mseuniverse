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
{$ifdef FPC}{$mode objfpc}{$h+}{$goto on}{$endif}
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
   locallogbranch: tbooleaneditradio;
   remotebranchlink: tbooleanedit;
   mergeact: taction;
   remotebranchcommit: tstringedit;
   localbranchcommit: tstringedit;
   remotelogbranch: tbooleaneditradio;
   remotebranchhidden: tbooleanedit;
   localbranchhidden: tbooleanedit;
   formpopup: tpopupmenu;
   foldlevel: tintegeredit;
   showhiddenact: taction;
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
   procedure localrowsdeleteexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure localcreateexe(const sender: TObject);
   procedure localdeleteexe(const sender: TObject);
   procedure remoterowinsertexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure befremotecoldraw(const sender: tcol; const canvas: tcanvas;
                   var cellinfo: cellinfoty; var processed: Boolean);
   procedure localactivelogsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure linkbranchsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure mergebranchexe(const sender: TObject);
   procedure mergeupdateexe(const sender: tcustomaction);
   procedure localbranchrowmovedexe(const sender: tcustomgrid;
                   const fromindex: Integer; const toindex: Integer;
                   const acount: Integer);
   procedure localrowsdeletedexe(const sender: tcustomgrid;
                   const aindex: Integer; const acount: Integer);
   procedure remoterowsmovingexe(const sender: tcustomgrid;
                   var fromindex: Integer; var toindex: Integer;
                   var acount: Integer);
   procedure remoterowsmovedexe(const sender: tcustomgrid;
                   const fromindex: Integer; const toindex: Integer;
                   const acount: Integer);
   procedure remoteactivelogsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure hideremotebranchsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure sethidelocalbranchexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure showhiddenexe(const sender: TObject);
  private
   function getshowhidden: boolean;
   procedure setshowhidden(const avalue: boolean);
  protected
   function currentremote(arow: integer = -1): msestring;
   procedure doclear; override;
   property showhidden: boolean read getshowhidden write setshowhidden;
  public
   procedure dorefresh; override;
   procedure setactivelocallog(const abranch: msestring);
   procedure setactiveremotelog(const aremote,abranch: msestring);
 end;
 
var
 branchfo: tbranchfo;

implementation

uses
 branchform_mfm,mainmodule,msewidgets,main,msefileutils,mseeditglob,logform;
const
 hiddencolor = $fff0f0;
 
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
 bo1,bo2: boolean;
begin
 showhidden:= mainmo.repostat.showhiddenbranches;
 showhiddenact.checked:= showhidden;
 
 localgrid.rowcount:= length(mainmo.branches);
 locallogbranch.checkedrow:= -1;
 localactive.checkedrow:= -1;
 with localgrid do begin
  optionsgrid:= optionsgrid + [og_autofirstrow,og_autoappend];
 end;
 for int1:= 0 to localgrid.rowhigh do begin
  with mainmo.branches[int1] do begin
   localbranchhidden[int1]:= hidden;
   localbranch[int1]:= info.name;
   localbranchcommit[int1]:= info.commit;
   if active then begin
    localactive.checkedrow:= int1;
   end;
   if info.name = mainmo.repostat.activelocallogbranch then begin
    locallogbranch.checkedrow:= int1;
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
    remotebranchhidden[int3]:= hidden;
    foldlevel[int3]:= 0;
    bo2:= mainmo.repostat.activeremotelog = name;
    mstr1:= mainmo.activeremotebranch[name];
    bo1:= name = mainmo.activeremote;
    if bo1 then begin
     remoteactive[int3]:= true;
     remotegrid.rowcolorstate[int3]:= 0;
    end;
    remotegrid.datacols.mergecols(int3,1,1);
    inc(int3);
    for int2:= 0 to high(branches) do begin
     with branches[int2] do begin
      remotebranch[int3]:= info.name;
      remotebranchhidden[int3]:= hidden;
      foldlevel[int3]:= 1;
      remotebranchcommit[int3]:= info.commit;
      remotebranchlink[int3]:= linklocalbranch;
      if bo2 and (info.name = mainmo.repostat.activeremotelogbranch) then begin
       remotelogbranch.checkedrow:= int3;
      end;
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
    if accept then begin
     mainmo.updatelocalbranchorder;
    end;
   end;
  end
  else begin
   accept:= askyesno('Do you want to rename branch "'+
                      localbranch.value+'" to "'+avalue+'"?');
   if accept then begin
    if not mainmo.renamebranch('',localbranch.value,avalue) then begin
     avalue:= localbranch.value;
    end
    else begin
     mainmo.updatelocalbranchorder;
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

function tbranchfo.currentremote(arow: integer = -1): msestring;
var
 int1: integer;
begin
 if arow < 0 then begin
  arow:= remotegrid.row;
 end;
 result:= '';
 for int1:= arow downto 0 do begin
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
  mainmo.repostat.activelocallogbranch:= localbranch.value;
  locallogbranch.value:= true;
  mainfo.reload;
  accept:= false;
 end;
 exit;
end;

procedure tbranchfo.setactivelocallog(const abranch: msestring);
var
 int1: integer;
begin
 mainmo.repostat.activelocallogbranch:= abranch;
 locallogbranch.checkedrow:= -1;
 if abranch <> '' then begin
  for int1:= 0 to localgrid.rowhigh do begin
   if localbranch[int1] = abranch then begin
    mainmo.repostat.activeremotelog:= '';
    mainmo.repostat.activeremotelogbranch:= '';
    remotelogbranch.checkedrow:= -1;
    locallogbranch.checkedrow:= int1;
    exit;
   end;
  end;
 end;    
 mainmo.repostat.activelocallogbranch:= '';
end;

procedure tbranchfo.setactiveremotelog(const aremote,abranch: msestring);
var
 int1,int2: integer;
label
 errorlab;
begin
 mainmo.repostat.activeremotelog:= aremote;
 mainmo.repostat.activeremotelogbranch:= abranch;
 remotelogbranch.checkedrow:= -1;
 if aremote <> '' then begin
  for int1:= 0 to remotegrid.rowhigh do begin
   if remote[int1] = aremote then begin
    for int2:= int1+1 to remotegrid.rowhigh do begin
     if remote[int2] <> '' then begin
      goto errorlab;
     end;
     if remotebranch[int2] = abranch then begin
      remotelogbranch.checkedrow:= int2;
      mainmo.repostat.activelocallogbranch:= '';
      locallogbranch.checkedrow:= -1;
      exit;
     end;
    end;
   end;
  end;
 end;    
errorlab:
 mainmo.repostat.activeremotelog:= '';
 mainmo.repostat.activeremotelogbranch:= ''; 
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
    setactivelocallog(mstr1);
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
     setactivelocallog(remotebranch.value);
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

procedure tbranchfo.localrowsdeleteexe(const sender: tcustomgrid;
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

procedure tbranchfo.localactivelogsetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
begin
 if avalue then begin
  setactivelocallog(localbranch.value);
//  remotelogbranch.checkedrow:= -1;
//  mainmo.repostat.activelogbranch:= localbranch.value;
  mainfo.objchanged;
 end;
end;

procedure tbranchfo.remoteactivelogsetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
begin
 if remote.value <> '' then begin
  avalue:= false;
 end;
 if avalue then begin
  setactiveremotelog(currentremote(remotegrid.row),remotebranch.value);
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

procedure tbranchfo.mergebranchexe(const sender: TObject);
begin
 if askyesno('Do you want to merge "'+localbranch.value+'" to "'+
                                          mainmo.activebranch+'"?') and
      mainmo.execgitconsole('merge '+
         mainmo.git.encodestringparam(localbranch.value)) then begin
   mainfo.reload;
 end;
end;

procedure tbranchfo.mergeupdateexe(const sender: tcustomaction);
begin
 mergeact.enabled:= (localgrid.row >= 0) and 
                          (localbranch.value <> mainmo.activebranch);
end;

procedure tbranchfo.localbranchrowmovedexe(const sender: tcustomgrid;
               const fromindex: Integer; const toindex: Integer;
               const acount: Integer);
begin
 mainmo.updatelocalbranchorder;
end;

procedure tbranchfo.localrowsdeletedexe(const sender: tcustomgrid;
               const aindex: Integer; const acount: Integer);
begin
 mainmo.updatelocalbranchorder;
end;

procedure tbranchfo.remoterowsmovingexe(const sender: tcustomgrid;
               var fromindex: Integer; var toindex: Integer;
               var acount: Integer);
begin
 if (remote[fromindex] <> '') or (remote[toindex] <> '') or 
   (currentremote(fromindex) <> currentremote(toindex)) then begin
  acount:= 0;
 end;
end;

procedure tbranchfo.remoterowsmovedexe(const sender: tcustomgrid;
               const fromindex: Integer; const toindex: Integer;
               const acount: Integer);
begin
 mainmo.updateremotebranchorder;
end;

procedure tbranchfo.hideremotebranchsetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
               
begin
 if not mainmo.repostat.showhiddenbranches then begin
  accept:= askyesno('Do you want to hide '+
                       currentremote+'/'+remotebranch.value+'?');
 end;
 if accept then begin
  if remote.value = '' then begin
   mainmo.hideremotebranch[currentremote,remotebranch.value]:= avalue;
  end
  else begin
   mainmo.hideremote[remote.value]:= avalue;
  end;
 end;
end;

procedure tbranchfo.sethidelocalbranchexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
begin
 if not mainmo.repostat.showhiddenbranches then begin
  accept:= askyesno('Do you want to hide '+
                       localbranch.value+'?');
 end;
 if accept then begin
  mainmo.hidelocalbranch[localbranch.value]:= avalue;
 end;
end;

procedure tbranchfo.showhiddenexe(const sender: TObject);
begin
 showhidden:= showhiddenact.checked;
end;

function tbranchfo.getshowhidden: boolean;
begin
 result:= mainmo.repostat.showhiddenbranches;
end;

procedure tbranchfo.setshowhidden(const avalue: boolean);
begin
 mainmo.repostat.showhiddenbranches:= avalue;
 localgrid.folded:= not avalue;
 remotegrid.folded:= not avalue;
 if avalue then begin
  localgrid.datacols[0].color:= cl_default;
  remotegrid.datacols[0].color:= cl_default;
 end
 else begin
  localgrid.datacols[0].color:= hiddencolor;
  remotegrid.datacols[0].color:= hiddencolor;
 end;
end;

end.
