unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,db,msebufdataset,msesqldb,msqldb,
 sysutils,msedataedits,msedbedit,msedialog,mseedit,msegrids,msestrings,msetypes,
 msedb,mdb,mseifiglob,mseact,mseificomp,mseificompglob,msestatfile,msestream,
 msewidgetgrid,msegraphedits,mselookupbuffer,msescrollbar,msedatabase,
 mseibconnection,variants,msedispwidgets,mserichstring,msesimplewidgets,
 msewidgets;

type
 tmainfo = class(tmseform)
   query: tmsesqlquery;
   navi: tdbnavigator;
   grid: tdbwidgetgrid;
   dataso: tmsedatasource;
   sfi: tmsestringfield;
   dfi: tmsedatefield;
   ifi: tmselongintfield;
   sed: tdbstringedit;
   ded: tdbdatetimeedit;
   ied: tdbintegeredit;
   smindi: tstringdisp;
   sexactdi: tstringdisp;
   smaxdi: tstringdisp;
   dmindi: tdatetimedisp;
   dexactdi: tdatetimedisp;
   dmaxdi: tdatetimedisp;
   imindi: tintegerdisp;
   iexactdi: tintegerdisp;
   imaxdi: tintegerdisp;
   procedure onfilterrecordev(dataset: tdataset; var accept: boolean);
   procedure endfiltereditev(const sender: tmsebufdataset;
                   const akind: filtereditkindty);
   procedure filterchangedev(const sender: tmsebufdataset);
   procedure beginfiltereditev(const sender: tmsebufdataset;
                   const akind: filtereditkindty);
  private
   
 end;
var
 mainfo: tmainfo;var varvar:variant;i:integer;
implementation
uses
 main_mfm;
 
procedure tmainfo.onfilterrecordev(dataset: tdataset; var accept: boolean);
//slow! in order to improve performance use
//local copies of the filter values, don't use variants
begin                     
 accept:= tmsebufdataset(dataset).checkfiltervalues();
end;

procedure tmainfo.endfiltereditev(const sender: tmsebufdataset;
               const akind: filtereditkindty);
var 
 i1: int32;
 fi1: tfield;
begin
 if akind = fek_find then begin
  for i1:= 0 to sender.fields.count -1 do begin
   fi1:= sender.fields[i1];
   if not sender.fieldfiltervalueisnull(fi1,fek_find) then begin
    if not sender.indexlocal.indexbyname(fi1.fieldname).findvariant(
           [sender.fieldfiltervalue(fi1,fek_find)],
                                    true,true,false,false) then begin
     showmessage('*** not found ***');
    end;
   end;
  end;
 end;
end;

procedure tmainfo.filterchangedev(const sender: tmsebufdataset);
var
 state1: tdatasetstate;
begin
 state1:= sender.beginfiltervalue(fek_filtermin);
 smindi.value:= sfi.asmsestring;
 dmindi.value:= dfi.asdatetime;
 imindi.value:= ifi.asinteger;
 if ifi.isnull then begin
  imindi.clear();
 end;
 sender.filtereditkind:= fek_filter;
 sexactdi.value:= sfi.asmsestring;
 dexactdi.value:= dfi.asdatetime;
 iexactdi.value:= ifi.asinteger;
 if ifi.isnull then begin
  iexactdi.clear();
 end;
 sender.filtereditkind:= fek_filtermax;
 smaxdi.value:= sfi.asmsestring;
 dmaxdi.value:= dfi.asdatetime;
 imaxdi.value:= ifi.asinteger;
 if ifi.isnull then begin
  imaxdi.clear();
 end;
 sender.endfiltervalue(state1);
end;

procedure tmainfo.beginfiltereditev(const sender: tmsebufdataset;
               const akind: filtereditkindty);
begin
 if akind = fek_find then begin
  sender.clearfilter();
 end;
end;

end.
