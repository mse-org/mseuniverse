unit dbmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,msedatabase,
 msesqlite3conn,sysutils,mdb,msebufdataset,msedb,mseifiglob,msesqldb,msestrings,
 msqldb,mseadifpars;

const
 logtablename = 'Log';

 adlogfieldnames: array[firstlogfield..lastlogfield] of string = (
  'callsign',  //at_call,
  'qth',       //at_qth,
  'name',      //at_name,
  'utc',       //at_time_on,
  'date',      //at_qso_date,
  'rsttx',     //at_rst_sent,
  'rstrx',     //at_rst_rcvd,
  'band',      //at_band,
  'qrg',       //at_freq,
  'mode',      //at_mode,
  'continent', //at_cont,
  'itu',       //at_ituz,
  'cq',        //at_cqz,
  'dxcc',      //at_dxcc,
  'country',   //at_country,
  'loc',       //at_gridsquare,
  'iota',      //at_iota,
  'state',     //at_state, 
  'qsl',       //at_qsl_rcvd,           //manager?
  'lotw',      //at_lotw_qsl_rcvd,
  'eqsl',      //at_eqsl_qsl_rcvd,
  'memo',      //at_comment,
  'pfx'        //at_pfx,                //statname?
 );

type
 tdbmo = class(tmsedatamodule)
   conn: tsqlite3connection;
   trans: tmsesqltransaction;
   insertstatement: tsqlstatement;
  private
   finited: boolean;
  protected
   fparams: array[firstlogfield..lastlogfield] of tmseparam;
   flasterror: msestring;
  public
   procedure init();
   function writelogrec(const logrec: adlogrecty): boolean; 
                                                      //true if ok
   procedure commit();
   procedure rollback();
   property lasterror: msestring read flasterror;
 end;
var
 dbmo: tdbmo;
implementation
uses
 dbmodule_mfm,msearrayutils;
{ tdbmo }

procedure tdbmo.init();
var
 s1: msestring;
 f1: adiftagty;
begin
 flasterror:= '';
 conn.connected:= false;
 s1:= 'insert into '+logtablename+lineend+'(';
 for f1:= firstlogfield to lastlogfield do begin
  s1:= s1+msestring(adlogfieldnames[f1])+',';
 end;
 setlength(s1,length(s1)-1); //remove last comma
 s1:= s1+')'+lineend+'values'+lineend+'(';
 for f1:= firstlogfield to lastlogfield do begin
  s1:= s1+':'+msestring(adlogfieldnames[f1])+',';
 end;
 setlength(s1,length(s1)-1); //remove last comma
 s1:= s1+')';

 insertstatement.params.clear();
 insertstatement.sql.text:= s1;
 for f1:= firstlogfield to lastlogfield do begin
  fparams[f1]:= insertstatement.params[ord(f1)-ord(firstlogfield)];
 end;
end;

function tdbmo.writelogrec(const logrec: adlogrecty): boolean;
var
 f1: adiftagty;
begin
 result:= false;
 for f1:= firstlogfield to lastlogfield do begin
  fparams[f1].asnullmsestring:= logrec.fields[f1];
 end;
 try
  insertstatement.execute();
  result:= true;
 except
  on e: esqlite3error do begin
   flasterror:= e.errormessage;
  end;
  else begin
   raise; //not expected error
  end;
 end;
end;

procedure tdbmo.commit();
begin
 trans.commit();
end;

procedure tdbmo.rollback();
begin
 trans.rollback();
end;

end.
