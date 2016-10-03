unit componentkindeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordnameeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils;

type
 tcomponentkindeditfo = class(trecordnameeditfo)
   tlayouter1: tlayouter;
   designationed: tdbstringedit;
   param1ed: tdbstringedit;
   param2ed: tdbstringedit;
   param4ed: tdbstringedit;
   param3ed: tdbstringedit;
 end;
var
 componentkindeditfo: tcomponentkindeditfo;
implementation
uses
 componentkindeditform_mfm;
end.
