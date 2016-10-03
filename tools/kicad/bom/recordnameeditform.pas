unit recordnameeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils;

type
 trecordnameeditfo = class(trecordeditfo)
   stripe1: tlayouter;
   nameselector: tenum64editdb;
   stripe2: tlayouter;
   nameed: tdbstringedit;
   procedure selectorev(const sender: TObject; var avalue: Int64;
                   var accept: Boolean);
 end;
var
 recordnameeditfo: trecordnameeditfo;
implementation
uses
 recordnameeditform_mfm,msesqldb;
 
procedure trecordnameeditfo.selectorev(const sender: TObject; var avalue: Int64;
               var accept: Boolean);
begin
 tmsesqlquery(dataso.dataset).indexlocal[0].find([avalue],[]);
end;

end.
