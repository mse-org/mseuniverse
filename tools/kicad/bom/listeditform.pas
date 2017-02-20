unit listeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,mseact,
 msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils,msedb,mseactions,msedbdialog;
type
 tlisteditfo = class(tmseform)
   navig: tdbnavigator;
   tstatfile1: tstatfile;
   grid: tdbwidgetgrid;
   nameed: tdbstringedit;
   tdcreateed: tdbdatetimeedit;
   tdmodifyed: tdbdatetimeedit;
   dataso: tmsedatasource;
   dialogact: taction;
   commented: tdbmemodialogedit;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
   procedure loadedev(const sender: TObject);
  private
   fidfield: int64;
  public
   constructor create(const aid: int64); reintroduce;
end;

implementation
uses
 listeditform_mfm,main,mainmodule,msesqldb;
 
constructor tlisteditfo.create(const aid: int64);
begin
 fidfield:= aid;
 inherited create(nil);
 fidfield:= -1;
end;

procedure tlisteditfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 mainfo.checkeditclose(dataso,amodalresult);
end;

procedure tlisteditfo.cellev(const sender: TObject; var info: celleventinfoty);
begin
 if iscellclick(info,[ccr_dblclick]) then begin
  navig.dialogbutton.execute();
 end;
end;

procedure tlisteditfo.loadedev(const sender: TObject);
begin
 mainmo.beginedit(tmsesqlquery(dataso.dataset),fidfield);
end;

end.
