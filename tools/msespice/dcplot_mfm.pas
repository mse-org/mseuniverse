unit dcplot_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,dcplot;

const
 objdata: record size: integer; data: array[0..93] of byte end =
      (size: 94; data: (
  84,80,70,48,241,9,116,100,99,112,108,111,116,102,111,8,100,99,112,108,
  111,116,102,111,8,98,111,117,110,100,115,95,120,2,109,8,98,111,117,110,
  100,115,95,121,3,238,0,9,98,111,117,110,100,115,95,99,120,3,206,0,
  15,109,111,100,117,108,101,99,108,97,115,115,110,97,109,101,6,14,116,112,
  108,111,116,111,112,116,105,111,110,115,102,111,0,0)
 );

initialization
 registerobjectdata(@objdata,tdcplotfo,'');
end.
