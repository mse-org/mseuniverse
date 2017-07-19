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
unit defaultstat;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes;
const
 defaultstatdata = 
'[mainmo.mainstat]'+lineend+
'savedmemoryfiles=5'+lineend+
' mainfo.sta'+lineend+
' commitqueryfo.sta'+lineend+
' optionsfo.sta'+lineend+
' revertqueryfo.sta'+lineend+
' lastmessagefo.sta'+lineend+
'mainfo.sta=295'+lineend+
' [mainfo.panelcontroller]'+lineend+
' panels=2'+lineend+
'  panel1'+lineend+
'  panel2'+lineend+
' clients=281'+lineend+
'  [mainfo.dockpanel]'+lineend+
'  splitdir=2'+lineend+
'  useroptions=33570183'+lineend+
'  parent=mainfo.container'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=18'+lineend+
'  cx=482'+lineend+
'  cy=498'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=2'+lineend+
'   diffwindowfo,0,201,472,297'+lineend+
'   panel1,0,0,472,198'+lineend+
'  [logfo.grid]'+lineend+
'  propcolwidthref=0'+lineend+
'  width0=36'+lineend+
'  sortdescend0=0'+lineend+
'  sortdescend1=0'+lineend+
'  width2=159'+lineend+
'  sortdescend2=0'+lineend+
'  width3=99'+lineend+
'  sortdescend3=0'+lineend+
'  width4=116'+lineend+
'  sortdescend4=0'+lineend+
'  width5=117'+lineend+
'  sortdescend5=0'+lineend+
'  sortcol=0'+lineend+
'  sorted=1'+lineend+
'  col=2'+lineend+
'  row=0'+lineend+
'  rowheight=16'+lineend+
'  [logfo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16511'+lineend+
'  parent=mainfo.panelcontroller.panel2.container'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=236'+lineend+
'  cx=505'+lineend+
'  cy=195'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,505,195'+lineend+
'  [diffwindowfo.tabs]'+lineend+
'  tabsize=114'+lineend+
'  firsttab=0'+lineend+
'  index=0'+lineend+
'  [diffwindowfo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16511'+lineend+
'  parent=mainfo.dockpanel'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=201'+lineend+
'  cx=472'+lineend+
'  cy=297'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,472,297'+lineend+
'  [gitconsolefo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16495'+lineend+
'  parent=mainfo.panelcontroller.panel2.container'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=434'+lineend+
'  cx=505'+lineend+
'  cy=98'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,505,98'+lineend+
'  [branchfo.remotegrid]'+lineend+
'  propcolwidthref=161'+lineend+
'  width0=51'+lineend+
'  sortdescend0=0'+lineend+
'  width1=53'+lineend+
'  sortdescend1=0'+lineend+
'  width2=45'+lineend+
'  sortdescend2=0'+lineend+
'  sortdescend3=0'+lineend+
'  sortdescend4=0'+lineend+
'  sortdescend5=0'+lineend+
'  sortdescend6=0'+lineend+
'  width7=14'+lineend+
'  sortdescend7=0'+lineend+
'  rowstate=4'+lineend+
'   0 3'+lineend+
'   0 0'+lineend+
'   0 0'+lineend+
'   0 0'+lineend+
'  [branchfo.localgrid]'+lineend+
'  propcolwidthref=183'+lineend+
'  sortdescend0=0'+lineend+
'  width1=115'+lineend+
'  sortdescend1=0'+lineend+
'  width2=57'+lineend+
'  sortdescend2=0'+lineend+
'  sortdescend3=0'+lineend+
'  sortdescend4=0'+lineend+
'  sortdescend5=0'+lineend+
'  [branchfo.tsplitter1]'+lineend+
'  x=265'+lineend+
'  y=0'+lineend+
'  xprop=0.53069306930693'+lineend+
'  yprop=1'+lineend+
'  [branchfo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16511'+lineend+
'  parent=mainfo.panelcontroller.panel2.container'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=74'+lineend+
'  cx=505'+lineend+
'  cy=159'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,505,159'+lineend+
'  [remotesfo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16495'+lineend+
'  parent=mainfo.panelcontroller.panel2.container'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=0'+lineend+
'  cx=505'+lineend+
'  cy=71'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,505,71'+lineend+
'  [remotesfo.grid]'+lineend+
'  propcolwidthref=486'+lineend+
'  width0=101'+lineend+
'  sortdescend0=0'+lineend+
'  width1=171'+lineend+
'  sortdescend1=0'+lineend+
'  width2=186'+lineend+
'  sortdescend2=0'+lineend+
'  [stashfo.stashgrid]'+lineend+
'  propcolwidthref=435'+lineend+
'  width0=120'+lineend+
'  sortdescend0=0'+lineend+
'  width1=309'+lineend+
'  sortdescend1=0'+lineend+
'  [stashfo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16511'+lineend+
'  stackedunder=mainfo.panelcontroller.panel2'+lineend+
'  parent='+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=100'+lineend+
'  y=100'+lineend+
'  cx=445'+lineend+
'  cy=354'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,435,354'+lineend+
'  wsize=0'+lineend+
'  active=0'+lineend+
'  visible=0'+lineend+
'  [filesfo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16511'+lineend+
'  parent=mainfo.panelcontroller.panel1.container'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=151'+lineend+
'  y=0'+lineend+
'  cx=321'+lineend+
'  cy=198'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,321,198'+lineend+
'  [filesfo.filelist.grid]'+lineend+
'  propcolwidthref=100'+lineend+
'  sortdescend0=0'+lineend+
'  sortdescend1=1'+lineend+
'  width2=174'+lineend+
'  sortdescend2=0'+lineend+
'  [dirtreefo]'+lineend+
'  splitdir=0'+lineend+
'  useroptions=16511'+lineend+
'  parent=mainfo.panelcontroller.panel1.container'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=0'+lineend+
'  cx=148'+lineend+
'  cy=198'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,148,198'+lineend+
'  [mainfo.panelcontroller.panel1]'+lineend+
'  splitdir=1'+lineend+
'  useroptions=32239'+lineend+
'  parent=mainfo.dockpanel'+lineend+
'  visible=1'+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=0'+lineend+
'  y=0'+lineend+
'  cx=472'+lineend+
'  cy=198'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,472,198'+lineend+
'  [mainfo.panelcontroller.panel2]'+lineend+
'  splitdir=2'+lineend+
'  useroptions=33586671'+lineend+
'  stackedunder=mainfo'+lineend+
'  parent='+lineend+
'  mdistate=0'+lineend+
'  nx=0'+lineend+
'  ny=0'+lineend+
'  ncx=0'+lineend+
'  ncy=0'+lineend+
'  x=505'+lineend+
'  y=160'+lineend+
'  cx=515'+lineend+
'  cy=532'+lineend+
'  rcx=0'+lineend+
'  rcy=0'+lineend+
'  children=1'+lineend+
'   container,0,0,505,532'+lineend+
'  wsize=0'+lineend+
'  active=0'+lineend+
'  visible=1'+lineend+
' [mainfo]'+lineend+
' stackedunder='+lineend+
' x=15'+lineend+
' y=160'+lineend+
' cx=482'+lineend+
' cy=532'+lineend+
' wsize=0'+lineend+
' active=0'+lineend+
' visible=1'+lineend+
'commitqueryfo.sta=19'+lineend+
' [commitqueryfo.tsplitter2]'+lineend+
' x=243'+lineend+
' y=0'+lineend+
' xprop=0.30524642289348'+lineend+
' yprop=0.93911439114391'+lineend+
' [commitqueryfo.tsplitter1]'+lineend+
' x=0'+lineend+
' y=331'+lineend+
' xprop=1'+lineend+
' yprop=0.65527950310559'+lineend+
' [commitqueryfo]'+lineend+
' stackedunder='+lineend+
' x=215'+lineend+
' y=177'+lineend+
' cx=805'+lineend+
' cy=542'+lineend+
' wsize=0'+lineend+
' active=1'+lineend+
' visible=1'+lineend+
'optionsfo.sta=18'+lineend+
' [optionsfo.patchtool]'+lineend+
' history=1'+lineend+
'  kdiff3 $BASE $THEIRS $MINE'+lineend+
' [optionsfo.mergetool]'+lineend+
' history=1'+lineend+
'  kdiff3'+lineend+
' [optionsfo.difftool]'+lineend+
' history=1'+lineend+
'  kompare'+lineend+
' [optionsfo]'+lineend+
' stackedunder='+lineend+
' x=236'+lineend+
' y=237'+lineend+
' cx=402'+lineend+
' cy=274'+lineend+
' wsize=0'+lineend+
' active=1'+lineend+
' visible=1'+lineend+
'revertqueryfo.sta=14'+lineend+
' [revertqueryfo.tsplitter2]'+lineend+
' x=232'+lineend+
' y=-8'+lineend+
' xprop=0.4249547920434'+lineend+
' yprop=0.85512367491166'+lineend+
' [revertqueryfo]'+lineend+
' stackedunder='+lineend+
' x=113'+lineend+
' y=249'+lineend+
' cx=553'+lineend+
' cy=283'+lineend+
' wsize=0'+lineend+
' active=1'+lineend+
' visible=1'+lineend+
'lastmessagefo.sta=9'+lineend+
' [lastmessagefo]'+lineend+
' stackedunder='+lineend+
' x=212'+lineend+
' y=250'+lineend+
' cx=341'+lineend+
' cy=263'+lineend+
' wsize=0'+lineend+
' active=1'+lineend+
' visible=1'+lineend+
'[mainmo.repositoryfiledialog]'+lineend+
'filefilterindex=-1'+lineend+
'filefilter='+lineend+
'filecolwidth=174'+lineend+
'x=0'+lineend+
'y=0'+lineend+
'cx=0'+lineend+
'cy=0'+lineend+
'[mainmo.optionsobj]'+lineend+
'showuntrackeditems=1'+lineend+
'showignoreditems=0'+lineend+
'gitcommand='+lineend+
'maxlog=50'+lineend+
'showutc=0'+lineend+
'diffcontextn=3'+lineend+
'splitdiffs=1'+lineend+
'difftool=kompare'+lineend+
'mergetool=kdiff3'+lineend+
'patchtool=kdiff3 $BASE $THEIRS $MINE'+lineend+
'[logfo.diffmode]'+lineend+
'value=0';

implementation
end.
