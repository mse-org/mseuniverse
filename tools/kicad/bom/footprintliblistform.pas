unit footprintliblistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 msedb,mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,
 msestream,msestrings,sysutils;

type
 tfootprintliblistfo = class(tlisteditfo)
   tdbstringedit1: tdbstringedit;
//   procedure closeev(const sender: TObject);
  public
   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 footprintliblistform_mfm,mainmodule;
 
{ tfootprintliblistfo }

constructor tfootprintliblistfo.create(const aid: tmselargeintfield);
begin
 mainmo.beginfootprintlibedit(aid);
 inherited create(nil);
end;
{
procedure tfootprintliblistfo.closeev(const sender: TObject);
begin
 mainmo.endfootprintlibedit();
end;
}
end.
