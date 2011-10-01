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
unit gdiapi;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses windows,sysutils,msesysintf1,msesys,msedynload;

type
 winbool = longbool;
 docinfow = record
  cbsize: longint;
  lpszdocname: lpcwstr;
  lpszoutput: lpcwstr;
  lpszdatatype: lpcwstr;
  fwtype: dword;
 end;
 tdocinfow = docinfow;
 pdocinfow = ^docinfow;

 TDocInfo1 = record
   pDocName: PAnsiChar;
   pOutputFile: PAnsiChar;
   pDatatype: PAnsiChar;
 end;

 PPrinterDefaultsA = ^TPrinterDefaultsA;
 TPrinterDefaultsA = record
   pDatatype: PAnsiChar;
   pDevMode: PDeviceModeA;
   DesiredAccess: ACCESS_MASK;
 end;
  
 printer_info_2 = packed record
  pservername: pchar;
  pprintername: pchar;
  psharename: pchar;
  pportname: pchar;
  pdrivername: pchar;
  pcomment: pchar;
  plocation: pchar;
  pdevmode: pdevicemode;
  psepfile: pchar;
  pprintprocessor: pchar;
  pdatatype: pchar;
  pparameters: pchar;
  psecuritydescriptor: pointer;
  attributes: dword;
  priority: dword;
  defaultpriority: dword;
  starttime: dword;
  untiltime: dword;
  status: dword;
  cjobs: dword;
  averageppm: dword; 
 end;
 
 pprinter_info_2 = ^printer_info_2;
 
 printer_info_4 = packed record
  pprintername: pchar; 
  pservername: pchar;
  attributes: dword; 
 end;

 pprinter_info_4 = ^printer_info_4;

 printer_info_5 = packed record
  pprintername: pchar;
  pportname: pchar;
  attributes: dword;
  devicenotselectedtimeout: dword;
  transmissionretrytimeout: dword;
 end;

 pprinter_info_5 = ^printer_info_5;          


var     

 setworldtransform: function(_para1:hdc; var _para2:xform):winbool; stdcall;
 startdocw: function(_para1:hdc; _para2:pdocinfow):longint; stdcall;
 getdefaultprintera: function(pszbuffer: pchar;pcchbuffer: pdword): boolean; stdcall;
 enumprinters: function(flags: dword; name: pchar; level: dword;
  pprinterenum: pointer; cbbuf: dword; var pcbneeded, pcreturned: dword): boolean; stdcall;
 devicecapabilities: function (pdevice, pport: pchar; fwcapability: word;
  poutput: pchar; devmode: pdevicemodew): integer; stdcall;
 writeprinter: function (hPrinter: THandle; pBuf: Pointer; cbBuf: DWORD; var pcWritten: DWORD): boolean; stdcall;
 openprinter: function (pPrinterName: PAnsiChar; var phPrinter: THandle; pDefault: PPrinterDefaultsA): boolean; stdcall;
 closeprinter: function (hPrinter: THandle): boolean; stdcall;
 startdocprinter: function (hPrinter: THandle; Level: DWORD; pDocInfo: Pointer): DWORD; stdcall;
 StartPagePrinter: function (hPrinter:THANDLE):DWORD; stdcall;
 EndPagePrinter: function (hprinter:THANDLE):BOOL; stdcall;
 DocumentProperties: function (
      hWnd          :HWND;        // handle to parent window
      hPrinter      :THandle;     // handle to printer object
      pDeviceName   :Pchar;       // device name
      pDevModeOutput:PdeviceMode; // modified device mode
      pDevModeInput :PdeviceMode; // original device mode
      fMode         :DWORD        // mode options
      ): Longint; stdcall;

function initgdiprint: boolean;

implementation

function initgdiprint: boolean;
var
 haserror: boolean;
begin
 haserror:= false;
 if not iswin95 then begin
  try
   getprocaddresses(getmodulehandle('gdi32'),[
    'SetWorldTransform',                        //0
    'StartDocW'                                 //1
    ],
    [
    {$ifndef FPC}@{$endif}@SetWorldTransform,     //0
    {$ifndef FPC}@{$endif}@StartDocW              //1
    ]);
  except
   haserror:= true;
  end;
 end;
 if not haserror then begin
  try
   getprocaddresses(['WINSPOOL.DRV'],[
   'GetDefaultPrinterA',
   'EnumPrintersA',
   'DeviceCapabilitiesA',
   'WritePrinter',
   'OpenPrinterA',
   'ClosePrinter',
   'StartDocPrinterA',
   'StartPagePrinter',
   'EndPagePrinter',
   'DocumentPropertiesA'
   ],[
   {$ifndef FPC}@{$endif}@GetDefaultPrinterA,
   {$ifndef FPC}@{$endif}@EnumPrinters,
   {$ifndef FPC}@{$endif}@DeviceCapabilities,
   {$ifndef FPC}@{$endif}@writeprinter,
   {$ifndef FPC}@{$endif}@openprinter,
   {$ifndef FPC}@{$endif}@closeprinter,
   {$ifndef FPC}@{$endif}@startdocprinter,
   {$ifndef FPC}@{$endif}@startpageprinter,
   {$ifndef FPC}@{$endif}@endpageprinter,
   {$ifndef FPC}@{$endif}@DocumentProperties
   ]);
  except
   haserror:= true;
  end;
 end else begin
  haserror:= true;
 end;
 result:= not haserror;
end;

end.
