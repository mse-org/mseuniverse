unit objectform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,objectform;

const
 objdata: record size: integer; data: array[0..4106] of byte end =
      (size: 4107; data: (
  84,80,70,48,9,116,111,98,106,101,99,116,102,111,8,111,98,106,101,99,
  116,102,111,8,98,111,117,110,100,115,95,120,3,81,1,8,98,111,117,110,
  100,115,95,121,3,10,1,9,98,111,117,110,100,115,95,99,120,3,59,1,
  9,98,111,117,110,100,115,95,99,121,3,0,1,26,99,111,110,116,97,105,
  110,101,114,46,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,
  11,0,27,99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,49,11,0,16,99,111,110,116,97,105,110,
  101,114,46,98,111,117,110,100,115,1,2,0,2,0,3,59,1,3,0,1,
  0,7,111,112,116,105,111,110,115,11,14,102,111,95,99,97,110,99,101,108,
  111,110,101,115,99,15,102,111,95,97,117,116,111,114,101,97,100,115,116,97,
  116,16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,10,102,
  111,95,115,97,118,101,112,111,115,13,102,111,95,115,97,118,101,122,111,114,
  100,101,114,12,102,111,95,115,97,118,101,115,116,97,116,101,0,8,115,116,
  97,116,102,105,108,101,7,10,116,115,116,97,116,102,105,108,101,49,12,111,
  110,99,108,111,115,101,113,117,101,114,121,7,12,99,108,111,115,101,113,117,
  101,114,121,101,118,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,
  101,6,8,116,109,115,101,102,111,114,109,0,7,116,98,117,116,116,111,110,
  6,102,105,110,105,98,117,8,116,97,98,111,114,100,101,114,2,5,8,98,
  111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,115,95,121,3,200,
  0,9,98,111,117,110,100,115,95,99,120,2,114,9,98,111,117,110,100,115,
  95,99,121,2,46,5,115,116,97,116,101,11,17,97,115,95,108,111,99,97,
  108,105,110,118,105,115,105,98,108,101,15,97,115,95,108,111,99,97,108,99,
  97,112,116,105,111,110,0,7,99,97,112,116,105,111,110,6,7,98,101,101,
  110,100,101,110,11,109,111,100,97,108,114,101,115,117,108,116,7,5,109,114,
  95,111,107,0,0,13,116,100,98,115,116,114,105,110,103,101,100,105,116,6,
  110,97,109,101,101,100,13,102,114,97,109,101,46,99,97,112,116,105,111,110,
  6,4,78,97,109,101,22,102,114,97,109,101,46,99,97,112,116,105,111,110,
  116,101,120,116,102,108,97,103,115,11,9,116,102,95,98,111,116,116,111,109,
  0,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,
  17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,
  16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,
  2,19,2,0,2,0,0,8,98,111,117,110,100,115,95,120,2,8,8,98,
  111,117,110,100,115,95,121,2,5,9,98,111,117,110,100,115,95,99,120,3,
  44,1,9,98,111,117,110,100,115,95,99,121,2,41,7,97,110,99,104,111,
  114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,
  110,95,114,105,103,104,116,0,11,111,112,116,105,111,110,115,101,100,105,116,
  11,12,111,101,95,117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,
  111,115,101,113,117,101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,
  97,110,99,101,108,14,111,101,95,115,104,105,102,116,114,101,116,117,114,110,
  12,111,101,95,101,97,116,114,101,116,117,114,110,20,111,101,95,114,101,115,
  101,116,115,101,108,101,99,116,111,110,101,120,105,116,15,111,101,95,101,120,
  105,116,111,110,99,117,114,115,111,114,13,111,101,95,101,110,100,111,110,101,
  110,116,101,114,13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,
  101,95,97,117,116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,
  108,105,99,107,22,111,101,95,102,111,99,117,115,114,101,99,116,111,110,114,
  101,97,100,111,110,108,121,10,111,101,95,110,111,116,110,117,108,108,20,111,
  101,95,100,105,114,101,99,116,100,98,110,117,108,108,99,104,101,99,107,0,
  19,100,97,116,97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,
  7,6,100,97,116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,
  101,108,100,110,97,109,101,6,4,78,65,77,69,16,100,97,116,97,108,105,
  110,107,46,111,112,116,105,111,110,115,11,25,111,101,100,95,110,117,108,108,
  99,104,101,99,107,105,102,117,110,109,111,100,105,102,105,101,100,0,13,114,
  101,102,102,111,110,116,104,101,105,103,104,116,2,16,0,0,11,116,100,98,
  114,101,97,108,101,100,105,116,7,112,114,105,99,101,101,100,13,102,114,97,
  109,101,46,99,97,112,116,105,111,110,6,5,80,114,101,105,115,22,102,114,
  97,109,101,46,99,97,112,116,105,111,110,116,101,120,116,102,108,97,103,115,
  11,9,116,102,95,98,111,116,116,111,109,0,16,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,
  116,101,114,102,114,97,109,101,1,2,0,2,19,2,0,2,0,0,8,116,
  97,98,111,114,100,101,114,2,2,8,98,111,117,110,100,115,95,120,2,8,
  8,98,111,117,110,100,115,95,121,2,101,9,98,111,117,110,100,115,95,99,
  121,2,41,11,111,112,116,105,111,110,115,101,100,105,116,11,12,111,101,95,
  117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,115,101,113,117,
  101,114,121,16,111,101,95,99,104,101,99,107,109,114,99,97,110,99,101,108,
  14,111,101,95,115,104,105,102,116,114,101,116,117,114,110,12,111,101,95,101,
  97,116,114,101,116,117,114,110,20,111,101,95,114,101,115,101,116,115,101,108,
  101,99,116,111,110,101,120,105,116,15,111,101,95,101,120,105,116,111,110,99,
  117,114,115,111,114,13,111,101,95,101,110,100,111,110,101,110,116,101,114,13,
  111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,
  111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,99,107,22,
  111,101,95,102,111,99,117,115,114,101,99,116,111,110,114,101,97,100,111,110,
  108,121,10,111,101,95,110,111,116,110,117,108,108,20,111,101,95,100,105,114,
  101,99,116,100,98,110,117,108,108,99,104,101,99,107,0,19,100,97,116,97,
  108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,100,97,116,
  97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,108,100,110,97,
  109,101,6,5,80,82,73,67,69,8,118,97,108,117,101,109,105,110,5,0,
  0,0,0,0,0,0,128,255,255,8,118,97,108,117,101,109,97,120,5,244,
  136,13,181,80,153,118,150,125,64,10,118,97,108,117,101,114,97,110,103,101,
  2,1,10,118,97,108,117,101,115,116,97,114,116,2,0,13,114,101,102,102,
  111,110,116,104,101,105,103,104,116,2,16,0,0,13,116,100,98,115,116,114,
  105,110,103,101,100,105,116,6,117,110,105,116,101,100,13,102,114,97,109,101,
  46,99,97,112,116,105,111,110,6,7,69,105,110,104,101,105,116,22,102,114,
  97,109,101,46,99,97,112,116,105,111,110,116,101,120,116,102,108,97,103,115,
  11,9,116,102,95,98,111,116,116,111,109,0,16,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,
  116,101,114,102,114,97,109,101,1,2,0,2,19,2,0,2,0,0,8,116,
  97,98,111,114,100,101,114,2,3,8,98,111,117,110,100,115,95,120,2,112,
  8,98,111,117,110,100,115,95,121,2,101,9,98,111,117,110,100,115,95,99,
  121,2,41,11,111,112,116,105,111,110,115,101,100,105,116,11,12,111,101,95,
  117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,115,101,113,117,
  101,114,121,14,111,101,95,115,104,105,102,116,114,101,116,117,114,110,12,111,
  101,95,101,97,116,114,101,116,117,114,110,20,111,101,95,114,101,115,101,116,
  115,101,108,101,99,116,111,110,101,120,105,116,15,111,101,95,101,120,105,116,
  111,110,99,117,114,115,111,114,13,111,101,95,101,110,100,111,110,101,110,116,
  101,114,13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,101,95,
  97,117,116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,108,105,
  99,107,22,111,101,95,102,111,99,117,115,114,101,99,116,111,110,114,101,97,
  100,111,110,108,121,0,19,100,97,116,97,108,105,110,107,46,100,97,116,97,
  115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,97,116,97,108,
  105,110,107,46,102,105,101,108,100,110,97,109,101,6,4,85,78,73,84,13,
  114,101,102,102,111,110,116,104,101,105,103,104,116,2,16,0,0,13,116,100,
  98,115,116,114,105,110,103,101,100,105,116,13,100,101,115,99,114,105,112,116,
  105,111,110,101,100,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,
  11,66,101,122,101,105,99,104,110,117,110,103,22,102,114,97,109,101,46,99,
  97,112,116,105,111,110,116,101,120,116,102,108,97,103,115,11,9,116,102,95,
  98,111,116,116,111,109,0,16,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,
  111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,
  97,109,101,1,2,0,2,19,2,0,2,0,0,8,116,97,98,111,114,100,
  101,114,2,1,8,98,111,117,110,100,115,95,120,2,8,8,98,111,117,110,
  100,115,95,121,2,53,9,98,111,117,110,100,115,95,99,120,3,44,1,9,
  98,111,117,110,100,115,95,99,121,2,41,7,97,110,99,104,111,114,115,11,
  7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,8,97,110,95,114,
  105,103,104,116,0,11,111,112,116,105,111,110,115,101,100,105,116,11,12,111,
  101,95,117,110,100,111,111,110,101,115,99,13,111,101,95,99,108,111,115,101,
  113,117,101,114,121,14,111,101,95,115,104,105,102,116,114,101,116,117,114,110,
  12,111,101,95,101,97,116,114,101,116,117,114,110,20,111,101,95,114,101,115,
  101,116,115,101,108,101,99,116,111,110,101,120,105,116,15,111,101,95,101,120,
  105,116,111,110,99,117,114,115,111,114,13,111,101,95,101,110,100,111,110,101,
  110,116,101,114,13,111,101,95,97,117,116,111,115,101,108,101,99,116,25,111,
  101,95,97,117,116,111,115,101,108,101,99,116,111,110,102,105,114,115,116,99,
  108,105,99,107,22,111,101,95,102,111,99,117,115,114,101,99,116,111,110,114,
  101,97,100,111,110,108,121,0,19,100,97,116,97,108,105,110,107,46,100,97,
  116,97,115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,97,116,
  97,108,105,110,107,46,102,105,101,108,100,110,97,109,101,6,11,68,69,83,
  67,82,73,80,84,73,79,78,13,114,101,102,102,111,110,116,104,101,105,103,
  104,116,2,16,0,0,19,116,100,98,100,105,97,108,111,103,115,116,114,105,
  110,103,101,100,105,116,9,99,111,109,109,101,110,116,101,100,13,102,114,97,
  109,101,46,99,97,112,116,105,111,110,6,9,66,101,109,101,114,107,117,110,
  103,22,102,114,97,109,101,46,99,97,112,116,105,111,110,116,101,120,116,102,
  108,97,103,115,11,9,116,102,95,98,111,116,116,111,109,0,16,102,114,97,
  109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,
  101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,19,102,114,97,109,
  101,46,98,117,116,116,111,110,115,46,99,111,117,110,116,2,1,19,102,114,
  97,109,101,46,98,117,116,116,111,110,115,46,105,116,101,109,115,14,1,7,
  105,109,97,103,101,110,114,2,17,0,0,20,102,114,97,109,101,46,98,117,
  116,116,111,110,46,105,109,97,103,101,110,114,2,17,16,102,114,97,109,101,
  46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,19,2,0,2,0,
  0,8,116,97,98,111,114,100,101,114,2,4,8,98,111,117,110,100,115,95,
  120,2,8,8,98,111,117,110,100,115,95,121,3,149,0,9,98,111,117,110,
  100,115,95,99,120,3,44,1,9,98,111,117,110,100,115,95,99,121,2,41,
  7,97,110,99,104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,
  95,116,111,112,8,97,110,95,114,105,103,104,116,0,11,111,112,116,105,111,
  110,115,101,100,105,116,11,12,111,101,95,117,110,100,111,111,110,101,115,99,
  13,111,101,95,99,108,111,115,101,113,117,101,114,121,14,111,101,95,115,104,
  105,102,116,114,101,116,117,114,110,12,111,101,95,101,97,116,114,101,116,117,
  114,110,20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,101,
  120,105,116,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,114,13,
  111,101,95,101,110,100,111,110,101,110,116,101,114,13,111,101,95,97,117,116,
  111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,108,101,99,
  116,111,110,102,105,114,115,116,99,108,105,99,107,22,111,101,95,102,111,99,
  117,115,114,101,99,116,111,110,114,101,97,100,111,110,108,121,0,19,100,97,
  116,97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,100,
  97,116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,108,100,
  110,97,109,101,6,7,67,79,77,77,69,78,84,13,114,101,102,102,111,110,
  116,104,101,105,103,104,116,2,16,0,0,7,116,98,117,116,116,111,110,8,
  99,97,110,99,101,108,98,117,8,116,97,98,111,114,100,101,114,2,6,8,
  98,111,117,110,100,115,95,120,3,128,0,8,98,111,117,110,100,115,95,121,
  3,200,0,9,98,111,117,110,100,115,95,99,120,2,114,9,98,111,117,110,
  100,115,95,99,121,2,46,5,115,116,97,116,101,11,17,97,115,95,108,111,
  99,97,108,105,110,118,105,115,105,98,108,101,15,97,115,95,108,111,99,97,
  108,99,97,112,116,105,111,110,0,7,99,97,112,116,105,111,110,6,9,65,
  98,98,114,101,99,104,101,110,11,109,111,100,97,108,114,101,115,117,108,116,
  7,9,109,114,95,99,97,110,99,101,108,0,0,11,116,100,98,114,101,97,
  108,101,100,105,116,10,100,117,114,97,116,105,111,110,101,100,13,102,114,97,
  109,101,46,99,97,112,116,105,111,110,21,12,0,0,0,71,0,252,0,108,
  0,116,0,105,0,103,0,32,0,74,0,97,0,104,0,114,0,101,0,22,
  102,114,97,109,101,46,99,97,112,116,105,111,110,116,101,120,116,102,108,97,
  103,115,11,9,116,102,95,98,111,116,116,111,109,0,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,
  108,111,99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,
  111,117,116,101,114,102,114,97,109,101,1,2,0,2,19,2,0,2,0,0,
  8,116,97,98,111,114,100,101,114,2,7,8,98,111,117,110,100,115,95,120,
  3,216,0,8,98,111,117,110,100,115,95,121,2,101,9,98,111,117,110,100,
  115,95,99,120,2,92,9,98,111,117,110,100,115,95,99,121,2,41,11,111,
  112,116,105,111,110,115,101,100,105,116,11,12,111,101,95,117,110,100,111,111,
  110,101,115,99,13,111,101,95,99,108,111,115,101,113,117,101,114,121,16,111,
  101,95,99,104,101,99,107,109,114,99,97,110,99,101,108,14,111,101,95,115,
  104,105,102,116,114,101,116,117,114,110,12,111,101,95,101,97,116,114,101,116,
  117,114,110,20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,110,
  101,120,105,116,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,114,
  13,111,101,95,101,110,100,111,110,101,110,116,101,114,13,111,101,95,97,117,
  116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,108,101,
  99,116,111,110,102,105,114,115,116,99,108,105,99,107,22,111,101,95,102,111,
  99,117,115,114,101,99,116,111,110,114,101,97,100,111,110,108,121,10,111,101,
  95,110,111,116,110,117,108,108,20,111,101,95,100,105,114,101,99,116,100,98,
  110,117,108,108,99,104,101,99,107,0,19,100,97,116,97,108,105,110,107,46,
  100,97,116,97,115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,
  97,116,97,108,105,110,107,46,102,105,101,108,100,110,97,109,101,6,8,68,
  85,82,65,84,73,79,78,8,118,97,108,117,101,109,105,110,5,0,0,0,
  0,0,0,0,128,255,255,8,118,97,108,117,101,109,97,120,5,244,136,13,
  181,80,153,118,150,125,64,10,118,97,108,117,101,114,97,110,103,101,2,1,
  10,118,97,108,117,101,115,116,97,114,116,2,0,13,114,101,102,102,111,110,
  116,104,101,105,103,104,116,2,16,0,0,9,116,115,116,97,116,102,105,108,
  101,10,116,115,116,97,116,102,105,108,101,49,8,102,105,108,101,110,97,109,
  101,6,10,111,98,106,101,99,116,46,115,116,97,7,111,112,116,105,111,110,
  115,11,10,115,102,111,95,109,101,109,111,114,121,15,115,102,111,95,116,114,
  97,110,115,97,99,116,105,111,110,17,115,102,111,95,97,99,116,105,118,97,
  116,111,114,114,101,97,100,18,115,102,111,95,97,99,116,105,118,97,116,111,
  114,119,114,105,116,101,0,4,108,101,102,116,2,88,3,116,111,112,2,8,
  0,0,14,116,109,115,101,100,97,116,97,115,111,117,114,99,101,6,100,97,
  116,97,115,111,7,68,97,116,97,83,101,116,7,16,109,97,105,110,109,111,
  46,111,98,106,101,99,116,115,113,117,4,108,101,102,116,3,208,0,3,116,
  111,112,2,8,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tobjectfo,'');
end.