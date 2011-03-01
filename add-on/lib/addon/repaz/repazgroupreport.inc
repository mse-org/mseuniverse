{ Implementation of repazgroupreporth.inc }

{ TGroupItem }

constructor TGroupItem.create(const aowner: TraTabulators);
begin
 inherited create;
 fdatalink:= aowner.datalink;
 fgrouplink:= tfielddatalink.create;
 fgrouplink.DataSource:= fdatalink.datasource;
 fheaderindex:= 0;
 ffooterindex:= 0;
 fgroupnumber:= 0;
end;

destructor TGroupItem.destroy;
begin
 inherited;
 fgrouplink.free;
end;

procedure TGroupItem.assign(source: tpersistent);
begin
 if source is TGroupItem then begin
  setgroupfield(TGroupItem(source).GroupField);
  fheaderindex:= TGroupItem(source).GroupHeaderIndex;
  ffooterindex:= TGroupItem(source).GroupFooterIndex;  
 end;
end;

function TGroupItem.isgroupchanged: boolean;
begin
 if fgrouplink.isstringfield then begin
  result:= fgrouplink.fieldactive and (flastgroupstring <> fgroupstring);
 end
 else begin
  result:= fgrouplink.fieldactive and (flastgroupnum <> fgroupnum);
 end;
end;

function TGroupItem.getdatasource(const aindex: integer): tdatasource;
begin
 result:= fdatalink.DataSource;
end;

procedure TGroupItem.getfieldtypes(out apropertynames: stringarty;
               out afieldtypes: fieldtypesarty);
begin
 setlength(apropertynames,1);
 apropertynames[0]:= 'GroupField';
 setlength(afieldtypes,1);
 afieldtypes[0]:= [ftinteger,ftlargeint,ftsmallint,
                     ftword,ftboolean] + textfields;
end;

function TGroupItem.getgroupfield: string;
begin
 result:= fgrouplink.fieldname;
end;

procedure TGroupItem.setgroupfield(const avalue: string);
begin
 fgrouplink.fieldname:= avalue;
end;

{ TGroupCol }

constructor TGroupCol.create(const aowner: TraTabulators);
begin
 fowner:= aowner;
 inherited create(TGroupItem);
end;

destructor TGroupCol.destroy;
begin
 inherited;
end;

procedure TGroupCol.insert(const index: integer; const aitem: TGroupItem);
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

function TGroupCol.getgroupitems(index: integer): TGroupItem;
begin
 result:= TGroupItem(getitems(index));
end;

procedure TGroupCol.setgroupitems(index: integer; const Value: TGroupItem);
begin
 TGroupItem(getitems(index)).assign(value);
end;

procedure TGroupCol.createitem(const index: integer; var item: tpersistent);
begin
 item:= TGroupItem.create(fowner);
end;

{ TraGroupTabulators}

constructor TraGroupTabulators.create(const aowner: TraReportTemplate);
begin
 fgroupcols:= TgroupCol.create(self);
 inherited;
end;

destructor TraGroupTabulators.destroy;
begin
 inherited; 
 fgroupcols.free;
end;

procedure TraGroupTabulators.init;
var
 int1: integer;
begin
 inherited;
 for int1:= 0 to fgroupcols.count-1 do begin
  with fgroupcols[int1] do begin
   if grouplink.fieldactive then begin
    if grouplink.isstringfield then begin
     fgroupstring:= grouplink.asmsestring;
     flastgroupstring:= grouplink.asmsestring;
    end
    else begin
     fgroupnum:= grouplink.aslargeint;
     flastgroupnum:= grouplink.aslargeint;
    end;
   end;
  end;
 end;
end;

procedure TraGroupTabulators.setdatasource(const avalue: string);
var
 int1: integer;
begin
 inherited; 
 for int1:= 0 to fgroupcols.count-1 do begin
  fgroupcols[int1].datalink.datasource:= fdatalink.datasource;
  fgroupcols[int1].grouplink.datasource:= fdatalink.datasource;
 end; 
end;

procedure TraGroupTabulators.dobeforenextrecord(const adatasource: tdatasource);
var
 int1: integer;
