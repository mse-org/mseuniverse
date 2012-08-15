{ Implementation of repazLabelreporth.inc }

{ TraLabelPaper }

constructor TraLabelPaper.create(const aowner: TraReportTemplate);
begin
 inherited;
end;

destructor TraLabelPaper.destroy;
begin
 inherited;
end;

{ TraLabelContent }

constructor TraLabelContent.create(const aowner: TraReportTemplate);
begin
 inherited create;
 fdatanumber:= -1;
 fowner:= aowner;
 fcols:= 2;
 frows:= 1;
 fmarginx:= 0;
 fmarginy:= 0;
 fdata:= TraLabelPaper.create(fowner);
end;

destructor TraLabelContent.destroy;
begin
 inherited;
 freeandnil(fdata);
end;

procedure TraLabelContent.paint(const canvas: tcanvas;const area:rectty);
var
 posy,int1,int2,int3,x,y: integer;
begin
 if (fdata.count>0) then begin
  y:= area.y;
  for int2:= 1 to frows do begin
   x:= area.x;
   for int3:= 1 to fcols do begin
    posy:= y;
    for int1:=0 to fdata.count-1 do begin
     with fdata.items[int1] do begin
      tabulators.paint(canvas,
       makerect(x,posy,round(fdata.paperwidth*fowner.pixelperunit),tabulators.pixelheight),
       false,false);
      inc(posy,tabulators.pixelheight);
     end;
    end;
    x:= x+round((fdata.paperwidth+fmarginx)*fowner.pixelperunit);
   end;
   y:= y+ round((fdata.paperheight+fmarginy)*fowner.pixelperunit);
  end;
 end;
end;

function TraLabelContent.build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
var
 posy,int1,int2,int3,x,y,extheight1,limity: integer;
 bo1: boolean;
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

begin
 posy:= 0;
 limity:= area.cy;
 if (fowner.Report_Footer_RowValues.count>0) then begin
  extheight1:= round(fowner.Report_Footer_Height*fowner.pixelperunit);
 end else begin
  extheight1:= 0;
 end; 
 fdatanumber:= 0;
 if fdata.count>0 then begin
  bo1:= false;
  while not bo1 do begin
   if fowner.Report_Footer_Show=frs_EveryPage then begin
    limity:= area.cy-extheight1;
   end else if fowner.Report_Footer_Show=frs_LastPageOnly then begin
    if islastrecord then begin
     limity:= area.cy-extheight1;
    end;
   end;
   y:= area.y;
   for int2:= 1 to frows do begin
    x:= area.x;
    if (round(fdata.paperheight*fowner.pixelperunit)+posy<=limity) then begin
     for int3:= 1 to fcols do begin
      posy:= y;
      for int1:=0 to fdata.count-1 do begin
       with fdata.items[int1] do begin
        if tabulators.iseof then begin
         bo1:= true;
         islastpage:= true;
         result:= posy+area.y;
         exit;
        end else begin
         tabulators.paint(canvas,
          makerect(x,posy,round(fdata.paperwidth*fowner.pixelperunit),tabulators.pixelheight),
          true,false);
         inc(posy,tabulators.pixelheight);
        end;
       end;
       if (int1=fdata.count-1) then begin
        fdata.items[0].tabulators.nextrecord;
       end;
      end;
      x:= x+round((fdata.paperwidth+fmarginx)*fowner.pixelperunit);
     end;
     y:= y+ round((fdata.paperheight+fmarginy)*fowner.pixelperunit);
    end else begin
     bo1:= true;
     islastpage:= false;
     result:= posy+area.y;
     exit;
    end;
   end;
   if fdata.items[0].tabulators.iseof then begin
    bo1:= true;
    islastpage:= true;
    result:= posy+area.y;
   end;
  end;
 end else begin
  islastpage:= true;
  result:= posy+area.y;
 end;
end;

procedure TraLabelContent.adddatasets(var adatasets: datasetarty);
var
 int1: integer;
begin
 for int1:=0 to fdata.count-1 do begin
  with fdata.items[int1] do begin
   if (tabulators.count>0) and (tabulators.datalink.dataset <> nil) then begin
     adduniqueitem(pointerarty(adatasets),tabulators.datalink.dataset);
   end;
  end;
 end;
end;

procedure TraLabelContent.init;
var
 int1: integer;
begin
 for int1:=0 to fdata.count-1 do begin
  fdata.items[int1].tabulators.recordarea:= ra_AllRecord;
  fdata.items[int1].tabulators.init;
 end;
end;

procedure TraLabelContent.updatelinks;
var
 int1: integer;
begin
 for int1:=0 to fdata.count-1 do begin
  fdata.items[int1].tabulators.updatelinks;
 end;
end;

{ TraLabelReport }

constructor TraLabelReport.create(aowner: tcomponent);
begin
 inherited;
 fcontent:= TraLabelContent.create(self);
end;

destructor TraLabelReport.destroy;
begin
 inherited;
 freeandnil(fcontent);
end;

procedure TraLabelReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
begin
 if fcontent<>nil then begin
  fcontent.paint(canvas,contentarea);
 end;
end;

function TraLabelReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
begin
 result:= fcontent.build(acanvas,contentarea,islastpage);
end;

procedure TraLabelReport.addcontentdatasets(var adatasets: datasetarty);
begin
 fcontent.adddatasets(adatasets);
end;

procedure TraLabelReport.contentinit;
begin
 fcontent.init;
end;

procedure TraLabelReport.contentupdatelinks;
begin
 fcontent.updatelinks;
end;

procedure TraLabelReport.setcontentpixelperunit(const avalue: real);
begin
 fcontent.Labels.setpixelperunit(avalue);
 fcontent.verticalmargin:= (fcontent.verticalmargin*fpixelperunit)/avalue;
 fcontent.horizontalmargin:= (fcontent.horizontalmargin*fpixelperunit)/avalue;
end;

function TraLabelReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;
