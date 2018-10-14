unit editpage3form;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 baseeditpageform,msesimplewidgets,mdb,mseact,msedataedits,msedbedit,
 msedragglob,msedropdownlist,mseedit,msegraphedits,msegrids,msegridsglob,
 mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestatfile,
 msestream,sysutils;

type
 teditpage3fo = class(tbaseeditpagefo)
   tlabel1: tlabel;
   tdbstringgrid1: tdbstringgrid;
 end;
implementation
uses
 editpage3form_mfm;
end.