begin
 for int1:= 0 to fgroupcols.count-1 do begin
  with fgroupcols[int1] do begin
   if grouplink.fieldactive then begin
    if grouplink.isstringfield then begin
     flastgroupstring:= fgroupstring;
    end
    else begin
     flastgroupnum:= fgroupnum;
    end;
   end;
  end;
 end;
 inherited;
end;

procedure TraGroupTabulators.nextrecord;
var
 int1: integer;
begin
 application.lock;
 try
  dobeforenextrecord(fdatalink.DataSource);
  if fdatalink.active then begin
   fdatalink.dataset.next;
   for int1:= 0 to fgroupcols.count-1 do begin
    with fgroupcols[int1] do begin   
     if grouplink.fieldactive then begin
      if grouplink.isstringfield then begin
       fgroupstring:= grouplink.asmsestring;
      end
      else begin
       fgroupnum:= grouplink.aslargeint;
      end;
     end;
    end;
   end;
  end;
 finally
  application.unlock;
 end;
end;

procedure TraGroupTabulators.prevrecord;
var
 int1: integer;
begin
 application.lock;
 try
  if fdatalink.active then begin
   fdatalink.dataset.prior;
   for int1:= 0 to fgroupcols.count-1 do begin
    with fgroupcols[int1] do begin   
     if grouplink.fieldactive then begin
      if grouplink.isstringfield then begin
       flastgroupstring:= fgroupstring;
       fgroupstring:= grouplink.asmsestring;
      end
      else begin
       flastgroupnum:= fgroupnum;
       fgroupnum:= grouplink.aslargeint;
      end;
     end;
    end;
   end;
  end;
 finally
  application.unlock;
 end;
end;

{ TraGroupContent }

constructor TraGroupContent.create(const aowner: TraReportTemplate);
begin
 inherited create;
 fdatanumber:= -1;
 fowner:= aowner;
 fheader:= TNormalTabsCol.create(fowner);
 ffooter:= TSummaryTabsCol.create(fowner);
 fdataheader:= TNormalTabs.create(fowner);
 fdata:= TraGroupTabulators.create(fowner);
 fdata.recordarea:= ra_AllRecord;
 fmodfooter:= -1;
 minchanged:= 0;
end;

destructor TraGroupContent.destroy;
begin
 freeandnil(fheader);
 freeandnil(ffooter);
 freeandnil(fdata);
 freeandnil(fdataheader);
 inherited;
end;

procedure TraGroupContent.paint(const canvas: tcanvas;const area:rectty);
var
 int1,posy: integer;
begin
 posy:= 0;
 if fheader.count>0 then begin
  for int1:=0 to fheader.count-1 do begin
   with fheader[int1] do begin
    if posy<=area.cy-tabulators.pixelheight then begin
     tabulators.yposition:=posy+area.y;
     tabulators.paint(canvas,makerect(0,posy+area.y,area.cx,tabulators.pixelheight),false,false);
     inc(posy,tabulators.pixelheight);
    end;
   end;
  end;
 end;
 if fdataheader.count>0 then begin
  if posy<=area.cy-fdataheader.pixelheight then begin
   fdataheader.yposition:=posy+area.y;
   fdataheader.paint(canvas,makerect(0,posy+area.y,area.cx,fdataheader.pixelheight),false,false);
   inc(posy,fdataheader.pixelheight);
  end;
 end;
 if fdata.count>0 then begin
  if posy<=area.cy-fdata.pixelheight then begin
   fdata.yposition:=posy+area.y;
   fdata.paint(canvas,makerect(0,posy+area.y,area.cx,fdata.pixelheight),false,false);
   inc(posy,fdata.pixelheight);
  end;
 end;
 if ffooter.count>0 then begin
  for int1:=ffooter.count-1 downto 0 do begin
   with ffooter[int1] do begin
    if posy<=area.cy-tabulators.pixelheight then begin
     tabulators.yposition:=posy+area.y;
     tabulators.paint(canvas,makerect(0,posy+area.y,area.cx,tabulators.pixelheight),false,false);
     inc(posy,tabulators.pixelheight);
    end;
   end;
  end;
 end;
