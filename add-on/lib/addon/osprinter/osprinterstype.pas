{ MSEgui Copyright (c) 2007-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
{*********************************************************}
{ Original file is mseprinter.pas, msegdiprint.pas, and   }
{ msepostscriptprinter.pas                                }
{            Modified by : Sri Wahono '2008               }
{             Included package with Repaz                 }
{*********************************************************}
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{              http://www.msegui.org/osprinter            }
{                                                         }
{*********************************************************}
unit osprinterstype;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
type
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
