unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mseifiendpoint,
 msebitmap,msefiledialog,msesys,msegraphedits,msescrollbar,msedialog,mseact,
 mseactions,msedispwidgets,mserichstring,msetimer,msemenuwidgets,msesplitter;

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
   nrdi: tintegeredit;
   tlayouter1: tlayouter;
   tmainmenuwidget1: tmainmenuwidget;
   tspacer1: tspacer;
   okdi: tintegerdisp;
   tspacer2: tspacer;
   errordi: tintegerdisp;
   totaldi: tintegerdisp;
   tspacer3: tspacer;
   procedure connectmoduleexe(const sender: TObject);
//   procedure createitemexe(const sender: tcustomitemlist;
//                   var item: ttreelistedititem);
   procedure captionchaexe(const sender: TObject; var avalue: msestring);
   procedure closequeryexe(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure rowdeletedexe(const sender: tcustomgrid; const aindex: Integer;
                   const acount: Integer);
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
  protected
   procedure checkenabledstate();
   procedure refreshnumbers();
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mainmodule,msefileutils,testeditform,groupeditform,macrosform,
 mseeditglob,runform;
const
 captioncol = 2;
  
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
 caption:= 'MSEtest ('+ avalue+')';
end;

procedure tmainfo.closequeryexe(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if mainmo.closeproject() = mr_cancel then begin
  amodalresult:= mr_none;
 end;
end;

procedure tmainfo.rowdeletedexe(const sender: tcustomgrid;
               const aindex: Integer; const acount: Integer);
begin
 if sender.userinput then begin
  mainmo.projectchanged();
  refreshnumbers();
 end;
end;

procedure tmainfo.insertgroupexe(const sender: TObject);
var
 n1: ttestgroupnode;
begin
 n1:= ttestgroupnode.create();
 treeed.itemlist.insert(grid.row,n1);
 n1.getdefaults();
 mainmo.projectchanged();
 grid.col:= captioncol;
 treeed.beginedit();
end;

procedure tmainfo.rowinsertingexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
var
 n1: ttestitem;
 n2: ttreelistitem;
begin
 if sender.userinput then begin
  acount:= 0; //handled here
  n1:= ttestitem.create();
  n2:= treeed.item;
  if (n2 is ttestgroupnode) and (n2.count = 0) and n2.expanded then begin
   n2.add(n1);
   n2.updateparentnotcheckedstate();
  end
  else begin
   treeed.itemlist.insert(aindex,n1);  
  end;
  n1.getdefaults();
  mainmo.projectchanged();
  grid.focuscell(mgc(1,n1.index));
  treeed.beginedit();
  refreshnumbers();
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
 nrdi[aindex]:= ttestnode(aitem).nr;
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
   grid.rowcolorstate[aindex]:= int1;
   runbu[aindex]:= int1;
  end;
 end;
 checkenabledstate();
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
 mainmo.projectchanged();
end;

procedure tmainfo.pathedshowhint(const sender: tdatacol; const arow: Integer;
               var info: hintinfoty);
begin
 if treeed[arow] is ttestpathnode then begin
  info.caption:= mainmo.expandmacros(ttestpathnode(treeed[arow]),
                         ttestpathnode(treeed[arow]).rootfilepath());
 end;
end;

procedure tmainfo.runexe(const sender: TObject);
begin
 okdi.text:= ' ';
 errordi.text:= ' ';
 totaldi.text:= ' ';
 seterror(errordi,false);
 mainmo.runtest(ttestnode(treeed.item));
 with ttestnode(treeed.item) do begin
  updateparentteststate();
  treeed.updateitemvalues(grid.row,rowheight);
  treeed.updateparentvalues(grid.row);
 end;
end;

procedure tmainfo.runallexe(const sender: TObject);
begin
 mainmo.runtest(mainmo.rootnode);
 treeed.updateitemvalues(0,grid.rowcount);
 okdi.text:= '';
 errordi.text:= '';
 totaldi.text:= '';
 okdi.value:= mainmo.okcount;
 errordi.value:= mainmo.errorcount;
 totaldi.value:= okdi.value + errordi.value;
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
 editfo: tmseform;
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
var
 po1: ptestnode;
 po2: pinteger;
 int1: integer;
begin
 po1:= treeed.itemlist.datapo;
 po2:= nrdi.griddata.datapo;
 for int1:= 0 to grid.rowhigh do begin
  po2^:= po1^.nr;
  inc(po1);
  inc(po2);
 end;
 grid[0].invalidate;
end;

procedure tmainfo.errorchangeexe(const sender: TObject);
begin
 seterror(errordi,errordi.value > 0);
end;

end.
