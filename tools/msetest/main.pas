unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mseifiendpoint,
 msebitmap,msefiledialog,msesys;

type
 tmainfo = class(tmainform)
   tmainmenu1: tmainmenu;
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   connectmodule: tifiactionendpoint;
   projectcaption: tifistringendpoint;
   tpopupmenu1: tpopupmenu;
   pathed: tfilenameedit;
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
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mainmodule,msefileutils;
 
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
 if not mainmo.closeproject() then begin
  amodalresult:= mr_none;
 end;
end;

procedure tmainfo.rowdeletedexe(const sender: tcustomgrid;
               const aindex: Integer; const acount: Integer);
begin
 mainmo.projectchanged();
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
  ttreelistitem(sender).updateparentnotcheckedstate();
 end;
end;

procedure tmainfo.updaterowvalueexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
begin
 if aitem is ttestgroupnode then begin
//  grid.datacols.mergecols(aindex);
 end
 else begin
//  grid.datacols.unmergecols(aindex);
 end;
 if aitem is ttestpathnode then begin
  with ttestpathnode(aitem) do begin
   pathed[aindex]:= path;
  end;
 end;
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
  info.caption:= ttestpathnode(treeed[arow]).rootfilepath();
 end;
end;

end.
