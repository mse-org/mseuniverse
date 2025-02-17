unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,db,msebufdataset,msesqldb,msqldb,
 sysutils,msedataedits,msedbedit,msedialog,mseedit,msegrids,msestrings,msetypes,
 msedb,mdb,mseifiglob,mseact,mseificomp,mseificompglob,msestatfile,msestream,
 msewidgetgrid,msegraphedits,mselookupbuffer,msescrollbar,msedatabase,
 mseibconnection,variants,msesimplewidgets,msewidgets,msesplitter,msebitmap,
 msedropdownlist,msedragglob,msegridsglob,msetabs;

type
 tmainfo = class(tmseform)
   procedure WhenCreated(const sender: TObject);
   procedure ActiveWin  (const sender: TObject);
end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,frmtiers;
 
procedure tmainfo.ActiveWin(const sender: TObject);
begin
//custommseformclassty(tbutton(sender).tagpo).create(nil); 
end;

procedure tmainfo.WhenCreated(const sender: TObject);
begin
//tbutton1.tagpo:=(tfrmtiersfo);
with custommseformclassty(tfrmtiersfo).create(nil) do begin
show;
end;
end;


end.