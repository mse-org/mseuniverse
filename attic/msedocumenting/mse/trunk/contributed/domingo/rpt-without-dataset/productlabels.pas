unit productlabels;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msereport,db,mserichstring,
 msesplitter,msestrings,mseimage,msesimplewidgets,msewidgets,msedataedits,
 mseedit,msepostscriptprinter,mseprinter,msetypes;

type
 tproductlabelsre = class(treport)
   treportpage1: treportpage;
   tileLabels: ttilearea;
   trecordband1: trecordband;
   imageBarCode: timage;
   labelDescription: tlabel;
   psprn: tpostscriptprinter;
   procedure feedData(const sender: tcustomrecordband; var empty: Boolean);
   procedure doInitVars(const sender: tcustomreport);
   procedure setLabelData(pages, pid, bcType : integer; desc : string);
   procedure checkPageCounter(const sender: tcustomreportpage;
                   var empty: Boolean);
   procedure reportLoaded(const sender: TObject);
   protected
    pagesToPrint, productId, barcodeType : integer;
    description : string;
    stopPrinting : boolean;
 end;
var
 productlabelsre: tproductlabelsre;
implementation
uses
 productlabels_mfm, sysutils, ubarcode;
 
procedure tproductlabelsre.setLabelData(pages, pid, bcType : integer; desc : string);
begin
	pagesToPrint := pages;
	productId := pid;
	description := desc;
	barcodeType := bcType
end;

procedure tproductlabelsre.feedData(const sender: tcustomrecordband;
               var empty: Boolean);
begin
	if stopPrinting then exit;
    empty := false;
end;

procedure tproductlabelsre.doInitVars(const sender: tcustomreport);
var 
    b : TasBarcode;               
begin
    //writeln('doRenderRecord');
    labelDescription.caption := description;

    b := TasBarcode.Create(Self);
    b.Text := IntToStr(productId);

    b.Typ := TBarcodeType(barcodeType); //bcCode128B;
  
    //bcoNone, bcoCode, bcoTyp, bcoBoth
    b.showtext := bcoBoth;
  
    //    stpTopLeft,     stpTopRight,     stpTopCenter,     stpBottomLeft,    stpBottomRight,    stpBottomCenter
    b.ShowTextPosition := stpTopCenter;
  
    imageBarCode.bitmap.size := imageBarCode.size;
    imageBarCode.bitmap.init(cl_white);
    b.Height := imageBarCode.size.cy;
    b.Width := imageBarCode.size.cx;
    b.Left := round(((imageBarCode.size.cx - 4)/2) - (b.width/2));
    b.Checksum := true;  
    
    b.DrawBarcode(imageBarCode.bitmap.canvas);
  
    b.free;    
    stopPrinting := False;       
end;

procedure tproductlabelsre.checkPageCounter(const sender: tcustomreportpage;
               var empty: Boolean);
begin
	if pagenum > pagesToPrint-1 then 
	begin
		stopPrinting := True;
		exit;
	end;
	empty := false;
end;

procedure tproductlabelsre.reportLoaded(const sender: TObject);
begin
	render(
		//{$ifdef mswindows}
		//gdiprn
		//{$else}
		psprn
		//{$endif}
		{,ttextstream.create('test.ps',fm_create)});
end;

end.
