unit repaztypes;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses msegraphutils,msegraphics,msestrings,variants,mseformatstr,sysutils;

type
 linestylety = (ls_Solid,ls_Dash,ls_Dot,ls_Dash_Dot,ls_Dash_Dot_Dot);
 borderty = record
  linewidth: real;
  linecolor: colorty;
  capstyle: capstylety;
  linestyle: linestylety;
 end;
 chartlinety = record
  linewidth: real;
  linecolor: colorty;
  capstyle: capstylety;
  linestyle: linestylety;
  joinstyle: joinstylety;
 end;
 halignmentty = (ha_Left,ha_Right,ha_Center);
 valignmentty = (va_Top,va_Center,va_Bottom);
 textellipsety = (el_None,el_Left,el_Right);
 textoptionty = (to_WordBreak,to_SoftHyphen,to_ConvertTabtoSpace,to_Vertical,to_Flip);
 textoptionsty = set of textoptionty;
 pagesizety = (Letter,Folio,Ledger,Legal,Tabloid,A0,
 A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,
 C5E,Comm10E,DLE,Executive,Custom);

 pagety = record
  name: string;
  width,height: real //mm
 end;
 
const
 pagesizes: array[pagesizety] of pagety = (
  (name: 'Letter';    width:   215.9; height:  279.4),
  (name: 'Folio';     width:   215.9; height:  330.2),
  (name: 'Ledger';    width:   279.4; height:  431.8),
  (name: 'Legal';     width:   215.9; height:  355.6),
  (name: 'Tabloid';   width:   279.4; height:  431.8),
  (name: 'A0';        width:   841;   height: 1189),
  (name: 'A1';        width:   594;   height:  841),
  (name: 'A2';        width:   420;   height:  594),
  (name: 'A3';        width:   297;   height:  420),
  (name: 'A4';        width:   210;   height:  297),
  (name: 'A5';        width:   148;   height:  210),
  (name: 'A6';        width:   105;   height:  148),
  (name: 'A7';        width:    74;   height:  105),
  (name: 'A8';        width:    52;   height:   74),
  (name: 'A9';        width:    37;   height:   52),
  (name: 'B0';        width:  1030;   height: 1456),
  (name: 'B1';        width:   728;   height: 1030),
  (name: 'B2';        width:   515;   height:  728),
  (name: 'B3';        width:   364;   height:  515),
  (name: 'B4';        width:   257;   height:  364),
  (name: 'B5';        width:   182;   height:  257),
  (name: 'B6';        width:   128;   height:  182),
  (name: 'B7';        width:    91;   height:  128),
  (name: 'B8';        width:    64;   height:   91),
  (name: 'B9';        width:    45;   height:   64),
  (name: 'B10';       width:    32;   height:   45),
  (name: 'C5E';       width:   163;   height:  229),
  (name: 'Comm10E';   width:   105;   height:  241),
  (name: 'DLE';       width:   110;   height:  220),
  (name: 'Executive'; width:   191;   height:  254),
  (name: 'Custom';    width:     0;   height:    0)
  );

 linestyles: array[linestylety] of string = (
  '',#6#3#3#0,#1#3#1#0,#6#3#1#3#3#0,#6#3#1#3#1#3#3#0);

 function vartoformattedtext(const avalue:variant; const aformat:string): msestring;

implementation

function vartoformattedtext(const avalue:variant; const aformat:string): msestring;
begin
 if aformat='' then begin
  case vartype(avalue) of
   varempty,varnull,varerror : result:= '';
   else result:= avalue;
  end;
 end else begin
  case vartype(avalue) of
   varempty,varnull,varerror : 
    result:= '';
   varsmallint,varinteger,varshortint,varbyte,varword,varlongword,
   varint64,varqword :
    result:= formatfloatmse(avalue,aformat);
   varsingle,vardouble,varcurrency,varvariant,vardecimal:
    result:= formatfloatmse(avalue,aformat);
   varboolean:
    result:= formatfloatmse(ord(boolean(avalue)),aformat);       
   vardate:
    result:= formatdatetime(aformat,avalue);
   else
    result:= aformat + avalue;
  end
 end;
end;


end.
