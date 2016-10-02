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
   valuefilter: tenum64editdb;
   valueselector: tenum64editdb;
   tenum64editdb2: tenum64editdb;
   tenum64editdb3: tenum64editdb;
   tenum64editdb4: tenum64editdb;
   tenum64editdb5: tenum64editdb;
   procedure edititemev(const sender: TObject);
   procedure rowselectev(const sender: TObject; var avalue: Int64;
                   var accept: Boolean);
 end;

implementation
uses
 componentlistform_mfm,mainmodule,componenteditform;
 
procedure tcomponentlistfo.edititemev(const sender: TObject);
begin
 tcomponenteditfo.create(nil,false).show(ml_application);
end;

procedure tcomponentlistfo.rowselectev(const sender: TObject; var avalue: Int64;
               var accept: Boolean);
begin
 mainmo.stockcompqu.indexlocal[0].find([avalue],[]);
end;

end.
