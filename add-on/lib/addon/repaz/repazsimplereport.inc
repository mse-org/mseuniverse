{ Implementation of repazsimplereporth.inc }

{ TraSimpleContent }

constructor TraSimpleContent.create(const aowner: TraReportTemplate);
begin
 inherited create;
 fdatanumber:= -1;
 fowner:= aowner;
 fheader:= TNormalTabs.create(fowner);
 ffooter:= TSummaryTabs.create(fowner);
 fdata:= TNormalTabs.create(fowner);
 fheader.recordarea:= ra_CurrentRecord;
 ffooter.recordarea:= ra_CurrentRecord;
 fdata.recordarea:= ra_AllRecord;
 fheaderheight:= defaulttabsheight/fowner.pixelperunit;
 ffooterheight:= defaulttabsheight/fowner.pixelperunit;
 fheadershow:= hcs_EveryPage;
 ffootershow:= fcs_EveryPage;
 ffooteroptions:= defaultfcontentoptions;
end;

destructor TraSimpleContent.destroy;
begin
 inherited;
 freeandnil(fheader);
 freeandnil(ffooter);
 freeandnil(fdata);
end;

procedure TraSimpleContent.paint(const canvas: tcanvas;const area:rectty);
var
 int1: integer;
begin
 int1:= area.y;
 if fheader.count>0 then begin
  if fheader.height<=fheaderheight then begin
   fheader.yposition:= area.y;
   fheader.paint(canvas,makerect(0,area.y,area.cx,fheader.pixelheight),false,false);
   int1:= int1+round(fheaderheight*fowner.pixelperunit);
  end;
 end;
 if fdata.count>0 then begin
  fdata.yposition:= int1;
  fdata.paint(canvas,makerect(0,int1,area.cx,fdata.pixelheight),false,false);
  fdata.paintextend(canvas,makerect(0,area.y+round(fheaderheight*fowner.pixelperunit)+fdata.pixelheight,
    area.cx,area.cy-round((fheaderheight+ffooterheight)*fowner.pixelperunit)-fdata.pixelheight),false,true,true,false,false);
 end;
 if ffooter.count>0 then begin
  if ffooter.height<=ffooterheight then begin
   int1:= area.y+area.cy-round(ffooterheight*fowner.pixelperunit);
   ffooter.yposition:= int1;
   ffooter.paint(canvas,makerect(0,int1,area.cx,ffooter.pixelheight),false,false);
  end;
 end;
end;

function TraSimpleContent.build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
 function islastrecord:boolean;
 begin
  result:= (fdata.datalink.datasource.dataset.recordcount-fdata.datalink.datasource.dataset.recno)=0;
 end;
 
 procedure countingsummary(grandtotal: boolean);
 var
  int1: integer;
 begin
  if (ffooter.count>0) and (ffooter.datalink.datasource<>nil) then begin
   ffooter.dobeforenextrecord(fdata.datalink.datasource);
  end;
  //process counting for report footer
  if grandtotal then begin
   if (fowner.report_footer_rowvalues.count>0) then begin
    for int1:=0 to fowner.report_footer_rowvalues.count-1 do begin
     if fowner.report_footer_rowvalues.items[int1].tabulators.datalink.datasource<>nil then begin
      fowner.report_footer_rowvalues.items[int1].tabulators.dobeforenextrecord(fdata.datalink.datasource);
     end;
    end;
   end;
  end;
 end;
var
 posy,limity,posy2,fdelta,extheight1,extheight2,hband: integer;
 bo1,eofbefore,areset: boolean;
