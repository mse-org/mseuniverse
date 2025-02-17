unit frmtiers;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,basetabs,
 msedragglob,msescrollbar,msetabs,mdb,mseact,msedataedits,msedbedit,
 msedropdownlist,mseedit,msegraphedits,msegrids,msegridsglob,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msestatfile,msestream,sysutils,
 DbGroup;

type
 tfrmtiersfo = class(tbasetabsfo)
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   procedure Whenloaded(const sender: TObject);
 end;
var
 frmtiersfo: tfrmtiersfo;
implementation
uses
 frmtiers_mfm, TiersPaie,tsub;
 
procedure tfrmtiersfo.Whenloaded(const sender: TObject);
begin
ttabpage1.tagpo := (tTiersPaiefo);
ttabPage2.tagpo := (ttsubfo);
ttabwidget1.activePageIndex:=0;
end;

end.
