unit basereppage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msereport,mdb,mseifiglob,
 mserichstring,msesplitter,msestrings,mainmodule;

type
 tbasereppa = class(treppageform)
   tlayouter1: tlayouter;
   treppagenumdisp1: treppagenumdisp;
   trepprintdatedisp1: trepprintdatedisp;
   titledi: trepvaluedisp;
  public
   constructor create(const areport: treport; const adocuinfo: docuinfoty;
                                               const apage: docupageinfoty);
 end;

implementation
uses
 basereppage_mfm;
 
{ tbasereppa }

constructor tbasereppa.create(const areport: treport; 
                                  const adocuinfo: docuinfoty;
                                               const apage: docupageinfoty); 
begin
 inherited create(nil);
 areport.add(self);
 createfont();
 with adocuinfo do begin
  if font <> '' then begin
   self.font.name:= ansistring(font);
  end;
  if fontheight <> emptyreal then begin
   self.font.heightflo:= fontheight;
  end; 
 end;
 if apage.font <> '' then begin
  font.name:= ansistring(apage.font);
 end;
 if apage.fontheight <> emptyreal then begin
  font.heightflo:= apage.fontheight;
 end;
end;

end.
