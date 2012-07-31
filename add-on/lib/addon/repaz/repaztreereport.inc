{ Implementation of repaztreereporth.inc }

{ TraTreeTabulators}

constructor TraTreeTabulators.create(const aowner: TraReportTemplate);
begin
 fkeyfieldlink:= tfielddatalink.create;
 fparentfieldlink:= tfielddatalink.create;
 findextree:= -1;
 frecordarea:= ra_AllRecord;
 fprintifnochild:= true;
 inherited;
end;

destructor TraTreeTabulators.destroy;
begin
 inherited; 
 fkeyfieldlink.free;
 fparentfieldlink.free;
end;

procedure TraTreeTabulators.assign(source: tpersistent);
begin
 inherited;
 setkeyfield(TraTreeTabulators(source).Tree_KeyField);
 setparentfield(TraTreeTabulators(source).Tree_ParentField); 
end;

function TraTreeTabulators.getdataset(const aindex: integer): tdataset;
begin
 result:= fdatalink.datasource.dataset;
end;

procedure TraTreeTabulators.getfieldtypes(out apropertynames: stringarty;
               out afieldtypes: fieldtypesarty);
begin
 setlength(apropertynames,2);
 apropertynames[0]:= 'Tree_KeyField';
 apropertynames[1]:= 'Tree_ParentField';
 setlength(afieldtypes,1);
 afieldtypes[0]:= [ftinteger,ftlargeint,ftsmallint,
                     ftword,ftboolean] + textfields;
end;

function TraTreeTabulators.getkeyfield: string;
begin
 result:= fkeyfieldlink.fieldname;
end;

procedure TraTreeTabulators.setkeyfield(const avalue: string);
begin
 fkeyfieldlink.fieldname:= avalue;
end;

function TraTreeTabulators.getparentfield: string;
begin
 result:= fparentfieldlink.fieldname;
end;

procedure TraTreeTabulators.setparentfield(const avalue: string);
begin
 fparentfieldlink.fieldname:= avalue;
end;

procedure TraTreeTabulators.init;
begin
 inherited;
 try
  ftreeheader:= nil;
  setlength(ftreeheader,0);
  findextree:= -1;
 except
 end;
end;

procedure TraTreeTabulators.setdatasource(const avalue: string);
begin
 inherited; 
 fkeyfieldlink.datasource:= fdatalink.datasource;
 fparentfieldlink.datasource:= fdatalink.datasource;
end;

procedure TraTreeTabulators.dobeforenextrecord(const adatasource: tdatasource);
begin
 inherited;
end;

procedure TraTreeTabulators.nextrecord;
begin
 inherited;
end;

procedure TraTreeTabulators.checklevel;
var
 int1: integer;
 found: boolean;
 res1: integer;
begin
 if fkeyfieldlink.active and (fkeyfieldlink.field<>nil) then begin
  found:= false;
  for int1:=0 to length(ftreeheader)-1 do begin
   //debugwriteln(inttostr(int1)+' = '+ftreeheader[int1].parentstr);
   if fkeyfieldlink.isstringfield then begin
    if fparentfieldlink.asmsestring=ftreeheader[int1].parentstr then begin
     res1:= ftreeheader[int1].indextree;
     found:= true;
     break;
    end;
   end else begin
    if fparentfieldlink.aslargeint=ftreeheader[int1].parentnum then begin
     res1:= ftreeheader[int1].indextree;
     found:= true;
     break;
    end;
   end;
  end;
  if not found then begin
   inc(findextree);
  end else begin  
   findextree:= res1;
  end;
 end;
end;

{ TraTreeBand }

constructor TraTreeBand.create(const aowner: TraReportTemplate);
begin
 inherited create;
 fowner:= aowner;
 fheader:= TraTreeTabulators.create(fowner);
 ftreefooter:= TSummaryTabsCol.create(fowner);
 fheader.recordarea:= ra_AllRecord;
 ffooter:= TSummaryTabs.create(fowner);
 ffooter2:= TSummaryTabs.create(fowner);
 fdata:= TNormalTabs.create(fowner);
 fheaderdetail:= TNormalTabs.create(fowner);
 fheaderdetail.recordarea:= ra_CurrentRecord;
 fdata.recordarea:= ra_AllRecord;
 ftreegap:= defaulttreegap/fowner.pixelperunit;
 ftreecol:= 0;
 fprintdetail:= true;
end;

destructor TraTreeBand.destroy;
begin
 freeandnil(fheader);
 freeandnil(ffooter);
 freeandnil(ftreefooter);
 freeandnil(ffooter2);
 freeandnil(fdata);
 freeandnil(fheaderdetail);
 inherited;
end;

procedure TraTreeBand.assign(source: tpersistent);
begin
 if source is TraTreeBand then begin
  ftreecol:= TraTreeBand(source).TreeColIndex;
  ftreegap:= TraTreeBand(source).TreeGap;
  fheader.assign(TraTreeBand(source).MasterHeader);
  ffooter.assign(TraTreeBand(source).MasterFooter);
  ffooter2.assign(TraTreeBand(source).Footer);
  ftreefooter.assign(TraTreeBand(source).TreeFooter);
  fdata.assign(TraTreeBand(source).Detail);
  fheaderdetail.assign(TraTreeBand(source).HeaderDetail);
  fkeyheader:= TraTreeBand(source).KeyFieldHeader;
  fparamname:= TraTreeBand(source).DetailParams;
 end;
