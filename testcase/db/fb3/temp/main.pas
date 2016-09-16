unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedatabase,
 mseibconnection,sysutils,mdb,msebufdataset,msedb,mseifiglob,msesqldb,msqldb,
 msegraphedits,mseificomp,mseificompglob,msescrollbar,msedataedits,msedbedit,
 mseedit,msegrids,mselookupbuffer,msestatfile,msestream,msestrings,msesqlresult,
 msefbconnection,msesimplewidgets,msedbgraphics,msebitmap,msedatanodes,
 msefiledialog,mselistbrowser,msesys,msedbevents,msedispwidgets,mserichstring,
 msedbdispwidgets,mseact;
//['{6C7A2561-16E6-4CAC-B4C6-16171480BE1D}']
type
 tmainfo = class(tmainform)
   conn: tmseibconnection;
   trans: tmsesqltransaction;
   query: tmsesqlquery;
   dataso: tmsedatasource;
   tbooleanedit1: tbooleanedit;
   tdbstringgrid1: tdbstringgrid;
   tdbnavigator1: tdbnavigator;
   tdatetimeedit1: tdatetimeedit;
   sqlres: tsqlresult;
   tbooleanedit2: tbooleanedit;
   tbooleanedit3: tbooleanedit;
   tstatfile1: tstatfile;
   blobf: tmsememofield;
   binblob: tmsegraphicfield;
   tdbstringedit1: tdbstringedit;
   tdbstringedit2: tdbstringedit;
   tdbstringedit3: tdbstringedit;
   event1: tdbevent;
   event2: tdbevent;
   event3: tdbevent;
   event4: tdbevent;
   eventstatement: tsqlstatement;
   bu1: tbutton;
   bu2: tbutton;
   bu3: tbutton;
   bu4: tbutton;
   eventtrans: tmsesqltransaction;
   tintegerdisp1: tintegerdisp;
   tbutton5: tbutton;
   tintegerdisp2: tintegerdisp;
   tintegerdisp3: tintegerdisp;
   tintegerdisp4: tintegerdisp;
   tbooleanedit4: tbooleanedit;
   tbooleanedit5: tbooleanedit;
   tbooleanedit6: tbooleanedit;
   tbooleanedit7: tbooleanedit;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton4: tbutton;
   tbutton6: tbutton;
   memodi: tstringdisp;
   versiondi: tstringdisp;
   maivers: tintegerdisp;
   minvers: tintegerdisp;
   query2: tmsesqlquery;
   tbooleanedit8: tbooleanedit;
   tdbintegerdisp1: tdbintegerdisp;
   datso2: tmsedatasource;
   rowsret: tintegerdisp;
   rowsaff: tintegerdisp;
   dbname: tfilenameedit;
   procedure connsetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure ressetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure createev(const sender: TObject);
   procedure querysetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure exeev(const sender: TObject);
   procedure exe2ev(const sender: TObject);
   procedure fireexe(const sender: TObject);
   procedure commitexe(const sender: TObject);
   procedure eventexe(const sender: tdbevent; const aid: Int64);
   procedure setevenaev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure fire2exe(const sender: TObject);
   procedure sqlresexe(const sender: TObject);
   procedure connev(const sender: tmdatabase);
   procedure returningev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure createsetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
  public
   db: tfbconnection;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msefirebird,firebird,mseformatpngread,mclasses;

procedure tmainfo.connsetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
end;

procedure tmainfo.ressetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 sqlres.active:= avalue;
end;

procedure tmainfo.createev(const sender: TObject);
var
 fcapacity: ptrint;
 ms: tmemorystream;
