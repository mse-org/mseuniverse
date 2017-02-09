{ MSEkicad Copyright (c) 2016-2017 by Martin Schreiber
   
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
unit bommodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mdb,msebufdataset,
 msedb,mseifiglob,mselocaldataset,msestrings,msedatabase,msesqldb,msqldb,
 sysutils,msesqlresult,mseificomp,mseificompglob,mseifiendpoint,mclasses,
 mseifidbcomp;

type
 variantarty = array of variant;
 getvalueseventty = function (const index: int32): variantarty of object;
 
 tbommo = class(tmsedatamodule)
   bomds: tlocaldataset;
   bomdso: tmsedatasource;
   bom_stockcompid: tmselargeintfield;
   compdistribdso: tmsedatasource;
   compdistribqu: tmsesqlquery;
   docusetqu: tmsesqlquery;
   docusetdso: tmsedatasource;
   prodfielstackdso: tmsedatasource;
   prodfilestackqu: tmsesqlquery;
   ds_pk: tmselargeintfield;
   dpg_pk: tifiint64linkcomp;
   dpg_title: tifistringlinkcomp;
   dpg_kind: tifienumlinkcomp;
   docupagelink: tfieldparamlink;
   docupagequ: tifisqlresult;
   docupagedso: tconnectedifidatasource;
   docupageupdate: tsqlstatement;
   docupageinsert: tsqlresult;
   docupagegrid: tifigridlinkcomp;
   docupagedelete: tsqlstatement;
   pageitemqu: tmsesqlquery;
   pageitempkpar: tparamconnector;
   pi_title: tmsestringfield;
   pi_mirrorhorz: tmsebooleanfield;
   pi_mirrorvert: tmsebooleanfield;
   pi_rotate90: tmsebooleanfield;
   pi_rotate180: tmsebooleanfield;
   pi_scale: tmsefloatfield;
   pi_shifthorz: tmsefloatfield;
   pi_shiftvert: tmsefloatfield;
   pi_filename: tmsestringfield;
   pi_text: tmsestringfield;
   plotitemdso: tconnectedifidatasource;
   plotitemqu: tifisqlresult;
   plotitemlink: tfieldparamlink;
   pi_pk: tmselargeintfield;
   pageitemdso: tmsedatasource;
   pli_pk: tifiint64linkcomp;
   pli_layer: tifidropdownlistlinkcomp;
   plotitemgrid: tifigridlinkcomp;
   plotitemdelete: tsqlstatement;
   plotitemupdate: tsqlstatement;
   plotiteminsert: tsqlresult;
   pli_refon: tifibooleanlinkcomp;
   pli_valon: tifibooleanlinkcomp;
   pli_invison: tifibooleanlinkcomp;
   pli_drillmarks: tifidropdownlistlinkcomp;
   pli_color: tifidropdownlistlinkcomp;
   pli_refcolor: tifidropdownlistlinkcomp;
   pli_valcolor: tifidropdownlistlinkcomp;
   procedure afteropenev(DataSet: TDataSet);
   procedure docupagepostev(const sender: TDataSet; const master: TDataSet);
   procedure docupagerefreshev(const sender: TObject);
   procedure docupagedelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
   procedure plotitempostev(const sender: TDataSet; const master: TDataSet);
   procedure plotitemrefreshev(const sender: TObject);
   procedure plotitemdelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
  protected
   fdeleteddocupages: int64arty;
   fdeletedplotitems: int64arty;
   procedure refreshitems(var deleted: int64arty;
             const pk: tifiint64linkcomp; const query: tmsesqlquery;
                                    const dataso: tconnectedifidatasource);
   function getdocupagevalues(const index: int32): variantarty;
   function getplotitemvalues(const index: int32): variantarty;
   procedure updateitems(var deleted: int64arty;
         const pk: tifiint64linkcomp;
         const deletestatement,updatestatement: tsqlstatement;
         const insertstatement: tsqlresult;
         const getvalues: getvalueseventty);
  public
   constructor create(aowner: tcomponent); override;
   procedure editdocupage(const arow: int32);
 end;
var
 bommo: tbommo;
implementation
uses
 bommodule_mfm,mainmodule,msearrayutils,titledialogform,msegui,bomdialogform,
 schematicplotdialogform,partlistdialogform,layerplotdialogform,
 drillmapdialogform;

constructor tbommo.create(aowner: tcomponent);
begin
 inherited;
 dpg_kind.c.dropdown.cols[0].asarray:= mainmo.docupagekinds;
 pli_layer.c.dropdown.cols[0].asarray:= mainmo.layernames;
 pli_color.c.dropdown.cols[0].asarray:= mainmo.edacolornames;
 pli_refcolor.c.dropdown.cols[0].asarray:= mainmo.edacolornames;
 pli_valcolor.c.dropdown.cols[0].asarray:= mainmo.edacolornames;
 pli_drillmarks.c.dropdown.cols[0].asarray:= mainmo.drillmarknames;
end;

procedure tbommo.editdocupage(const arow: int32);
var
 res: modalresultty;
begin
 if arow >= 0 then begin
  res:= mr_none;
  docusetqu.checkbrowsemode();
  pageitempkpar.param.value:= dpg_pk.c.griddata[arow];
  pageitemqu.controller.refresh();
  if not pageitemqu.eof then begin
   case docupagekindty(dpg_kind.c.griddata[arow]+1) of
    dpk_title: begin
     res:= ttitledialogfo.create(nil).show(ml_application);
    end;
    dpk_schematic: begin
     res:= tschematicplotdialogfo.create(nil).show(ml_application);
    end;
    dpk_layerplot: begin
     res:= tlayerplotdialogfo.create(nil).show(ml_application);
    end;
    dpk_drillmap: begin
     res:= tdrillmapdialogfo.create(nil).show(ml_application);
    end;
    dpk_partlist: begin
     res:= tpartlistdialogfo.create(nil).show(ml_application);
    end;
    dpk_bom: begin
     res:= tbomdialogfo.create(nil).show(ml_application);
    end;
   end;
  end;
  if res = mr_ok then begin
   pageitemqu.checkbrowsemode();
   dpg_title.c.griddata[arow]:= pi_title.asmsestring;
  end;
  pageitemqu.active:= false;
 end;
end;
 
procedure tbommo.afteropenev(DataSet: TDataSet);
var
 index1: int32;
 recno1: int32;
 val,val1,val2,desc: msestring;
 valbefore,val1before,val2before,descbefore: msestring;
 compbefore: int64;
 reflist: msestring;
 count1: int32;

 procedure addcomp();
 begin
  if count1 > 0 then begin
   setlength(reflist,length(reflist)-1); //remove trailing space
   bomds.appendrecord([count1,descbefore,reflist,compbefore]);
  end;
  valbefore:= val;
  val1before:= val1;
  val2before:= val2;
  descbefore:= desc;
  compbefore:= mainmo.c_stockitemid.asid;
  count1:= 0;
  reflist:= '';
 end;//addcomp

begin
 with mainmo.compds do begin
  index1:= indexlocal.activeindex;
  recno1:= recno;
  try
   bomds.disablecontrols();
   bomds.resetindex;
   indexlocal.indexbyname('comp').active:= true;
   disablecontrols();
   valbefore:= '';
   val1before:= '';
   val2before:= '';
   descbefore:= '';
   reflist:= '';
   count1:= 0;
   first();
   while not eof do begin
    val:= mseuppercase(mainmo.c_value.asmsestring);
    val1:= mseuppercase(mainmo.c_value1.asmsestring);
    val2:= mseuppercase(mainmo.c_value2.asmsestring);
    desc:= mainmo.c_description.asmsestring;
    if (val <> valbefore) or (val1 <> val1before) or 
                        (val2 <> val2before) or (desc <> descbefore) then begin
     addcomp();
    end;
    reflist:= reflist + mainmo.c_ref.asmsestring + ' ';
    inc(count1);
    next();
   end;
   addcomp();
   bomds.indexlocal[0].active:= true;
   bomds.first();
   bomds.enablecontrols();
   enablecontrols();
  finally
   indexlocal.activeindex:= index1;
   recno:= recno1;
  end;
 end;
end;

procedure tbommo.refreshitems(var deleted: int64arty;
             const pk: tifiint64linkcomp; const query: tmsesqlquery;
                                    const dataso: tconnectedifidatasource);
var
 i1: int32;
begin
 if not query.controller.posting1 or 
                       query.controller.deleting then begin
  deleted:= nil;
  if query.controller.copying() then begin
   with pk.c.griddata do begin
    for i1:= 0 to count-1 do begin
     items[i1]:= 0; //prepare for insert
    end;
   end;
  end
  else begin
   dataso.refresh();
  end;
 end;
end;

procedure tbommo.docupagerefreshev(const sender: TObject);
begin
 refreshitems(fdeleteddocupages,dpg_pk,docusetqu,docupagedso);
end;

{
procedure tbommo.docupagerefreshev(const sender: TObject);
var
 i1: int32;
begin
 if not docusetqu.controller.posting1 or 
                       docusetqu.controller.deleting then begin
  fdeleteddocupages:= nil;
  if docusetqu.controller.copying() then begin
   with dpg_pk.c.griddata do begin
    for i1:= 0 to count-1 do begin
     items[i1]:= 0; //prepare for insert
    end;
   end;
  end
  else begin
   docupagedso.refresh();
  end;
 end;
end;
}
procedure tbommo.docupagepostev(const sender: TDataSet; const master: TDataSet);
begin
 updateitems(fdeleteddocupages,dpg_pk,docupagedelete,docupageupdate,
                 docupageinsert,@getdocupagevalues);
end;

procedure tbommo.updateitems(var deleted: int64arty;
         const pk: tifiint64linkcomp;
         const deletestatement,updatestatement: tsqlstatement;
         const insertstatement: tsqlresult;
         const getvalues: getvalueseventty);
var
 i1: int32;
begin
 for i1:= 0 to high(deleted) do begin
  deletestatement.execute([deleted[i1]]);
 end;
 deleted:= nil;
 with pk.c.griddata do begin
  for i1:= 0 to count-1 do begin
   if items[i1] = 0 then begin
    insertstatement.refresh(getvalues(i1));
    items[i1]:= insertstatement[0].asid;
   end
   else begin
    updatestatement.execute(getvalues(i1));
   end;
  end;
 end;
end;

function tbommo.getdocupagevalues(const index: int32): variantarty;
begin
 setlength(result,4);
 result[0]:= dpg_pk.c.griddata[index];
 result[1]:= index;
 result[2]:= dpg_kind.c.griddata[index];
 result[3]:= dpg_title.c.griddata[index];
end;

{
procedure tbommo.updatedocupages();
var
 i1: int32;
begin
 for i1:= 0 to high(fdeleteddocupages) do begin
  docupagedelete.execute([fdeleteddocupages[i1]]);
 end;
 fdeleteddocupages:= nil;
 with dpg_pk.c.griddata do begin
  for i1:= 0 to count-1 do begin
   if items[i1] = 0 then begin
    docupageinsert.refresh([ds_pk.value,i1,dpg_kind.c.griddata[i1],
                                             dpg_title.c.griddata[i1]]);
    items[i1]:= docupageinsert[0].asid;
   end
   else begin
    docupageupdate.execute([items[i1],i1,dpg_kind.c.griddata[i1],
                                             dpg_title.c.griddata[i1]]);
   end;
  end;
 end;
end;
}
procedure tbommo.docupagedelev(const sender: TObject; var aindex: Integer;
               var acount: Integer);
begin
 additem(fdeleteddocupages,dpg_pk.c.griddata[aindex]);
end;

function tbommo.getplotitemvalues(const index: int32): variantarty;
begin
 setlength(result,11);
 result[0]:= pli_pk.c.griddata[index];
 result[1]:= pi_pk.value;
 result[2]:= index;
 result[3]:= pli_layer.c.griddata[index];
 result[4]:= pli_color.c.griddata[index];
 result[5]:= pli_refon.c.griddata[index];
 result[6]:= pli_refcolor.c.griddata[index];
 result[7]:= pli_valon.c.griddata[index];
 result[8]:= pli_valcolor.c.griddata[index];
 result[9]:= pli_invison.c.griddata[index];
 result[10]:= pli_drillmarks.c.griddata[index];
end;

procedure tbommo.plotitempostev(const sender: TDataSet; const master: TDataSet);
begin
 updateitems(fdeletedplotitems,pli_pk,plotitemdelete,plotitemupdate,
                 plotiteminsert,@getplotitemvalues);
end;

procedure tbommo.plotitemrefreshev(const sender: TObject);
begin
 refreshitems(fdeletedplotitems,pli_pk,pageitemqu,plotitemdso);
end;

procedure tbommo.plotitemdelev(const sender: TObject; var aindex: Integer;
               var acount: Integer);
begin
 additem(fdeletedplotitems,pli_pk.c.griddata[aindex]);
end;

end.