end;

function TraGroupContent.build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
var
 posy,limity,int1,int2,int3,hband,extheight: integer;
 bo1,eofbefore,newheader,isprev: boolean;

 function islastrecord:boolean;
 begin
  result:= (fdata.datalink.datasource.dataset.recordcount-fdata.datalink.datasource.dataset.recno)=0;
 end;
 
 procedure countingsummary(grandtotal: boolean);
 var
  int1: integer;
 begin
  if ffooter.count>0 then begin
   for int1:=0 to ffooter.count-1 do begin
    if (ffooter[int1].tabulators.count>0) and (ffooter[int1].tabulators.datalink.datasource<>nil) then begin
     ffooter[int1].tabulators.dobeforenextrecord(fdata.datalink.datasource);
    end;
   end;
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
 
 procedure drawfirstgroups;
 var
  int1: integer;
 begin
  //draw first headers group
  if fdata.groupfields.count>0 then begin
   for int1:=0 to fdata.groupfields.count-1 do begin  
    int2:= fdata.groupfields[int1].GroupHeaderIndex;
    if (fheader.count>0) and (int2<fheader.count) then begin
     if (posy+fheader[int2].tabulators.pixelheight<=limity) then begin
      fheader[int2].tabulators.paint(canvas,makerect(area.x,posy+area.y,area.cx,fheader[int2].tabulators.pixelheight),true,false);
      inc(posy,fheader[int2].tabulators.pixelheight);
     end;
    end;
   end;
  end; 
 end;
 
 procedure drawdataheader;
 begin
  if fdataheader.count>0 then begin
   fdataheader.paint(canvas,makerect(area.x,posy+area.y,area.cx,fdataheader.pixelheight),true,false);
   inc(posy,fdataheader.pixelheight);
  end;
 end;
