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
   tdbenum64editdb1: tdbenum64editdb;
   idented: tdbstringedit;
   procedure closeev(const sender: TObject);
   procedure libeditev(const sender: TObject);
  public
   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 footprintlistform_mfm,mainmodule,main;

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

procedure tfootprintlistfo.libeditev(const sender: TObject);
begin
 mainfo.editfootprintlibev(nil);
end;

end.
