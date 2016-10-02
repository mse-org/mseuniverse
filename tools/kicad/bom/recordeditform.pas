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
 end;

implementation
uses
 recordeditform_mfm,main;
 
procedure trecordeditfo.closequeryev(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 mainfo.checkeditclose(dataso,amodalresult);
end;

end.
