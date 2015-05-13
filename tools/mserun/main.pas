{ MSEtest Copyright (c) 2014-2015 by Martin Schreiber
   
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
unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mseifiendpoint,
 msebitmap,msefiledialog,msesys,msegraphedits,msescrollbar,msedialog,mseact,
 mseactions,msedispwidgets,mserichstring,msetimer,msemenuwidgets,msesplitter,
 mainmodule,msesimplewidgets;

const
 versiontext = '1.2';

type
 tmainfo = class(tmainform)
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   connectmodule: tifiactionendpoint;
   projectcaption: tifistringendpoint;
   tpopupmenu1: tpopupmenu;
   pathed: tfilenameedit;
   runbu: tdatabutton;
   commented: tdialogstringedit;
   editbu: tstockglyphdatabutton;
   editact: taction;
   tlayouter1: tlayouter;
   tmainmenuwidget1: tmainmenuwidget;
   tspacer1: tspacer;
   okdi: tintegerdisp;
   tspacer2: tspacer;
   errordi: tintegerdisp;
   totaldi: tintegerdisp;
   tspacer3: tspacer;
   menuitemframe: tframecomp;
   menuitemface: tfacelist;
   copyitemact: taction;
   pasteitemact: taction;
   cutitemact: taction;
   images: timagelist;
   insertgroupnodeact: taction;
   tspacer4: tspacer;
   resetbu: tbutton;
   procedure connectmoduleexe(const sender: TObject);
//   procedure createitemexe(const sender: tcustomitemlist;
//                   var item: ttreelistedititem);
   procedure captionchaexe(const sender: TObject; var avalue: msestring);
   procedure closequeryexe(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure insertgroupexe(const sender: TObject);
   procedure rowinsertingexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure rowsmovingexe(const sender: tcustomgrid; var fromindex: Integer;
                   var toindex: Integer; var acount: Integer);
   procedure itemnotifyexe(const sender: tlistitem; var action: nodeactionty);
   procedure updaterowvalueexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure pathsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure pathedshowhint(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
   procedure runexe(const sender: TObject);
   procedure cellevent(const sender: TObject; var info: celleventinfoty);
   procedure pathedbeforedialogexe(const sender: tfiledialogcontroller;
                   var dialogkind: filedialogkindty;
                   var aresult: modalresultty);
   procedure pathedafterdialogexe(const sender: tfiledialogcontroller;
                   var aresult: modalresultty);
   procedure editexe(const sender: TObject);
   procedure editmacroexe(const sender: TObject);
   procedure runallexe(const sender: TObject);
   procedure errorchangeexe(const sender: TObject);
   procedure runpaintglyphexe(const sender: tcustomintegergraphdataedit;
                   const acanvas: tcanvas; const avalue: Integer;
                   const arow: Integer);
   procedure copyitemexe(const sender: TObject);
   procedure pasteitemexe(const sender: TObject);
   procedure cutitemexe(const sender: TObject);
   procedure rowdeleteingexe(const sender: tcustomgrid; var aindex: Integer;
                   var acount: Integer);
   procedure dataenteredexe(const sender: TObject);
   procedure commentsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure updatepasteitem(const sender: tcustomaction);
   procedure updaterowactexe(const sender: tcustomaction);
   procedure resetexe(const sender: TObject);
   procedure aboutexe(const sender: TObject);
  protected
   procedure deleterow(const aindex: integer);
   procedure checkenabledstate();
   procedure refreshnumbers();
   procedure insertitem(const aitem: ttestnode; aindex: integer);
   procedure initdisp();
   procedure updatedisp(const astate: teststatety);
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msefileutils,testeditform,groupeditform,macrosform,
 mseeditglob,runform,msedrawtext,mseformatstr,msestockobjects,editform;

const
 captioncol = 1;
  
procedure tmainfo.connectmoduleexe(const sender: TObject);
begin
 treeed.itemlist.rootnode:= mainmo.rootnode;
end;
{
procedure tmainfo.createitemexe(const sender: tcustomitemlist;
               var item: ttreelistedititem);
begin
 item:= ttestnode.create(sender);
 with ttreeitemeditlist(sender) do begin
  insertparent.insert(insertparentindex,item);
 end;
 mainmo.projectchanged();
end;
}
procedure tmainfo.captionchaexe(const sender: TObject; var avalue: msestring);
begin
 if avalue = '' then begin
  caption:= 'MSErun';
 end
 else begin
  caption:= 'MSErun ('+ avalue+')';
 end;
end;

procedure tmainfo.closequeryexe(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if mainmo.closeproject() = mr_cancel then begin
  amodalresult:= mr_none;
 end;
end;

procedure tmainfo.deleterow(const aindex: integer);
begin
 treeed.itemlist.delete(aindex);  
 mainmo.projectchanged();
 refreshnumbers();
end;

procedure tmainfo.rowdeleteingexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
begin
 if sender.userinput then begin
  acount:= 0; //handled here
  deleterow(aindex);
 end;
end;

procedure tmainfo.insertgroupexe(const sender: TObject);
var
 n1: ttestgroupnode;
 n2: ttreelistitem;
 int1: integer;
begin
 n1:= ttestgroupnode.create();
 if grid.row < 0 then begin
  treeed.itemlist.insert(0,n1);
  int1:= 0;
 end
 else begin
  int1:= grid.row;
  n2:= treeed.item;
  if (n2 is ttestgroupnode) and (n2.count = 0) and n2.expanded then begin
   n2.add(n1);
  end
  else begin
   treeed.itemlist.insert(grid.row,n1);
  end;
 end;
 n1.getdefaults();
 mainmo.projectchanged();
 grid.focuscell(mgc(captioncol,int1));
 grid.col:= captioncol;
 treeed.beginedit();
end;

procedure tmainfo.insertitem(const aitem: ttestnode; aindex: integer);
var
 n2: ttreelistitem;
begin
 if aindex < 0 then begin
  aindex:= 0;
 end;
 n2:= treeed.item;
 if (n2 is ttestgroupnode) and (n2.count = 0) and n2.expanded then begin
  n2.add(aitem);
  n2.updateparentnotcheckedstate();
 end
 else begin
  treeed.itemlist.insert(aindex,aitem);  
 end;
 grid.row:= aindex;
 mainmo.projectchanged();
 refreshnumbers();
end;  

procedure tmainfo.rowinsertingexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
var
 n1: ttestitem;
begin
 if sender.userinput then begin
  acount:= 0; //handled here
  n1:= ttestitem.create();
  insertitem(n1,aindex);
  n1.getdefaults();
  grid.focuscell(mgc(captioncol,n1.index));
  treeed.beginedit();
 end;
end;

procedure tmainfo.rowsmovingexe(const sender: tcustomgrid;
               var fromindex: Integer; var toindex: Integer;
               var acount: Integer);
begin
 if sender.userinput then begin
  treeed.itemlist.moverow(fromindex,toindex);
  acount:= 0;
  mainmo.projectchanged();
  refreshnumbers();
 end;
end;

procedure tmainfo.itemnotifyexe(const sender: tlistitem;
               var action: nodeactionty);
begin
 if action = na_valuechange then begin
  mainmo.projectchanged();
  with ttreelistitem(sender) do begin
   updateparentnotcheckedstate();
   treeed.updateitemvalues(index,rowheight)
  end;
 end;
end;

procedure tmainfo.updaterowvalueexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
var
 int1: integer;
begin
 ttestnode(aitem).updateteststate();
 if aitem is ttestgroupnode then begin
  editbu[aindex]:= -1;
//  grid.datacols.mergecols(aindex);
 end
 else begin
  editbu[aindex]:= 0;
//  grid.datacols.unmergecols(aindex);
 end;
 if aitem is ttestpathnode then begin
  with ttestpathnode(aitem) do begin
   pathed[aindex]:= path;
   commented[aindex]:= comment;
   {
   int1:= -1;
   if treechecked then begin
    int1:= 0;
    case teststate of
     tes_ok: begin
      int1:= 1;
     end;
     tes_error: begin
      int1:= 2;
     end;
    end;
   end;
   }
   int1:= -1;
   if treechecked then begin
    int1:= imagenr mod 3;
   end;
   grid.rowcolorstate[aindex]:= int1;
   runbu[aindex]:= int1;
  end;
 end;
 checkenabledstate();
end;

procedure tmainfo.dataenteredexe(const sender: TObject);
begin
 mainmo.projectchanged();
end;

procedure tmainfo.pathsetexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
var
 fna1: filenamety;
begin
 if (avalue <> '') and (avalue[1] <> '/') and 
                    (treeed.item.parent is ttestpathnode) then begin
  fna1:= ttestpathnode(treeed.item.parent).rootfilepath;
  avalue:= relativepath(fna1+avalue,fna1);
 end;
 ttestpathnode(treeed.item).path:= avalue;
end;

procedure tmainfo.commentsetexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 ttestpathnode(treeed.item).comment:= avalue;
end;

procedure tmainfo.pathedshowhint(const sender: tdatacol; const arow: Integer;
               var info: hintinfoty);
begin
 if treeed[arow] is ttestpathnode then begin
  info.caption:= mainmo.expandmacros(ttestpathnode(treeed[arow]),
                      ttestpathnode(treeed[arow]).rootfilepath(),fn_path);
 end;
end;

procedure tmainfo.initdisp();
begin
 okdi.text:= ' ';
 errordi.text:= ' ';
 totaldi.text:= ' ';
 seterror(errordi,ers_none);
end;

procedure tmainfo.runexe(const sender: TObject);
begin
 initdisp();
 mainmo.runtest(ttestnode(treeed.item));
 with ttestnode(treeed.item) do begin
  updateparentteststate();
  treeed.updateitemvalues(grid.row,rowheight);
  treeed.updateparentvalues(grid.row);
 end;
end;

procedure tmainfo.updatedisp(const astate: teststatety);
begin
 treeed.updateitemvalues(0,grid.rowcount);
 okdi.text:= '';
 errordi.text:= '';
 okdi.value:= mainmo.okcount;
 totaldi.value:= okdi.value + mainmo.errorcount;
 errordi.value:= mainmo.errorcount;
 case astate of
  tes_canceled: begin
   totaldi.text:= 'Canceled';
   totaldi.textflags:= [tf_xcentered,tf_ycentered]
  end;
  tes_none: begin
   initdisp();
  end;
  else begin
   totaldi.text:= '';
   totaldi.textflags:= [tf_right,tf_ycentered]
  end;
 end;
end;

procedure tmainfo.runallexe(const sender: TObject);
var
 testres1: teststatety;
begin
 testres1:= mainmo.runtest(mainmo.rootnode);
 updatedisp(testres1);
end;

procedure tmainfo.resetexe(const sender: TObject);
begin
 if askconfirmation('Do you want to reset the state of all items?') then begin
  mainmo.resetitemstate();
  updatedisp(tes_none);
 end;
end;

procedure tmainfo.cellevent(const sender: TObject; var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  checkenabledstate();
 end;
end;

procedure tmainfo.checkenabledstate();
begin
{
 if grid.row >= 0 then begin
  runbu.enabled:= treeed[grid.row].treechecked();
 end;
}
end;

procedure tmainfo.pathedbeforedialogexe(const sender: tfiledialogcontroller;
               var dialogkind: filedialogkindty; var aresult: modalresultty);
begin
 if (treeed.item.parent is ttestpathnode) and (sender.filename <> '') and
            (sender.filename[1] <> '/') then begin
  sender.filename:= ttestpathnode(treeed.item.parent).rootfilepath + 
                                                         sender.filename;
 end;
end;

procedure tmainfo.pathedafterdialogexe(const sender: tfiledialogcontroller;
               var aresult: modalresultty);
begin
 if (aresult = mr_ok) and (treeed.item.parent is ttestpathnode) then begin
  sender.filename:= relativepath(sender.filename,
                             ttestpathnode(treeed.item.parent).rootfilepath);
 end;
end;

procedure tmainfo.editexe(const sender: TObject);
var
 editfo: teditfo;
begin
 if treeed.item is ttestitem then begin
  editfo:= ttesteditfo.create(nil);
 end
 else begin
  editfo:= tgroupeditfo.create(nil);
 end;
 
 try
  mainmo.beginedit(ttestnode(treeed.item),editfo);
  if editfo.show(ml_application) = mr_ok then begin
   mainmo.endedit(ttestitem(treeed.item),editfo);
   treeed.updateitemvalues;
  end;
 finally
  editfo.destroy();
 end;
end;

procedure tmainfo.editmacroexe(const sender: TObject);
var
 editfo: tmacrosfo;
begin
 editfo:= tmacrosfo.create(nil);
 try
  mainmo.begineditmacros(editfo);
  if editfo.show(ml_application) = mr_ok then begin
   mainmo.endeditmacros(editfo);
  end;
 finally
  editfo.destroy();
 end;
end;

procedure tmainfo.refreshnumbers;
begin
 grid[0].invalidate;
end;

procedure tmainfo.errorchangeexe(const sender: TObject);
begin
 if totaldi.value = 0 then begin
  seterror(errordi,ers_none);
 end
 else begin
  seterror(errordi,errordi.value > 0);
 end;
end;

procedure tmainfo.runpaintglyphexe(const sender: tcustomintegergraphdataedit;
               const acanvas: tcanvas; const avalue: Integer;
               const arow: Integer);
begin
 acanvas.font.shadow_color:= cl_ltgray;
 drawtext(acanvas,inttostrmse(ttestnode(treeed[arow]).nr),sender.clientrect,
                                              [tf_xcentered,tf_ycentered]);
end;

procedure tmainfo.copyitemexe(const sender: TObject);
begin
 mainmo.copytoclipboard(ttestnode(treeed.item));
end;

procedure tmainfo.pasteitemexe(const sender: TObject);
var
 item1: ttestnode;
begin
 item1:= mainmo.pastefromclipboard;
 if item1 <> nil then begin
  insertitem(item1,grid.row);
 end;
end;

procedure tmainfo.cutitemexe(const sender: TObject);
begin
 if grid.row >= 0 then begin
  with stockobjects do begin
   if askok(captions[sc_Delete_row_question],
                         captions[sc_Confirmation]) then begin
    mainmo.copytoclipboard(ttestnode(treeed.item));
    deleterow(grid.row);
   end;
  end;
 end; 
end;

procedure tmainfo.updatepasteitem(const sender: tcustomaction);
begin
 sender.enabled:= (grid.rowcount = 0) or (grid.row >= 0);
end;

procedure tmainfo.updaterowactexe(const sender: tcustomaction);
begin
 sender.enabled:= grid.row >= 0;
end;

procedure tmainfo.aboutexe(const sender: TObject);
begin
 showmessage('MSEgui version: '+mseguiversiontext+c_linefeed+
             'MSErun version: '+versiontext+c_linefeed+
             'Host: '+ platformtext+ c_linefeed+
             c_linefeed+
             copyrighttext+c_linefeed+
             'by Martin Schreiber','About MSEtest');
end;

end.
