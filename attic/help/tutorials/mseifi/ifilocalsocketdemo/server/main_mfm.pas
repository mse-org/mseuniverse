unit main_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,main;

const
 objdata: record size: integer; data: array[0..437] of byte end =
      (size: 438; data: (
  84,80,70,48,7,116,109,97,105,110,109,111,6,109,97,105,110,109,111,9,
  98,111,117,110,100,115,95,99,120,3,214,0,9,98,111,117,110,100,115,95,
  99,121,2,92,4,108,101,102,116,3,148,0,3,116,111,112,3,75,1,15,
  109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,14,116,109,115,
  101,100,97,116,97,109,111,100,117,108,101,0,13,116,115,111,99,107,101,116,
  115,101,114,118,101,114,14,116,115,111,99,107,101,116,115,101,114,118,101,114,
  49,8,111,110,97,99,99,101,112,116,7,9,97,99,99,101,112,116,101,120,
  101,16,111,110,97,102,116,101,114,99,104,99,111,110,110,101,99,116,7,9,
  99,104,99,111,110,110,101,99,116,19,111,110,97,102,116,101,114,99,104,100,
  105,115,99,111,110,110,101,99,116,7,15,99,104,100,105,115,99,111,110,110,
  101,99,116,101,120,101,6,97,99,116,105,118,101,9,8,99,114,121,112,116,
  111,105,111,7,3,115,115,108,3,117,114,108,6,12,46,46,47,105,102,105,
  115,111,99,107,101,116,3,116,111,112,2,8,0,0,11,116,116,104,114,101,
  97,100,99,111,109,112,13,99,111,109,109,97,110,100,116,104,114,101,97,100,
  6,97,99,116,105,118,101,9,9,111,110,101,120,101,99,117,116,101,7,16,
  99,111,109,109,97,110,100,116,104,114,101,97,100,101,120,101,4,108,101,102,
  116,2,8,3,116,111,112,2,32,0,0,4,116,115,115,108,3,115,115,108,
  18,99,105,112,104,101,114,108,105,115,116,46,83,116,114,105,110,103,115,1,
  6,7,68,69,70,65,85,76,84,0,8,99,101,114,116,102,105,108,101,6,
  13,46,46,47,99,97,99,101,114,116,46,112,101,109,11,112,114,105,118,107,
  101,121,102,105,108,101,6,14,46,46,47,112,114,105,118,107,101,121,46,112,
  101,109,4,108,101,102,116,2,112,3,116,111,112,2,8,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmainmo,'');
end.