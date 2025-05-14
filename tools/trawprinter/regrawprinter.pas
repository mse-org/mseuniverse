unit regrawprinter;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

implementation
uses
 msedesignintf,rawprinter;

procedure register;
begin
 registercomponents('RAW Printer',[trawprinter]);
end;

initialization
 register;
end.
