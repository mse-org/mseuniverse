{ Implementation of repazsimplereporth.inc }


{ TMasterTabs }

constructor TMasterTabs.create(const aowner: TraReportTemplate);
begin
 inherited;
 fkeyfieldlink:= tfielddatalink.create;
end;

destructor TMasterTabs.destroy;
begin
 inherited;
 fkeyfieldlink.free;
end;

procedure TMasterTabs.assign(source: TPersistent);
begin
 if source is TMasterTabs then begin
  inherited;
  setkeyfield(TMasterTabs(source).KeyField);
 end;
end;

procedure TMasterTabs.setdatasource(const avalue: string);
begin
 inherited;
 fkeyfieldlink.datasource:= fdatalink.datasource;
end;

function TMasterTabs.getkeyfield: string;
begin
 result:= fkeyfieldlink.fieldname;
end;

procedure TMasterTabs.setkeyfield(const avalue: string);
begin
 fkeyfieldlink.fieldname:= avalue;
end;

function TMasterTabs.getdataset(const aindex: integer): tdataset;
begin
 result:= fdatalink.datasource.dataset;
end;

procedure TMasterTabs.getfieldtypes(out apropertynames: stringarty;
               out afieldtypes: fieldtypesarty);
begin
 setlength(apropertynames,1);
 apropertynames[0]:= 'KeyField';
 setlength(afieldtypes,1);
 afieldtypes[0]:= [ftinteger,ftlargeint,ftsmallint,
                     ftword,ftboolean] + textfields;
end;

{ TDetailTabs }

function TDetailTabs.getdestdataset: tsqlquery;
begin
 result:= tsqlquery(fdatalink.dataset);
end;

procedure TDetailTabs.assign(source: TPersistent);
begin
 if source is TDetailTabs then begin
  inherited;
  fparamname:= TDetailTabs(source).param;
 end;
end;

{ TraMasterDetailContent }

constructor TraMasterDetailContent.create(const aowner: TraReportTemplate);
begin
 inherited create;
 frecordnumber:= -1;
 fmasternumber:= -1;
 fowner:= aowner;
 fmaster:= TMasterTabs.create(fowner);
 fheader:= TNormalTabs.create(fowner);
 ffooter:= TSummaryTabs.create(fowner);
 fdata:= TDetailTabs.create(fowner);
 fmaster.recordarea:= ra_AllRecord;
 fheader.recordarea:= ra_CurrentRecord;
 ffooter.recordarea:= ra_CurrentRecord;
 fdata.recordarea:= ra_AllRecord;
end;

destructor TraMasterDetailContent.destroy;
begin
 inherited;
 freeandnil(fmaster);
 freeandnil(fheader);
 freeandnil(ffooter);
 freeandnil(fdata);
end;

procedure TraMasterDetailContent.paint(const canvas: tcanvas;const area:rectty);
var
 y: integer;
begin
 y:= area.y;
 frecordnumber:= 1;
 fmasternumber:= 1;
 if fmaster.count>0 then begin
  fmaster.paint(canvas,makerect(0,y,area.cx,fmaster.pixelheight),false,false);
  y:= y+fmaster.pixelheight;
 end;
 if fheader.count>0 then begin
  fheader.paint(canvas,makerect(0,y,area.cx,fheader.pixelheight),false,false);
  y:= y+fheader.pixelheight;
 end;
 if fdata.count>0 then begin
  if (fdata.param<>'') and (fmaster.KeyField<>'') and 
   (tmsesqlquery(fdata.datalink.dataset).params.parambyname(fdata.param).value<> 
     tmsesqlquery(fmaster.datalink.dataset).fieldbyname(fmaster.keyfield).value) then begin
   tmsesqlquery(fdata.datalink.dataset).params.parambyname(fdata.param).value:= 
     tmsesqlquery(fmaster.datalink.dataset).fieldbyname(fmaster.keyfield).value;
   tmsesqlquery(fdata.datalink.dataset).refresh;
   fdata.init;
  end;
  fdata.paint(canvas,makerect(0,y,area.cx,fdata.pixelheight),false,false);
  y:= y+fdata.pixelheight;
  fdata.paintextend(canvas,makerect(0,y,
    area.cx,area.cy),false,true,true,false,false);
 end;
 if ffooter.count>0 then begin
  ffooter.paint(canvas,makerect(0,y,area.cx,ffooter.pixelheight),false,false);
 end;
end;

