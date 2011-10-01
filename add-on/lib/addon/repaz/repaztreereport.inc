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
 setlength(ftreeheader,1);
  if fparentfieldlink.active and fkeyfieldlink.active and
   (fparentfieldlink.fieldname<>'') and (fkeyfieldlink.fieldname<>'') then begin
  if fparentfieldlink.ismsestring then begin
   ftreeheader[0].parentstr:= fparentfieldlink.asmsestring;
   ftreeheader[0].keystr:= fkeyfieldlink.asmsestring;
  end else begin
   ftreeheader[0].parentnum:= fparentfieldlink.aslargeint;
   ftreeheader[0].keynum:= fkeyfieldlink.aslargeint;
  end;
 end;
 ftreeheader[0].indextree:= 0;
 findextree:= 0;
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
 if fparentfieldlink.active and (fparentfieldlink.field<>nil) then begin
  if iseof then begin
   findextree:= 0;
   setlength(ftreeheader,0);
   exit;
  end;
  found:= false;
  for int1:=0 to length(ftreeheader)-1 do begin
   if fparentfieldlink.isstringfield then begin
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
 fisfinishdata:= true;
 fpreviewing:= false;
 fmodfooter:= -1;
 isdrawheader:= true;
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
    for int2:=masterheader.indextree downto 0 do begin
     if posy<=area.cy-int3-footerarty[int2].pixelheight then begin
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
emptyfooter:
  for int1:=length(footerarty)-1 downto 0 do begin
   footerarty[int1].free;
  end;
  footerarty:=nil;
 end;
end;

procedure TraTreeContent.createfooter(const aindex:integer);
var
 int1: integer;
begin
 with items[aindex] do begin
   if length(footerarty)<masterheader.indextree+1 then begin
   setlength(ffooterarty,masterheader.indextree+1);
   footerarty[masterheader.indextree]:= TSummaryTabs.create(fowner);
   footerarty[masterheader.indextree].count:= masterfooter.count;
   for int1:=0 to masterfooter.count-1 do begin
    footerarty[masterheader.indextree][int1].assign(masterfooter[int1]);
   end;
   if TreeColIndex<footerarty[masterheader.indextree].count then begin
    footerarty[masterheader.indextree][TreeColIndex].fpos:= masterfooter[TreeColIndex].position+(masterheader.indextree*TreeGap);
    footerarty[masterheader.indextree][TreeColIndex].fwidth:= masterfooter[TreeColIndex].width-(masterheader.indextree*TreeGap);
   end;
   footerarty[masterheader.indextree].datasource:= masterfooter.datasource;
   footerarty[masterheader.indextree].height:= masterfooter.height;
   //footerarty[masterheader.indextree].PixelPerUnit:= masterfooter.PixelPerUnit;
   footerarty[masterheader.indextree].backcolor:= masterfooter.backcolor;
   footerarty[masterheader.indextree].RAW_EmptyLinesBelow:= masterfooter.RAW_EmptyLinesBelow;
  end;
  setlength(masterheader.ftreeheader,masterheader.indextree+1);
  if masterheader.parentfieldlink.active and masterheader.parentfieldlink.active then begin
   if masterheader.parentfieldlink.isstringfield then begin
    masterheader.treeheader[masterheader.indextree].parentstr:= masterheader.parentfieldlink.asmsestring;
    masterheader.treeheader[masterheader.indextree].keystr:= masterheader.keyfieldlink.asmsestring;
   end else begin
    masterheader.treeheader[masterheader.indextree].parentnum:= masterheader.parentfieldlink.aslargeint;
    masterheader.treeheader[masterheader.indextree].keynum:= masterheader.keyfieldlink.aslargeint;
   end;
  end;
  masterheader.treeheader[masterheader.indextree].indextree:= masterheader.indextree;
 end;
end;

