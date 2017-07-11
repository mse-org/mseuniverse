unit mseadifpars;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msestream,msestrings;
type
 adiftagty = ( //record fields at the beginning
  at_call,
  at_qth,
  at_name,
  at_time_on,
  at_qso_date,
  at_rst_sent,
  at_rst_rcvd,
  at_band,
  at_freq,
  at_mode,
  at_cont,
  at_ituz,
  at_cqz,
  at_dxcc,
  at_country,
  at_gridsquare,
  at_iota,
  at_state,
  at_qsl_rcvd,
  at_lotw_qsl_rcvd,
  at_eqsl_qsl_rcvd,
  at_comment,
  at_pfx,
  at_adif_vers, //known fields not in record
  at_programid,
  at_programversion,
  at_a_index); 

const
 firstlogfield = at_call;
 lastlogfield = at_pfx;

 adiftagnames: array[adiftagty] of string = (
  'call',
  'qth',
  'name',
  'time_on',
  'qso_date',
  'rst_sent',
  'rst_rcvd',
  'band',
  'freq',
  'mode',
  'cont',
  'ituz',
  'cqz',
  'dxcc',
  'country',
  'gridsquare',
  'iota',
  'state',
  'qsl_rcvd',
  'lotw_qsl_rcvd',
  'eqsl_qsl_rcvd',
  'comment',
  'pfx',
   'adif_vers',
   'programid',
   'programversion',
   'a_index'
 );

type
 adlogrecty = record
  fields: array[firstlogfield..lastlogfield] of msestring;
 end;
 
 tadifparser = class //todo
  protected
   fdata: ttextstream;
  public
   constructor create(const astream: ttextstream);
 end;
 
function datetoadif(const value: tdatetime): msestring;
function timetoadif(const value: tdatetime): msestring;

implementation
uses
 mseformatstr;
 
function datetoadif(const value: tdatetime): msestring;
begin
 result:= datetimetostring(value,'YYYYMMDD');
end;

function timetoadif(const value: tdatetime): msestring;
begin
 result:= datetimetostring(value,'HHNNSS');
end;

{ tadifparser }

constructor tadifparser.create(const astream: ttextstream);
begin
 fdata:= astream;
end;

end.
