unit componentlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,msestrings,sysutils,msesimplewidgets,mdb,msedbedit,msegraphedits,
 msegrids,mselookupbuffer,msescrollbar,mseactions,listeditform,msedb;
type
 tcomponentlistfo = class(tmseform)
   tstatfile1: tstatfile;
   edititemact: taction;
   navig: tdbnavigator;
   valueed: tdbstringedit;
   value1ed: tdbstringedit;
   value2ed: tdbstringedit;
   footprinted: tdbenum64editdb;
   kinded: tdbenum64editdb;
   valuefilter: tenum64editdb;
   valueselector: tenum64editdb;
   tenum64editdb2: tenum64editdb;
   tenum64editdb3: tenum64editdb;
   tenum64editdb4: tenum64editdb;
   tenum64editdb5: tenum64editdb;
   dataso: tmsedatasource;
   grid: tdbwidgetgrid;
   procedure edititemev(const sender: TObject);
   procedure rowselectev(const sender: TObject; var avalue: Int64;
                   var accept: Boolean);
   procedure closeev(const sender: TObject);
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
  public
   constructor create(); reintroduce;
 end;

implementation
uses
 componentlistform_mfm,mainmodule,componenteditform,main;
 
constructor tcomponentlistfo.create();
begin
 mainmo.begincomponentlistedit();
 create(nil);
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

procedure tcomponentlistfo.closeev(const sender: TObject);
begin
 mainmo.endcomponentlistedit();
end;

procedure tcomponentlistfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 mainfo.checkeditclose(dataso,amodalresult);
end;

procedure tcomponentlistfo.cellev(const sender: TObject;
               var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) then begin
  navig.dialogbutton.execute();
 end;
end;

end.
