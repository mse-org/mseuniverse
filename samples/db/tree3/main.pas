unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseact,
 msedataedits,msedragglob,msedropdownlist,mseedit,msegrids,msegridsglob,
 mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,msewidgetgrid,
 sysutils,msesplitter,msedatanodes,mselistbrowser;

type
 tmainfo = class(tmainform)
   datagrid: twidgetgrid;
   tsplitter1: tsplitter;
   treegrid: twidgetgrid;
   tstatfile1: tstatfile;
   id: tstringedit;
   depth: tintegeredit;
   treeed: ttreeitemedit;
   procedure dataenteredev(const sender: TObject);
   procedure createev(const sender: TObject);
   procedure destroyev(const sender: TObject);
   procedure rowcountchangeev(const sender: tcustomgrid);
  private
   froot: ttreelistedititem;
  public
   procedure buildtree();
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.createev(const sender: TObject);
begin
 froot:= ttreelistedititem.create(nil);
end;

procedure tmainfo.destroyev(const sender: TObject);
begin
 treegrid.clear();
 froot.free();
end;

procedure tmainfo.buildtree();

 procedure addleafs(const parent: ttreelistitem; const adepth: int32; 
                                                         var index: int32);
 var
  i1: int32;
  currentnode: ttreelistedititem;
 begin
  currentnode:= nil;
  while index < datagrid.rowcount do begin
   i1:= depth[index];
   if i1 <= adepth then begin
    break;
   end;
   if (i1 > adepth+1) and (currentnode <> nil) then begin
    addleafs(currentnode,i1-1,index);
   end
   else begin
    currentnode:= ttreelistedititem.create();
    currentnode.caption:= id[index];
    currentnode.expanded:= true;
    parent.add(currentnode);
    inc(index);
   end;
  end;
 end; //addleafs

var
 i1: int32;
begin
 treegrid.clear;
 i1:= 0;
 addleafs(froot,-1,i1);
 treeed.itemlist.addchildren(froot);
end;
 
procedure tmainfo.dataenteredev(const sender: TObject);
begin
 buildtree();
end;

procedure tmainfo.rowcountchangeev(const sender: tcustomgrid);
begin
 dataenteredev(sender);
end;

end.
