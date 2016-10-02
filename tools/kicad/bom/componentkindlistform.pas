unit componentkindlistform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,listeditform,
 mdb,mseact,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msestrings,sysutils;

type
 tcomponentkindlistfo = class(tlisteditfo)
   designationed: tdbstringedit;
   tdbstringedit1: tdbstringedit;
   procedure closeev(const sender: TObject);
  public
   constructor create(); reintroduce;
 end;

implementation
uses
 componentkindlistform_mfm,mainmodule;

{ tcomponentkindlistform }

constructor tcomponentkindlistfo.create();
begin
 mainmo.begincomponentkindedit();
 create(nil);
end;

procedure tcomponentkindlistfo.closeev(const sender: TObject);
begin
 mainmo.endcomponentkindedit();
end;

end.