function TraTreeContent.build(const aindex:integer; var posy: integer;
  const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
var
 int2,extheight,limity,hband,lastfound: integer;
 isfinish,ishaschildren: boolean;
 tmpwidth,tmppos: real;

 function islastrecord:boolean;
 begin
  result:= ((items[aindex].detail.datalink.datasource.dataset.recordcount-
   items[aindex].detail.datalink.datasource.dataset.recno)=0) and
   ((items[aindex].masterheader.datalink.datasource.dataset.recordcount-
   items[aindex].masterheader.datalink.datasource.dataset.recno)=0) and
   (aindex=self.count-1);
 end;

 procedure updateheader;
 begin
  with items[aindex] do begin
   setlength(masterheader.ftreeheader,length(footerarty));
   if masterheader.parentfieldlink.isstringfield then begin
    masterheader.treeheader[masterheader.indextree].parentstr:= masterheader.parentfieldlink.asmsestring;
    masterheader.treeheader[masterheader.indextree].keystr:= masterheader.keyfieldlink.asmsestring;
   end else begin
    masterheader.treeheader[masterheader.indextree].parentnum:= masterheader.parentfieldlink.aslargeint;
    masterheader.treeheader[masterheader.indextree].keynum:= masterheader.keyfieldlink.aslargeint;
   end;
   masterheader.treeheader[masterheader.indextree].indextree:= masterheader.indextree;
  end;
 end;
 
 function drawfooter(astart:integer):integer;
 var
  int3,int4,lowerfoot: integer;
 begin
  with items[aindex] do begin
   result:= -1;
   if masterheader.iseof then begin
    lowerfoot:= 0;
   end else begin
    lowerfoot:= masterheader.indextree;
   end;
   if footer.count>0 then begin
    int4:= footer.pixelheight;
   end else begin
    int4:= 0;
   end;
   if masterfooter.count>0 then begin
    for int3:=astart downto lowerfoot do begin
     if posy<=limity-int4-footerarty[int3].pixelheight then begin
      factivefooterkey:= masterheader.treeheader[int3].keystr;
      footerarty[int3].paint(canvas,makerect(area.x,posy+area.y,area.cx,footerarty[int3].pixelheight),true,false);
      inc(posy,footerarty[int3].pixelheight);
      footerarty[int3].resetsums(false);
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
   while length(footerarty)>masterheader.indextree+1 do begin
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
    if fisfinishdata then begin
     fisfinishdata:= false;
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
       detail.paint(canvas,makerect(area.x,posy+area.y,area.cx,detail.pixelheight),true,false);
       inc(posy,detail.pixelheight);
      end;
      items[aindex].footer.dobeforenextrecord(detail.datalink.datasource);
      for int3:=0 to masterheader.indextree do begin
       footerarty[int3].dobeforenextrecord(detail.datalink.datasource);
      end;
      //process counting for report footer
      if (fowner.report_footer_rowvalues.count>0) then begin
       for int3:=0 to fowner.report_footer_rowvalues.count-1 do begin
        if fowner.report_footer_rowvalues.items[int3].tabulators.datalink.datasource<>nil then begin
         fowner.report_footer_rowvalues.items[int3].tabulators.dobeforenextrecord(detail.datalink.datasource);
        end;
       end;
      end;
      detail.nextrecord;
      inc(fdatanumber);
     end else begin
      isfinish2:= true;
      isfinish:= true;
      TraTreeReport(fowner).continuetree:= false;
     end;
     if detail.iseof then begin
      fisfinishdata:= true;
      isfinish2:= true;
     end;
    end;
    detail[TreeColIndex].fpos:= tmppos;
    detail[TreeColIndex].fwidth:= tmpwidth;
   end else begin
    fisfinishdata:= true;
   end;
  end;
 end;
 
 function haschildren: boolean;
 var
  lastrow,itree,tmptree: integer;
  shouldstop: boolean;
  fparent1,lastparent: variant;
 begin
  with items[aindex] do begin
   lastrow:= masterheader.datalink.dataset.recno;
   if lastfound>lastrow then begin
    result:= true;
    exit;
   end;
   with tmsesqlquery(detail.datalink.dataset) do begin
    active:= false;
    params.parambyname(DetailParams).value:= tmsesqlquery(
      masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
    active:= true;
   end;
   if (detail.datalink.dataset.recordcount>0) then begin
    result:= true;
    lastfound:= lastrow;
   end else begin
    shouldstop:= false;
    tmptree:= masterheader.indextree;
    while not shouldstop do begin
     masterheader.nextrecord;       
     if not masterheader.iseof then begin
      with tmsesqlquery(detail.datalink.dataset) do begin
       active:= false;
       params.parambyname(DetailParams).value:= tmsesqlquery(
         masterheader.datalink.dataset).fieldbyname(KeyFieldHeader).value;
       active:= true;
      end;
      itree:= masterheader.indextree;
      masterheader.checklevel;
      if itree>=masterheader.indextree then begin
       result:= false;
       lastfound:= masterheader.datalink.dataset.recno;
       shouldstop:= true;
       fisfinishdata:= true;
       masterheader.datalink.dataset.recno:= lastrow;
       tmsesqlquery(detail.datalink.dataset).active:= false;
      end else begin
       with tmsesqlquery(detail.datalink.dataset) do begin
        if recordcount>0 then begin
         result:= true;
         lastfound:= masterheader.datalink.dataset.recno;
         shouldstop:= true;
         fisfinishdata:= true;
         masterheader.datalink.dataset.recno:= lastrow;
         active:= false;
        end;
       end;
      end;
     end else begin
      result:= false;
      shouldstop:= true;
     end;
    end;
    masterheader.indextree:= tmptree;
   end;
  end;
 end;
 
 procedure drawtreefooter;
 begin
  if items[aindex].footer.count>0 then begin
   if posy<=limity-items[aindex].footer.pixelheight then begin
    items[aindex].footer.paint(canvas,makerect(area.x,posy+area.y,area.cx,items[aindex].footer.pixelheight),true,false);
    inc(posy,items[aindex].footer.pixelheight);
   end;
  end;
 end;
 
begin
 limity:= area.cy;
 fpreviewing:= true;
 isfinish:= false;
 lastfound:= -1;
 with items[aindex] do begin
  if not masterheader.datalink.active then begin
   TraTreeReport(fowner).continuetree:= false;
   islastpage:= true;
   exit;
  end;
  if (fowner.Report_Footer_RowValues.count>0) then begin
   extheight:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
  end else begin
   extheight:= 0;
  end;
  if masterheader.iseof then begin
   result:= 0;
   //draw footer
   fmodfooter:= drawfooter(masterheader.indextree);
   if fmodfooter=-1 then begin
    updatefooter;
    updateheader;
   end;
   if TraTreeReport(fowner).indexbuild<self.count-1 then begin
    drawtreefooter;
    inc(TraTreeReport(fowner).findexbuild);
    init(TraTreeReport(fowner).indexbuild);
    TraTreeReport(fowner).continuetree:= true;
   end else begin
    drawtreefooter;
    islastpage:= true;
    TraTreeReport(fowner).continuetree:= false;
   end;
   exit;
  end;
  while not isfinish do begin
   if fisfinishdata then begin
    if fmodfooter>=0 then begin
     drawfooter(fmodfooter);
     updatefooter;
     updateheader;
    end;
    if masterheader.count>0 then begin
     if posy<=limity-masterheader.pixelheight then begin
      ishaschildren:= haschildren;
      if isdrawheader and ((masterheader.printifnochild) or ((not masterheader.printifnochild) and ishaschildren)) then begin
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
       if detail.datalink.active then begin
        if ishaschildren then begin
         drawdetail;
        end;
       end;
      end;
      isdrawheader:= true;
      if fisfinishdata and (not isfinish) then begin
       if not masterheader.iseof then masterheader.nextrecord;
       if not masterheader.iseof then begin
        int2:= masterheader.indextree;
        masterheader.checklevel;
        if int2<masterheader.indextree then begin
         createfooter(aindex);
        end else begin
         //draw footer
         if ishaschildren then begin
          fmodfooter:= drawfooter(int2);
         end;
         if fmodfooter=-1 then begin
          updatefooter;
          updateheader;
         end;
        end;
       end else begin
        //draw footer
        fmodfooter:= drawfooter(masterheader.indextree-1);
        if fmodfooter=-1 then begin
         updatefooter;
         updateheader;
        end;
        isfinish:= true;
        if TraTreeReport(fowner).indexbuild<self.count-1 then begin
         drawtreefooter;
         inc(TraTreeReport(fowner).findexbuild);
         init(TraTreeReport(fowner).indexbuild);
         TraTreeReport(fowner).continuetree:= true;
        end else begin
         drawtreefooter;
         islastpage:= true;
         TraTreeReport(fowner).continuetree:= false;
        end;
       end;
      end;
     end else begin
      isfinish:= true;
      TraTreeReport(fowner).continuetree:= false;
     end;
    end else begin
     drawtreefooter;
     inc(TraTreeReport(fowner).findexbuild);
     isfinish:= true;
     islastpage:= true;
    end;
   end else begin
    if not detail.datalink.active then begin
     isfinish:= true;
    end else begin
     drawdetail;
     isdrawheader:= true;
     if not fisfinishdata then begin
      TraTreeReport(fowner).continuetree:= false;
      isfinish:= true;
     end else begin
      if masterheader.iseof then begin
       isfinish:= true;
       if TraTreeReport(fowner).indexbuild<self.count-1 then begin
        drawtreefooter;
        inc(TraTreeReport(fowner).findexbuild);
        init(TraTreeReport(fowner).indexbuild);
        TraTreeReport(fowner).continuetree:= true;
       end else begin
        drawtreefooter;
        islastpage:= true;
        TraTreeReport(fowner).continuetree:= false;
       end;
      end else begin
       isdrawheader:= false;
      end;
     end;
    end;    
   end;
  end;
  if islastpage then begin
   fpreviewing:= false;
  end;
 end;
 result:= posy+area.y;
end;

procedure TraTreeContent.adddatasets(var adatasets: datasetarty);
var
 int1: integer;
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
  end;
 end;
end;

procedure TraTreeContent.init(aindex:integer);
begin
 if aindex<count then begin
  with items[aindex] do begin
   footerarty:= nil;
   masterheader.init;
   footerarty:= nil;
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
  end;
 end;
 fdatanumber:= 0;
 fmodfooter:= -1;
 fisfinishdata:= true;
 isdrawheader:= true;
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
 int1: integer;
begin
 if fcontent.count>0 then begin
  for int1:=0 to fcontent.count-1 do begin
   fcontent.items[int1].masterheader.updatelinks;
   fcontent.items[int1].masterfooter.updatelinks;
   fcontent.items[int1].detail.updatelinks;
   fcontent.items[int1].footer.updatelinks;
  end;
 end;
end;

procedure TraTreeReport.setcontentpixelperunit(const avalue: real);
var
 int1: integer;
begin
 if fcontent.count>0 then begin
  for int1:=0 to fcontent.count-1 do begin
   fcontent.items[int1].masterheader.setpixelperunit(avalue);
   fcontent.items[int1].masterfooter.setpixelperunit(avalue);
   fcontent.items[int1].detail.setpixelperunit(avalue);
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
  result:= fcontent[findexbuild].masterheader.indextree;
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
