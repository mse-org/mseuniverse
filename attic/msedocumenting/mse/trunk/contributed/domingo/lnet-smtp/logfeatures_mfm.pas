unit logfeatures_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,logfeatures;

const
 objdata: record size: integer; data: array[0..1181] of byte end =
      (size: 1182; data: (
  84,80,70,48,14,116,108,111,103,102,101,97,116,117,114,101,115,102,111,13,
  108,111,103,102,101,97,116,117,114,101,115,102,111,8,98,111,117,110,100,115,
  95,120,3,165,1,8,98,111,117,110,100,115,95,121,3,211,0,9,98,111,
  117,110,100,115,95,99,120,3,130,1,9,98,111,117,110,100,115,95,99,121,
  3,38,1,8,116,97,98,111,114,100,101,114,2,1,7,118,105,115,105,98,
  108,101,8,23,99,111,110,116,97,105,110,101,114,46,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,
  117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,
  114,111,119,102,111,99,117,115,11,111,119,95,115,117,98,102,111,99,117,115,
  19,111,119,95,109,111,117,115,101,116,114,97,110,115,112,97,114,101,110,116,
  13,111,119,95,109,111,117,115,101,119,104,101,101,108,17,111,119,95,100,101,
  115,116,114,111,121,119,105,100,103,101,116,115,12,111,119,95,97,117,116,111,
  115,99,97,108,101,0,18,99,111,110,116,97,105,110,101,114,46,98,111,117,
  110,100,115,95,120,2,0,18,99,111,110,116,97,105,110,101,114,46,98,111,
  117,110,100,115,95,121,2,0,19,99,111,110,116,97,105,110,101,114,46,98,
  111,117,110,100,115,95,99,120,3,130,1,19,99,111,110,116,97,105,110,101,
  114,46,98,111,117,110,100,115,95,99,121,3,38,1,21,99,111,110,116,97,
  105,110,101,114,46,102,114,97,109,101,46,100,117,109,109,121,2,0,7,99,
  97,112,116,105,111,110,6,12,77,101,115,115,97,103,101,32,76,111,103,115,
  15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,109,
  115,101,102,111,114,109,0,9,116,109,101,109,111,101,100,105,116,8,109,101,
  109,111,76,111,103,115,8,98,111,117,110,100,115,95,120,3,165,0,8,98,
  111,117,110,100,115,95,121,2,10,9,98,111,117,110,100,115,95,99,120,3,
  217,0,9,98,111,117,110,100,115,95,99,121,3,23,1,13,102,114,97,109,
  101,46,99,97,112,116,105,111,110,6,3,76,111,103,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,15,102,114,108,95,99,111,108,
  111,114,99,108,105,101,110,116,0,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,22,2,0,2,0,0,0,0,11,116,115,116,114,105,110,103,
  103,114,105,100,12,103,114,105,100,70,101,97,116,117,114,101,115,13,111,112,
  116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,115,
  101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,111,
  119,95,97,114,114,111,119,102,111,99,117,115,17,111,119,95,102,111,99,117,
  115,98,97,99,107,111,110,101,115,99,13,111,119,95,109,111,117,115,101,119,
  104,101,101,108,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,
  116,115,18,111,119,95,102,111,110,116,103,108,121,112,104,104,101,105,103,104,
  116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,110,
  100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,2,10,9,98,111,
  117,110,100,115,95,99,120,3,154,0,9,98,111,117,110,100,115,95,99,121,
  3,24,1,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,8,70,
  101,97,116,117,114,101,115,11,102,114,97,109,101,46,100,117,109,109,121,2,
  0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,
  0,2,22,2,0,2,0,0,8,116,97,98,111,114,100,101,114,2,1,14,
  100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,1,20,100,97,116,
  97,99,111,108,115,46,99,111,108,111,114,115,101,108,101,99,116,4,9,0,
  0,160,20,100,97,116,97,99,111,108,115,46,99,111,108,111,114,97,99,116,
  105,118,101,4,9,0,0,160,14,100,97,116,97,99,111,108,115,46,105,116,
  101,109,115,14,1,11,99,111,108,111,114,115,101,108,101,99,116,4,9,0,
  0,160,11,99,111,108,111,114,97,99,116,105,118,101,4,9,0,0,160,5,
  119,105,100,116,104,3,149,0,7,111,112,116,105,111,110,115,11,11,99,111,
  95,114,101,97,100,111,110,108,121,14,99,111,95,102,111,99,117,115,115,101,
  108,101,99,116,12,99,111,95,114,111,119,115,101,108,101,99,116,7,99,111,
  95,102,105,108,108,12,99,111,95,115,97,118,101,118,97,108,117,101,12,99,
  111,95,115,97,118,101,115,116,97,116,101,10,99,111,95,114,111,119,102,111,
  110,116,11,99,111,95,114,111,119,99,111,108,111,114,13,99,111,95,122,101,
  98,114,97,99,111,108,111,114,17,99,111,95,114,111,119,99,111,108,111,114,
  97,99,116,105,118,101,17,99,111,95,109,111,117,115,101,115,99,114,111,108,
  108,114,111,119,0,0,0,13,100,97,116,97,114,111,119,104,101,105,103,104,
  116,2,21,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,19,0,
  0,0)
 );

initialization
 registerobjectdata(@objdata,tlogfeaturesfo,'');
end.