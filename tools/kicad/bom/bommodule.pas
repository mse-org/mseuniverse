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
   ds_docudir: tmsestringfield;
   ds_psfile: tmsestringfield;
   ds_pdffile: tmsestringfield;
   ds_width: tmsefloatfield;
   ds_height: tmsefloatfield;
   ds_margleft: tmsefloatfield;
   ds_margright: tmsefloatfield;
   ds_margtop: tmsefloatfield;
   ds_margbottom: tmsefloatfield;
   pi_layera: tmsestringfield;
   pi_layerb: tmsestringfield;
   pi_npt: tmsebooleanfield;
   pi_showref: tmsebooleanfield;
   pi_showdist: tmsebooleanfield;
   dpg_kind: tifidropdownlistlinkcomp;
   pi_kind: tmsestringfield;
   proditemlink: tfieldparamlink;
   pf_pk: tmselargeintfield;
   pli_format: tifidropdownlistlinkcomp;
   pli_filename: tifistringlinkcomp;
   dri_layera: tifidropdownlistlinkcomp;
   dri_layerb: tifidropdownlistlinkcomp;
   dri_npt: tifibooleanlinkcomp;
   drillitemdso: tconnectedifidatasource;
   drillitemqu: tifisqlresult;
   dri_pk: tifiint64linkcomp;
   dri_filename: tifistringlinkcomp;
   drillitemdelete: tsqlstatement;
   drillitemupdate: tsqlstatement;
   drilliteminsert: tsqlresult;
   drillitemgrid: tifigridlinkcomp;
   pf_outputdir: tmsestringfield;
   pf_createzip: tmsebooleanfield;
   pf_zipfile: tmsestringfield;
   pf_zipmaindir: tmsestringfield;
   copyplotitems: tsqlstatement;
   procedure afteropenev(DataSet: TDataSet);
   procedure docupagepostev(const sender: TDataSet; const master: TDataSet);
   procedure docupagerefreshev(const sender: TObject);
   procedure docupagedelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
   procedure plotitempostev(const sender: TDataSet; const master: TDataSet);
   procedure plotitemrefreshev(const sender: TObject);
   procedure plotitemdelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
   procedure newdodocusetev(DataSet: TDataSet);
   procedure newpageitemev(DataSet: TDataSet);
   procedure proditemrefreshev(const sender: TObject);
   procedure proditempostev(const sender: TDataSet; const master: TDataSet);
   procedure drillitemdelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
   procedure namecopyrecev(DataSet: TDataSet);
   procedure docusetcopyev(DataSet: TDataSet);
   procedure docusetbefcopyev(DataSet: TDataSet);
   procedure docusetaftercancelev(DataSet: TDataSet);
   procedure docusetafterpostev(const sender: TDataSet; var ok: Boolean);
  protected
   fdeleteddocupages: int64arty;
   fdeletedplotitems: int64arty;
   fdeleteddrillitems: int64arty;
   fcopyplotpks: array of int64arty;
   fcopypagepks: int64arty;
   procedure refreshitems(const alink: tmselargeintfield; 
             var deleted: int64arty;
             const pk: tifiint64linkcomp; const query: tmsesqlquery;
                                    const dataso: tconnectedifidatasource);
   function getdocupagevalues(const index: int32): variantarty;
   function getplotitemvalues(const index: int32): variantarty;
   function getproditemvalues(const index: int32): variantarty;
   function getproddrillitemvalues(const index: int32): variantarty;
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
 pli_format.c.dropdown.cols[0].asarray:= mainmo.fileformats;
 dri_layera.c.dropdown.cols[0].asarray:= mainmo.layernames;
 dri_layerb.c.dropdown.cols[0].asarray:= mainmo.layernames;
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
   case mainmo.getpagekind(dpg_kind.c.griddata[arow]) of
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

