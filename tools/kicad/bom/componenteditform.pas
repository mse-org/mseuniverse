unit componenteditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils,msedb;

type
 tcomponenteditfo = class(trecordeditfo)
   stripe2: tlayouter;
   value2ed: tdbstringedit;
   value1ed: tdbstringedit;
   valueed: tdbstringedit;
   stripe3: tlayouter;
   footprinted: tdbenum64editdb;
   compkinded: tdbenum64editdb;
   tsimplewidget2: tsimplewidget;
   stripe4: tlayouter;
   tdbstringedit1: tdbstringedit;
   procedure closeev(const sender: TObject);
   procedure editfootprintev(const sender: TObject);
   procedure editcompkindev(const sender: TObject);
  public
   constructor create(const idfield: tmselargeintfield;
                                        const nonavig: boolean); reintroduce;
 end;
implementation
uses
 componenteditform_mfm,mainmodule,main;

{ tcomponenteditfo }

constructor tcomponenteditfo.create(const idfield: tmselargeintfield;
                                                    const nonavig: boolean);
begin
 mainmo.begincomponentedit(idfield);
 inherited create(nil);
 if nonavig then begin
  navig.options:= navig.options + [dno_nonavig,dno_noinsert];
 end
 else begin
  navig.options:= navig.options - [dno_nonavig,dno_noinsert];
 end;
end;

procedure tcomponenteditfo.closeev(const sender: TObject);
begin
 mainmo.endcomponentedit(dno_nonavig in navig.options); //true -> full refresh
end;

procedure tcomponenteditfo.editfootprintev(const sender: TObject);
begin
 mainfo.editfootprint(sender);
end;

procedure tcomponenteditfo.editcompkindev(const sender: TObject);
begin
 mainfo.editcomponentkind(sender);
end;

end.
