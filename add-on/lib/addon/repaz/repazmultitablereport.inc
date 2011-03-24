{ Implementation of repazmultitablereporth.inc }

{ TraTable }

constructor TraTable.create(const aowner: TraReportTemplate);
begin
 inherited create;
 ftableheight:= 0;
 fdatanumber:= 0;
 fowner:= aowner;
 fprintifempty:= true;
 fheader:= TNormalTabsCol.create(fowner);
 ffooter:= TSummaryTabsCol.create(fowner);
 fdata:= TNormalTabsCol.create(fowner);
 fheaderheight:= defaulttabsheight/fowner.pixelperunit;
 ffooterheight:= defaulttabsheight/fowner.pixelperunit;
 fheadershow:= hmbs_EveryTopOfPage;
 ffootershow:= fmbs_EveryBottomOfPage;
 ffooteroptions:= defaultfmultitableoptions;
end;

destructor TraTable.destroy;
begin
 inherited;
 freeandnil(fheader);
 freeandnil(ffooter);
 freeandnil(fdata);
end;

procedure TraTable.assign(source: tpersistent);
begin
 if source is TraTable then begin
  fprintifempty:= TraTable(source).PrintIfEmpty;
  fheader.assign(TraTable(source).Header_RowValues);
  fheaderheight:= TraTable(source).Header_Height;
  fheadershow:= TraTable(source).Header_Show;
  ffooter.assign(TraTable(source).Footer_RowValues);
  ffooterheight:= TraTable(source).Footer_Height;
  ffootershow:= TraTable(source).Footer_Show;
  ffooteroptions:= TraTable(source).Footer_Options;
  fdata.assign(TraTable(source).Data_RowValues); 
 end;
end;

procedure TraTable.paint(const canvas: tcanvas;const area:rectty);
var
 posy,limity,int1,int2,int3,int4,posy2,fdelta,extheight1,extheight2,hband,tmppos: integer;
begin
 posy:= 0;
 limity:= area.cy;
 if (fowner.Report_Footer_RowValues.count>0) then begin
  if ftableheight>0 then begin
   extheight1:= 0;
  end else begin
   extheight1:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
  end;
 end else begin
  extheight1:= 0;
 end;
 tmppos:= posy;
 if (fheader.count>0) and 
  ((fheadershow=hmbs_EveryTopOfPage) or 
  ((fheadershow=hmbs_FirstRowOnly) and (fowner.reportpage.pagenum=1))) then begin
  hband:= 0;
  for int1:=0 to fheader.count-1 do begin
   with fheader.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(fheaderheight*fowner.fpixelperunit)) then begin
     tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,tabulators.pixelheight),false,false);
     posy:= posy+tabulators.pixelheight;
    end else begin
     break;
    end;
   end;
  end;
  if posy<(tmppos+round(fheaderheight*fowner.pixelperunit)) then begin
   posy:=tmppos+round(fheaderheight*fowner.pixelperunit);
  end;
 end;
 if (ffooter.count>0) then begin
  extheight2:= round(ffooterheight*fowner.pixelperunit);
 end else begin
  extheight2:= 0;
 end;
 if fdata.count>0 then begin
  if not fdata.items[0].tabulators.iseof then begin
   hband:=fdata.bandheight;
   if fowner.Report_Footer_Show=frs_EveryPage then begin
    if (ffootershow=fmbs_EveryBottomOfPage) then begin
     limity:= area.cy-extheight1-extheight2;
    end else begin
     limity:= area.cy-extheight1-extheight2;
    end;
   end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
    if (ffootershow=fmbs_EveryBottomOfPage) then begin
     limity:= area.cy-extheight1-extheight2;
    end else begin
     limity:= area.cy-extheight1-extheight2;
    end;
   end;
   if hband+posy<=limity then begin
    inc(fdatanumber);
    for int2:=0 to fdata.count-1 do begin
     fdata.items[int2].tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,fdata.items[int2].tabulators.pixelheight),false,false);
     inc(posy,fdata.items[int2].tabulators.pixelheight);
    end;
   end else begin
    if fowner.Report_Footer_Show=frs_EveryPage then begin
     if (ffootershow=fmbs_EveryBottomOfPage) then begin       
      limity:= limity+extheight1;
     end else begin
      limity:= limity+extheight1;
     end;
    end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
     if (ffootershow=fmbs_EveryBottomOfPage) then begin
      limity:= limity+extheight1;
     end else begin
      limity:= limity+extheight1;
     end;
    end;
   end;
  end;
 end;
 if (ffooter.count>0) and 
  ((ffootershow=fmbs_EveryBottomOfPage) or 
  ((ffootershow=fmbs_LastRowOnly))) then begin
  if ffooter.bandheight<=round(ffooterheight*fowner.pixelperunit) then begin
   hband:= ffooter.bandheight;
   if ftableheight>0 then begin
    //draw extend line
    fdelta:= limity-posy-hband;
    if (fdelta>0) and (fdata.count>0) then begin
     fdata.items[fdata.count-1].tabulators.paintextend(canvas,makerect(area.x,area.y+posy,area.cx,fdelta),false,true,true,false,false);
     posy:= posy+fdelta;
    end;
   end;
   for int1:=0 to ffooter.count-1 do begin
    with ffooter.items[int1] do begin
     if (hband<=round(ffooterheight*fowner.fpixelperunit)) then begin
      tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,tabulators.pixelheight),false,false);
      posy:= posy+tabulators.pixelheight;
     end else begin
      break;
     end;
    end;
   end;
  end;
 end;
 if ftableheight>0 then begin
  flastposy:= flastposy+round((ftableheight*fowner.pixelperunit));
 end else begin
  flastposy:= flastposy+posy;
 end;
