unit listeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,mseact,
 msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils,msedb,mseactions;
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
   procedure closequeryev(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure cellev(const sender: TObject; var info: celleventinfoty);
 end;

implementation
uses
 listeditform_mfm,main;
 
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

end.