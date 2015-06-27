unit commitdispform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,dispform,
 msedispwidgets,mserichstring,msestrings,msedataedits,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestatfile,msestream,sysutils,msesplitter;

type
 tcommitdispfo = class(tdispfo)
   tspacer1: tspacer;
   parentdi: tstringdisp;
   commitdi: tstringdisp;
   texpandingwidget1: texpandingwidget;
   messagedi: tmemoedit;
   authordatedi: tdatetimedisp;
   authordi: tstringdisp;
   committerdi: tstringdisp;
   treedi: tstringdisp;
   commitdatedi: tdatetimedisp;
  protected
   procedure dorefresh; override;
   procedure doclear; override;
 end;
var
 commitdispfo: tcommitdispfo;
implementation
uses
 commitdispform_mfm,logform;
 
{ tcommitdispfo }

procedure tcommitdispfo.dorefresh;
begin
 if logfo.grid.row < 0 then begin
  doclear();
 end
 else begin
  commitdi.value:= logfo.commit.value;
  parentdi.value:= logfo.parent.value;
  commitdatedi.value:= logfo.commitdate.value;
  treedi.value:= logfo.tree.value;
  committerdi.value:= logfo.committer.value;
  authordi.value:= logfo.author.value;
  authordatedi.value:= logfo.authordate.value;
  messagedi.value:= tlogitem(logfo.message.item).origmessage;
 end;
end;

procedure tcommitdispfo.doclear;
begin
 commitdi.clear();
 parentdi.clear();
 commitdatedi.clear();
 treedi.clear();
 committerdi.clear();
 authordi.clear();
 authordatedi.clear();
 messagedi.value:= '';
end;

end.
