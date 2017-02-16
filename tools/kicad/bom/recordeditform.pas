unit recordeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,mseact,
 msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils,msesplitter,msedbdispwidgets,msedb;
type
 trecordeditfo = class(tmseform)
   stripe0: tlayouter;
   tlayouter2: tlayouter;
   tsmodify: tdbdatetimedisp;
   tscreate: tdbdatetimedisp;
   navig: tdbnavigator;
   dataso: tmsedatasource;
   tstatfile1: tstatfile;
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
   procedure gridmacrohintev(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
  public
   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 recordeditform_mfm,main,msesqldb,mainmodule,msewidgetgrid;
 
constructor trecordeditfo.create(const aid: tmselargeintfield);
begin
 inherited create(nil);
 if aid <> nil then begin
  tmsesqlquery(dataso.dataset).indexlocal[0].find([aid]);
 end;
end;

procedure trecordeditfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 mainfo.checkeditclose(dataso,amodalresult);
end;

procedure trecordeditfo.macrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 info.caption:= mainmo.expandprojectmacros(tedit(sender).text);
end;

procedure trecordeditfo.gridmacrohintev(const sender: tdatacol;
               const arow: Integer; var info: hintinfoty);
begin
 info.caption:= mainmo.expandprojectmacros(
               tstringedit(twidgetcol(sender).editwidget).griddata[arow]);
end;

end.