function TraMasterDetailContent.build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
var
 posy,limity,hband,extheight: integer;
 bo1: boolean;

 function islastrecord:boolean;
 begin
  result:= ((fmaster.datalink.datasource.dataset.recordcount-fmaster.datalink.datasource.dataset.recno)=0) and
    ((fdata.datalink.datasource.dataset.recordcount-fdata.datalink.datasource.dataset.recno)=0);
 end;
 
 procedure countingsummarymaster;
 var
  int1: integer;
 begin
  if (ffooter.count>0) and (ffooter.datalink.datasource<>nil) then begin
   ffooter.dobeforenextrecord(fmaster.datalink.datasource);
  end;
  //process counting for report footer
  if (fowner.report_footer_rowvalues.count>0) then begin
   for int1:=0 to fowner.report_footer_rowvalues.count-1 do begin
    if fowner.report_footer_rowvalues.items[int1].tabulators.datalink.datasource<>nil then begin
     fowner.report_footer_rowvalues.items[int1].tabulators.dobeforenextrecord(fmaster.datalink.datasource);
    end;
   end;
  end;
 end;

 procedure countingsummarydetail;
 var
  int1: integer;
 begin
  if (ffooter.count>0) and (ffooter.datalink.datasource<>nil) then begin
   ffooter.dobeforenextrecord(fdata.datalink.datasource);
  end;
  //process counting for report footer
  if (fowner.report_footer_rowvalues.count>0) then begin
   for int1:=0 to fowner.report_footer_rowvalues.count-1 do begin
    if fowner.report_footer_rowvalues.items[int1].tabulators.datalink.datasource<>nil then begin
     fowner.report_footer_rowvalues.items[int1].tabulators.dobeforenextrecord(fdata.datalink.datasource);
    end;
   end;
  end;
 end;
 
begin
 posy:= 0;
 limity:= area.cy;
 if (fowner.Report_Footer_RowValues.count>0) then begin
  extheight:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
 end else begin
  extheight:= 0;
 end;
 if fmaster.count>0 then begin
  bo1:= false;
  while not bo1 do begin
   if not fmaster.iseof then begin
    hband:=fmaster.pixelheight;
    if fowner.Report_Footer_Show=frs_EveryPage then begin
     limity:= area.cy - extheight;
    end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
     if islastrecord then begin
      if hband+posy<=area.cy-extheight then begin
       limity:= area.cy - extheight;
       //bo1:= true;
       islastpage:= true;
      end else begin
       limity:= area.cy;
       //bo1:= true;
      end;
     end else begin
      islastpage:= false;
      limity:= area.cy;
     end;
    end;
    if (ffooter.count>0) and fmodfooter then begin
 	   ffooter.paint(canvas,makerect(area.x,posy+area.y,area.cx,ffooter.pixelheight),true,false);
     inc(posy,ffooter.pixelheight);
     fmodfooter:= false;
    end;
    if (fmaster.count>0) and newgroup then begin
     if ((posy+fmaster.pixelheight)<=limity) then begin
  	   fmaster.paint(canvas,makerect(area.x,posy+area.y,area.cx,fmaster.pixelheight),true,false);
      inc(posy,fmaster.pixelheight);
      tmsesqlquery(fdata.datalink.dataset).params.parambyname(fdata.param).value:= 
        tmsesqlquery(fmaster.datalink.dataset).fieldbyname(fmaster.keyfield).value;
      tmsesqlquery(fdata.datalink.dataset).refresh;
      fdata.init;
      inc(fmasternumber);
     end else begin
      bo1:= true;
      newgroup:= true;
     end;
    end;
    if (fheader.count>0) and (fdata.datalink.dataset.recordcount>0) and newheader and not bo1 then begin
     if ((posy+fheader.pixelheight)<=limity) then begin
 	    fheader.paint(canvas,makerect(area.x,posy+area.y,area.cx,fheader.pixelheight),true,false);
      inc(posy,fheader.pixelheight);
     end else begin
      newheader:= true;
      bo1:= true;
     end;
    end;
    if (fdata.datalink.dataset.recordcount>0) and not bo1 then begin
     if ((posy+fdata.pixelheight)<=limity) then begin
      fdata.paint(canvas,makerect(area.x,area.y+posy,area.cx,fdata.pixelheight),true,false);
      inc(posy,fdata.pixelheight);
      inc(frecordnumber);
      countingsummarydetail;
      fdata.nextrecord;
      newheader:= false;
      newgroup:= false;
     end else begin
      newheader:= true;
      bo1:= true;
     end;
    end else begin
     newheader:= true;
    end;
    if fdata.iseof then begin
     if (ffooter.count>0) and (fdata.datalink.dataset.recordcount>0) then begin
      if ((posy+ffooter.pixelheight)<=limity) then begin
       ffooter.paint(canvas,makerect(area.x,posy+area.y,area.cx,ffooter.pixelheight),true,false);
       inc(posy,ffooter.pixelheight);
      end else begin
       fmodfooter:= true;
      end;
     end;
     countingsummarymaster;
     fmaster.nextrecord;
     frecordnumber:= 1;
     newheader:= true;
     newgroup:= true;
    end;
   end else begin
    islastpage:= true;
   end;   
   if fmaster.iseof then begin
    bo1:= true;
    //countingsummarymaster;
   end;
  end;
 end else begin
  islastpage:= true;
 end;
 result:= posy+area.y;
