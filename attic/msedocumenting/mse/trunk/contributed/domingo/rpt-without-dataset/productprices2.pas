unit productprices2;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msereport,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msegdiprint,mseprinter,msestrings,msetypes,
 msepostscriptprinter,sysutils, msesplitter,mseimage,db,mserichstring;

type
 tproductprices2re = class(treport)
   treportpage1: treportpage;
   tlabel2: tlabel;
   psprn: tpostscriptprinter;
   tbandarea1: tbandarea;
   tgroupbox2: tgroupbox;
   treppagenumdisp1: treppagenumdisp;
   trepprintdatedisp1: trepprintdatedisp;
   tlabel1: tlabel;
   tlabel3: tlabel;
   timage2: timage;
   timage1: timage;
   treppagenumdisp2: treppagenumdisp;
   bandHeader: trecordband;
   gdiprn: tgdiprinter;
   bandRecGroup: tbandgroup;
   bandGroupTitle: trecordband;
   bandProduct: trecordband;
   procedure reportLoaded(const sender: TObject);
   procedure doInit(const sender: TObject);
   procedure feedData(const sender: tcustomrecordband; var empty: Boolean);
   procedure updateCounter(const sender: tcustomrecordband);
   procedure setRecordsPtr(ptr : pointer);
   procedure resetCounter(const sender: tcustomreport);
   procedure doFinish(const sender: TObject);
   procedure weveDone(const sender: TObject);
   protected
    recordsPtr : pointer;
    recNo : integer;
    gProductGroup, gProduct  : string;
 end;
var
 productprices2re: tproductprices2re;
implementation
uses
 productprices2_mfm,msestream,msesys, datagrid, mseformatstr, msedrawtext;
 
procedure tproductprices2re.reportLoaded(const sender: TObject);
begin
	render(
		//{$ifdef mswindows}
		//gdiprn
		//{$else}
		psprn
		//{$endif}
		,ttextstream.create('test.ps',fm_create));
end;

procedure tproductprices2re.doInit(const sender: TObject);
begin
	recordsPtr := nil;
end;

procedure tproductprices2re.setRecordsPtr(ptr : pointer);
begin
	recordsPtr := ptr;
end;

procedure tproductprices2re.feedData(const sender: tcustomrecordband;
               var empty: Boolean);
var
	records : tpricesrecartyPtr; 
	rec : tpricesrec; 
begin
	if recordsPtr = nil then exit;
	records := tpricesrecartyPtr(recordsPtr);
	if recNo >= length(records^) then exit;
	rec := records^[recNo];

	if gProductGroup <> rec.group then
	begin
		gProductGroup := rec.group;
		bandGroupTitle.tabs[0].value := gProductGroup;
		bandGroupTitle.visible := true;
	end
	else
		bandGroupTitle.visible := false;

	if gProduct <> rec.description then
	begin
		gProduct := rec.description;
		bandProduct.tabs[0].value := IntToStr(rec.id);
		bandProduct.tabs[1].textflags := bandProduct.tabs[1].textflags - [tf_right];  
		bandProduct.tabs[1].value := gProduct;
		bandProduct.tabs[2].value := '';
		bandProduct.tabs[3].value := formatfloatmse(rec.main_price, '0.00');;
	end
	else
	begin
		bandProduct.tabs[0].value := '';
		bandProduct.tabs[1].textflags := bandProduct.tabs[1].textflags + [tf_right];  
		bandProduct.tabs[1].value := 'buys starting from';
		bandProduct.tabs[2].value := formatfloatmse(rec.quantity, '0.###');
		bandProduct.tabs[3].value := formatfloatmse(rec.qty_price, '0.00');
	end;
	empty := false;
end;

procedure tproductprices2re.updateCounter(const sender: tcustomrecordband);
begin
	inc(recNo);
end;

procedure tproductprices2re.resetCounter(const sender: tcustomreport);
begin
	recNo := 0;
	gProductGroup := '';
	gProduct := '';
end;

procedure tproductprices2re.doFinish(const sender: TObject);
begin
    //writeln('doFinish');
end;

procedure tproductprices2re.weveDone(const sender: TObject);
begin
    //writeln('weveDone');
end;
 
end.