begin
 posy:= 0;
 limity:= area.cy;
 eofbefore:= false;
 if (fowner.Report_Footer_RowValues.count>0) then begin
  extheight:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
 end else begin
  extheight:= 0;
 end;
 fdatanumber:= 0;
 if fdata.count>0 then begin
  bo1:= false;
  while not bo1 do begin
   if not fdata.iseof then begin
    hband:=fdata.pixelheight;
    if minchanged>=0 then begin
     for int1:= minchanged to fdata.groupfields.count-1 do begin
      if (fdata.groupfields[int1].isgroupchanged) or (fdata.datalink.dataset.recno=1) then begin
       int2:= fdata.groupfields[int1].GroupHeaderIndex;
       if (fheader.count>0) and (int2<fheader.count) then begin
        inc(hband,fheader[int2].tabulators.pixelheight);
       end;
      end;
     end;
    end;
    //begin draw mod footer
    if (fmodfooter>=0) and (minchanged>=0) then begin
     for int1:= fmodfooter downto minchanged do begin
      if (fdata.groupfields[int1].isgroupchanged) then begin
       int2:= fdata.groupfields[int1].GroupFooterIndex;
       if (ffooter[int2].tabulators.count>0) and (int2<ffooter[int2].tabulators.count) then begin
        ffooter[int2].tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,ffooter[int2].tabulators.pixelheight),true,true);
        inc(posy,ffooter[int2].tabulators.pixelheight);
       end;
      end;
     end;
     //countingsummary(false);
     fdata.nextrecord;
    end;
    //end draw mod footer
    if fowner.Report_Footer_Show=frs_EveryPage then begin
     limity:= area.cy - extheight;
    end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
     if islastrecord then begin
      if hband+posy<=area.cy-extheight then begin
       limity:= area.cy - extheight;
       islastpage:= true;
      end else begin
       limity:= area.cy;
       bo1:= true;
      end;
     end else begin
      limity:= area.cy - extheight;
     end;
    end;
    if (hband+posy<=limity) and not bo1 then begin
     newheader:= false;
     if minchanged>=0 then begin
      for int1:= minchanged to fdata.groupfields.count-1 do begin
       if (fdata.groupfields[int1].isgroupchanged) or (fdata.datalink.dataset.recno=1) then begin
        newheader:= true;
        inc(fdata.groupfields[int1].fgroupnumber);
        int2:= fdata.groupfields[int1].GroupHeaderIndex;
        if (int2<fheader.count) then begin
         fheader[int2].tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,fheader[int2].tabulators.pixelheight),true,true);
         inc(posy,fheader[int2].tabulators.pixelheight);
         int2:= fdata.groupfields[int1].GroupFooterIndex;
         if int2>=0 then begin
          for int3:=int2 to ffooter.count-1 do begin
           ffooter[int3].tabulators.resetsums(false);
          end;
         end;
        end;
       end;
      end;
     end;
     if newheader then begin
      drawdataheader;
      fdatanumber:= 0;
     end else begin
      if posy=0 then begin
       fdataheader.paintextend(canvas,makerect(area.x,area.y+posy,area.cx,fdataheader.pixelheight),true,false,false,true,false);
      end;
     end;
     inc(fdatanumber);
     fdata.paint(canvas,makerect(area.x,area.y+posy,area.cx,fdata.pixelheight),true,false);
     inc(posy,fdata.pixelheight);
     countingsummary(true);
     fdata.nextrecord;
     isprev:= false;
     fmodfooter:= -1;
     minchanged:= -1;
     for int1:= 0 to fdata.groupfields.count-1 do begin
      if (fdata.groupfields[int1].isgroupchanged) or islastpage then begin
       minchanged:= int1;
       break;
      end;
     end;
     if minchanged>=0 then begin
      for int1:= fdata.groupfields.count-1 downto minchanged do begin
       int2:= fdata.groupfields[int1].GroupFooterIndex;
       if int1+1<=fdata.groupfields.count-1 then
       fdata.groupfields[int1+1].groupnumber:=0;
       if int2>=0 then begin
        if (ffooter[int2].tabulators.count>0) and (int2<ffooter[int2].tabulators.count) then begin
         if (not isprev) and (not islastrecord) then begin
          fdata.prevrecord;
          isprev:= true;
         end;
         if posy+ffooter[int2].tabulators.pixelheight<=limity then begin
          ffooter[int2].tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,ffooter[int2].tabulators.pixelheight),true,false);
          inc(posy,ffooter[int2].tabulators.pixelheight);
         end else begin
          fmodfooter:= int1;
          bo1:= true;
          islastpage:= false;
          break;
         end;
        end;
       end;
      end;
     end;
     if isprev and (fmodfooter=-1) then begin
      fdata.nextrecord;
     end;
     if fdata.iseof then bo1:= true;
    end else begin
     bo1:= true;
    end;
   end else begin
    hband:=fdata.pixelheight;
    if minchanged>=0 then begin
     for int1:= minchanged to fdata.groupfields.count-1 do begin
      if (fdata.groupfields[int1].isgroupchanged) or (fdata.datalink.dataset.recno=1) then begin
       int2:= fdata.groupfields[int1].GroupHeaderIndex;
       if (fheader.count>0) and (int2<fheader.count) then begin
        inc(hband,fheader[int2].tabulators.pixelheight);
       end;
      end;
     end;
    end;
    //begin draw mod footer in the last record
    if (fmodfooter>=0) and (minchanged>=0) then begin
     for int1:= fmodfooter downto minchanged do begin
      int2:= fdata.groupfields[int1].GroupFooterIndex;
      if (ffooter[int2].tabulators.count>0) and (int2<ffooter[int2].tabulators.count) then begin
       ffooter[int2].tabulators.paint(canvas,makerect(area.x,area.y+posy,area.cx,ffooter[int2].tabulators.pixelheight),true,true);
       inc(posy,ffooter[int2].tabulators.pixelheight);
      end;
     end;
    end;
    islastpage:= true;
    eofbefore:= true;
   end;   
   if fdata.iseof then begin
    bo1:= true;
   end;
   if ((not isprev) and bo1) or ((fmodfooter>=0) and isprev) then begin
    int2:= fdata.groupfields[fdata.groupfields.count-1].GroupFooterIndex;
    if int2>=0 then begin
     ffooter[int2].tabulators.paintextend(canvas,makerect(area.x,area.y+posy-fdata.pixelheight,area.cx,fdata.pixelheight),true,false,false,false,true);
    end;
   end;
  end;
 end else begin
  islastpage:= true;
 end;
 result:= posy+area.y;
