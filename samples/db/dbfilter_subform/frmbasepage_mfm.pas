unit frmbasepage_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,frmbasepage;

const
 objdata: record size: integer; data: array[0..147] of byte end =
      (size: 148; data: (
  84,80,70,48,14,116,102,114,109,98,97,115,101,80,97,103,101,102,111,13,
  102,114,109,98,97,115,101,80,97,103,101,102,111,16,102,114,97,109,101,46,
  108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,49,11,0,8,98,111,117,110,100,115,95,
  120,2,0,8,98,111,117,110,100,115,95,121,2,0,9,98,111,117,110,100,
  115,95,99,120,3,96,1,9,98,111,117,110,100,115,95,99,121,3,23,1,
  15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,8,116,115,
  117,98,102,111,114,109,0,0)
 );

initialization
 registerobjectdata(@objdata,tfrmbasePagefo,'');
end.
