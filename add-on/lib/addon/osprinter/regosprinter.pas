unit regosprinter;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface

implementation
uses
 msedesignintf,osprinters,psprinter,regosprinter_bmp;

procedure register;
begin
 registercomponents('Repaz Tools',[TOSPrinter,TPSPrinter]);
 registercomponenttabhints(['Tools for Repaz and Others'],['Printer component for Windows and Linux',
   'Printer component for PostScript output file']);
end;


initialization
 register;
end.
