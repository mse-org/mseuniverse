unit editpage1form;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 baseeditpageform,mdb,mseact,msedataedits,msedbedit,msedragglob,msedropdownlist,
 mseedit,msegraphedits,msegrids,msegridsglob,mseificomp,mseificompglob,
 mseifiglob,mselookupbuffer,msescrollbar,msestatfile,msestream,sysutils,
 msesimplewidgets;

type
 teditpage1fo = class(tbaseeditpagefo)
   tdbstringgrid1: tdbstringgrid;
   tlabel1: tlabel;
 end;
implementation
uses
 editpage1form_mfm;
end.
