unit titledialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msesplitter,msesimplewidgets,mainmodule,mseact,msedataedits,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestream,msestrings,sysutils,docupageeditform,
 msedbedit,mdb,msegraphedits,msegrids,mselookupbuffer,msescrollbar;
type
 ttitledialogfo = class(tdocupageeditfo)
   val_text: tdbmemoedit;
  protected
  public
//   constructor create(const apage: ttitlepage);
 end;
implementation
uses
 titledialogform_mfm;

{ ttitledialogfo }
{
constructor ttitledialogfo.create(const apage: ttitlepage);
begin
 inherited create(apage);
end;
}
end.
