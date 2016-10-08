unit componentlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,msestrings,sysutils,msesimplewidgets,mdb,msedbedit,msegraphedits,
 msegrids,mselookupbuffer,msescrollbar,mseactions,listeditform,msedb,msedbdialog;
type
 tcomponentlistfo = class(tmseform)
   tstatfile1: tstatfile;
   edititemact: taction;
   navig: tdbnavigator;
   valueed: tdbstringedit;
   value1ed: tdbstringedit;
   value2ed: tdbstringedit;
   kinded: tdbenum64editdb;
   valuefilter: tenum64editdb;
   valueselector: tenum64editdb;
   value1selector: tenum64editdb;
   value2selector: tenum64editdb;
   footprintselector: tenum64editdb;
   kindselector: tenum64editdb;
   dataso: tmsedatasource;
   manufacturerselector: tenum64editdb;
   distributorselector: tenum64editdb;
   grid: tdbwidgetgrid;
   footprinttdi: tdbstringedit;
   manufacturered: tdbenum64editdb;
   distributored: tdbenum64editdb;
   procedure edititemev(const sender: TObject);
   procedure rowselectev(const sender: TObject; var avalue: Int64;
                   var accept: Boolean);
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
   procedure loadedev(const sender: TObject);
  private
   fidfield: tmselargeintfield;
  public
   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 componentlistform_mfm,mainmodule,componenteditform,main,msesqldb;

constructor tcomponentlistfo.create(const aid: tmselargeintfield);
begin
 fidfield:= aid;
 inherited create(nil);
 fidfield:= nil;
end;

procedure tcomponentlistfo.edititemev(const sender: TObject);
begin
 tcomponenteditfo.create(nil,false).show(ml_application);
end;

procedure tcomponentlistfo.rowselectev(const sender: TObject; var avalue: Int64;
               var accept: Boolean);
begin
 mainmo.stockcompqu.indexlocal[0].find([avalue],[]);
 grid.setfocus();
end;

procedure tcomponentlistfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 mainfo.checkeditclose(dataso,amodalresult);
end;

procedure tcomponentlistfo.cellev(const sender: TObject;
               var info: celleventinfoty);
begin
 if (info.cell.row >= 0) and iscellclick(info,[ccr_dblclick]) then begin
  navig.dialogbutton.execute();
 end;
end;

procedure tcomponentlistfo.loadedev(const sender: TObject);
begin
 mainmo.beginedit(tmsesqlquery(dataso.dataset),fidfield);
end;

end.
