unit rptpreview;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msebitmap,mseimage,msedataedits,
 msedatanodes,mseedit,msefiledialog,msegrids,mselistbrowser,msestrings,msesys,
 msetypes,msesimplewidgets,msewidgets, msereport;
type
 trptpreviewfo = class(tmseform)
   imgPreview: timage;
   gridPages: tstringgrid;
   tbutton1: tbutton;
   tbutton2: tbutton;
   fileSaveDialog: tfiledialog;
   zoonValue: trealspinedit;
   procedure doInit(const sender: TObject);
   procedure pageFinished(const sender: tcustomreportpage;
                   const acanvas: tcanvas);
   procedure rptFinished(const sender: TObject);                   
   procedure doFinish(const sender: TObject);
   procedure checkPageScroll(const sender: twidget;
                   var info: mousewheeleventinfoty);
   procedure gridCellEvent(const sender: TObject; var info: celleventinfoty);
   procedure doSavePageImage(const sender: TObject);

   procedure showReport(rpt: TReport);
   
   procedure doZoon(const sender: TObject);
   protected
    bitmapCanvas : tmaskedbitmap;
    imagePages : array of tmaskedbitmap;
    imagePagesCompressed : array of cardinalarty;
    rptImgSize: sizety;
    report : TReport;
    oldonreportfinished : notifyeventty;
    oldonpageafterpaint : reportpagepainteventty;
 end;
var
 rptpreviewfo: trptpreviewfo;
implementation
uses
 rptpreview_mfm, mseformatbmpicoread, mseformatjpgread, mseformatpngread, 
 mseformatpnmread, mseformattgaread, mseformatxpmread, sysutils,strutils, 
 msestream, msegraphicstream, mseformatjpgwrite, mseformatpngwrite;
{$define compressed} 
procedure trptpreviewfo.doInit(const sender: TObject);
begin
	bitmapCanvas := tmaskedbitmap.Create(false);
	oldonreportfinished := nil;
	oldonpageafterpaint := nil;
end;

procedure trptpreviewfo.showReport(rpt: TReport);
begin
	report := rpt;
	rpt.ppmm := 4;
	oldonpageafterpaint := rpt.onpageafterpaint;
	rpt.onpageafterpaint := @pageFinished;
	oldonreportfinished := rpt.onreportfinished;
	rpt.onreportfinished := @rptFinished;
	bitmapCanvas.size := rpt.size;
	rpt.color := cl_white;
	rpt.render(bitmapCanvas.canvas);
end;

procedure trptpreviewfo.pageFinished(const sender: tcustomreportpage;
               const acanvas: tcanvas);
var
	ipagear : cardinalarty;               
	ipagemb : tmaskedbitmap;               
begin
	//writeln('Page finished ' + IntToStr(sender.pagenum));
	if not sender.report.prepass then
	begin
		gridPages.appendrow(IntToStr(sender.pagenum+1));
{$ifdef compressed}
		setLength(imagePagesCompressed, sender.pagenum+1);
		rptImgSize := bitmapCanvas.size;
		ipagear := bitmapCanvas.compressdata;
		imagePagesCompressed[high(imagePagesCompressed)] := ipagear;
{$else}
		setLength(imagePages, sender.pagenum+1);
		ipagemb := tmaskedbitmap.Create(false);
		ipagemb.Assign(bitmapCanvas);
		imagePages[high(imagePages)] := ipagemb;
{$endif}
		if sender.pagenum = 0 then gridPages.row := 0;
	end;
	if oldonpageafterpaint <> nil then oldonpageafterpaint(sender, acanvas);
end;

procedure trptpreviewfo.doFinish(const sender: TObject);
var
	i : integer;
begin
	if report <> nil then report.destroy;
	bitmapCanvas.Destroy;
	for i := 0 to high(imagePages) do
		imagePages[i].Destroy;
end;

procedure trptpreviewfo.gridCellEvent(const sender: TObject;
               var info: celleventinfoty);
var
	i : integer;               
begin
	if (info.eventkind = cek_focusedcellchanged) then
	begin
		if gridPages.row >= 0 then
		begin
			//writeln(gridPages[0][gridPages.row]);
			i := StrToInt(gridPages[0][gridPages.row]);
{$ifdef compressed}
			imgPreview.bitmap.decompressdata(rptImgSize, imagePagesCompressed[i-1]);
			imgPreview.bitmap.change;
{$else}
			imgPreview.bitmap := imagePages[i-1];
{$endif}
			imgPreview.bitmap.alignment := [al_xcentered];
		end;
	end;
end;

procedure trptpreviewfo.rptFinished(const sender: TObject);
begin
	if reo_autorelease in report.options then report := nil;
	if oldonreportfinished <> nil then oldonreportfinished(sender);
end;

procedure trptpreviewfo.doSavePageImage(const sender: TObject);
var
	fn, fmt : string;
	stream: tmsefilestream;
begin
	if gridPages.RowCount = 0 then exit;
	if fileSaveDialog.execute = mr_Ok then
	begin
		fn := fileSaveDialog.controller.filename;
		//writeln(fn);
		stream:= tmsefilestream.create(fn,fm_create);
        if AnsiEndsStr(pnglabel,fn) then fmt := pnglabel
        else fmt := jpglabel;
 		try
            writegraphic(stream, imgPreview.bitmap, fmt, []);
 		finally
  			stream.free;
  		end;
	end;
end;

procedure trptpreviewfo.checkPageScroll(const sender: twidget;
               var info: mousewheeleventinfoty);
begin
	if imgPreview.frame.sbvert.value = 0 then
	begin //user tryies to go beyound begining of page
		if gridPages.Row > 0 then 
		begin		
			gridPages.Row := gridPages.Row-1;
			imgPreview.frame.sbvert.value := 0.999999;
			include(info.eventstate,es_processed);
		end;
	end;
	if imgPreview.frame.sbvert.value = 1 then
	begin //user tryies to go beyound end of page
		if gridPages.Row < gridPages.RowCount-1 then 
		begin
			gridPages.Row := gridPages.Row+1;
			imgPreview.frame.sbvert.value := 0.000001;
			include(info.eventstate,es_processed);
		end;
	end;
end;

procedure trptpreviewfo.doZoon(const sender: TObject);
begin
	//imgPreview.scale(zoonValue.value);
end;

end.
