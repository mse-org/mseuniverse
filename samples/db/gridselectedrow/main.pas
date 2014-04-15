unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,
 msedataedits,msedbedit,mseedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,msestrings,
 msebufdataset,msedb,mselocaldataset,msewidgetgrid,msesimplewidgets;

type
 tmainfo = class(tmainform)
   tdbstringgrid1: tdbstringgrid;
   ds: tlocaldataset;
   dso: tmsedatasource;
   digri: twidgetgrid;
   seldi: tintegeredit;
   tdbnavigator1: tdbnavigator;
   tbutton1: tbutton;
   selfield: tmselongintfield;
   procedure showselexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msedatalist;
 
procedure tmainfo.showselexe(const sender: TObject);
var
 int1: integer;
begin
 digri.beginupdate();
 digri.clear;
 for int1:= 0 to ds.recordcount - 1 do begin
  if ds.currentasinteger[selfield,int1] <> 0 then begin
   tintegerdatalist(seldi.griddata).add(int1+1); //version 3.2
//   seldi.griddata.add(int1+1);                 //version 3.3
  end;
 end;
 digri.endupdate();
end;

end.
