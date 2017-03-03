unit doculistpageeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 docupageeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils;

type
 tdoculistpageeditfo = class(tdocupageeditfo)
   tlayouter1: tlayouter;
   fonted: tdbstringedit;
   fontheighted: tdbrealedit;
 end;
implementation
uses
 doculistpageeditform_mfm;
end.
