unit reportik_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,reportik;

const
 objdata: record size: integer; data: array[0..4081] of byte end =
      (size: 4082; data: (
  84,80,70,48,11,116,114,101,112,111,114,116,105,107,114,101,10,114,101,112,
  111,114,116,105,107,114,101,4,112,112,109,109,2,3,9,112,97,103,101,119,
  105,100,116,104,3,190,0,10,112,97,103,101,104,101,105,103,104,116,3,14,
  1,11,102,111,110,116,46,104,101,105,103,104,116,2,14,9,102,111,110,116,
  46,110,97,109,101,6,10,115,116,102,95,114,101,112,111,114,116,15,102,111,
  110,116,46,108,111,99,97,108,112,114,111,112,115,11,0,9,103,114,105,100,
  95,115,105,122,101,2,2,7,111,112,116,105,111,110,115,11,15,114,101,111,
  95,97,117,116,111,114,101,108,101,97,115,101,11,114,101,111,95,112,114,101,
  112,97,115,115,0,14,111,110,98,101,102,111,114,101,114,101,110,100,101,114,
  7,12,98,101,102,111,114,101,114,101,110,100,101,114,13,114,101,112,100,101,
  115,105,103,110,105,110,102,111,1,2,51,2,75,3,60,3,3,94,2,0,
  15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,7,116,114,
  101,112,111,114,116,0,11,116,114,101,112,111,114,116,112,97,103,101,12,116,
  114,101,112,111,114,116,112,97,103,101,49,9,112,97,103,101,119,105,100,116,
  104,3,190,0,10,112,97,103,101,104,101,105,103,104,116,3,14,1,0,9,
  116,98,97,110,100,97,114,101,97,10,116,98,97,110,100,97,114,101,97,49,
  8,98,111,117,110,100,115,95,120,2,54,8,98,111,117,110,100,115,95,121,
  2,12,9,98,111,117,110,100,115,95,99,120,3,184,1,9,98,111,117,110,
  100,115,95,99,121,3,14,3,0,11,116,114,101,99,111,114,100,98,97,110,
  100,8,98,97,110,100,68,97,116,97,19,102,114,97,109,101,46,102,114,97,
  109,101,105,95,98,111,116,116,111,109,2,2,16,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,102,105,108,101,102,
  116,12,102,114,108,95,102,105,98,111,116,116,111,109,0,17,102,114,97,109,
  101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,8,98,111,117,110,
  100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,3,138,0,9,98,
  111,117,110,100,115,95,99,120,3,184,1,9,98,111,117,110,100,115,95,99,
  121,3,82,1,12,98,111,117,110,100,115,95,99,121,109,105,110,2,15,12,
  111,112,116,105,111,110,115,115,99,97,108,101,11,11,111,115,99,95,101,120,
  112,97,110,100,121,11,111,115,99,95,115,104,114,105,110,107,121,0,11,102,
  111,110,116,46,104,101,105,103,104,116,2,14,9,102,111,110,116,46,110,97,
  109,101,6,10,115,116,102,95,114,101,112,111,114,116,15,102,111,110,116,46,
  108,111,99,97,108,112,114,111,112,115,11,0,10,116,97,98,115,46,99,111,
  117,110,116,2,2,18,116,97,98,115,46,108,105,116,111,112,95,119,105,100,
  116,104,109,109,5,205,204,204,204,204,204,204,204,251,63,19,116,97,98,115,
  46,108,105,108,101,102,116,95,119,105,100,116,104,109,109,5,205,204,204,204,
  204,204,204,204,251,63,19,116,97,98,115,46,108,105,118,101,114,116,95,119,
  105,100,116,104,109,109,5,205,204,204,204,204,204,204,204,251,63,20,116,97,
  98,115,46,108,105,114,105,103,104,116,95,119,105,100,116,104,109,109,5,205,
  204,204,204,204,204,204,204,251,63,21,116,97,98,115,46,108,105,98,111,116,
  116,111,109,95,119,105,100,116,104,109,109,5,205,204,204,204,204,204,204,204,
  251,63,13,116,97,98,115,46,100,105,115,116,108,101,102,116,2,0,14,116,
  97,98,115,46,100,105,115,116,114,105,103,104,116,2,0,15,116,97,98,115,
  46,108,105,110,107,115,111,117,114,99,101,7,10,98,97,110,100,72,101,97,
  100,101,114,16,116,97,98,115,46,100,101,102,97,117,108,116,100,105,115,116,
  2,0,10,116,97,98,115,46,105,116,101,109,115,14,1,3,112,111,115,2,
  0,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,121,99,101,110,
  116,101,114,101,100,12,116,102,95,119,111,114,100,98,114,101,97,107,13,116,
  102,95,115,111,102,116,104,121,112,104,101,110,0,9,100,97,116,97,102,105,
  101,108,100,6,7,102,108,100,77,101,109,111,10,100,97,116,97,115,111,117,
  114,99,101,7,9,109,97,105,110,102,111,46,100,115,13,108,105,116,111,112,
  95,119,105,100,116,104,109,109,2,0,14,108,105,118,101,114,116,95,119,105,
  100,116,104,109,109,5,205,204,204,204,204,204,204,204,251,63,16,108,105,98,
  111,116,116,111,109,95,119,105,100,116,104,109,109,2,0,8,100,105,115,116,
  108,101,102,116,2,1,9,100,105,115,116,114,105,103,104,116,2,1,0,1,
  3,112,111,115,2,49,9,116,101,120,116,102,108,97,103,115,11,12,116,102,
  95,120,99,101,110,116,101,114,101,100,12,116,102,95,121,99,101,110,116,101,
  114,101,100,0,9,100,97,116,97,102,105,101,108,100,6,8,102,108,100,70,
  108,111,97,116,10,100,97,116,97,115,111,117,114,99,101,7,9,109,97,105,
  110,102,111,46,100,115,13,108,105,116,111,112,95,119,105,100,116,104,109,109,
  2,0,14,108,105,118,101,114,116,95,119,105,100,116,104,109,109,5,205,204,
  204,204,204,204,204,204,251,63,16,108,105,98,111,116,116,111,109,95,119,105,
  100,116,104,109,109,2,0,8,100,105,115,116,108,101,102,116,2,0,9,100,
  105,115,116,114,105,103,104,116,2,0,0,0,10,100,97,116,97,115,111,117,
  114,99,101,7,9,109,97,105,110,102,111,46,100,115,14,111,110,98,101,102,
  111,114,101,114,101,110,100,101,114,7,10,100,97,116,97,114,101,110,100,101,
  114,0,0,11,116,114,101,99,111,114,100,98,97,110,100,10,98,97,110,100,
  72,101,97,100,101,114,19,102,114,97,109,101,46,102,114,97,109,101,105,95,
  98,111,116,116,111,109,2,2,16,102,114,97,109,101,46,108,111,99,97,108,
  112,114,111,112,115,11,9,102,114,108,95,102,105,116,111,112,12,102,114,108,
  95,102,105,98,111,116,116,111,109,0,17,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,49,11,0,8,116,97,98,111,114,100,101,114,2,
  1,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,
  121,2,108,9,98,111,117,110,100,115,95,99,120,3,184,1,9,98,111,117,
  110,100,115,95,99,121,2,18,12,111,112,116,105,111,110,115,115,99,97,108,
  101,11,11,111,115,99,95,101,120,112,97,110,100,121,11,111,115,99,95,115,
  104,114,105,110,107,121,0,11,102,111,110,116,46,104,101,105,103,104,116,2,
  14,15,102,111,110,116,46,101,120,116,114,97,115,112,97,99,101,2,251,10,
  102,111,110,116,46,115,116,121,108,101,11,7,102,115,95,98,111,108,100,0,
  9,102,111,110,116,46,110,97,109,101,6,10,115,116,102,95,114,101,112,111,
  114,116,15,102,111,110,116,46,108,111,99,97,108,112,114,111,112,115,11,9,
  102,108,112,95,115,116,121,108,101,0,10,116,97,98,115,46,99,111,117,110,
  116,2,2,18,116,97,98,115,46,108,105,116,111,112,95,119,105,100,116,104,
  109,109,5,154,153,153,153,153,153,153,153,253,63,19,116,97,98,115,46,108,
  105,108,101,102,116,95,119,105,100,116,104,109,109,2,0,19,116,97,98,115,
  46,108,105,118,101,114,116,95,119,105,100,116,104,109,109,5,154,153,153,153,
  153,153,153,153,253,63,20,116,97,98,115,46,108,105,114,105,103,104,116,95,
  119,105,100,116,104,109,109,5,154,153,153,153,153,153,153,153,253,63,21,116,
  97,98,115,46,108,105,98,111,116,116,111,109,95,119,105,100,116,104,109,109,
  5,154,153,153,153,153,153,153,153,253,63,13,116,97,98,115,46,100,105,115,
  116,108,101,102,116,2,0,14,116,97,98,115,46,100,105,115,116,114,105,103,
  104,116,2,0,16,116,97,98,115,46,100,101,102,97,117,108,116,100,105,115,
  116,2,0,10,116,97,98,115,46,105,116,101,109,115,14,1,3,112,111,115,
  2,0,5,118,97,108,117,101,6,14,86,101,114,121,32,108,111,110,103,32,
  116,101,120,116,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,120,
  99,101,110,116,101,114,101,100,12,116,102,95,121,99,101,110,116,101,114,101,
  100,12,116,102,95,119,111,114,100,98,114,101,97,107,0,13,108,105,116,111,
  112,95,119,105,100,116,104,109,109,2,0,14,108,105,118,101,114,116,95,119,
  105,100,116,104,109,109,5,154,153,153,153,153,153,153,153,253,63,16,108,105,
  98,111,116,116,111,109,95,119,105,100,116,104,109,109,2,0,8,100,105,115,
  116,108,101,102,116,2,0,9,100,105,115,116,114,105,103,104,116,2,0,0,
  1,3,112,111,115,2,49,5,118,97,108,117,101,6,19,84,101,115,116,99,
  97,115,101,32,114,101,115,105,115,116,97,110,99,101,9,116,101,120,116,102,
  108,97,103,115,11,12,116,102,95,120,99,101,110,116,101,114,101,100,12,116,
  102,95,121,99,101,110,116,101,114,101,100,0,13,108,105,116,111,112,95,119,
  105,100,116,104,109,109,2,0,14,108,105,118,101,114,116,95,119,105,100,116,
  104,109,109,5,154,153,153,153,153,153,153,153,253,63,16,108,105,98,111,116,
  116,111,109,95,119,105,100,116,104,109,109,2,0,8,100,105,115,116,108,101,
  102,116,2,0,9,100,105,115,116,114,105,103,104,116,2,0,0,0,7,111,
  112,116,105,111,110,115,11,7,98,111,95,111,110,99,101,0,0,0,11,116,
  114,101,99,111,114,100,98,97,110,100,12,116,114,101,99,111,114,100,98,97,
  110,100,49,8,116,97,98,111,114,100,101,114,2,2,8,98,111,117,110,100,
  115,95,120,2,0,8,98,111,117,110,100,115,95,121,2,12,9,98,111,117,
  110,100,115,95,99,120,3,184,1,9,98,111,117,110,100,115,95,99,121,2,
  91,18,116,97,98,115,46,108,105,116,111,112,95,119,105,100,116,104,109,109,
  2,0,19,116,97,98,115,46,108,105,108,101,102,116,95,119,105,100,116,104,
  109,109,2,0,19,116,97,98,115,46,108,105,118,101,114,116,95,119,105,100,
  116,104,109,109,2,0,20,116,97,98,115,46,108,105,114,105,103,104,116,95,
  119,105,100,116,104,109,109,2,0,21,116,97,98,115,46,108,105,98,111,116,
  116,111,109,95,119,105,100,116,104,109,109,2,0,13,116,97,98,115,46,100,
  105,115,116,108,101,102,116,2,0,14,116,97,98,115,46,100,105,115,116,114,
  105,103,104,116,2,0,16,116,97,98,115,46,100,101,102,97,117,108,116,100,
  105,115,116,2,0,7,111,112,116,105,111,110,115,11,7,98,111,95,111,110,
  99,101,0,0,6,116,108,97,98,101,108,7,116,108,97,98,101,108,49,18,
  102,114,97,109,101,46,102,114,97,109,101,105,95,114,105,103,104,116,2,2,
  19,102,114,97,109,101,46,102,114,97,109,101,105,95,98,111,116,116,111,109,
  2,2,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,
  11,102,114,108,95,102,105,114,105,103,104,116,12,102,114,108,95,102,105,98,
  111,116,116,111,109,0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,
  111,112,115,49,11,0,8,98,111,117,110,100,115,95,120,2,114,8,98,111,
  117,110,100,115,95,121,2,6,9,98,111,117,110,100,115,95,99,120,3,8,
  1,9,98,111,117,110,100,115,95,99,121,2,64,7,99,97,112,116,105,111,
  110,6,69,84,101,115,116,99,97,115,101,32,114,101,112,111,114,116,10,102,
  111,114,32,100,101,98,117,103,103,105,110,103,32,84,77,115,101,83,81,76,
  81,117,101,114,121,13,105,110,32,108,111,99,97,108,32,109,111,100,101,44,
  32,97,108,108,32,114,101,99,111,114,100,115,10,102,111,110,116,46,99,111,
  108,111,114,4,2,0,0,160,11,102,111,110,116,46,104,101,105,103,104,116,
  2,18,10,102,111,110,116,46,115,116,121,108,101,11,7,102,115,95,98,111,
  108,100,0,9,102,111,110,116,46,110,97,109,101,6,10,115,116,102,95,114,
  101,112,111,114,116,15,102,111,110,116,46,108,111,99,97,108,112,114,111,112,
  115,11,9,102,108,112,95,99,111,108,111,114,9,102,108,112,95,115,116,121,
  108,101,0,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,120,99,
  101,110,116,101,114,101,100,12,116,102,95,121,99,101,110,116,101,114,101,100,
  0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,20,0,0,0,
  11,116,114,101,99,111,114,100,98,97,110,100,10,98,97,110,100,70,111,111,
  116,101,114,8,116,97,98,111,114,100,101,114,2,3,8,98,111,117,110,100,
  115,95,120,2,0,8,98,111,117,110,100,115,95,121,3,134,1,9,98,111,
  117,110,100,115,95,99,120,3,184,1,9,98,111,117,110,100,115,95,99,121,
  2,45,10,116,97,98,115,46,99,111,117,110,116,2,2,18,116,97,98,115,
  46,108,105,116,111,112,95,119,105,100,116,104,109,109,5,154,153,153,153,153,
  153,153,153,253,63,19,116,97,98,115,46,108,105,108,101,102,116,95,119,105,
  100,116,104,109,109,2,0,19,116,97,98,115,46,108,105,118,101,114,116,95,
  119,105,100,116,104,109,109,5,154,153,153,153,153,153,153,153,253,63,20,116,
  97,98,115,46,108,105,114,105,103,104,116,95,119,105,100,116,104,109,109,5,
  154,153,153,153,153,153,153,153,253,63,21,116,97,98,115,46,108,105,98,111,
  116,116,111,109,95,119,105,100,116,104,109,109,5,154,153,153,153,153,153,153,
  153,253,63,13,116,97,98,115,46,100,105,115,116,108,101,102,116,2,0,14,
  116,97,98,115,46,100,105,115,116,114,105,103,104,116,2,0,15,116,97,98,
  115,46,108,105,110,107,115,111,117,114,99,101,7,10,98,97,110,100,72,101,
  97,100,101,114,16,116,97,98,115,46,100,101,102,97,117,108,116,100,105,115,
  116,2,0,10,116,97,98,115,46,105,116,101,109,115,14,1,3,112,111,115,
  2,0,5,118,97,108,117,101,6,14,84,104,101,32,102,111,111,116,101,114,
  32,114,111,119,11,102,111,110,116,46,104,101,105,103,104,116,2,14,10,102,
  111,110,116,46,115,116,121,108,101,11,9,102,115,95,105,116,97,108,105,99,
  0,9,102,111,110,116,46,110,97,109,101,6,10,115,116,102,95,114,101,112,
  111,114,116,15,102,111,110,116,46,108,111,99,97,108,112,114,111,112,115,11,
  9,102,108,112,95,115,116,121,108,101,0,9,116,101,120,116,102,108,97,103,
  115,11,12,116,102,95,121,99,101,110,116,101,114,101,100,12,116,102,95,119,
  111,114,100,98,114,101,97,107,0,13,108,105,116,111,112,95,119,105,100,116,
  104,109,109,2,0,14,108,105,118,101,114,116,95,119,105,100,116,104,109,109,
  5,154,153,153,153,153,153,153,153,253,63,16,108,105,98,111,116,116,111,109,
  95,119,105,100,116,104,109,109,2,0,8,100,105,115,116,108,101,102,116,2,
  3,9,100,105,115,116,114,105,103,104,116,2,0,0,1,3,112,111,115,2,
  49,5,118,97,108,117,101,18,12,0,0,0,17,34,32,0,114,0,101,0,
  115,0,105,0,115,0,116,0,97,0,110,0,99,0,101,0,11,102,111,110,
  116,46,104,101,105,103,104,116,2,14,10,102,111,110,116,46,115,116,121,108,
  101,11,7,102,115,95,98,111,108,100,0,9,102,111,110,116,46,110,97,109,
  101,6,10,115,116,102,95,114,101,112,111,114,116,15,102,111,110,116,46,108,
  111,99,97,108,112,114,111,112,115,11,9,102,108,112,95,115,116,121,108,101,
  0,9,116,101,120,116,102,108,97,103,115,11,12,116,102,95,120,99,101,110,
  116,101,114,101,100,12,116,102,95,121,99,101,110,116,101,114,101,100,0,13,
  108,105,116,111,112,95,119,105,100,116,104,109,109,2,0,14,108,105,118,101,
  114,116,95,119,105,100,116,104,109,109,5,154,153,153,153,153,153,153,153,253,
  63,16,108,105,98,111,116,116,111,109,95,119,105,100,116,104,109,109,2,0,
  8,100,105,115,116,108,101,102,116,2,0,9,100,105,115,116,114,105,103,104,
  116,2,0,0,0,7,111,112,116,105,111,110,115,11,7,98,111,95,111,110,
  99,101,0,14,111,110,98,101,102,111,114,101,114,101,110,100,101,114,7,12,
  102,111,111,116,101,114,114,101,110,100,101,114,0,0,0,15,116,114,101,112,
  112,97,103,101,110,117,109,100,105,115,112,16,116,114,101,112,112,97,103,101,
  110,117,109,100,105,115,112,49,8,116,97,98,111,114,100,101,114,2,1,8,
  98,111,117,110,100,115,95,120,3,4,2,8,98,111,117,110,100,115,95,121,
  2,0,9,98,111,117,110,100,115,95,99,120,2,55,9,98,111,117,110,100,
  115,95,99,121,2,11,11,102,111,110,116,46,104,101,105,103,104,116,2,10,
  9,102,111,110,116,46,110,97,109,101,6,10,115,116,102,95,114,101,112,111,
  114,116,15,102,111,110,116,46,108,111,99,97,108,112,114,111,112,115,11,0,
  6,102,111,114,109,97,116,6,11,80,97,103,101,32,48,32,111,102,32,49,
  0,0,17,116,114,101,112,112,114,105,110,116,100,97,116,101,100,105,115,112,
  18,116,114,101,112,112,114,105,110,116,100,97,116,101,100,105,115,112,49,8,
  116,97,98,111,114,100,101,114,2,2,8,98,111,117,110,100,115,95,120,2,
  0,8,98,111,117,110,100,115,95,121,3,30,3,9,98,111,117,110,100,115,
  95,99,120,2,53,9,98,111,117,110,100,115,95,99,121,2,10,11,102,111,
  110,116,46,104,101,105,103,104,116,2,9,9,102,111,110,116,46,110,97,109,
  101,6,15,84,105,109,101,115,32,78,101,119,32,82,111,109,97,110,15,102,
  111,110,116,46,108,111,99,97,108,112,114,111,112,115,11,0,6,102,111,114,
  109,97,116,6,13,121,121,121,121,44,32,109,109,109,109,32,100,100,0,0,
  0,0)
 );

initialization
 registerobjectdata(@objdata,treportikre,'');
end.