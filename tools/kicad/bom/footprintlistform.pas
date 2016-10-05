unit footprintlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils,msedb;

type
 tfootprintlistfo = class(tlisteditfo)
   areaed: tdbrealedit;
   procedure closeev(const sender: TObject);
  public
   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 footprintlistform_mfm,mainmodule;

{ tfootprintlistfo }

constructor tfootprintlistfo.create(const aid: tmselargeintfield);
begin
 mainmo.beginfootprintedit(aid);
 inherited create(nil);
end;

procedure tfootprintlistfo.closeev(const sender: TObject);
begin
 mainmo.endfootprintedit();
end;

end.
