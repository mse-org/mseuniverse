unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mserealsumedit,
 msesimplewidgets;

type
 tmainfo = class(tmainform)
   twidgetgrid1: twidgetgrid;
   itemed: titemedit;
   trealedit1: trealedit;
   tintegeredit1: tintegeredit;
   procedure createexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,msedatalist,msevaluenodes;

procedure tmainfo.createexe(const sender: TObject);
begin
 itemed.itemlist.add(trealvaluelistedititem.create);
 itemed.itemlist.add(tintegervaluelistedititem.create);
end;

end.
