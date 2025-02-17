unit DMAIN;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,msedatabase,
 msefb3connection,msqldb,sysutils,mdb,msebufdataset,msedb,mseifiglob,msesqldb,
 msewidgets,mseificomp,mseificompglob,msebitmap;

type
 tDMAINmo = class(tmsedatamodule)
   tfb3connection1: tfb3connection;
   tmsesqltransaction1: tmsesqltransaction;
   tmsesqlquery1: tmsesqlquery;
   tmsesqlquery2: tmsesqlquery;
   tmsedatasource1: tmsedatasource;
   tmsedatasource2: tmsedatasource;
   tfieldparamlink1: tfieldparamlink;
   tifistringlinkcomp1: tifistringlinkcomp;
   timagelist1: timagelist;
   procedure BeforeFilterEdit(const sender: tmsebufdataset;
             const akind: filtereditkindty);
   procedure filterRec(DataSet: TDataSet; var Accept: Boolean);            
   procedure afterFilterChanged(const sender: tmsebufdataset);
 end;
var
 DMAINmo: tDMAINmo;
implementation
uses
 DMAIN_mfm;

procedure tdmainmo.BeforeFilterEdit(const sender: tmsebufdataset;
               const akind: filtereditkindty);
begin
tmsebufdataset(sender).tag:=ord(akind);
end;

procedure tdmainmo.filterRec(DataSet: TDataSet; var Accept: Boolean);
begin
accept:=tmsebufdataset(dataset).checkfiltervalues();
end; 

procedure tDMAINmo.afterFilterChanged(const sender: tmsebufdataset);
begin
with (sender) do 
if filtered then tifistringlinkcomp1.controller.value:=inttostr(countvisiblerecords()) 
end;
end.