end;

function TraTreeBand.getdataset(const aindex: integer): tdataset;
begin
 result:= fheader.datalink.datasource.dataset;
end;

procedure TraTreeBand.getfieldtypes(out apropertynames: stringarty;
               out afieldtypes: fieldtypesarty);
begin
 setlength(apropertynames,1);
 apropertynames[0]:= 'KeyFieldHeader';
 setlength(afieldtypes,1);
 afieldtypes[0]:= [ftinteger,ftlargeint,ftsmallint,
                     ftword,ftboolean] + textfields;
end;


function TraTreeBand.getdestdataset: tsqlquery;
begin
 result:= tsqlquery(fdata.datalink.dataset);
end;

{ TraTreeContent }

constructor TraTreeContent.create(const aowner: TraReportTemplate);
begin
 fowner:= aowner;
 fneedfooter:= true;
 fmodheader:= false;
 fpreviewing:= false;
 fmodfooter:= -1;
 ishaschildren:= false;
 fmodmasterfooter:= false;
 fmodtreefooter:= -1;
 findextree:= -1;
 inherited create(TraTreeBand);
end;

destructor TraTreeContent.destroy;
begin
 inherited;
end;

procedure TraTreeContent.insert(const index: integer; const aitem: TraTreeBand);
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

function TraTreeContent.gettreeitems(index: integer): TraTreeBand;
begin
 result:= TraTreeBand(getitems(index));
end;

procedure TraTreeContent.settreeitems(index: integer; const Value: TraTreeBand);
begin
 TraTreeBand(getitems(index)).assign(value);
end;

procedure TraTreeContent.createitem(const index: integer; var item: tpersistent);
begin
 item:= TraTreeBand.create(fowner);
end;

procedure TraTreeContent.paint(const aindex:integer; var posy:integer; const canvas: tcanvas;const area:rectty);
var
 int1,counter: integer;
 isfinish: boolean;
 tmpwidth,tmppos: real;
label emptyfooter;
 procedure drawfooter;
 var
  int2,int3: integer;
 begin
  with items[aindex] do begin
   if footer.count>0 then begin
    int3:= footer.pixelheight;
   end else begin
    int3:= 0;
   end;
   if masterfooter.count>0 then begin
    for int2:=masterheader.indextree-1 downto 0 do begin
     if posy<=area.cy-int3-footerarty[int2].pixelheight then begin
      factivefooterkey:= masterheader.treeheader[int2].keystr;
      footerarty[int2].yposition:= posy+area.y;
      footerarty[int2].paint(canvas,makerect(0,posy+area.y,area.cx,footerarty[int1].pixelheight),false,true);
      inc(posy,footerarty[int2].pixelheight);
     end else begin
      isfinish:= true;
     end;
    end;
   end;
   if footer.count>0 then begin
    if posy<=area.cy-int3 then begin
     footer.yposition:= posy+area.y;
     footer.paint(canvas,makerect(0,posy+area.y,area.cx,footer.pixelheight),false,true);
     inc(posy,footer.pixelheight);
    end else begin
     isfinish:= true;
    end;
   end;
  end;
 end;
  
