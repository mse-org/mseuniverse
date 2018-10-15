unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mdb,msebufdataset,
 msedb,mseifiglob,mselocaldataset;

type
 tmainmo = class(tmsedatamodule)
   ds1: tlocaldataset;
   ds2: tlocaldataset;
   procedure beforepostev(DataSet: TDataSet);
 end;
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm,msedate;
 
procedure tmainmo.beforepostev(DataSet: TDataSet);
var
 dt1: tdatetime;
begin
 dt1:= nowutc();
 if dataset.state = dsinsert then begin
  dataset.fieldbyname('tscreate').asdatetime:= dt1;
  dataset.fieldbyname('tsmodify').asdatetime:= dt1;
 end
 else begin
  dataset.fieldbyname('tsmodify').asdatetime:= dt1;
 end;
end;

end.
