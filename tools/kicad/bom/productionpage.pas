unit productionpage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetabs,
 msesplitter,mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msegrids,msewidgetgrid;
type
 tproductionpagefo = class(ttabform)
   tlayouter1: tlayouter;
   tstringedit1: tstringedit;
   plotsgrid: twidgetgrid;
   plotkinded: tdropdownlistedit;
   procedure befkinddropdownev(const sender: TObject);
   procedure namesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
 end;
var
 productionpagefo: tproductionpagefo;
implementation
uses
 productionpage_mfm,mainmodule;
 
procedure tproductionpagefo.befkinddropdownev(const sender: TObject);
begin
 tdropdownlistedit(sender).dropdown.cols[0].asarray:= mainmo.plotkinds;
end;

procedure tproductionpagefo.namesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 caption:= avalue;
end;

end.
