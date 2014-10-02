unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mseifiendpoint,
 msebitmap,msefiledialog,msesys,msegraphedits,msescrollbar,msedialog,mseact,
 mseactions,msedispwidgets,mserichstring,msetimer;

type
 tmainfo = class(tmainform)
   tmainmenu1: tmainmenu;
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
  protected
   procedure checkenabledstate();
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mainmodule,msefileutils,editform,macrosform;
 
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
 end;
end;

procedure tmainfo.insertgroupexe(const sender: TObject);
begin
 treeed.itemlist.insert(grid.row,ttestgroupnode.create());
 mainmo.projectchanged();
end;

procedure tmainfo.rowinsertingexe(const sender: tcustomgrid;
               var aindex: Integer; var acount: Integer);
var
 n1: ttestnode;
 n2: ttreelistitem;
begin
 if sender.userinput then begin
  n1:= ttestnode.create();
  n2:= treeed.item;
  if (n2 is ttestgroupnode) and (n2.count = 0) and n2.expanded then begin
   n2.add(n1);
   n2.updateparentnotcheckedstate();
  end
  else begin
   treeed.itemlist.insert(aindex,n1);  
  end;
  mainmo.projectchanged();
  acount:= 0; //handled here
 end;
end;

procedure tmainfo.rowsmovingexe(const sender: tcustomgrid;
               var fromindex: Integer; var toindex: Integer;
               var acount: Integer);
begin
 if sender.userinput then begin
  treeed.itemlist.moverow(fromindex,toindex);
  acount:= 0;
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
 mainmo.runtest(ttestnode(treeed.item));
 with ttestnode(treeed.item) do begin
  updateparentteststate();
  treeed.updateitemvalues(grid.row,rowheight);
  treeed.updateparentvalues(grid.row);
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
 editfo:= teditfo.create(nil);
 try
  mainmo.beginedit(ttestitem(treeed.item),editfo);
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

end.
