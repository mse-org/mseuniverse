unit distributorlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 msedb,mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,
 msestream,msestrings,sysutils;

type
 tdistributorlistfo = class(tlisteditfo)
   idented: tdbstringedit;
  public
 end;

implementation
uses
 distributorlistform_mfm,mainmodule;

{ tdistributorlistfo }

end.
