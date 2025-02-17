unit tsub;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,frmbasepage,
 mdb,mseact,msedataedits,msedbedit,msedragglob,msedropdownlist,mseedit,
 msegraphedits,msegrids,msegridsglob,mseificomp,mseificompglob,mseifiglob,
 mselookupbuffer,msescrollbar,msestatfile,msestream,sysutils,dbgroup;
 type
 ttsubfo = class(tfrmbasePagefo)
   TDBgroup1: TDBgroup;
   tdbstringedit3: tdbstringedit;
   tdbstringedit1: tdbstringedit;
   tdbintegeredit1: tdbintegeredit;
 end;
var
 tsubfo: ttsubfo;
implementation
uses
   tsub_mfm;
end.