begin
 posy:= 0;
 limity:= area.cy;
 eofbefore:= false;
 if (fowner.Report_Footer_RowValues.count>0) then begin
  extheight1:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
 end else begin
  extheight1:= 0;
 end; 
 if (fheader.count>0) and 
  ((fheadershow=hcs_EveryPage) or 
  ((fheadershow=hcs_FirstPageOnly) and (fowner.reportpage.pagenum=1))) then begin
  if (fdata.count>0) and (not fdata.iseof) then begin
   if fheader.height<=fheaderheight then begin
    fheader.paint(canvas,makerect(area.x,area.y,area.cx,fheader.pixelheight),true,false);
   end;
   posy:= round(fheaderheight*fowner.pixelperunit);
  end;
 end;
 if (ffooter.count>0) then begin
  extheight2:= round(ffooterheight*fowner.pixelperunit);
 end else begin
  extheight2:= 0;
 end;
 fdatanumber:= 0;
 if fdata.count>0 then begin
  bo1:= false;
  while not bo1 do begin
   if not fdata.iseof then begin
    hband:=fdata.pixelheight;
    if fowner.Report_Footer_Show=frs_EveryPage then begin
     if (ffootershow=fcs_EveryPage) then begin
      limity:= area.cy-extheight1-extheight2;
     end else begin
      if islastrecord then begin
       limity:= area.cy-extheight1-extheight2;
      end else begin
       limity:= area.cy-extheight2;
      end;
     end;
    end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
     if (ffootershow=fcs_EveryPage) then begin
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
     fdata.paint(canvas,makerect(area.x,area.y+posy,area.cx,fdata.pixelheight),true,false);
     inc(posy,fdata.pixelheight);
     if not islastrecord then begin
      countingsummary(true);
     end;
     fdata.nextrecord;
    end else begin
     bo1:= true;
    end;
   end else begin
    eofbefore:= true;
   end;
   if fdata.iseof then begin
    bo1:= true;
    islastpage:= true;
    countingsummary(true);
   end;
  end;
 end else begin
  islastpage:= true;
 end;
 if (ffooter.count>0) and 
  ((ffootershow=fcs_EveryPage) or 
  ((ffootershow=fcs_LastPageOnly) and islastpage)) then begin
  if not eofbefore then begin
   if ffooter.height<=ffooterheight then begin
    if fco_PrintOnBottomPage in ffooteroptions then begin
     posy2:= area.y+limity; //-round(ffooterheight*fowner.pixelperunit);
     //draw extend line
     fdelta:= posy2-posy-area.y;
     if (fdelta>0) and (fdata.count>0) then begin
      fdata.paintextend(canvas,makerect(area.x,area.y+posy,area.cx,fdelta),true,true,true,false,false);
     end;
    end else begin
     posy2:= posy + area.y;
    end;
    if fco_ResetEveryPage in ffooteroptions then begin
     areset:= true;
    end else begin
     areset:= false;
    end;
    ffooter.paint(canvas,makerect(area.x,posy2,area.cx,ffooter.pixelheight),true,areset);
    if not (fdata.iseof) then begin
     fdata.initpage;
     countingsummary(false);
    end;
   end;
  end;
 end;
 result:= posy+area.y;
end;

procedure TraSimpleContent.adddatasets(var adatasets: datasetarty);
begin
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

procedure TraSimpleContent.init;
begin
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

procedure TraSimpleContent.updatelinks;
begin
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

{ TraSimpleReport }

constructor TraSimpleReport.create(aowner: tcomponent);
begin
 inherited;
 fcontent:= TraSimpleContent.create(self);
end;

destructor TraSimpleReport.destroy;
begin
 inherited;
 freeandnil(fcontent);
end;

procedure TraSimpleReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
begin
 if fcontent<>nil then begin
  fcontent.paint(canvas,contentarea);
 end;
end;

function TraSimpleReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
begin
 result:= fcontent.build(acanvas,contentarea,islastpage);
end;

procedure TraSimpleReport.addcontentdatasets(var adatasets: datasetarty);
begin
 fcontent.adddatasets(adatasets);
end;

procedure TraSimpleReport.contentinit;
begin
 fcontent.init;
end;

procedure TraSimpleReport.contentupdatelinks;
begin
 fcontent.updatelinks;