end;

procedure TraMasterDetailContent.adddatasets(var adatasets: datasetarty);
begin
 if (fmaster.count>0) and (fmaster.datalink.dataset <> nil) then begin
   adduniqueitem(pointerarty(adatasets),fmaster.datalink.dataset);
 end;
 if (fheader.count>0) and (fheader.datalink.dataset <> nil) then begin
   adduniqueitem(pointerarty(adatasets),fheader.datalink.dataset);
 end;
 if (ffooter.count>0) and (ffooter.datalink.dataset <> nil) then begin
   adduniqueitem(pointerarty(adatasets),ffooter.datalink.dataset);
 end;
 if (fdata.count>0) and (fdata.datalink.dataset <> nil) then begin
   adduniqueitem(pointerarty(adatasets),fdata.datalink.dataset);
 end;
end;

procedure TraMasterDetailContent.init;
begin
 newheader:= true;
 newgroup:= true;
 fmodfooter:= false;
 frecordnumber:= 1;
 fmasternumber:= 1;
 if fmaster.count>0 then begin
  fmaster.init;
 end;
 if fheader.count>0 then begin
  fheader.init;
 end;
 if fdata.count>0 then begin
  fdata.init;
 end;
 if ffooter.count>0 then begin
  ffooter.init;
 end;
end;

procedure TraMasterDetailContent.updatelinks;
begin
 if fmaster.count>0 then begin
  fmaster.updatelinks;
 end;
 if fheader.count>0 then begin
  fheader.updatelinks;
 end;
 if fdata.count>0 then begin
  fdata.updatelinks;
 end;
 if ffooter.count>0 then begin
  ffooter.updatelinks;
 end;
end;

{ TraMasterDetailReport }

constructor TraMasterDetailReport.create(aowner: tcomponent);
begin
 inherited;
 fcontent:= TraMasterDetailContent.create(self);
end;

destructor TraMasterDetailReport.destroy;
begin
 inherited;
 freeandnil(fcontent);
end;

procedure TraMasterDetailReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
begin
 if fcontent<>nil then begin
  fcontent.paint(canvas,contentarea);
 end;
end;

function TraMasterDetailReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
begin
 result:= fcontent.build(acanvas,contentarea,islastpage);
end;

procedure TraMasterDetailReport.addcontentdatasets(var adatasets: datasetarty);
begin
 fcontent.adddatasets(adatasets);
end;

procedure TraMasterDetailReport.contentinit;
begin
 fcontent.init;
end;

procedure TraMasterDetailReport.contentupdatelinks;
begin
 fcontent.updatelinks;
end;

procedure TraMasterDetailReport.setcontentpixelperunit(const avalue: real);
begin
 fcontent.Detail_Header.setpixelperunit(avalue);
 fcontent.Detail_Data.setpixelperunit(avalue);
 fcontent.Detail_Footer.setpixelperunit(avalue);
end;

function TraMasterDetailReport.contentheadervalue(indexcol:integer): variant;
begin
 if (indexcol>=0) and (indexcol<=fcontent.Detail_Header.count-1) then begin
  result:= fcontent.Detail_Header.items[indexcol].value;
 end;
end;

function TraMasterDetailReport.contentfootervalue(indexcol:integer): variant;
begin
 if (indexcol>=0) and (indexcol<=fcontent.Detail_Footer.count-1) then begin
  result:= fcontent.Detail_Footer.items[indexcol].value;
 end;
end;

function TraMasterDetailReport.contentdatavalue(indexcol:integer): variant;
begin
 if (indexcol>=0) and (indexcol<=fcontent.Detail_Data.count-1) then begin
  result:= fcontent.Detail_Data.items[indexcol].value;
 end;
end;

function TraMasterDetailReport.recordnumber: integer;
begin
 result:= fcontent.recordnumber;
end;

function TraMasterDetailReport.masternumber: integer;
begin
 result:= fcontent.masternumber;
end;

function TraMasterDetailReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;

