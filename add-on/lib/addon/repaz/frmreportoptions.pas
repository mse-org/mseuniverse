unit frmreportoptions;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msegui,msegraphics,
 msegraphutils,mseclasses,mseforms,msetabs,msedataedits,
 msesimplewidgets,msegraphedits;
type
 tfrmreportoptionsfo = class(tmseform)
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   btnok: tbutton;
   btncancel: tbutton;
   cshowgrid: tbooleanedit;
   csnap: tbooleanedit;
   cgridx: trealspinedit;
   cgridy: trealspinedit;
   cunits: tdropdownlistedit;
   procedure frmreportoptionsfo_oncreate(const sender: TObject);
 end;
var
 frmreportoptionsfo: tfrmreportoptionsfo;
implementation
uses
 frmreportoptions_mfm,mseconsts,repazconsts;
procedure tfrmreportoptionsfo.frmreportoptionsfo_oncreate(const sender: TObject);
begin
 ttabpage1.caption:= uc(ord(rcsDisplay));
 cshowgrid.frame.caption:= uc(ord(rcsLblshowgrid));
 csnap.frame.caption:= uc(ord(rcsLblsnap));
 cgridx.frame.caption:= uc(ord(rcsLblgridsizex));
 cgridy.frame.caption:= uc(ord(rcsLblgridsizey));
 cunits.frame.caption:= uc(ord(rcsLblunit));
 btnok.caption:= uc(ord(rcsOk));
 btncancel.caption:= uc(ord(rcsCancel));
end;

end.
