unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,db,msebufdataset,msesqldb,msqldb,
 sysutils,msedataedits,msedbedit,msedialog,mseedit,msegrids,msestrings,msetypes,
 msedb;

type
 tmainfo = class(tmseform)
   tmsesqlquery1: tmsesqlquery;
   tdbnavigator1: tdbnavigator;
   tdbwidgetgrid1: tdbwidgetgrid;
   tdbstringedit1: tdbstringedit;
   tmsedatasource1: tmsedatasource;
   text1fi: tmsestringfield;
   procedure filterrec(DataSet: TDataSet; var Accept: Boolean);
   procedure befendfiltered(const sender: tmsebufdataset;
                   const akind: filtereditkindty);
   procedure afterendfiltered(const sender: tmsebufdataset;
                   const akind: filtereditkindty);
  private
   filtervalue: msestring;
   findvalue: msestring;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msewidgets;
 
procedure tmainfo.filterrec(DataSet: TDataSet; var Accept: Boolean);
begin
 accept:= msecomparetextlen(filtervalue,text1fi.asmsestring) = 0;
end;

procedure tmainfo.befendfiltered(const sender: tmsebufdataset;
               const akind: filtereditkindty);
var
 mstr1: msestring;
begin
 mstr1:= text1fi.asmsestring; //dataset is in dsfilter state
 case akind of
  fek_filter: begin
   filtervalue:= mstr1;
  end;
  fek_find: begin
   findvalue:= mstr1;
  end;
 end;
end;

procedure tmainfo.afterendfiltered(const sender: tmsebufdataset;
               const akind: filtereditkindty);
begin
 if akind = fek_find then begin
  if not sender.indexlocal[0].find([findvalue],[],false,true) then begin
   showmessage('Record "'+findvalue+'" not found.');
  end;
 end;
end;

end.
