unit main_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,main;

const
 objdata: record size: integer; data: array[0..2666] of byte end =
      (size: 2667; data: (
  84,80,70,48,7,116,109,97,105,110,102,111,6,109,97,105,110,102,111,8,
  98,111,117,110,100,115,95,120,2,53,8,98,111,117,110,100,115,95,121,3,
  238,0,9,98,111,117,110,100,115,95,99,120,3,219,0,9,98,111,117,110,
  100,115,95,99,121,3,4,1,26,99,111,110,116,97,105,110,101,114,46,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,27,99,111,
  110,116,97,105,110,101,114,46,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,49,11,0,16,99,111,110,116,97,105,110,101,114,46,98,111,
  117,110,100,115,1,2,0,2,0,3,219,0,3,4,1,0,13,111,112,116,
  105,111,110,115,119,105,110,100,111,119,11,14,119,111,95,103,114,111,117,112,
  108,101,97,100,101,114,0,7,111,112,116,105,111,110,115,11,7,102,111,95,
  109,97,105,110,19,102,111,95,116,101,114,109,105,110,97,116,101,111,110,99,
  108,111,115,101,15,102,111,95,97,117,116,111,114,101,97,100,115,116,97,116,
  16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,10,102,111,
  95,115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,115,116,97,116,
  101,0,8,115,116,97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,
  108,101,49,7,99,97,112,116,105,111,110,6,13,77,83,69,103,117,105,32,
  79,112,101,110,71,76,13,119,105,110,100,111,119,111,112,97,99,105,116,121,
  5,0,0,0,0,0,0,0,128,255,255,6,111,110,115,104,111,119,7,7,
  115,104,111,119,101,120,101,15,109,111,100,117,108,101,99,108,97,115,115,110,
  97,109,101,6,8,116,109,115,101,102,111,114,109,0,13,116,111,112,101,110,
  103,108,119,105,100,103,101,116,12,111,112,101,110,103,108,119,105,100,103,101,
  116,12,102,114,97,109,101,46,108,101,118,101,108,105,2,255,17,102,114,97,
  109,101,46,102,114,97,109,101,105,95,108,101,102,116,2,10,16,102,114,97,
  109,101,46,102,114,97,109,101,105,95,116,111,112,2,10,18,102,114,97,109,
  101,46,102,114,97,109,101,105,95,114,105,103,104,116,2,10,19,102,114,97,
  109,101,46,102,114,97,109,101,105,95,98,111,116,116,111,109,2,10,16,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,
  95,108,101,118,101,108,105,10,102,114,108,95,102,105,108,101,102,116,9,102,
  114,108,95,102,105,116,111,112,11,102,114,108,95,102,105,114,105,103,104,116,
  12,102,114,108,95,102,105,98,111,116,116,111,109,0,17,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,49,11,0,8,116,97,98,111,114,
  100,101,114,2,4,8,98,111,117,110,100,115,95,120,2,8,8,98,111,117,
  110,100,115,95,121,2,8,9,98,111,117,110,100,115,95,99,120,3,202,0,
  9,98,111,117,110,100,115,95,99,121,3,166,0,7,97,110,99,104,111,114,
  115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,
  95,114,105,103,104,116,9,97,110,95,98,111,116,116,111,109,0,8,111,110,
  114,101,110,100,101,114,7,9,114,101,110,100,101,114,101,120,101,6,102,112,
  115,109,97,120,2,1,13,111,110,99,114,101,97,116,101,119,105,110,105,100,
  7,14,99,114,101,97,116,101,119,105,110,105,100,101,120,101,19,111,110,99,
  108,105,101,110,116,114,101,99,116,99,104,97,110,103,101,100,7,20,99,108,
  105,101,110,116,114,101,99,116,99,104,97,110,103,101,100,101,120,101,0,0,
  9,116,114,101,97,108,101,100,105,116,4,114,111,116,121,13,102,114,97,109,
  101,46,99,97,112,116,105,111,110,6,4,114,111,116,121,16,102,114,97,109,
  101,46,99,97,112,116,105,111,110,112,111,115,7,8,99,112,95,114,105,103,
  104,116,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,
  0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,
  0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,
  0,2,0,2,24,2,0,0,8,116,97,98,111,114,100,101,114,2,1,8,
  98,111,117,110,100,115,95,120,2,10,8,98,111,117,110,100,115,95,121,3,
  207,0,9,98,111,117,110,100,115,95,99,120,2,76,9,98,111,117,110,100,
  115,95,99,121,2,22,7,97,110,99,104,111,114,115,11,7,97,110,95,108,
  101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,115,116,97,116,102,
  105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,13,111,110,100,97,
  116,97,101,110,116,101,114,101,100,7,9,114,111,116,101,110,116,101,120,101,
  5,118,97,108,117,101,5,205,204,204,204,204,204,204,204,252,63,12,118,97,
  108,117,101,100,101,102,97,117,108,116,5,0,0,0,0,0,0,0,128,255,
  255,10,118,97,108,117,101,114,97,110,103,101,2,1,10,118,97,108,117,101,
  115,116,97,114,116,2,0,8,118,97,108,117,101,109,105,110,5,0,0,0,
  0,0,0,0,128,255,255,8,118,97,108,117,101,109,97,120,5,244,136,13,
  181,80,153,118,150,125,64,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,16,0,0,9,116,114,101,97,108,101,100,105,116,3,102,112,115,13,
  102,114,97,109,101,46,99,97,112,116,105,111,110,6,6,102,112,115,109,97,
  120,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,8,
  99,112,95,114,105,103,104,116,16,102,114,97,109,101,46,108,111,99,97,108,
  112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,116,101,114,102,
  114,97,109,101,1,2,0,2,0,2,45,2,0,0,8,116,97,98,111,114,
  100,101,114,2,3,8,98,111,117,110,100,115,95,120,2,98,8,98,111,117,
  110,100,115,95,121,3,183,0,9,98,111,117,110,100,115,95,99,120,2,97,
  9,98,111,117,110,100,115,95,99,121,2,22,7,97,110,99,104,111,114,115,
  11,7,97,110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,
  8,115,116,97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,
  49,10,111,110,115,101,116,118,97,108,117,101,7,11,102,112,115,115,101,116,
  118,97,108,117,101,5,118,97,108,117,101,2,30,12,118,97,108,117,101,100,
  101,102,97,117,108,116,5,0,0,0,0,0,0,0,128,255,255,10,118,97,
  108,117,101,114,97,110,103,101,2,1,10,118,97,108,117,101,115,116,97,114,
  116,2,0,8,118,97,108,117,101,109,105,110,2,255,8,118,97,108,117,101,
  109,97,120,5,244,136,13,181,80,153,118,150,125,64,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,16,0,0,9,116,114,101,97,108,101,100,
  105,116,4,114,111,116,120,13,102,114,97,109,101,46,99,97,112,116,105,111,
  110,6,4,114,111,116,120,16,102,114,97,109,101,46,99,97,112,116,105,111,
  110,112,111,115,7,8,99,112,95,114,105,103,104,116,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,
  108,111,99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,
  111,117,116,101,114,102,114,97,109,101,1,2,0,2,0,2,24,2,0,0,
  8,98,111,117,110,100,115,95,120,2,10,8,98,111,117,110,100,115,95,121,
  3,183,0,9,98,111,117,110,100,115,95,99,120,2,76,9,98,111,117,110,
  100,115,95,99,121,2,22,7,97,110,99,104,111,114,115,11,7,97,110,95,
  108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,115,116,97,116,
  102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,13,111,110,100,
  97,116,97,101,110,116,101,114,101,100,7,9,114,111,116,101,110,116,101,120,
  101,5,118,97,108,117,101,5,205,204,204,204,204,204,204,204,251,63,12,118,
  97,108,117,101,100,101,102,97,117,108,116,5,0,0,0,0,0,0,0,128,
  255,255,10,118,97,108,117,101,114,97,110,103,101,2,1,10,118,97,108,117,
  101,115,116,97,114,116,2,0,8,118,97,108,117,101,109,105,110,5,0,0,
  0,0,0,0,0,128,255,255,8,118,97,108,117,101,109,97,120,5,244,136,
  13,181,80,153,118,150,125,64,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,16,0,0,9,116,114,101,97,108,100,105,115,112,7,102,112,115,
  100,105,115,112,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,3,
  102,112,115,16,102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,
  7,8,99,112,95,114,105,103,104,116,16,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,116,101,
  114,102,114,97,109,101,1,2,0,2,0,2,21,2,0,0,8,116,97,98,
  111,114,100,101,114,2,5,8,98,111,117,110,100,115,95,120,2,98,8,98,
  111,117,110,100,115,95,121,3,207,0,9,98,111,117,110,100,115,95,99,120,
  2,73,7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,9,
  97,110,95,98,111,116,116,111,109,0,10,118,97,108,117,101,114,97,110,103,
  101,2,1,10,118,97,108,117,101,115,116,97,114,116,2,0,6,102,111,114,
  109,97,116,6,4,48,46,48,48,5,118,97,108,117,101,5,0,0,0,0,
  0,0,0,128,255,255,13,114,101,102,102,111,110,116,104,101,105,103,104,116,
  2,16,0,0,9,116,114,101,97,108,101,100,105,116,4,114,111,116,122,13,
  102,114,97,109,101,46,99,97,112,116,105,111,110,6,4,114,111,116,122,16,
  102,114,97,109,101,46,99,97,112,116,105,111,110,112,111,115,7,8,99,112,
  95,114,105,103,104,116,16,102,114,97,109,101,46,108,111,99,97,108,112,114,
  111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,
  112,115,49,11,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,
  109,101,1,2,0,2,0,2,25,2,0,0,8,116,97,98,111,114,100,101,
  114,2,2,8,98,111,117,110,100,115,95,120,2,10,8,98,111,117,110,100,
  115,95,121,3,231,0,9,98,111,117,110,100,115,95,99,120,2,77,9,98,
  111,117,110,100,115,95,99,121,2,22,7,97,110,99,104,111,114,115,11,7,
  97,110,95,108,101,102,116,9,97,110,95,98,111,116,116,111,109,0,8,115,
  116,97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,13,
  111,110,100,97,116,97,101,110,116,101,114,101,100,7,9,114,111,116,101,110,
  116,101,120,101,5,118,97,108,117,101,5,154,153,153,153,153,153,153,153,253,
  63,12,118,97,108,117,101,100,101,102,97,117,108,116,5,0,0,0,0,0,
  0,0,128,255,255,10,118,97,108,117,101,114,97,110,103,101,2,1,10,118,
  97,108,117,101,115,116,97,114,116,2,0,8,118,97,108,117,101,109,105,110,
  5,0,0,0,0,0,0,0,128,255,255,8,118,97,108,117,101,109,97,120,
  5,244,136,13,181,80,153,118,150,125,64,13,114,101,102,102,111,110,116,104,
  101,105,103,104,116,2,16,0,0,9,116,115,116,97,116,102,105,108,101,10,
  116,115,116,97,116,102,105,108,101,49,8,102,105,108,101,110,97,109,101,6,
  10,115,116,97,116,117,115,46,115,116,97,4,108,101,102,116,2,24,3,116,
  111,112,2,24,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmainfo,'');
end.