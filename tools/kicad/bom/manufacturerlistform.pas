unit manufacturerlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 msedb,mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,
 msestream,msestrings,sysutils;

type
 tmanufacturerlistfo = class(tlisteditfo)
   idented: tdbstringedit;
  public
//   constructor create(const aid: tmselargeintfield); reintroduce;
 end;

implementation
uses
 manufacturerlistform_mfm,mainmodule;

{ tmanufacturerlistfo }
{
constructor tmanufacturerlistfo.create(const aid: tmselargeintfield);
begin
 mainmo.beginmanufactureredit(aid);
 inherited create(nil);
end;
}
end.
