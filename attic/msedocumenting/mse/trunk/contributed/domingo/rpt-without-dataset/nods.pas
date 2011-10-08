unit nods;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msereport,msesplitter,msestrings,
 msesimplewidgets,msewidgets,msedataedits,mseedit,msepostscriptprinter,
 mseprinter,msetypes,db,mserichstring;

type
 tnodsre = class(treport)
   treportpage1: treportpage;
   tbandarea1: tbandarea;
   tlabel1: tlabel;
   header: trecordband;
   dataRec: trecordband;
   psprn: tpostscriptprinter;
   treppagenumdisp1: treppagenumdisp;
   procedure fillDataLine(const sender: tcustomrecordband; 
   		var empty: Boolean);virtual;
   procedure doInit(const sender: TObject);virtual;
   procedure reportLoaded(const sender: TObject);
   
   procedure advanceCounter(const sender: tcustomrecordband);
   procedure resetCounter(const sender: tcustomreport);
   procedure pageFinished(const sender: tcustomreportpage;
                   const acanvas: tcanvas);
   procedure rptFinished(const sender: TObject);
   protected
   dataCount : Integer;
 end;
var
 nodsre: tnodsre;
implementation
uses
 nods_mfm, sysutils;
 
procedure tnodsre.fillDataLine(const sender: tcustomrecordband;
               var empty: Boolean);
var
	snum : string;               
begin
	if dataCount > 100 then 
	begin
		exit;
	end;
	snum := IntToStr(dataCount);
	dataRec.tabs[0].value := snum;
	dataRec.tabs[1].value := 'A data name ' + snum;
	dataRec.tabs[2].value := 'phone n# ' + snum;
	empty := False;
end;

procedure tnodsre.doInit(const sender: TObject);
begin
	dataCount := 0;
end;

procedure tnodsre.reportLoaded(const sender: TObject);
begin
	render(psprn{,ttextstream.create('test.ps',fm_create)});
end;

procedure tnodsre.advanceCounter(const sender: tcustomrecordband);
begin
	inc(dataCount);
end;

procedure tnodsre.resetCounter(const sender: tcustomreport);
begin
	dataCount := 0;
end;

procedure tnodsre.pageFinished(const sender: tcustomreportpage;
               const acanvas: tcanvas);
begin
	writeln('page finished ' + IntToStr(sender.pagenum));
end;

procedure tnodsre.rptFinished(const sender: TObject);
begin
end;

end.