end;

function TraTable.build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
 function islastrecord:boolean;
 begin
  if fdata.count>0 then begin
   if fdata.items[0].tabulators.datalink.datasource=nil then begin
    result:= true;
   end else begin
    result:= (fdata.items[0].tabulators.datalink.datasource.dataset.recordcount-fdata.items[0].tabulators.datalink.datasource.dataset.recno)=0;
   end;
  end else begin
   result:= true;
  end;
 end;
 
 procedure countingsummary(grandtotal: boolean);
 var
  int1: integer;
 begin
  if (ffooter.count>0) then begin
   for int1:= 0 to ffooter.count-1 do begin
    if (ffooter.items[int1].tabulators.datalink.datasource<>nil) then begin
     ffooter.items[int1].tabulators.dobeforenextrecord(fdata.items[0].tabulators.datalink.datasource);
    end;
   end;
  end;
  //process counting for report footer
  if grandtotal then begin
   if (fowner.report_footer_rowvalues.count>0) then begin
    for int1:=0 to fowner.report_footer_rowvalues.count-1 do begin
     if fowner.report_footer_rowvalues.items[int1].tabulators.datalink.datasource<>nil then begin
      fowner.report_footer_rowvalues.items[int1].tabulators.dobeforenextrecord(fdata.items[0].tabulators.datalink.datasource);
     end;
    end;
   end;
  end;
 end;
var
 posy,limity,int1,int2,int3,int4,posy2,fdelta,extheight1,extheight2,hband,tmppos: integer;
 bo1,eofbefore,areset: boolean;
