unit componentlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,msestrings,sysutils,msesimplewidgets,mdb,msedbedit,msegraphedits,
 msegrids,mselookupbuffer,msescrollbar,mseactions;
type
 tcomponentlistfo = class(tmseform)
   tstatfile1: tstatfile;
   edititemact: taction;
   tdbnavigator1: tdbnavigator;
   grid: tdbwidgetgrid;
   valueed: tdbstringedit;
   value1ed: tdbstringedit;
   value2ed: tdbstringedit;
   footprinted: tdbenum64editdb;
   kinded: tdbenum64editdb;
   procedure edititemev(const sender: TObject);
 end;

implementation
uses
 componentlistform_mfm,mainmodule,componenteditform;
 
procedure tcomponentlistfo.edititemev(const sender: TObject);
begin
 tcomponenteditfo.create(nil,false).show(ml_application);
end;

end.
