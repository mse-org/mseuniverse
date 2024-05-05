unit datagrid;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedataedits,msedialog,mseedit,
 msegrids,msestrings,msetypes,msesimplewidgets,msewidgets;

type

 tpricesrec = record
 	group : string;
 	reference : string;
 	description : string;
 	main_price : currency;
 	quantity : currency;
 	qty_price : currency;
 	unit_measure : string;
 	weight : currency;
 	vat_percentage : currency;
 	id : integer;
 end;

 tpricesrecarty = array of tpricesrec;
 tpricesrecartyPtr = ^tpricesrecarty;
 
 tdatagridfo = class(tmseform)
   tbutton1: tbutton;
   grid: tdrawgrid;
   tgroupbox3: tgroupbox;
   labelPagesToPrint: tintegeredit;
   tbutton3: tbutton;
   barcodeType: tenumedit;
   procedure doReport(const sender: TObject);
   procedure doInit(const sender: TObject);
   
   procedure doFinish(const sender: TObject);
   procedure grawGridCell(const sender: tcol; const canvas: tcanvas;
                   const cellinfo: cellinfoty);
   procedure doLabels(const sender: TObject);
   protected
   	records : tpricesrecarty;
 end;
var
 datagridfo: tdatagridfo;
implementation
uses
 datagrid_mfm, productprices2, sysutils, mseformatstr, 
 msedrawtext, rptpreview, productlabels;
 
procedure tdatagridfo.doReport(const sender: TObject);
var
	rpt : tproductprices2re;
	rptView : trptpreviewfo;
begin
 	application.createform(trptpreviewfo, rptView);
 	rptView.Activate;
	rpt := tproductprices2re.create(nil);
	rpt.setRecordsPtr(@records);
	rptView.showReport(rpt);
end;

procedure tdatagridfo.doInit(const sender: TObject);
var
	fd : Text;
	line : string;
	fields : stringarty;
	i : integer;
begin
	System.Assign(fd,'pricelist.csv');
	System.Reset(fd);
	setLength(records,100);
	i := 0;
	repeat
		readln(fd, line);
		if line = '' then break;
		if i > high(records) then setLength(records, high(records)+100);
		with records[i] do
		begin
			splitstring(line, fields, ';');

        	group := AnsiDequotedStr(fields[0], '"');
        	reference := AnsiDequotedStr(fields[1], '"');
        	description := AnsiDequotedStr(fields[2], '"');
        	main_price := strtoreal(fields[3]);
        	quantity := strtoreal(fields[4]);
        	qty_price := strtoreal(fields[5]);
        	unit_measure := AnsiDequotedStr(fields[6], '"');
        	weight := strtoreal(fields[7]);
        	vat_percentage := strtoreal(fields[8]);
        	id := strtoint(fields[9]);
		end;
		inc(i);
	until false;
	System.Close(fd);
	setLength(records,i);
	grid.RowCount := length(records);
end;

procedure tdatagridfo.doFinish(const sender: TObject);
begin
	setLength(records,0);
end;

procedure tdatagridfo.grawGridCell(const sender: tcol; const canvas: tcanvas;
               const cellinfo: cellinfoty);
var
 str : String;
 textFlags : textflagsty;
 locRect : rectty;
 
begin
	if (sender.colindex < 0) then Exit;
 	textflags := [tf_ycentered,tf_noselect];
 	with cellinfo do begin
  		sender.drawcellbackground(canvas,sender.frame,sender.face);
  		with records[cell.row] do
  		begin
     		case cell.col of
     			0 : str := group;
     			1 : str := reference;
     			2 : str := description;
     			3 : begin
     					str := CurrToStr(main_price);
     					include(textflags, tf_right);
     				end;
     			4 : begin
     					str := CurrToStr(quantity);
     					include(textflags, tf_right);
     				end;
     			5 : begin
     					str := CurrToStr(qty_price);
     					include(textflags, tf_right);
     				end;
     			6 : str := unit_measure;
     			7 : begin
     					str := CurrToStr(weight);
     					include(textflags, tf_right);
     				end;
     			8 : begin
     					str := CurrToStr(vat_percentage);
     					include(textflags, tf_right);
     				end;
     			9 : str := IntToStr(id);
     			else str := '??';
     		end;
  		end;
  		locRect := rect;
  		locRect.cx := locRect.cx -8;
  		locRect.x := locRect.x +4;
  		drawtext(canvas,str,locRect, textflags);
 	end;
end;

procedure tdatagridfo.doLabels(const sender: TObject);
var
	rpt : tproductlabelsre;
	rptView : trptpreviewfo;
	lp : integer;
begin
	if grid.row < 0 then
    begin
        ShowMessage('Select a product to print labels !');
        exit;
    end;

	rpt := tproductlabelsre.create(nil);

	lp := labelPagesToPrint.value;

    with records[grid.row] do
	   rpt.setLabelData(lp, id, barcodeType.value,
		  '<' + IntToStr(id) + '> ' + reference);

	//if btnRptPreview.value then
	//begin
	 	application.createform(trptpreviewfo, rptView);
	 	rptView.Activate;
		rptView.showReport(rpt);
	//end
	//else rpt.reportLoaded(sender);
end;

end.