begin
 if not fprintifempty then begin
  if fdata.items[0].tabulators.recordcount<=0 then begin
   islastpage:= true;
   result:= flastposy;
   exit;
  end;
 end;
 posy:= 0;
 limity:= area.cy;
 eofbefore:= false;
 if (fowner.Report_Footer_RowValues.count>0) then begin
  if ftableheight>0 then begin
   extheight1:= 0;
  end else begin
   extheight1:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
  end;
 end else begin
  extheight1:= 0;
 end;
 tmppos:= posy;
 if (fheader.count>0) and 
  ((fheadershow=hmbs_EveryTopOfPage) or 
  ((fheadershow=hmbs_FirstRowOnly) and (fowner.reportpage.pagenum=1))) then begin
  hband:= 0;
  for int1:=0 to fheader.count-1 do begin
   with fheader.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(fheaderheight*fowner.fpixelperunit)) then begin
     tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,tabulators.pixelheight),true,false);
     posy:= posy+tabulators.pixelheight;
    end else begin
     break;
    end;
   end;
  end;
  if posy<(tmppos+round(fheaderheight*fowner.pixelperunit)) then begin
   posy:=tmppos+round(fheaderheight*fowner.pixelperunit);
  end;
 end;
 if (ffooter.count>0) then begin
  extheight2:= round(ffooterheight*fowner.pixelperunit);
 end else begin
  extheight2:= 0;
 end;
 if fdata.count>0 then begin
  bo1:= false;
  while not bo1 do begin
   if not fdata.items[0].tabulators.iseof then begin
    hband:=fdata.bandheight;
    if fowner.Report_Footer_Show=frs_EveryPage then begin
     if (ffootershow=fmbs_EveryBottomOfPage) then begin
      limity:= area.cy-extheight1-extheight2;
     end else begin
      if islastrecord then begin
       limity:= area.cy-extheight1-extheight2;
      end else begin
       limity:= area.cy-extheight2;
      end;
     end;
    end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
     if (ffootershow=fmbs_EveryBottomOfPage) then begin
      if islastrecord then begin
       limity:= area.cy-extheight1-extheight2;
      end else begin
       limity:= area.cy-extheight2;
      end;
     end else begin
      if islastrecord then begin
       limity:= area.cy-extheight1-extheight2;
      end else begin
       limity:= area.cy;
      end;
     end;
    end;
    if hband+posy<=limity then begin
     inc(fdatanumber);
     for int2:=0 to fdata.count-1 do begin
      fdata.items[int2].tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,fdata.items[int2].tabulators.pixelheight),true,false);
      inc(posy,fdata.items[int2].tabulators.pixelheight);
     end;
     countingsummary(true);
     fdata.items[0].tabulators.nextrecord;
    end else begin
     if fowner.Report_Footer_Show=frs_EveryPage then begin
      if (ffootershow=fmbs_EveryBottomOfPage) then begin       
       limity:= limity+extheight1;
      end else begin
       if islastrecord then begin
        limity:= limity+extheight1;
       end;
      end;
     end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
      if (ffootershow=fmbs_EveryBottomOfPage) then begin
       if islastrecord then begin
        limity:= limity+extheight1;
       end;
      end else begin
       if islastrecord then begin
        limity:= limity+extheight1;
       end;
      end;
     end;
     bo1:= true;
    end;
   end else begin
    eofbefore:= true;
   end;
   if fdata.items[0].tabulators.iseof then begin
    bo1:= true;
    islastpage:= true;
   end;
  end;
 end else begin
  islastpage:= true;
 end;
 if (ffooter.count>0) and 
  ((ffootershow=fmbs_EveryBottomOfPage) or 
  ((ffootershow=fmbs_LastRowOnly) and islastpage)) then begin
  if not eofbefore or islastpage then begin
   if ffooter.bandheight<=round(ffooterheight*fowner.pixelperunit) then begin
    hband:= ffooter.bandheight;
    if ftableheight>0 then begin
     //draw extend line
     fdelta:= area.cy-posy-hband;
     if (fdelta>0) and (fdata.count>0) then begin
      fdata.items[fdata.count-1].tabulators.paintextend(canvas,makerect(area.x,area.y+posy,area.cx,fdelta),true,true,true,false,false);
      posy:= posy+fdelta;
     end;
    end;
    if fmbo_ResetEveryPage in ffooteroptions then begin
     areset:= true;
    end else begin
     areset:= false;
    end;
    for int1:=0 to ffooter.count-1 do begin
     with ffooter.items[int1] do begin
      if (hband<=round(ffooterheight*fowner.fpixelperunit)) then begin
       tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,tabulators.pixelheight),true,false);
       posy:= posy+tabulators.pixelheight;
      end else begin
       break;
      end;
     end;
    end;
    if not (fdata.items[0].tabulators.iseof) then begin
     for int2:=0 to fdata.count-1 do begin
      fdata.items[int2].tabulators.initpage;
     end;
    end;
   end;
  end;
 end;
 result:= posy+area.y;
 if ftableheight>0 then begin
  flastposy:= flastposy+round((ftableheight*fowner.pixelperunit));
 end else begin
  flastposy:= flastposy+posy;
 end;
 if islastpage then fdatanumber:= 0;
end;

procedure TraTable.adddatasets(var adatasets: datasetarty);
var
 int1: integer;
