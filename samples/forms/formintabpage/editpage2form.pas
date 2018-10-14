unit editpage2form;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 baseeditpageform,mdb,mseact,msedataedits,msedbedit,msedragglob,msedropdownlist,
 mseedit,msegraphedits,msegrids,msegridsglob,mseificomp,mseificompglob,
 mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,sysutils,
 msedispwidgets,mserichstring,msesimplewidgets;

type
 teditpage2fo = class(tbaseeditpagefo)
   tdbrealedit1: tdbrealedit;
   tdbstringedit1: tdbstringedit;
   tlabel1: tlabel;
 end;
implementation
uses
 editpage2form_mfm;
end.
