unit GuiMDIChild_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 mseclasses,GuiMDIChild;

const
 objdata: record size: integer; data: array[0..1566] of byte end =
      (size: 1567; data: (
  84,80,70,48,14,84,71,117,105,77,68,73,67,104,105,108,100,102,111,13,
  71,117,105,77,68,73,67,104,105,108,100,70,111,13,111,112,116,105,111,110,
  115,119,105,100,103,101,116,11,13,111,119,95,97,114,114,111,119,102,111,99,
  117,115,11,111,119,95,115,117,98,102,111,99,117,115,17,111,119,95,100,101,
  115,116,114,111,121,119,105,100,103,101,116,115,9,111,119,95,104,105,110,116,
  111,110,12,111,119,95,97,117,116,111,115,99,97,108,101,0,8,98,111,117,
  110,100,115,95,120,3,232,0,8,98,111,117,110,100,115,95,121,3,255,0,
  9,98,111,117,110,100,115,95,99,120,3,1,1,9,98,111,117,110,100,115,
  95,99,121,3,194,0,5,99,111,108,111,114,4,11,0,0,144,12,102,114,
  97,109,101,46,108,101,118,101,108,111,2,1,19,102,114,97,109,101,46,99,
  111,108,111,114,100,107,115,104,97,100,111,119,4,0,0,0,144,17,102,114,
  97,109,101,46,99,111,108,111,114,115,104,97,100,111,119,4,1,0,0,144,
  16,102,114,97,109,101,46,99,111,108,111,114,108,105,103,104,116,4,3,0,
  0,144,20,102,114,97,109,101,46,99,111,108,111,114,104,105,103,104,108,105,
  103,104,116,4,4,0,0,144,17,102,114,97,109,101,46,102,114,97,109,101,
  105,95,108,101,102,116,2,1,16,102,114,97,109,101,46,102,114,97,109,101,
  105,95,116,111,112,2,1,18,102,114,97,109,101,46,102,114,97,109,101,105,
  95,114,105,103,104,116,2,1,19,102,114,97,109,101,46,102,114,97,109,101,
  105,95,98,111,116,116,111,109,2,1,17,102,114,97,109,101,46,99,97,112,
  116,105,111,110,100,105,115,116,2,254,19,102,114,97,109,101,46,99,97,112,
  116,105,111,110,111,102,102,115,101,116,2,3,16,102,114,97,109,101,46,102,
  111,110,116,46,99,111,108,111,114,4,10,0,0,144,15,102,114,97,109,101,
  46,102,111,110,116,46,110,97,109,101,6,11,115,116,102,95,100,101,102,97,
  117,108,116,16,102,114,97,109,101,46,102,111,110,116,46,100,117,109,109,121,
  2,0,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,
  10,102,114,108,95,108,101,118,101,108,111,14,102,114,108,95,102,114,97,109,
  101,119,105,100,116,104,14,102,114,108,95,99,111,108,111,114,102,114,97,109,
  101,17,102,114,108,95,99,111,108,111,114,100,107,115,104,97,100,111,119,15,
  102,114,108,95,99,111,108,111,114,115,104,97,100,111,119,14,102,114,108,95,
  99,111,108,111,114,108,105,103,104,116,18,102,114,108,95,99,111,108,111,114,
  104,105,103,104,108,105,103,104,116,11,102,114,108,95,102,105,114,105,103,104,
  116,15,102,114,108,95,99,111,108,111,114,99,108,105,101,110,116,0,15,102,
  114,97,109,101,46,103,114,105,112,95,115,105,122,101,2,14,15,102,114,97,
  109,101,46,103,114,105,112,95,103,114,105,112,7,9,115,116,98,95,100,101,
  110,115,48,16,102,114,97,109,101,46,103,114,105,112,95,99,111,108,111,114,
  4,3,0,0,128,22,102,114,97,109,101,46,103,114,105,112,95,99,111,108,
  111,114,97,99,116,105,118,101,4,3,0,0,128,22,102,114,97,109,101,46,
  103,114,105,112,95,99,111,108,111,114,98,117,116,116,111,110,4,5,0,0,
  144,28,102,114,97,109,101,46,103,114,105,112,95,99,111,108,111,114,98,117,
  116,116,111,110,97,99,116,105,118,101,4,5,0,0,144,18,102,114,97,109,
  101,46,103,114,105,112,95,111,112,116,105,111,110,115,11,14,103,111,95,99,
  108,111,115,101,98,117,116,116,111,110,17,103,111,95,109,105,110,105,109,105,
  122,101,98,117,116,116,111,110,18,103,111,95,110,111,114,109,97,108,105,122,
  101,98,117,116,116,111,110,17,103,111,95,109,97,120,105,109,105,122,101,98,
  117,116,116,111,110,7,103,111,95,104,111,114,122,19,103,111,95,115,104,111,
  119,115,112,108,105,116,99,97,112,116,105,111,110,0,11,102,114,97,109,101,
  46,100,117,109,109,121,2,0,8,116,97,98,111,114,100,101,114,2,1,7,
  118,105,115,105,98,108,101,8,23,99,111,110,116,97,105,110,101,114,46,111,
  112,116,105,111,110,115,119,105,100,103,101,116,11,13,111,119,95,109,111,117,
  115,101,102,111,99,117,115,11,111,119,95,116,97,98,102,111,99,117,115,13,
  111,119,95,97,114,114,111,119,102,111,99,117,115,11,111,119,95,115,117,98,
  102,111,99,117,115,19,111,119,95,109,111,117,115,101,116,114,97,110,115,112,
  97,114,101,110,116,17,111,119,95,100,101,115,116,114,111,121,119,105,100,103,
  101,116,115,12,111,119,95,97,117,116,111,115,99,97,108,101,0,18,99,111,
  110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,120,2,2,18,99,
  111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,121,2,16,19,
  99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,99,120,3,
  253,0,19,99,111,110,116,97,105,110,101,114,46,98,111,117,110,100,115,95,
  99,121,3,176,0,15,99,111,110,116,97,105,110,101,114,46,99,111,108,111,
  114,4,5,0,0,144,21,99,111,110,116,97,105,110,101,114,46,102,114,97,
  109,101,46,100,117,109,109,121,2,0,16,100,114,97,103,100,111,99,107,46,
  99,97,112,116,105,111,110,6,14,77,68,73,32,99,104,105,108,100,32,102,
  111,114,109,20,100,114,97,103,100,111,99,107,46,111,112,116,105,111,110,115,
  100,111,99,107,11,10,111,100,95,115,97,118,101,112,111,115,10,111,100,95,
  99,97,110,109,111,118,101,10,111,100,95,99,97,110,115,105,122,101,10,111,
  100,95,99,97,110,100,111,99,107,0,9,102,111,110,116,46,110,97,109,101,
  6,11,115,116,102,95,100,101,102,97,117,108,116,10,102,111,110,116,46,100,
  117,109,109,121,2,0,7,111,112,116,105,111,110,115,11,14,102,111,95,102,
  114,101,101,111,110,99,108,111,115,101,13,102,111,95,100,101,102,97,117,108,
  116,112,111,115,15,102,111,95,97,117,116,111,114,101,97,100,115,116,97,116,
  16,102,111,95,97,117,116,111,119,114,105,116,101,115,116,97,116,10,102,111,
  95,115,97,118,101,112,111,115,12,102,111,95,115,97,118,101,115,116,97,116,
  101,0,17,105,99,111,110,46,116,114,97,110,115,112,97,114,101,110,99,121,
  4,0,0,0,128,15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,
  101,6,9,116,100,111,99,107,102,111,114,109,0,7,116,97,99,116,105,111,
  110,14,65,99,116,105,111,110,65,99,116,105,118,97,116,101,9,111,110,101,
  120,101,99,117,116,101,7,23,79,110,69,120,101,99,117,116,101,65,99,116,
  105,111,110,65,99,116,105,118,97,116,101,4,108,101,102,116,2,96,3,116,
  111,112,2,32,0,0,0)
 );

initialization
 registerobjectdata(@objdata,TGuiMDIChildfo,'');
end.