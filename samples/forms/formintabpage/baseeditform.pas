unit baseeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,msedb,
 mseifiglob,mseact,msedataedits,msedbedit,msedragglob,msedropdownlist,mseedit,
 msegraphedits,msegrids,msegridsglob,mseificomp,mseificompglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,sysutils,msedbdispwidgets,msesplitter;
type
 tbaseeditfo = class(tmseform)
   dataso: tmsedatasource;
   tdbnavigator1: tdbnavigator;
   tsmodify: tdbdatetimedisp;
   tscreate: tdbdatetimedisp;
   tspacer1: tspacer;
 end;

implementation
uses
 baseeditform_mfm;
end.
