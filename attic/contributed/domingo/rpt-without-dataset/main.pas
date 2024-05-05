unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets;

type
 tmainfo = class(tmseform)
   tbutton1: tbutton;
   btnShowImage: tbutton;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton4: tbutton;
   procedure doPrint(const sender: TObject);
   procedure showReportViewer(const sender: TObject);
   procedure showReport(const sender: TObject);
   procedure showDataGrid(const sender: TObject);
   procedure showReportG(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm, nods, imageviewer, rptpreview, datagrid, nodsgrouping;
 
procedure tmainfo.doPrint(const sender: TObject);
var
 rpt : tnodsre;
begin
	rpt := tnodsre.create(nil);
	rpt.reportLoaded(self);
end;

procedure tmainfo.showReportViewer(const sender: TObject);
begin
	if not Assigned(imageviewerfo) then 
 		application.createform(timageviewerfo, imageviewerfo);
 	imageviewerfo.Activate;
end;

procedure tmainfo.showReport(const sender: TObject);
var
 rpt : tnodsre;
 rptView : trptpreviewfo;
begin
 	application.createform(trptpreviewfo, rptView);
 	rptView.Activate;
	rpt := tnodsre.create(nil);
	rptView.showReport(rpt);
end;

procedure tmainfo.showDataGrid(const sender: TObject);
begin
 if not Assigned(datagridfo) then 
 	application.createform(tdatagridfo, datagridfo);
 datagridfo.Activate;
end;

procedure tmainfo.showReportG(const sender: TObject);
var
 rpt : tnodsgroupingfo;
 rptView : trptpreviewfo;
begin
 	application.createform(trptpreviewfo, rptView);
 	rptView.Activate;
	rpt := tnodsgroupingfo.create(nil);
	rptView.showReport(rpt);
end;

end.
