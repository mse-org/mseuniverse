unit stashform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,stashform;

const
 objdata: record size: integer; data: array[0..2233] of byte end =
      (size: 2234; data: (
  84,80,70,48,241,8,116,115,116,97,115,104,102,111,7,115,116,97,115,104,
  102,111,8,98,111,117,110,100,115,95,120,2,100,8,98,111,117,110,100,115,
  95,121,2,100,16,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,
  115,1,2,0,2,0,3,179,1,3,98,1,0,7,99,97,112,116,105,111,
  110,6,7,83,116,97,115,104,101,115,15,109,111,100,117,108,101,99,108,97,
  115,115,110,97,109,101,6,7,116,100,105,115,112,102,111,0,242,2,0,11,
  116,119,105,100,103,101,116,103,114,105,100,9,115,116,97,115,104,103,114,105,
  100,9,112,111,112,117,112,109,101,110,117,7,11,116,112,111,112,117,112,109,
  101,110,117,49,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,
  100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,179,1,9,
  98,111,117,110,100,115,95,99,121,3,98,1,7,97,110,99,104,111,114,115,
  11,0,11,111,112,116,105,111,110,115,103,114,105,100,11,12,111,103,95,99,
  111,108,115,105,122,105,110,103,19,111,103,95,102,111,99,117,115,99,101,108,
  108,111,110,101,110,116,101,114,20,111,103,95,99,111,108,99,104,97,110,103,
  101,111,110,116,97,98,107,101,121,10,111,103,95,119,114,97,112,99,111,108,
  17,111,103,95,109,111,117,115,101,115,99,114,111,108,108,99,111,108,0,14,
  100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,2,21,100,97,116,
  97,99,111,108,115,46,99,111,108,111,114,102,111,99,117,115,101,100,4,7,
  0,0,144,16,100,97,116,97,99,111,108,115,46,111,112,116,105,111,110,115,
  11,15,99,111,95,112,114,111,112,111,114,116,105,111,110,97,108,12,99,111,
  95,115,97,118,101,115,116,97,116,101,17,99,111,95,109,111,117,115,101,115,
  99,114,111,108,108,114,111,119,0,14,100,97,116,97,99,111,108,115,46,105,
  116,101,109,115,14,1,12,99,111,108,111,114,102,111,99,117,115,101,100,4,
  7,0,0,144,5,119,105,100,116,104,2,120,7,111,112,116,105,111,110,115,
  11,11,99,111,95,114,101,97,100,111,110,108,121,15,99,111,95,112,114,111,
  112,111,114,116,105,111,110,97,108,12,99,111,95,115,97,118,101,115,116,97,
  116,101,17,99,111,95,109,111,117,115,101,115,99,114,111,108,108,114,111,119,
  0,10,119,105,100,103,101,116,110,97,109,101,6,7,115,116,97,115,104,101,
  100,9,100,97,116,97,99,108,97,115,115,7,22,116,103,114,105,100,109,115,
  101,115,116,114,105,110,103,100,97,116,97,108,105,115,116,0,1,12,99,111,
  108,111,114,102,111,99,117,115,101,100,4,7,0,0,144,5,119,105,100,116,
  104,3,53,1,7,111,112,116,105,111,110,115,11,11,99,111,95,114,101,97,
  100,111,110,108,121,7,99,111,95,102,105,108,108,12,99,111,95,115,97,118,
  101,115,116,97,116,101,17,99,111,95,109,111,117,115,101,115,99,114,111,108,
  108,114,111,119,0,10,119,105,100,103,101,116,110,97,109,101,6,9,109,101,
  115,115,97,103,101,101,100,9,100,97,116,97,99,108,97,115,115,7,22,116,
  103,114,105,100,109,115,101,115,116,114,105,110,103,100,97,116,97,108,105,115,
  116,0,0,13,100,97,116,97,114,111,119,104,101,105,103,104,116,2,16,8,
  115,116,97,116,102,105,108,101,7,14,109,97,105,110,102,111,46,102,111,114,
  109,115,116,97,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,
  0,11,116,115,116,114,105,110,103,101,100,105,116,7,115,116,97,115,104,101,
  100,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,
  109,111,117,115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,
  117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,
  100,101,115,116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,
  110,116,103,108,121,112,104,104,101,105,103,104,116,0,11,111,112,116,105,111,
  110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,116,
  116,111,110,111,110,108,121,0,8,116,97,98,111,114,100,101,114,2,1,7,
  118,105,115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,2,0,8,
  98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,
  2,120,9,98,111,117,110,100,115,95,99,121,2,16,11,111,112,116,105,111,
  110,115,101,100,105,116,11,11,111,101,95,114,101,97,100,111,110,108,121,12,
  111,101,95,117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,115,
  101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,97,110,
  99,101,108,14,111,101,95,115,104,105,102,116,114,101,116,117,114,110,12,111,
  101,95,101,97,116,114,101,116,117,114,110,20,111,101,95,114,101,115,101,116,
  115,101,108,101,99,116,111,110,101,120,105,116,15,111,101,95,101,120,105,116,
  111,110,99,117,114,115,111,114,13,111,101,95,101,110,100,111,110,101,110,116,
  101,114,13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,
  97,117,116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,
  99,107,22,111,101,95,102,111,99,117,115,114,101,99,116,111,110,114,101,97,
  100,111,110,108,121,18,111,101,95,104,105,110,116,99,108,105,112,112,101,100,
  116,101,120,116,13,111,101,95,107,101,121,101,120,101,99,117,116,101,25,111,
  101,95,99,104,101,99,107,118,97,108,117,101,112,97,115,116,115,116,97,116,
  114,101,97,100,12,111,101,95,115,97,118,101,115,116,97,116,101,0,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,11,116,115,116,
  114,105,110,103,101,100,105,116,9,109,101,115,115,97,103,101,101,100,13,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,
  115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,
  111,119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,100,101,115,
  116,114,111,121,119,105,100,103,101,116,115,18,111,119,95,102,111,110,116,103,
  108,121,112,104,104,101,105,103,104,116,0,11,111,112,116,105,111,110,115,115,
  107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,116,116,111,110,
  111,110,108,121,0,8,116,97,98,111,114,100,101,114,2,2,7,118,105,115,
  105,98,108,101,8,8,98,111,117,110,100,115,95,120,2,121,8,98,111,117,
  110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,53,1,
  9,98,111,117,110,100,115,95,99,121,2,16,11,111,112,116,105,111,110,115,
  101,100,105,116,11,11,111,101,95,114,101,97,100,111,110,108,121,12,111,101,
  95,117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,115,101,113,
  117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,97,110,99,101,
  108,14,111,101,95,115,104,105,102,116,114,101,116,117,114,110,12,111,101,95,
  101,97,116,114,101,116,117,114,110,20,111,101,95,114,101,115,101,116,115,101,
  108,101,99,116,111,110,101,120,105,116,15,111,101,95,101,120,105,116,111,110,
  99,117,114,115,111,114,13,111,101,95,101,110,100,111,110,101,110,116,101,114,
  13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,117,
  116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,107,
  22,111,101,95,102,111,99,117,115,114,101,99,116,111,110,114,101,97,100,111,
  110,108,121,18,111,101,95,104,105,110,116,99,108,105,112,112,101,100,116,101,
  120,116,13,111,101,95,107,101,121,101,120,101,99,117,116,101,25,111,101,95,
  99,104,101,99,107,118,97,108,117,101,112,97,115,116,115,116,97,116,114,101,
  97,100,12,111,101,95,115,97,118,101,115,116,97,116,101,0,13,114,101,102,
  102,111,110,116,104,101,105,103,104,116,2,14,0,0,0,243,2,1,7,116,
  97,99,116,105,111,110,13,114,101,112,111,108,111,97,100,101,100,97,99,116,
  0,0,243,2,2,7,116,97,99,116,105,111,110,13,114,101,112,111,99,108,
  111,115,101,100,97,99,116,0,0,242,2,3,10,116,112,111,112,117,112,109,
  101,110,117,11,116,112,111,112,117,112,109,101,110,117,49,8,111,110,117,112,
  100,97,116,101,7,11,117,112,100,97,116,97,112,111,112,117,112,18,109,101,
  110,117,46,115,117,98,109,101,110,117,46,99,111,117,110,116,2,3,18,109,
  101,110,117,46,115,117,98,109,101,110,117,46,105,116,101,109,115,14,1,7,
  99,97,112,116,105,111,110,6,6,38,65,112,112,108,121,5,115,116,97,116,
  101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,
  115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,9,111,110,
  101,120,101,99,117,116,101,7,8,97,112,112,108,121,101,120,101,0,1,7,
  99,97,112,116,105,111,110,6,5,38,68,114,111,112,5,115,116,97,116,101,
  11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,
  95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,9,111,110,101,
  120,101,99,117,116,101,7,7,100,114,111,112,101,120,101,0,1,7,99,97,
  112,116,105,111,110,6,6,38,67,108,101,97,114,5,115,116,97,116,101,11,
  15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,
  108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,9,111,110,101,120,
  101,99,117,116,101,7,8,99,108,101,97,114,101,120,101,0,0,4,108,101,
  102,116,2,48,3,116,111,112,3,144,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tstashfo,'');
end.