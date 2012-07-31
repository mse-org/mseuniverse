unit regazskin;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface

implementation
uses
 msedesignintf,azskin;

procedure register;
begin
 registercomponents('AzSkin',[tazskin]);
end;


initialization
 register;
end.