begin
{
fcapacity:= 500000000;
writeln(high(ptrint) div 5);
writeln((5*FCapacity) div 4);
writeln((int64(5)*int64(FCapacity)) div int64(4));
ms:= tmemorystream.create;
ms.capacity:= 500000000;
ms.capacity:= 500002817;
ms.capacity:= ms.capacity+1;
ms.free;
}
//exit;
 db:= tfbconnection.create(self);
 db.options:= [fbo_sqlinfo];
 db.transaction:= trans;
 db.username:= 'SYSDBA';
 db.password:= 'masterkey';
 db.hostname:= 'localhost/3051';
 db.databasename:= '/db/firebird_3_0/test.fdb';
 if dbo_bcdtofloatif in conn.controller.options then begin
  db.controller.options:= db.controller.options + [dbo_bcdtofloatif];
 end;
 sqlres.database:= db;
 query.database:= db;
 query2.database:= db;
 eventstatement.database:= db;
 eventtrans.database:= db;
 event1.database:= db;
 event2.database:= db;
 event3.database:= db;
 event4.database:= db;
 db.onafterconnect:= conn.onafterconnect;
end;

procedure tmainfo.querysetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  query.active:= true;
 end
 else begin
  if db <> nil then begin
   db.connected:= false;
  end
  else begin
   conn.connected:= false;
  end;
 end;
 rowsaff.value:= query.rowsaffected;
 rowsret.value:= query.rowsreturned;
end;

procedure tmainfo.exeev(const sender: TObject);
var
 str1: string;
 i1: int32;
begin
 str1:= 'abcdefghiklmno';
 setlength(str1,256000);
 for i1:= 10 to length(str1) - 1 do begin
  pchar(pointer(str1))[i1]:= char(ord('0') + (i1 mod 10));
  if i1 mod 100 = 0 then begin
   pchar(pointer(str1))[i1]:= c_linefeed;
  end;
 end;
 blobf.asstring:= str1;
 writefiledatastring('/home/mse/test/test.txt',str1);
end;

procedure tmainfo.exe2ev(const sender: TObject);
begin
 writefiledatastring('/home/mse/test/test2.txt',blobf.asstring);
end;

procedure tmainfo.fireexe(const sender: TObject);
begin
 with tbutton(sender) do begin
  eventstatement.sql.macros[0].value.text:= caption;
  eventstatement.execute();
 end;
 tbutton(sender).color:= cl_ltred;
end;

procedure tmainfo.commitexe(const sender: TObject);
begin
 eventtrans.commit;
 bu1.color:= cl_default;
 bu2.color:= cl_default;
 bu3.color:= cl_default;
 bu4.color:= cl_default;
end;

procedure tmainfo.eventexe(const sender: tdbevent; const aid: Int64);
begin
 with tintegerdisp(findtagchild(sender.tag,tintegerdisp)) do begin
  value:= value + 1;
 end;
end;

procedure tmainfo.setevenaev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 with tdbevent(findtagcomponent(tmsecomponent(sender).tag,tdbevent)) do begin
  listen:= avalue;
 end;
end;

procedure tmainfo.fire2exe(const sender: TObject);
begin
 with tdbevent(findtagcomponent(tmsecomponent(sender).tag,tdbevent)) do begin
  fire();
 end;
end;

procedure tmainfo.sqlresexe(const sender: TObject);
begin
 sqlres.active:= true;
 memodi.value:= sqlres.cols.colbyname('textblob').asmsestring;
 sqlres.active:= false;
end;

procedure tmainfo.connev(const sender: tmdatabase);
begin
 if db <> nil then begin
  versiondi.value:= db.version;
  maivers.value:= isc_get_client_major_version();
  minvers.value:= isc_get_client_minor_version();
 end
 else begin
  versiondi.value:= msestring(concatstrings(conn.version.imp,lineend));
 end;
end;

procedure tmainfo.returningev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 query2.active:= avalue;
 rowsaff.value:= query2.rowsaffected;
 rowsret.value:= query2.rowsreturned;
end;

procedure tmainfo.createsetev(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
var
 str1: string;
begin
 str1:= 'create database '+ansistring(
  encodesqlstring('localhost/3051:'+avalue)+
              ' user ''SYSDBA'' password ''masterkey''');
 try
  if db <> nil then begin
   db.createdatabase(str1);
  end
  else begin
   conn.createdatabase(str1);
  end;
 except
  application.handleexception();
 end;
end;

end.
