unit main_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,main;

const
 objdata: record size: integer; data: array[0..415] of byte end =
      (size: 416; data: (
  84,80,70,48,7,116,109,97,105,110,102,111,6,109,97,105,110,102,111,8,
  98,111,117,110,100,115,95,120,3,35,1,8,98,111,117,110,100,115,95,121,
  3,247,0,9,98,111,117,110,100,115,95,99,120,3,196,0,9,98,111,117,
  110,100,115,95,99,121,2,106,16,99,111,110,116,97,105,110,101,114,46,98,
  111,117,110,100,115,1,2,0,2,0,3,196,0,2,106,0,13,111,112,116,
  105,111,110,115,119,105,110,100,111,119,11,14,119,111,95,103,114,111,117,112,
  108,101,97,100,101,114,0,7,111,112,116,105,111,110,115,11,7,102,111,95,
  109,97,105,110,19,102,111,95,116,101,114,109,105,110,97,116,101,111,110,99,
  108,111,115,101,15,102,111,95,97,117,116,111,114,101,97,100,115,116,97,116,
  16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,10,102,111,
  95,115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,115,116,97,116,
  101,0,7,99,97,112,116,105,111,110,6,15,71,114,111,117,112,115,117,109,
  32,82,101,112,111,114,116,15,109,111,100,117,108,101,99,108,97,115,115,110,
  97,109,101,6,8,116,109,115,101,102,111,114,109,0,7,116,98,117,116,116,
  111,110,8,116,98,117,116,116,111,110,49,8,98,111,117,110,100,115,95,120,
  2,72,8,98,111,117,110,100,115,95,121,2,40,9,98,111,117,110,100,115,
  95,99,120,2,50,9,98,111,117,110,100,115,95,99,121,2,19,5,115,116,
  97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,
  17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,7,
  99,97,112,116,105,111,110,6,3,82,117,110,9,111,110,101,120,101,99,117,
  116,101,7,9,114,117,110,114,101,112,111,114,116,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmainfo,'');
end.