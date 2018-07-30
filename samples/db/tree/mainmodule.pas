unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mdb,msedb,mseifiglob,
 msebufdataset,mselocaldataset,mselistbrowser,mseificomp,mseificompglob,mseact,
 msedataedits,msedatanodes,msedropdownlist,mseedit,msegraphics,msegraphutils,
 msegrids,msegui,mseguiglob,msemenus,msestat,msestatfile,msestream,sysutils;

type
 tidnode = class(ttreelistedititem)
  private
   fid: int32;
  public
   property id: int32 read fid;
 end;

 titemnode = class(tidnode)
  protected
   frootindex: int32;
  public
   intval: int32;
   floatval: flo64;
 end;
 
 tmainmo = class(tmsedatamodule)
   caption: tmsestringfield;
   parentid: tmselongintfield;
   id: tmselongintfield;
   dso: tmsedatasource;
   ds: tlocaldataset;
   gridlink: tifigridlinkcomp;
   treelink: tifitreeitemlinkcomp;
   order: tmselongintfield;
   intval: tmselongintfield;
   floatval: tmsefloatfield;
   procedure loadedev(const sender: TObject);
   procedure beforepostev(DataSet: TDataSet);
   procedure deletingev(const sender: TObject; var aindex: Integer;
                   var acount: Integer; const userinput: Boolean);
   procedure insertingev(const sender: TObject; var aindex: Integer;
                   var acount: Integer; const userinput: Boolean);
   procedure datentev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient; const aindex: Integer);
  private
   fid: int32;
  protected
   procedure nodetodb(const anode: titemnode);
  public
   function getid: int32;
   function gettreedata(): ttreelistedititem;
 end;
 
var
 mainmo: tmainmo;
 
implementation
uses
 mainmodule_mfm;
 
procedure tmainmo.loadedev(const sender: TObject);
begin
 ds.active:= true; //active indexfield is id
 ds.last;
 fid:= id.asinteger; //default 0
end;

function tmainmo.getid: int32;
begin
 inc(fid);
 result:= fid;
end;

function tmainmo.gettreedata(): ttreelistedititem;

 procedure addchildren(const anode: tidnode);
 var
  bm1: bookmarkdataty;
  i1: int32;
  n1: titemnode;
 begin
  if ds.indexlocal[1].find([anode.id],[],bm1) then begin //find parentid
   i1:= bm1.recno;
   repeat
    n1:= titemnode.create();
    n1.subitems:= true;
    n1.fid:= ds.currentasinteger[id,i1];
    n1.caption:= ds.currentasmsestring[caption,i1];
    n1.intval:= ds.currentasinteger[intval,i1];
    n1.floatval:= ds.currentasfloat[floatval,i1];
    anode.add(n1);
    addchildren(n1);
    inc(i1);
   until (i1 >= ds.recordcount) or 
                         (ds.currentasinteger[parentid,i1] <> anode.id);
  end;
 end; //addchildren()
 
begin
 result:= titemnode.create();
 ds.indexlocal[1].active:= true; //order by parentid
 addchildren(titemnode(result));
end;

procedure tmainmo.beforepostev(DataSet: TDataSet);
begin
 if id.isnull then begin
  id.asinteger:= getid();
 end;
end;

procedure tmainmo.nodetodb(const anode: titemnode);
var
 b1: boolean;
begin
 if anode <> nil then begin
  b1:= ds.indexlocal[0].find([anode.id],[],false,false,true); 
                                         //no checkbrowswmode
  if ds.state = dsinsert then begin
   if b1 then begin
    ds.cancel();
    raise exception.create('Duplicate ID');
   end;
  end
  else begin
   if not b1 then begin
    raise exception.create('ID not found');
   end;
   ds.edit();
  end;
  id.asinteger:= anode.id;
  if anode.parent <> nil then begin
   parentid.asinteger:= titemnode(anode.parent).id;
  end
  else begin
   parentid.asinteger:= 0;
  end;
  if anode.fparentindex < 0 then begin
   order.asinteger:= anode.frootindex;
  end
  else begin
   order.asinteger:= anode.fparentindex;
  end;
  caption.asmsestring:= anode.caption;
  intval.asinteger:= anode.intval;
  floatval.asfloat:= anode.floatval;
  ds.post();
 end;
end;

procedure tmainmo.insertingev(const sender: TObject; var aindex: Integer;
               var acount: Integer; const userinput: Boolean);
var
 n1,n2: ttreelistedititem;
 n3: titemnode;
 after: boolean;
 i1: int32;
 p1,pa,pe: ptreelistedititem;
begin
 if userinput then begin
  pointer(n1):= treelink.c.item;
  n3:= titemnode.create();
  n3.fid:= getid;
  if n1 <> nil then begin
   after:= aindex <> n1.editwidget.gridrow;
   if n1.expanded and (n1.count = 0) then begin
    n1.add(n3);
    n1.expanded:= true;
    with n1.editwidget do begin
     gridrow:= gridrow+1;
    end;
   end
   else begin
    n2:= ttreelistedititem(n1.parent);
    if n2 <> nil then begin
     n2.insert(n1.parentindex+aindex-n1.editwidget.grid.row,n3);
     if after then begin
      with n1.editwidget do begin
       gridrow:= gridrow+1;
      end;
     end;
     for i1:= n3.parentindex+1 to n2.count-1 do begin
      nodetodb(titemnode(n2[i1])); //update order
     end;
    end
    else begin
     n1.editwidget.itemlist.insert(aindex,n3);
     if not after then begin
      with n1.editwidget do begin
       gridrow:= gridrow-1;
      end;
     end;
     p1:= n1.editwidget.itemlist.datapo;
     pa:= p1 + aindex;
     pe:= p1 + n1.editwidget.itemlist.count;
     i1:= 0;
     while p1 < pe do begin
      if p1^.treelevel = 0 then begin
       if p1 = pa then begin
        n3.frootindex:= i1;
       end;
       if p1 > pa then begin
        titemnode(p1^).frootindex:= i1;
        nodetodb(titemnode(p1^));
       end;
       inc(i1);
      end;
      inc(p1);
     end;
    end;
   end;
  end
  else begin
   n3.frootindex:= bigint;
   treelink.c.itemlist.add(n3);
   treelink.c.itemedit.gridrow:= bigint;
  end;
  ds.insert;
  nodetodb(n3);
  acount:= 0;
 end;
end;

procedure tmainmo.deletingev(const sender: TObject; var aindex: Integer;
               var acount: Integer; const userinput: Boolean);

 procedure dodelete(const anode: titemnode);
 var
  i1: int32;
 begin
  for i1:= 0 to anode.count - 1 do begin
   dodelete(titemnode(anode[i1]));
  end;
  if ds.indexlocal[0].find([anode.id],[]) then begin
   ds.delete();
  end;
 end;
 
var
 n1: titemnode;
 n2: ttreelistitem;
begin
 if userinput then begin
  n1:= titemnode(treelink.c.item);
  if (n1 <> nil) then begin
   dodelete(n1);
   n2:= n1.parent;
   n1.destroy();
   if n2 <> nil then begin
    n2.subitems:= true; //restore expanding box
   end;
  end;
  acount:= 0;
 end;
end;

procedure tmainmo.datentev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const aindex: Integer);
begin
 nodetodb(titemnode(treelink.c.item));
end;

end.
