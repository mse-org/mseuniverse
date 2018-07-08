unit regmycomps;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 msedesignintf,dbgroup;
 
procedure register;
begin
 registercomponents('DbPanel',[tdbgroup]);
end;

initialization
 register;
end.
