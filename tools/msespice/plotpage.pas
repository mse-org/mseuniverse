{ MSEgit Copyright (c) 2012 by Martin Schreiber
   
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
unit plotpage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,msedataedits,
 mseedit,mseifiglob,msestrings,msetypes,msewidgets,classes,plotoptions,
 msesplitter,msegrids,msewidgetgrid,msegraphedits,msesimplewidgets,
 mselistbrowser,msedatanodes,msememodialog,chartform,msengspice;
 
type

 tplotnode = class(ttreelistedititem)
  private
   fvalue0: msestring;
  protected
   property value0: msestring read fvalue0 write fvalue0;
  public
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   procedure showchart; virtual;
 end;
 
 tchartnode = class(tplotnode)
  private
   fchart: tchartfo;
  protected
   function createsubnode: ttreelistitem; override;
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   destructor destroy; override;
   procedure showchart; override;
   function getsavevalues: msestring;
   property chart: tchartfo read fchart;
   procedure loaddata(const adata: plotinfoty; const xexpression: msestring);
   property title: msestring read fvalue0;
 end;

 chartnodearty = array of tchartnode;

 ttracenode = class(tplotnode)
  private
   fexpression: msestring;
   fxvaluekind: valuekindty;
   fyexpression: msestring;
   fyvaluekind: valuekindty;
  protected
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
  public
   procedure showchart; override;
   property xexpression: msestring read fvalue0 write fvalue0;
   property xvaluekind: valuekindty read fxvaluekind write fxvaluekind 
                                                        default vk_def;
   property yexpression: msestring read fyexpression write fyexpression;
   property yvaluekind: valuekindty read fyvaluekind write fyvaluekind 
                                                        default vk_def;
 end;
 
 tplotpagefo = class(ttabform)
   plotname: tstringedit;
   plotkind: tenumedit;
   plotcont: tsimplewidget;
   tsplitter1: tsplitter;
   tracegrid: twidgetgrid;
   plotactive: tbooleanedit;
   treeed: ttreeitemedit;
   value0: tmemodialogedit;
   xvaluekind: tenumedit;
   yexpression: tmemodialogedit;
   yvaluekind: tenumedit;
   procedure setnameexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure kindsetexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure createitemexe(const sender: tcustomitemlist;
                   var item: ttreelistedititem);
   procedure updaterowvalueexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure value0setexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure rowinsertexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure rowdeleteexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure rowmoveexe(const sender: tcustomgrid; var fromindex: Integer;
                   var toindex: Integer; var acount: Integer);
   procedure xvaluekindsetexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure yexpressionsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure yvaluekindsetexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
  private
   fplot: tplotoptionsfo;
   fnameindex: integer;
  protected
   procedure setkind(const akind: integer);
   function getchartname: string;
  public
   constructor create(const aowner: tcomponent; const akind: integer);
   function kind: integer;
   function getplotstatement: string;
   function chartnodes: chartnodearty;
   procedure resetnameindex;
   property plot: tplotoptionsfo read fplot;
 end;
 
implementation
uses
 plotpage_mfm,dcplot,acplot,transplot,sysutils,mseeditglob,msechart,plotsform,
 msearrayutils;

const
 plotclasses: array[0..2] of plotsfoclassty = (
  tdcplotfo,tacplotfo,ttransplotfo);

function getplotclass(const akind: integer): plotsfoclassty;
begin
 if (akind < 0) or (akind > high(plotclasses)) then begin
  result:= nil;
 end
 else begin
  result:= plotclasses[akind];
 end;
end;

function getplotkind(const aclass: tplotoptionsfo): integer;
var
 int1: integer;
 po1: pointer;
begin
 result:= -1;
 if aclass <> nil then begin
  po1:= aclass.classtype;
  for int1:= 0 to high(plotclasses) do begin
   if plotclasses[int1] = plotsfoclassty(po1) then begin
    result:= int1;
    break;
   end;
  end;
 end;
end;

{ tplotnode }

procedure tplotnode.dostatread(const reader: tstatreader);
begin
 inherited;
 fvalue0:= reader.readmsestring('value0',fvalue0);
end;

procedure tplotnode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writemsestring('value0',fvalue0);
end;

procedure tplotnode.showchart;
begin
 //dummy
end;

{ tchartnode }

constructor tchartnode.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;
 fchart:= tchartfo.create(nil);
// fchart.name:= '';
end;

destructor tchartnode.destroy;
begin
 freeandnil(fchart);
 inherited;
end;

function tchartnode.getsavevalues: msestring;
var
 int1: integer;
 ar1: msestringarty;
 mstr1: msestring;
begin
 result:= '';
 if count > 0 then begin
  setlength(ar1,2*count);
  for int1:= 0 to count - 1 do begin
   with ttracenode(fitems[int1]) do begin
    ar1[2*int1]:= mseuppercase(trim(xexpression));
    ar1[2*int1+1]:= mseuppercase(trim(yexpression));
   end;
  end;
  sortarray(ar1);
  mstr1:= '';
  for int1:= 0 to high(ar1) do begin
   if ar1[int1] <> mstr1 then begin
    mstr1:= ar1[int1];
    result:= result + mstr1 + ' ';
   end;
  end;
  setlength(result,length(result)-1); //remove last space
 end;
end;

function tchartnode.createsubnode: ttreelistitem;
begin
 result:= ttracenode.create;
end;

procedure tchartnode.showchart;
begin
 chart.activate;
end;

procedure tchartnode.loaddata(const adata: plotinfoty;
                                   const xexpression: msestring);
var
 int1: integer;
begin
 with chart do begin
  scalesgrid.rowcount:= count;
//  expdisp[0]:= xexpression;
  with chart do begin
   traces.count:= count;
   for int1:= 0 to count-1 do begin
    if int1 >= high(adata.data) then begin
     clear;
     xexpdisp[int1]:= '';
     yexpdisp[int1]:= '';
    end
    else begin
     with traces[int1],ttracenode(items[int1]) do begin
      kind:= trk_xy;
      options:= options + [cto_xordered];
      xdata:= getplotvalues(adata,xexpression,xvaluekind);
      ydata:= getplotvalues(adata,yexpression,yvaluekind);
      xexpdisp[int1]:= xexpression;
      yexpdisp[int1]:= yexpression;
     end;
    end;
   end;
   autoscalex;
   autoscaley;
  end;
  for int1:= 0 to count-1 do begin
   xstart[int1]:= chart.xstart;
   xrange[int1]:= chart.xrange;
   ystart[int1]:= chart.ystart;
   yrange[int1]:= chart.yrange;
  end;
 end;
end;

{ ttracenode }

procedure ttracenode.showchart;
begin
 tchartnode(parent).showchart;
end;

procedure ttracenode.dostatread(const reader: tstatreader);
begin
 inherited;
 fxvaluekind:= valuekindty(reader.readinteger('xvaluekind',0,0,4));
 fyexpression:= reader.readmsestring('yexpression','');
 fyvaluekind:= valuekindty(reader.readinteger('yvaluekind',0,0,4));
end;

procedure ttracenode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writeinteger('xvaluekind',ord(fxvaluekind));
 writer.writeinteger('yvaluekind',ord(fyvaluekind));
 writer.writemsestring('yexpression',fyexpression);
end;

 {tplotpagefo}

constructor tplotpagefo.create(const aowner: tcomponent; const akind: integer);
begin
 inherited create(aowner);
 caption:= plotname.value;
 setkind(akind);
end;
 
procedure tplotpagefo.setnameexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 caption:= avalue;
end;

procedure tplotpagefo.kindsetexe(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 if avalue <> plotkind.value then begin
  setkind(avalue);
 end;
end;

procedure tplotpagefo.setkind(const akind: integer);
var
 cla1: plotsfoclassty;
begin
 freeandnil(fplot);
 cla1:= getplotclass(akind);
 if cla1 <> nil then begin
  fplot:= cla1.create(self);
  fplot.parentwidget:= plotcont;
  fplot.visible:= true;
 end;
end;

function tplotpagefo.kind: integer;
begin
 result:= getplotkind(fplot);
end;

function tplotpagefo.getplotstatement: string;
var
 int1,int2: integer;
 str1: string;
 ar1: chartnodearty;
begin
 result:= '';
 ar1:= chartnodes;
 str1:= '.SAVE '{+ fplot.getxvalue};
 if ar1 <> nil then begin
  for int1:= 0 to high(ar1) do begin
   str1:= str1 + ' ' + ar1[int1].getsavevalues;
  end;
 end;
 result:= str1+lineend;
 result:= result+fplot.getplotstatement;
end;

procedure tplotpagefo.createitemexe(const sender: tcustomitemlist;
               var item: ttreelistedititem);
begin
 item:= tchartnode.create(sender);
 item.add(1);
 tchartnode(item).chart.name:= getchartname;
end;

procedure tplotpagefo.updaterowvalueexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
begin
 value0[aindex]:= tplotnode(aitem).value0;
 if aitem is ttracenode then begin
  xvaluekind[aindex]:= ord(ttracenode(aitem).xvaluekind);
  yvaluekind[aindex]:= ord(ttracenode(aitem).yvaluekind);
  yexpression[aindex]:= ttracenode(aitem).yexpression;
  tracegrid.datacols.unmergecols(aindex);
 end
 else begin
  tracegrid.datacols.mergecols(aindex,1,3);
 end;
end;

procedure tplotpagefo.value0setexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 tplotnode(treeed.item).value0:= avalue;
end;

procedure tplotpagefo.xvaluekindsetexe(const sender: TObject;
               var avalue: Integer; var accept: Boolean);
begin
 if treeed.item is ttracenode then begin
  ttracenode(treeed.item).xvaluekind:= valuekindty(avalue);
 end;
end;

procedure tplotpagefo.yexpressionsetexe(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if treeed.item is ttracenode then begin
  ttracenode(treeed.item).yexpression:= avalue;
 end;
end;

procedure tplotpagefo.yvaluekindsetexe(const sender: TObject;
               var avalue: Integer; var accept: Boolean);
begin
 if treeed.item is ttracenode then begin
  ttracenode(treeed.item).yvaluekind:= valuekindty(avalue);
 end;
end;


procedure tplotpagefo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) then begin
  tplotnode(treeed.item).showchart;
 end;
end;

function tplotpagefo.chartnodes: chartnodearty;
begin
 result:= chartnodearty(treeed.itemlist.toplevelnodes);
end;

function tplotpagefo.getchartname: string;
begin
 result:= 'p'+inttostr(tabindex)+'_'+inttostr(fnameindex);
 inc(fnameindex);
end;

procedure tplotpagefo.resetnameindex;
begin
 fnameindex:= 0;
end;

procedure tplotpagefo.rowinsertexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
begin
 if sender.userinput then begin
  if (treeed.item is tchartnode) then begin
   with tchartnode(treeed.item) do begin
    if (aindex > tracegrid.row) and (count = 0) then begin
     insert(ttracenode.create,0);
     acount:= 0;
    end
    else begin
     if expanded and (aindex > tracegrid.row) then begin
      aindex:= tracegrid.row + treeheight+1;
     end;
    end;
   end;
  end
  else begin
   if treeed.item is ttracenode then begin
    with treeed.item do begin
     if aindex > tracegrid.row then begin
      parent.insert(ttracenode.create,parentindex+1);
     end
     else begin
//      insert(ttracenode.create,0);
      parent.insert(ttracenode.create,parentindex);
     end;
    end;
    acount:= 0;
   end;
  end;
 end;
end;

procedure tplotpagefo.rowdeleteexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
var
 int1: integer;
begin
 if sender.userinput then begin
  int1:= tracegrid.row;
  treeed[aindex].free;
  acount:= 0;
  if int1 >= 0 then begin
   tracegrid.row:= aindex;
  end;
 end;
end;

procedure tplotpagefo.rowmoveexe(const sender: tcustomgrid;
               var fromindex: Integer; var toindex: Integer;
               var acount: Integer);
var
 source,dest: ttreelistedititem;
 int1: integer;
begin
 if sender.userinput then begin
  source:= treeed[fromindex];
  if source is tchartnode then begin
   treeed.itemlist.moverow(fromindex,toindex);
  end
  else begin
   if treeed[toindex] is tchartnode then begin
    dest:= nil;
    if toindex > fromindex then begin
     dest:= treeed[toindex];
     dest.insert(treeed[fromindex],0);
    end
    else begin
     if toindex > 0 then begin
      dest:= treeed[toindex-1];
      dest.parentorself.insert(treeed[fromindex],bigint);
     end;
    end;
    if dest <> nil then begin
     dest.expanded:= true;
    end;
   end
   else begin
    treeed[fromindex].parent.move(treeed[fromindex].parentindex,
                                     treeed[toindex].parentindex);
   end;
  end;
  acount:= 0;
  tracegrid.row:= source.index;
 end;
end;

end.
