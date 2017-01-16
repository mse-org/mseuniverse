unit listreppage_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,listreppage;

const
 objdata: record size: integer; data: array[0..83] of byte end =
      (size: 84; data: (
  84,80,70,48,241,10,116,108,105,115,116,114,101,112,112,97,9,108,105,115,
  116,114,101,112,112,97,15,109,111,100,117,108,101,99,108,97,115,115,110,97,
  109,101,6,10,116,98,97,115,101,114,101,112,112,97,13,114,101,112,100,101,
  115,105,103,110,105,110,102,111,1,3,177,0,3,159,0,3,204,1,3,113,
  1,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tlistreppa,'');
end.
