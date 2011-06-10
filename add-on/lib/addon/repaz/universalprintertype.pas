{*********************************************************}
{           Copyright by : Sri Wahono '2008               }
{             Included package with Repaz                 }
{*********************************************************}
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{              http://www.msegui.org/osprinter            }
{                                                         }
{*********************************************************}
unit universalprintertype;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
{$IFDEF WINDOWS}
 uses windows;
{$ENDIF}
const
 // esc command index
 esc_max           = 26;
 esc_init          = 0;
 esc_normal        = 1;
 esc_courier       = 2;
 esc_roman         = 3;
 esc_condensed     = 4;
 esc_expanded      = 5;
 esc_doubleheight       = 6;
 esc_not_doubleheight   = 7;
 esc_bold          = 8;
 esc_not_bold      = 9;
 esc_italic        = 10;
 esc_not_italic    = 11;
 esc_underline     = 12;
 esc_not_underline = 13;
 esc_strike        = 14;
 esc_not_strike    = 15;
 esc_sub           = 16;
 esc_not_sub       = 17;
 esc_super         = 18;
 esc_not_super     = 19;
 esc_open_drawer   = 20;
 esc_cut_paper     = 21;
 esc_form_feed     = 22;
 esc_line_feed     = 23;
 esc_left_margin   = 24;
 esc_paper_width   = 25;
 esc_linesperpage  = 26;

type
 trawprintercommand = (rpcEpson,rpcEpsonTMSeries,rpcIBM,rpcStarSPSeries);
 rawfontty = (rfNormal,rfCourier,rfRoman,rfCondensed,rfExpanded,rfDoubleHeight); 
 pageorientationty = (pao_portrait,pao_landscape);
 esclistty = array[0..esc_max] of string;
 draweractionty = (cdaNotOpen,cdaOpenBefore,cdaOpenAfter);
 drawermodety = (cdmPrinter,cdmSerial);
 stdpagety = record
  paperindex: integer;
  name: string;
  width,height: real //mm
 end;
 stdpagearty = array of stdpagety;

 printerty = record
  printername: string;
  drivername: string;
  location: string;
  port: string;
  description: string;
  isdefault: boolean;
  servername: string;
  sharename: string;
 end;
 printerarty = array of printerty;

 pageskindty = (pk_all,pk_even,pk_odd);
 
 pagerangety = record
  first,last: integer;
 end;
 pagerangearty = array of pagerangety;

implementation
end.