end;

procedure TraSimpleReport.setcontentpixelperunit(const avalue: real);
begin
 fcontent.header_tabulators.setpixelperunit(avalue);
 fcontent.header_height:= (fcontent.header_height*fpixelperunit)/avalue;
 fcontent.footer_height:= (fcontent.footer_height*fpixelperunit)/avalue;
 fcontent.data_tabulators.setpixelperunit(avalue);
 fcontent.footer_tabulators.setpixelperunit(avalue);
end;

function TraSimpleReport.contentheadervalue(indexcol:integer): variant;
begin
 if (indexcol>=0) and (indexcol<=fcontent.header_tabulators.count-1) then begin
  result:= fcontent.header_tabulators.items[indexcol].value;
 end;
end;

function TraSimpleReport.contentfootervalue(indexcol:integer): variant;
begin
 if (indexcol>=0) and (indexcol<=fcontent.footer_tabulators.count-1) then begin
  result:= fcontent.footer_tabulators.items[indexcol].value;
 end;
end;

function TraSimpleReport.contentdatavalue(indexcol:integer): variant;
begin
 if (indexcol>=0) and (indexcol<=fcontent.data_tabulators.count-1) then begin
  result:= fcontent.data_tabulators.items[indexcol].value;
 end;
end;

function TraSimpleReport.recordnumber: integer;
begin
 if fcontent.data_tabulators.datalink.active then begin
  result:= fcontent.data_tabulators.datalink.dataset.recno;
 end else begin
  result:= -1;
 end;
end;

function TraSimpleReport.datanumber: integer;
begin
 result:= fcontent.datanumber;
end;

function TraSimpleReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;

procedure TraSimpleReport.contentgetpickobjects(const sender: tobjectpicker; var objects: integerarty);
var
 int1,int2: integer; 
begin
 with fcontent.fheader do begin
  if (sender.pickpos.y>=fcontent.fheader.yposition) and (sender.pickpos.y<=fcontent.fheader.yposition+fcontent.fheader.pixelheight) then begin
   for int1:=0 to count-1 do begin
    int2:= abs(sender.pickpos.x - round(items[int1].Position*fpixelperunit));
    if int2 < tabpickthreshold then begin
     setlength(objects,1);
     objects[0]:= int1;
     fpickkind:= 4;
     fpickarrayindex:= -1;
     break;
    end;
   end;
  end;
 end; 
 with fcontent.fdata do begin
  if (sender.pickpos.y>=fcontent.fdata.yposition) and (sender.pickpos.y<=fcontent.fdata.yposition+fcontent.fdata.pixelheight) then begin
   for int1:=0 to count-1 do begin
    int2:= abs(sender.pickpos.x - round(items[int1].Position*fpixelperunit));
    if int2 < tabpickthreshold then begin
     setlength(objects,1);
     objects[0]:= int1;
     fpickkind:= 5;
     fpickarrayindex:= -1;
     break;
    end;
   end;
  end;
 end; 
 with fcontent.ffooter do begin
  if (sender.pickpos.y>=fcontent.ffooter.yposition) and (sender.pickpos.y<=fcontent.ffooter.yposition+fcontent.ffooter.pixelheight) then begin
   for int1:=0 to count-1 do begin
    int2:= abs(sender.pickpos.x - round(items[int1].Position*fpixelperunit));
    if int2 < tabpickthreshold then begin
     setlength(objects,1);
     objects[0]:= int1;
     fpickkind:= 6;
     fpickarrayindex:= -1;
     break;
    end;
   end;
  end;
 end; 
end;

procedure TraSimpleReport.contentendpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                       const aoffset: pointty; const aobjects: integerarty);
begin
 case fpickkind of
  4: begin
      with fcontent.fheader do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  5: begin
      with fcontent.fdata do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  6: begin
      with fcontent.ffooter do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
 end;
end;