begin
 if fpreviewing then exit;
 isfinish:= false;
 counter:= 0;
 with items[aindex] do begin
  masterheader.init;
  masterheader.indextree:= 0;
  if (not masterheader.datalink.active) or masterheader.iseof then exit;
  if KeyFieldHeader='' then exit;
  footerarty:=nil;
  if masterheader.datalink.active and detail.datalink.active then begin
   try
    with tmsesqlquery(detail.datalink.dataset) do begin
     params.parambyname(DetailParams).value:= tmsesqlquery(
       masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
     refresh;
     disablecontrols;
    end;
   except
    exit;
   end;
  end;
  while not isfinish do begin
   if (masterheader.count>0) and (not masterheader.iseof) then begin
    if posy<=area.cy-masterheader.pixelheight then begin
     tmppos:= masterheader[TreeColIndex].position;
     tmpwidth:= masterheader[TreeColIndex].width;
     delta:= masterheader.indextree*TreeGap;
     treepos:= tmppos+delta;
     masterheader[TreeColIndex].fpos:= treepos;
     masterheader[TreeColIndex].fwidth:= tmpwidth-delta;
     masterheader.yposition:= posy+area.y;
     masterheader.paint(canvas,makerect(0,posy+area.y,area.cx,masterheader.pixelheight),false,false);
     masterheader[TreeColIndex].fpos:= tmppos;
     masterheader[TreeColIndex].fwidth:= tmpwidth;
     inc(posy,masterheader.pixelheight);
     masterheader.checklevel;
     setlength(masterheader.ftreeheader,masterheader.indextree+1);
     if masterheader.parentfieldlink.isstringfield then begin
      masterheader.treeheader[masterheader.indextree].parentstr:= masterheader.parentfieldlink.asmsestring;
      masterheader.treeheader[masterheader.indextree].keystr:= masterheader.keyfieldlink.asstring;
     end else begin
      masterheader.treeheader[masterheader.indextree].parentnum:= masterheader.parentfieldlink.aslargeint;
      masterheader.treeheader[masterheader.indextree].keynum:= masterheader.keyfieldlink.aslargeint;
     end;
     masterheader.treeheader[masterheader.indextree].indextree:= masterheader.indextree;
     createfooter(aindex);
     if detail.datalink.datasource<>nil then begin
      if detail.datalink.dataset.recordcount>0  then begin
       if headerdetail.count>0 then begin
        if posy<=area.cy-headerdetail.pixelheight then begin
         tmppos:= headerdetail[TreeColIndex].position;
         tmpwidth:= headerdetail[TreeColIndex].width;
         headerdetail[TreeColIndex].fpos:= treepos+TreeGap;
         headerdetail[TreeColIndex].fwidth:= tmpwidth-delta-TreeGap;
         headerdetail.yposition:= posy+area.y;
         headerdetail.paint(canvas,makerect(0,posy+area.y,area.cx,headerdetail.pixelheight),false,false);
         inc(posy,headerdetail.pixelheight);
         headerdetail[TreeColIndex].fpos:= tmppos;
         headerdetail[TreeColIndex].fwidth:= tmpwidth;
        end;
       end;
       if detail.count>0 then begin
        if not detail.datalink.active then goto emptyfooter;
        detail.datalink.dataset.first;
        if posy<=area.cy-detail.pixelheight then begin
         tmppos:= detail[TreeColIndex].position;
         tmpwidth:= detail[TreeColIndex].width;
         detail[TreeColIndex].fpos:= treepos+TreeGap;
         detail[TreeColIndex].fwidth:= tmpwidth-delta-TreeGap;
         if fprintdetail then begin
          detail.yposition:= posy+area.y;
          detail.paint(canvas,makerect(0,posy+area.y,area.cx,detail.pixelheight),false,false);
          inc(posy,detail.pixelheight);
         end;
         detail[TreeColIndex].fpos:= tmppos;
         detail[TreeColIndex].fwidth:= tmpwidth;
         isfinish:= true;
         for int1:=0 to masterheader.indextree do begin
          footerarty[int1].dobeforenextrecord(detail.datalink.datasource);
         end;
         if ftreefooter.count>0 then begin
          for int1:=0 to ftreefooter.count-1 do begin
           if (ftreefooter[int1].tabulators.count>0) and (ftreefooter[int1].tabulators.datalink.datasource<>nil) then begin
            ftreefooter[int1].tabulators.dobeforenextrecord(detail.datalink.datasource);
           end;
          end;
         end;
         drawfooter;
        end;
       end;
      {end else begin
       inc(counter);
       if counter=1 then begin
        drawfooter;
        isfinish:= true;
       end;}
      end;
     end else begin
      inc(counter);
      if counter=1 then begin
       drawfooter;
       isfinish:= true;
      end;
     end;
     if not isfinish then begin
      masterheader.nextrecord;
      if masterheader.datalink.active and detail.datalink.active then begin
       with tmsesqlquery(detail.datalink.dataset) do begin
        params.parambyname(DetailParams).value:= tmsesqlquery(
          masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
        refresh;
       end;
      end;
     end;
    end else begin
     isfinish:= true;
    end;
   end else begin
    isfinish:= true;
   end;
  end;
  if ftreefooter.count>0 then begin
   for int1:=ftreefooter.count-1 downto 0 do begin
    with ftreefooter[int1] do begin
     if posy<=area.cy-tabulators.pixelheight then begin
      tabulators.yposition:=posy+area.y;
      tabulators.paint(canvas,makerect(0,posy+area.y,area.cx,tabulators.pixelheight),false,false);
      inc(posy,tabulators.pixelheight);
     end;
    end;
   end;
  end;
emptyfooter:
  for int1:=length(footerarty)-1 downto 0 do begin
   footerarty[int1].free;
  end;
  footerarty:=nil;
 end;
end;

procedure TraTreeContent.createfooter(const aindex:integer);
var
 int1,int2,int3: integer;
begin
 with items[aindex] do begin
  if length(footerarty)<masterheader.indextree+1 then begin
   int2:= length(footerarty);
   setlength(ffooterarty,length(masterheader.ftreeheader));
   for int3:=int2 to high(masterheader.ftreeheader) do begin
    footerarty[int3]:= TSummaryTabs.create(fowner);
    footerarty[int3].count:= masterfooter.count;
    for int1:=0 to masterfooter.count-1 do begin
     footerarty[int3][int1].assign(masterfooter[int1]);
    end;
    if TreeColIndex<footerarty[int3].count then begin
     footerarty[int3][TreeColIndex].fpos:= masterfooter[TreeColIndex].position+(int3*TreeGap);
     footerarty[int3][TreeColIndex].fwidth:= masterfooter[TreeColIndex].width-(int3*TreeGap);
    end;
    footerarty[int3].datasource:= masterfooter.datasource;
    footerarty[int3].height:= masterfooter.height;
    //footerarty[int3].PixelPerUnit:= masterfooter.PixelPerUnit;
    footerarty[int3].backcolor:= masterfooter.backcolor;
    footerarty[int3].RAW_EmptyLinesBelow:= masterfooter.RAW_EmptyLinesBelow;
   end;
  end;
 end;
end;

function TraTreeContent.build(const aindex:integer; var posy: integer;
  const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
var
 int1,int2,int3,j,extheight,limity,hband: integer;
 isfinish,fprintfooter: boolean;
 tmpwidth,tmppos: real;

 function islastrecord:boolean;
 begin
  result:= ((items[aindex].detail.datalink.datasource.dataset.recordcount-
   items[aindex].detail.datalink.datasource.dataset.recno)=0) and
   ((items[aindex].masterheader.datalink.datasource.dataset.recordcount-
   items[aindex].masterheader.datalink.datasource.dataset.recno)=0) and
   (aindex=self.count-1);
 end;

 procedure updateheader(const headerlength:integer; const changelength: boolean);
 begin
  with items[aindex] do begin
   //if (high(masterheader.ftreeheader)=headerlength) and not istemp then exit;
   if changelength then begin
    setlength(masterheader.ftreeheader,headerlength+1);
   end;
   if headerlength<0 then exit;
   if masterheader.parentfieldlink.isstringfield then begin
    masterheader.treeheader[headerlength].parentstr:= masterheader.parentfieldlink.asmsestring;
    masterheader.treeheader[headerlength].keystr:= masterheader.keyfieldlink.asstring;
   end else begin
    masterheader.treeheader[headerlength].parentnum:= masterheader.parentfieldlink.aslargeint;
    masterheader.treeheader[headerlength].keynum:= masterheader.keyfieldlink.aslargeint;
   end;
   masterheader.treeheader[headerlength].indextree:= masterheader.indextree;
  end;
 end;
 
 function drawfooter(astart:integer; aend: integer):integer;
 var
  int3,int4: integer;
 begin
  with items[aindex] do begin
   result:= -1;
   if footer.count>0 then begin
    int4:= footer.pixelheight;
   end else begin
    int4:= 0;
   end;
   if masterfooter.count>0 then begin
    for int3:=astart downto aend do begin
     if posy<=limity-int4-footerarty[int3].pixelheight then begin
      factivefooterkey:= masterheader.treeheader[int3].keystr;
      footerarty[int3].paint(canvas,makerect(area.x,posy+area.y,area.cx,footerarty[int3].pixelheight),true,false);
      inc(posy,footerarty[int3].pixelheight);
      footerarty[int3].resetsums(false);
      if int3=0 then
       result:= -1
      else
       result:= int3-1;
      if int3=aend then begin
       fneedfooter:= false;
       fnextindex:= -1;
       fnextrow:= -1;
      end;
     end else begin
      result:= int3;
      TraTreeReport(fowner).continuetree:= false;
      isfinish:= true;
      break;
     end;
    end;
   end;
  end;
 end;
 
 procedure updatefooter;
 begin
  with items[aindex] do begin
   while high(footerarty)>length(masterheader.treeheader) do begin
    footerarty[high(footerarty)].destroy;
    setlength(ffooterarty,high(footerarty));
   end;
  end;
 end;

 procedure drawheaderdetail;
 begin
  with items[aindex] do begin
   if headerdetail.count>0 then begin
    tmppos:= headerdetail[TreeColIndex].position;
    tmpwidth:= headerdetail[TreeColIndex].width;
    headerdetail[TreeColIndex].fpos:= treepos+TreeGap;
    headerdetail[TreeColIndex].fwidth:= tmpwidth-delta-TreeGap;
    //begin check limit
    hband:= headerdetail.pixelheight;
    if fowner.Report_Footer_Show=frs_EveryPage then begin
     limity:= area.cy - extheight;
    end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
     if islastrecord then begin
      if hband+posy<=area.cy-extheight then begin
       limity:= area.cy - extheight;
       islastpage:= true;
      end else begin
       limity:= area.cy;
      end;
     end else begin
      limity:= area.cy;
     end;
     //end check limit
     if posy<=limity-headerdetail.pixelheight then begin
      headerdetail.paint(canvas,makerect(area.x,posy+area.y,area.cx,headerdetail.pixelheight),true,false);
      inc(posy,headerdetail.pixelheight);
     end else begin
      isfinish:= true;
      TraTreeReport(fowner).continuetree:= false;
     end;
    end;
    headerdetail[TreeColIndex].fpos:= tmppos;
    headerdetail[TreeColIndex].fwidth:= tmpwidth;
   end;
  end;
 end;
 
 procedure drawdetail;
 var
  int3: integer;
  isfinish2: boolean;
 begin
  with items[aindex] do begin
   if (detail.datalink.dataset.recordcount>0) and (not detail.iseof) then begin
    if fprintdetail then begin
     drawheaderdetail;
    end;
    if fneedfooter then begin
     fneedfooter:= false;
     detail.datalink.dataset.first;
     fdatanumber:= 1;
    end;
    isfinish2:= false;
    tmppos:= detail[TreeColIndex].position;
    tmpwidth:= detail[TreeColIndex].width;
    detail[TreeColIndex].fpos:= treepos+TreeGap;
    detail[TreeColIndex].fwidth:= tmpwidth-delta-TreeGap;
    while not isfinish2 do begin
     //begin check limit
     hband:= detail.pixelheight;
     if fowner.Report_Footer_Show=frs_EveryPage then begin
      limity:= area.cy - extheight;
     end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
      if islastrecord then begin
       if hband+posy<=area.cy-extheight then begin
        limity:= area.cy - extheight;
        islastpage:= true;
       end else begin
        limity:= area.cy;
       end;
      end else begin
       limity:= area.cy;
      end;
     end;
     //end check limit
     if posy<=limity-detail.pixelheight then begin
      if fprintdetail then begin
       //debugwriteln(detail.datalink.dataset.fieldbyname('id').asstring);
       detail.paint(canvas,makerect(area.x,posy+area.y,area.cx,detail.pixelheight),true,false);
       inc(posy,detail.pixelheight);
      end;
      items[aindex].footer.dobeforenextrecord(detail.datalink.datasource);
      if ftreefooter.count>0 then begin
       for int3:=0 to ftreefooter.count-1 do begin
        if (ftreefooter[int3].tabulators.count>0) and (ftreefooter[int3].tabulators.datalink.datasource<>nil) then begin
         ftreefooter[int3].tabulators.dobeforenextrecord(detail.datalink.datasource);
        end;
       end;
      end;
      //process counting for report footer
      if (fowner.report_footer_rowvalues.count>0) then begin
       for int3:=0 to fowner.report_footer_rowvalues.count-1 do begin
        if fowner.report_footer_rowvalues.items[int3].tabulators.datalink.datasource<>nil then begin
         fowner.report_footer_rowvalues.items[int3].tabulators.dobeforenextrecord(detail.datalink.datasource);
        end;
       end;
      end;
      for int3:=0 to high(footerarty) do begin
       footerarty[int3].dobeforenextrecord(detail.datalink.datasource);
      end;
      detail.nextrecord;
      inc(fdatanumber);
     end else begin
      isfinish2:= true;
      isfinish:= true;
      TraTreeReport(fowner).continuetree:= false;
     end;
     if detail.iseof then begin
      fneedfooter:= true;
      isfinish2:= true;
     end;
    end;
    detail[TreeColIndex].fpos:= tmppos;
    detail[TreeColIndex].fwidth:= tmpwidth;
   end else begin
    fneedfooter:= false;
   end;
  end;
 end;
 
 function haschildren: boolean;
 var
  lastrow,tmptree,k: integer;
  shouldstop: boolean;
  findexstr1,fparentstr1: msestring;
  findexint1,fparentint1: int64;
 begin
  j:= 0;
  with items[aindex] do begin
   if (fnextrow>masterheader.datalink.dataset.recno) then begin
    result:= true;
    exit;
   end else if (fnextrow=masterheader.datalink.dataset.recno) then begin
    result:= true;
   //debugwriteln(inttostr(fnextrow)+' = '+inttostr(fnextindex));
    with tmsesqlquery(detail.datalink.dataset) do begin
     active:= false;
     params.parambyname(DetailParams).value:= tmsesqlquery(
       masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
     active:= true;
    end;
    exit;
   end;
   lastrow:= masterheader.datalink.dataset.recno;
   with tmsesqlquery(detail.datalink.dataset) do begin
    active:= false;
    params.parambyname(DetailParams).value:= tmsesqlquery(
      masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
    active:= true;
   end;
   if (fnextindex=masterheader.indextree) then begin
    result:= detail.datalink.dataset.recordcount>0;
    if result then begin
     fnextrow:= masterheader.datalink.dataset.recno;
     fnextindex:= masterheader.indextree;
    end;
    exit;
   end;
   if (detail.datalink.dataset.recordcount>0) then begin
    result:= true;
    fnextrow:= lastrow;
    fnextindex:= masterheader.indextree;
   end else begin
    shouldstop:= false;
    tmptree:= masterheader.indextree;
    if tmptree>=high(masterheader.treeheader) then begin
     updateheader(tmptree,true);
    end;
    findexstr1:= masterheader.treeheader[tmptree].keystr;
    fparentstr1:= masterheader.treeheader[tmptree].parentstr;
    findexint1:= masterheader.treeheader[tmptree].keynum;
    fparentint1:= masterheader.treeheader[tmptree].parentnum;
    //factiveheaderkey1:= footertreekey;
    while not shouldstop do begin
     masterheader.nextrecord;
     if not masterheader.iseof then begin
      with tmsesqlquery(detail.datalink.dataset) do begin
       active:= false;
       params.parambyname(DetailParams).value:= tmsesqlquery(
         masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
       active:= true;
      end;
     end else begin
      result:= false;
      shouldstop:= true;
      //updateheader(tmptree,true);
      tmsesqlquery(detail.datalink.dataset).active:= false;
      break;
     end;
     masterheader.checklevel;
     k:= masterheader.indextree;
     if k>=high(masterheader.treeheader) then begin
      updateheader(k,true);
     end;
     if (k=tmptree) and ((tmptree<>-1) and (tmptree<>0)) then begin
      result:= false;
      shouldstop:= true;
      masterheader.datalink.dataset.recno:= lastrow;
      fnextrow:= -1;
      fnextindex:= -1;
      tmsesqlquery(detail.datalink.dataset).active:= false;
     end else begin
      if k<tmptree then begin
       result:= false;
       shouldstop:= true;
       fnextrow:= -1;
       fnextindex:= -1;
       masterheader.datalink.dataset.recno:= lastrow;
       tmsesqlquery(detail.datalink.dataset).active:= false;
      end else if detail.datalink.dataset.recordcount>0 then begin
       result:= true;
       shouldstop:= true;
       fnextrow:= masterheader.datalink.dataset.recno;
       fnextindex:= masterheader.indextree;
       masterheader.datalink.dataset.recno:= lastrow;
       tmsesqlquery(detail.datalink.dataset).active:= false;
      end;
     end;      
    end;
    if masterheader.indextree<>tmptree then begin
     masterheader.indextree:= tmptree;
     updateheader(masterheader.indextree,true);
     updatefooter;
    end;
    if result then begin
     masterheader.treeheader[tmptree].keystr:= findexstr1;
     masterheader.treeheader[tmptree].parentstr:= fparentstr1;
     masterheader.treeheader[tmptree].keynum:= findexint1;
     masterheader.treeheader[tmptree].parentnum:= fparentint1;
     //masterheader.treeheader[tmptree].activeheaderkey:= factiveheaderkey1;
    end;
   end;
  end;
 end;
 
 function drawtreefooter:boolean;
 begin
  result:= false;
  if items[aindex].footer.count>0 then begin
   if posy<=limity-items[aindex].footer.pixelheight then begin
    items[aindex].footer.paint(canvas,makerect(area.x,posy+area.y,area.cx,items[aindex].footer.pixelheight),true,false);
    inc(posy,items[aindex].footer.pixelheight);
    result:= true;
   end;
  end;
 end;
 
begin
 limity:= area.cy;
 fpreviewing:= true;
 isfinish:= false;
 with items[aindex] do begin
  if (fowner.Report_Footer_RowValues.count>0) then begin
   extheight:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
  end else begin
   extheight:= 0;
  end;
  while not isfinish do begin
   if fmodheader or fneedfooter or (not fneedfooter and detail.iseof) then begin
    {if masterheader.keyfieldlink.asmsestring='514.002' then begin
     debugwriteln(masterheader.keyfieldlink.asmsestring);
    end;
    debugwriteln(masterheader.keyfieldlink.asmsestring);}
    
    int2:= masterheader.indextree;
    masterheader.checklevel;
    int3:= masterheader.indextree;
    if (int3<int2) then begin
     fprintfooter:= (fmodfooter<>-1) or fneedfooter;
    end else if (int3=int2) then begin
     if fneedfooter then begin
      fprintfooter:= true;
     end else begin
      fprintfooter:= false;
     end;
    end else begin
     fprintfooter:= false;
    end;
    if masterheader.iseof then begin
     int1:= 0;
     fprintfooter:= true;
    end else begin
     int1:= masterheader.indextree;
    end;
    if fmodfooter<>-1 then begin
     if not fneedfooter then begin
      if int3>int2 then begin
       int2:= int3;
      end else begin
       int2:= fmodfooter;
      end;
     //end else begin
     // int2:= int3;
     end;
    end;
    if fprintfooter and (int2>=0) and (int1>=0) then begin
     fmodfooter:= drawfooter(int2,int1);
    end;
    if not isfinish and masterheader.iseof then begin
     if fmodmasterfooter then begin
      fmodmasterfooter:= drawtreefooter;
      if not fmodmasterfooter then begin
       isfinish:= true;
      end;
     end;
     if (fmodtreefooter<>-1) and not isfinish then begin
      if treefooter.count>0 then begin
       for j:=fmodtreefooter downto 0 do begin
        with treefooter[j] do begin
         if posy<=limity-tabulators.pixelheight then begin
          //tabulators.yposition:=posy+area.y;
          tabulators.paint(canvas,makerect(area.x,posy+area.y,area.cx,tabulators.pixelheight),true,false);
          inc(posy,tabulators.pixelheight);
          fmodtreefooter:= j;
         end else begin
          isfinish:= true;
         end;
        end;
       end;
      end;
     end;
     if not isfinish then begin
      if TraTreeReport(fowner).indexbuild<self.count-1 then begin
       inc(TraTreeReport(fowner).findexbuild);
       init(TraTreeReport(fowner).indexbuild);
       TraTreeReport(fowner).continuetree:= true;
       isfinish:= true;
      end else begin
       islastpage:= true;
       isfinish:= true;
       TraTreeReport(fowner).continuetree:= false;
      end;
     end;
    end;
    //print header
    if not isfinish then begin
     ishaschildren:= haschildren;
     if masterheader.indextree>fmodfooter then begin
      updateheader(masterheader.indextree,true);
      createfooter(aindex);
     end else begin
      updateheader(fmodfooter,true);
      createfooter(aindex);
     end;
     if not masterheader.iseof then begin
      if masterheader.count>0 then begin
       if posy<=limity-masterheader.pixelheight then begin
        if ((masterheader.printifnochild) or ((not masterheader.printifnochild) and ishaschildren)) then begin
         if (fnextindex=-1) or (fnextrow=-1) or (masterheader.indextree<fnextindex) or ((masterheader.indextree=fnextindex) and (masterheader.datalink.dataset.recno=fnextrow)) then begin
          tmppos:= masterheader[TreeColIndex].position;
          tmpwidth:= masterheader[TreeColIndex].width;
          delta:= masterheader.indextree*TreeGap;
          treepos:= tmppos+delta;
          masterheader[TreeColIndex].fpos:= treepos;
          masterheader[TreeColIndex].fwidth:= tmpwidth-delta;
          factiveheaderkey:= masterheader.keyfieldlink.asvariant;
          masterheader.paint(canvas,makerect(area.x,posy+area.y,area.cx,masterheader.pixelheight),true,false);
          masterheader[TreeColIndex].fpos:= tmppos;
          masterheader[TreeColIndex].fwidth:= tmpwidth;
          inc(posy,masterheader.pixelheight);
          fmodheader:= false;
         end;
        end;
       end else begin
        isfinish:= true;
        TraTreeReport(fowner).continuetree:= false;
        fmodheader:= true;
        result:= posy+area.y;
        break;
       end;
      end;
     end else begin
      isfinish:= true;
      TraTreeReport(fowner).continuetree:= true;
     end;
    end;
   end;
   //print detail
   if not isfinish then begin
    if ishaschildren and (masterheader.datalink.dataset.recordcount>0) then begin
     drawdetail;
    end;
    if detail.iseof then begin
     masterheader.nextrecord;
    end;
   end;
  end;
//akhir
 end;
 if islastpage then begin
  fpreviewing:= false;
 end;
 result:= posy+area.y;
end;

procedure TraTreeContent.adddatasets(var adatasets: datasetarty);
var
 int1,int2: integer;
begin
 if count>0 then begin
  for int1:=0 to count-1 do begin
   if (items[int1].masterheader.count>0) and (items[int1].masterheader.datalink.dataset <> nil) then begin
    adduniqueitem(pointerarty(adatasets),items[int1].masterheader.datalink.dataset);
   end;
   if (items[int1].masterfooter.count>0) and (items[int1].masterfooter.datalink.dataset <> nil) then begin
    adduniqueitem(pointerarty(adatasets),items[int1].masterfooter.datalink.dataset);
   end;
   if (items[int1].footer.count>0) and (items[int1].footer.datalink.dataset <> nil) then begin
    adduniqueitem(pointerarty(adatasets),items[int1].footer.datalink.dataset);
   end;
   if (items[int1].detail.count>0) and (items[int1].detail.datalink.dataset <> nil) then begin
    adduniqueitem(pointerarty(adatasets),items[int1].detail.datalink.dataset);
   end;
   if items[int1].treefooter.count>0 then begin
    for int2:=0 to items[int1].treefooter.count-1 do begin
     if (items[int1].treefooter[int2].tabulators.count>0) and (items[int1].treefooter[int2].tabulators.datalink.dataset <> nil) then begin
      adduniqueitem(pointerarty(adatasets),items[int1].treefooter[int2].tabulators.datalink.dataset);
     end;
    end;
   end;
  end;
 end;
end;

procedure TraTreeContent.init(aindex:integer);
var
 int1: integer;
begin
 if aindex<count then begin
  with items[aindex] do begin
   footerarty:= nil;
   masterheader.init;
   createfooter(aindex);
   if masterheader.datalink.active and detail.datalink.active then begin
    with tmsesqlquery(detail.datalink.dataset) do begin
     params.parambyname(DetailParams).value:= 
      tmsesqlquery(masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
     refresh;
    end;
   end;
   footer.init;
   masterfooter.init;
   detail.init;
   if ftreefooter.count>0 then begin
    for int1:=0 to ftreefooter.count-1 do begin
     ftreefooter[int1].tabulators.init;
    end;
   end;
   fmodmasterfooter:= footer.count>0;
   fmodtreefooter:= treefooter.count-1;
  end;
 end;
 fnextrow:= -1;
 fnextindex:= -1;
 fdatanumber:= 0;
 fmodfooter:= -1;
 fneedfooter:= true;
 ishaschildren:= false;
end;

{ TraTreeReport }

constructor TraTreeReport.create(aowner: tcomponent);
begin
 inherited;
 fcontent:= TraTreeContent.create(self);
 fcontinuetree:= true;
end;

destructor TraTreeReport.destroy;
begin
 fcontent.destroy;
 inherited;
end;

procedure TraTreeReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
var
 int1: integer;
begin
 posy:= 0;
 for int1:=0 to fcontent.count-1 do begin
  fcontent.paint(int1,posy,canvas,contentarea);
 end;
end;

function TraTreeReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
begin
 while findexbuild<fcontent.count do begin
  if not fcontinuetree then begin
   posy:= 0;
  end;
  result:= fcontent.build(findexbuild,posy,acanvas,contentarea,islastpage);
  if not fcontinuetree then begin
   break;
  end;
 end;
end;

procedure TraTreeReport.addcontentdatasets(var adatasets: datasetarty);
begin
 fcontent.adddatasets(adatasets);
end;

procedure TraTreeReport.contentinit;
begin
 findexbuild:= 0;
 fcontent.init(findexbuild);
 fcontinuetree:= true;
 posy:= 0;
end;

procedure TraTreeReport.contentupdatelinks;
var
 int1,int2: integer;
begin
 if fcontent.count>0 then begin
  for int1:=0 to fcontent.count-1 do begin
   fcontent.items[int1].masterheader.updatelinks;
   fcontent.items[int1].masterfooter.updatelinks;
   fcontent.items[int1].detail.updatelinks;
   fcontent.items[int1].footer.updatelinks;
   if fcontent.items[int1].treefooter.count>0 then begin
    for int2:=0 to fcontent.items[int1].treefooter.count-1 do begin
     fcontent.items[int1].treefooter[int2].tabulators.updatelinks;
    end;
   end;
  end;
 end;
end;

procedure TraTreeReport.setcontentpixelperunit(const avalue: real);
var
 int1,int2: integer;
begin
 if fcontent.count>0 then begin
  for int1:=0 to fcontent.count-1 do begin
   fcontent.items[int1].masterheader.setpixelperunit(avalue);
   fcontent.items[int1].masterfooter.setpixelperunit(avalue);
   fcontent.items[int1].detail.setpixelperunit(avalue);
   if fcontent.items[int1].treefooter.count>0 then begin
    for int2:=0 to fcontent.items[int1].treefooter.count-1 do begin
     fcontent.items[int1].treefooter[int2].tabulators.setpixelperunit(avalue);
    end;
   end;
  end;
 end;
end;

function TraTreeReport.treeheadervalue(indexrow: integer; indexcol:integer): variant;
begin
{ if (indexrow>=0) and (indexrow<=fcontent.treeheader.count-1) then begin
  if (indexcol>=0) and (indexcol<=fcontent.treeheader[indexrow].tabulators.count-1) then begin
   result:= fcontent.treeheader[indexrow].tabulators.items[indexcol].value;
  end;
 end;}
end;

function TraTreeReport.treefootervalue(indexrow: integer; indexcol:integer; indextree: integer=0): variant;
begin
 if ((indextree>=0) and (indextree<=(fcontent.count-1))) then begin
  if (indexrow>=0) and (indexrow<=high(fcontent[indextree].footerarty)) then begin
   if (indexcol>=0) and (indexcol<=(fcontent[indextree].footerarty[indexrow].count-1)) then begin
    result:= fcontent[indextree].footerarty[indexrow].items[indexcol].value;
   end;
  end;
 end;
end;

function TraTreeReport.treemainfootervalue(indexrow: integer; indexcol:integer; indextree: integer=0): variant;
begin
 if ((indextree>=0) and (indextree<=(fcontent.count-1))) then begin
  if (indexrow>=0) and (indexrow<=high(fcontent[indextree].treefooter.count)) then begin
   if (indexcol>=0) and (indexcol<=(fcontent[indextree].treefooter[indexrow].tabulators.count-1)) then begin
    result:= fcontent[indextree].treefooter[indexrow].tabulators.items[indexcol].value;
   end;
  end;
 end;
end;

function TraTreeReport.treefootervalue2(indexcol:integer; indextree: integer=0): variant;
begin
 if ((indextree>=0) and (indextree<=(fcontent.count-1))) then begin
  if (indexcol>=0) and (indexcol<=(fcontent[indextree].footer.count-1)) then begin
   result:= fcontent[indextree].footer.items[indexcol].value;
  end;
 end;
end;

function TraTreeReport.treedatavalue(indexcol:integer): variant;
begin
{ if (indexcol>=0) and (indexcol<=fcontent.treedata_data.count-1) then begin
  result:= fcontent.treedata_data.items[indexcol].value;
 end;}
end;

function TraTreeReport.recordnumber: integer;
begin
 result:= fcontent.datanumber;
end;

function TraTreeReport.datanumber: integer;
begin
 result:= fcontent.datanumber;
end;

function TraTreeReport.treenumber: integer;
begin
 if findexbuild>=0 then begin
  result:= fcontent.indextree;
 end else begin
  result:= -1;
 end;
end;

function TraTreeReport.footertreekey: variant;
begin
 if findexbuild>=0 then begin
  result:= fcontent.activefooterkey;
 end;
end;

function TraTreeReport.headertreekey: variant;
begin
 if findexbuild>=0 then begin
  result:= fcontent.activeheaderkey;
 end;
end;

function TraTreeReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;

procedure TraTreeReport.endbuild;
var
 int1,int2: integer;
begin
 for int1:= fcontent.count-1 downto 0 do begin
  with fcontent.items[int1] do begin
   for int2:= length(footerarty)-1 downto 0 do begin
    footerarty[int2].destroy;
    footerarty[int2]:= nil;
   end;
   footerarty:=nil;
  end;
 end;
end;

procedure TraTreeReport.contentgetpickobjects(const sender: tobjectpicker; var objects: integerarty);
var
 int1,int2,int3: integer;
begin
 for int1:=0 to fcontent.count-1 do begin
  if fcontent.items[int1].masterheader.count>0 then begin
   with fcontent.items[int1].masterheader do begin
    if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
     for int2:=0 to count-1 do begin
      int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
      if int3 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 14;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
  if fcontent.items[int1].HeaderDetail.count>0 then begin
   with fcontent.items[int1].HeaderDetail do begin
    if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
     for int2:=0 to count-1 do begin
      int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
      if int3 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 15;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
  if fcontent.items[int1].Detail.count>0 then begin
   with fcontent.items[int1].Detail do begin
    if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
     for int2:=0 to count-1 do begin
      int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
      if int3 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 16;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
  if fcontent.items[int1].masterfooter.count>0 then begin
   with fcontent.items[int1].masterfooter do begin
    if (sender.pickpos.y>=yposition) and (sender.pickpos.y<=yposition+pixelheight) then begin
     for int2:=0 to count-1 do begin
      int3:= abs(sender.pickpos.x - round(items[int2].Position*fpixelperunit));
      if int3 < tabpickthreshold then begin
       setlength(objects,1);
       objects[0]:= int2;
       fpickkind:= 17;
       fpickarrayindex:= int1;
       break;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure TraTreeReport.contentendpickmove(const apos: pointty; const ashiftstate: shiftstatesty;
                       const aoffset: pointty; const aobjects: integerarty);
begin
 case fpickkind of
  14: begin
      with fcontent.items[fpickarrayindex].masterheader do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  15: begin
      with fcontent.items[fpickarrayindex].headerdetail do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  16: begin
      with fcontent.items[fpickarrayindex].detail do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
  17: begin
      with fcontent.items[fpickarrayindex].masterfooter do begin
       items[aobjects[0]].position:= items[aobjects[0]].position+(aoffset.x/fpixelperunit);
       if aobjects[0]>=1 then begin
        items[aobjects[0]-1].width:= items[aobjects[0]-1].width+(aoffset.x/fpixelperunit);
       end;
      end;
     end;
 end;
end;
