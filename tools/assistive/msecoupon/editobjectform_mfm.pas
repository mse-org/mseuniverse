unit editobjectform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,editobjectform;

const
 objdata: record size: integer; data: array[0..820] of byte end =
      (size: 821; data: (
  84,80,70,48,241,13,116,101,100,105,116,111,98,106,101,99,116,102,111,12,
  101,100,105,116,111,98,106,101,99,116,102,111,16,99,111,110,116,97,105,110,
  101,114,46,98,111,117,110,100,115,1,2,0,2,0,3,59,1,3,0,1,
  0,7,99,97,112,116,105,111,110,21,15,0,0,0,76,0,101,0,105,0,
  115,0,116,0,117,0,110,0,103,0,32,0,228,0,110,0,100,0,101,0,
  114,0,110,0,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,
  6,9,116,111,98,106,101,99,116,102,111,0,241,7,116,98,117,116,116,111,
  110,6,102,105,110,105,98,117,8,116,97,98,111,114,100,101,114,2,6,9,
  98,111,117,110,100,115,95,99,120,3,138,0,7,99,97,112,116,105,111,110,
  21,28,0,0,0,71,0,101,0,228,0,110,0,100,0,101,0,114,0,116,
  0,101,0,32,0,76,0,101,0,105,0,115,0,116,0,117,0,110,0,103,
  0,10,0,115,0,112,0,101,0,105,0,99,0,104,0,101,0,114,0,110,
  0,0,0,241,13,116,100,98,115,116,114,105,110,103,101,100,105,116,6,110,
  97,109,101,101,100,16,100,97,116,97,108,105,110,107,46,111,112,116,105,111,
  110,115,11,0,0,0,241,11,116,100,98,114,101,97,108,101,100,105,116,7,
  112,114,105,99,101,101,100,0,0,241,13,116,100,98,115,116,114,105,110,103,
  101,100,105,116,6,117,110,105,116,101,100,0,0,241,13,116,100,98,115,116,
  114,105,110,103,101,100,105,116,13,100,101,115,99,114,105,112,116,105,111,110,
  101,100,11,111,112,116,105,111,110,115,101,100,105,116,11,12,111,101,95,117,
  110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,115,101,113,117,101,
  114,121,16,111,101,95,99,104,101,99,107,109,114,99,97,110,99,101,108,14,
  111,101,95,115,104,105,102,116,114,101,116,117,114,110,12,111,101,95,101,97,
  116,114,101,116,117,114,110,20,111,101,95,114,101,115,101,116,115,101,108,101,
  99,116,111,110,101,120,105,116,15,111,101,95,101,120,105,116,111,110,99,117,
  114,115,111,114,13,111,101,95,101,110,100,111,110,101,110,116,101,114,13,111,
  101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,
  115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,107,22,111,
  101,95,102,111,99,117,115,114,101,99,116,111,110,114,101,97,100,111,110,108,
  121,20,111,101,95,100,105,114,101,99,116,100,98,110,117,108,108,99,104,101,
  99,107,0,0,0,241,19,116,100,98,100,105,97,108,111,103,115,116,114,105,
  110,103,101,100,105,116,9,99,111,109,109,101,110,116,101,100,19,102,114,97,
  109,101,46,98,117,116,116,111,110,115,46,105,116,101,109,115,14,1,0,0,
  8,116,97,98,111,114,100,101,114,2,5,9,98,111,117,110,100,115,95,99,
  120,3,42,1,0,0,241,7,116,98,117,116,116,111,110,8,99,97,110,99,
  101,108,98,117,8,116,97,98,111,114,100,101,114,2,7,8,98,111,117,110,
  100,115,95,120,3,152,0,0,0,241,11,116,100,98,114,101,97,108,101,100,
  105,116,10,100,117,114,97,116,105,111,110,101,100,8,116,97,98,111,114,100,
  101,114,2,4,0,0,241,9,116,115,116,97,116,102,105,108,101,10,116,115,
  116,97,116,102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,14,101,
  100,105,116,111,98,106,101,99,116,46,115,116,97,0,0,241,14,116,109,115,
  101,100,97,116,97,115,111,117,114,99,101,6,100,97,116,97,115,111,0,0,
  0)
 );

initialization
 registerobjectdata(@objdata,teditobjectfo,'');
end.