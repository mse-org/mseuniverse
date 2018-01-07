unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,msestat,msestatfile,
 mseassistivehandler,mseactions,msedatabase,msefb3connection,msqldb,sysutils,
 mdb,msebufdataset,msedb,mseifiglob,msesqldb;

type
 tmainmo = class(tmsedatamodule)
   tstatfile1: tstatfile;
   tassistivehandler1: tassistivehandler;
   newtokenact: taction;
   conn: tfb3connection;
   trans: tmsesqltransaction;
   objectsqu: tmsesqlquery;
   objectsact: taction;
   newobjectact: taction;
   editobjectact: taction;
   deleteobjectact: taction;
   procedure newtokenev(const sender: TObject);
   procedure objectsev(const sender: TObject);
   procedure newobjectev(const sender: TObject);
   procedure editobjectev(const sender: TObject);
   procedure deleteobjectev(const sender: TObject);
 end;
var
 mainmo: tmainmo;
implementation
uses
 msegui,mainmodule_mfm,newtokenform,objectsform,
 newobjectform,editobjectform,deleteobjectform;
 
procedure tmainmo.newtokenev(const sender: TObject);
begin
 with tnewtokenfo.create(nil) do begin
  show(ml_application);
 end;
end;

procedure tmainmo.objectsev(const sender: TObject);
begin
 with tobjectsfo.create(nil) do begin
  show(ml_application);
 end;
end;

procedure tmainmo.newobjectev(const sender: TObject);
begin
 objectsqu.open();
 try
  objectsqu.insert();
  with tnewobjectfo.create(nil) do begin
   try
    case show(ml_application) of
     mr_ok: begin
      objectsqu.post();
     end;
    end;
   finally
    destroy();
   end;
  end;
 finally
  objectsqu.cancel();
  objectsqu.close();
 end;
end;

procedure tmainmo.editobjectev(const sender: TObject);
begin
 objectsqu.open();
 try
  with teditobjectfo.create(nil) do begin
   try
    case show(ml_application) of
     mr_ok: begin
      objectsqu.post();
     end;
    end;
   finally
    destroy();
   end;
  end;
 finally
  objectsqu.cancel();
  objectsqu.close();
 end;
end;

procedure tmainmo.deleteobjectev(const sender: TObject);
begin
 with tdeleteobjectfo.create(nil) do begin
  try
   show(ml_application);
  finally
   destroy();
  end;
 end;
end;

end.
