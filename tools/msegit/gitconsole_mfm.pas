unit gitconsole_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,gitconsole;

const
 objdata: record size: integer; data: array[0..1368] of byte end =
      (size: 1369; data: (
  84,80,70,48,13,116,103,105,116,99,111,110,115,111,108,101,102,111,12,103,
  105,116,99,111,110,115,111,108,101,102,111,15,102,114,97,109,101,46,103,114,
  105,112,95,115,105,122,101,2,10,11,102,114,97,109,101,46,100,117,109,109,
  121,2,0,7,118,105,115,105,98,108,101,8,8,98,111,117,110,100,115,95,
  120,2,100,8,98,111,117,110,100,115,95,121,2,100,9,98,111,117,110,100,
  115,95,99,120,3,189,1,9,98,111,117,110,100,115,95,99,121,3,98,1,
  29,99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,46,122,111,111,
  109,119,105,100,116,104,115,116,101,112,2,1,30,99,111,110,116,97,105,110,
  101,114,46,102,114,97,109,101,46,122,111,111,109,104,101,105,103,104,116,115,
  116,101,112,2,1,16,99,111,110,116,97,105,110,101,114,46,98,111,117,110,
  100,115,1,2,0,2,0,3,179,1,3,98,1,0,20,100,114,97,103,100,
  111,99,107,46,111,112,116,105,111,110,115,100,111,99,107,11,10,111,100,95,
  115,97,118,101,112,111,115,13,111,100,95,115,97,118,101,122,111,114,100,101,
  114,15,111,100,95,115,97,118,101,99,104,105,108,100,114,101,110,10,111,100,
  95,99,97,110,109,111,118,101,11,111,100,95,99,97,110,102,108,111,97,116,
  10,111,100,95,99,97,110,100,111,99,107,11,111,100,95,112,114,111,112,115,
  105,122,101,0,8,115,116,97,116,102,105,108,101,7,14,109,97,105,110,102,
  111,46,102,111,114,109,115,116,97,7,99,97,112,116,105,111,110,6,11,71,
  105,116,32,67,111,110,115,111,108,101,15,109,111,100,117,108,101,99,108,97,
  115,115,110,97,109,101,6,9,116,100,111,99,107,102,111,114,109,0,11,116,
  115,116,114,105,110,103,100,105,115,112,7,100,105,114,100,105,115,112,11,102,
  114,97,109,101,46,100,117,109,109,121,2,0,8,98,111,117,110,100,115,95,
  120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,
  115,95,99,120,3,179,1,9,98,111,117,110,100,115,95,99,121,2,18,7,
  97,110,99,104,111,114,115,11,6,97,110,95,116,111,112,0,13,114,101,102,
  102,111,110,116,104,101,105,103,104,116,2,14,0,0,11,116,119,105,100,103,
  101,116,103,114,105,100,4,103,114,105,100,8,116,97,98,111,114,100,101,114,
  2,1,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,
  95,121,2,18,9,98,111,117,110,100,115,95,99,120,3,179,1,9,98,111,
  117,110,100,115,95,99,121,3,80,1,7,97,110,99,104,111,114,115,11,7,
  97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,95,114,105,
  103,104,116,9,97,110,95,98,111,116,116,111,109,0,11,111,112,116,105,111,
  110,115,103,114,105,100,11,19,111,103,95,102,111,99,117,115,99,101,108,108,
  111,110,101,110,116,101,114,15,111,103,95,97,117,116,111,102,105,114,115,116,
  114,111,119,20,111,103,95,99,111,108,99,104,97,110,103,101,111,110,116,97,
  98,107,101,121,10,111,103,95,119,114,97,112,99,111,108,12,111,103,95,97,
  117,116,111,112,111,112,117,112,17,111,103,95,109,111,117,115,101,115,99,114,
  111,108,108,99,111,108,0,11,114,111,119,99,111,117,110,116,109,97,120,3,
  16,39,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,1,14,
  100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,100,
  116,104,3,232,3,10,119,105,100,103,101,116,110,97,109,101,6,6,116,101,
  114,109,101,100,9,100,97,116,97,99,108,97,115,115,7,23,116,103,114,105,
  100,114,105,99,104,115,116,114,105,110,103,100,97,116,97,108,105,115,116,0,
  0,16,100,97,116,97,114,111,119,108,105,110,101,119,105,100,116,104,2,0,
  13,100,97,116,97,114,111,119,104,101,105,103,104,116,2,16,13,114,101,102,
  102,111,110,116,104,101,105,103,104,116,2,14,0,9,116,116,101,114,109,105,
  110,97,108,6,116,101,114,109,101,100,13,111,112,116,105,111,110,115,119,105,
  100,103,101,116,11,13,111,119,95,109,111,117,115,101,102,111,99,117,115,11,
  111,119,95,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,
  102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,17,111,119,95,102,111,110,116,108,105,110,101,104,101,105,103,104,
  116,12,111,119,95,97,117,116,111,115,99,97,108,101,0,11,111,112,116,105,
  111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,
  116,116,111,110,111,110,108,121,0,8,116,97,98,111,114,100,101,114,2,1,
  7,118,105,115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,2,0,
  8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,
  120,3,232,3,9,98,111,117,110,100,115,95,99,121,2,16,9,102,111,110,
  116,46,110,97,109,101,6,9,115,116,102,95,102,105,120,101,100,11,102,111,
  110,116,46,120,115,99,97,108,101,2,1,10,102,111,110,116,46,100,117,109,
  109,121,2,0,17,109,97,120,99,111,109,109,97,110,100,104,105,115,116,111,
  114,121,2,100,14,111,110,112,114,111,99,102,105,110,105,115,104,101,100,7,
  9,112,114,111,99,102,105,101,120,101,10,111,110,115,101,110,100,116,101,120,
  116,7,11,115,101,110,100,116,101,120,116,101,120,101,14,111,112,116,105,111,
  110,115,112,114,111,99,101,115,115,11,10,112,114,111,95,111,117,116,112,117,
  116,9,112,114,111,95,105,110,112,117,116,17,112,114,111,95,101,114,114,111,
  114,111,117,116,116,111,111,117,116,7,112,114,111,95,116,116,121,20,112,114,
  111,95,110,111,119,97,105,116,102,111,114,112,105,112,101,101,111,102,9,112,
  114,111,95,99,116,114,108,99,0,13,114,101,102,102,111,110,116,104,101,105,
  103,104,116,2,15,0,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tgitconsolefo,'');
end.