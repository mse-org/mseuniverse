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
   nameed: tstringedit;
   plotsgrid: twidgetgrid;
   layered: tdropdownlistedit;
   plotfileed: tstringedit;
   plotformated: tenumedit;
   procedure namesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure layersetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure createev(const sender: TObject);
 end;

implementation
uses
 productionpage_mfm,mainmodule;

procedure tproductionpagefo.createev(const sender: TObject);
begin
 layered.dropdown.cols[0].asarray:= mainmo.plotkinds;
 plotformated.dropdown.cols[0].asarray:= mainmo.fileformats;
end;

procedure tproductionpagefo.namesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 caption:= avalue;
end;

procedure tproductionpagefo.layersetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if (plotfileed.value = '') or 
           (plotfileed.value = layertoplotname(layered.value)) then begin
  plotfileed.value:= layertoplotname(avalue);
 end;
end;

end.
