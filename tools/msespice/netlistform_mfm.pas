unit netlistform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,netlistform;

const
 objdata: record size: integer; data: array[0..104] of byte end =
      (size: 105; data: (
  84,80,70,48,241,10,116,110,101,116,108,105,115,116,102,111,9,110,101,116,
  108,105,115,116,102,111,8,98,111,117,110,100,115,95,120,2,100,8,98,111,
  117,110,100,115,95,121,2,100,16,99,111,110,116,97,105,110,101,114,46,98,
  111,117,110,100,115,1,2,0,2,0,3,179,1,3,98,1,0,15,109,111,
  100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,115,112,105,99,
  101,102,111,0,0)
 );

initialization
 registerobjectdata(@objdata,tnetlistfo,'');
end.