end;

procedure TraGroupContent.adddatasets(var adatasets: datasetarty);
var
 int1: integer;
begin
 if fheader.count>0 then begin
  for int1:=0 to fheader.count-1 do begin
   if (fheader[int1].tabulators.count>0) and (fheader[int1].tabulators.datalink.dataset <> nil) then begin
    adduniqueitem(pointerarty(adatasets),fheader[int1].tabulators.datalink.dataset);
   end;
  end;
 end;
 if ffooter.count>0 then begin
  for int1:=0 to ffooter.count-1 do begin
   if (ffooter[int1].tabulators.count>0) and (ffooter[int1].tabulators.datalink.dataset <> nil) then begin
    adduniqueitem(pointerarty(adatasets),ffooter[int1].tabulators.datalink.dataset);
   end;
  end;
 end;
 if (fdataheader.count>0) and (fdataheader.datalink.dataset <> nil) then begin
   adduniqueitem(pointerarty(adatasets),fdataheader.datalink.dataset);
 end;
 if (fdata.count>0) and (fdata.datalink.dataset <> nil) then begin
   adduniqueitem(pointerarty(adatasets),fdata.datalink.dataset);
 end;
end;

procedure TraGroupContent.init;
var
 int1: integer;
begin
 if fheader.count>0 then begin
  for int1:=0 to fheader.count-1 do begin
   fheader[int1].tabulators.init;
  end;
 end;
 if fdataheader.count>0 then begin
  fdataheader.init;
 end;
 if fdata.count>0 then begin
  fdata.init;
  if fdata.groupfields.count>0 then begin
   for int1:=0 to fdata.groupfields.count-1 do begin
    fdata.groupfields[int1].groupnumber:= 0;
   end;
  end;
 end;
 if ffooter.count>0 then begin
  for int1:=0 to ffooter.count-1 do begin
   ffooter[int1].tabulators.init;
  end;
 end;
end;

procedure TraGroupContent.updatelinks;
var
 int1: integer;
begin
 if fheader.count>0 then begin
  for int1:=0 to fheader.count-1 do begin
   fheader[int1].tabulators.updatelinks;
  end;
 end;
 if fdataheader.count>0 then begin
  fdataheader.updatelinks;
 end;
 if fdata.count>0 then begin
  fdata.updatelinks;
 end;
 if ffooter.count>0 then begin
  for int1:=0 to ffooter.count-1 do begin
   ffooter[int1].tabulators.updatelinks;
  end;
 end;
end;

function TraGroupContent.groupnumber(aindex: integer): integer;
begin
 if (aindex>=0) and (aindex<fdata.groupfields.count) then begin
  result:= fdata.groupfields[aindex].groupnumber;
 end else begin
  result:= -1;
 end;
end;

{ TraGroupReport }

constructor TraGroupReport.create(aowner: tcomponent);
begin
 inherited;
 fcontent:= TraGroupContent.create(self);
end;

destructor TraGroupReport.destroy;
begin
 freeandnil(fcontent);
 inherited;
end;

procedure TraGroupReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
begin
 if fcontent<>nil then begin
  fcontent.paint(canvas,contentarea);
 end;
end;

function TraGroupReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
begin
 result:= fcontent.build(acanvas,contentarea,islastpage);
end;

procedure TraGroupReport.addcontentdatasets(var adatasets: datasetarty);
begin
 fcontent.adddatasets(adatasets);
end;

procedure TraGroupReport.contentinit;
begin
 fcontent.init;
end;

procedure TraGroupReport.contentupdatelinks;
begin
 fcontent.updatelinks;
end;

procedure TraGroupReport.setcontentpixelperunit(const avalue: real);
var
 int1: integer;