procedure tbommo.refreshitems(const alink: tmselargeintfield;
             var deleted: int64arty;
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
   tifisqlresult(dataso.connection).params[0].value:= alink.value;
   dataso.refresh();
  end;
 end;
end;

procedure tbommo.docupagerefreshev(const sender: TObject);
begin
 refreshitems(ds_pk,fdeleteddocupages,dpg_pk,docusetqu,docupagedso);
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
var
 ar1: int64arty;
 i1: int32;
begin
 updateitems(fdeleteddocupages,dpg_pk,docupagedelete,docupageupdate,
                 docupageinsert,@getdocupagevalues);
 if fcopypagepks <> nil then begin
  ar1:= dpg_pk.c.griddata.asarray;
  for i1:= 0 to high(ar1) do begin
   if fcopypagepks[i1] <> 0 then begin //kind = dpk_layerplot
    copyplotitems.execute([fcopypagepks[i1],ar1[i1]]); //oldlink,newlink
   end;
  end;
 end;
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

function tbommo.getproditemvalues(const index: int32): variantarty;
begin
 setlength(result,13);
 result[0]:= pli_pk.c.griddata[index];
 result[1]:= pf_pk.value;
 result[2]:= index;
 result[3]:= pli_layer.c.griddata[index];
 result[4]:= '';//pli_color.c.griddata[index];
 result[5]:= pli_refon.c.griddata[index];
 result[6]:= '';//pli_refcolor.c.griddata[index];
 result[7]:= pli_valon.c.griddata[index];
 result[8]:= '';//pli_valcolor.c.griddata[index];
 result[9]:= pli_invison.c.griddata[index];
 result[10]:= pli_drillmarks.c.griddata[index];
 result[11]:= pli_format.c.griddata[index];
 result[12]:= pli_filename.c.griddata[index];
end;

function tbommo.getproddrillitemvalues(const index: int32): variantarty;
begin
 setlength(result,7);
 result[0]:= dri_pk.c.griddata[index];
 result[1]:= pf_pk.value;
 result[2]:= index;
 result[3]:= dri_layera.c.griddata[index];
 result[4]:= dri_layerb.c.griddata[index];
 result[5]:= dri_npt.c.griddata[index];
 result[6]:= dri_filename.c.griddata[index];
end;

procedure tbommo.plotitempostev(const sender: TDataSet; const master: TDataSet);
begin
 updateitems(fdeletedplotitems,pli_pk,plotitemdelete,plotitemupdate,
                 plotiteminsert,@getplotitemvalues);
end;

procedure tbommo.plotitemrefreshev(const sender: TObject);
begin
 refreshitems(pi_pk,fdeletedplotitems,pli_pk,pageitemqu,plotitemdso);
end;

procedure tbommo.plotitemdelev(const sender: TObject; var aindex: Integer;
               var acount: Integer);
begin
 additem(fdeletedplotitems,pli_pk.c.griddata[aindex]);
end;

procedure tbommo.proditempostev(const sender: TDataSet; const master: TDataSet);
begin
 updateitems(fdeletedplotitems,pli_pk,plotitemdelete,plotitemupdate,
                 plotiteminsert,@getproditemvalues);
 updateitems(fdeleteddrillitems,dri_pk,drillitemdelete,drillitemupdate,
                 drilliteminsert,@getproddrillitemvalues);
end;

procedure tbommo.proditemrefreshev(const sender: TObject);
begin
 refreshitems(pf_pk,fdeletedplotitems,pli_pk,prodfilestackqu,plotitemdso);
 refreshitems(pf_pk,fdeleteddrillitems,dri_pk,prodfilestackqu,drillitemdso);
end;

procedure tbommo.drillitemdelev(const sender: TObject; var aindex: Integer;
               var acount: Integer);
begin
 additem(fdeleteddrillitems,dri_pk.c.griddata[aindex]);
end;

procedure tbommo.newdodocusetev(DataSet: TDataSet);
begin
 ds_height.asfloat:= 297; //a4
 ds_width.asfloat:= 210;
 ds_margleft.asfloat:= 10;
 ds_margright.asfloat:= 10;
 ds_margtop.asfloat:= 10;
 ds_margbottom.asfloat:= 10;
end;

procedure tbommo.newpageitemev(DataSet: TDataSet);
begin
 pi_scale.asfloat:= 1;
 pi_shifthorz.asfloat:= 0;
 pi_shiftvert.asfloat:= 0;
 pi_layera.asmsestring:= 'F.Cu';
 pi_layerb.asmsestring:= 'B.Cu';
end;

procedure tbommo.namecopyrecev(DataSet: TDataSet);
begin
 with dataset.fieldbyname('NAME') do begin
  asmsestring:= asmsestring + '-copy';
 end;
end;

procedure tbommo.docusetcopyev(DataSet: TDataSet);
begin
 namecopyrecev(dataset);
end;

procedure tbommo.docusetbefcopyev(DataSet: TDataSet);
var
 i1: int32;
 p1: pmsestring;
begin
 fcopypagepks:= dpg_pk.c.griddata.asarray;
 p1:= dpg_kind.c.griddata.datapo;
 for i1:= 0 to high(fcopypagepks) do begin
  if p1[i1] <> docupagekinds[dpk_layerplot] then begin
   fcopypagepks[i1]:= 0;
  end;
 end;
end;

procedure tbommo.docusetaftercancelev(DataSet: TDataSet);
begin
 fcopypagepks:= nil;
end;

procedure tbommo.docusetafterpostev(const sender: TDataSet; var ok: Boolean);
begin
 fcopypagepks:= nil;
end;

end.