begin
 if (fheader.count>0) then begin
  for int1:=0 to fheader.count-1 do begin
   if fheader.items[int1].tabulators.fdatalink.dataset <> nil then begin
    adduniqueitem(pointerarty(adatasets),fheader.items[int1].tabulators.fdatalink.dataset);
   end;
  end;
 end; 
 if (ffooter.count>0) then begin
  for int1:=0 to ffooter.count-1 do begin
   if ffooter.items[int1].tabulators.fdatalink.dataset <> nil then begin
    adduniqueitem(pointerarty(adatasets),ffooter.items[int1].tabulators.fdatalink.dataset);
   end;
  end;
 end;
 if (fdata.count>0) then begin
  for int1:=0 to fdata.count-1 do begin
   if (fdata.items[int1].tabulators.datalink.dataset <> nil) then begin
    adduniqueitem(pointerarty(adatasets),fdata.items[int1].tabulators.datalink.dataset);
   end;
  end;
 end;
end;

procedure TraTable.init;
var
 int1: integer;
begin
 if fheader.count>0 then begin
  for int1:=0 to fheader.count-1 do begin
   fheader.items[int1].tabulators.init;
  end;
 end;
 if fdata.count>0 then begin
  for int1:=0 to fdata.count-1 do begin
   fdata.items[int1].tabulators.recordarea:= ra_AllRecord;
   fdata.items[int1].tabulators.init;
  end;
 end;
 if ffooter.count>0 then begin
  for int1:=0 to ffooter.count-1 do begin
   ffooter.items[int1].tabulators.init;
  end;
 end;
end;

procedure TraTable.updatelinks;
var
 int1: integer;
begin
 if fheader.count>0 then begin
  for int1:=0 to fheader.count-1 do begin
   fheader.items[int1].tabulators.updatelinks;
  end;
 end;
 if fdata.count>0 then begin
  for int1:=0 to fdata.count-1 do begin
   fdata.items[int1].tabulators.updatelinks;
  end;
 end;
 if ffooter.count>0 then begin
  for int1:=0 to ffooter.count-1 do begin
   ffooter.items[int1].tabulators.updatelinks;
  end;
 end;
end;

{ TMultiTableItem }

constructor TMultiTableItem.create(const aowner: TraReportTemplate);
begin
 inherited create;
 ftable:= TraTable.create(aowner);
end;

destructor TMultiTableItem.destroy;
begin
 freeandnil(ftable);
end;

procedure TMultiTableItem.assign(source: tpersistent);
begin
 if (source is TMultiTableItem) then begin
  ftable.assign(TMultiTableItem(source).table);
 end;
end;


{ TMultiTableCol }

constructor TMultiTableCol.create(const aowner: TraReportTemplate);
begin
 fowner:= aowner;
 inherited create(TMultiTableItem);
end;

destructor TMultiTableCol.destroy;
var
 int1: integer;
begin
 for int1:=0 to count-1 do begin
  TMultiTableItem(items[int1]).ftable.free;
 end;
 inherited;
end;

procedure TMultiTableCol.setpixelperunit(const avalue: real);
var
 int1,int2: integer;
begin
 if count>0 then begin
  for int1:=0 to count-1 do begin
   items[int1].table.Data_RowValues.setpixelperunit(avalue);
   for int2:=0 to items[int1].table.header_rowvalues.count-1 do begin
    items[int1].table.header_rowvalues.items[int2].tabulators.setpixelperunit(avalue);
   end;
   for int2:=0 to items[int1].table.footer_rowvalues.count-1 do begin
    items[int1].table.footer_rowvalues.items[int2].tabulators.setpixelperunit(avalue);
   end;
  end;
 end;
end;

procedure TMultiTableCol.insert(const index: integer; const aitem: TMultiTableItem);
var
 int1: integer;
begin
 int1:= index;
 if index > count then begin
  int1:= count;
 end;
 beginupdate;
 try
  insertempty(int1);
  fitems[int1]:= aitem;
 finally
  endupdate;
 end;
end;

function TMultiTableCol.getmultitableitems(index: integer): TMultiTableItem;
begin
 result:= TMultiTableItem(getitems(index));
end;

procedure TMultiTableCol.setmultitableitems(index: integer; const Value: TMultiTableItem);
begin
 TMultiTableItem(getitems(index)).assign(value);
end;

