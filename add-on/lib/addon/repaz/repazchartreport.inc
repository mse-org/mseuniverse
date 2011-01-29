{ Implementation of repazChartreporth.inc }


{ TraChartContent }

constructor TraChartContent.create(const aowner: tcomponent);
begin
 inherited;
end;

destructor TraChartContent.destroy;
begin
 inherited;
end;

procedure TraChartContent.setdatasource(const avalue: string);
var
 xx: TComponentState;
begin
 if (fdatasource<>avalue) or (fchartdatasource=nil) then begin
  fdatasource:= avalue;
  xx:= TraChartReport(fowner).reportpage.componentstate;
  if xx*[{csloading,}csreading] = [] then begin
   if avalue='' then begin
    fchartdatasource:= nil;
   end else begin
    setchartdatasource(TraChartReport(fowner).reportpage.report.getdatasourcereport(avalue));
   end;
  end;
 end;
end;

function TraChartContent.build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
var
 int1,int2: integer;
 tmpchart: TraCustomChart;
begin
 rebuildchart;
 tmpchart:= TraCustomChart.create(nil);
 tmpchart.ChartType:= fcharttype;
 tmpchart.Shadow_Depth:= fdepth;
 tmpchart.Shadow_Color:= fshadowcolor;
 tmpchart.ShowValue:= fshowvalue;
 tmpchart.ShowPercentValue:= fshowpercentvalue;
 tmpchart.legend_show:= fshowlegend;
 tmpchart.Legend_Position:= flegendpos;
 tmpchart.Legend_Size:= flegendsize;
 tmpchart.Legend_BackColor:= flegendbackcolor;
 tmpchart.Legend_LineColor:= flegendlinecolor;
 tmpchart.ValuePosition:= fvaluepos;
 tmpchart.X_AxisCaption:= fxaxiscaption;
 tmpchart.Y_AxisCaption:= fyaxiscaption;
 tmpchart.X_AxisLabel.assign(fxaxis);
 tmpchart.Y_AxisLabel.assign(fyaxis);
 tmpchart.AxisCaption.assign(faxiscaption);
 tmpchart.ChartCaption:= fchartcaption;
 tmpchart.ChartCaptionStyle.assign(fcaptionstyle);
 tmpchart.X_Value.assign(fchartx);
 tmpchart.X_LabelAsValue:= fxasvalue;
 tmpchart.X_Value.setitemcount(length(fchartx.chartitems));
 for int1:=0 to length(fchartx.chartitems)-1 do begin
  tmpchart.X_Value.chartitems[int1].assign(fchartx.chartitems[int1]);
 end;
 tmpchart.Y_Values.count:= fcharty.count;
 for int1:=0 to fcharty.count-1 do begin
  tmpchart.Y_Values[int1].values.assign(fcharty[int1].values);
  tmpchart.Y_Values[int1].values.setitemcount(length(fcharty[int1].values.chartitems));
  for int2:=0 to length(fcharty[int1].values.chartitems)-1 do begin
   tmpchart.Y_Values[int1].values.chartitems[int2].assign(fcharty[int1].values.chartitems[int2]);
  end;
 end;
 TraReportTemplate(fowner).reportpage.report.addcharttoreport(area,tmpchart);
 result:= 0;
end;

procedure TraChartContent.adddatasets(var adatasets: datasetarty);
var
 xx: TComponentState;
begin
 xx:= TraChartReport(fowner).reportpage.componentstate;
 if xx*[{csloading,}csreading] = [] then begin
  if fchartdatasource.dataset<>nil then begin
   adduniqueitem(pointerarty(adatasets),fchartdatasource.dataset);
  end;
 end;
end;

procedure TraChartContent.init;
begin
 if fchartdatasource.dataset<>nil then begin
   fchartdatasource.dataset.first;
 end;
end;

procedure TraChartContent.updatelinks;
begin
 setdatasource(fdatasource);
end;

procedure TraChartContent.getchartwithoutdb(var achart: TraCustomChart);
begin

end;

{ TraChartReport }

constructor TraChartReport.create(aowner: tcomponent);
begin
 inherited;
 fcontent:= TraChartContent.create(self);
end;

destructor TraChartReport.destroy;
begin
 freeandnil(fcontent);
 inherited;
end;

procedure TraChartReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
begin
 if fcontent<>nil then begin
  fcontent.rebuildchart;
  fcontent.paintchart(canvas,contentarea);
 end;
end;

function TraChartReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
begin
 if (freportfooter.count>0) then begin
  with contentarea do begin
   fcontent.build(acanvas,makerect(x,y,cx,cy-round(freportfooterheight*fpixelperunit)),islastpage);
  end;
  result:= contentarea.y + contentarea.cy - round(freportfooterheight*fpixelperunit);
 end else begin
  fcontent.build(acanvas,contentarea,islastpage);
  result:= contentarea.y + contentarea.cy;
 end;
 islastpage:= true;
end;

procedure TraChartReport.addcontentdatasets(var adatasets: datasetarty);
begin
 fcontent.adddatasets(adatasets);
end;

procedure TraChartReport.contentinit;
begin
 fcontent.init;
end;

procedure TraChartReport.contentupdatelinks;
begin
 fcontent.updatelinks;
end;

procedure TraChartReport.setcontentpixelperunit(const avalue: real);
begin
 //
end;

function TraChartReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;
