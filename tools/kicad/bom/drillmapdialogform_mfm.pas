unit drillmapdialogform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,drillmapdialogform;

const
 objdata: record size: integer; data: array[0..3296] of byte end =
      (size: 3297; data: (
  84,80,70,48,241,17,116,100,114,105,108,108,109,97,112,100,105,97,108,111,
  103,102,111,16,100,114,105,108,108,109,97,112,100,105,97,108,111,103,102,111,
  8,98,111,117,110,100,115,95,120,2,62,8,98,111,117,110,100,115,95,121,
  3,61,2,9,98,111,117,110,100,115,95,99,121,3,67,1,16,99,111,110,
  116,97,105,110,101,114,46,98,111,117,110,100,115,1,2,0,2,0,3,42,
  2,3,67,1,0,7,99,97,112,116,105,111,110,6,27,68,111,99,117,32,
  80,67,66,32,68,114,105,108,108,109,97,112,45,80,108,111,116,32,80,97,
  103,101,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,15,
  116,100,111,99,117,112,97,103,101,101,100,105,116,102,111,0,241,9,116,115,
  112,108,105,116,116,101,114,10,116,115,112,108,105,116,116,101,114,49,8,116,
  97,98,111,114,100,101,114,2,1,0,241,7,116,98,117,116,116,111,110,8,
  116,98,117,116,116,111,110,50,0,0,241,7,116,98,117,116,116,111,110,8,
  116,98,117,116,116,111,110,49,0,0,241,7,116,115,112,97,99,101,114,8,
  116,115,112,97,99,101,114,50,0,0,0,242,2,1,9,116,108,97,121,111,
  117,116,101,114,10,116,108,97,121,111,117,116,101,114,49,13,111,112,116,105,
  111,110,115,119,105,100,103,101,116,11,11,111,119,95,116,97,98,102,111,99,
  117,115,17,111,119,95,112,97,114,101,110,116,116,97,98,102,111,99,117,115,
  13,111,119,95,97,114,114,111,119,102,111,99,117,115,15,111,119,95,97,114,
  114,111,119,102,111,99,117,115,105,110,16,111,119,95,97,114,114,111,119,102,
  111,99,117,115,111,117,116,11,111,119,95,115,117,98,102,111,99,117,115,17,
  111,119,95,100,101,115,116,114,111,121,119,105,100,103,101,116,115,0,8,116,
  97,98,111,114,100,101,114,2,3,8,98,111,117,110,100,115,95,120,2,8,
  8,98,111,117,110,100,115,95,121,2,37,9,98,111,117,110,100,115,95,99,
  120,3,26,2,9,98,111,117,110,100,115,95,99,121,2,37,7,97,110,99,
  104,111,114,115,11,7,97,110,95,108,101,102,116,6,97,110,95,116,111,112,
  8,97,110,95,114,105,103,104,116,0,12,111,112,116,105,111,110,115,115,99,
  97,108,101,11,11,111,115,99,95,101,120,112,97,110,100,121,11,111,115,99,
  95,115,104,114,105,110,107,121,17,111,115,99,95,101,120,112,97,110,100,115,
  104,114,105,110,107,120,17,111,115,99,95,101,120,112,97,110,100,115,104,114,
  105,110,107,121,0,13,111,112,116,105,111,110,115,108,97,121,111,117,116,11,
  10,108,97,111,95,112,108,97,99,101,120,10,108,97,111,95,97,108,105,103,
  110,121,0,10,97,108,105,103,110,95,103,108,117,101,7,9,119,97,109,95,
  115,116,97,114,116,13,112,108,97,99,101,95,109,105,110,100,105,115,116,2,
  4,13,112,108,97,99,101,95,109,97,120,100,105,115,116,2,4,0,19,116,
  100,98,100,114,111,112,100,111,119,110,108,105,115,116,101,100,105,116,14,118,
  97,108,95,108,97,121,101,114,97,110,97,109,101,14,111,112,116,105,111,110,
  115,119,105,100,103,101,116,49,11,19,111,119,49,95,102,111,110,116,103,108,
  121,112,104,104,101,105,103,104,116,0,11,111,112,116,105,111,110,115,115,107,
  105,110,11,19,111,115,107,95,102,114,97,109,101,98,117,116,116,111,110,111,
  110,108,121,0,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,7,
  76,97,121,101,114,32,65,16,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,10,102,114,108,
  95,108,101,118,101,108,105,15,102,114,108,95,99,111,108,111,114,99,108,105,
  101,110,116,0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,
  115,49,11,0,18,102,114,97,109,101,46,98,117,116,116,111,110,46,99,111,
  108,111,114,4,5,0,0,144,19,102,114,97,109,101,46,98,117,116,116,111,
  110,115,46,99,111,117,110,116,2,1,19,102,114,97,109,101,46,98,117,116,
  116,111,110,115,46,105,116,101,109,115,14,1,5,99,111,108,111,114,4,5,
  0,0,144,0,0,16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,
  109,101,1,2,0,2,17,2,0,2,0,0,8,98,111,117,110,100,115,95,
  120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,
  115,95,99,120,3,179,0,9,98,111,117,110,100,115,95,99,121,2,37,11,
  111,112,116,105,111,110,115,101,100,105,116,11,12,111,101,95,117,110,100,111,
  111,110,101,115,99,13,111,101,95,99,108,111,115,101,113,117,101,114,121,16,
  111,101,95,99,104,101,99,107,109,114,99,97,110,99,101,108,14,111,101,95,
  115,104,105,102,116,114,101,116,117,114,110,12,111,101,95,101,97,116,114,101,
  116,117,114,110,20,111,101,95,114,101,115,101,116,115,101,108,101,99,116,111,
  110,101,120,105,116,15,111,101,95,101,120,105,116,111,110,99,117,114,115,111,
  114,13,111,101,95,101,110,100,111,110,101,110,116,101,114,13,111,101,95,97,
  117,116,111,115,101,108,101,99,116,25,111,101,95,97,117,116,111,115,101,108,
  101,99,116,111,110,102,105,114,115,116,99,108,105,99,107,22,111,101,95,102,
  111,99,117,115,114,101,99,116,111,110,114,101,97,100,111,110,108,121,18,111,
  101,95,104,105,110,116,99,108,105,112,112,101,100,116,101,120,116,10,111,101,
  95,110,111,116,110,117,108,108,0,19,100,97,116,97,108,105,110,107,46,100,
  97,116,97,115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,97,
  116,97,108,105,110,107,46,102,105,101,108,100,110,97,109,101,6,6,76,65,
  89,69,82,65,16,100,114,111,112,100,111,119,110,46,111,112,116,105,111,110,
  115,11,16,100,101,111,95,97,117,116,111,100,114,111,112,100,111,119,110,15,
  100,101,111,95,107,101,121,100,114,111,112,100,111,119,110,12,100,101,111,95,
  99,108,105,112,104,105,110,116,0,19,100,114,111,112,100,111,119,110,46,99,
  111,108,115,46,99,111,117,110,116,2,1,19,100,114,111,112,100,111,119,110,
  46,99,111,108,115,46,105,116,101,109,115,14,1,0,0,13,114,101,102,102,
  111,110,116,104,101,105,103,104,116,2,14,0,0,19,116,100,98,100,114,111,
  112,100,111,119,110,108,105,115,116,101,100,105,116,14,118,97,108,95,108,97,
  121,101,114,98,110,97,109,101,14,111,112,116,105,111,110,115,119,105,100,103,
  101,116,49,11,19,111,119,49,95,102,111,110,116,103,108,121,112,104,104,101,
  105,103,104,116,0,11,111,112,116,105,111,110,115,115,107,105,110,11,19,111,
  115,107,95,102,114,97,109,101,98,117,116,116,111,110,111,110,108,121,0,13,
  102,114,97,109,101,46,99,97,112,116,105,111,110,6,7,76,97,121,101,114,
  32,66,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,
  10,102,114,108,95,108,101,118,101,108,111,10,102,114,108,95,108,101,118,101,
  108,105,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,17,
  102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,18,
  102,114,97,109,101,46,98,117,116,116,111,110,46,99,111,108,111,114,4,5,
  0,0,144,19,102,114,97,109,101,46,98,117,116,116,111,110,115,46,99,111,
  117,110,116,2,1,19,102,114,97,109,101,46,98,117,116,116,111,110,115,46,
  105,116,101,109,115,14,1,5,99,111,108,111,114,4,5,0,0,144,0,0,
  16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,
  2,17,2,0,2,0,0,8,116,97,98,111,114,100,101,114,2,1,8,98,
  111,117,110,100,115,95,120,3,183,0,8,98,111,117,110,100,115,95,121,2,
  0,9,98,111,117,110,100,115,95,99,120,3,179,0,9,98,111,117,110,100,
  115,95,99,121,2,37,11,111,112,116,105,111,110,115,101,100,105,116,11,12,
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
  116,101,120,116,10,111,101,95,110,111,116,110,117,108,108,0,19,100,97,116,
  97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,100,97,
  116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,108,100,110,
  97,109,101,6,6,76,65,89,69,82,66,16,100,114,111,112,100,111,119,110,
  46,111,112,116,105,111,110,115,11,16,100,101,111,95,97,117,116,111,100,114,
  111,112,100,111,119,110,15,100,101,111,95,107,101,121,100,114,111,112,100,111,
  119,110,12,100,101,111,95,99,108,105,112,104,105,110,116,0,19,100,114,111,
  112,100,111,119,110,46,99,111,108,115,46,99,111,117,110,116,2,1,19,100,
  114,111,112,100,111,119,110,46,99,111,108,115,46,105,116,101,109,115,14,1,
  0,0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,2,14,0,0,
  14,116,100,98,98,111,111,108,101,97,110,101,100,105,116,13,118,97,108,95,
  110,111,110,112,108,97,116,101,100,13,102,114,97,109,101,46,99,97,112,116,
  105,111,110,6,10,110,111,110,32,112,108,97,116,101,100,16,102,114,97,109,
  101,46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,
  46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,1,2,71,2,2,
  0,8,116,97,98,111,114,100,101,114,2,2,8,98,111,117,110,100,115,95,
  120,3,110,1,8,98,111,117,110,100,115,95,121,2,20,9,98,111,117,110,
  100,115,95,99,120,2,84,9,98,111,117,110,100,115,95,99,121,2,16,19,
  100,97,116,97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,
  6,100,97,116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,
  108,100,110,97,109,101,6,3,78,80,84,0,0,0,246,2,2,15,116,112,
  108,111,116,115,101,116,116,105,110,103,115,102,111,12,112,108,111,116,115,101,
  116,116,105,110,103,115,8,98,111,117,110,100,115,95,120,2,8,8,98,111,
  117,110,100,115,95,121,2,74,7,108,105,110,107,116,111,112,7,10,116,108,
  97,121,111,117,116,101,114,49,0,241,14,116,100,98,98,111,111,108,101,97,
  110,101,100,105,116,11,118,97,108,95,109,105,114,114,111,114,120,19,100,97,
  116,97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,100,
  97,116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,108,100,
  110,97,109,101,6,10,77,73,82,82,79,82,72,79,82,90,0,0,241,14,
  116,100,98,98,111,111,108,101,97,110,101,100,105,116,11,118,97,108,95,109,
  105,114,114,111,114,121,19,100,97,116,97,108,105,110,107,46,100,97,116,97,
  115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,97,116,97,108,
  105,110,107,46,102,105,101,108,100,110,97,109,101,6,10,77,73,82,82,79,
  82,86,69,82,84,0,0,241,14,116,100,98,98,111,111,108,101,97,110,101,
  100,105,116,12,118,97,108,95,114,111,116,97,116,101,57,48,19,100,97,116,
  97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,100,97,
  116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,108,100,110,
  97,109,101,6,8,82,79,84,65,84,69,57,48,0,0,241,14,116,100,98,
  98,111,111,108,101,97,110,101,100,105,116,13,118,97,108,95,114,111,116,97,
  116,101,49,56,48,19,100,97,116,97,108,105,110,107,46,100,97,116,97,115,
  111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,97,116,97,108,105,
  110,107,46,102,105,101,108,100,110,97,109,101,6,9,82,79,84,65,84,69,
  49,56,48,0,0,241,11,116,100,98,114,101,97,108,101,100,105,116,9,118,
  97,108,95,115,99,97,108,101,19,100,97,116,97,108,105,110,107,46,100,97,
  116,97,115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,97,116,
  97,108,105,110,107,46,102,105,101,108,100,110,97,109,101,6,5,83,67,65,
  76,69,0,0,241,11,116,100,98,114,101,97,108,101,100,105,116,13,118,97,
  108,95,115,104,105,102,116,104,111,114,122,19,100,97,116,97,108,105,110,107,
  46,100,97,116,97,115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,
  100,97,116,97,108,105,110,107,46,102,105,101,108,100,110,97,109,101,6,9,
  83,72,73,70,84,72,79,82,90,0,0,241,11,116,100,98,114,101,97,108,
  101,100,105,116,13,118,97,108,95,115,104,105,102,116,118,101,114,116,19,100,
  97,116,97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,
  100,97,116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,108,
  100,110,97,109,101,6,9,83,72,73,70,84,86,69,82,84,0,0,0,243,
  2,3,9,116,108,97,121,111,117,116,101,114,10,116,108,97,121,111,117,116,
  101,114,50,8,116,97,98,111,114,100,101,114,2,2,0,241,13,116,100,98,
  115,116,114,105,110,103,101,100,105,116,9,118,97,108,95,116,105,116,108,101,
  0,0,0,243,2,4,14,116,109,115,101,100,97,116,97,115,111,117,114,99,
  101,6,100,97,116,97,115,111,0,0,243,2,5,7,116,97,99,116,105,111,
  110,6,102,49,48,97,99,116,0,0,243,2,6,9,116,115,116,97,116,102,
  105,108,101,10,116,115,116,97,116,102,105,108,101,49,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tdrillmapdialogfo,'');
end.