procedure TMultiTableCol.createitem(const index: integer; var item: tpersistent);
begin
 item:= TMultiTableItem.create(fowner);
end;

{ TraMultiTableReport }

constructor TraMultiTableReport.create(aowner: tcomponent);
begin
 inherited;
 fmultitable:= TMultiTableCol.create(self);
 ftableindex:= -1;
end;

destructor TraMultiTableReport.destroy;
begin
 inherited;
 freeandnil(fmultitable);
end;

procedure TraMultiTableReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
var
 int1: integer;
 farea: rectty;
begin
 with fmultitable do begin
  for int1:=0 to count-1 do begin
   ftableindex:= int1;
   if int1=0 then begin
    items[0].table.lastybuild:= 0;
   end else begin
    items[int1].table.lastybuild:= items[int1-1].table.lastybuild;
   end;
   if items[int1].table.tableheight>0 then begin
    items[int1].table.paint(canvas,makerect(contentarea.x,contentarea.y+items[int1].table.lastybuild,contentarea.cx,round(items[int1].table.tableheight*fowner.fpixelperunit)));
   end else begin
    items[int1].table.paint(canvas,makerect(contentarea.x,contentarea.y+items[int1].table.lastybuild,contentarea.cx,(contentarea.cy-items[int1].table.lastybuild)));
   end;
  end;
 end;
end;

function TraMultiTableReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
var
 int1: integer;
begin
 with fmultitable do begin
  for int1:=0 to count-1 do begin
   ftableindex:= int1;
   if int1=0 then begin
    items[0].table.lastybuild:= 0;
   end else begin
    items[int1].table.lastybuild:= items[int1-1].table.lastybuild;
   end;
   if items[int1].table.tableheight>0 then begin
    result:= items[int1].table.build(acanvas,makerect(contentarea.x,contentarea.y+items[int1].table.lastybuild,contentarea.cx,round(items[int1].table.tableheight*fowner.fpixelperunit)),islastpage);
   end else begin
    //result:= items[int1].table.build(acanvas,contentarea,islastpage);
    result:= items[int1].table.build(acanvas,makerect(contentarea.x,contentarea.y+items[int1].table.lastybuild,contentarea.cx,(contentarea.cy-items[int1].table.lastybuild)),islastpage);
   end;
   if not islastpage then break;
  end;
 end;
end;

procedure TraMultiTableReport.addcontentdatasets(var adatasets: datasetarty);
var
 int1: integer;
begin
 with fmultitable do begin
  for int1:=0 to count-1 do begin
   items[int1].table.adddatasets(adatasets);
  end;
 end;
end;

procedure TraMultiTableReport.contentinit;
var
 int1: integer;
begin
 with fmultitable do begin
  for int1:=0 to count-1 do begin
   items[int1].table.init;
  end;
 end;
end;

procedure TraMultiTableReport.contentupdatelinks;
var
 int1: integer;
begin
 with fmultitable do begin
  for int1:=0 to count-1 do begin
   items[int1].table.updatelinks;
  end;
 end;
end;

procedure TraMultiTableReport.setcontentpixelperunit(const avalue: real);
var
 int1,int2: integer;
begin
 with fmultitable do begin
  for int1:=0 to count-1 do begin
   for int2:=0 to items[int1].table.header_rowvalues.count-1 do begin
    items[int1].table.header_rowvalues.items[int2].tabulators.setpixelperunit(avalue);
   end;
   items[int1].table.header_height:= (items[int1].table.header_height*fpixelperunit)/avalue;
   items[int1].table.footer_height:= (items[int1].table.footer_height*fpixelperunit)/avalue;
   items[int1].table.Data_RowValues.setpixelperunit(avalue);
   for int2:=0 to items[int1].table.footer_rowvalues.count-1 do begin
    items[int1].table.footer_rowvalues.items[int2].tabulators.setpixelperunit(avalue);
   end;
  end;
 end;
end;

function TraMultiTableReport.tableheadervalue(tableindex:integer;indexrow:integer;indexcol:integer): variant;
begin
 if (tableindex>=0) and (tableindex<=fmultitable.count-1) then begin
  if (indexrow>=0) and (indexrow<=fmultitable.items[tableindex].table.header_rowvalues.count-1) then begin
   if (indexcol>=0) and (indexcol<=fmultitable.items[tableindex].table.header_rowvalues[indexrow].tabulators.count-1) then begin
    result:= fmultitable.items[tableindex].table.header_rowvalues[indexrow].tabulators.items[indexcol].value;
   end;
  end;
 end;
