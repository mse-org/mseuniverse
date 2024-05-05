unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesqlite3conn,db,msebufdataset,
 msesqldb,msqldb,sysutils,msedb,msedataedits,msedbedit,msedialog,mseedit,
 msegrids,msestrings,msetypes,msesimplewidgets,msewidgets;

type
 tmainfo = class(tmseform)
   conn: tsqlite3connection;
   trans: tmsesqltransaction;
   query: tmsesqlquery;
   dso: tmsedatasource;
   navig: tdbnavigator;
   ed: tdbstringedit;
   tbutton1: tbutton;
   procedure insertex(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.insertex(const sender: TObject);
begin
 query.insert;
 query.fieldbyname('TEXT1').aswidestring:= 'my source string';
 query.post;
end;

end.
