unit popup_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,popup;

const
 objdata: record size: integer; data: array[0..584] of byte end =
      (size: 585; data: (
  84,80,70,48,8,116,112,111,112,117,112,102,111,7,112,111,112,117,112,102,
  111,5,99,111,108,111,114,4,12,0,0,144,12,102,114,97,109,101,46,108,
  101,118,101,108,111,2,1,16,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,10,102,114,108,95,108,101,118,101,108,111,0,17,102,114,
  97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,7,118,105,
  115,105,98,108,101,8,8,98,111,117,110,100,115,95,120,3,81,1,8,98,
  111,117,110,100,115,95,121,3,10,1,9,98,111,117,110,100,115,95,99,120,
  3,233,0,9,98,111,117,110,100,115,95,99,121,2,88,26,99,111,110,116,
  97,105,110,101,114,46,102,114,97,109,101,46,108,111,99,97,108,112,114,111,
  112,115,11,0,27,99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,49,11,0,16,99,111,110,116,97,
  105,110,101,114,46,98,111,117,110,100,115,1,2,1,2,1,3,231,0,2,
  86,0,13,111,112,116,105,111,110,115,119,105,110,100,111,119,11,8,119,111,
  95,112,111,112,117,112,0,18,111,110,97,112,112,108,105,99,97,116,105,111,
  110,101,118,101,110,116,7,13,97,112,112,108,105,99,97,116,105,111,110,101,
  118,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,
  109,115,101,102,111,114,109,0,7,116,115,108,105,100,101,114,8,116,115,108,
  105,100,101,114,49,5,99,111,108,111,114,4,5,0,0,144,16,102,114,97,
  109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,
  101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,8,98,111,117,110,
  100,115,95,120,2,16,8,98,111,117,110,100,115,95,121,2,16,5,118,97,
  108,117,101,2,0,0,0,11,116,115,116,114,105,110,103,101,100,105,116,12,
  116,115,116,114,105,110,103,101,100,105,116,49,16,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,49,11,0,8,116,97,98,111,114,100,101,114,
  2,1,8,98,111,117,110,100,115,95,120,2,16,8,98,111,117,110,100,115,
  95,121,2,48,9,98,111,117,110,100,115,95,99,120,3,201,0,13,111,110,
  100,97,116,97,101,110,116,101,114,101,100,7,13,100,97,116,97,101,110,116,
  101,114,101,100,101,118,13,114,101,102,102,111,110,116,104,101,105,103,104,116,
  2,14,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tpopupfo,'');
end.