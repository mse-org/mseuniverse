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
   procedure afteropenev(DataSet: TDataSet);
   procedure docupagepostev(const sender: TDataSet; const master: TDataSet);
   procedure docupagerefreshev(const sender: TObject);
   procedure docupagedelev(const sender: TObject; var aindex: Integer;
                   var acount: Integer);
  protected
   fdeleteddocupages: int64arty;
   procedure updatedocupages();
  public
   constructor create(aowner: tcomponent); override;
 end;
var
 bommo: tbommo;
implementation
uses
 bommodule_mfm,mainmodule,msearrayutils;

constructor tbommo.create(aowner: tcomponent);
begin
 inherited;
 dpg_kind.c.dropdown.cols[0].asarray:= mainmo.docupagekinds;
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

procedure tbommo.docupagerefreshev(const sender: TObject);
begin
 if not docusetqu.controller.posting1 or 
                       docusetqu.controller.deleting then begin
  fdeleteddocupages:= nil;
  docupagedso.refresh();
 end;
end;

procedure tbommo.docupagepostev(const sender: TDataSet; const master: TDataSet);
begin
 updatedocupages();
end;

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

procedure tbommo.docupagedelev(const sender: TObject; var aindex: Integer;
               var acount: Integer);
begin
 additem(fdeleteddocupages,dpg_pk.c.griddata[aindex]);
end;

end.
