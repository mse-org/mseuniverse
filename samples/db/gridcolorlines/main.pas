unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mdb,msebufdataset,msedb,
 mseifiglob,mselocaldataset,msedataedits,msedbedit,mseedit,msegraphedits,
 msegrids,mseificomp,mseificompglob,mselookupbuffer,msescrollbar,msestrings,
 msetypes;

type
 tmainfo = class(tmainform)
   ds: tlocaldataset;
   dataso: tmsedatasource;
   tdbnavigator1: tdbnavigator;
   tdbwidgetgrid1: tdbwidgetgrid;
   colornumed: tdbintegeredit;
   stringed: tdbstringedit;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
