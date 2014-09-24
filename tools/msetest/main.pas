unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mseifiendpoint;

type
 tmainfo = class(tmainform)
   tmainmenu1: tmainmenu;
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   connectmodule: tifiactionendpoint;
   projectcaption: tifistringendpoint;
   tpopupmenu1: tpopupmenu;
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
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mainmodule;
 
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
  acount:= 0; //handled here
  n1:= ttestnode.create();
  n2:= treeed.item;
  if (n2 is ttestgroupnode) and (n2.count = 0) and n2.expanded then begin
   n2.add(n1);
  end
  else begin
   treeed.itemlist.insert(aindex,n1);  
  end;
  mainmo.projectchanged();
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

end.
