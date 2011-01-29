unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets,
 repazclasses,db,msedb,msebufdataset,msedatabase,msesqldb,msqldb,sysutils,
 repazdatasources,msedataedits,mseedit,msestrings,msetypes,msestatfile,
 msedbedit,msedialog,msegrids,mselookupbuffer,msebitmap,msedatanodes,
 msefiledialog,msesplitter,mselistbrowser,msesys,repazlookupbuffers,
 msewidgetgrid,mseinplaceedit,msetextedit,msedbgraphics,mseimage,msepointer,
 msesqlite3conn,msefileutils,mseact,msetoolbar,msedock,mseskin,repazchart,
 repazpreview,msetabs,mseguiintf;

type
 tmainfo = class(tmainform)
   TRepaz1: TRepaz;
   dsproduct: tmsedatasource;
   sqlproduct: tmsesqlquery;
   trepazdatasources1: trepazdatasources;
   tstatfile1: tstatfile;
   transread: tmsesqltransaction;
   sqlsupplier: tmsesqlquery;
   dssupplier: tmsedatasource;
   trepazlookupbuffers1: trepazlookupbuffers;
   lbsupplier: tdblookupbuffer;
   SQLProductCat: tmsesqlquery;
   DSProductCat: tmsedatasource;
   transwrite: tmsesqltransaction;
   lbproduct: tdblookupbuffer;
   dsaccount: tmsedatasource;
   sqlaccount: tmsesqlquery;
   sqlcompany: tmsesqlquery;
   dscompany: tmsedatasource;
   tdbwidgetgrid4: tdbwidgetgrid;
   tfilelistview1: tfilelistview;
   timage1: timage;
   tlayouter1: tlayouter;
   tbutton6: tbutton;
   tbutton5: tbutton;
   tbutton4: tbutton;
   tbutton3: tbutton;
   tbutton1: tbutton;
   tbutton2: tbutton;
   lbkel: tdblookupbuffer;
   dsgroupaccount: tmsedatasource;
   sqlgroupaccount: tmsesqlquery;
   dschart: tmsedatasource;
   sqlchart: tmsesqlquery;
   tsqlite3connection1: tsqlite3connection;
   dsProductDetail: tmsedatasource;
   sqlProductDetail: tmsesqlquery;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   TRepazChart1: TRepazChart;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
   tdockpanel1: tdockpanel;
   tdockpanel2: tdockpanel;
   procedure showdesign(const sender: TObject);
   procedure repexecute(const sender: TObject);
   procedure reppreview(const sender: TObject);
   procedure repprint(const sender: TObject);
   procedure repps(const sender: TObject);
   procedure mainfo_onloaded(const sender: TObject);
   procedure tbutton2_onexecute(const sender: TObject);
   procedure mainfo_onclosequery(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure mainfo_oncreate(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mseintegerenter;
procedure tmainfo.showdesign(const sender: TObject);
begin
 if tfilelistview1.selectednames<>nil then begin
  trepaz1.filename:= tfilelistview1.path + tfilelistview1.selectednames[0];
	 trepaz1.reportdesign;
 end else begin
  showmessage('Repaz filename not selected!');
 end;
end;

procedure tmainfo.repexecute(const sender: TObject);
begin
 if tfilelistview1.selectednames<>nil then begin
  trepaz1.filename:= tfilelistview1.path + tfilelistview1.selectednames[0];
	 trepaz1.reportexecute(true);
 end else begin
  showmessage('Repaz filename not selected!');
 end;
end;

procedure tmainfo.reppreview(const sender: TObject);
begin
 if tfilelistview1.selectednames<>nil then begin
  trepaz1.filename:= tfilelistview1.path + tfilelistview1.selectednames[0];
	 trepaz1.reportpreview;
 end else begin
  showmessage('Repaz filename not selected!');
 end;
end;

procedure tmainfo.repprint(const sender: TObject);
begin
 if tfilelistview1.selectednames<>nil then begin
  trepaz1.filename:= tfilelistview1.path + tfilelistview1.selectednames[0];
	 trepaz1.reportprint(true);
 end else begin
  showmessage('Repaz filename not selected!');
 end;
end;

procedure tmainfo.repps(const sender: TObject);
begin
 if tfilelistview1.selectednames<>nil then begin
  trepaz1.filename:= tfilelistview1.path + tfilelistview1.selectednames[0];
	 trepaz1.reportpostscript;
 end else begin
  showmessage('Repaz filename not selected!');
 end;
end;

procedure tmainfo.mainfo_onloaded(const sender: TObject);
begin
end;

procedure tmainfo.tbutton2_onexecute(const sender: TObject);
begin
 tsqlite3connection1.connected:= true;
 sqlproduct.active:= true;
 sqlcompany.active:= true;
 sqlsupplier.active:= true;
 sqlgroupaccount.active:= true;
 sqlaccount.active:= true;
 sqlproductcat.active:= true;
 sqlchart.active:= true;
 sqlproductdetail.active:= true;
 TRepazChart1.invalidate;
 tbutton1.enabled:= true;
 tbutton3.enabled:= true;
 tbutton4.enabled:= true;
 tbutton5.enabled:= true;
 tbutton6.enabled:= true;
end;

procedure tmainfo.mainfo_onclosequery(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if not askyesno('Close application?','Confirmation',mr_no) then begin
  amodalresult:= mr_none;
 end;
end;

procedure tmainfo.mainfo_oncreate(const sender: TObject);
begin
 tfilelistview1.directory:= getcurrentdir + '/report/';
 tfilelistview1.readlist; 
end;

end.
