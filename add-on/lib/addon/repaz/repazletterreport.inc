{ Implementation of repazletterreporth.inc }

{ TraLetterContent }

constructor TraLetterContent.create(const aowner: TraReportTemplate);
begin
 inherited create;
 fdatanumber:= -1;
 fowner:= aowner;
 fdata:= TNormalTabsCol.create(fowner);
end;

destructor TraLetterContent.destroy;
begin
 inherited;
 freeandnil(fdata);
end;

procedure TraLetterContent.paint(const canvas: tcanvas;const area:rectty);
var
 posy,hband,int1: integer;
begin
 if (fdata.count>0) then begin
  posy:= area.y;
  hband:= 0;
  for int1:=0 to fdata.count-1 do begin
   with fdata.items[int1] do begin
    inc(hband,tabulators.pixelheight);
    if (hband<=round(fheight*fowner.pixelperunit)) then begin
     tabulators.paint(canvas,makerect(0,posy,area.cx,tabulators.pixelheight),false,false);
    end else begin
     break;
    end;
    inc(posy,tabulators.pixelheight);
   end;
  end;
 end;
end;

function TraLetterContent.build(const canvas: tcanvas;const area:rectty;var islastpage: boolean):integer;
var
 posy,int1,hband: integer;
begin
 posy:= 0;
 for int1:=0 to fdata.count-1 do begin
  with fdata.items[int1] do begin
   inc(hband,tabulators.pixelheight);
   if hband<=round(fheight*fowner.pixelperunit) then begin
    tabulators.init;
    tabulators.paint(canvas,makerect(area.x,
    area.y+posy,area.cx,tabulators.pixelheight),true,false);
   end else begin
    break;
   end;
   inc(posy,tabulators.pixelheight);
  end;
 end;
 islastpage:= true;
 result:= posy+area.y;
end;

procedure TraLetterContent.adddatasets(var adatasets: datasetarty);
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

procedure TraLetterContent.init;
var
 int1: integer;
begin
 for int1:=0 to fdata.count-1 do begin
  fdata.items[int1].tabulators.init;
 end;
end;

procedure TraLetterContent.updatelinks;
var
 int1: integer;
begin
 for int1:=0 to fdata.count-1 do begin
  fdata.items[int1].tabulators.updatelinks;
 end;
end;

{ TraLetterReport }

constructor TraLetterReport.create(aowner: tcomponent);
begin
 inherited;
 fcontent:= TraLetterContent.create(self);
end;

destructor TraLetterReport.destroy;
begin
 inherited;
 freeandnil(fcontent);
end;

procedure TraLetterReport.drawcontent(const canvas: tcanvas;const contentarea:rectty);
begin
 if fcontent<>nil then begin
  fcontent.paint(canvas,contentarea);
 end;
end;

function TraLetterReport.buildcontent(const acanvas: tcanvas;const contentarea:rectty;var islastpage: boolean):integer;
begin
 result:= fcontent.build(acanvas,contentarea,islastpage);
end;

procedure TraLetterReport.addcontentdatasets(var adatasets: datasetarty);
begin
 fcontent.adddatasets(adatasets);
end;

procedure TraLetterReport.contentinit;
begin
 fcontent.init;
end;

procedure TraLetterReport.contentupdatelinks;
begin
 fcontent.updatelinks;
end;

procedure TraLetterReport.setcontentpixelperunit(const avalue: real);
begin
 fcontent.lettercontent.setpixelperunit(avalue);
 fcontent.heightcontent:= (fcontent.heightcontent*fpixelperunit)/avalue;
end;

function TraLetterReport.getauthor:msestring;
begin
 result:= 'Sri Wahono (Aztechsoft Int.)';
end;

function TraLetterReport.lettervalue(indexrow: integer; indexcol:integer): variant;
begin
 if (indexrow>=0) and (indexrow<=fcontent.LetterContent.count-1) then begin
  if (indexcol>=0) and (indexcol<=(fcontent.LetterContent[indexrow].tabulators.count-1)) then begin
   result:= fcontent.LetterContent[indexrow].tabulators.items[indexcol].value;
  end;
 end;
end;
