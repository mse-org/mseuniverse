unit TiersPaie;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,frmbasepage,
 mdb,mseact,msedataedits,msedbedit,msedragglob,msedropdownlist,mseedit,
 msegraphedits,msegrids,msegridsglob,mseificomp,mseificompglob,mseifiglob,
 mselookupbuffer,msescrollbar,msestatfile,msestream,sysutils,DbGroup;

type
 tTiersPaiefo = class(tfrmbasePagefo)
   tdbwidgetgrid1: tdbwidgetgrid;
   tdbintegeredit2: tdbintegeredit;
   tdbintegeredit3: tdbintegeredit;
   tdbintegeredit4: tdbintegeredit;
   TDBgroup1: TDBgroup;
   tdbstringedit3: tdbstringedit;
   tdbstringedit1: tdbstringedit;
   tdbintegeredit1: tdbintegeredit;
 end;
var
 TiersPaiefo: tTiersPaiefo;
implementation
uses
 TiersPaie_mfm;
 
end.
