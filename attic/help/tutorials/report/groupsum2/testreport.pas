unit testreport;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msereport,msestrings,msedataedits,
 mseedit,msepostscriptprinter,mseprinter,msetypes,db,msebufdataset,msedb,
 msesqldb,msqldb,sysutils,msesimplewidgets,msewidgets,mserichstring;

type
 ttestre = class(treport)
   treportpage1: treportpage;
   tbandarea1: tbandarea;
   tbandgroup1: tbandgroup;
   printer: tpostscriptprinter;
   dse: tmsesqlquery;
   dso: tmsedatasource;
   trecordband1: trecordband;
   treppagenumdisp1: treppagenumdisp;
   header: trecordband;
   group3: trecordband;
   group2: trecordband;
   group1: trecordband;
   procedure reportloaded(const sender: TObject);
   procedure group3getvalue(const sender: TObject; var avalue: richstringty);
   procedure group2getvalue(const sender: TObject; var avalue: richstringty);
   procedure group1getvalue(const sender: TObject; var avalue: richstringty);
 end;

implementation
uses
 testreport_mfm,msestream,msesys;
 
procedure ttestre.reportloaded(const sender: TObject);
begin
 dse.appendrecord(['a1','b1','c1','d1',100,1,1,1]);
 dse.appendrecord(['a1','b1','c1','d2',50, 1,1,1]);
 dse.appendrecord(['a1','b1','c2','d1',50, 1,1,2]);
 dse.appendrecord(['a1','b1','c2','d2',50, 1,1,2]);
 dse.appendrecord(['a1','b2','c1','d1',300,1,2,1]);
 dse.appendrecord(['a1','b2','c1','d2',250,1,2,1]);
 render(printer{,ttextstream.create('test.ps',fm_create)});
end;

procedure ttestre.group3getvalue(const sender: TObject;
               var avalue: richstringty);
begin
 if not group3.isfirstofgroup then begin
  avalue.text:= '';
 end;
end;

procedure ttestre.group2getvalue(const sender: TObject;
               var avalue: richstringty);
begin
 if not group2.isfirstofgroup then begin
  avalue.text:= '';
 end;
end;

procedure ttestre.group1getvalue(const sender: TObject;
               var avalue: richstringty);
begin
 if not group1.isfirstofgroup then begin
  avalue.text:= '';
 end;
end;

end.
