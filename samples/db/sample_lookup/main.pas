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
   procedure changeev(const sender: TObject);
end; 

var
 mainfo: tmainfo; nCol:integer;
implementation
uses
 main_mfm;

procedure tmainfo.changeEV(const sender: TObject);
begin
with tdropdownlisteditlb(sender).dropdown do 
with lookupbuffer do
localdata.indexlocal.indexbyname(fieldnamestext[ncol])
                    .find([textvalue[ncol,itemindex]],false,true);
end;

initialization
ncol:=1;
end.
