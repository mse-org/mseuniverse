 unit frmbase;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mclasses,mseforms,msedataedits,
 msedbedit,mseedit,msegraphedits,msegrids,mseifiglob,mselookupbuffer,msestrings,
 msetypes,msesimplewidgets,msewidgets,mdb,msedb,sysutils,msebufdataset,
 msedatabase,msesqldb,msqldb,msedispwidgets,mserichstring,mseact,mseactions,
 mseificomp,mseificompglob,msescrollbar,msesqlresult,msestatfile,msestream,
 msecalendardatetimeedit,msedropdownlist,msedragglob,msetabs,msegridsglob,
 msesplitter,msebitmap,dbgroup,strutils,msetoolbar,msedblookup,classes,
 mseifilink,variants,mseifiendpoint,msekeyboard,msetimer;

type
 tfrmbasefo = class(tmseform)
	ds: tmsedatasource;
   	tdbnavigator1: tdbnavigator;
   	tlayouter1: tlayouter;
   	tlabel1: tlabel;
   	tlabel2: tlabel;
   	tlabel3: tlabel;
   	tlabel4: tlabel;
   tstringdisp1: tstringdisp;
 	procedure onStateChange( Sender: TObject);
   	procedure switchDs(const sender:tobject);
   	procedure WhenDataChanged(Sender: TObject; Field: TField);
    procedure WhenKeydown(const sender: twidget; var ainfo: keyeventinfoty);   
    procedure ResetBtn;
   procedure WhenClosed(const sender: TObject);
end;

var
 frmbasefo: tfrmbasefo;
 
const
 DatasetStates: array[TDataSetState] of string =
 ('dsInactive', 
  'dsBrowse', 
  'dsEdit', 
  'dsInsert',
  'dsKey',
  'dsCalc',
  'dsFilter',
  'dsNewValue','dsOldValue','dsCurrentValue','dsBlockread',
  'dsInternalCalc','dsOpen','dsRefresh');
  aR: array[0..1] of string =('OFF',' ON');
  oP: array[0..3] of string =('= ','>=','<=',' ');
 
implementation
uses
 frmbase_mfm, main;

function dbseek(field:tfield):boolean;
begin
with tmsebufdataset(field.dataset) do 
 if indexlocal.indexbyname(field.fieldname) <> nil then 
      result:=indexlocal.indexbyname(field.fieldname).findvariant(
           [fieldfiltervalue(field,fek_find)],true,true,false,false)
 else result:=locate([field],[fieldfiltervalue(field,fek_find)],[],[]) = loc_ok;
end;  

function getdbnb( filter_kind:integer):integer;
begin
if filter_kind in [0..2] then result:=11+filter_kind else result:=16; 
end;

procedure tfrmbasefo.onStateChange(sender:TObject);
begin
tlabel1.caption := DataSetStates[ds.state];
end;

procedure tfrmbasefo.WhenDataChanged(Sender: TObject; Field: TField);
begin
if (field<>nil)  then
case ds.state of 
dsFilter:
begin
with Field do tlabel4.caption:=displayname
                             +op[ord(filtereditkindty(ds.dataset.tag))]
                             +text;
ResetBtn;
if ds.dataset.tag=3 then if not(dbseek(field)) then showmessage('*** NOT FOUND *** ');
end;
else
end
else 
with ds.dataset do
begin
tlabel3.caption:=inttostr( recno);
if not (filtered) then tstringdisp1.value:=inttostr(recordcount);
end;end;

procedure tfrmbasefo.SwitchDs(const sender:TObject); 
begin
if sender is TDBgroup then ds.dataset:=TDBgroup(sender).datasource.dataset
                      else ds.dataset:=TDBwidgetgrid(sender).datalink.datasource.dataset;
tlabel2.caption:=tmsesqlquery(ds.dataset).tablename
end;

procedure tfrmbasefo.WhenKeydown(const sender: twidget; var ainfo: keyeventinfoty);
begin
if ((ainfo.key = key_Escape) or  (ainfo.key=key_Return)) 
                             and (ds.state = dsfilter) then ResetBtn;
end;

procedure tfrmbasefo.resetBtn;
begin
tdbnavigator1.datalink.execbutton(dbnavigbuttonty(getdbnb(ds.dataset.tag))); 
end;

procedure tfrmbasefo.WhenClosed(const sender: TObject);
begin
mainfo.close;
end;

initialization 
end.
