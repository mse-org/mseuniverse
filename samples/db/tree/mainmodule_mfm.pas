unit mainmodule_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,mainmodule;

const
 objdata: record size: integer; data: array[0..1283] of byte end =
      (size: 1284; data: (
  84,80,70,48,7,116,109,97,105,110,109,111,6,109,97,105,110,109,111,9,
  98,111,117,110,100,115,95,99,120,3,23,1,9,98,111,117,110,100,115,95,
  99,121,3,220,0,8,111,110,108,111,97,100,101,100,7,8,108,111,97,100,
  101,100,101,118,4,108,101,102,116,3,183,1,3,116,111,112,3,169,0,15,
  109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,14,116,109,115,
  101,100,97,116,97,109,111,100,117,108,101,0,14,116,109,115,101,100,97,116,
  97,115,111,117,114,99,101,3,100,115,111,7,68,97,116,97,83,101,116,7,
  2,100,115,4,108,101,102,116,2,8,3,116,111,112,2,24,0,0,13,116,
  108,111,99,97,108,100,97,116,97,115,101,116,2,100,115,7,111,112,116,105,
  111,110,115,11,9,98,100,111,95,108,111,99,97,108,0,11,108,111,103,102,
  105,108,101,110,97,109,101,6,7,116,101,115,116,46,100,98,16,105,110,100,
  101,120,108,111,99,97,108,46,99,111,117,110,116,2,2,16,105,110,100,101,
  120,108,111,99,97,108,46,105,116,101,109,115,14,1,12,102,105,101,108,100,
  115,46,105,116,101,109,115,14,1,9,102,105,101,108,100,110,97,109,101,6,
  2,105,100,0,0,6,97,99,116,105,118,101,9,0,1,12,102,105,101,108,
  100,115,46,99,111,117,110,116,2,2,12,102,105,101,108,100,115,46,105,116,
  101,109,115,14,1,9,102,105,101,108,100,110,97,109,101,6,8,112,97,114,
  101,110,116,105,100,0,1,9,102,105,101,108,100,110,97,109,101,6,5,111,
  114,100,101,114,0,0,0,0,9,70,105,101,108,100,68,101,102,115,14,1,
  4,78,97,109,101,6,2,105,100,8,68,97,116,97,84,121,112,101,7,9,
  102,116,73,110,116,101,103,101,114,0,1,4,78,97,109,101,6,8,112,97,
  114,101,110,116,105,100,8,68,97,116,97,84,121,112,101,7,9,102,116,73,
  110,116,101,103,101,114,0,1,4,78,97,109,101,6,7,99,97,112,116,105,
  111,110,8,68,97,116,97,84,121,112,101,7,8,102,116,83,116,114,105,110,
  103,0,1,4,78,97,109,101,6,5,111,114,100,101,114,8,68,97,116,97,
  84,121,112,101,7,9,102,116,73,110,116,101,103,101,114,0,1,4,78,97,
  109,101,6,6,105,110,116,118,97,108,8,68,97,116,97,84,121,112,101,7,
  9,102,116,73,110,116,101,103,101,114,0,1,4,78,97,109,101,6,8,102,
  108,111,97,116,118,97,108,8,68,97,116,97,84,121,112,101,7,7,102,116,
  70,108,111,97,116,0,0,10,66,101,102,111,114,101,80,111,115,116,7,12,
  98,101,102,111,114,101,112,111,115,116,101,118,4,108,101,102,116,2,8,3,
  116,111,112,2,8,16,115,116,114,101,97,109,105,110,103,118,101,114,115,105,
  111,110,2,1,0,16,116,109,115,101,108,111,110,103,105,110,116,102,105,101,
  108,100,2,105,100,9,70,105,101,108,100,78,97,109,101,6,2,105,100,5,
  73,110,100,101,120,2,0,4,108,101,102,116,2,16,3,116,111,112,2,40,
  0,0,15,116,109,115,101,115,116,114,105,110,103,102,105,101,108,100,7,99,
  97,112,116,105,111,110,12,68,105,115,112,108,97,121,87,105,100,116,104,2,
  20,9,70,105,101,108,100,78,97,109,101,6,7,99,97,112,116,105,111,110,
  5,73,110,100,101,120,2,1,4,83,105,122,101,2,0,4,108,101,102,116,
  2,16,3,116,111,112,2,88,0,0,16,116,109,115,101,108,111,110,103,105,
  110,116,102,105,101,108,100,8,112,97,114,101,110,116,105,100,9,70,105,101,
  108,100,78,97,109,101,6,8,112,97,114,101,110,116,105,100,5,73,110,100,
  101,120,2,2,4,108,101,102,116,2,16,3,116,111,112,2,56,0,0,16,
  116,109,115,101,108,111,110,103,105,110,116,102,105,101,108,100,5,111,114,100,
  101,114,9,70,105,101,108,100,78,97,109,101,6,5,111,114,100,101,114,5,
  73,110,100,101,120,2,3,4,108,101,102,116,2,16,3,116,111,112,2,72,
  0,0,14,116,109,115,101,102,108,111,97,116,102,105,101,108,100,8,102,108,
  111,97,116,118,97,108,9,70,105,101,108,100,78,97,109,101,6,8,102,108,
  111,97,116,118,97,108,5,73,110,100,101,120,2,4,8,77,97,120,86,97,
  108,117,101,2,0,8,77,105,110,86,97,108,117,101,2,0,4,108,101,102,
  116,2,16,3,116,111,112,2,120,0,0,16,116,109,115,101,108,111,110,103,
  105,110,116,102,105,101,108,100,6,105,110,116,118,97,108,9,70,105,101,108,
  100,78,97,109,101,6,6,105,110,116,118,97,108,5,73,110,100,101,120,2,
  5,4,108,101,102,116,2,16,3,116,111,112,2,104,0,0,0,16,116,105,
  102,105,103,114,105,100,108,105,110,107,99,111,109,112,8,103,114,105,100,108,
  105,110,107,26,99,111,110,116,114,111,108,108,101,114,46,111,110,114,111,119,
  115,105,110,115,101,114,116,105,110,103,7,11,105,110,115,101,114,116,105,110,
  103,101,118,25,99,111,110,116,114,111,108,108,101,114,46,111,110,114,111,119,
  115,100,101,108,101,116,105,110,103,7,10,100,101,108,101,116,105,110,103,101,
  118,4,108,101,102,116,2,96,3,116,111,112,2,16,0,0,20,116,105,102,
  105,116,114,101,101,105,116,101,109,108,105,110,107,99,111,109,112,8,116,114,
  101,101,108,105,110,107,30,99,111,110,116,114,111,108,108,101,114,46,111,110,
  99,108,105,101,110,116,100,97,116,97,101,110,116,101,114,101,100,7,8,100,
  97,116,101,110,116,101,118,4,108,101,102,116,3,192,0,3,116,111,112,2,
  16,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmainmo,'');
end.