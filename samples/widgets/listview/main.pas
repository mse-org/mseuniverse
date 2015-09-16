unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 msedatanodes,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,
 mselistbrowser,msestatfile,msestream,msestrings,sysutils,msesplitter,msebitmap,
 msedragglob,msegraphedits,msescrollbar;

type
 tmainfo = class(tmainform)
   listview1: tlistview;
   tstatfile1: tstatfile;
   tsplitter1: tsplitter;
   listview2: tlistview;
   imli: timagelist;
   moveed: tbooleanedit;
   procedure createexe(const sender: TObject);
   procedure dragoverexe(const asender: TObject; const apos: pointty;
                   var adragobject: tdragobject; var accept: Boolean;
                   var processed: Boolean);
   procedure dragdropexe(const asender: TObject; const apos: pointty;
                   var adragobject: tdragobject; var processed: Boolean);
   procedure dragbegin2(const asender: TObject; const apos: pointty;
                   var adragobject: tdragobject; var processed: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msedrag;
 
procedure tmainfo.createexe(const sender: TObject);
var
 i1: int32;
 item1: tlistitem;
begin
 imli.beginupdate();
 for i1:= 0 to imli.count-1 do begin
  item1:= tlistitem.create();
  item1.imagenr:= i1;
  listview1.itemlist.add(item1);
 end;
 imli.endupdate();
end;

procedure tmainfo.dragoverexe(const asender: TObject; const apos: pointty;
               var adragobject: tdragobject; var accept: Boolean;
               var processed: Boolean);
begin
 if isobjectdrag(adragobject,tlistitem) and 
      (tlistitem(tobjectdragobject(adragobject).data).owner <> 
                                   tlistview(asender).itemlist) then begin
  accept:= true;
  processed:= true;
 end;
end;

procedure tmainfo.dragdropexe(const asender: TObject; const apos: pointty;
               var adragobject: tdragobject; var processed: Boolean);
var
 item1,item2,item3: tlistitem;
begin
 item1:= tlistitem(tobjectdragobject(adragobject).data);
 if item1.owner <> tlistview(asender).itemlist then begin
                   //otherwise use default item drag handling of tlistview
  with tlistview(asender) do begin
   defocuscell(); //no current selected item
   item2:= itematpos(apos);
   item3:= tlistitem.createassign(nil,item1);
   itemlist.add(item3);
   if item2 <> nil then begin
    moveitem(item3,item2,true);
   end
   else begin
    focuscell(indextocell(item3.index)); //focus added cell
   end;
   processed:= true;
   if moveed.value then begin
    item1.free;
   end;
  end;
 end;
end;

procedure tmainfo.dragbegin2(const asender: TObject; const apos: pointty;
               var adragobject: tdragobject; var processed: Boolean);
var
 item1: tlistitem;
begin
 with tlistview(asender) do begin
  item1:= itematpos(apos);
  if item1 <> nil then begin
   tlistitemdragobject.create(asender,adragobject,nullpoint,item1);
   processed:= true;
  end;
 end;
end;

end.