begin
 if fcontent.groupheader.count>0 then begin
  for int1:=0 to fcontent.groupheader.count-1 do begin
   fcontent.groupheader[int1].tabulators.setpixelperunit(avalue);
  end;
 end;
 fcontent.groupdata_dataheader.setpixelperunit(avalue);
 fcontent.groupdata_data.setpixelperunit(avalue);
 if fcontent.groupfooter.count>0 then begin
  for int1:=0 to fcontent.groupfooter.count-1 do begin
   fcontent.groupfooter[int1].tabulators.setpixelperunit(avalue);
  end;
 end;
end;

function TraGroupReport.groupheadervalue(indexrow: integer; indexcol:integer): variant;
begin
 if (indexrow>=0) and (indexrow<=fcontent.groupheader.count-1) then begin
  if (indexcol>=0) and (indexcol<=fcontent.groupheader[indexrow].tabulators.count-1) then begin
   result:= fcontent.groupheader[indexrow].tabulators.items[indexcol].value;
  end;
 end;
end;

function TraGroupReport.groupfootervalue(indexrow: integer; indexcol:integer): variant;
begin
 if (indexrow>=0) and (indexrow<=fcontent.groupfooter.count-1) then begin
  if (indexcol>=0) and (indexcol<=fcontent.groupfooter[indexrow].tabulators.count-1) then begin
   result:= fcontent.groupfooter[indexrow].tabulators.items[indexcol].value;
  end;
 end;
end;

function TraGroupReport.groupdatavalue(indexcol:integer): variant;
begin
 if (indexcol>=0) and (indexcol<=fcontent.groupdata_data.count-1) then begin
  result:= fcontent.groupdata_data.items[indexcol].value;
 end;
end;

function TraGroupReport.recordnumber: integer;
begin
 if fcontent.groupdata_data.datalink.active then begin
  result:= fcontent.groupdata_data.datalink.dataset.recno;
 end;
end;

function TraGroupReport.datanumber: integer;
begin
 result:= fcontent.datanumber;
end;

function TraGroupReport.groupnumber(aindex: integer): integer;
begin
 result:= fcontent.groupnumber(aindex);
end;

function TraGroupReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;

procedure TraGroupReport.contentgetpickobjects(const sender: tobjectpicker; var objects: integerarty);
var
 int1,int2,int3: integer;
begin
 if fcontent.GroupHeader.count>0 then begin
  for int1:=0 to fcontent.GroupHeader.count-1 do begin
   with fcontent.GroupHeader[int1].tabulators do begin
    if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
     for int2:=0 to count-1 do begin
      int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
      if int3 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 10;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
 if fcontent.GroupData_DataHeader.count>0 then begin
  with fcontent.GroupData_DataHeader do begin
   if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
    for int2:=0 to count-1 do begin
     int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
     if int3 < tabpickthreshold then begin
      setlength(objects,1);
      objects[0]:= int2;
      fpickkind:= 11;
      fpickarrayindex:= -1;
      break;
     end;
    end;
   end;
  end;
 end;
 if fcontent.GroupData_Data.count>0 then begin
  with fcontent.GroupData_Data do begin
   if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
    for int2:=0 to count-1 do begin
     int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
     if int3 < tabpickthreshold then begin
      setlength(objects,1);
      objects[0]:= int2;
      fpickkind:= 12;
      fpickarrayindex:= -1;
      break;
     end;
    end;
   end;
  end;
 end;
 if fcontent.GroupFooter.count>0 then begin
  for int1:=fcontent.GroupFooter.count-1 downto 0 do begin
   with fcontent.GroupFooter[int1].tabulators do begin
    if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
     for int2:=0 to count-1 do begin
      int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
      if int3 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 13;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure TraGroupReport.contentendpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                       const aoffset: pointty; const aobjects: integerarty);
begin
 case fpickkind of
  10: begin
      with fcontent.GroupHeader.items[fpickarrayindex].tabulators do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  11: begin
      with fcontent.GroupData_DataHeader do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  12: begin
      with fcontent.GroupData_Data do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  13: begin
      with fcontent.GroupFooter.items[fpickarrayindex].tabulators do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
 end;
end;
