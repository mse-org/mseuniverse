// By Med Hamza 2023

unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msedispwidgets,mserichstring,msestrings,mseedit,msestatfile,msestream,sysutils,
 msesimplewidgets,mdb,msedataedits,msedbedit,msegraphedits,msegrids,mseificomp,
 mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,mseact,msedragglob,
 msedropdownlist,msegridsglob,msedb,msebufdataset,msedatabase,msesqldb,msqldb,
 msesqlresult,mselocaldataset,msetypes;

type
 tmainfo = class(tmainform)
   tdbstringgrid1: tdbstringgrid;
   tdbnavigator1: tdbnavigator;
   dso: tmsedatasource;
   localdata: tlocaldataset;
   lookuplb: tdblookupbuffer;
   tdropdownlisteditlb1: tdropdownlisteditlb;
   tbutton1: tbutton;
   procedure changeev(const sender: TObject);
   procedure filterrec(DataSet: TDataSet; var Accept: Boolean);
   procedure btnexe(const sender: TObject);
end; 

var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.changeEV(const sender: TObject);
begin
with tdropdownlisteditlb(sender).dropdown
   , tdblookupbuffer(lookupbuffer) do 
localdata.indexlocal.indexbyname(fieldnamestext[valuecol])
                    .find([textvalue[valuecol,itemindex]],false,true);
end;

procedure tmainfo.filterrec(DataSet: TDataSet; var Accept: Boolean);
begin
accept:=tmsebufdataset(dataset).checkfiltervalues();
end;

procedure tmainfo.btnexe(const sender: TObject);
begin
TDBNAVIGATOR1.datalink.execbutton(dbnb_filteronoff);
tdropdownlisteditlb1.dropdown.lookupbuffer.clearbuffer;
end;
initialization

end.
