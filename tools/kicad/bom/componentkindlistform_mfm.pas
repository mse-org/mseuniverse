unit componentkindlistform_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,componentkindlistform;

const
 objdata: record size: integer; data: array[0..1068] of byte end =
      (size: 1069; data: (
  84,80,70,48,241,20,116,99,111,109,112,111,110,101,110,116,107,105,110,100,
  108,105,115,116,102,111,19,99,111,109,112,111,110,101,110,116,107,105,110,100,
  108,105,115,116,102,111,16,99,111,110,116,97,105,110,101,114,46,98,111,117,
  110,100,115,1,2,0,2,0,3,46,2,3,137,1,0,7,99,97,112,116,
  105,111,110,6,14,67,111,109,112,111,110,101,110,116,107,105,110,100,115,7,
  111,110,99,108,111,115,101,7,7,99,108,111,115,101,101,118,15,109,111,100,
  117,108,101,99,108,97,115,115,110,97,109,101,6,11,116,108,105,115,116,101,
  100,105,116,102,111,0,241,12,116,100,98,110,97,118,105,103,97,116,111,114,
  5,110,97,118,105,103,0,0,241,13,116,100,98,119,105,100,103,101,116,103,
  114,105,100,4,103,114,105,100,13,102,105,120,99,111,108,115,46,105,116,101,
  109,115,14,1,0,0,13,102,105,120,114,111,119,115,46,105,116,101,109,115,
  14,1,14,99,97,112,116,105,111,110,115,46,99,111,117,110,116,2,4,14,
  99,97,112,116,105,111,110,115,46,105,116,101,109,115,14,1,0,1,7,99,
  97,112,116,105,111,110,6,11,68,101,115,105,103,110,97,116,105,111,110,0,
  1,7,99,97,112,116,105,111,110,6,7,67,114,101,97,116,101,100,0,1,
  7,99,97,112,116,105,111,110,6,8,77,111,100,105,102,105,101,100,0,0,
  0,0,14,100,97,116,97,99,111,108,115,46,99,111,117,110,116,2,4,17,
  100,97,116,97,99,111,108,115,46,99,111,108,111,114,100,101,114,1,6,6,
  110,97,109,101,101,100,6,14,116,100,98,115,116,114,105,110,103,101,100,105,
  116,49,6,10,116,100,99,114,101,97,116,101,101,100,6,10,116,100,109,111,
  100,105,102,121,101,100,0,14,100,97,116,97,99,111,108,115,46,105,116,101,
  109,115,14,7,6,110,97,109,101,101,100,1,0,7,14,116,100,98,115,116,
  114,105,110,103,101,100,105,116,49,1,5,119,105,100,116,104,3,143,0,10,
  119,105,100,103,101,116,110,97,109,101,6,14,116,100,98,115,116,114,105,110,
  103,101,100,105,116,49,0,7,10,116,100,99,114,101,97,116,101,101,100,1,
  0,7,10,116,100,109,111,100,105,102,121,101,100,1,0,0,0,243,2,0,
  15,116,100,98,100,97,116,101,116,105,109,101,101,100,105,116,10,116,100,99,
  114,101,97,116,101,101,100,8,98,111,117,110,100,115,95,120,3,249,0,0,
  0,243,2,1,13,116,100,98,115,116,114,105,110,103,101,100,105,116,6,110,
  97,109,101,101,100,0,0,242,2,2,13,116,100,98,115,116,114,105,110,103,
  101,100,105,116,14,116,100,98,115,116,114,105,110,103,101,100,105,116,49,14,
  111,112,116,105,111,110,115,119,105,100,103,101,116,49,11,19,111,119,49,95,
  102,111,110,116,103,108,121,112,104,104,101,105,103,104,116,0,11,111,112,116,
  105,111,110,115,115,107,105,110,11,19,111,115,107,95,102,114,97,109,101,98,
  117,116,116,111,110,111,110,108,121,0,8,116,97,98,111,114,100,101,114,2,
  4,7,118,105,115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,2,
  105,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,115,95,
  99,120,3,143,0,9,98,111,117,110,100,115,95,99,121,2,16,19,100,97,
  116,97,108,105,110,107,46,100,97,116,97,115,111,117,114,99,101,7,6,100,
  97,116,97,115,111,18,100,97,116,97,108,105,110,107,46,110,97,118,105,103,
  97,116,111,114,7,16,108,105,115,116,101,100,105,116,102,111,46,110,97,118,
  105,103,18,100,97,116,97,108,105,110,107,46,102,105,101,108,100,110,97,109,
  101,6,11,68,69,83,73,71,78,65,84,73,79,78,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,14,0,0,243,2,3,15,116,100,98,100,
  97,116,101,116,105,109,101,101,100,105,116,10,116,100,109,111,100,105,102,121,
  101,100,8,98,111,117,110,100,115,95,120,3,109,1,0,0,0,241,9,116,
  115,116,97,116,102,105,108,101,10,116,115,116,97,116,102,105,108,101,49,8,
  102,105,108,101,110,97,109,101,6,23,99,111,109,112,111,110,101,110,116,107,
  105,110,100,108,105,115,116,102,111,46,115,116,97,0,0,241,14,116,109,115,
  101,100,97,116,97,115,111,117,114,99,101,6,100,97,116,97,115,111,7,68,
  97,116,97,83,101,116,7,17,109,97,105,110,109,111,46,99,111,109,112,107,
  105,110,100,113,117,0,0,241,7,116,97,99,116,105,111,110,9,100,105,97,
  108,111,103,97,99,116,9,111,110,101,120,101,99,117,116,101,7,8,100,105,
  97,108,111,103,101,118,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tcomponentkindlistfo,'');
end.