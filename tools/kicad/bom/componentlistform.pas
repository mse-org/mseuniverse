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
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   texpandingwidget1: texpandingwidget;
   tdbnavigator1: tdbnavigator;
   grid: tdbwidgetgrid;
   valueed: tdbstringedit;
   value1ed: tdbstringedit;
   value2ed: tdbstringedit;
   tstatfile1: tstatfile;
   kinded: tdbenum64editdb;
   footprinted: tdbenum64editdb;
   edititemact: taction;
   procedure edititemev(const sender: TObject);
 end;

implementation
uses
 componentlistform_mfm,mainmodule,componenteditform;
 
procedure tcomponentlistfo.edititemev(const sender: TObject);
var
 res1: modalresultty;
 fo1: tcomponenteditfo;
begin
 mainmo.begincomponentedit(nil);
 fo1:= tcomponenteditfo.create(nil);
 try
  repeat
   res1:= fo1.show(ml_application);
  until mainmo.endcomponentedit(res1 = mr_ok);
 finally
  fo1.destroy();
 end;
end;

end.
