unit main_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,main;

const
 objdata: record size: integer; data: array[0..2682] of byte end =
      (size: 2683; data: (
  84,80,70,48,7,116,109,97,105,110,102,111,6,109,97,105,110,102,111,8,
  98,111,117,110,100,115,95,120,3,160,0,8,98,111,117,110,100,115,95,121,
  3,246,0,9,98,111,117,110,100,115,95,99,120,3,223,1,9,98,111,117,
  110,100,115,95,99,121,3,181,1,26,99,111,110,116,97,105,110,101,114,46,
  102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,27,99,
  111,110,116,97,105,110,101,114,46,102,114,97,109,101,46,108,111,99,97,108,
  112,114,111,112,115,49,11,0,16,99,111,110,116,97,105,110,101,114,46,98,
  111,117,110,100,115,1,2,0,2,0,3,223,1,3,181,1,0,8,115,116,
  97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,15,109,
  111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,9,116,109,97,105,
  110,102,111,114,109,0,11,116,119,105,100,103,101,116,103,114,105,100,12,116,
  119,105,100,103,101,116,103,114,105,100,49,16,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,49,11,0,8,116,97,98,111,114,100,101,114,2,
  1,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,
  121,3,190,0,9,98,111,117,110,100,115,95,99,120,3,223,1,9,98,111,
  117,110,100,115,95,99,121,3,247,0,7,97,110,99,104,111,114,115,11,6,
  97,110,95,116,111,112,9,97,110,95,98,111,116,116,111,109,0,11,111,112,
  116,105,111,110,115,103,114,105,100,11,19,111,103,95,102,111,99,117,115,99,
  101,108,108,111,110,101,110,116,101,114,15,111,103,95,97,117,116,111,102,105,
  114,115,116,114,111,119,20,111,103,95,99,111,108,99,104,97,110,103,101,111,
  110,116,97,98,107,101,121,10,111,103,95,119,114,97,112,99,111,108,12,111,
  103,95,97,117,116,111,112,111,112,117,112,17,111,103,95,109,111,117,115,101,
  115,99,114,111,108,108,99,111,108,0,13,102,105,120,114,111,119,115,46,99,
  111,117,110,116,2,1,13,102,105,120,114,111,119,115,46,105,116,101,109,115,
  14,1,6,104,101,105,103,104,116,2,16,0,0,11,114,111,119,99,111,117,
  110,116,109,97,120,3,232,3,14,100,97,116,97,99,111,108,115,46,99,111,
  117,110,116,2,1,23,100,97,116,97,99,111,108,115,46,105,110,110,101,114,
  102,114,97,109,101,95,116,111,112,2,0,26,100,97,116,97,99,111,108,115,
  46,105,110,110,101,114,102,114,97,109,101,95,98,111,116,116,111,109,2,0,
  14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,7,4,116,101,
  114,109,1,5,119,105,100,116,104,3,232,3,10,119,105,100,103,101,116,110,
  97,109,101,6,4,116,101,114,109,9,100,97,116,97,99,108,97,115,115,7,
  23,116,103,114,105,100,114,105,99,104,115,116,114,105,110,103,100,97,116,97,
  108,105,115,116,0,0,13,100,97,116,97,114,111,119,104,101,105,103,104,116,
  2,14,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,9,
  116,116,101,114,109,105,110,97,108,4,116,101,114,109,14,111,112,116,105,111,
  110,115,119,105,100,103,101,116,49,11,18,111,119,49,95,102,111,110,116,108,
  105,110,101,104,101,105,103,104,116,0,11,111,112,116,105,111,110,115,115,107,
  105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,116,116,111,110,111,
  110,108,121,0,8,116,97,98,111,114,100,101,114,2,1,7,118,105,115,105,
  98,108,101,8,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,
  100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,232,3,9,
  98,111,117,110,100,115,95,99,121,2,14,11,111,112,116,105,111,110,115,101,
  100,105,116,11,13,111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,
  101,95,99,104,101,99,107,109,114,99,97,110,99,101,108,12,111,101,95,101,
  97,116,114,101,116,117,114,110,15,111,101,95,101,120,105,116,111,110,99,117,
  114,115,111,114,20,111,101,95,110,111,102,105,114,115,116,97,114,114,111,119,
  110,97,118,105,103,18,111,101,95,99,97,114,101,116,111,110,114,101,97,100,
  111,110,108,121,22,111,101,95,102,111,99,117,115,114,101,99,116,111,110,114,
  101,97,100,111,110,108,121,18,111,101,95,104,105,110,116,99,108,105,112,112,
  101,100,116,101,120,116,0,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,14,0,0,0,11,116,115,116,114,105,110,103,103,114,105,100,3,112,
  97,114,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,6,112,97,
  114,97,109,115,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,
  115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,
  49,11,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,17,2,0,2,0,0,8,116,97,98,111,114,100,101,114,2,
  2,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,
  121,2,39,9,98,111,117,110,100,115,95,99,120,3,234,0,9,98,111,117,
  110,100,115,95,99,121,3,147,0,7,97,110,99,104,111,114,115,11,7,97,
  110,95,108,101,102,116,6,97,110,95,116,111,112,9,97,110,95,98,111,116,
  116,111,109,0,11,111,112,116,105,111,110,115,103,114,105,100,11,12,111,103,
  95,99,111,108,115,105,122,105,110,103,12,111,103,95,114,111,119,109,111,118,
  105,110,103,15,111,103,95,107,101,121,114,111,119,109,111,118,105,110,103,15,
  111,103,95,114,111,119,105,110,115,101,114,116,105,110,103,14,111,103,95,114,
  111,119,100,101,108,101,116,105,110,103,19,111,103,95,102,111,99,117,115,99,
  101,108,108,111,110,101,110,116,101,114,15,111,103,95,97,117,116,111,102,105,
  114,115,116,114,111,119,13,111,103,95,97,117,116,111,97,112,112,101,110,100,
  20,111,103,95,99,111,108,99,104,97,110,103,101,111,110,116,97,98,107,101,
  121,10,111,103,95,119,114,97,112,99,111,108,12,111,103,95,97,117,116,111,
  112,111,112,117,112,17,111,103,95,109,111,117,115,101,115,99,114,111,108,108,
  99,111,108,0,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,
  1,14,100,97,116,97,99,111,108,115,46,105,116,101,109,115,14,1,5,119,
  105,100,116,104,3,200,0,10,118,97,108,117,101,102,97,108,115,101,6,1,
  48,9,118,97,108,117,101,116,114,117,101,6,1,49,0,0,13,102,105,120,
  99,111,108,115,46,99,111,117,110,116,2,1,13,102,105,120,99,111,108,115,
  46,105,116,101,109,115,14,1,5,119,105,100,116,104,2,25,7,110,117,109,
  115,116,101,112,2,1,0,0,13,102,105,120,114,111,119,115,46,99,111,117,
  110,116,2,1,13,102,105,120,114,111,119,115,46,105,116,101,109,115,14,1,
  6,104,101,105,103,104,116,2,16,0,0,8,115,116,97,116,102,105,108,101,
  7,10,116,115,116,97,116,102,105,108,101,49,13,114,101,102,102,111,110,116,
  104,101,105,103,104,116,2,14,0,0,11,116,115,116,114,105,110,103,103,114,
  105,100,3,101,110,118,13,102,114,97,109,101,46,99,97,112,116,105,111,110,
  6,7,101,110,118,118,97,114,115,16,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,
  112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,116,101,114,
  102,114,97,109,101,1,2,0,2,17,2,0,2,0,0,8,116,97,98,111,
  114,100,101,114,2,3,8,98,111,117,110,100,115,95,120,3,240,0,8,98,
  111,117,110,100,115,95,121,2,39,9,98,111,117,110,100,115,95,99,120,3,
  234,0,9,98,111,117,110,100,115,95,99,121,3,147,0,7,97,110,99,104,
  111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,9,
  97,110,95,98,111,116,116,111,109,0,11,111,112,116,105,111,110,115,103,114,
  105,100,11,12,111,103,95,99,111,108,115,105,122,105,110,103,12,111,103,95,
  114,111,119,109,111,118,105,110,103,15,111,103,95,107,101,121,114,111,119,109,
  111,118,105,110,103,15,111,103,95,114,111,119,105,110,115,101,114,116,105,110,
  103,14,111,103,95,114,111,119,100,101,108,101,116,105,110,103,19,111,103,95,
  102,111,99,117,115,99,101,108,108,111,110,101,110,116,101,114,15,111,103,95,
  97,117,116,111,102,105,114,115,116,114,111,119,13,111,103,95,97,117,116,111,
  97,112,112,101,110,100,20,111,103,95,99,111,108,99,104,97,110,103,101,111,
  110,116,97,98,107,101,121,10,111,103,95,119,114,97,112,99,111,108,12,111,
  103,95,97,117,116,111,112,111,112,117,112,17,111,103,95,109,111,117,115,101,
  115,99,114,111,108,108,99,111,108,0,14,100,97,116,97,99,111,108,115,46,
  99,111,117,110,116,2,1,14,100,97,116,97,99,111,108,115,46,105,116,101,
  109,115,14,1,5,119,105,100,116,104,3,200,0,10,118,97,108,117,101,102,
  97,108,115,101,6,1,48,9,118,97,108,117,101,116,114,117,101,6,1,49,
  0,0,13,102,105,120,99,111,108,115,46,99,111,117,110,116,2,1,13,102,
  105,120,99,111,108,115,46,105,116,101,109,115,14,1,5,119,105,100,116,104,
  2,25,8,110,117,109,115,116,97,114,116,2,1,7,110,117,109,115,116,101,
  112,2,1,0,0,13,102,105,120,114,111,119,115,46,99,111,117,110,116,2,
  1,13,102,105,120,114,111,119,115,46,105,116,101,109,115,14,1,6,104,101,
  105,103,104,116,2,16,0,0,8,115,116,97,116,102,105,108,101,7,10,116,
  115,116,97,116,102,105,108,101,49,13,114,101,102,102,111,110,116,104,101,105,
  103,104,116,2,14,0,0,7,116,98,117,116,116,111,110,8,116,98,117,116,
  116,111,110,49,8,98,111,117,110,100,115,95,120,3,168,1,8,98,111,117,
  110,100,115,95,121,2,8,9,98,111,117,110,100,115,95,99,120,2,50,9,
  98,111,117,110,100,115,95,99,121,2,20,5,115,116,97,116,101,11,15,97,
  115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,
  99,97,108,111,110,101,120,101,99,117,116,101,0,7,99,97,112,116,105,111,
  110,6,4,101,120,101,99,9,111,110,101,120,101,99,117,116,101,7,3,101,
  120,101,0,0,12,116,98,111,111,108,101,97,110,101,100,105,116,5,115,104,
  101,108,108,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,5,115,
  104,101,108,108,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,
  115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,
  49,11,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,
  1,2,0,2,1,2,32,2,2,0,8,116,97,98,111,114,100,101,114,2,
  4,8,98,111,117,110,100,115,95,120,2,16,8,98,111,117,110,100,115,95,
  121,2,15,9,98,111,117,110,100,115,95,99,120,2,45,9,98,111,117,110,
  100,115,95,99,121,2,16,8,115,116,97,116,102,105,108,101,7,10,116,115,
  116,97,116,102,105,108,101,49,0,0,11,116,109,115,101,112,114,111,99,101,
  115,115,4,112,114,111,99,4,108,101,102,116,3,200,0,3,116,111,112,3,
  0,1,0,0,9,116,115,116,97,116,102,105,108,101,10,116,115,116,97,116,
  102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,10,115,116,97,116,
  117,115,46,115,116,97,4,108,101,102,116,2,88,3,116,111,112,3,0,1,
  0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmainfo,'');
end.