unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mdb,msedb,mseifiglob,
 msebufdataset,mselocaldataset,mselistbrowser,mseificomp,mseificompglob,mseact,
 msedataedits,msedatanodes,msedropdownlist,mseedit,msegraphics,msegraphutils,
 msegrids,msegui,mseguiglob,msemenus,msestat,msestatfile,msestream,sysutils,
 msedatabase,msefb3connection,msqldb,msesqldb,mselookupbuffer,msesqlresult,
 msefb3service,mseactions;

type
 tidnode = class(ttreelistedititem)
  private
   fid: int64;
  public
   property id: int64 read fid;
 end;

 titemnode = class(tidnode)
  protected
  public
   intval: int32;
   floatval: flo64;
 end;
 
 tmainmo = class(tmsedatamodule)
   gridlink: tifigridlinkcomp;
   treelink: tifitreeitemlinkcomp;
   tree_idmax: tsqlresultconnector;
   tree_idmin: tsqlresultconnector;
   tree_caption: tsqlresultconnector;
   tree_pk: tsqlresultconnector;
   fetchtree: tsqlresult;
   trans: tmsesqltransaction;
   conn: tfb3connection;
   insertitem: tsqlresult;
   idminpar: tparamconnector;
   fetchidrange: tsqlresult;
   fetchidrange_pk: tparamconnector;
   updateitem: tsqlstatement;
   updateitem_pk: tparamconnector;
   updateitem_caption: tparamconnector;
   deleteitem: tsqlstatement;
   deleteitem_pk: tparamconnector;
   updateitem_intval: tparamconnector;
   updateitem_floatval: tparamconnector;
   tree_intval: tsqlresultconnector;
   tree_floatval: tsqlresultconnector;
   service: tfb3service;
   createdbact: taction;
   procedure deletingev(const sender: TObject; var aindex: Integer;
                   var acount: Integer; const userinput: Boolean);
   procedure insertingev(const sender: TObject; var aindex: Integer;
                   var acount: Integer; const userinput: Boolean);
   procedure datentev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient; const aindex: Integer);
   procedure createdbev(const sender: TObject);
   procedure serviceendev(const sender: tfb3service; const aborted: Boolean);
  private
  protected
   procedure nodetodb(const anode: titemnode);
  public
   function gettreedata(): ttreelistedititem;
 end;
 
var
 mainmo: tmainmo;
 
implementation
uses
 mainmodule_mfm;
 
function tmainmo.gettreedata(): ttreelistedititem;

 procedure addchildren(const anode: tidnode; const min,max: int32);
 var
  i1,i2: int32;
  n1: titemnode;
 begin
  while not fetchtree.eof and (tree_idmin.col.asinteger < max) do begin
   n1:= titemnode.create();
   n1.fid:= tree_pk.col.aslargeint;
   n1.caption:= tree_caption.col.asmsestring;
   n1.intval:= tree_intval.col.asinteger;
   n1.floatval:= tree_floatval.col.asfloat;
   anode.add(n1);
   i1:= tree_idmin.col.asinteger;
   i2:= tree_idmax.col.asinteger;
   fetchtree.next;
   addchildren(n1,i1,i2);
  end;
 end; //addchildren()
 
begin
 fetchtree.active:= true;
 try
  result:= titemnode.create();
  addchildren(titemnode(result),0,maxint);
 finally
  trans.rollback();
 end;
end;

procedure tmainmo.nodetodb(const anode: titemnode);
begin
 if anode <> nil then begin
  updateitem_pk.param.asid:= anode.id;
  updateitem_caption.param.asmsestring:= anode.caption;
  updateitem_intval.param.asinteger:= anode.intval;
  updateitem_floatval.param.asfloat:= anode.floatval;
  updateitem.execute();
  trans.commit();
 end;
end;

procedure tmainmo.insertingev(const sender: TObject; var aindex: Integer;
               var acount: Integer; const userinput: Boolean);
var
 n1,n2: ttreelistedititem;
 n3: titemnode;
 after: boolean;
 i1: int32;
 belowpk: int64;
 usemin: boolean;
begin
 if userinput then begin
  acount:= 0;
  belowpk:= -1;
  usemin:= false;
  pointer(n1):= treelink.c.item;
  n3:= titemnode.create();
  if n1 <> nil then begin
   after:= aindex <> n1.editwidget.gridrow;
   if n1.expanded and (n1.count = 0) then begin
    n1.add(n3);
    n1.expanded:= true;
    belowpk:= titemnode(n1).id;
    usemin:= true;
    with n1.editwidget do begin
     gridrow:= gridrow+1;
    end;
   end
   else begin
    n2:= ttreelistedititem(n1.parent);
    if n2 <> nil then begin
     i1:= n1.parentindex+aindex-n1.editwidget.grid.row;
     if i1 <= 0 then begin
      belowpk:= titemnode(n2).id;
      usemin:= true;
     end
     else begin
      belowpk:= titemnode(n2[i1-1]).id;
     end;
     n2.insert(i1,n3);
     if after then begin
      with n1.editwidget do begin
       gridrow:= gridrow+1;
      end;
     end;
    end
    else begin
     if n1.editwidget.itemlist.count > 0 then begin
      n3.destroy();   //single root only
      exit;
     end;
     n1.editwidget.itemlist.insert(aindex,n3);
     if aindex > 0 then begin
      belowpk:= titemnode(n1.editwidget.itemlist[aindex-1]).id;
     end;
     if not after then begin
      with n1.editwidget do begin
       gridrow:= gridrow-1;
      end;
     end;
    end;
   end;
  end
  else begin
   treelink.c.itemlist.add(n3);
   treelink.c.itemedit.gridrow:= bigint;
  end;
  if belowpk < 0 then begin
   idminpar.param.asinteger:= 0;
  end
  else begin
   fetchidrange_pk.param.aslargeint:= belowpk;
   fetchidrange.active:= true;
   if fetchidrange.eof then begin
    raise exception.create('Error: PK '+inttostr(belowpk)+' not found');
   end;
   if usemin then begin
    idminpar.param.asinteger:= fetchidrange[0].asinteger+1;
   end
   else begin
    idminpar.param.asinteger:= fetchidrange[1].asinteger+1;
   end;
  end;
  insertitem.active:= true;
  n3.fid:= insertitem[0].asid;
  trans.commit();
 end;
end;

procedure tmainmo.deletingev(const sender: TObject; var aindex: Integer;
               var acount: Integer; const userinput: Boolean);
var
 n1: titemnode;
begin
 if userinput then begin
  n1:= titemnode(treelink.c.item);
  if (n1 <> nil) then begin
   deleteitem_pk.param.asid:= n1.id;
   deleteitem.execute();
   trans.commit();
   n1.destroy();
  end;
  acount:= 0;
 end;
end;

procedure tmainmo.datentev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const aindex: Integer);
begin
 nodetodb(titemnode(treelink.c.item));
end;

procedure tmainmo.createdbev(const sender: TObject);
begin
 service.connected:= true;
 service.restorestart(['tree.fbk'],['tree.fdb'],[]);
end;

procedure tmainmo.serviceendev(const sender: tfb3service;
               const aborted: Boolean);
begin
 sender.connected:= false;
end;

end.
