unit docureport_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,docureport;

const
 objdata: record size: integer; data: array[0..330] of byte end =
      (size: 331; data: (
  84,80,70,48,7,116,100,111,99,117,114,101,6,100,111,99,117,114,101,4,
  112,112,109,109,2,3,9,112,97,103,101,119,105,100,116,104,3,190,0,10,
  112,97,103,101,104,101,105,103,104,116,3,14,1,11,102,111,110,116,46,104,
  101,105,103,104,116,2,14,9,102,111,110,116,46,110,97,109,101,6,10,115,
  116,102,95,114,101,112,111,114,116,15,102,111,110,116,46,108,111,99,97,108,
  112,114,111,112,115,11,10,102,108,112,95,104,101,105,103,104,116,0,9,103,
  114,105,100,95,115,105,122,101,2,2,7,111,112,116,105,111,110,115,11,14,
  114,101,111,95,119,97,105,116,100,105,97,108,111,103,0,10,100,105,97,108,
  111,103,116,101,120,116,6,29,67,114,101,97,116,105,110,103,32,100,111,99,
  117,109,101,110,116,97,116,105,111,110,32,115,101,116,46,46,46,13,100,105,
  97,108,111,103,99,97,112,116,105,111,110,6,11,77,83,69,107,105,99,97,
  100,66,79,77,13,114,101,112,100,101,115,105,103,110,105,110,102,111,1,3,
  177,0,3,159,0,3,204,1,3,113,1,0,15,109,111,100,117,108,101,99,
  108,97,115,115,110,97,109,101,6,7,116,114,101,112,111,114,116,0,11,116,
  114,101,112,111,114,116,112,97,103,101,12,116,114,101,112,111,114,116,112,97,
  103,101,49,9,112,97,103,101,119,105,100,116,104,2,0,10,112,97,103,101,
  104,101,105,103,104,116,2,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tdocure,'');
end.