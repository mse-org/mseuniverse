unit recordeditform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,recordeditform;

const
 objdata: record size: integer; data: array[0..2659] of byte end =
      (size: 2660; data: (
  84,80,70,48,13,116,114,101,99,111,114,100,101,100,105,116,102,111,12,114,
  101,99,111,114,100,101,100,105,116,102,111,7,118,105,115,105,98,108,101,8,
  8,98,111,117,110,100,115,95,120,3,111,1,8,98,111,117,110,100,115,95,
  121,3,80,2,9,98,111,117,110,100,115,95,99,120,3,0,2,9,98,111,
  117,110,100,115,95,99,121,3,150,1,26,99,111,110,116,97,105,110,101,114,
  46,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,27,
  99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,49,11,0,16,99,111,110,116,97,105,110,101,114,46,
  98,111,117,110,100,115,1,2,0,2,0,3,0,2,3,150,1,0,7,111,
  112,116,105,111,110,115,11,14,102,111,95,102,114,101,101,111,110,99,108,111,
  115,101,13,102,111,95,99,108,111,115,101,111,110,101,115,99,15,102,111,95,
  97,117,116,111,114,101,97,100,115,116,97,116,16,102,111,95,97,117,116,111,
  119,114,105,116,101,115,116,97,116,10,102,111,95,115,97,118,101,112,111,115,
  13,102,111,95,115,97,118,101,122,111,114,100,101,114,12,102,111,95,115,97,
  118,101,115,116,97,116,101,0,8,115,116,97,116,102,105,108,101,7,10,116,
  115,116,97,116,102,105,108,101,49,12,111,110,99,108,111,115,101,113,117,101,
  114,121,7,12,99,108,111,115,101,113,117,101,114,121,101,118,15,109,111,100,
  117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,109,115,101,102,111,
  114,109,0,9,116,108,97,121,111,117,116,101,114,7,115,116,114,105,112,101,
  48,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,11,111,119,95,
  116,97,98,102,111,99,117,115,17,111,119,95,112,97,114,101,110,116,116,97,
  98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,99,117,115,
  15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,111,119,95,
  97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,115,117,98,
  102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,0,8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,
  100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,3,0,2,9,
  98,111,117,110,100,115,95,99,121,2,36,7,97,110,99,104,111,114,115,11,
  6,97,110,95,116,111,112,0,12,111,112,116,105,111,110,115,115,99,97,108,
  101,11,11,111,115,99,95,101,120,112,97,110,100,120,11,111,115,99,95,101,
  120,112,97,110,100,121,11,111,115,99,95,115,104,114,105,110,107,121,17,111,
  115,99,95,101,120,112,97,110,100,115,104,114,105,110,107,120,17,111,115,99,
  95,101,120,112,97,110,100,115,104,114,105,110,107,121,0,13,111,112,116,105,
  111,110,115,108,97,121,111,117,116,11,10,108,97,111,95,112,108,97,99,101,
  120,0,0,9,116,108,97,121,111,117,116,101,114,10,116,108,97,121,111,117,
  116,101,114,50,13,111,112,116,105,111,110,115,119,105,100,103,101,116,11,11,
  111,119,95,116,97,98,102,111,99,117,115,17,111,119,95,112,97,114,101,110,
  116,116,97,98,102,111,99,117,115,13,111,119,95,97,114,114,111,119,102,111,
  99,117,115,15,111,119,95,97,114,114,111,119,102,111,99,117,115,105,110,16,
  111,119,95,97,114,114,111,119,102,111,99,117,115,111,117,116,11,111,119,95,
  115,117,98,102,111,99,117,115,17,111,119,95,100,101,115,116,114,111,121,119,
  105,100,103,101,116,115,0,8,98,111,117,110,100,115,95,120,3,73,1,8,
  98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,99,120,
  3,183,0,9,98,111,117,110,100,115,95,99,121,2,36,7,97,110,99,104,
  111,114,115,11,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,
  0,12,111,112,116,105,111,110,115,115,99,97,108,101,11,11,111,115,99,95,
  101,120,112,97,110,100,120,11,111,115,99,95,115,104,114,105,110,107,120,11,
  111,115,99,95,101,120,112,97,110,100,121,11,111,115,99,95,115,104,114,105,
  110,107,121,17,111,115,99,95,101,120,112,97,110,100,115,104,114,105,110,107,
  120,17,111,115,99,95,101,120,112,97,110,100,115,104,114,105,110,107,121,0,
  13,111,112,116,105,111,110,115,108,97,121,111,117,116,11,10,108,97,111,95,
  112,108,97,99,101,121,0,13,112,108,97,99,101,95,109,97,120,100,105,115,
  116,2,0,0,15,116,100,98,100,97,116,101,116,105,109,101,100,105,115,112,
  8,116,115,109,111,100,105,102,121,13,102,114,97,109,101,46,99,97,112,116,
  105,111,110,6,1,77,16,102,114,97,109,101,46,99,97,112,116,105,111,110,
  112,111,115,7,7,99,112,95,108,101,102,116,16,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,
  116,101,114,102,114,97,109,101,1,2,13,2,0,2,0,2,0,0,4,104,
  105,110,116,6,22,77,111,100,105,102,105,99,97,116,105,111,110,32,116,105,
  109,101,115,116,97,109,112,8,98,111,117,110,100,115,95,120,2,0,8,98,
  111,117,110,100,115,95,121,2,18,9,98,111,117,110,100,115,95,99,120,3,
  183,0,9,98,111,117,110,100,115,95,99,121,2,18,7,97,110,99,104,111,
  114,115,11,6,97,110,95,116,111,112,8,97,110,95,114,105,103,104,116,0,
  7,111,112,116,105,111,110,115,11,19,100,119,111,95,104,105,110,116,99,108,
  105,112,112,101,100,116,101,120,116,0,6,102,111,114,109,97,116,6,18,121,
  121,121,121,45,109,109,45,100,32,104,104,58,110,110,58,115,115,4,107,105,
  110,100,7,12,100,116,107,95,100,97,116,101,116,105,109,101,19,100,97,116,
  97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,100,97,
  116,97,115,111,18,100,97,116,97,108,105,110,107,46,102,105,101,108,100,110,
  97,109,101,6,8,84,83,77,79,68,73,70,89,13,114,101,102,102,111,110,
  116,104,101,105,103,104,116,2,14,0,0,15,116,100,98,100,97,116,101,116,
  105,109,101,100,105,115,112,8,116,115,99,114,101,97,116,101,13,102,114,97,
  109,101,46,99,97,112,116,105,111,110,6,1,67,16,102,114,97,109,101,46,
  99,97,112,116,105,111,110,112,111,115,7,7,99,112,95,108,101,102,116,16,
  102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,16,102,
  114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,11,2,0,
  2,0,2,0,0,8,116,97,98,111,114,100,101,114,2,1,4,104,105,110,
  116,6,18,67,114,101,97,116,105,111,110,32,116,105,109,101,115,116,97,109,
  112,8,98,111,117,110,100,115,95,120,2,2,8,98,111,117,110,100,115,95,
  121,2,0,9,98,111,117,110,100,115,95,99,120,3,181,0,9,98,111,117,
  110,100,115,95,99,121,2,18,7,97,110,99,104,111,114,115,11,6,97,110,
  95,116,111,112,8,97,110,95,114,105,103,104,116,0,7,111,112,116,105,111,
  110,115,11,19,100,119,111,95,104,105,110,116,99,108,105,112,112,101,100,116,
  101,120,116,0,6,102,111,114,109,97,116,6,18,121,121,121,121,45,109,109,
  45,100,32,104,104,58,110,110,58,115,115,4,107,105,110,100,7,12,100,116,
  107,95,100,97,116,101,116,105,109,101,19,100,97,116,97,108,105,110,107,46,
  100,97,116,97,115,111,117,114,99,101,7,6,100,97,116,97,115,111,18,100,
  97,116,97,108,105,110,107,46,102,105,101,108,100,110,97,109,101,6,8,84,
  83,67,82,69,65,84,69,13,114,101,102,102,111,110,116,104,101,105,103,104,
  116,2,14,0,0,0,12,116,100,98,110,97,118,105,103,97,116,111,114,5,
  110,97,118,105,103,14,111,112,116,105,111,110,115,119,105,100,103,101,116,49,
  11,13,111,119,49,95,97,117,116,111,115,99,97,108,101,13,111,119,49,95,
  97,117,116,111,119,105,100,116,104,0,16,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,49,11,0,8,116,97,98,111,114,100,101,114,2,1,
  8,98,111,117,110,100,115,95,120,2,0,8,98,111,117,110,100,115,95,121,
  2,0,9,98,111,117,110,100,115,95,99,120,3,20,1,9,98,111,117,110,
  100,115,95,99,121,2,23,8,115,116,97,116,102,105,108,101,7,10,116,115,
  116,97,116,102,105,108,101,49,10,100,97,116,97,115,111,117,114,99,101,7,
  6,100,97,116,97,115,111,14,118,105,115,105,98,108,101,98,117,116,116,111,
  110,115,11,10,100,98,110,98,95,102,105,114,115,116,10,100,98,110,98,95,
  112,114,105,111,114,9,100,98,110,98,95,110,101,120,116,9,100,98,110,98,
  95,108,97,115,116,11,100,98,110,98,95,105,110,115,101,114,116,11,100,98,
  110,98,95,100,101,108,101,116,101,15,100,98,110,98,95,99,111,112,121,114,
  101,99,111,114,100,9,100,98,110,98,95,101,100,105,116,9,100,98,110,98,
  95,112,111,115,116,11,100,98,110,98,95,99,97,110,99,101,108,12,100,98,
  110,98,95,114,101,102,114,101,115,104,13,100,98,110,98,95,97,117,116,111,
  101,100,105,116,0,21,98,117,116,116,111,110,102,97,99,101,46,108,111,99,
  97,108,112,114,111,112,115,11,0,19,98,117,116,116,111,110,102,97,99,101,
  46,116,101,109,112,108,97,116,101,7,17,109,97,105,110,102,111,46,104,111,
  114,122,107,111,110,118,101,120,8,97,117,116,111,101,100,105,116,9,20,100,
  105,97,108,111,103,98,117,116,116,111,110,46,105,109,97,103,101,110,114,2,
  17,17,100,105,97,108,111,103,98,117,116,116,111,110,46,104,105,110,116,6,
  6,68,105,97,108,111,103,18,100,105,97,108,111,103,98,117,116,116,111,110,
  46,115,116,97,116,101,11,11,97,115,95,100,105,115,97,98,108,101,100,12,
  97,115,95,105,110,118,105,115,105,98,108,101,16,97,115,95,108,111,99,97,
  108,100,105,115,97,98,108,101,100,17,97,115,95,108,111,99,97,108,105,110,
  118,105,115,105,98,108,101,17,97,115,95,108,111,99,97,108,105,109,97,103,
  101,108,105,115,116,15,97,115,95,108,111,99,97,108,105,109,97,103,101,110,
  114,18,97,115,95,108,111,99,97,108,99,111,108,111,114,103,108,121,112,104,
  12,97,115,95,108,111,99,97,108,104,105,110,116,17,97,115,95,108,111,99,
  97,108,111,110,101,120,101,99,117,116,101,0,0,0,0,14,116,109,115,101,
  100,97,116,97,115,111,117,114,99,101,6,100,97,116,97,115,111,8,65,117,
  116,111,69,100,105,116,8,4,108,101,102,116,3,88,1,3,116,111,112,2,
  8,0,0,9,116,115,116,97,116,102,105,108,101,10,116,115,116,97,116,102,
  105,108,101,49,8,102,105,108,101,110,97,109,101,6,14,114,101,99,111,114,
  100,101,100,105,116,46,115,116,97,7,111,112,116,105,111,110,115,11,10,115,
  102,111,95,109,101,109,111,114,121,15,115,102,111,95,116,114,97,110,115,97,
  99,116,105,111,110,17,115,102,111,95,97,99,116,105,118,97,116,111,114,114,
  101,97,100,18,115,102,111,95,97,99,116,105,118,97,116,111,114,119,114,105,
  116,101,0,4,108,101,102,116,3,160,1,3,116,111,112,2,8,0,0,0)
 );

initialization
 registerobjectdata(@objdata,trecordeditfo,'');
end.