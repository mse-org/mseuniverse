unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,
 msestrings,msewidgetgrid,sysutils,msecolordialog,msesimplewidgets;

type
 tmainfo = class(tmainform)
   grid: twidgetgrid;
   colorname: tstringedit;
   colored: tcoloredit;
   tstatfile1: tstatfile;
   tbutton1: tbutton;
   procedure resetev(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.resetev(const sender: TObject);
var
 i1: int32;
begin
 for i1:= 0 to grid.rowhigh do begin
  colored[i1]:= cl_default;
 end;
end;

end.
