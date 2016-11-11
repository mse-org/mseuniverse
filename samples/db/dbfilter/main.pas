unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,db,msebufdataset,msesqldb,msqldb,
 sysutils,msedataedits,msedbedit,msedialog,mseedit,msegrids,msestrings,msetypes,
 msedb,mdb,mseifiglob,mseact,mseificomp,mseificompglob,msestatfile,msestream,
 msewidgetgrid,msegraphedits,mselookupbuffer,msescrollbar,msedatabase,
 mseibconnection,variants;

type
 tmainfo = class(tmseform)
   tmsesqlquery1: tmsesqlquery;
   tdbnavigator1: tdbnavigator;
   tdbwidgetgrid1: tdbwidgetgrid;
   tmsedatasource1: tmsedatasource;
   text1fi: tmsestringfield;
   date1fi: tmsedatefield;
   longint1fi: tmselongintfield;
   tdbstringedit1: tdbstringedit;
   tdbdatetimeedit1: tdbdatetimeedit;
   tdbintegeredit1: tdbintegeredit;
   procedure OnfilterRecord(DataSet: TDataSet; var Accept: Boolean);
   procedure beforeendfilteredit(const sender: tmsebufdataset;
                   const akind: filtereditkindty);
   procedure afterendfilteredit(const sender: tmsebufdataset;
                   const akind: filtereditkindty);
   procedure AfterBeginFilterEdit(const sender: tmsebufdataset;
               const akind: filtereditkindty);                
  private
   
 end;
var
 mainfo: tmainfo;var varvar:variant;i:integer;
implementation
uses
 main_mfm,msewidgets;
 
procedure tmainfo.OnfilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
with dataset.fields[i] do
case datatype of
ftdate,ftinteger,ftfloat,ftboolean,ftcurrency,ftsmallint,ftbcd:
case tmseBufDataset(dataset).FilterEditKind of
fek_filtermin:		accept:=value<varvar;
fek_filter:				accept:=value=varvar;
fek_filtermax:	accept:=value>varvar;
end;
ftstring:
case tmseBufDataset(dataset).FilterEditKind of
fek_filtermin:		accept:= 	msecomparetextlen(varvar,value)<0;
fek_filter:				accept:=  msecomparetextlen(varvar,value)=0;
fek_filtermax:	accept:=	msecomparetextlen(varvar,value)>0;
end;
else showmessage ('Unsupported  ft*');
end;end;

procedure tmainfo.beforeendfilteredit(const sender: tmsebufdataset;
               const akind: filtereditkindty);
begin
i:=0;
with sender do begin
while (i<fields.count) and (fields[i].isnull) do inc(i);
if i<fields.count then varvar:=fields[i].value;
end;end;

procedure tmainfo.afterendfilteredit(const sender: tmsebufdataset;
               const akind: filtereditkindty);
var j:integer;
begin
 if akind = fek_find then begin
 j:=0;
if not(varisempty(varvar) ) then 
with sender do begin
while  (j<indexlocal.count) and (fields[i].fieldname<>indexlocal[j].fields[0].fieldname) do inc(j);
if  ( j< indexlocal.count ) and 
    (not indexlocal[j].findvariant([varvar],false,true)) then 
     showmessage('*** not found ***');
end; end; end;

procedure tmainfo.AfterBeginFilterEdit(const sender: tmsebufdataset;
               const akind: filtereditkindty);
begin
//sender.clearfilter();
end;

end.
