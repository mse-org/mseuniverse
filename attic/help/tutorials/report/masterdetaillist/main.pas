unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedatabase,msesqlite3conn,sysutils,
 db,msebufdataset,msedb,msesqldb,msqldb,msedataedits,msedbedit,msedialog,
 mseedit,msegrids,mselookupbuffer,msestrings,msetypes,msesimplewidgets,
 msewidgets,msepostscriptprinter,mseprinter,msereport;

type
 tmainfo = class(tmseform)
   conn: tsqlite3connection;
   trans: tmsesqltransaction;
   qcustomer: tmsesqlquery;
   qlist: tmsesqlquery;
   mastergrid: tdbstringgrid;
   detailgrid: tdbwidgetgrid;
   tdbdatetimeedit1: tdbdatetimeedit;
   tdbstringedit1: tdbstringedit;
   tdbrealedit1: tdbrealedit;
   dcustomer: tmsedatasource;
   dlist: tmsedatasource;
   custlink: tfieldfieldlink;
   custparamlink: tfieldparamlink;
   button1: tbutton;
   printer: tpostscriptprinter;
   button2: tbutton;
   info: tlabel;
   procedure runpagerep(const sender: TObject);
   procedure runlistrep(const sender: TObject);
  private
   procedure startreport(const kind: reportclassty);
   procedure doafterrender(const sender: tcustomreport);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,report1,report2,msestream,msesys;
 
procedure tmainfo.startreport(const kind: reportclassty);
begin
 button1.enabled:= false;
 button2.enabled:= false;
 mastergrid.datalink.datasource:= nil;
 detailgrid.datalink.datasource:= nil;
 kind.create(self).render(printer,ttextstream.create('test.ps',fm_create),
               @doafterrender);
end;

procedure tmainfo.runlistrep(const sender: TObject);
begin
 startreport(treport1re);
end;

procedure tmainfo.runpagerep(const sender: TObject);
begin
 startreport(treport2re);
end;

procedure tmainfo.doafterrender(const sender: tcustomreport);
begin
 button1.enabled:= true;
 button2.enabled:= true;
 mastergrid.datalink.datasource:= dcustomer;
 detailgrid.datalink.datasource:= dlist;
 info.visible:= true;
end;

end.