end;

function TraMultiTableReport.tablefootervalue(tableindex:integer;indexrow:integer;indexcol:integer): variant;
begin
 if (tableindex>=0) and (tableindex<=fmultitable.count-1) then begin
  if (indexrow>=0) and (indexrow<=fmultitable.items[tableindex].table.footer_rowvalues.count-1) then begin
   if (indexcol>=0) and (indexcol<=fmultitable.items[tableindex].table.footer_rowvalues[indexrow].tabulators.count-1) then begin
    result:= fmultitable.items[tableindex].table.footer_rowvalues[indexrow].tabulators.items[indexcol].value;
   end;
  end;
 end;
end;

function TraMultiTableReport.contentdatavalue(indexcol:integer): variant;
begin
 {if ftableindex>=0 then begin
  if (indexcol>=0) and (indexcol<=fmultitable.items[ftableindex].table.Data_RowValues.count-1) then begin
   result:= fmultitable.items[ftableindex].table.Data_RowValues.items[indexcol].value;
  end;
 end;}
end;

function TraMultiTableReport.recordnumber: integer;
begin
 if ftableindex>=0 then begin
  if fmultitable.items[ftableindex].table.Data_RowValues.items[0].tabulators.datalink.active then begin
   result:= fmultitable.items[ftableindex].table.Data_RowValues.items[0].tabulators.datalink.dataset.recno;
  end else begin
   result:= -1;
  end;
 end;
end;

function TraMultiTableReport.datanumber: integer;
begin
 if ftableindex>=0 then begin
  result:= fmultitable.items[ftableindex].table.datanumber;
 end else begin
  result:= -1;
 end;
end;

function TraMultiTableReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;

procedure TraMultiTableReport.contentgetpickobjects(const sender: tobjectpicker; var objects: integerarty);
var
 int1,int2,int3,int4: integer; 
begin
 if fmultitable.count>0 then begin
  for int1:=0 to fmultitable.count-1 do begin
   for int4:=0 to fmultitable.items[int1].table.header_rowvalues.count-1 do begin
    with fmultitable.items[int1].table.header_rowvalues[int4].tabulators do begin
     if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
      for int2:=0 to count-1 do begin
       int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
       if int3 < tabpickthreshold then begin
        setlength(objects,1);
        objects[0]:= int2;
        fpickkind:= 7;
        fpickarrayindex:= int4;
        fpicktable:= int1;
        break;
       end;
      end;
     end;
    end; 
   end;
   {with fmultitable.items[int1].table.Data_RowValues do begin
    if (arect.y>=yposition) and (arect.y<=yposition+pixelheight) then begin
     for int2:=0 to count-1 do begin
      int3:= abs(arect.x - round(items[int2].Position*fpixelperunit));
      if int3 < tabpickthreshold then begin
       setlength(aobjects,1);
       aobjects[0]:= int2;
       fpickkind:= 8;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;}
   for int4:=0 to fmultitable.items[int1].table.footer_rowvalues.count-1 do begin
    with fmultitable.items[int1].table.footer_rowvalues[int4].tabulators do begin
     if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
      for int2:=0 to count-1 do begin
       int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
       if int3 < tabpickthreshold then begin
        setlength(objects,1);
        objects[0]:= int2;
        fpickkind:= 9;
        fpickarrayindex:= int4;
        fpicktable:= int1;
        break;
       end;
      end;
     end;
    end; 
   end;
  end;
 end;
end;

procedure TraMultiTableReport.contentendpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                       const aoffset: pointty; const aobjects: integerarty);
begin
 case fpickkind of
  7: begin
      with fmultitable.items[fpicktable].table.header_rowvalues.items[fpickarrayindex].tabulators do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  {8: begin
      with fmultitable.items[fpickarrayindex].table.Data_RowValues do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;}
  9: begin
      with fmultitable.items[fpicktable].table.footer_rowvalues.items[fpickarrayindex].tabulators do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
 end;
end;
